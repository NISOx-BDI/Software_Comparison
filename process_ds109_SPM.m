base_dir = '/home/maullz/NIDM-Ex/BIDS_Data';

raw_dir = fullfile(base_dir, 'DATA', 'BIDS');
results_dir = fullfile(base_dir, 'RESULTS', 'SOFTWARE_COMPARISON');

study_dir = fullfile(raw_dir, 'ds000109_R2.0.1');
spm_dir = fullfile(results_dir, 'ds109', 'SPM');
preproc_dir = fullfile(spm_dir, 'PREPROCESSING');
level1_dir = fullfile(spm_dir, 'LEVEL1');
level2_dir = fullfile(spm_dir, 'LEVEL2');

subject_ids = [1,2,3,8,9,10,11,14,15,17,18,21,22,26,27,28,30,31,32,43,46,48,49];

num_ignored_volumes = 0;
% Specify the number of functional volumes ignored in the study

removed_TR_time = 0;
% Specify the TR that will be removed from onsets, equal to num_ignored_volumes*TR

% Add 'lib' folder to the matlab path
if ~exist('copy_gunzip', 'file')
    addpath(fullfile(fileparts(mfilename('fullpath')), 'lib'))
end

copy_gunzip(study_dir, preproc_dir);

% Directory to store the onset files
onsetDir = fullfile(spm_dir,'ONSETS');

% Define conditions and parametric modulations (if any)
% FORMAT
%   {VariableLabel,{TrialType,Durations}}
%   {{VariableLabel,VariableModLabel},{TrialType,Duration,Amplitude}}
%  
CondNames = {...
    {{'pumps_fixed','pumps_demean'}, {'pumps_demean', 0, 'pumps_demean'}},...
    {'pumps_RT', {'pumps_demean', 'response_time'}},...
    {{'cash_fixed','cash_demean'}, {'cash_demean', 0, 'cash_demean'}},...
    {'cash_RT', {'cash_demean', 'response_time'}},...
    {{'explode_fixed','explode_demean'}, {'explode_demean', 0, 'explode_demean'}},...
    {{'control_pumps_fixed','control_pumps_demean'}, {'control_pumps_demean', 0, 'control_pumps_demean'}},...
    {'control_pumps_RT', {'control_pumps_demean', 'response_time'}}};

create_onset_files(study_dir, onsetDir, CondNames, removed_TR_time);
spm('defaults','FMRI');
run_subject_level_analyses(study_dir, preproc_dir, 'template_ds001_SPM_level1', level1_dir, num_ignored_volumes);

run_group_level_analysis(level1_dir, 'template_ds001_SPM_level2', level2_dir, '0001');
