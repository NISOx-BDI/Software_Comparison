function r_squared_maps(Statistic_Map, Mask, dof1, dof2, study_dir)

	r_squared_dir = fullfile(study_dir, 'r_squared_images');	

	if ~isdir(r_squared_dir)
		mkdir(r_squared_dir)
	end	
	
	V = spm_vol(Statistic_Map);
	X = spm_read_vols(V);
	Mask = spm_vol(Mask);
	M = spm_read_vols(Mask);
	X(M==0) = NaN;

	Binout = V(1);

	% Checking whether this is the AFNI or SPM stat map
	template = 'SPM';
	index = strfind(Statistic_Map, template);

	% If SPM...
	if ~isempty(index)
		Binout.fname = fullfile(r_squared_dir, 'spm_r_squared.nii');
	% If AFNI...
	else
		Binout.fname = fullfile(r_squared_dir, 'afni_r_squared.nii');	
	end 

	% Using the identity R^2 = 1 - 1/(1 + (dof1/dof2)*F)
	Bin = 1 - 1/(1+ (dof1/dof2)*X);
	spm_write_vol(Binout,Bin);

end
