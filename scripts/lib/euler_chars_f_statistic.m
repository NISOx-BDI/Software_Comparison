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
	end

	delete('Bin.nii');

	A = zeros(length(T),2);
    A(:,1) = T(1,:);
    A(:,2) = EC(1,:);
	[Level2Dir, ~, ~] = fileparts(F_Statistic_Map);
	csvwrite(fullfile(Level2Dir, 'euler_chars.csv'), A);
end