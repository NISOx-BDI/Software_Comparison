function run_subject_level_analyses(raw_dir, preproc_dir, sub_template, level1_dir, num_ignored_volumes, TR, varargin)
    
    if length(varargin) == 0 
        sub_dirs = cellstr(spm_select('FPList',raw_dir, 'dir','sub-*'));
    else
        subject_ids = varargin{1};
        sub_dirs = cell(length(subject_ids),1);
        for i=1:length(subject_ids)
            sub_dirs(i,1) = cellstr(fullfile(raw_dir, sprintf('sub-%02d', subject_ids(i))));
        end
    end

    onset_dir = fullfile(preproc_dir, '..', 'ONSETS');
    func_dir = fullfile(preproc_dir, 'FUNCTIONAL');
    anat_dir = fullfile(preproc_dir, 'ANATOMICAL');
    scripts_dir = fullfile(preproc_dir, '..', 'SCRIPTS');    
    
    if ~isdir(scripts_dir)
        mkdir(scripts_dir)
    end

    for i = 1:numel(sub_dirs)
        clearvars FUNC_RUN_* ONSETS_RUN_* ANAT OUT_DIR PREPROC_DIR BRAIN_EXTRACTED BRAIN_EXTRACTED_FILE
        
        [~,sub,~] = fileparts(sub_dirs{i});
        OUT_DIR = fullfile(level1_dir, sub);
        PREPROC_DIR = anat_dir;
        BRAIN_EXTRACTED = [sub '_brain_extracted'];
        BRAIN_EXTRACTED_FILE = fullfile(PREPROC_DIR, [BRAIN_EXTRACTED '.nii']);
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
        anat_file = spm_select('FPList', anat_dir, [sub '.*\T1w.nii']);
        ANAT = anat_file;
        
        % Create the matlabbatch for this subject
        eval(sub_template);
        
        save(fullfile(scripts_dir, [strrep(sub,'^','') '_level1.mat']), 'matlabbatch');
        spm_jobman('run', matlabbatch);
    end
end