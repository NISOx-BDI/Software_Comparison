import os

from lib.fsl_processing import copy_gunzip, create_onset_files
from lib.fsl_processing import run_run_level_analyses
from lib.fsl_processing import run_subject_level_analyses
from lib.fsl_processing import run_group_level_analysis

raw_dir = '/storage/essicd/data/NIDM-Ex/BIDS_Data/DATA/BIDS/ds001_R2.0.4'
results_dir = '/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001'

fsl_dir = os.path.join(results_dir, 'FSL')
if not os.path.isdir(fsl_dir):
    os.mkdir(fsl_dir)

preproc_dir = os.path.join(fsl_dir, 'PREPROCESSING')
level1_dir = os.path.join(fsl_dir, 'LEVEL1')
level2_dir = os.path.join(fsl_dir, 'LEVEL1')
level3_dir = os.path.join(fsl_dir, 'LEVEL3', 'group')

cwd = os.path.dirname(os.path.realpath(__file__))

copy_gunzip(raw_dir, preproc_dir)

# Directory to store the onset files
onsetDir = os.path.join(fsl_dir, 'ONSETS')

# Define conditions and parametric modulations (if any)
conditions = (
    (('pumps_fixed', 'pumps_demean'), ('pumps_demean',)),
    ('pumps_RT', ('pumps_demean', 'response_time')),
    (('cash_fixed', 'cash_demean'), ('cash_demean',)),
    ('cash_RT', ('cash_demean', 'response_time')),
    (('explode_fixed', 'explode_demean'), ('explode_demean',)),
    (('control_pumps_fixed', 'control_pumps_demean'),
     ('control_pumps_demean',)),
    ('control_pumps_RT', ('control_pumps_demean', 'response_time')))

cond_files = create_onset_files(raw_dir, onsetDir, conditions)

run_level_fsf = os.path.join(cwd, 'lib', 'template_ds001_FSL_level1.fsf')
sub_level_fsf = os.path.join(cwd, 'lib', 'template_ds001_FSL_level2.fsf')
grp_level_fsf = os.path.join(cwd, 'lib', 'template_ds001_FSL_level3.fsf')

run_run_level_analyses(preproc_dir, run_level_fsf, level1_dir, cond_files)

run_subject_level_analyses(level1_dir, sub_level_fsf, level2_dir)

run_group_level_analysis(level1_dir, grp_level_fsf, level3_dir, '1')

# run_group_level_analysis(raw_dir, level1_dir, 'template_ds001_SPM_level2', level2_dir);
# %'/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/SPM/LEVEL2/pumps_demean_vs_ctrl_demean'
