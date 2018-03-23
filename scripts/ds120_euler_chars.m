base_dir = '/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/';
study = 'ds120';

if ~exist('euler_chars', 'file')
    addpath(fullfile(fileparts(mfilename('fullpath')), 'lib'))
end 

study_dir = fullfile(base_dir, study);
spm_stat_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'spmF_0002.nii');
afni_stat_file = fullfile(study_dir, 'AFNI', 'LEVEL2', 'Group_f_stat_masked.nii');
spm_mask = fullfile(study_dir, 'SPM', 'LEVEL2', 'mask.nii');
afni_mask = fullfile(study_dir, 'AFNI', 'LEVEL2', 'mask.nii');

euler_array = {spm_stat_file, afni_stat_file};
mask_array = {spm_mask, afni_mask};


for i=1:length(euler_array)
	euler_chars_f_statistic(euler_array{i}, mask_array{i});
end