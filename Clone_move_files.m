function Move_files
Nsub= 16;
Nrun = 3; 
Nstud= 1;

Base=sprintf('/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds%03d/SPM/SCRIPTS', Nstud);
cd(Base);

for i=2:Nsub
	load('sub-01-move-files.mat');
	
	sub=sprintf('sub-%02d', i); 

	for j=1:Nrun
		RUN = sprintf('run-%02d', j);
		matlabbatch{j}.cfg_basicio.file_dir.file_ops.file_move.files = strrep(matlabbatch{j}.cfg_basicio.file_dir.file_ops.file_move.files,'sub-01', sub);
		matlabbatch{j}.cfg_basicio.file_dir.file_ops.file_move.files = strrep(matlabbatch{j}.cfg_basicio.file_dir.file_ops.file_move.files, sprintf('run-%02d', j), RUN);		
	end

	matlabbatch{Nrun+1}.cfg_basicio.file_dir.file_ops.file_move.files = strrep(matlabbatch{Nrun+1}.cfg_basicio.file_dir.file_ops.file_move.files, 'sub-01', sub);
 	filename = sprintf([sub,'-move-files.mat']); 	
	save(filename,'matlabbatch') 
end
end

