function EulerChars(Statistic_Map)
	V = spm_vol(Statistic_Map);
	X = spm_read_vols(V);
	T = -6:0.1:6;
	EC = zeros(size(T));
	Binout = V(1); 
	Binout.fname = 'Bin.nii';

	for i = 1:numel(EC)
  		% Thresold
  		Bin = X>= T(i);
  		Binout = spm_write_vol(Binout, Bin)
  		% Write Bin to an image
  		VBin = spm_vol('Bin.nii');
   		tmp = spm_resels_vol(VBin);
  		EC(i)= tmp(1);
	end

	delete('Bin.nii');

	A = [T; EC];
	[Level2Dir, ~, ~] = filesparts(Statistic_Map)
	fileID = fopen(fullfile(Level2Dir, 'EulerChars.txt'), 'w');
	fprintf(fileID, '%6.2f %6.2f\n', A);
	fclose(fildID);
end
