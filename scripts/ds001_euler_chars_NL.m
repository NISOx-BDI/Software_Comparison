base_dir = '/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/';
study = 'ds001';
DF = 16-1;
		
if ~exist('euler_chars', 'file')
    addpath(fullfile(fileparts(mfilename('fullpath')), 'lib'))
end 

study_dir = fullfile(base_dir, study);
spm_stat_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'spmT_0001.nii');
fsl_stat_file = fullfile(study_dir, 'FSL_NL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'stats', 'tstat1.nii.gz');
afni_stat_file = fullfile(study_dir, 'AFNI_NL', 'LEVEL2', '3dMEMA_result_t_stat_masked.nii.gz');
spm_perm_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'permutation_test', 'snpmT+.img');
fsl_perm_file = fullfile(study_dir, 'FSL_NL', 'LEVEL2', 'permutation_test', 'OneSampT_tstat1.nii.gz');
afni_perm_file = fullfile(study_dir, 'AFNI_NL', 'LEVEL2', 'permutation_test', 'perm_ttest++_Clustsim_result_t_stat_masked.nii.gz');
spm_mask = fullfile(study_dir, 'SPM', 'LEVEL2', 'mask.nii');
fsl_mask = fullfile(study_dir, 'FSL_NL', 'LEVEL2', 'group.gfeat', 'mask.nii.gz');
afni_mask = fullfile(study_dir, 'AFNI_NL', 'LEVEL2', 'mask.nii.gz');

euler_array = {fsl_stat_file, afni_stat_file, fsl_perm_file};
mask_array  = {fsl_mask,      afni_mask,      fsl_mask     };


for i=1:length(euler_array)
	euler_chars(euler_array{i}, mask_array{i});
end

euler_chars(afni_perm_file,afni_mask,DF);
