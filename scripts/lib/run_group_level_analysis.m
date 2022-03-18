function run_group_level_analysis(level1_dir, group_batch_template, level2_dir, contrast_id)
    sub_dirs = cellstr(spm_select('FPList',fullfile(level1_dir, '..'), 'dir','sub-*'));

    scripts_dir = fullfile(level1_dir, '..', 'SCRIPTS');

    LEVEL1_DIR = level1_dir;
    OUT_DIR = level2_dir;
    
    if ~isdir(scripts_dir)
        mkdir(scripts_dir)
    end
    
    num_sub = numel(sub_dirs);
    CON_FILES = cell(num_sub,0);
    for i = 1:num_sub
        CON_FILES{i,1} = spm_select(...
            'FPList', fullfile(sub_dirs{i}, 'LEVEL1'), ['con_' contrast_id '\.nii']);
        CON_FILES{i,1} = gunzip_if_gz(CON_FILES{i,1});
    end

    % Create the matlabbatch for this subject
    eval(group_batch_template);
        
    save(fullfile(scripts_dir, 'level2.mat'), 'matlabbatch');
    spm_jobman('run', matlabbatch);
end