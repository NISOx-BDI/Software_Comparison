cd /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL2

# Group analysis with weighted least squares
3dMEMA -prefix 3dMEMA_result       \
          -set controls                   \
             01 /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-01/sub01.results/stats.sub01+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-01/sub01.results/stats.sub01+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             02 /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-02/sub02.results/stats.sub02+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-02/sub02.results/stats.sub02+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             03 /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-03/sub03.results/stats.sub03+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-03/sub03.results/stats.sub03+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             04 /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-04/sub04.results/stats.sub04+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-04/sub04.results/stats.sub04+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             05 /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-05/sub05.results/stats.sub05+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-05/sub05.results/stats.sub05+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             06 /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-06/sub06.results/stats.sub06+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-06/sub06.results/stats.sub06+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             07 /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-07/sub07.results/stats.sub07+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-07/sub07.results/stats.sub07+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             08 /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-08/sub08.results/stats.sub08+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-08/sub08.results/stats.sub08+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             09 /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-09/sub09.results/stats.sub09+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-09/sub09.results/stats.sub09+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             10 /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-10/sub10.results/stats.sub10+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-10/sub10.results/stats.sub10+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             11 /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-11/sub11.results/stats.sub11+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-11/sub11.results/stats.sub11+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             12 /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-12/sub12.results/stats.sub12+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-12/sub12.results/stats.sub12+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             13 /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-13/sub13.results/stats.sub13+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-13/sub13.results/stats.sub13+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             14 /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-14/sub14.results/stats.sub14+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-14/sub14.results/stats.sub14+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             15 /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-15/sub15.results/stats.sub15+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-15/sub15.results/stats.sub15+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             16 /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-16/sub16.results/stats.sub16+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-16/sub16.results/stats.sub16+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat']

# Create a group mask
3dMean -mask_inter -prefix mask `ls /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL1/sub-*/sub*.results/mask_group*.HEAD`             
        
# Simulations for FWE corrected cluster-size inference
# 6.86978 6.64627 6.72331 is the average of second line
# in blur_est.sub_xxx.1D over the 16 subjects
3dClustSim -both -mask mask+tlrc -fwhmxyz 6.84252 6.69859 6.79038 -prefix ClustSim 

# Clusterizing the results for a height threshold z > 2.3 
3dclust -1Dformat -nosum -1dindex 0 -1tindex 1 -2thresh -2.947 2.947 -dxyz=1 -savemask Clust_mask 1.01 67 /Users/maullz/Desktop/Software_Comparison_Dev/ds001/AFNI/LEVEL2/3dMEMA_result+tlrc.HEAD