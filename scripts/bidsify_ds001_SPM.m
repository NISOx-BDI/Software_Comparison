function bidsify_ds001_SPM(direc, dry)
    sub_dirs = cellstr(spm_select('FPList',direc, 'dir','sub-*'));
    
    todel = {};
    torename = {};

    for s = 1:numel(sub_dirs)
    
        input_files_a = cellstr(spm_select('FPListRec', fullfile(sub_dirs{s}, 'anat')));
        input_files_f = cellstr(spm_select('FPListRec', fullfile(sub_dirs{s}, 'func')));
        input_files = {input_files_a{:}, input_files_f{:}};

        for i = 1:numel(input_files)
            goNext = false;

            [pth,nam,ext,num] = spm_fileparts(input_files{i});

            % Delete MacOS '.DS_Store' files
            if strcmp(ext,'.DS_Store')
                todel{end+1,1} = input_files{i};
                goNext = true;
            end
            if goNext
                continue;
            end
            
            prefix_todel = {'c4', 'c5'};
            for j = 1:numel(prefix_todel)
                if startsWith(nam,prefix_todel{j})
                    todel{end+1,1} = input_files{i};
                    goNext = true;
                end
            end
            if goNext
                continue;
            end

            % Rename non-SPM files manually        
            rename_suffixes = {{'brain_extracted.nii', 'space-individual_desc-skullstripped.nii'},...
                {'brain_extracted', 'space-individual_desc-skullstripped'},...
                {'brainextracted.nii', 'space-individual_desc-skullstripped.nii'},...
                {'brainextracted', 'space-individual_desc-skullstripped'}};
            for j = 1:numel(rename_suffixes)
                if endsWith(nam,rename_suffixes{j}{1})
                    filename = strrep(nam, rename_suffixes{j}{1}, rename_suffixes{j}{2});
                    
                    torename{end+1,1} = input_files{i};
                    torename{end,2} = filename;
                    goNext = true;
                end
            end
            if goNext
                continue;
            end


            % Rename SPM-like files        
            filename = spm_2_bids(input_files{i});
            torename{end+1,1} = input_files{i};
            torename{end,2} = filename;
        end
    end
    
    if dry
        for i = 1:numel(todel)
            fprintf(1, 'Deleting\t-->\t%s\n', todel{i});
        end
        for i = 1:size(torename,1)
            fprintf(1, '%s\t-->\t%s\n', torename{i,1}, torename{i,2});
        end
    else
        matlabbatch = cell(0);
        matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_move.files = todel;
        matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_move.action.delete = false;
      
        for i = 1:size(torename,1)
            fprintf(1, '%s\t-->\t%s\n', torename{i,1}, torename{i,2});
            
           [pth,nam,ext,num] = spm_fileparts(torename{i,1});
           [~,nam_new] = spm_fileparts(torename{i,2});
            
            matlabbatch{end+1}.cfg_basicio.file_dir.file_ops.file_move.files = torename(i,1);
            matlabbatch{end}.cfg_basicio.file_dir.file_ops.file_move.action.moveren.moveto = {pth};
            matlabbatch{end}.cfg_basicio.file_dir.file_ops.file_move.action.moveren.patrep.pattern = '.*';
            matlabbatch{end}.cfg_basicio.file_dir.file_ops.file_move.action.moveren.patrep.repl = nam_new;
            matlabbatch{end}.cfg_basicio.file_dir.file_ops.file_move.action.moveren.unique = false;
        end

        %  save batch
        save(fullfile(direc, 'batch_rename.mat'), 'matlabbatch')
        spm_jobman('run', matlabbatch)
    end   
end