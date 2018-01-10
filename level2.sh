cd /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL2

# Group analysis with weighted least squares
3dMEMA -prefix 3dMEMA_result       \
          -set controls                   \
             01 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-01/sub01.results/stats.sub01+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-01/sub01.results/stats.sub01+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             02 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-02/sub02.results/stats.sub02+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-02/sub02.results/stats.sub02+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             03 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-03/sub03.results/stats.sub03+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-03/sub03.results/stats.sub03+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             04 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-04/sub04.results/stats.sub04+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-04/sub04.results/stats.sub04+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             05 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-05/sub05.results/stats.sub05+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-05/sub05.results/stats.sub05+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             06 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-06/sub06.results/stats.sub06+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-06/sub06.results/stats.sub06+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             07 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-07/sub07.results/stats.sub07+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-07/sub07.results/stats.sub07+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             08 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-08/sub08.results/stats.sub08+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-08/sub08.results/stats.sub08+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             09 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-09/sub09.results/stats.sub09+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-09/sub09.results/stats.sub09+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             10 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-10/sub10.results/stats.sub10+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-10/sub10.results/stats.sub10+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             11 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-11/sub11.results/stats.sub11+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-11/sub11.results/stats.sub11+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             12 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-12/sub12.results/stats.sub12+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-12/sub12.results/stats.sub12+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             13 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-13/sub13.results/stats.sub13+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-13/sub13.results/stats.sub13+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             14 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-14/sub14.results/stats.sub14+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-14/sub14.results/stats.sub14+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             15 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-15/sub15.results/stats.sub15+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-15/sub15.results/stats.sub15+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             16 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-16/sub16.results/stats.sub16+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-16/sub16.results/stats.sub16+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat']

# Create a group mask
3dMean -mask_inter -prefix mask `ls /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL1/sub-*/sub*.results/mask_group*.HEAD`

# Simulations for FWE corrected cluster-size inference
# 0.783098 3.85315 13.5226 is the average of the 3dFWHMx -acf calculations applied
# to the blur_est.sub_xxx.1D files for the 16 subjects
3dClustSim -both -mask mask+tlrc -acf 0.787302 3.86771 13.9191 -prefix ClustSim 

# Clusterizing the results for a height threshold z > 2.3
3dclust -1Dformat -nosum -1dindex 1 -1tindex 1 -2thresh -1e+09 2.602 -dxyz=1 -savemask Positive_clust_mask 1.01 309 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL2/3dMEMA_result+tlrc.HEAD

3dclust -1Dformat -nosum -1dindex 1 -1tindex 1 -2thresh -2.602 1e+09 -dxyz=1 -savemask Negative_clust_mask 1.01 309 /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/AFNI/LEVEL2/3dMEMA_result+tlrc.HEAD

# Masking t_stat 
   3dcalc -a '3dMEMA_result+tlrc[1]' -b 'mask+tlrc' \
            -expr 'a*b' -prefix 3dMEMA_result_t_stat_masked -datum float   
                         
# Binarizing both cluster masks
   3dcalc -a 'Positive_clust_mask+tlrc' -expr 'ispositive(a-0.5)' \
            -prefix Positive_binary_clust_mask                 

   3dcalc -a 'Negative_clust_mask+tlrc' -expr 'ispositive(a-0.5)' \
            -prefix Negative_binary_clust_mask                

   3dcalc -a Positive_binary_clust_mask+tlrc -b 3dMEMA_result_t_stat_masked+tlrc \
            -expr 'a*b' -prefix 3dMEMA_result_positive_t_stat_clustered -datum float   

   3dcalc -a Negative_binary_clust_mask+tlrc -b 3dMEMA_result_t_stat_masked+tlrc \
            -expr '-a*b' -prefix 3dMEMA_result_negative_t_stat_clustered -datum float

# Convert to NIFTI for upload to Neurovault
  3dAFNItoNIFTI -prefix 3dMEMA_result_B 3dMEMA_result+tlrc"[0]"
  3dAFNItoNIFTI -prefix 3dMEMA_result_t_stat 3dMEMA_result+tlrc"[1]"
  3dAFNItoNIFTI 3dMEMA_result_t_stat_masked+tlrc
  3dAFNItoNIFTI -prefix Positive_clustered_t_stat 3dMEMA_result_positive_t_stat_clustered+tlrc
  3dAFNItoNIFTI -prefix Negative_clustered_t_stat 3dMEMA_result_negative_t_stat_clustered+tlrc
  3dAFNItoNIFTI mask+tlrc
