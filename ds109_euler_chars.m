base_dir = '/Users/maullz/Desktop/Software_Comparison/';
study = 'ds109';
		
study_dir = fullfile(base_dir, study);
spm_stat_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'spmT_0001.nii');
fsl_stat_file = fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'stats', 'tstat1.nii.gz');
afni_stat_file = fullfile(study_dir, 'AFNI', 'LEVEL2', '3dMEMA_result_t_stat_masked.nii');
stat_file_array = {spm_stat_file, fsl_stat_file, afni_stat_file};

for i=1:length(stat_file_array)
	euler_chars(stat_file_array{i});
end