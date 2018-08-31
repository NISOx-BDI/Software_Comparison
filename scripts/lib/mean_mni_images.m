function mean_mni_images(preproc_dir, level1_dir, mni_dir)

	 if ~isdir(mni_dir)
        mkdir(mni_dir)
    end

	sub_dirs = cellstr(spm_select('FPList', level1_dir, 'dir', 'sub-*'));
	num_sub = length(sub_dirs);
	mean_func_images = cell(num_sub, 0);
	anat_images = cell(num_sub, 0);
	SPMs = cell(num_sub, 0);
	func_dir = fullfile(preproc_dir, 'FUNCTIONAL');
	anat_dir = fullfile(preproc_dir, 'ANATOMICAL');

	for i = 1:num_sub
		[~,sub,~] = fileparts(sub_dirs{i});
		mean_func_images{i,1} = spm_select('FPList', func_dir, ['wmean.*' sub '_task.*']);
		anat_images{i,1} = spm_select('FPList', anat_dir, ['wm' sub '_T1w.nii']);
		SPMs{i,1} = fullfile(sub_dirs{i}, 'SPM.mat');
	end
	

	% Create mean and standard deviation maps of mean functional images
	V = spm_vol(mean_func_images);

	% Standardising each subjects mean func image
	for i = 1:num_sub
		g = spm_global(V{i});
		V{i}.pinfo(1,:) = V{i}.pinfo(1,:)*100/g;
	end 

	% Creating standardised mean and standard deviation maps
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
	VMean.fname = fullfile(mni_dir, 'spm_mean_mni_mean_func.nii');
	spm_write_vol(VMean, Mean);

	VStd = V{1};
	VStd.fname = fullfile(mni_dir, 'spm_std_mni_mean_func.nii');
	spm_write_vol(VStd, Std_dev);


	% Create mean and standard deviation maps of anatomical images
	V = spm_vol(anat_images);

	% Standardising each subjects anat image
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
	VMean.fname = fullfile(mni_dir, 'spm_mean_mni_anat.nii');
	spm_write_vol(VMean, Mean);

	VStd = V{1};
	VStd.fname = fullfile(mni_dir, 'spm_std_mni_anat.nii');
	spm_write_vol(VStd, Std_dev);

	% Creating grand mean images at the subject-level using the beta-images
	for i = 1:num_sub
        [~,sub,~] = fileparts(sub_dirs{i});
		load(SPMs{i,1});
		
		X = SPM.xX.X;
		n = size(X,1);
		p = size(X,2);

        Vi = spm_select('FPList', fullfile(level1_dir, sub), 'beta_.*');
		Vi = spm_vol(Vi);

		Vo = struct(    'fname',        fullfile(mni_dir, ['spm_' sub '_grand_mean.nii']),...
              		  	'dim',          Vi(1).dim(1:3),...
            		    'mat',          Vi(1).mat,...
             		    'pinfo',        [1.0,0,0]',...
             		    'descrip',      'spm - grand mean image');

		Vo = spm_create_vol(Vo);

		oXb = ones(n,1)'*X;

		for i = 1:p
			Vi(i).pinfo(1:2,:) = Vi(i).pinfo(1:2,:)*oXb(i)/n;
		end

		Vo.pinfo(1,1) = spm_add(Vi,Vo);
		
		Vo = spm_create_vol(Vo);
	end

	% Creating mean of the grand mean images
	grand_mean_images = cell(num_sub, 0);

	for i = 1:num_sub
		[~,sub,~] = fileparts(sub_dirs{i});
		grand_mean_images{i,1} = spm_select('FPList', mni_dir, [sub '_grand_mean.nii']);
	end

	V = spm_vol(grand_mean_images);

	Mean = spm_read_vols(V{1})*0;

	for i = 1:length(V)
		tmp = spm_read_vols(V{i});
		Mean = Mean + tmp;
	end	

	Mean = Mean/num_sub;

	VMean = V{1};
	VMean.fname = fullfile(mni_dir, 'spm_mean_grand_mean.nii');
	spm_write_vol(VMean, Mean);

end 
