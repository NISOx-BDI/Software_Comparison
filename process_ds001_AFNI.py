# Analysis of ds001 with AFNI

import os

from lib.afni_processing import copy_raw, create_afni_onset_files
from lib.afni_processing import run_subject_level_analyses
from lib.afni_processing import run_group_level_analysis

raw_dir = '/home/maullz/NIDM-Ex/BIDS_Data/DATA/BIDS/ds001_R2.0.4'
results_dir = '/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001'
afni_dir = os.path.join(results_dir, 'AFNI')

if not os.path.isdir(afni_dir):
    os.mkdir(afni_dir)

preproc_dir = os.path.join(afni_dir, 'PREPROCESSING')
level1_dir = os.path.join(afni_dir, 'LEVEL1')
level2_dir = os.path.join(afni_dir, 'LEVEL2')

# Set default orientation to origin (instead of standardised space) for
# ambiguous NIfTi (required for ds001)
os.environ["AFNI_NIFTI_VIEW"] = "orig"

# Specify the number of functional volumes ignored in the study
TR = 2
num_ignored_volumes = 2

# Specify the TR that will be removed from onesets, equal to num_ignored_volumes*TR
removed_TR_time = num_ignored_volumes*TR 

cwd = os.path.dirname(os.path.realpath(__file__))

# Copy raw anatomical and functional data to the preprocessing directory and
# run BET on the anatomical images
copy_raw(raw_dir, preproc_dir)

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
cond_files = create_afni_onset_files(raw_dir, onset_dir, conditions, removed_TR_time)

sub_level_template = os.path.join(cwd, 'lib', 'template_ds001_AFNI_level1')
grp_level_template = os.path.join(cwd, 'lib', 'template_ds001_AFNI_level2')

# Run a GLM combining all the fMRI runs of each subject
run_subject_level_analyses(preproc_dir, onset_dir, level1_dir, sub_level_template)

# Run the group-level GLM
run_group_level_analysis(level1_dir, level2_dir, grp_level_template)
