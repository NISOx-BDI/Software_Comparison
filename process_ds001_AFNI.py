import os

from lib.afni_processing import copy_raw, create_afni_onset_files
# from lib.afni_processing import run_run_level_analyses
# from lib.afni_processing import run_subject_level_analyses
# from lib.afni_processing import run_group_level_analysis

raw_dir = '/Users/cmaumet/Projects/Data_sharing/Data/OpenfMRI/ds001_R201/ds001'
results_dir = \
    '/Users/cmaumet/Projects/Data_sharing/dev/Software_Comparison/ds001'

afni_dir = os.path.join(results_dir, 'AFNI')
if not os.path.isdir(afni_dir):
    os.mkdir(afni_dir)

preproc_dir = os.path.join(afni_dir, 'PREPROCESSING')
level1_dir = os.path.join(afni_dir, 'LEVEL1')
level2_dir = os.path.join(afni_dir, 'LEVEL2')

cwd = os.path.dirname(os.path.realpath(__file__))

# Copy raw anatomical and functional data to the preprocessing directory and
# run BET on the anatomical images
#copy_raw(raw_dir, preproc_dir)

# Directory to store the onset files
onset_dir = os.path.join(afni_dir, 'ONSETS')

# Define conditions and parametric modulations (if any)
# FORMAT
#   {VariableLabel,{TrialType,Durations}}
#   {{VariableLabel,VariableModLabel},{TrialType,Duration,Amplitude}}
conditions = (
    (('pumps_fixed', 'pumps_demean'), ('pumps_demean',)),
    ('pumps_RT', ('pumps_demean', 'response_time')),
    (('cash_fixed', 'cash_demean'), ('cash_demean',)),
    ('cash_RT', ('cash_demean', 'response_time')),
    (('explode_fixed', 'explode_demean'), ('explode_demean',)),
    (('control_pumps_fixed', 'control_pumps_demean'),
     ('control_pumps_demean',)),
    ('control_pumps_RT', ('control_pumps_demean', 'response_time')))

# Create onset files based on BIDS tsv files
cond_files = create_afni_onset_files(raw_dir, onset_dir, conditions)

# run_level_fsf = os.path.join(cwd, 'lib', 'template_ds001_FSL_level1.fsf')
# sub_level_fsf = os.path.join(cwd, 'lib', 'template_ds001_FSL_level2.fsf')
# grp_level_fsf = os.path.join(cwd, 'lib', 'template_ds001_FSL_level3.fsf')

# # Run a GLM for each fMRI run of each subject
# run_run_level_analyses(preproc_dir, run_level_fsf, level1_dir, cond_files)

# # Run a GLM combining all the fMRI runs of each subject
# run_subject_level_analyses(level1_dir, sub_level_fsf, level2_dir)

# # Run the group-level GLM
# run_group_level_analysis(level2_dir, grp_level_fsf, level3_dir, '1')
