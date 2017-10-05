base_dir = '/Users/maullz/Desktop/Software_Comparison/';
study = 'ds001';
		
if ~exist('euler_chars', 'file')
    addpath(fullfile(fileparts(mfilename('fullpath')), 'lib'))
end 

study_dir = fullfile(base_dir, study);
spm_stat_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'spmT_0001.nii');
fsl_stat_file = fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'stats', 'tstat1.nii.gz');
afni_stat_file = fullfile(study_dir, 'AFNI', 'LEVEL2', '3dMEMA_result_t_stat_masked.nii');
spm_perm_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'permutation_test', 'snpmT+.img');
fsl_perm_file = fullfile(study_dir, 'FSL', 'LEVEL2', 'permutation_test', 'OneSampT_pos_tstat1.nii');
afni_perm_file = fullfile(study_dir, 'AFNI', 'LEVEL2', 'permutation_test', 'perm_ttest++_Clustsim_result_t_stat_masked.nii');
euler_array = {spm_stat_file, fsl_stat_file, afni_stat_file, spm_perm_file, fsl_perm_file, afni_perm_file};


for i=1:length(euler_array)
	euler_chars(euler_array{i});
end