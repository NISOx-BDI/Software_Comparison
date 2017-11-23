import os

from lib.fsl_processing import copy_and_BET, create_fsl_onset_files
from lib.fsl_processing import run_run_level_analyses
from lib.fsl_processing import run_subject_level_analyses
from lib.fsl_processing import run_group_level_analysis
from lib.fsl_processing import run_permutation_test
from lib.fsl_processing import mean_mni_images

raw_dir = '/storage/essicd/data/NIDM-Ex/BIDS_Data/DATA/BIDS/ds000109_R2.0.1'
results_dir = '/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109'

fsl_dir = os.path.join(results_dir, 'FSL')
if not os.path.isdir(fsl_dir):
    os.mkdir(fsl_dir)

preproc_dir = os.path.join(fsl_dir, 'PREPROCESSING')
level1_dir = os.path.join(fsl_dir, 'LEVEL1')
level2_dir = os.path.join(fsl_dir, 'LEVEL1')
level3_dir = os.path.join(fsl_dir, 'LEVEL2', 'group')
perm_dir = os.path.join(fsl_dir, 'LEVEL2', 'permutation_test')
mni_dir = os.path.join(fsl_dir, 'mean_mni_images')

# Specify the subjects of interest from the raw data
subject_ids = [1, 2, 3, 8, 9, 10, 11, 14, 15, 17, 18, 21, 22, 26, 27, 28, 30, 31, 32, 43, 48]
subject_ids = ['{num:02d}'.format(num=x) for x in subject_ids]

# Specify the number of functional volumes ignored in the study
TR = 2
num_ignored_volumes = 0

# Specify the TR that will be removed from onesets, equal to num_ignored_volumes*TR
removed_TR_time = num_ignored_volumes*TR 

cwd = os.path.dirname(os.path.realpath(__file__))

# Copy raw anatomical and functional data to the preprocessing directory and
# run BET on the anatomical images
#copy_and_BET(raw_dir, preproc_dir, subject_ids)

# Directory to store the onset files
onsetDir = os.path.join(fsl_dir, 'ONSETS')

# Define conditions and parametric modulations (if any)
conditions = (
    ('false_belief_story', ('false belief story', 'duration')),
    ('false_belief_question', ('false belief question', 'duration')),
    ('false_photo_story', ('false photo story', 'duration')),
    ('false_photo_question', ('false photo question', 'duration')))

# Create 3-columns onset files based on BIDS tsv files
#cond_files = create_fsl_onset_files(raw_dir, onsetDir, conditions, removed_TR_time, subject_ids)

run_level_fsf = os.path.join(cwd, 'lib', 'template_ds109_FSL_level1.fsf')
sub_level_fsf = os.path.join(cwd, 'lib', 'template_ds109_FSL_level2.fsf')
grp_level_fsf = os.path.join(cwd, 'lib', 'template_ds109_FSL_level3.fsf')
perm_template = os.path.join(cwd, 'lib', 'template_ds109_FSL_perm_test')

# Run a GLM for each fMRI run of each subject
#run_run_level_analyses(preproc_dir, run_level_fsf, level1_dir, cond_files)

# Run a GLM combining all the fMRI runs of each subject
#run_subject_level_analyses(level1_dir, sub_level_fsf, level2_dir)

# Run the group-level GLM
#run_group_level_analysis(level2_dir, grp_level_fsf, level3_dir, '1')

# Run a permutation test
#run_permutation_test(level1_dir, perm_dir, perm_template)

# Create mean and standard deviations maps of the mean func and anat images in MNI space
mean_mni_images(preproc_dir, level1_dir, mni_dir)
