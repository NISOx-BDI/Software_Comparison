base_dir = '/home/maullz/NIDM-Ex/BIDS_Data';

raw_dir = fullfile(base_dir, 'DATA', 'BIDS');
results_dir = fullfile(base_dir, 'RESULTS', 'SOFTWARE_COMPARISON');

study_dir = fullfile(raw_dir, 'ds120_R1.0.0_AMENDED');
spm_dir = fullfile(results_dir, 'ds120', 'SPM');
preproc_dir = fullfile(spm_dir, 'PREPROCESSING');
level1_dir = fullfile(spm_dir, 'LEVEL1');
level2_dir = fullfile(spm_dir, 'LEVEL2');

% Specify the subjects of interest from the raw data
subject_ids = [1,2,3,4,6,8,10,11,14,17,18,19,21,22,25,26,27];

% Specify the number of functional volumes ignored in the study
TR = 1.5;
num_ignored_volumes = 4;

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
    {'neutral', {'neutral_resp', 0}},...
    {'reward', {'reward_resp', 0}}};

create_onset_files(study_dir, onsetDir, CondNames, removed_TR_time, subject_ids);
spm('defaults','FMRI');
run_subject_level_analyses(study_dir, preproc_dir, 'template_ds120_SPM_level1', level1_dir, num_ignored_volumes, TR, subject_ids);
run_group_level_analysis(level1_dir, 'template_ds120_SPM_level2', level2_dir, '0001');
