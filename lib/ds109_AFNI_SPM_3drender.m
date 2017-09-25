function x = ds109_AFNI_SPM_3drender(POS_EXCURSION_SET_FILE, SPM_SURFACE_FILE)
	%-----------------------------------------------------------------------
	% Job saved on 19-Sep-2017 14:40:04 by cfg_util (rev $Rev: 6460 $)
	% spm SPM - SPM12 (6906)
	% cfg_basicio BasicIO - Unknown
	%-----------------------------------------------------------------------
	matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files = {POS_EXCURSION_SET_FILE};
	matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
	matlabbatch{1}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = true;
	matlabbatch{2}.spm.tools.render.SExtract.images(1) = cfg_dep('Gunzip Files: Gunzipped Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{':'}));
	matlabbatch{2}.spm.tools.render.SExtract.surface.expression = 'i1';
	matlabbatch{2}.spm.tools.render.SExtract.surface.thresh = 0.5;
	matlabbatch{3}.spm.tools.render.SRender.Object(1).SurfaceFile(1) = cfg_dep('Surface Extraction: Surface File 1', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','SurfaceFile', '()',{1}));
	matlabbatch{3}.spm.tools.render.SRender.Object(1).Color.Red = 1;
	matlabbatch{3}.spm.tools.render.SRender.Object(1).Color.Green = 0;
	matlabbatch{3}.spm.tools.render.SRender.Object(1).Color.Blue = 0;
	matlabbatch{3}.spm.tools.render.SRender.Object(1).DiffuseStrength = 0.8;
	matlabbatch{3}.spm.tools.render.SRender.Object(1).AmbientStrength = 0.2;
	matlabbatch{3}.spm.tools.render.SRender.Object(1).SpecularStrength = 0.2;
	matlabbatch{3}.spm.tools.render.SRender.Object(1).SpecularExponent = 10;
	matlabbatch{3}.spm.tools.render.SRender.Object(1).SpecularColorReflectance = 0.8;
	matlabbatch{3}.spm.tools.render.SRender.Object(1).FaceAlpha = 1;
	matlabbatch{3}.spm.tools.render.SRender.Object(2).SurfaceFile = {SPM_SURFACE_FILE};
	matlabbatch{3}.spm.tools.render.SRender.Object(2).Color.Red = 1;
	matlabbatch{3}.spm.tools.render.SRender.Object(2).Color.Green = 1;
	matlabbatch{3}.spm.tools.render.SRender.Object(2).Color.Blue = 1;
	matlabbatch{3}.spm.tools.render.SRender.Object(2).DiffuseStrength = 0.8;
	matlabbatch{3}.spm.tools.render.SRender.Object(2).AmbientStrength = 0.2;
	matlabbatch{3}.spm.tools.render.SRender.Object(2).SpecularStrength = 0.2;
	matlabbatch{3}.spm.tools.render.SRender.Object(2).SpecularExponent = 10;
	matlabbatch{3}.spm.tools.render.SRender.Object(2).SpecularColorReflectance = 0.8;
	matlabbatch{3}.spm.tools.render.SRender.Object(2).FaceAlpha = 1;
	matlabbatch{3}.spm.tools.render.SRender.Light.Position = [100 100 100];
	matlabbatch{3}.spm.tools.render.SRender.Light.Color.Red = 1;
	matlabbatch{3}.spm.tools.render.SRender.Light.Color.Green = 1;
	matlabbatch{3}.spm.tools.render.SRender.Light.Color.Blue = 1;

	x = matlabbatch;
end 