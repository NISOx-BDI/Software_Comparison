function ds109_FSL_render
	if ~exist('ds109_FSL_3drender', 'file')
	    addpath(fullfile(fileparts(mfilename('fullpath')), 'lib'))
	end

    base_dir = '/Users/maullz/Desktop/Software_Comparison';
    spm_dir = '/Users/maullz/Software/spm12';
    study = 'ds109'; 

    POS_EXCURSION_SET_FILE = fullfile(base_dir, 'input', study, 'fsl_exc_set.nii.gz');
    NEG_EXCURSION_SET_FILE = fullfile(base_dir, 'input', study, 'fsl_exc_set_neg.nii.gz');
    SPM_SURFACE_FILE = fullfile(spm_dir, 'canonical', 'cortex_20484.surf.gii');

    batch = ds109_FSL_3drender(POS_EXCURSION_SET_FILE, NEG_EXCURSION_SET_FILE, SPM_SURFACE_FILE);
    spm('defaults','FMRI');
    spm_jobman('run', batch)
end