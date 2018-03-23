function create_onset_files(study_dir, OnsetDir, CondNames, removed_TR_time, varargin)

    if ~isdir(OnsetDir)
        mkdir(OnsetDir)
    end
    
    if length(varargin) == 0 
        sub_dirs = cellstr(spm_select('FPList', study_dir, 'dir', 'sub-*'));
    else
        subject_ids = varargin{1};
        sub_dirs = cell(length(subject_ids),1);
        for i=1:length(subject_ids)
            sub_dirs(i,1) = cellstr(spm_select('FPList', study_dir, 'dir', sprintf('sub-%02d',subject_ids(i))));
        end
    end

	removed_TR_time = num2str(removed_TR_time);
%%% This should be a function
%%% Input arguments
%%%    BIDSDir (input)
%%%    FSLonsetsDir (input)
%%%    CondNames (input, encodes parametric mod)
%%%    SPMonsetsDir (output)

%Base=spm_select(1,'dir','Select the study directory');
   % Find the value set by spm_select and copy and paste this value in
   % here, then comment-out the spm_select line (making this script *not*
   % depend  on spm_select)
% Base='/storage/essicd/data/NIDM-Ex/Data/ds000001';
% NewBase='/storage/essicd/data/NIDM-Ex/BIDS_Data/';


%     % Infer subject list from BIDS
%     list=dir(fullfile(Base,'sub-*'));
%     Subjs={list.name}';

    


    for i = 1:numel(sub_dirs)
        event_files =cellstr(spm_select('FPList', fullfile(sub_dirs{i}, 'func'), '.*\.tsv'));
        nRun = numel(event_files);

        [~,sub,~] = fileparts(sub_dirs{i}); 
        
        for r = 1:nRun
            sub_run = [sub '_run-' sprintf('%02d',r)];

            event_file = event_files{r};
            ThreeCol={};
            for j = 1:length(CondNames)

                cond_names = CondNames{j}{1};
                trial_type = CondNames{j}{2}{1};
                
                if ~isempty(trial_type)
                    onsets_opt = ['-e ', '"' trial_type '"']; 
                else
                    onsets_opt = ' -s ';
                end

                if numel(CondNames{j}{2}) < 2
                    CondNames{j}{2}{2} = 0;
                end
                duration = CondNames{j}{2}{2};
                
                if (~ischar(duration))
                    if (~isempty(duration)) && (duration ~= 0)
                        dur_opt = ['-d ', '"' duration '"'];
                    else
                        dur_opt = '';
                    end
                else
                dur_opt = '';
                end
                
                
                if ~iscell(cond_names)
                    cond_name = cond_names;
                    FSL3colfile=fullfile(OnsetDir,sprintf('%s_%s',sub_run, cond_name));
                    system(['BIDSto3col.sh -b ' removed_TR_time ' ' onsets_opt dur_opt ' ' event_file ' ' FSL3colfile]);                   
                    ThreeCol{j}=fullfile(OnsetDir,sprintf('%s_%s.txt',sub_run,cond_name));
                    CondNamesOnly{j} = cond_name;
                else
                    % Parametric modulation
                    if numel(CondNames{j}{2}) < 3
                        error('create_onset_files:NoHeight', ...
                            ['Missing height definition for parametric modulation (' cond_names{1} ')'])
                    end
                    
                    base_cond_name = cond_names{1};
                    base_cond_file = fullfile(OnsetDir,sprintf('%s_%s.txt',sub_run,base_cond_name));
                    ThreeCol{j}{1} = base_cond_file;
                    CondNamesOnly{j}{1}=base_cond_name; 

                    for jj = 1:(length(CondNames{j}{1})-1)
                        height = CondNames{j}{2}{2+jj};
                        height_opt = [' -h ', height];

                        pmod_cond_name = cond_names{1+jj};
                        system(['BIDSto3col.sh -b ' removed_TR_time ' ' onsets_opt height_opt dur_opt ' ' event_file ' ' strrep(base_cond_file,'.txt', '')]);
                        pmod_cond_file_auto = strrep(base_cond_file, '.txt', '_pmod.txt');
                        pmod_cond_file = strrep(pmod_cond_file_auto, [base_cond_name '_pmod'], pmod_cond_name);
                        movefile(pmod_cond_file_auto, pmod_cond_file);
                        ThreeCol{j}{jj+1} = pmod_cond_file;
                        CondNamesOnly{j}{1+jj} = pmod_cond_name;
                    end
                end
            end
            OutMat = fullfile(OnsetDir,sprintf('%s_SPM_MultCond.mat',sub_run));
            ConvEVtoSPM(ThreeCol,CondNamesOnly,OutMat);
        end
    end
    % Delete temporary FSL three col files
    delete(fullfile(OnsetDir,'*.txt'));
end

