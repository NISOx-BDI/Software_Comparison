cd /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL2/permutation_test

# t-test analysis
3dttest++ -Clustsim 1 -prefix perm_ttest++_Clustsim_result       \
          -mask /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL2/permutation_test/../mask.nii   \
          -setA setA                   \
             01 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-01/sub01.results/stats.sub01+tlrc.HEAD[31]" \
             02 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-02/sub02.results/stats.sub02+tlrc.HEAD[31]" \
             03 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-03/sub03.results/stats.sub03+tlrc.HEAD[31]" \
             04 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-04/sub04.results/stats.sub04+tlrc.HEAD[31]" \
             05 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-05/sub05.results/stats.sub05+tlrc.HEAD[31]" \
             06 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-06/sub06.results/stats.sub06+tlrc.HEAD[31]" \
             07 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-07/sub07.results/stats.sub07+tlrc.HEAD[31]" \
             08 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-08/sub08.results/stats.sub08+tlrc.HEAD[31]" \
             09 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-09/sub09.results/stats.sub09+tlrc.HEAD[31]" \
             10 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-10/sub10.results/stats.sub10+tlrc.HEAD[31]" \
             11 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-11/sub11.results/stats.sub11+tlrc.HEAD[31]" \
             12 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-12/sub12.results/stats.sub12+tlrc.HEAD[31]" \
             13 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-13/sub13.results/stats.sub13+tlrc.HEAD[31]" \
             14 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-14/sub14.results/stats.sub14+tlrc.HEAD[31]" \
             15 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-15/sub15.results/stats.sub15+tlrc.HEAD[31]" \
             16 "/home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-16/sub16.results/stats.sub16+tlrc.HEAD[31]" 

# Create a group mask
3dMean -mask_inter -prefix perm_mask `ls /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-*/sub*.results/mask_group*.HEAD`

3dclust -1Dformat -nosum -1dindex 1 -1tindex 1 -2thresh -1e+09 2.326 -inmask -savemask perm_Positive_clust_mask -dxyz=1 1.01 1036 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL2/permutation_test/perm_ttest++_Clustsim_result+tlrc.HEAD

3dclust -1Dformat -nosum -1dindex 1 -1tindex 1 -2thresh -2.326 1e+09 -inmask -savemask perm_Negative_clust_mask -dxyz=1 1.01 1036 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL2/permutation_test/perm_ttest++_Clustsim_result+tlrc.HEAD

# Masking t_stat 
   3dcalc -a 'perm_ttest++_Clustsim_result+tlrc[1]' -b 'perm_mask+tlrc' \
            -expr 'a*b' -prefix perm_ttest++_Clustsim_result_t_stat_masked -datum float   
                         
# Binarizing both cluster masks
   3dcalc -a 'perm_Positive_clust_mask+tlrc' -expr 'ispositive(a-0.5)' \
            -prefix perm_Positive_binary_clust_mask                 

   3dcalc -a 'perm_Negative_clust_mask+tlrc' -expr 'ispositive(a-0.5)' \
            -prefix perm_Negative_binary_clust_mask                

   3dcalc -a perm_Positive_binary_clust_mask+tlrc -b perm_ttest++_Clustsim_result_t_stat_masked+tlrc \
            -expr 'a*b' -prefix perm_ttest++_Clustsim_result_positive_t_stat_clustered -datum float   

   3dcalc -a perm_Negative_binary_clust_mask+tlrc -b perm_ttest++_Clustsim_result_t_stat_masked+tlrc \
            -expr '-a*b' -prefix perm_ttest++_Clustsim_result_negative_t_stat_clustered -datum float

# Convert to NIFTI for upload to Neurovault
  3dAFNItoNIFTI -prefix perm_ttest++_Clustsim_result_t_stat perm_ttest++_Clustsim_result+tlrc"[1]"
  3dAFNItoNIFTI perm_ttest++_Clustsim_result_t_stat_masked+tlrc
  3dAFNItoNIFTI -prefix perm_Positive_clustered_t_stat perm_ttest++_Clustsim_result_positive_t_stat_clustered+tlrc
  3dAFNItoNIFTI -prefix perm_Negative_clustered_t_stat perm_ttest++_Clustsim_result_negative_t_stat_clustered+tlrc
  3dAFNItoNIFTI perm_mask+tlrc
