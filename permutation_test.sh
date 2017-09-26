cd /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL2/permutation_test

# t-test analysis
3dttest++ -Clustsim 1 -prefix perm_ttest++_Clustsim_result       \
          -mask /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL2/permutation_test/../mask.nii   \
          -setA setA                   \
             01 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-01/sub01.results/stats.sub01+tlrc.HEAD[14]" \
             02 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-02/sub02.results/stats.sub02+tlrc.HEAD[14]" \
             03 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-03/sub03.results/stats.sub03+tlrc.HEAD[14]" \
             04 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-08/sub08.results/stats.sub08+tlrc.HEAD[14]" \
             05 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-09/sub09.results/stats.sub09+tlrc.HEAD[14]" \
             06 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-10/sub10.results/stats.sub10+tlrc.HEAD[14]" \
             07 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-11/sub11.results/stats.sub11+tlrc.HEAD[14]" \
             08 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-14/sub14.results/stats.sub14+tlrc.HEAD[14]" \
             09 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-15/sub15.results/stats.sub15+tlrc.HEAD[14]" \
             10 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-17/sub17.results/stats.sub17+tlrc.HEAD[14]" \
             11 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-18/sub18.results/stats.sub18+tlrc.HEAD[14]" \
             12 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-21/sub21.results/stats.sub21+tlrc.HEAD[14]" \
             13 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-22/sub22.results/stats.sub22+tlrc.HEAD[14]" \
             14 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-26/sub26.results/stats.sub26+tlrc.HEAD[14]" \
             15 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-27/sub27.results/stats.sub27+tlrc.HEAD[14]" \
             16 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-28/sub28.results/stats.sub28+tlrc.HEAD[14]" \
             17 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-30/sub30.results/stats.sub30+tlrc.HEAD[14]" \
             18 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-31/sub31.results/stats.sub31+tlrc.HEAD[14]" \
             19 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-32/sub32.results/stats.sub32+tlrc.HEAD[14]" \
             20 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-43/sub43.results/stats.sub43+tlrc.HEAD[14]" \
             21 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-48/sub48.results/stats.sub48+tlrc.HEAD[14]" 

# Create a group mask
3dMean -mask_inter -prefix perm_mask `ls /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL1/sub-*/sub*.results/mask_group*.HEAD`

3dclust -1Dformat -nosum -1dindex 1 -1tindex 1 -2thresh -1e+09 2.576 -savemask perm_Positive_clust_mask -dxyz=1 1.01 1078 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/AFNI/LEVEL2/permutation_test/perm_ttest++_Clustsim_result+tlrc.HEAD

# Masking t_stat 
   3dcalc -a 'perm_ttest++_Clustsim_result+tlrc[1]' -b 'perm_mask+tlrc' \
            -expr 'a*b' -prefix perm_ttest++_Clustsim_result_t_stat_masked -datum float   
                         
# Binarizing both cluster masks
   3dcalc -a 'perm_Positive_clust_mask+tlrc' -expr 'ispositive(a-0.5)' \
            -prefix perm_Positive_binary_clust_mask                 
            
   3dcalc -a perm_Positive_binary_clust_mask+tlrc -b perm_ttest++_Clustsim_result_t_stat_masked+tlrc \
            -expr 'a*b' -prefix perm_ttest++_Clustsim_result_positive_t_stat_clustered -datum float   

# Convert to NIFTI for upload to Neurovault
  3dAFNItoNIFTI -prefix perm_ttest++_Clustsim_result_t_stat perm_ttest++_Clustsim_result+tlrc"[1]"
  3dAFNItoNIFTI perm_ttest++_Clustsim_result_t_stat_masked+tlrc
  3dAFNItoNIFTI -prefix perm_Positive_clustered_t_stat perm_ttest++_Clustsim_result_positive_t_stat_clustered+tlrc
  3dAFNItoNIFTI perm_mask+tlrc

