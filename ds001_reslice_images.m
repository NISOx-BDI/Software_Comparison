base_dir = '/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/';
study = 'ds001';
		
study_dir = fullfile(base_dir, study);
reslice_dir = fullfile(study_dir, 'resliced_images');

if ~isdir(reslice_dir)
    mkdir(reslice_dir) 
end

afni_stat_file = fullfile(study_dir, 'AFNI', 'LEVEL2', '3dMEMA_result_t_stat_masked.nii');
gunzip(fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'stats', 'tstat1.nii.gz'));
fsl_stat_file = fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'stats', 'tstat1.nii');
spm_stat_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'spmT_0001.nii');

[afni_stat_dir, ~, ~] = fileparts(afni_stat_file);
[fsl_stat_dir, ~, ~] = fileparts(fsl_stat_file);
[spm_stat_dir, ~, ~] = fileparts(spm_stat_file);


reslice_flags = struct('mask', false, 'mean', false, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_fsl_');
spm_reslice({afni_stat_file, fsl_stat_file}, reslice_flags);

reslice_flags = struct('mask', false, 'mean', false, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_spm_');
spm_reslice({afni_stat_file, spm_stat_file}, reslice_flags);

reslice_flags = struct('mask', false, 'mean', false, 'which', 1, 'wrap', [1 1 0], 'prefix', 'fsl_spm_');
spm_reslice({fsl_stat_file, spm_stat_file}, reslice_flags);

movefile(fullfile(fsl_stat_dir, 'afni_fsl_tstat1.nii'), fullfile(reslice_dir, 'afni_fsl_reslice.nii'));
movefile(fullfile(spm_stat_dir, 'afni_spm_spmT_0001.nii'), fullfile(reslice_dir, 'afni_spm_reslice.nii'));
movefile(fullfile(spm_stat_dir, 'fsl_spm_spmT_0001.nii'), fullfile(reslice_dir, 'fsl_spm_reslice.nii'));