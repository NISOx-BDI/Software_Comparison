import os
import stat
from subprocess import check_call
import glob
import re
import string
import shutil
from lib.fsl_processing import create_fsl_onset_files
import stat
from nilearn import image
import numpy as np
import nibabel as nib


def copy_raw(raw_dir, preproc_dir, *args):
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


def create_afni_onset_files(study_dir, onset_dir, conditions, removed_TR_time, *args):
    """
    Create AFNI onset files based on BIDS tsv files. Input data in
    'study_dir' is organised according to BIDS, the 'conditions' variable
    specifies the conditions of interest with respect to the regressors defined
    in BIDS. After completion, the onset files are saved in 'onset_dir'.
    """

    # Create FSL onset files from BIDS
    if args:
        subject_ids = args[0]
        create_fsl_onset_files(study_dir, onset_dir, conditions, removed_TR_time, subject_ids)
    else:
        create_fsl_onset_files(study_dir, onset_dir, conditions, removed_TR_time)

    # Convert FSL onset files to AFNI onset files
    cmd = '3coltoAFNI.sh ' + onset_dir
    print(cmd)
    check_call(cmd, shell=True)

    # Delete FSL onset files
    filelist = glob.glob(os.path.join(onset_dir, "*.txt"))
    for f in filelist:
        os.remove(f)

    if args:
        subject_ids = args[0]
        sub_dirs = []
        for s in subject_ids:
            sub_dirs.append(os.path.join(study_dir, 'sub-' + s))
    else:
        sub_dirs = glob.glob(os.path.join(study_dir, 'sub-*'))

    subs = [os.path.basename(w) for w in sub_dirs]

    # Get the condition names
    condition_names = list()
    for cond_names, cond_info in conditions:
        if isinstance(cond_names, tuple):
            for cond_name in cond_names:
                condition_names.append(cond_name)
        else:
            condition_names.append(cond_names)

    # Combine all runs into one .1d combined onset for each condition/subject
    for sub in subs:
        for cond in condition_names:
            # All onset files for this subject and condition
            onset_files = sorted(glob.glob(
                os.path.join(onset_dir, sub + '_run-[0-9][0-9]_' + cond + '*.1d')))
            combined_onset_file = os.path.join(
                onset_dir, sub + '_combined_' + cond + '_afni.1d')
            if not onset_files:
                raise Exception('No onset files for ' + sub + ' ' + cond)

            with open(combined_onset_file, 'w') as outfile:
                for fname in onset_files:
                    with open(fname) as infile:
                        # Replace n/a with 0 as AFNI cannot handle them
                        onsets = infile.read().replace("465.166:n/a", "")
                        outfile.write(onsets)
                    os.remove(fname)


def run_subject_level_analyses(preproc_dir, onset_dir, level1_dir,
    sub_level_template):

    scripts_dir = os.path.join(preproc_dir, os.pardir, 'SCRIPTS')

    if not os.path.isdir(scripts_dir):
        os.mkdir(scripts_dir)

    if not os.path.isdir(level1_dir):
        os.mkdir(level1_dir)

    # Pre-processing directories storing the fMRIs and aMRIs for all subjects
    func_dir = os.path.join(preproc_dir, 'FUNCTIONAL')
    anat_dir = os.path.join(preproc_dir, 'ANATOMICAL')

    # All aMRI files (for all subjects)
    amri_files = glob.glob(os.path.join(anat_dir, 'sub-*_T1w.nii.gz'))

    # For each subject
    for amri in amri_files:
        # New dict for each subject
        values = dict()
        values["anat_dir"] = anat_dir
        values["func_dir"] = func_dir
        values["stim_dir"] = onset_dir

        subreg = re.search('sub-\d+', amri)
        sub = subreg.group(0)
        values["sub"] = sub
        shortsub = sub.replace("-", "")
        values["subj"] = shortsub
	
	if not os.path.isfile(os.path.join(scripts_dir, sub + '_level1.sh')):
		# Fill-in the subject-level template
		with open(sub_level_template) as f:
		    tpm = f.read()
		    t = string.Template(tpm)
		    sub_script = t.substitute(values)
	
		sub_script_file = os.path.join(scripts_dir, sub + '_level1.sh')

		with open(sub_script_file, "w") as f:
		    f.write(sub_script)

		# Make the script executable
		st = os.stat(sub_script_file)
		os.chmod(sub_script_file, st.st_mode | stat.S_IEXEC)

		# Run subject-level analysis
		sub_results_dir = os.path.join(level1_dir, sub)
		if not os.path.isdir(sub_results_dir):
		    os.mkdir(sub_results_dir)

		os.chdir(sub_results_dir)

		cmd = os.path.join('.', sub_script_file)
		print(cmd)
		check_call(cmd, shell=True)

		# Putting the proc. script in the correct directory, making it executable, and running
		sub_proc_script_file = os.path.join(sub_results_dir, 'proc.' + shortsub)
		cmd = os.path.join('tcsh -xef ' + sub_proc_script_file)
		print(cmd)
		check_call(cmd, shell=True)

def run_group_level_analysis(level1_dir, level2_dir, grp_level_template):

    scripts_dir = os.path.join(level1_dir, os.pardir, 'SCRIPTS')

    if not os.path.isdir(scripts_dir):
        os.mkdir(scripts_dir)

    if not os.path.isdir(level2_dir):
        os.mkdir(level2_dir)

    # Fill-in the group-level template
    values = dict()
    values["level2_dir"] = level2_dir
    values["level1_dir"] = level1_dir

    with open(grp_level_template) as f:
        tpm = f.read()
        t = string.Template(tpm)
        group_script = t.substitute(values)

    group_script_file = os.path.join(scripts_dir, 'level2.sh')

    with open(group_script_file, "w") as f:
            f.write(group_script)

    # Make the script executable and run
    st = os.stat(group_script_file)
    os.chmod(group_script_file, st.st_mode | stat.S_IEXEC)

    cmd = os.path.join('.', group_script_file)
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
        subreg_dash = re.search('sub-\d+', sub_dir)
        sub_dash = subreg_dash.group(0)

        results_dir = glob.glob(os.path.join(sub_dir, 'sub??.results'))[0]
        subreg = re.search('sub\d+', results_dir)
        sub = subreg.group(0)

        # MNI anat images 
        # Converting mni anatomical from BRIK to NIFTI
        anat_BRIK = os.path.join(results_dir, 'anat_final.' + sub + '+tlrc.BRIK')
        cmd = '3dAFNItoNIFTI -prefix ' + mni_dir + '/' + sub_dash + '_mni_anat.nii.gz ' + anat_BRIK
        check_call(cmd, shell=True)

        anat = os.path.join(mni_dir, sub_dash + '_mni_anat.nii.gz')
        anat_images.append(anat)

        run_mean_func_BRIKS = glob.glob(os.path.join(results_dir, 'pb02.' + sub + '.r??.volreg+tlrc.BRIK'))

        # Array of mean func images across runs
        run_mean_funcs = []
        for func_BRIK in run_mean_func_BRIKS:
            runreg = re.search('r\d+', func_BRIK)
            run = runreg.group(0)
            cmd = '3dAFNItoNIFTI -prefix ' + mni_dir + '/' + sub_dash + '_' + run + '_mean_func.nii.gz ' + func_BRIK
            check_call(cmd, shell=True)
            run_mean_func = os.path.join(mni_dir, sub_dash + '_' + run + '_mean_func.nii.gz')
            run_mean_funcs.append(run_mean_func)

        # Concatenate the mean func images
        run_mean_funcs = image.concat_imgs(run_mean_funcs)

        # Create the mean func image across runs
        mean_func = image.mean_img(run_mean_funcs)

        # Save the image
        mean_func.to_filename(os.path.join(mni_dir, sub_dash + '_mni_mean_func.nii.gz'))

    # MNI mean func images
    mean_func_images = glob.glob(os.path.join(mni_dir, 'sub-*_mni_mean_func.nii.gz'))

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
    mean_mni_mean_func.to_filename(os.path.join(mni_dir, 'afni_mean_mni_mean_func.nii.gz'))

    # Mean anat images 
    mean_mni_anat = image.mean_img(standardised_anat_images)
    mean_mni_anat.to_filename(os.path.join(mni_dir, 'afni_mean_mni_anat.nii.gz'))

    # Std dev mni mean func image
    img = image.load_img(mean_mni_mean_func)
    data_array = img.get_data()
    tmp = image.new_img_like(mean_func, data_array*0)
    tmp_data = tmp.get_data()
    for mean_func in standardised_mean_func_images:
        img = image.load_img(mean_func)
        data_array = img.get_data()
        tmp_data = tmp_data + np.square(data_array)

    tmp_data = tmp_data/len(standardised_mean_func_images)
    tmp = image.new_img_like(tmp, tmp_data)

    std_mni_mean_func = image.math_img("np.sqrt(img1 - np.square(img2))", img1=tmp, img2=mean_mni_mean_func)
    std_mni_mean_func.to_filename(os.path.join(mni_dir, 'afni_std_mni_mean_func.nii.gz'))

    # Std dev mni anat image
    img = image.load_img(anat)
    data_array = img.get_data()
    tmp = image.new_img_like(anat, data_array*0)
    tmp_data = tmp.get_data()
    for anat in standardised_anat_images:
        img = image.load_img(anat)
        data_array = img.get_data()
        tmp_data = tmp_data + np.square(data_array)

    tmp_data = tmp_data/len(standardised_mean_func_images)
    tmp = image.new_img_like(tmp, tmp_data)

    std_mni_anat = image.math_img("np.sqrt(img1 - np.square(img2))", img1=tmp, img2=mean_mni_anat)
    std_mni_anat.to_filename(os.path.join(mni_dir, 'afni_std_mni_anat.nii.gz'))

def run_SSWarper(preproc_dir, SSWarper_template):

    scripts_dir = os.path.join(preproc_dir, os.pardir, 'SCRIPTS')

    if not os.path.isdir(scripts_dir):
        os.mkdir(scripts_dir)

    # Pre-processing directory storing the aMRIs for all subjects
    anat_dir = os.path.join(preproc_dir, 'ANATOMICAL')

    # All aMRI files (for all subjects)
    amri_files = glob.glob(os.path.join(anat_dir, 'sub-*_T1w.nii.gz'))

    # For each subject
    for amri in amri_files:
        # New dict for each subject
        values = dict()
        subreg = re.search('sub-\d+', amri)
        sub = subreg.group(0)
        values["sub"] = sub
	
	if not os.path.isfile(os.path.join(scripts_dir, sub + '_SSWarper.sh')):
		# Fill-in template
		with open(SSWarper_template) as f:
		    tpm = f.read()
		    t = string.Template(tpm)
		    sub_script = t.substitute(values)

		sub_script_file = os.path.join(scripts_dir, sub + '_SSWarper.sh')

		with open(sub_script_file, "w") as f:
		    f.write(sub_script)

		# Make the script executable
		st = os.stat(sub_script_file)
		os.chmod(sub_script_file, st.st_mode | stat.S_IEXEC)

		# Run SSWarper on subject
		os.chdir(anat_dir)

		cmd = os.path.join('.', sub_script_file)
        	print(cmd)
        	check_call(cmd, shell=True)

def run_orthogonalize(preproc_dir, onset_dir, orthogonalize_template):

    scripts_dir = os.path.join(preproc_dir, os.pardir, 'SCRIPTS')

    if not os.path.isdir(scripts_dir):
        os.mkdir(scripts_dir)

    # Pre-processing directories storing the fMRIs and aMRIs for all subjects
    anat_dir = os.path.join(preproc_dir, 'ANATOMICAL')

    # All aMRI files (for all subjects)
    amri_files = glob.glob(os.path.join(anat_dir, 'sub-*_T1w.nii.gz'))

    # For each subject
    for amri in amri_files:
        # New dict for each subject
        values = dict()
        values["stim_dir"] = onset_dir

        subreg = re.search('sub-\d+', amri)
        sub = subreg.group(0)
        values["sub"] = sub

	
	if not os.path.isfile(os.path.join(scripts_dir, sub + '_orthorgonalize.sh')):
		# Fill-in the subject-level template
		with open(orthogonalize_template) as f:
		    tpm = f.read()
		    t = string.Template(tpm)
		    sub_script = t.substitute(values)
	
		sub_script_file = os.path.join(scripts_dir, sub + '_orthogonalize.sh')

		with open(sub_script_file, "w") as f:
		    f.write(sub_script)

		# Make the script executable
		st = os.stat(sub_script_file)
		os.chmod(sub_script_file, st.st_mode | stat.S_IEXEC)

		# Run subject-level analysis
		if not os.path.isdir(onset_dir):
		    os.mkdir(onset_dir)

		os.chdir(onset_dir)

		cmd = os.path.join('.', sub_script_file)
		print(cmd)
		check_call(cmd, shell=True)

