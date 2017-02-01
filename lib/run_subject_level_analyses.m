function run_subject_level_analyses(raw_dir, preproc_dir, sub_template, level1_dir, num_ignored_volumes, TR)
    sub_dirs = cellstr(spm_select('FPList',raw_dir, 'dir','sub-*'));

    onset_dir = fullfile(preproc_dir, '..', 'ONSETS');
    func_dir = fullfile(preproc_dir, 'FUNCTIONAL');
    anat_dir = fullfile(preproc_dir, 'ANATOMICAL');
    scripts_dir = fullfile(preproc_dir, '..', 'SCRIPTS');    
    
    if ~isdir(scripts_dir)
        mkdir(scripts_dir)
    end

    for i = 1:numel(sub_dirs)
        clearvars FUNC_RUN_* ONSETS_RUN_* ANAT OUT_DIR PREPROC_DIR
        
        sub = ['sub-' sprintf('%02d',i)];
        OUT_DIR = fullfile(level1_dir, sub);
        PREPROC_DIR = anat_dir;
        sub = ['^' sub];
        
        fmri_files = cellstr(spm_select('List', func_dir, [sub '.*\.nii$']));
        for r = 1:numel(fmri_files)
            sub_run = [sub '.*_run-' sprintf('%02d',r)];
            fmris = cellstr(spm_select('ExtFPList', func_dir, [sub_run '.*\.nii'], Inf)); 
            fmris = fmris(num_ignored_volumes+1:end);
            eval(['FUNC_RUN_' num2str(r) ' =  fmris;']);
            onset_file = spm_select('FPList', onset_dir, [sub_run '.*\.mat']);
            eval(['ONSETS_RUN_' num2str(r) ' = onset_file;']);
        end
        anat_file = spm_select('FPList', anat_dir, [sub '.*\.nii']);
        ANAT = anat_file;
        
        % Create the matlabbatch for this subject
        eval(sub_template);
        
        save(fullfile(scripts_dir, [strrep(sub,'^','') '_level1.mat']), 'matlabbatch');
        spm_jobman('interactive', matlabbatch);
    end
end