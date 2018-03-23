function run_permutation_test(level1_dir, group_batch_template, perm_dir, contrast_id)
    sub_dirs = cellstr(spm_select('FPList',level1_dir, 'dir','sub-*'));

    scripts_dir = fullfile(level1_dir, '..', 'SCRIPTS');
    
    LEVEL1_DIR = level1_dir;
    OUT_DIR = perm_dir;
    
    if ~isdir(scripts_dir)
        mkdir(scripts_dir)
    end
    
    num_sub = numel(sub_dirs);
    CON_FILES = cell(num_sub,0);
    for i = 1:num_sub
        CON_FILES{i,1} = spm_select(...
            'FPList', sub_dirs{i}, ['con_' contrast_id '\.nii']);
    end

    % Create the matlabbatch for this subject
    eval(group_batch_template);
        
    save(fullfile(scripts_dir, 'permutation_test.mat'), 'matlabbatch');
    spm_jobman('run', matlabbatch);
end
