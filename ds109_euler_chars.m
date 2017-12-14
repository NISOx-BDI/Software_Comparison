base_dir = '/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/';
study = 'ds109';

if ~exist('euler_chars', 'file')
    addpath(fullfile(fileparts(mfilename('fullpath')), 'lib'))
end 

study_dir = fullfile(base_dir, study);
spm_stat_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'spmT_0001.nii');
fsl_stat_file = fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'stats', 'tstat1.nii.gz');
afni_stat_file = fullfile(study_dir, 'AFNI', 'LEVEL2', '3dMEMA_result_t_stat_masked.nii');
spm_perm_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'permutation_test', 'snpmT+.img');
fsl_perm_file = fullfile(study_dir, 'FSL', 'LEVEL2', 'permutation_test', 'OneSampT_tstat1.nii.gz');
afni_perm_file = fullfile(study_dir, 'AFNI', 'LEVEL2', 'permutation_test', 'perm_ttest++_Clustsim_result_t_stat_masked.nii');
spm_mask = fullfile(study_dir, 'SPM', 'LEVEL2', 'mask.nii');
fsl_mask = fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'mask.nii.gz');
afni_mask = fullfile(study_dir, 'AFNI', 'LEVEL2', 'mask.nii');

euler_array = {spm_stat_file, fsl_stat_file, afni_stat_file, spm_perm_file, fsl_perm_file, afni_perm_file};
mask_array = {spm_mask, fsl_mask, afni_mask, spm_mask, fsl_mask, afni_mask};


for i=1:length(euler_array)
	euler_chars(euler_array{i}, mask_array{i});
end
