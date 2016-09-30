%Base=spm_select(1,'dir','Select the study directory');
OldBase='/storage/essicd/data/NIDM-Ex/Data/ds000001';
   % Find the value set by spm_select and copy and paste this value in
   % here, then comment-out the spm_select line (making this script *not*
   % depend  on spm_select)
disp(['''' OldBase ''''])

% Get condition names
fid=fopen(fullfile(OldBase,'models','model001','condition_key.txt'));
tmp=textscan(fid,'%*s %*s %[^n]');
CondNms=tmp{1};
fclose(fid);

% Get subject list, and demographics / covariates
fid=fopen(fullfile(OldBase,'demographics.txt'));
if (fid~=-1)
  tmp=textscan(fid,'%*s %s %s %s');
  Subjs=tmp{1};
  GendsMgF=real(cellfun(@(x) x(1)=='M',tmp{2}));
  Ages=cellfun(@str2num,tmp{3});
  fclose(fid);
else
  % Fall-back... use directory listing to get list of subjects
  list=dir(fullfile(OldBase,'sub*'));
  Subjs={list.name}';
  GendsMgF={};
  Ages={};
end

NewBase='/storage/essicd/data/NIDM-Ex/BIDS_Data/';
OnsetDir=fullfile(NewBase,'RESULTS','SOFTWARE_COMPARISON','ds001','FSL','ONSETS');
OutDir=fullfile(NewBase,'RESULTS','SOFTWARE_COMPARISON','ds001','SPM','ONSETS');

for i = 1:length(Subjs)
  for r = 1:3
    OnsetDir=fullfile(NewBase,'RESULTS','SOFTWARE_COMPARISON','ds001','FSL','ONSETS');
    ThreeCol={...
	{fullfile(OnsetDir,sprintf('sub-%02d_run-%02d_pumps_fixed.txt',i,r)),fullfile(OnsetDir,sprintf('sub-%02d_run-%02d_pumps_fixed_pmod.txt',i,r))},...
	fullfile(OnsetDir,sprintf('sub-%02d_run-%02d_pumps_fixed.txt',i,r)),...
	{fullfile(OnsetDir,sprintf('sub-%02d_run-%02d_cash_fixed.txt',i,r)),fullfile(OnsetDir,sprintf('sub-%02d_run-%02d_cash_fixed_pmod.txt',i,r))},...
	fullfile(OnsetDir,sprintf('sub-%02d_run-%02d_pumps_RT.txt',i,r)),...
	{fullfile(OnsetDir,sprintf('sub-%02d_run-%02d_explode_fixed.txt',i,r)),fullfile(OnsetDir,sprintf('sub-%02d_run-%02d_explode_fixed_pmod.txt',i,r))},...
	{fullfile(OnsetDir,sprintf('sub-%02d_run-%02d_control_pumps_fixed.txt',i,r)),fullfile(OnsetDir,sprintf('sub-%02d_run-%02d_control_pumps_fixed_pmod.txt',i,r))},...
	fullfile(OnsetDir,sprintf('sub-%02d_run-%02d_control_pumps_RT.txt',i,r))};
    CondNames={...
	{CondNms{1},CondNms{2}},...
	CondNms{3},...
	{CondNms{4},CondNms{5}},...
	CondNms{6},...
	{CondNms{7},CondNms{8}},...
	{CondNms{9},CondNms{10}},...,
	CondNms{11}};
    OutMat=fullfile(OutDir,sprintf('sub-%02d_run-%02d_SPM_MultCond.mat',i,r));
    ConvEVtoSPM(ThreeCol,CondNames,OutMat);
  end
end


