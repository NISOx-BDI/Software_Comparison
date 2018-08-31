base_dir = '/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/';
study = 'ds001';

study_dir = fullfile(base_dir, study);
bold_dir = fullfile(study_dir, 'BOLD_images');

if ~isdir(bold_dir)
	mkdir(bold_dir)
end

% AFNI outputs a % percent bold image... no work needs to be done!
afni_bold_file = fullfile(study_dir, 'AFNI', 'LEVEL2', '3dMEMA_result_B.nii.gz');

% FSL files
fsl_contrast_file = fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'stats', 'cope1.nii.gz');

% SPM files
spm_contrast_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'con_0001.nii');
spm_mask_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'mask.nii');
spm_mean_func_file = fullfile(study_dir, 'SPM', 'mean_mni_images', 'spm_mean_grand_mean.nii');

%% Create AFNI BOLD file
% Nothing to be done, just copy to directory
copyfile(afni_bold_file, fullfile(bold_dir, 'afni_bold.nii.gz'));

%% Create FSL BOLD file
V = spm_vol(fsl_contrast_file);
X = spm_read_vols(V);
Binout = V(1);
Binout.fname = fullfile(bold_dir, 'fsl_bold.nii');

% Using the formula BOLD = Contrast*(100/B); B = median brain intensity
% For FSL, B = 10000
% Regressor height as 0.338 approximated by looking at the height of an isolated event in the design matrix
Bin = X/100*0.338;

% Write image
spm_write_vol(Binout, Bin);

%% Create SPM BOLD file
% Compute median brain intensity of mean anatomical image
V = spm_vol(spm_mean_func_file);
X = spm_read_vols(V);
Mask = spm_vol(spm_mask_file);
M = spm_read_vols(Mask);
X(M==0) = NaN;
% Getting the median brain intesity
B = nanmedian(X(:));

% Creating SPM BOLD file
V = spm_vol(spm_contrast_file);
X = spm_read_vols(V);
Binout = V(1);
Binout.fname = fullfile(bold_dir, 'spm_bold.nii');

% Using the formula BOLD = Contrast*(100/B)*regressor_height; B = median brain intensity
% Regressor height as 0.3421 approximated by looking at the height of an isolated event in the design matrix
Bin = X*(100/B)*0.3421;

% Write image
spm_write_vol(Binout, Bin);
