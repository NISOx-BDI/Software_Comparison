#!/usr/bin/env tcsh

# created by uber_subject.py: version 0.39 (March 21, 2016)
# creation date: Tue Sep 13 15:59:22 2016

# run afni_proc.py to create a single subject processing script
afni_proc.py -subj_id sub30                                                  \
        -script proc.sub30 -scr_overwrite                                    \
        -blocks tshift align tlrc volreg blur mask scale regress               \
        -copy_anat /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/PREPROCESSING/ANATOMICAL/sub-30_T1w.nii                                    \
        -align_opts_aea -giant_move -check_flip                                \
        -dsets                                                                 \
            /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/PREPROCESSING/FUNCTIONAL/sub-30_task-theoryofmindwithmanualresponse_run-01_bold.nii.gz     \
            /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/PREPROCESSING/FUNCTIONAL/sub-30_task-theoryofmindwithmanualresponse_run-02_bold.nii.gz     \
        -volreg_align_to third                                                 \
        -volreg_align_e2a                                                      \
        -volreg_tlrc_warp                                                      \
        -tlrc_base MNI_avg152T1+tlrc                                           \
        -blur_size 8.0                                                         \
        -regress_stim_times                                                    \
            /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/ONSETS/sub-30_combined_false_belief_story_afni.1d               \
            /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/ONSETS/sub-30_combined_false_belief_question_afni.1d            \
            /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/ONSETS/sub-30_combined_false_photo_story_afni.1d                \
            /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/ONSETS/sub-30_combined_false_photo_question_afni.1d             \
        -regress_stim_labels                                                   \
            false_belief_story false_belief_question false_photo_story         \
            false_photo_question                                               \
        -regress_basis_multi                                                   \
            'SPMG1(10)' 'SPMG1(6)' 'SPMG1(10)' 'SPMG1(6)'                      \
        -regress_censor_motion 0.3                                             \
        -regress_opts_3dD                                                      \
            -gltsym 'SYM: false_belief_story -false_photo_story'               \
        -glt_label 1 false_belief_vs_false_photo                               \
        -regress_make_ideal_sum sum_ideal.1D                                   \
        -regress_est_blur_epits                                                \
        -regress_est_blur_errts
        