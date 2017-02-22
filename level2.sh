cd /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL2

# Group analysis with weighted least squares
3dMEMA -prefix 3dMEMA_result       \
          -set controls                   \
             01 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-01/sub01.results/stats.sub01+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-01/sub01.results/stats.sub01+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             02 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-02/sub02.results/stats.sub02+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-02/sub02.results/stats.sub02+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             03 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-03/sub03.results/stats.sub03+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-03/sub03.results/stats.sub03+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             04 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-08/sub08.results/stats.sub08+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-08/sub08.results/stats.sub08+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             05 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-09/sub09.results/stats.sub09+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-09/sub09.results/stats.sub09+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             06 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-10/sub10.results/stats.sub10+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-10/sub10.results/stats.sub10+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             07 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-11/sub11.results/stats.sub11+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-11/sub11.results/stats.sub11+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             08 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-14/sub14.results/stats.sub14+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-14/sub14.results/stats.sub14+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             09 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-15/sub15.results/stats.sub15+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-15/sub15.results/stats.sub15+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             10 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-17/sub17.results/stats.sub17+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-17/sub17.results/stats.sub17+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             11 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-18/sub18.results/stats.sub18+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-18/sub18.results/stats.sub18+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             12 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-21/sub21.results/stats.sub21+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-21/sub21.results/stats.sub21+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             13 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-22/sub22.results/stats.sub22+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-22/sub22.results/stats.sub22+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             14 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-26/sub26.results/stats.sub26+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-26/sub26.results/stats.sub26+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             15 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-27/sub27.results/stats.sub27+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-27/sub27.results/stats.sub27+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             16 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-28/sub28.results/stats.sub28+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-28/sub28.results/stats.sub28+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             17 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-30/sub30.results/stats.sub30+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-30/sub30.results/stats.sub30+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             18 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-31/sub31.results/stats.sub31+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-31/sub31.results/stats.sub31+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             19 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-32/sub32.results/stats.sub32+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-32/sub32.results/stats.sub32+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             20 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-43/sub43.results/stats.sub43+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-43/sub43.results/stats.sub43+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] \
             21 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-48/sub48.results/stats.sub48+tlrc['false_belief_vs_false_photo_GLT#0_Coef'] /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-48/sub48.results/stats.sub48+tlrc['false_belief_vs_false_photo_GLT#0_Tstat'] 

# Create a group mask
3dMean -mask_inter -prefix mask `ls /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-*/sub*.results/mask_group*.HEAD`

# Simulations for FWE corrected cluster-size inference
# 0.591284 5.93789 15.1334 is the average of the 3dFWHMx -acf calculations applied
# to the blur_est.sub_xxx.1D files for the 16 subjects
3dClustSim -both -mask mask+tlrc -acf 0.591284 5.93789 15.1334 -prefix ClustSim 

# Clusterizing the results for a height threshold z > 2.3 
3dclust -1Dformat -nosum -1dindex 1 -1tindex 1 -2thresh -1e+09 2.845 -dxyz=1 -savemask Positive_clust_mask 1.01 127 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL2/3dMEMA_result+tlrc.HEAD
 
3dclust -1Dformat -nosum -1dindex 1 -1tindex 1 -2thresh -2.845 1e+09 -dxyz=1 -savemask Negative_clust_mask 1.01 127 /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL2/3dMEMA_result+tlrc.HEAD

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