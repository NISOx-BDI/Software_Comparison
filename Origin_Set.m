path_to_bids_data = '/storage/essicd/data/NIDM-Ex/BIDS_Data/DATA/BIDS/ds001_R1.1.0';

origin_fixed = fullfile(path_to_bids_data, 'origin_fixed');
mkdir(origin_fixed)


% sub-01/anat/sub-01_T1w.nii.gz
% sub-01/func/sub-01_.*_run-01_bold.nii.gz
% sub-01/func/sub-01_.*_run-02_bold.nii.gz
% sub-01/func/sub-01_.*_run-03_bold.nii.gz

subjects = {'sub-01'};

for n = 1:numel(subjects)
    sub = subjects{n};
    
    sub_folder = fullfile(path_to_bids_data, sub);
    anat_regexp = [sub '_T1\.nii\.gz'];
    fun_regexp = [sub '.*_bold\.nii\.gz'];
    
    amri = spm_select('FPList', fullfile(sub_folder, 'anat'), anat_regexp);
    fmri = spm_select('FPList', fullfile(sub_folder, 'func'), fun_regexp);
    
    % Copy and gunzip raw data
    copyfile(amri, origin_fixed);
    amri = spm_file(amri,'path',origin_fixed);
    gunzip(amri)
    amri = strrep(amri, '.gz', '');
    for f = 1:numel(fmri)
        copyfile(fmri{f}, origin_fixed)
        fmri{f} = spm_file(fmri{f},'path',origin_fixed);
        gunzip(fmri{f})
    end
    
    % Select all volumes in all fMRI runs
    all_fmris = spm_select('ExtFPList',origin_fixed,func_regexp,Inf);

    matlabbatch = {};
    matlabbatch{1}.spm.util.imcalc.input = cellstr(all_fmris);
    
    % Compute the mean of all functional images
    matlabbatch{1}.spm.util.imcalc.output = 'mean_func.nii';
    matlabbatch{1}.spm.util.imcalc.outdir = {origin_fixed};
    matlabbatch{1}.spm.util.imcalc.expression = 'mean(X)';
    matlabbatch{1}.spm.util.imcalc.options.dtype = 16;
    
    mean_func = fullfile(origin_fixed, 'mean_func.nii');

    % Register the functional images onto the anatomical image
    matlabbatch{2}.spm.spatial.coreg.estimate.ref = {amri};
    matlabbatch{2}.spm.spatial.coreg.estimate.source = {mean_func};
    matlabbatch{2}.spm.spatial.coreg.estimate.other = {all_fmris};
    matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{2}.spm.spatial.coreg.estimate.eoptions.sep = [8 4 2];

    spm_jobman('interactive', matlabbatch);
    
end



