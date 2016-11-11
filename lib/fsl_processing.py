import os
import time
import sys
from subprocess import check_call
import glob
import re
import string
import shutil


def copy_gunzip(raw_dir, preproc_dir):
    """
    Copy to 'preproc_dir' and gunzip anatomical and fmri files found in
    'raw_dir' (and organised according to BIDS)

    """
    sub_dirs = glob.glob(os.path.join(raw_dir, 'sub-*'))

    if not os.path.isdir(preproc_dir):
        os.mkdir(preproc_dir)

    for sub_folder in sub_dirs:
        anat_regexp = '*_T1w.nii.gz'
        fun_regexp = '*_bold.nii.gz'

        amri = glob.glob(
            os.path.join(sub_folder, 'anat', anat_regexp))[0]
        fmris = glob.glob(
            os.path.join(sub_folder, 'func', fun_regexp))

        # Copy the anatomical image
        anat_preproc_dir = os.path.join(preproc_dir, 'ANATOMICAL')
        if not os.path.isdir(anat_preproc_dir):
            os.mkdir(anat_preproc_dir)
        shutil.copy(amri, anat_preproc_dir)

        # For each run, copy the fmri image
        func_preproc_dir = os.path.join(preproc_dir, 'FUNCTIONAL')
        if not os.path.isdir(func_preproc_dir):
            os.mkdir(func_preproc_dir)

        for fmri in fmris:
            shutil.copy(fmri, func_preproc_dir)


def create_onset_files(study_dir, OnsetDir, conditions):

    cond_files = dict()

    if not os.path.isdir(OnsetDir):
        os.mkdir(OnsetDir)

    sub_dirs = glob.glob(os.path.join(study_dir, 'sub-*'))
    for sub_dir in sub_dirs:
        event_files = glob.glob(os.path.join(sub_dir, 'func', '*.tsv'))

        subreg = re.search('sub-\d+', sub_dir)
        sub = subreg.group(0)

        for event_file in event_files:

            runreg = re.search('run-\d+', event_file)
            sub_run = sub + '_' + runreg.group(0)

            cond_files[sub_run] = list()

            for cond in conditions:
                if isinstance(cond[0], str):
                    FSL3colfile = os.path.join(
                        OnsetDir, sub_run + '_' + cond[0])
                    cmd = 'BIDSto3col.sh -b 4 -e ' + cond[1][0] +\
                        ' -d ' + cond[1][1] + ' '\
                        + event_file + ' '\
                        + FSL3colfile
                    check_call(cmd, shell=True)
                    cond_files[sub_run].append(FSL3colfile + '.txt')
                else:
                    FSL3colfile = os.path.join(OnsetDir, sub_run + '_' + cond[0][0])
                    cond_files[sub_run].append(FSL3colfile + '.txt')
                    for cond_name, cond_bids_name in dict(
                            zip(cond[0][1:], cond[1])).items():
                        cmd = 'BIDSto3col.sh -b 4 -e ' + cond_bids_name +\
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
    running = True
    while running:
        time.sleep(10)

        with open(report_file, "r") as fp:
            report_head = fp.read()
            if "STILL RUNNING" not in report_head:
                running = False
            else:
                print("."),
                sys.stdout.flush()


def run_run_level_analyses(preproc_dir, run_level_fsf, level1_dir, cond_files):

    scripts_dir = os.path.join(preproc_dir, os.pardir, 'SCRIPTS')

    if not os.path.isdir(scripts_dir):
        os.mkdir(scripts_dir)

    func_dir = os.path.join(preproc_dir, 'FUNCTIONAL')
    anat_dir = os.path.join(preproc_dir, 'ANATOMICAL')

    amri_files = glob.glob(os.path.join(anat_dir, 'sub-*.nii.gz'))

    for amri in amri_files:
        subreg = re.search('sub-\d+', amri)
        sub = subreg.group(0)

        fmri_files = glob.glob(os.path.join(func_dir, sub + '*.nii.gz'))
        for fmri in fmri_files:
            runreg = re.search('run-\d+', fmri)
            run = runreg.group(0)
            sub_run = sub + '_' + run

            out_dir = os.path.join(level1_dir, sub, run)

            values = {'amri': amri, 'fmri': fmri, 'out_dir': out_dir,
                      'FSLDIR': os.environ['FSLDIR']}
            print(cond_files)
            for i, cond_file in enumerate(cond_files[sub_run]):
                values['onsets_' + str(i+1)] = cond_file

            with open(run_level_fsf) as f:
                tpm = f.read()
                t = string.Template(tpm)
                run_fsf = t.substitute(values)

            run_fsf_file = os.path.join(scripts_dir, sub_run + '_level1.fsf')
            with open(run_fsf_file, "w") as f:
                f.write(run_fsf)

            cmd = "feat " + run_fsf_file
            print(cmd)
            check_call(cmd, shell=True)

            report_file = os.path.join(
                os.path.dirname(run_fsf_file), 'report.html')
            wait_for_feat(report_file)

# out_dir='/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL1/sub-01/run-01'
# fmri='/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/PREPROCESSING/FUNCTIONAL/sub-01_task-balloonanalogrisktask_run-01_bold'
# amri=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/PREPROCESSING/ANATOMICAL/sub-01_T1w_brain
# onsets_1=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/ONSETS/sub-01_run-01_pumps_fixed.txt
# onsets_2=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/ONSETS/sub-01_run-01_pumps_fixed_pmod.txt
# onsets_3=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/ONSETS/sub-01_run-01_pumps_RT.txt
# onsets_4=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/ONSETS/sub-01_run-01_cash_fixed.txt
# onsets_5=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/ONSETS/sub-01_run-01_cash_fixed_pmod.txt
# onsets_6=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/ONSETS/sub-01_run-01_cash_RT.txt
# onsets_7=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/ONSETS/sub-01_run-01_explode_fixed.txt
# onsets_8=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/ONSETS/sub-01_run-01_explode_fixed_pmod.txt
# onsets_9=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/ONSETS/sub-01_run-01_control_pumps_fixed.txt
# onsets_10=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/ONSETS/sub-01_run-01_control_pumps_fixed_pmod.txt
# onsets_11=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/ONSETS/sub-01_run-01_control_pumps_RT.txt


def run_subject_level_analyses(level1_dir, sub_level_fsf, level2_dir):

    scripts_dir = os.path.join(level2_dir, os.pardir, 'SCRIPTS')

    if not os.path.isdir(scripts_dir):
        os.mkdir(scripts_dir)

    sub_dirs = glob.glob(os.path.join(level1_dir, 'sub-*'))
    print(level1_dir)
    for sub_dir in sub_dirs:
        print(sub_dir)
        values = dict()
        subreg = re.search('sub-\d+', sub_dir)
        sub = subreg.group(0)

        values['out_dir'] = os.path.join(sub_dir, "combined")
        print(os.path.join(sub_dir, '*.feat'))
        feat_dirs = glob.glob(os.path.join(sub_dir, '*.feat'))
        print(feat_dirs)
        for i, feat_dir in enumerate(feat_dirs):
            values['feat_' + str(i+1)] = feat_dir
        with open(sub_level_fsf) as f:
            tpm = f.read()
            t = string.Template(tpm)
            sub_fsf = t.substitute(values)

        sub_fsf_file = os.path.join(scripts_dir, sub + '_level2.fsf')
        with open(sub_fsf_file, "w") as f:
            f.write(sub_fsf)

        cmd = "feat " + sub_fsf_file
        print(cmd)
        check_call(cmd, shell=True)

        report_file = os.path.join(
            os.path.dirname(sub_fsf_file), 'report.html')
        wait_for_feat(report_file)

# out_dir='/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL1/sub-01/combined'
# feat_1=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL1/sub-01/run-01.feat
# feat_2=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL1/sub-01/run-02.feat
# feat_3=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL1/sub-01/run-03.feat


def run_group_level_analysis(level1_dir, group_level_fsf, level2_dir,
                             contrast_id):

    scripts_dir = os.path.join(level2_dir, os.pardir, 'SCRIPTS')

    if not os.path.isdir(scripts_dir):
        os.mkdir(scripts_dir)

    values = dict()
    values['out_dir'] = level2_dir

    feat_dirs = glob.glob(
        os.path.join(
            level1_dir, 'sub-*', "combined.gfeat",
            "cope" + contrast_id + ".feat"))

    for i, feat_dir in enumerate(feat_dirs):
        values['feat_' + str(i+1)] = feat_dir

    with open(group_level_fsf) as f:
        tpm = f.read()
        t = string.Template(tpm)
        sub_fsf = t.substitute(values)

    group_fsf_file = os.path.join(scripts_dir, 'level3.fsf')
    with open(group_fsf_file, "w") as f:
        f.write(sub_fsf)

    cmd = "feat " + group_fsf_file
    print(cmd)
    check_call(cmd, shell=True)
    report_file = os.path.join(
        os.path.dirname(group_fsf_file), 'report.html')
    wait_for_feat(report_file)

# out_dir=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL2/group
# feat_1=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL1/sub-01/combined.gfeat/cope1.feat
# feat_2=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL1/sub-02/combined.gfeat/cope1.feat
# feat_3=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL1/sub-03/combined.gfeat/cope1.feat
# ...
