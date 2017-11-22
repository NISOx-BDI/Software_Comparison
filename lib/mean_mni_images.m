function mean_mni_images(preproc_dir, level1_dir, mni_dir)

	 if ~isdir(mni_dir)
        mkdir(mni_dir)
    end
    
	sub_dirs = cellstr(spm_select('FPList', level1_dir, 'dir', 'sub-*'));
	num_sub = length(sub_dirs);
	mean_func_images = cell(num_sub, 0);
	anat_images = cell(num_sub, 0);
	func_dir = fullfile(preproc_dir, 'FUNCTIONAL');
	anat_dir = fullfile(preproc_dir, 'ANATOMICAL');

	for i = 1:num_sub
		[~,sub,~] = fileparts(sub_dirs{i});
		mean_func_images{i,1} = spm_select('FPList', func_dir, ['wmean.*' sub '_task.*']);
		anat_images{i,1} = spm_select('FPList', anat_dir, ['wm' sub '_T1w.nii']);
	end
	

	% Create mean and standard deviation maps of mean functional images
	V = spm_vol(mean_func_images);

	% Standardising each subjects mean func image
	for i = 1:num_sub
		g = spm_global(V{i});
		V{i}.pinfo(1,:) = V{i}.pinfo(1,:)*100/g;
	end 

	% Creating mean and standard deviation maps
	Mean = spm_read_vols(V{1})*0;
	Std_dev = spm_read_vols(V{1})*0;

	for i = 1:length(V)
		tmp = spm_read_vols(V{i});
		Mean = Mean + tmp;
		Std_dev = Std_dev + tmp.^2;
	end

	Mean = Mean/num_sub;
	Std_dev = sqrt(Std_dev/num_sub - Mean.^2); 

	VMean = V{1};
	VMean.fname = fullfile(mni_dir, 'mean_mni_mean_func.nii');
	spm_write_vol(VMean, Mean);

	VStd = V{1};
	VStd.fname = fullfile(mni_dir, 'std_mni_mean_func.nii');
	spm_write_vol(VStd, Std_dev)


	% Create mean and standard deviation maps of anatomical images
	V = spm_vol(anat_images);

	% Standardising each subjects mean func image
	for i = 1:num_sub
		g = spm_global(V{i});
		V{i}.pinfo(1,:) = V{i}.pinfo(1,:)*100/g;
	end 

	% Creating mean and standard deviation maps
	Mean = spm_read_vols(V{1})*0;
	Std_dev = spm_read_vols(V{1})*0;

	for i = 1:length(V)
		tmp = spm_read_vols(V{i});
		Mean = Mean + tmp;
		Std_dev = Std_dev + tmp.^2;
	end

	Mean = Mean/num_sub;
	Std_dev = sqrt(Std_dev/num_sub - Mean.^2); 

	VMean = V{1};
	VMean.fname = fullfile(mni_dir, 'mean_mni_anat.nii');
	spm_write_vol(VMean, Mean);

	VStd = V{1};
	VStd.fname = fullfile(mni_dir, 'std_mni_anat.nii');
	spm_write_vol(VStd, Std_dev)	

end 