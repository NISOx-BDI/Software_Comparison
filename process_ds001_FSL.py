import os

from lib import copy_gunzip, create_onset_files

base_dir = '/home/maullz/NIDM-Ex/BIDS_Data'

raw_dir = os.path.join(base_dir, 'DATA', 'BIDS')
results_dir = os.path.join(base_dir, 'RESULTS', 'SOFTWARE_COMPARISON')

study_dir = os.path.join(raw_dir, 'ds000001_R2.0.3')
fsl_dir = os.path.join(results_dir, 'ds001', 'FSL')
preproc_dir = os.path.join(fsl_dir, 'PREPROCESSING')
level1_dir = os.path.join(fsl_dir, 'LEVEL1')

copy_gunzip(study_dir, preproc_dir)

# Directory to store the onset files
onsetDir = os.path.join(results_dir, 'ds001', 'SPM', 'ONSETS')

# Define conditions and parametric modulations (if any)
CondNames = (
    (('pumps_fixed', 'pumps_demean'), ('pumps_demean')),
    ('pumps_RT', ('pumps_demean', 'response_time')),
    (('cash_fixed', 'cash_demean'), ('cash_demean')),
    ('cash_RT', ('cash_demean', 'response_time')),
    (('explode_fixed', 'explode_demean'), ('explode_demean')),
    (('control_pumps_fixed', 'control_pumps_demean'),
     ('control_pumps_demean')),
    ('control_pumps_RT', ('control_pumps_demean', 'response_time')))

create_onset_files(study_dir, onsetDir, CondNames)
# run_subject_level_analyses(raw_dir, preproc_dir, 'template_ds001_SPM_level1', level1_dir);

# run_group_level_analysis(raw_dir, level1_dir, 'template_ds001_SPM_level2', level2_dir);
# %'/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/SPM/LEVEL2/pumps_demean_vs_ctrl_demean'
