function create_onset_files(OnsetDir, FSLonsetDir, CondNames)

    sub_dirs = cellstr(spm_select('FPList',raw_dir, 'dir','sub-*'));

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

    % Infer number of runs from BIDS
    nRun = 3;

    for i = 1:numel(sub_dirs)
        for r = 1:nRun
            ThreeCol={};
            for j = 1:length(CondNames) 
                if ~iscell(CondNames(j)
                    ThreeCol{j}=fullfile(FSLonsetDir,sprintf('sub-%02d_run-%02d_%s.txt',i,r,CondNames{j}));
                else
                    tmp={};
                    for jj=1:length(CondNames{j})
                        tmp{jj}=fullfile(FSLonsetDir,sprintf('sub-%02d_run-%02d_%s.txt',i,r,CondNames{j}{jj}));
                    end
                    ThreeCol{j}=tmp;
                end
            end
            OutMat = fullfile(OnsetDir,sprintf('sub-%02d_run-%02d_SPM_MultCond.mat',i,r));
            ConvEVtoSPM(ThreeCol,CondNames,OutMat);
        end
    end
end


