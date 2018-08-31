base_dir = '/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/';
study = 'ds109';

study_dir = fullfile(base_dir, study);
bold_dir = fullfile(study_dir, 'BOLD_images');

if ~isdir(bold_dir)
	mkdir(bold_dir)
end

% AFNI outputs a % percent bold image... no work needs to be done!
afni_bold_file = fullfile(study_dir, 'AFNI', 'LEVEL2', '3dMEMA_result_B.nii.gz');

% FSL files
fsl_contrast_file = fullfile(study_dir, 'FSL', 'LEVEL2', 'group.gfeat', 'cope1.feat', 'stats', 'cope1.nii.gz');
fsl_mat_file = fullfile(study_dir, 'FSL', 'LEVEL1', 'sub-01', 'temp', 'design.mat');

% SPM files
spm_contrast_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'con_0001.nii');
spm_mask_file = fullfile(study_dir, 'SPM', 'LEVEL2', 'mask.nii');
spm_mean_func_file = fullfile(study_dir, 'SPM', 'mean_mni_images', 'spm_mean_grand_mean.nii');
spm_mat_file = fullfile(study_dir, 'SPM', 'LEVEL1', 'sub-01', 'SPM.mat');

%% Create AFNI BOLD file
% Nothing to be done, just copy to directory
copyfile(afni_bold_file, fullfile(bold_dir, 'afni_bold.nii.gz'));

%% Create FSL BOLD file
% Compute regressor height from the design matrix;
% Reading the design.mat file
fsl_design = textread(fsl_mat_file, '%f', 'headerlines',5);
% Reshaping to a matrix
fsl_design = vec2mat(fsl_design, 4);
% Only looking at columns involed in the contrast
fsl_design = fsl_design(:,[2 4]);
% Since baseline =/= 0, we get the regressor height as max(regressor) - baseline; 
regressor_height = max(fsl_design(:)) - fsl_design(1,1);

V = spm_vol(fsl_contrast_file);
X = spm_read_vols(V);
Binout = V(1);
Binout.fname = fullfile(bold_dir, 'fsl_bold.nii');

% Using the formula BOLD = Contrast*(100/B); B = median brain intensity
% For FSL, B = 10000
Bin = X/100*regressor_height;

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

% Compute regressor height from the design matrix;
spm_mat = load(spm_mat_file);
spm_design = spm_mat.SPM.xX.X;
% Only looking at columns involved in the contrast
spm_design = spm_design(:, [1,3,11,13]);
regressor_height = max(spm_design(:));

% Creating SPM BOLD file
V = spm_vol(spm_contrast_file);
X = spm_read_vols(V);
Binout = V(1);
Binout.fname = fullfile(bold_dir, 'spm_bold.nii');

% Using the formula BOLD = Contrast*(100/B)*regressor_height; B = median brain intensity
% We divide by the number of runs (2) to compensate that sessions are combined in a single contrast in SPM.
Bin = X*(100/B)*regressor_height/2;

% Write image
spm_write_vol(Binout, Bin);



