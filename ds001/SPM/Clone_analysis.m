function Analysis
Nsub= 16;
Nrun = 3; 
Nstud= 1;

Base=sprintf('/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds%03d/SPM/SCRIPTS', Nstud);
cd(Base);

for i=2:Nsub
	load('sub-01-analysis.mat');
	
	sub=sprintf('sub-%02d', i); 

	for j=1:Nrun
	matlabbatch{1}.spm.spatial.realign.estwrite.data{j} = strrep(matlabbatch{1}.spm.spatial.realign.estwrite.data{j}, 'sub-01', sub);
	matlabbatch{8}.spm.stats.fmri_spec.sess(j).multi = strrep(matlabbatch{8}.spm.stats.fmri_spec.sess(j).multi, 'sub-01', sub);
	end

	matlabbatch{2}.spm.spatial.coreg.estimate.source = strrep(matlabbatch{2}.spm.spatial.coreg.estimate.source, 'sub-01', sub);
	matlabbatch{8}.spm.stats.fmri_spec.dir = strrep(matlabbatch{8}.spm.stats.fmri_spec.dir, 'sub-01', sub);

 	filename = sprintf([sub,'-analysis.mat']); 	
	save(filename,'matlabbatch') 
end
end
