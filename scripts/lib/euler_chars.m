function euler_chars(Statistic_Map, Mask, varargin)
        % DF should only be specified if a converted Z image is given (as
        % produced by 3dttest++ when -ClusterSim used); the DF will then
        % be used to undo the transformation, finding EC values for the
        % usual set of T thresholds.
    if length(varargin)~=0
	  DF=varargin{1};
	else
	  DF=NaN;
	end
	V = spm_vol(Statistic_Map);
	X = spm_read_vols(V);
	Mask = spm_vol(Mask);
	M = spm_read_vols(Mask);
	X(M==0) = NaN;
	% Problem AFNI voxels at +/-100
	X(X==100) = 0;
	X(X==-100) = 0; 
	T = -6:0.1:6;
	if ~isnan(DF)
	  Z = zeros(size(T));
	  I = T<0;
	  Z(I)  =  spm_invNcdf(spm_Tcdf( T( I),DF));
	  Z(~I) = -spm_invNcdf(spm_Tcdf(-T(~I),DF));
	end
	EC = zeros(size(T));
	Binout = V(1); 
	Binout.fname = 'Bin.nii';

	for i = 1:numel(EC)
  		% Thresold
		if isnan(DF)
		  Bin = X>= T(i);
		else
		  Bin = X>= Z(i);
		end
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
	[Level2Dir, ~, ~] = fileparts(Statistic_Map);
	csvwrite(fullfile(Level2Dir, 'euler_chars.csv'), A);
end
