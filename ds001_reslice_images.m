base_dir = '/Users/maullz/Desktop/Software_Comparison';
study = 'ds001';
		
study_dir = fullfile(base_dir, study);
reslice_dir = fullfile(study_dir, 'resliced_images');

if ~isdir(reslice_dir)
    mkdir(reslice_dir) 
end

%% AFNI t-statistic and excursion set files
afni_stat_file = fullfile(study_dir, 'AFNI', 'LEVEL2', '3dMEMA_result_t_stat_masked.nii');
afni_pos_exc_file = fullfile(study_dir, 'AFNI', 'LEVEL2', 'Positive_clustered_t_stat.nii');
afni_neg_exc_file = fullfile(study_dir, 'AFNI', 'LEVEL2', 'Negative_clustered_t_stat.nii');

%% AFNI permutation test files
afni_perm_stat_file = fullfile(study_dir, 'AFNI', 'LEVEL2', 'permutation_test', 'perm_ttest++_Clustsim_result_t_stat_masked.nii');
afni_perm_pos_exc_file = fullfile(study_dir, 'AFNI', 'LEVEL2', 'permutation_test', 'perm_Positive_clustered_t_stat.nii');
afni_perm_neg_exc_file = fullfile(study_dir, 'AFNI', 'LEVEL2', 'permutation_test', 'perm_Negative_clustered_t_stat.nii');


%% FSL t-statistic and excursion set files
gunzip(fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'stats', 'tstat1.nii.gz'));
fsl_stat_file = fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'stats', 'tstat1.nii');
gunzip(fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'thresh_zstat1.nii.gz'));
fsl_pos_exc_file = fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'thresh_zstat1.nii');
gunzip(fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'thresh_zstat2.nii.gz'));
fsl_neg_exc_file = fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'thresh_zstat2.nii');

%% FSL permutation test files
gunzip(fullfile(study_dir, 'FSL', 'LEVEL2', 'permutation_test', 'OneSampT_tstat1.nii.gz'));
fsl_perm_stat_file = fullfile(study_dir, 'FSL', 'LEVEL2', 'permutation_test', 'OneSampT_tstat1.nii');
gunzip(fullfile(study_dir, 'FSL', 'LEVEL2', 'permutation_test', '05FWECorrected_OneSampT_pos_exc_set.nii.gz'));
fsl_perm_pos_exc_file = fullfile(study_dir, 'FSL', 'LEVEL2', 'permutation_test', '05FWECorrected_OneSampT_pos_exc_set.nii');
gunzip(fullfile(study_dir, 'FSL', 'LEVEL2', 'permutation_test', '05FWECorrected_OneSampT_neg_exc_set.nii.gz'));
fsl_perm_neg_exc_file = fullfile(study_dir, 'FSL', 'LEVEL2', 'permutation_test', '05FWECorrected_OneSampT_neg_exc_set.nii');


%% SPM t-statistic and excursion set files
spm_stat_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'spmT_0001.nii');
spm_pos_exc_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'spmT_0001_thresholded.nii');
spm_neg_exc_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'spmT_0002_thresholded.nii');

%% SPM permutation test files
spm_perm_stat_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'permutation_test', 'snpmT+.img');
spm_perm_pos_exc_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'permutation_test', 'SnPM_pos_filtered.nii');
spm_perm_neg_exc_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'permutation_test', 'SnPM_neg_filtered.nii');

%% t-statistics directories
[afni_stat_dir, ~, ~] = fileparts(afni_stat_file);
[fsl_stat_dir, ~, ~] = fileparts(fsl_stat_file);
[fsl_exc_set_dir, ~, ~] = fileparts(fsl_pos_exc_file);
[spm_stat_dir, ~, ~] = fileparts(spm_stat_file);
[afni_perm_dir, ~, ~] = fileparts(afni_perm_stat_file);
[fsl_perm_dir, ~, ~] = fileparts(fsl_perm_stat_file);
[spm_perm_dir, ~, ~] = fileparts(spm_perm_stat_file);


%% Reslicing t-statistic and excursion set images
% AFNI/FSL reslicing
reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_fsl_');
spm_reslice({afni_stat_file, fsl_stat_file}, reslice_flags);
spm_reslice({fsl_stat_file, afni_stat_file}, reslice_flags);

spm_reslice({afni_pos_exc_file, fsl_pos_exc_file}, reslice_flags);
spm_reslice({fsl_pos_exc_file, afni_pos_exc_file}, reslice_flags);

spm_reslice({afni_neg_exc_file, fsl_neg_exc_file}, reslice_flags);
spm_reslice({fsl_neg_exc_file, afni_neg_exc_file}, reslice_flags);

%% AFNI/FSL permutations
spm_reslice({afni_perm_stat_file, fsl_perm_stat_file}, reslice_flags);
spm_reslice({fsl_perm_stat_file, afni_perm_stat_file}, reslice_flags);

spm_reslice({afni_perm_pos_exc_file, fsl_perm_pos_exc_file}, reslice_flags);
spm_reslice({fsl_perm_pos_exc_file, afni_perm_pos_exc_file}, reslice_flags);

spm_reslice({afni_perm_neg_exc_file, fsl_perm_neg_exc_file}, reslice_flags);
spm_reslice({fsl_perm_neg_exc_file, afni_perm_neg_exc_file}, reslice_flags);

% AFNI/SPM reslicing
reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_spm_');
spm_reslice({afni_stat_file, spm_stat_file}, reslice_flags);
spm_reslice({spm_stat_file, afni_stat_file}, reslice_flags);

spm_reslice({afni_pos_exc_file, spm_pos_exc_file}, reslice_flags);
spm_reslice({spm_pos_exc_file, afni_pos_exc_file}, reslice_flags);

spm_reslice({afni_neg_exc_file, spm_neg_exc_file}, reslice_flags);
spm_reslice({spm_neg_exc_file, afni_neg_exc_file}, reslice_flags);

%% AFNI/SPM permutations
spm_reslice({afni_perm_stat_file, spm_perm_stat_file}, reslice_flags);
spm_reslice({spm_perm_stat_file, afni_perm_stat_file}, reslice_flags);

spm_reslice({afni_perm_pos_exc_file, spm_perm_pos_exc_file}, reslice_flags);
spm_reslice({spm_perm_pos_exc_file, afni_perm_pos_exc_file}, reslice_flags);

spm_reslice({afni_perm_neg_exc_file, spm_perm_neg_exc_file}, reslice_flags);
spm_reslice({spm_perm_neg_exc_file, afni_perm_neg_exc_file}, reslice_flags);

% FSL/SPM reslicing
reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'fsl_spm_');
spm_reslice({fsl_stat_file, spm_stat_file}, reslice_flags);
spm_reslice({spm_stat_file, fsl_stat_file}, reslice_flags);

spm_reslice({fsl_pos_exc_file, spm_pos_exc_file}, reslice_flags);
spm_reslice({spm_pos_exc_file, fsl_pos_exc_file}, reslice_flags);

spm_reslice({fsl_neg_exc_file, spm_neg_exc_file}, reslice_flags);
spm_reslice({spm_neg_exc_file, fsl_neg_exc_file}, reslice_flags);

%% FSL/SPM permutations
spm_reslice({fsl_perm_stat_file, spm_perm_stat_file}, reslice_flags);
spm_reslice({spm_perm_stat_file, fsl_perm_stat_file}, reslice_flags);

spm_reslice({fsl_perm_pos_exc_file, spm_perm_pos_exc_file}, reslice_flags);
spm_reslice({spm_perm_pos_exc_file, fsl_perm_pos_exc_file}, reslice_flags);

spm_reslice({fsl_perm_neg_exc_file, spm_perm_neg_exc_file}, reslice_flags);
spm_reslice({spm_perm_neg_exc_file, fsl_perm_neg_exc_file}, reslice_flags);


% Files where FSL has been resliced onto AFNI
movefile(fullfile(fsl_stat_dir, 'afni_fsl_tstat1.nii'), fullfile(reslice_dir, 'afni_fsl_reslice.nii'));
movefile(fullfile(fsl_exc_set_dir, 'afni_fsl_thresh_zstat1.nii'), fullfile(reslice_dir, 'afni_fsl_reslice_pos_exc.nii'));
movefile(fullfile(fsl_exc_set_dir, 'afni_fsl_thresh_zstat2.nii'), fullfile(reslice_dir, 'afni_fsl_reslice_neg_exc.nii'));

%% Permutations
movefile(fullfile(fsl_perm_dir, 'afni_fsl_OneSampT_pos_tstat1.nii'), fullfile(reslice_dir, 'afni_fsl_reslice_perm.nii'));
movefile(fullfile(fsl_perm_dir, 'afni_fsl_05FWECorrected_OneSampT_pos_exc_set.nii'), fullfile(reslice_dir, 'afni_fsl_reslice_pos_exc_perm.nii'));
movefile(fullfile(fsl_perm_dir, 'afni_fsl_05FWECorrected_OneSampT_neg_exc_set.nii'), fullfile(reslice_dir, 'afni_fsl_reslice_neg_exc_perm.nii'));


% Files where AFNI has been resliced onto FSL
movefile(fullfile(afni_stat_dir, 'afni_fsl_3dMEMA_result_t_stat_masked.nii'), fullfile(reslice_dir, 'afni_reslice_fsl.nii'));
movefile(fullfile(afni_stat_dir, 'afni_fsl_Positive_clustered_t_stat.nii'), fullfile(reslice_dir, 'afni_reslice_fsl_pos_exc.nii'));
movefile(fullfile(afni_stat_dir, 'afni_fsl_Negative_clustered_t_stat.nii'), fullfile(reslice_dir, 'afni_reslice_fsl_neg_exc.nii'));

%% Permutations
movefile(fullfile(afni_perm_dir, 'afni_fsl_perm_ttest++_Clustsim_result_t_stat_masked.nii'), fullfile(reslice_dir, 'afni_reslice_fsl_perm.nii'));
movefile(fullfile(afni_perm_dir, 'afni_fsl_perm_Positive_clustered_t_stat.nii'), fullfile(reslice_dir, 'afni_reslice_fsl_pos_exc_perm.nii'));
movefile(fullfile(afni_perm_dir, 'afni_fsl_perm_Negative_clustered_t_stat.nii'), fullfile(reslice_dir, 'afni_reslice_fsl_neg_exc_perm.nii'));


% Files where SPM has been resliced onto AFNI
movefile(fullfile(spm_stat_dir, 'afni_spm_spmT_0001.nii'), fullfile(reslice_dir, 'afni_spm_reslice.nii'));
movefile(fullfile(spm_stat_dir, 'afni_spm_spmT_0001_thresholded.nii'), fullfile(reslice_dir, 'afni_spm_reslice_pos_exc.nii'));
movefile(fullfile(spm_stat_dir, 'afni_spm_spmT_0002_thresholded.nii'), fullfile(reslice_dir, 'afni_spm_reslice_neg_exc.nii'));

%% Permutations
movefile(fullfile(spm_perm_dir, 'afni_spm_snpmT+.img'), fullfile(reslice_dir, 'afni_spm_reslice_perm.img'));
movefile(fullfile(spm_perm_dir, 'afni_spm_snpmT+.hdr'), fullfile(reslice_dir, 'afni_spm_reslice_perm.hdr'));
movefile(fullfile(spm_perm_dir, 'afni_spm_SnPM_pos_filtered.nii'), fullfile(reslice_dir, 'afni_spm_reslice_pos_exc_perm.nii'));
movefile(fullfile(spm_perm_dir, 'afni_spm_SnPM_neg_filtered.nii'), fullfile(reslice_dir, 'afni_spm_reslice_neg_exc_perm.nii'));


% Files where AFNI has been resliced onto SPM
movefile(fullfile(afni_stat_dir, 'afni_spm_3dMEMA_result_t_stat_masked.nii'), fullfile(reslice_dir, 'afni_reslice_spm.nii'));
movefile(fullfile(afni_stat_dir, 'afni_spm_Positive_clustered_t_stat.nii'), fullfile(reslice_dir, 'afni_reslice_spm_pos_exc.nii'));
movefile(fullfile(afni_stat_dir, 'afni_spm_Negative_clustered_t_stat.nii'), fullfile(reslice_dir, 'afni_reslice_spm_neg_exc.nii'));

%% Permutations
movefile(fullfile(afni_perm_dir, 'afni_spm_perm_ttest++_Clustsim_result_t_stat_masked.nii'), fullfile(reslice_dir, 'afni_reslice_spm_perm.nii'));
movefile(fullfile(afni_perm_dir, 'afni_spm_perm_Positive_clustered_t_stat.nii'), fullfile(reslice_dir, 'afni_reslice_spm_pos_exc_perm.nii'));
movefile(fullfile(afni_perm_dir, 'afni_spm_perm_Negative_clustered_t_stat.nii'), fullfile(reslice_dir, 'afni_reslice_spm_neg_exc_perm.nii'));


% Files where SPM has been resliced onto FSL
movefile(fullfile(spm_stat_dir, 'fsl_spm_spmT_0001.nii'), fullfile(reslice_dir, 'fsl_spm_reslice.nii'));
movefile(fullfile(spm_stat_dir, 'fsl_spm_spmT_0001_thresholded.nii'), fullfile(reslice_dir, 'fsl_spm_reslice_pos_exc.nii'));
movefile(fullfile(spm_stat_dir, 'fsl_spm_spmT_0002_thresholded.nii'), fullfile(reslice_dir, 'fsl_spm_reslice_neg_exc.nii'));

%% Permutations
movefile(fullfile(spm_perm_dir, 'fsl_spm_snpmT+.img'), fullfile(reslice_dir, 'fsl_spm_reslice_perm.img'));
movefile(fullfile(spm_perm_dir, 'fsl_spm_snpmT+.hdr'), fullfile(reslice_dir, 'fsl_spm_reslice_perm.hdr'));
movefile(fullfile(spm_perm_dir, 'fsl_spm_SnPM_pos_filtered.nii'), fullfile(reslice_dir, 'fsl_spm_reslice_pos_exc_perm.nii'));
movefile(fullfile(spm_perm_dir, 'fsl_spm_SnPM_neg_filtered.nii'), fullfile(reslice_dir, 'fsl_spm_reslice_neg_exc_perm.nii'));


%Files where FSL has been resliced onto SPM
movefile(fullfile(fsl_stat_dir, 'fsl_spm_tstat1.nii'), fullfile(reslice_dir, 'fsl_reslice_spm.nii'));
movefile(fullfile(fsl_exc_set_dir, 'fsl_spm_thresh_zstat1.nii'), fullfile(reslice_dir, 'fsl_reslice_spm_pos_exc.nii'));
movefile(fullfile(fsl_exc_set_dir, 'fsl_spm_thresh_zstat2.nii'), fullfile(reslice_dir, 'fsl_reslice_spm_neg_exc.nii'));

%% Permutations
movefile(fullfile(fsl_perm_dir, 'fsl_spm_OneSampT_pos_tstat1.nii'), fullfile(reslice_dir, 'fsl_reslice_spm_perm.nii'));
movefile(fullfile(fsl_perm_dir, 'fsl_spm_05FWECorrected_OneSampT_pos_exc_set.nii'), fullfile(reslice_dir, 'fsl_reslice_spm_pos_exc_perm.nii'));
movefile(fullfile(fsl_perm_dir, 'fsl_spm_05FWECorrected_OneSampT_neg_exc_set.nii'), fullfile(reslice_dir, 'fsl_reslice_spm_neg_exc_perm.nii'));
