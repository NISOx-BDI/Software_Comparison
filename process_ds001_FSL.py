import os

from lib.fsl_processing import copy_gunzip, create_onset_files
from lib.fsl_processing import run_run_level_analyses
from lib.fsl_processing import run_subject_level_analyses
from lib.fsl_processing import run_group_level_analysis

base_dir = '/storage/essicd/data/NIDM-Ex/BIDS_Data'

raw_dir = os.path.join(base_dir, 'DATA', 'BIDS')
results_dir = os.path.join(base_dir, 'RESULTS', 'SOFTWARE_COMPARISON')

study_dir = os.path.join(raw_dir, 'ds000001_R2.0.3')
fsl_dir = os.path.join(results_dir, 'ds001', 'FSL')
preproc_dir = os.path.join(fsl_dir, 'PREPROCESSING')
level1_dir = os.path.join(fsl_dir, 'LEVEL1')
level2_dir = os.path.join(fsl_dir, 'LEVEL1')

copy_gunzip(study_dir, preproc_dir)

# Directory to store the onset files
onsetDir = os.path.join(results_dir, 'ds001', 'SPM', 'ONSETS')

# Define conditions and parametric modulations (if any)
conditions = (
    (('pumps_fixed', 'pumps_demean'), ('pumps_demean')),
    ('pumps_RT', ('pumps_demean', 'response_time')),
    (('cash_fixed', 'cash_demean'), ('cash_demean')),
    ('cash_RT', ('cash_demean', 'response_time')),
    (('explode_fixed', 'explode_demean'), ('explode_demean')),
    (('control_pumps_fixed', 'control_pumps_demean'),
     ('control_pumps_demean')),
    ('control_pumps_RT', ('control_pumps_demean', 'response_time')))

cond_files = create_onset_files(study_dir, onsetDir, conditions)

run_level_fsf = 'template_ds001_FSL_level1'
sub_level_fsf = 'template_ds001_FSL_level2'
grp_level_fsf = 'template_ds001_FSL_level3'
run_run_level_analyses(preproc_dir, run_level_fsf, level1_dir, cond_files)

run_subject_level_analyses(preproc_dir, sub_level_fsf, level2_dir, cond_files)

run_group_level_analysis(level1_dir, grp_level_fsf, level2_dir, '1')

# run_group_level_analysis(raw_dir, level1_dir, 'template_ds001_SPM_level2', level2_dir);
# %'/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/SPM/LEVEL2/pumps_demean_vs_ctrl_demean'
