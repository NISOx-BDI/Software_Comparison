%-----------------------------------------------------------------------
% Job saved on 02-Sep-2016 15:40:18 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6685)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_move.files = {'/storage/essicd/data/NIDM-Ex/BIDS_Data/DATA/BIDS/ds001_R1.1.0/sub-01/func/sub-01_task-balloonanalogrisktask_run-01_bold.nii.gz'};
matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_move.action.copyto = {'/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/PREPROCESSING/FUNCTIONAL'};
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.files = {'/storage/essicd/data/NIDM-Ex/BIDS_Data/DATA/BIDS/ds001_R1.1.0/sub-01/func/sub-01_task-balloonanalogrisktask_run-02_bold.nii.gz'};
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.action.copyto = {'/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/PREPROCESSING/FUNCTIONAL'};
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_move.files = {'/storage/essicd/data/NIDM-Ex/BIDS_Data/DATA/BIDS/ds001_R1.1.0/sub-01/func/sub-01_task-balloonanalogrisktask_run-03_bold.nii.gz'};
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_move.action.copyto = {'/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/PREPROCESSING/FUNCTIONAL'};
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_move.files = {'/storage/essicd/data/NIDM-Ex/BIDS_Data/DATA/BIDS/ds001_R1.1.0/sub-01/anat/sub-01_T1w.nii.gz'};
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_move.action.copyto = {'/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/PREPROCESSING/ANATOMICAL'};
matlabbatch{5}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = cfg_dep('Move/Delete Files: Moved/Copied Files', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{5}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
matlabbatch{5}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = true;
matlabbatch{6}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = cfg_dep('Move/Delete Files: Moved/Copied Files', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{6}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
matlabbatch{6}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = true;
matlabbatch{7}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = cfg_dep('Move/Delete Files: Moved/Copied Files', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{7}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
matlabbatch{7}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = true;
matlabbatch{8}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.files(1) = cfg_dep('Move/Delete Files: Moved/Copied Files', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{8}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.outdir = {''};
matlabbatch{8}.cfg_basicio.file_dir.file_ops.cfg_gunzip_files.keep = true;
