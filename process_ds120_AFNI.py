# Analysis of ds001 with AFNI

import os
import shutil
from subprocess import check_call

from lib.afni_processing import copy_raw, create_afni_onset_files
from lib.afni_processing import run_subject_level_analyses
from lib.afni_processing import run_group_level_analysis

pre_raw_dir = '/home/maullz/NIDM-Ex/BIDS_Data/DATA/BIDS/ds120_R1.0.0'
results_dir = '/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds120'
raw_dir = os.path.join(pre_raw_dir, '..', 'ds120_R1.0.0_AMENDED')
afni_dir = os.path.join(results_dir, 'AFNI')

if not os.path.isdir(afni_dir):
    os.mkdir(afni_dir)

preproc_dir = os.path.join(afni_dir, 'PREPROCESSING')
level1_dir = os.path.join(afni_dir, 'LEVEL1')
level2_dir = os.path.join(afni_dir, 'LEVEL2')

# The original event files are not compatible with Bidsto3col.sh, so we copy the raw data and amend the events
if not os.path.isdir(raw_dir):
	shutil.copytree(pre_raw_dir, raw_dir)
	cmd = "Amendds120tsv.sh " + raw_dir
	check_call(cmd, shell=True)

# Set default orientation to origin (instead of standardised space) for
# ambiguous NIfTi (required for ds001)
os.environ["AFNI_NIFTI_VIEW"] = "orig"

# Specify the number of functional volumes ignored in the study
TR = 1.5
num_ignored_volumes = 4

# Specify the TR that will be removed from onesets, equal to num_ignored_volumes*TR
removed_TR_time = num_ignored_volumes*TR 

# Specify the subjects of interest from the raw data
subject_ids = [1, 2, 3, 4, 6, 8, 10, 11, 14, 17, 18, 19, 21, 22, 25, 26, 27]
subject_ids = ['{num:02d}'.format(num=x) for x in subject_ids]

cwd = os.path.dirname(os.path.realpath(__file__))

# Copy raw anatomical and functional data to the preprocessing directory and
# run BET on the anatomical images
copy_raw(raw_dir, preproc_dir, subject_ids)

# Directory to store the onset files
onset_dir = os.path.join(afni_dir, 'ONSETS')

# Define conditions and parametric modulations (if any)
# FORMAT
#   {VariableLabel,{TrialType,Durations}}
#   {{VariableLabel,VariableModLabel},{TrialType,Duration,Amplitude}}
conditions = (
    ('neutral', ('neutral_resp', 'duration')),
    ('reward', ('reward_resp', 'duration')))

# Create onset files based on BIDS tsv files
cond_files = create_afni_onset_files(raw_dir, onset_dir, conditions, removed_TR_time, subject_ids)

sub_level_template = os.path.join(cwd, 'lib', 'template_ds120_AFNI_level1')
grp_level_template = os.path.join(cwd, 'lib', 'template_ds120_AFNI_level2')

# Run a GLM combining all the fMRI runs of each subject
run_subject_level_analyses(preproc_dir, onset_dir, level1_dir, sub_level_template)

# Run the group-level GLM
run_group_level_analysis(level1_dir, level2_dir, grp_level_template)
