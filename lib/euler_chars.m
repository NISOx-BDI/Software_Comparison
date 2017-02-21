function euler_chars(Statistic_Map)
	V = spm_vol(Statistic_Map);
	X = spm_read_vols(V);
	T = -6:0.1:6;
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

	A = [T; EC];
	[Level2Dir, ~, ~] = fileparts(Statistic_Map);
	fileID = fopen(fullfile(Level2Dir, 'euler_chars.txt'), 'w');
	fprintf(fileID, '%6.2f %8.0f\n', A);
	fclose(fileID);
end
