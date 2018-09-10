base_dir = '/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/';
study = 'ds120';
% Find degrees of freedom in 2nd-level results
spm_dof1 = 8;
spm_dof2 = 142;
afni_dof1 = 7;
afni_dof2 = 98;

if ~exist('r_squared_maps', 'file')
    addpath(fullfile(fileparts(mfilename('fullpath')), 'lib'))
end 

study_dir = fullfile(base_dir, study);
spm_stat_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'spmF_0002.nii');
afni_stat_file = fullfile(study_dir, 'AFNI', 'LEVEL2', 'Group_f_stat_masked.nii.gz');
spm_mask = fullfile(study_dir, 'SPM', 'LEVEL2', 'mask.nii');
afni_mask = fullfile(study_dir, 'AFNI', 'LEVEL2', 'mask.nii.gz');

% Creating r_squared_maps, degrees of freedom obtained from second level results
r_squared_maps(afni_stat_file, afni_mask, afni_dof1, afni_dof2, study_dir);
r_squared_maps(spm_stat_file, spm_mask, spm_dof1, spm_dof2, study_dir);

