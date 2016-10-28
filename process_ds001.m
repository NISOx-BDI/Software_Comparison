base_dir = '/home/maullz/NIDM-Ex/BIDS_Data';

raw_dir = fullfile(base_dir, 'DATA', 'BIDS');
results_dir = fullfile(base_dir, 'RESULTS', 'SOFTWARE_COMPARISON');

study_dir = fullfile(raw_dir, 'ds000001_R2.0.3');
spm_dir = fullfile(results_dir, 'ds001', 'SPM');
preproc_dir = fullfile(spm_dir, 'PREPROCESSING');
level1_dir = fullfile(spm_dir, 'LEVEL1');
level2_dir = fullfile(spm_dir, 'LEVEL2');

% Add 'lib' folder to the matlab path
if ~exist('copy_gunzip', 'file')
    addpath(fullfile(fileparts(mfilename('fullpath')), 'lib'))
end

copy_gunzip(study_dir, preproc_dir);

% Directory to store the onset files
onsetDir = fullfile(results_dir,'ds001','SPM','ONSETS');

% Define conditions and parametric modulations (if any)
CondNames = {...
    {{'pumps_fixed','pumps_demean'}, {'pumps_demean'}},...
    {'pumps_RT', {'pumps_demean', 'response_time'}},...
    {{'cash_fixed','cash_demean'}, {'cash_demean'}},...
    {'cash_RT', {'cash_demean', 'response_time'}},...
    {{'explode_fixed','explode_demean'}, {'explode_demean'}},...
    {{'control_pumps_fixed','control_pumps_demean'}, {'control_pumps_demean'}},...
    {'control_pumps_RT', {'control_pumps_demean', 'response_time'}}};

create_onset_files(study_dir, onsetDir, CondNames);
spm('defaults','FMRI');
run_subject_level_analyses(raw_dir, preproc_dir, 'template_ds001_SPM_level1', level1_dir);

run_group_level_analysis(level1_dir, 'template_ds001_SPM_level2', level2_dir, '0001');
