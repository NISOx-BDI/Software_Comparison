% _________________________________________________________________________
% Copy to 'preproc_dir' and gunzip anatomical and fmri files found in 
% 'study_dir' (and organised according to BIDS)
% _________________________________________________________________________
function copy_gunzip(study_dir, preproc_dir, varargin)
    
    if length(varargin) == 0 
        sub_dirs = cellstr(spm_select('FPList', study_dir, 'dir', 'sub-*'));
    else
        subject_ids = varargin{1};
        sub_dirs = cell(length(subject_ids),1);
        for i=1:length(subject_ids)
            sub_dirs(i,1) = cellstr(spm_select('FPList', study_dir, 'dir', sprintf('sub-%02d',subject_ids(i))));
        end
    end

    if ~isdir(preproc_dir)
        mkdir(preproc_dir)
    end
    
    matlabbatch = cell(0);
    for n = 1:numel(sub_dirs)
        sub_folder = sub_dirs{n};
        anat_regexp = ['.*_T1w\.nii\.gz'];
        fun_regexp = ['.*_bold\.nii\.gz'];

        amri = spm_select('FPList', fullfile(sub_folder, 'anat'), anat_regexp);
        fmri = cellstr(spm_select('FPList', fullfile(sub_folder, 'func'), fun_regexp));
               
        % Copy the anatomical image
        anat_preproc_dir = fullfile(preproc_dir, 'ANATOMICAL');
        if ~isdir(anat_preproc_dir)
            mkdir(anat_preproc_dir)
        end        
        matlabbatch{end+1}.cfg_basicio.file_dir.file_ops.file_move.files = {amri};
        matlabbatch{end}.cfg_basicio.file_dir.file_ops.file_move.action.copyto = {anat_preproc_dir};
        amri = spm_file(amri, 'path', anat_preproc_dir);
            
        % For each run, copy the fmri image       
        func_preproc_dir = fullfile(preproc_dir, 'FUNCTIONAL');
        if ~isdir(func_preproc_dir)
            mkdir(func_preproc_dir)
        end                
        for r = 1:numel(fmri)
            matlabbatch{end+1}.cfg_basicio.file_dir.file_ops.file_move.files = {fmri{r}};
            matlabbatch{end}.cfg_basicio.file_dir.file_ops.file_move.action.copyto = {func_preproc_dir};
            fmri{r} = spm_file(fmri{r}, 'path', func_preproc_dir);
        end

        % Gunzip anat image
        matlabbatch{end+1}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = {amri};
        matlabbatch{end}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
        matlabbatch{end}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = false;
        
        % Gunzip fmri images
        for r = 1:numel(fmri)
            matlabbatch{end+1}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = fmri(r);
            matlabbatch{end}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
            matlabbatch{end}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = false;        
        end

    end
    spm_jobman('run', matlabbatch);    

end
