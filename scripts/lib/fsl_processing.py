import os
import time
import sys
from subprocess import check_call
import glob
import re
import string
import shutil
import stat
from nilearn import image
import numpy as np
import nibabel as nib


def copy_and_BET(raw_dir, preproc_dir, *args):
    """
    Copy to raw data (anatomical and functional) from 'raw_dir' (organised
    according to BIDS) to 'preproc_dir' and run BET on the anatomical images.
    """

    # All subject directories
    if args:
        subject_ids = args[0]
        sub_dirs = []
        for s in subject_ids:
            sub_dirs.append(os.path.join(raw_dir, 'sub-' + s))
    else:
        sub_dirs = glob.glob(os.path.join(raw_dir, 'sub-*'))



    if not os.path.isdir(preproc_dir):
        os.mkdir(preproc_dir)

    # For each subject
    for sub_folder in sub_dirs:
        anat_regexp = '*_T1w.nii.gz'
        fun_regexp = '*_bold.nii.gz'

        # Find the anatomical MRI
        amri = glob.glob(
            os.path.join(sub_folder, 'anat', anat_regexp))[0]

        # Find the fMRI
        fmris = glob.glob(
            os.path.join(sub_folder, 'func', fun_regexp))

        # Copy the anatomical image
        anat_preproc_dir = os.path.join(preproc_dir, 'ANATOMICAL')
        if not os.path.isdir(anat_preproc_dir):
            os.mkdir(anat_preproc_dir)
        shutil.copy(amri, anat_preproc_dir)

        # For each run, copy the fMRI image
        func_preproc_dir = os.path.join(preproc_dir, 'FUNCTIONAL')
        if not os.path.isdir(func_preproc_dir):
            os.mkdir(func_preproc_dir)

        for fmri in fmris:
            shutil.copy(fmri, func_preproc_dir)

    # Applying BET to all the preprocessed anatomical MRIs
    amris = glob.glob(
        os.path.join(preproc_dir, 'ANATOMICAL', anat_regexp))
    for amri in amris:
        cmd = "bet " + amri + " " + amri.replace('.nii.gz', '_brain')
        print(cmd)
        check_call(cmd, shell=True)


def create_fsl_onset_files(study_dir, OnsetDir, conditions, removed_TR_time, *args):
    """
    Create FSL 3-columns onset files based on BIDS tsv files. Input data in
    'study_dir' is organised according to BIDS, the 'conditions' variable
    specifies the conditions of interest with respect to the regressors defined
    in BIDS. After completion, the 3-columns files are saved in 'OnsetDir'.
    """
    cond_files = dict()

    if not os.path.isdir(OnsetDir):
        os.mkdir(OnsetDir)

    # All subject directories
    if args:
        subject_ids = args[0]
        sub_dirs = []
        for s in subject_ids:
           sub_dirs.append(os.path.join(study_dir, 'sub-' + s))
    else:
        sub_dirs = glob.glob(os.path.join(study_dir, 'sub-*'))

    removed_TR_time = str(removed_TR_time)

    # For each subject
    for sub_dir in sub_dirs:

        # Event files (.tsv) for this subject
        event_files = glob.glob(os.path.join(sub_dir, 'func', '*.tsv'))

        subreg = re.search('sub-\d+', sub_dir)
        sub = subreg.group(0)

        # For each run
        for event_file in event_files:

            runreg = re.search('run-\d+', event_file)
            sub_run = sub + '_' + runreg.group(0)

            cond_files[sub_run] = list()

            # For each condition of interest
            for cond in conditions:
                if isinstance(cond[0], str):
                    # Standard condition (constant height)
                    FSL3colfile = os.path.join(
                        OnsetDir, sub_run + '_' + cond[0])
                    cmd = 'BIDSto3col.sh -b ' + removed_TR_time + ' -e ' + '"' + cond[1][0] + '"' +\
                        ' -d ' + cond[1][1] + ' '\
                        + event_file + ' '\
                        + FSL3colfile
                    check_call(cmd, shell=True)
                    cond_files[sub_run].append(FSL3colfile + '.txt')
                else:
                    # Parametric modulation
                    FSL3colfile = os.path.join(
                        OnsetDir, sub_run + '_' + cond[0][0])
                    cond_files[sub_run].append(FSL3colfile + '.txt')
                    for cond_name, cond_bids_name in dict(
                            zip(cond[0][1:], cond[1])).items():
                        cmd = 'BIDSto3col.sh -b ' + removed_TR_time + ' -e ' + cond_bids_name +\
                              ' -h ' + cond_bids_name + ' ' +\
                              event_file + ' ' + FSL3colfile
                        check_call(cmd, shell=True)
                        FSL3col_pmod = FSL3colfile + '_pmod.txt'
                        FSL3col_renamed = FSL3col_pmod.replace(
                            cond[0][0] + '_pmod', cond_name)
                        os.rename(FSL3col_pmod, FSL3col_renamed)
                        cond_files[sub_run].append(FSL3col_renamed)

    return cond_files


def wait_for_feat(report_file):
    """
    Because feat returns before the analysis is actually finished (and run in
    the background), we check if 'report_file' contains "STILL RUNNING" to
    determine when the analysis is completed.
    """
    running = True
    while running:
        time.sleep(10)

        with open(report_file, "r") as fp:
            report_head = fp.read()
            if "STILL RUNNING" not in report_head:
                running = False
                # Add a new line after all the dots
                print(" ")
            else:
                print("."),
                sys.stdout.flush()


def run_run_level_analyses(preproc_dir, run_level_fsf, level1_dir, cond_files):
    """
    Run a GLM for each fMRI run of each subject
    """
    scripts_dir = os.path.join(preproc_dir, os.pardir, 'SCRIPTS')

    if not os.path.isdir(scripts_dir):
        os.mkdir(scripts_dir)

    # Pre-processing directories storing the fMRIs and aMRIs for all subjects
    func_dir = os.path.join(preproc_dir, 'FUNCTIONAL')
    anat_dir = os.path.join(preproc_dir, 'ANATOMICAL')

    # All aMRI files (for all subjects)
    amri_files = glob.glob(os.path.join(anat_dir, 'sub-*_brain.nii.gz'))

    # For each subject
    for amri in amri_files:
        subreg = re.search('sub-\d+', amri)
        sub = subreg.group(0)

        # All fMRI files for this subject
        fmri_files = glob.glob(os.path.join(func_dir, sub + '*.nii.gz'))

        # For each fMRI file
        for fmri in fmri_files:
            runreg = re.search('run-\d+', fmri)
            run = runreg.group(0)
            sub_run = sub + '_' + run

            out_dir = os.path.join(level1_dir, sub, run)

            # Retreive inputs required to fill-in the design.fsf template:
            #   - amri: Path to the anatomical image (this subject)
            #   - fmri: Path to the functional image (this run)
            #   - outdir: Path to output feat directory
            #   - FSLDIR: Path to FSL (retreive from env variable FSLDIR)
            #   - onsets_xx: Path to onset file for condition 'xx'
            values = {'amri': amri, 'fmri': fmri, 'out_dir': out_dir,
                      'FSLDIR': os.environ['FSLDIR']}
            for i, cond_file in enumerate(cond_files[sub_run]):
                values['onsets_' + str(i+1)] = cond_file

            # Fill-in the template run-level design.fsf
            with open(run_level_fsf) as f:
                tpm = f.read()
                t = string.Template(tpm)
                run_fsf = t.substitute(values)

            run_fsf_file = os.path.join(scripts_dir, sub_run + '_level1.fsf')
            with open(run_fsf_file, "w") as f:
                f.write(run_fsf)

            # Run feat
            cmd = "feat " + run_fsf_file
            print(cmd)
            check_call(cmd, shell=True)


def run_subject_level_analyses(level1_dir, sub_level_fsf, level2_dir):

    scripts_dir = os.path.join(level2_dir, os.pardir, 'SCRIPTS')

    if not os.path.isdir(scripts_dir):
        os.mkdir(scripts_dir)

    # All subject directories
    sub_dirs = glob.glob(os.path.join(level1_dir, 'sub-*'))

    # For each subject
    for sub_dir in sub_dirs:
        values = dict()
        subreg = re.search('sub-\d+', sub_dir)
        sub = subreg.group(0)

        # Retreive values inputs to fill-in the design.fsf template:
        #   - out_dir: Path to output feat directory
        #   - feat_xx: Path to first-level feat directory 'xx'
        values = {'out_dir': os.path.join(sub_dir, "combined"), 'FSLDIR': os.environ['FSLDIR']}
        feat_dirs = glob.glob(os.path.join(sub_dir, '*.feat'))
        for i, feat_dir in enumerate(feat_dirs):
            values['feat_' + str(i+1)] = feat_dir
            report_file = os.path.join(feat_dir, 'report.html')
            # Wait for the run-level analysis to be completed
            wait_for_feat(report_file)

        # Fill-in the template subject-level design.fsf
        with open(sub_level_fsf) as f:
            tpm = f.read()
            t = string.Template(tpm)
            sub_fsf = t.substitute(values)

        sub_fsf_file = os.path.join(scripts_dir, sub + '_level2.fsf')
        with open(sub_fsf_file, "w") as f:
            f.write(sub_fsf)

        # Run feat
        cmd = "feat " + sub_fsf_file
        print(cmd)
        check_call(cmd, shell=True)


def run_group_level_analysis(level2_dir, group_level_fsf, level3_dir,
                             contrast_id):

    scripts_dir = os.path.join(level2_dir, os.pardir, 'SCRIPTS')

    if not os.path.isdir(scripts_dir):
        os.mkdir(scripts_dir)

    # Retreive values inputs to fill-in the design.fsf template:
    #   - out_dir: Path to output feat directory
    #   - feat_xx: Path to subject-level combined feat directory 'xx'
    values = dict()
    values = {'out_dir': level3_dir, 'FSLDIR': os.environ['FSLDIR']}

    feat_dirs = glob.glob(
        os.path.join(
            level2_dir, 'sub-*', "combined.gfeat",
            "cope" + contrast_id + ".feat"))

    for i, feat_dir in enumerate(feat_dirs):
        values['feat_' + str(i+1)] = feat_dir
        report_file = os.path.join(feat_dir, 'report.html')
        # Wait for the subject-level analysis to be completed
        wait_for_feat(report_file)

    # Fill-in the template group-level design.fsf
    with open(group_level_fsf) as f:
        tpm = f.read()
        t = string.Template(tpm)
        sub_fsf = t.substitute(values)

    group_fsf_file = os.path.join(scripts_dir, 'level3.fsf')
    with open(group_fsf_file, "w") as f:
        f.write(sub_fsf)

    # Run feat
    cmd = "feat " + group_fsf_file
    print(cmd)
    check_call(cmd, shell=True)

def run_permutation_test(level1_dir, perm_dir, perm_template):

    scripts_dir = os.path.join(level1_dir, os.pardir, 'SCRIPTS')

    if not os.path.isdir(scripts_dir):
        os.mkdir(scripts_dir)

    if not os.path.isdir(perm_dir):
        os.mkdir(perm_dir)

    # Fill-in the permutation template
    values = dict()
    values["perm_dir"] = perm_dir
    values["level1_dir"] = level1_dir

    with open(perm_template) as f:
        tpm = f.read()
        t = string.Template(tpm)
        group_script = t.substitute(values)

    group_script_file = os.path.join(scripts_dir, 'permutation_test.sh')

    with open(group_script_file, "w") as f:
            f.write(group_script)

    # Make the script executable and run
    st = os.stat(group_script_file)
    os.chmod(group_script_file, st.st_mode | stat.S_IEXEC)

    cmd = os.path.join('.', group_script_file)
    print(cmd)
    check_call(cmd, shell=True)

def mean_mni_images(preproc_dir, level1_dir, mni_dir):
    
    if not os.path.isdir(mni_dir):
        os.mkdir(mni_dir)
    
    anat_images = []

    # Creating the mean func in MNI space for each subject across runs
    sub_dirs = glob.glob(os.path.join(level1_dir, 'sub-*'))

    # For each subject
    for sub_dir in sub_dirs:
        # MNI anat images 
        anat = os.path.join(sub_dir, 'run-01.feat', 'reg', 'highres2standard.nii.gz')
        anat_images.append(anat)

        subreg = re.search('sub-\d+', sub_dir)
        sub = subreg.group(0)

        run_dirs = glob.glob(os.path.join(level1_dir, sub, 'run-*'))

        # Array of mean func images across runs
        run_mean_funcs = []
        for run_dir in run_dirs:
            func_img = os.path.join(run_dir, 'reg', 'example_func2standard.nii.gz')
            run_mean_funcs.append(func_img)

        # Concatenate the mean func images
        run_mean_funcs = image.concat_imgs(run_mean_funcs)

        # Create the mean func image across runs
        mean_func = image.mean_img(run_mean_funcs)

        # Save the image
        mean_func.to_filename(os.path.join(mni_dir, sub + '_mni_mean_func.nii.gz'))

    # MNI mean func images
    mean_func_images = glob.glob(os.path.join(mni_dir, 'sub-*'))

    # Standardising
    standardised_mean_func_images = []
    standardised_anat_images = []

    # Standardising mean func images
    for mean_func in mean_func_images:
        img = image.load_img(mean_func)
        data_array = img.get_data()
        # Copying the spm_global function in SPM
        global_mean = np.mean(data_array)
        masked_array = data_array[data_array > global_mean/8]
        g = np.mean(masked_array)
        data_array = data_array*(100/g)
        standardised_mean_func = image.new_img_like(mean_func, data_array)
        standardised_mean_func_images.append(standardised_mean_func)

    # Standardising anat images
    for anat in anat_images:
        img = image.load_img(anat)
        data_array = img.get_data()
        # Copying the spm_global function in SPM
        global_mean = np.mean(data_array)
        masked_array = data_array[data_array > global_mean/8]
        g = np.mean(masked_array)
        data_array = data_array*(100/g)
        standardised_anat = image.new_img_like(anat, data_array)
        standardised_anat_images.append(standardised_anat)

    # MNI mean and std dev mean func and anat images
    # Mean mean func images 
    mean_mni_mean_func = image.mean_img(standardised_mean_func_images)
    mean_mni_mean_func.to_filename(os.path.join(mni_dir, 'fsl_mean_mni_mean_func.nii.gz'))

    # Mean anat images 
    mean_mni_anat = image.mean_img(standardised_anat_images)
    mean_mni_anat.to_filename(os.path.join(mni_dir, 'fsl_mean_mni_anat.nii.gz'))

    # Std dev mni mean func image
    tmp = image.new_img_like(anat, data_array*0)
    tmp_data = tmp.get_data()
    for mean_func in standardised_mean_func_images:
        img = image.load_img(mean_func)
        data_array = img.get_data()
        tmp_data = tmp_data + np.square(data_array)

    tmp_data = tmp_data/len(standardised_mean_func_images)
    tmp = image.new_img_like(tmp, tmp_data)

    std_mni_mean_func = image.math_img("np.sqrt(img1 - np.square(img2))", img1=tmp, img2=mean_mni_mean_func)
    std_mni_mean_func.to_filename(os.path.join(mni_dir, 'fsl_std_mni_mean_func.nii.gz'))

    # Std dev mni anat image
    tmp = image.new_img_like(anat, data_array*0)
    tmp_data = tmp.get_data()
    for anat in standardised_anat_images:
        img = image.load_img(anat)
        data_array = img.get_data()
        tmp_data = tmp_data + np.square(data_array)

    tmp_data = tmp_data/len(standardised_mean_func_images)
    tmp = image.new_img_like(tmp, tmp_data)

    std_mni_anat = image.math_img("np.sqrt(img1 - np.square(img2))", img1=tmp, img2=mean_mni_anat)
    std_mni_anat.to_filename(os.path.join(mni_dir, 'fsl_std_mni_anat.nii.gz'))

def nidm_export(level1_dir, level3_dir):
    # Get the number of subjects in the analyis
    num_subs = str(len(glob.glob1(level1_dir, 'sub-*')))
    feat_dir = os.path.join(level3_dir, os.pardir, 'group.gfeat')

    cmd = 'nidmfsl -g control ' + num_subs + ' ' + feat_dir
    print(cmd)
    check_call(cmd, shell=True)
