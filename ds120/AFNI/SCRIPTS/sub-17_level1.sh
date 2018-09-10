#!/usr/bin/env tcsh

# created by uber_subject.py: version 0.39 (March 21, 2016)
# creation date: Tue Sep 13 15:59:22 2016

# run afni_proc.py to create a single subject processing script
afni_proc.py -subj_id sub17                                                  \
        -script proc.sub17 -scr_overwrite                                    \
        -blocks tshift align tlrc volreg blur mask scale regress               \
        -copy_anat /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds120/AFNI/PREPROCESSING/ANATOMICAL/anatSS.sub-17.nii                             \
		-anat_has_skull no					       \
        -tcat_remove_first_trs 4                                               \
        -align_opts_aea -giant_move -check_flip                                \
        -dsets                                                                 \
            /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds120/AFNI/PREPROCESSING/FUNCTIONAL/sub-17_task-antisaccadetaskwithfixedorder_run-01_bold.nii.gz    \
            /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds120/AFNI/PREPROCESSING/FUNCTIONAL/sub-17_task-antisaccadetaskwithfixedorder_run-02_bold.nii.gz    \
            /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds120/AFNI/PREPROCESSING/FUNCTIONAL/sub-17_task-antisaccadetaskwithfixedorder_run-03_bold.nii.gz    \
        -tshift_opts_ts -tpattern alt+z                                        \
        -tlrc_base MNI152_2009_template.nii.gz                                 \
        -volreg_warp_dxyz 2                                                    \
        -volreg_align_to third                                                 \
        -volreg_align_e2a                                                      \
        -volreg_tlrc_warp                                                      \
	-tlrc_NL_warp							       \
	-tlrc_NL_warped_dsets						       \
		/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds120/AFNI/PREPROCESSING/ANATOMICAL/anatQQ.sub-17.nii				       \
		/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds120/AFNI/PREPROCESSING/ANATOMICAL/anatQQ.sub-17.aff12.1D			       \
		/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds120/AFNI/PREPROCESSING/ANATOMICAL/anatQQ.sub-17_WARP.nii			       \
        -blur_size 5.0                                                         \
        -regress_stim_times                                                    \
            /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds120/AFNI/ONSETS/sub-17_combined_neutral_afni.1d                          \
            /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds120/AFNI/ONSETS/sub-17_combined_reward_afni.1d                           \
        -regress_stim_labels                                                   \
            neutral reward                                                     \
        -regress_basis_multi                                                   \
            'SIN(0,24,8)' 'SIN(0,24,8)'                                        \
	-regress_3dD_stop						       \
	-regress_reml_exec 						       \
        -regress_opts_3dD                                                      \
            -gltsym 'SYM: neutral'                                             \
        -glt_label 1 neutral_vs_baseline                                       \
             -gltsym 'SYM: reward'                                             \
        -glt_label 2 reward_vs_baseline                                        \
        -regress_make_ideal_sum sum_ideal.1D                                   \
        -regress_est_blur_epits                                                \
        -regress_est_blur_errts
        
