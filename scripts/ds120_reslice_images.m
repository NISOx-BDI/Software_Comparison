base_dir = '/Users/maullz/Desktop/Software_Comparison';
study = 'ds120';
		
study_dir = fullfile(base_dir, study);
reslice_dir = fullfile(study_dir, 'resliced_images');

if ~isdir(reslice_dir)
    mkdir(reslice_dir) 
end

afni_stat_file = fullfile(study_dir, 'AFNI', 'LEVEL2', 'Group_f_stat_masked.nii');
afni_exc_set_file = fullfile(study_dir, 'AFNI', 'LEVEL2', 'Positive_clustered_f_stat.nii');

spm_stat_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'spmF_0002.nii');
spm_exc_set_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'spmF_0002_thresholded.nii');

[afni_stat_dir, ~, ~] = fileparts(afni_stat_file);
[spm_stat_dir, ~, ~] = fileparts(spm_stat_file);

reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_spm_');
spm_reslice({afni_stat_file, spm_stat_file}, reslice_flags);
reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_spm_');
spm_reslice({spm_stat_file, afni_stat_file}, reslice_flags);

reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_spm_');
spm_reslice({afni_exc_set_file, spm_exc_set_file}, reslice_flags);
reslice_flags = struct('mask', true, 'mean', false, 'interp', 0, 'which', 1, 'wrap', [1 1 0], 'prefix', 'afni_spm_');
spm_reslice({spm_exc_set_file, afni_exc_set_file}, reslice_flags);

% Files where SPM has been resliced onto AFNI
movefile(fullfile(spm_stat_dir, 'afni_spm_spmF_0002.nii'), fullfile(reslice_dir, 'afni_spm_reslice.nii'));
movefile(fullfile(spm_stat_dir, 'afni_spm_spmF_0002_thresholded.nii'), fullfile(reslice_dir, 'afni_spm_reslice_exc.nii'));
% Files where AFNI has been resliced onto SPM
movefile(fullfile(afni_stat_dir, 'afni_spm_Group_f_stat_masked.nii'), fullfile(reslice_dir, 'afni_reslice_spm.nii'));
movefile(fullfile(afni_stat_dir, 'afni_spm_Positive_clustered_f_stat.nii'), fullfile(reslice_dir, 'afni_reslice_spm_exc.nii'));
