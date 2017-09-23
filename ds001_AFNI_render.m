function ds001_AFNI_render
	if ~exist('ds001_3drender', 'file')
	    addpath(fullfile(fileparts(mfilename('fullpath')), 'render_lib'))
	end

    base_dir = '/Users/maullz/Desktop/Software_Comparison';
    spm_dir = '/Users/maullz/Software/spm12';
    study = 'ds001'; 

    POS_EXCURSION_SET_FILE = fullfile(base_dir, 'input', study, 'afni_exc_set_pos.nii.gz');
    NEG_EXCURSION_SET_FILE = fullfile(base_dir, 'input', study, 'afni_exc_set_neg.nii.gz');
    SPM_SURFACE_FILE = fullfile(spm_dir, 'canonical', 'cortex_20484.surf.gii');

    batch = ds001_3drender(POS_EXCURSION_SET_FILE, NEG_EXCURSION_SET_FILE, SPM_SURFACE_FILE);
    spm('defaults','FMRI');
    spm_jobman('run', batch)
end