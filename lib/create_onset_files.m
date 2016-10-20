function create_onset_files(study_dir, OnsetDir, FSLonsetDir, CondNames)

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
        event_files = spm_select('FPList', fullfile(sub_dirs{i}, 'FUNCTIONAL'), '*.tsv');
        nRun = numel(event_files);        
        
        for r = 1:nRun
            ThreeCol={};
            for j = 1:length(CondNames) 
                if ~iscell(CondNames{j})
                    
                    ThreeCol{j}=fullfile(FSLonsetDir,sprintf('sub-%02d_run-%02d_%s.txt',i,r,CondNames{j}));
                else
                    tmp={};
                    event_file = event_files{r};
                    system(['BIDSto3col.sh -b 4 -e ' CondNames{j}{2} ' -h ' CondNames{j}{2} ' ' event_file ' ' fullfile(OnsetDir, CondNames{j}{1})]);
%                     movefile(fullfile(OnsetDir, CondName))
                    for jj=1:length(CondNames{j})
                        tmp{jj}=fullfile(OnsetDir,sprintf('sub-%02d_run-%02d_%s.txt',i,r,CondNames{j}{jj}));
                    end
                    ThreeCol{j}=tmp;
                end
            end
            OutMat = fullfile(OnsetDir,sprintf('sub-%02d_run-%02d_SPM_MultCond.mat',i,r));
            ConvEVtoSPM(ThreeCol,CondNames,OutMat);
        end
    end
end


