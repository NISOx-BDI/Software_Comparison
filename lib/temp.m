%-----------------------------------------------------------------------
% Job saved on 19-Sep-2017 14:40:04 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6906)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.tools.render.SExtract.images = {'/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/SPM/LEVEL2/spmT_0001_thresholded.nii,1'};
matlabbatch{1}.spm.tools.render.SExtract.surface.expression = 'i1';
matlabbatch{1}.spm.tools.render.SExtract.surface.thresh = 0.5;
matlabbatch{2}.spm.tools.render.SRender.Object(1).SurfaceFile(1) = cfg_dep('Surface Extraction: Surface File 1', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','SurfaceFile', '()',{1}));
matlabbatch{2}.spm.tools.render.SRender.Object(1).Color.Red = 1;
matlabbatch{2}.spm.tools.render.SRender.Object(1).Color.Green = 0;
matlabbatch{2}.spm.tools.render.SRender.Object(1).Color.Blue = 0;
matlabbatch{2}.spm.tools.render.SRender.Object(1).DiffuseStrength = 0.8;
matlabbatch{2}.spm.tools.render.SRender.Object(1).AmbientStrength = 0.2;
matlabbatch{2}.spm.tools.render.SRender.Object(1).SpecularStrength = 0.2;
matlabbatch{2}.spm.tools.render.SRender.Object(1).SpecularExponent = 10;
matlabbatch{2}.spm.tools.render.SRender.Object(1).SpecularColorReflectance = 0.8;
matlabbatch{2}.spm.tools.render.SRender.Object(1).FaceAlpha = 1;
matlabbatch{2}.spm.tools.render.SRender.Object(2).SurfaceFile = {'/storage/essicd/spm12/canonical/cortex_20484.surf.gii'};
matlabbatch{2}.spm.tools.render.SRender.Object(2).Color.Red = 1;
matlabbatch{2}.spm.tools.render.SRender.Object(2).Color.Green = 1;
matlabbatch{2}.spm.tools.render.SRender.Object(2).Color.Blue = 1;
matlabbatch{2}.spm.tools.render.SRender.Object(2).DiffuseStrength = 0.8;
matlabbatch{2}.spm.tools.render.SRender.Object(2).AmbientStrength = 0.2;
matlabbatch{2}.spm.tools.render.SRender.Object(2).SpecularStrength = 0.2;
matlabbatch{2}.spm.tools.render.SRender.Object(2).SpecularExponent = 10;
matlabbatch{2}.spm.tools.render.SRender.Object(2).SpecularColorReflectance = 0.8;
matlabbatch{2}.spm.tools.render.SRender.Object(2).FaceAlpha = 1;
matlabbatch{2}.spm.tools.render.SRender.Light.Position = [100 100 100];
matlabbatch{2}.spm.tools.render.SRender.Light.Color.Red = 1;
matlabbatch{2}.spm.tools.render.SRender.Light.Color.Green = 1;
matlabbatch{2}.spm.tools.render.SRender.Light.Color.Blue = 1;
