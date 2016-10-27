function create_onset_files(study_dir, OnsetDir, CondNames)

    if ~isdir(OnsetDir)
        mkdir(OnsetDir)
    end
    
    sub_dirs = cellstr(spm_select('FPList',study_dir, 'dir','sub-*'));

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
        
        for r = 1:nRun
            event_file = event_files{r};
            ThreeCol={};
            for j = 1:length(CondNames)
                if ~iscell(CondNames{j}{1})
                    FSL3colfile=fullfile(OnsetDir,sprintf('sub-%02d_run-%02d_%s',i,r,CondNames{j}{1}));
                    system(['BIDSto3col.sh -b 4 -e ' CondNames{j}{2}{1} ' -d ' CondNames{j}{2}{2} ' ' event_file ' ' FSL3colfile]);                   
                    ThreeCol{j}=fullfile(OnsetDir,sprintf('sub-%02d_run-%02d_%s.txt',i,r,CondNames{j}{1}));
                else
                    tmp={};
                    for jj=2:length(CondNames{j}{1})
                        FSL3colfile=fullfile(OnsetDir,sprintf('sub-%02d_run-%02d_%s',i,r,CondNames{j}{1}{1}));
                        system(['BIDSto3col.sh -b 4 -e ' CondNames{j}{2}{jj-1} ' -h ' CondNames{j}{2}{jj-1} ' ' event_file ' ' FSL3colfile]);
                        FSL3col_pmod = [FSL3colfile, '_pmod.txt'];
                        FSL3col_renamed = strrep(FSL3col_pmod, [CondNames{j}{1}{1} '_pmod'], CondNames{j}{1}{jj});
                        movefile(FSL3col_pmod, FSL3col_renamed);
                    end
                    for jj = 1:length(CondNames{j})
                        tmp{jj}=fullfile(OnsetDir,sprintf('sub-%02d_run-%02d_%s.txt',i,r,CondNames{j}{1}{jj}));
                    end
                    ThreeCol{j}=tmp;
                end
            end
            OutMat = fullfile(OnsetDir,sprintf('sub-%02d_run-%02d_SPM_MultCond.mat',i,r));
            ConvEVtoSPM(ThreeCol,CondNames,OutMat);
        end
    end
    delete(fullfile(OnsetDir,'*.txt'));
end


