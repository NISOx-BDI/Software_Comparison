% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/SPM/SCRIPTS/test_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
18-r