base_dir = '/home/maullz/NIDM-Ex/BIDS_Data';

raw_dir = fullfile(base_dir, 'DATA', 'BIDS');
results_dir = fullfile(base_dir, 'RESULTS', 'SOFTWARE_COMPARISON');

study_dir = fullfile(raw_dir, 'ds000109_R2.0.1');
spm_dir = fullfile(results_dir, 'ds109', 'SPM');
preproc_dir = fullfile(spm_dir, 'PREPROCESSING');
level1_dir = fullfile(spm_dir, 'LEVEL1');
level2_dir = fullfile(spm_dir, 'LEVEL2');
perm_dir = fullfile(level2_dir, 'permutation_test');

% Specify the subjects of interest from the raw data
subject_ids = [1,2,3,8,9,10,11,14,15,17,18,21,22,26,27,28,30,31,32,43,48];

% Specify the number of functional volumes ignored in the study
TR = 2;
num_ignored_volumes = 0;

% Specify the TR that will be removed from onsets, equal to num_ignored_volumes*TR
removed_TR_time = num_ignored_volumes*TR;

% Add 'lib' folder to the matlab path
if ~exist('copy_gunzip', 'file')
    addpath(fullfile(fileparts(mfilename('fullpath')), 'lib'))
end

copy_gunzip(study_dir, preproc_dir, subject_ids);

% Directory to store the onset files
onsetDir = fullfile(spm_dir,'ONSETS');

% Define conditions and parametric modulations (if any)
% FORMAT
%   {VariableLabel,{TrialType,Durations}}
%   {{VariableLabel,VariableModLabel},{TrialType,Duration,Amplitude}}
%  
CondNames = {...
    {'false_belief_story', {'false belief story', 'duration'}},...
    {'false_belief_question', {'false belief question', 'duration'}},...
    {'false_photo_story', {'false photo story', 'duration'}},...
    {'false_photo_question', {'false photo question', 'duration'}}};

create_onset_files(study_dir, onsetDir, CondNames, removed_TR_time, subject_ids);
spm('defaults','FMRI');

% run_subject_level_analyses(study_dir, preproc_dir, 'template_ds109_SPM_level1', level1_dir, num_ignored_volumes, TR, subject_ids);
% run_group_level_analysis(level1_dir, 'template_ds109_SPM_level2', level2_dir, '0001');
run_permutation_test(level1_dir, 'template_ds109_SPM_perm_test', perm_dir, '0001');
