base_dir = '/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/';
study = 'ds001';
		
study_dir = fullfile(base_dir, study);
reslice_dir = fullfile(study_dir, 'resliced_images');

if ~isdir(reslice_dir)
    mkdir(reslice_dir) 
end

afni_stat_file = fullfile(study_dir, 'AFNI', 'LEVEL2', '3dMEMA_result_t_stat_masked.nii');
afni_pos_exc_file = fullfile(study_dir, 'AFNI', 'LEVEL2', 'Positive_clustered_t_stat.nii');
afni_neg_exc_file = fullfile(study_dir, 'AFNI', 'LEVEL2', 'Negative_clustered_t_stat.nii');

gunzip(fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'stats', 'tstat1.nii.gz'));
fsl_stat_file = fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'stats', 'tstat1.nii');
gunzip(fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'thresh_zstat1.nii.gz'));
fsl_pos_exc_file = fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'thresh_zstat1.nii');
gunzip(fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'thresh_zstat2.nii.gz'));
fsl_neg_exc_file = fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'thresh_zstat2.nii');

spm_stat_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'spmT_0001.nii');
spm_pos_exc_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'spmT_0001_thresholded.nii');
spm_neg_exc_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'spmT_0002_thresholded.nii');

[afni_stat_dir, ~, ~] = fileparts(afni_stat_file);
[fsl_stat_dir, ~, ~] = fileparts(fsl_stat_file);
[fsl_exc_set_dir, ~, ~] = fileparts(fsl_pos_exc_file);
[spm_stat_dir, ~, ~] = fileparts(spm_stat_file);


reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_fsl_');
spm_reslice({afni_stat_file, fsl_stat_file}, reslice_flags);
reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_fsl_');
spm_reslice({fsl_stat_file, afni_stat_file}, reslice_flags);

reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_fsl_');
spm_reslice({afni_pos_exc_file, fsl_pos_exc_file}, reslice_flags);
reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_fsl_');
spm_reslice({fsl_pos_exc_file, afni_pos_exc_file}, reslice_flags);

reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_fsl_');
spm_reslice({afni_neg_exc_file, fsl_neg_exc_file}, reslice_flags);
reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_fsl_');
spm_reslice({fsl_neg_exc_file, afni_neg_exc_file}, reslice_flags);


reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_spm_');
spm_reslice({afni_stat_file, spm_stat_file}, reslice_flags);
reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_spm_');
spm_reslice({spm_stat_file, afni_stat_file}, reslice_flags);

reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_spm_');
spm_reslice({afni_pos_exc_file, spm_pos_exc_file}, reslice_flags);
reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_spm_');
spm_reslice({spm_pos_exc_file, afni_pos_exc_file}, reslice_flags);

reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_spm_');
spm_reslice({afni_neg_exc_file, spm_neg_exc_file}, reslice_flags);
reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_spm_');
spm_reslice({spm_neg_exc_file, afni_neg_exc_file}, reslice_flags);


reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'fsl_spm_');
spm_reslice({fsl_stat_file, spm_stat_file}, reslice_flags);
reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'fsl_spm_');
spm_reslice({spm_stat_file, fsl_stat_file}, reslice_flags);

reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'fsl_spm_');
spm_reslice({fsl_pos_exc_file, spm_pos_exc_file}, reslice_flags);
reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'fsl_spm_');
spm_reslice({spm_pos_exc_file, fsl_pos_exc_file}, reslice_flags);

reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'fsl_spm_');
spm_reslice({fsl_neg_exc_file, spm_neg_exc_file}, reslice_flags);
reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'fsl_spm_');
spm_reslice({spm_neg_exc_file, fsl_neg_exc_file}, reslice_flags);


% Files where FSL has been resliced onto AFNI
movefile(fullfile(fsl_stat_dir, 'afni_fsl_tstat1.nii'), fullfile(reslice_dir, 'afni_fsl_reslice.nii'));
movefile(fullfile(fsl_exc_set_dir, 'afni_fsl_thresh_zstat1.nii'), fullfile(reslice_dir, 'afni_fsl_reslice_pos_exc.nii'));
movefile(fullfile(fsl_exc_set_dir, 'afni_fsl_thresh_zstat2.nii'), fullfile(reslice_dir, 'afni_fsl_reslice_neg_exc.nii'));
% Files where AFNI has been resliced onto FSL
movefile(fullfile(afni_stat_dir, 'afni_fsl_3dMEMA_result_t_stat_masked.nii'), fullfile(reslice_dir, 'afni_reslice_fsl.nii'));
movefile(fullfile(afni_stat_dir, 'afni_fsl_Positive_clustered_t_stat.nii'), fullfile(reslice_dir, 'afni_reslice_fsl_pos_exc.nii'));
movefile(fullfile(afni_stat_dir, 'afni_fsl_Negative_clustered_t_stat.nii'), fullfile(reslice_dir, 'afni_reslice_fsl_neg_exc.nii'));

% Files where SPM has been resliced onto AFNI
movefile(fullfile(spm_stat_dir, 'afni_spm_spmT_0001.nii'), fullfile(reslice_dir, 'afni_spm_reslice.nii'));
movefile(fullfile(spm_stat_dir, 'afni_spm_spmT_0001_thresholded.nii'), fullfile(reslice_dir, 'afni_spm_reslice_pos_exc.nii'));
movefile(fullfile(spm_stat_dir, 'afni_spm_spmT_0002_thresholded.nii'), fullfile(reslice_dir, 'afni_spm_reslice_neg_exc.nii'));
% Files where AFNI has been resliced onto SPM
movefile(fullfile(afni_stat_dir, 'afni_spm_3dMEMA_result_t_stat_masked.nii'), fullfile(reslice_dir, 'afni_reslice_spm.nii'));
movefile(fullfile(afni_stat_dir, 'afni_spm_Positive_clustered_t_stat.nii'), fullfile(reslice_dir, 'afni_reslice_spm_pos_exc.nii'));
movefile(fullfile(afni_stat_dir, 'afni_spm_Negative_clustered_t_stat.nii'), fullfile(reslice_dir, 'afni_reslice_spm_neg_exc.nii'));

% Files where SPM has been resliced onto FSL
movefile(fullfile(spm_stat_dir, 'fsl_spm_spmT_0001.nii'), fullfile(reslice_dir, 'fsl_spm_reslice.nii'));
movefile(fullfile(spm_stat_dir, 'fsl_spm_spmT_0001_thresholded.nii'), fullfile(reslice_dir, 'fsl_spm_reslice_pos_exc.nii'));
movefile(fullfile(spm_stat_dir, 'fsl_spm_spmT_0002_thresholded.nii'), fullfile(reslice_dir, 'fsl_spm_reslice_neg_exc.nii'));
%Files where FSL has been resliced onto SPM
movefile(fullfile(fsl_stat_dir, 'fsl_spm_tstat1.nii'), fullfile(reslice_dir, 'fsl_reslice_spm.nii'));
movefile(fullfile(fsl_exc_set_dir, 'fsl_spm_thresh_zstat1.nii'), fullfile(reslice_dir, 'fsl_reslice_spm_pos_exc.nii'));
movefile(fullfile(fsl_exc_set_dir, 'fsl_spm_thresh_zstat2.nii'), fullfile(reslice_dir, 'fsl_reslice_spm_neg_exc.nii'));