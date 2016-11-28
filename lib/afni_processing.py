import os
import time
import sys
from subprocess import check_call
import glob
import re
import string
import shutil
from lib.fsl_processing import create_fsl_onset_files


def copy_raw(raw_dir, preproc_dir):
    """
    Copy to raw data (anatomical and functional) from 'raw_dir' (organised
    according to BIDS) to 'preproc_dir' and run BET on the anatomical images.
    """
    # All subject directories
    sub_dirs = glob.glob(os.path.join(raw_dir, 'sub-*'))

    if not os.path.isdir(preproc_dir):
        os.mkdir(preproc_dir)

    # For each subject
    for sub_folder in sub_dirs:
        anat_regexp = '*_T1w.nii.gz'
        fun_regexp = '*_bold.nii.gz'

        # Find the anatomical MRI
        amri = glob.glob(
            os.path.join(sub_folder, 'anat', anat_regexp))[0]

        # Find the fMRI
        fmris = glob.glob(
            os.path.join(sub_folder, 'func', fun_regexp))

        # Copy the anatomical image
        anat_preproc_dir = os.path.join(preproc_dir, 'ANATOMICAL')
        if not os.path.isdir(anat_preproc_dir):
            os.mkdir(anat_preproc_dir)
        shutil.copy(amri, anat_preproc_dir)

        # For each run, copy the fMRI image
        func_preproc_dir = os.path.join(preproc_dir, 'FUNCTIONAL')
        if not os.path.isdir(func_preproc_dir):
            os.mkdir(func_preproc_dir)

        for fmri in fmris:
            shutil.copy(fmri, func_preproc_dir)


def create_afni_onset_files(study_dir, OnsetDir, conditions):
    """
    Create AFNI onset files based on BIDS tsv files. Input data in
    'study_dir' is organised according to BIDS, the 'conditions' variable
    specifies the conditions of interest with respect to the regressors defined
    in BIDS. After completion, the onset files are saved in 'OnsetDir'.
    """
    # Create FSL onset files from BIDS
    create_fsl_onset_files(study_dir, OnsetDir, conditions)

    # Convert FSL onset files to AFNI onset files
    cmd = '3coltoAFNI.sh ' + OnsetDir
    print(cmd)
    check_call(cmd, shell=True)

    # Delete FSL onset files
    filelist = glob.glob(os.path.join(OnsetDir, "*.txt"))
    for f in filelist:
        os.remove(f)

    # Combine all runs into one .1d combined onset for each condition
    unique_onsets = []
    for root, dirs, files in os.walk(os.path.join(OnsetDir,"sub-01_run-01*")):
        for file in files:
            unique_onsets.append(file)
    print(unique_onsets)
