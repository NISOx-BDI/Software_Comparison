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
Base='/storage/essicd/data/NIDM-Ex/Data/ds000001';
NewBase='/storage/essicd/data/NIDM-Ex/BIDS_Data/';
OnsetDir=fullfile(NewBase,'RESULTS','SOFTWARE_COMPARISON','ds001','FSL','ONSETS');
OutDir=fullfile(NewBase,'RESULTS','SOFTWARE_COMPARISON','ds001','SPM','ONSETS');
FSLonsDir=fullfile(NewBase,'RESULTS','SOFTWARE_COMPARISON','ds001','FSL','ONSETS');


% Infer subject list from BIDS
list=dir(fullfile(Base,'sub-*'));
Subjs={list.name}';

% Infer number of runs from BIDS
nRun=...

for i = 1:length(Subjs)
  for r = 1:nRun
    ThreeCol={};
    for j = 1:length(CondNames) 
      if ~iscell(CondNames(j)
	ThreeCol{j}=fullfile(FSLonsDir,sprintf('sub-%02d_run-%02d_%s.txt',i,r,CondNames{j}));
      else
	tmp={};
	for jj=1:length(CondNames{j})
	  tmp{jj}=fullfile(FSLonsDir,sprintf('sub-%02d_run-%02d_%s.txt',i,r,CondNames{j}{jj}));
	end
	ThreeCol{j}=tmp;
      end
    end
    OutMat=fullfile(OutDir,sprintf('sub-%02d_run-%02d_SPM_MultCond.mat',i,r));
    ConvEVtoSPM(ThreeCol,CondNames,OutMat);
  end
end


