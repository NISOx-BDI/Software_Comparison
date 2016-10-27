# _________________________________________________________________________
# Copy to 'preproc_dir' and gunzip anatomical and fmri files found in
# 'raw_dir' (and organised according to BIDS)
# _________________________________________________________________________
import os
import glob
import shutil


def copy_gunzip(raw_dir, preproc_dir):
    sub_dirs = glob.glob(os.path.join(raw_dir, 'sub-*'))

    if not os.path.isdir(preproc_dir):
        os.mkdir(preproc_dir)

    for sub_folder in sub_dirs:
        anat_regexp = '.*_T1w\.nii\.gz'
        fun_regexp = '.*_bold\.nii\.gz'

        amri = glob.glob(
            os.path.join(sub_folder, 'anat', anat_regexp))
        fmris = glob.glob(
            os.path.join(sub_folder, 'func', fun_regexp))

        # Copy the anatomical image
        anat_preproc_dir = os.path.join(preproc_dir, 'ANATOMICAL')
        if not os.path.isdir(anat_preproc_dir):
            os.mkdir(anat_preproc_dir)
        shutil.copyfile(amri, anat_preproc_dir)

        # For each run, copy the fmri image
        func_preproc_dir = os.path.join(preproc_dir, 'FUNCTIONAL')
        if not os.path.isdir(func_preproc_dir):
            os.mkdir(func_preproc_dir)

        for fmri in fmris:
            shutil.copyfile(fmri, func_preproc_dir)
