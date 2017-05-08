#!/usr/bin/env tcsh

# created by uber_subject.py: version 0.39 (March 21, 2016)
# creation date: Tue Sep 13 15:59:22 2016

# run afni_proc.py to create a single subject processing script
afni_proc.py -subj_id sub25                                                  \
        -script proc.sub25 -scr_overwrite                                    \
        -blocks tshift align tlrc volreg blur mask scale regress               \
        -copy_anat /Users/maullz/Desktop/Software_Comparison/ds120/AFNI/PREPROCESSING/ANATOMICAL/sub-25_T1w.nii                                    \
        -tcat_remove_first_trs 4                                               \
        -align_opts_aea -giant_move -check_flip                                \
        -dsets                                                                 \
            /Users/maullz/Desktop/Software_Comparison/ds120/AFNI/PREPROCESSING/FUNCTIONAL/sub-25_task-antisaccadetaskwithfixedorder_run-01_bold.nii.gz    \
            /Users/maullz/Desktop/Software_Comparison/ds120/AFNI/PREPROCESSING/FUNCTIONAL/sub-25_task-antisaccadetaskwithfixedorder_run-02_bold.nii.gz    \
            /Users/maullz/Desktop/Software_Comparison/ds120/AFNI/PREPROCESSING/FUNCTIONAL/sub-25_task-antisaccadetaskwithfixedorder_run-03_bold.nii.gz    \
        -tshift_opts_ts -tpattern alt+z                                        \
        -volreg_align_to third                                                 \
        -volreg_align_e2a                                                      \
        -volreg_tlrc_warp                                                      \
        -tlrc_base MNI_avg152T1+tlrc                                           \
        -blur_size 5.0                                                         \
        -regress_stim_times                                                    \
            /Users/maullz/Desktop/Software_Comparison/ds120/AFNI/ONSETS/sub-25_combined_neutral_afni.1D                          \
            /Users/maullz/Desktop/Software_Comparison/ds120/AFNI/ONSETS/sub-25_combined_reward_afni.1D                           \
        -regress_stim_labels                                                   \
            neutral reward                                                     \
        -regress_basis_multi                                                   \
            'SIN(0,24,8)' 'SIN(0,24,8)'                                        \
        -regress_censor_motion 0.3                                             \
        -regress_opts_3dD                                                      \
            -gltsym 'SYM: neutral'                                             \
        -glt_label 1 neutral_vs_baseline                                       \
             -gltsym 'SYM: reward'                                             \
        -glt_label 2 reward_vs_baseline                                        \
        -regress_make_ideal_sum sum_ideal.1D                                   \
        -regress_est_blur_epits                                                \
        -regress_est_blur_errts
        