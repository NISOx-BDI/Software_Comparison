import glob
import string
import os
from subprocess import check_call


def run_run_level_analyses(preproc_dir, sub_level_fsf, level2_dir, cond_files):

    scripts_dir = os.path.join(preproc_dir, os.pardir, 'SCRIPTS')

    if os.path.isdir(scripts_dir):
        os.mkdir(scripts_dir)

    func_dir = fullfile(preproc_dir, 'FUNCTIONAL')
    anat_dir = fullfile(preproc_dir, 'ANATOMICAL')

    amri_files = glob.glob(os.path.join(anat_dir, 'sub-*.nii.gz'))

    for amri in amri_files:
        subreg = re.search('sub-\d+', sub_dir)
        sub = subreg.group(0)

        fmri_files = glob.glob(os.path.join(func_dir, sub + '*.nii.gz'))
        for fmri in fmri_files:
            runreg = re.search('run-\d+', fmri)
            run = runreg.group(0)

            out_dir = os.path.join(level1_dir, sub, run)

            values = {'amri': amri, 'fmri': fmri, 'out_dir': out_dir}
            for i, cond_file in enumerate(cond_files):
                values['onsets_' + str(i+1)] = cond_file

            with open(run_level_template) as f:
                tpm = f.read()
                t = string.Template(tpm)
                run_fsf = t.substitute(values)

            run_fsf_file = os.path.join(scripts_dir, sub + '_level1.fsf')
            with open(run_fsf_file, "w") as f:
                f.write(run_fsf)

            check_call("feat " + run_fsf_file)

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
