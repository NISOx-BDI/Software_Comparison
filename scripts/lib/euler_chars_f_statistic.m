function euler_chars_f_statistic(F_Statistic_Map, Mask)
	V = spm_vol(F_Statistic_Map);
	X = spm_read_vols(V);
	Mask = spm_vol(Mask);
	M = spm_read_vols(Mask);
	X(M==0) = NaN;
	X(X==100) = 0;
	X(X==-100) = 0; 
	T = 0:0.1:6;
	EC = zeros(size(T));
	cluster_count = zeros(size(T));
	Binout = V(1); 
	Binout.fname = 'Bin.nii';

	for i = 1:numel(EC)
  		% Thresold
  		Bin = X>= T(i);
  		Binout = spm_write_vol(Binout, Bin);
  		% Write Bin to an image
  		VBin = spm_vol('Bin.nii');
   		tmp = spm_resels_vol(VBin, [0 0 0]);
  		EC(i)= tmp(1);

		% Obtaining cluster count
		tmp = spm_read_vols(VBin);
		CC = bwconncomp(tmp, 6);
		cluster_count(i) = CC.NumObjects;
	end

	delete('Bin.nii');

	A = zeros(length(T),2);
    	A(:,1) = T(1,:);
    	A(:,2) = EC(1,:);

	B = zeros(length(T),2);
	B(:,1) = T(1,:);
	B(:,2) = cluster_count(1,:);

	[Level2Dir, ~, ~] = fileparts(F_Statistic_Map);
	csvwrite(fullfile(Level2Dir, 'euler_chars.csv'), A);
	csvwrite(fullfile(Level2Dir, 'cluster_count.csv'), B);
end
