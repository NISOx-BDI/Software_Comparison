Base=/Users/maullz/Desktop/SOFTWARE_COMPARISON_DATA/RESULTS/ds001/AFNI/LEVEL1/subject_results/group.control

# Group analysis with weighted least squares
3dMEMA -prefix 3dMEMA_result       \
          -set controls                   \
             01 ./subj.sub01/sub01.results/stats.sub01+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] ./subj.sub01/sub01.results/stats.sub01+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             02 ./subj.sub02/sub02.results/stats.sub02+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] ./subj.sub02/sub02.results/stats.sub02+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             03 ./subj.sub03/sub03.results/stats.sub03+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] ./subj.sub03/sub03.results/stats.sub03+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             04 ./subj.sub04/sub04.results/stats.sub04+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] ./subj.sub04/sub04.results/stats.sub04+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             05 ./subj.sub05/sub05.results/stats.sub05+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] ./subj.sub05/sub05.results/stats.sub05+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             06 ./subj.sub06/sub06.results/stats.sub06+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] ./subj.sub06/sub06.results/stats.sub06+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             07 ./subj.sub07/sub07.results/stats.sub07+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] ./subj.sub07/sub07.results/stats.sub07+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             08 ./subj.sub08/sub08.results/stats.sub08+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] ./subj.sub08/sub08.results/stats.sub08+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             09 ./subj.sub09/sub09.results/stats.sub09+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] ./subj.sub09/sub09.results/stats.sub09+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             10 ./subj.sub10/sub10.results/stats.sub10+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] ./subj.sub10/sub10.results/stats.sub10+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             11 ./subj.sub11/sub11.results/stats.sub11+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] ./subj.sub11/sub11.results/stats.sub11+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             12 ./subj.sub12/sub12.results/stats.sub12+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] ./subj.sub12/sub12.results/stats.sub12+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             13 ./subj.sub13/sub13.results/stats.sub13+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] ./subj.sub13/sub13.results/stats.sub13+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             14 ./subj.sub14/sub14.results/stats.sub14+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] ./subj.sub14/sub14.results/stats.sub14+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             15 ./subj.sub15/sub15.results/stats.sub15+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] ./subj.sub15/sub15.results/stats.sub15+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat'] \
             16 ./subj.sub16/sub16.results/stats.sub16+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Coef'] ./subj.sub16/sub16.results/stats.sub16+tlrc['pumps_demean_vs_ctrl_demean_GLT#0_Tstat']

# Create a group mask
3dMean -mask_inter -prefix mask `ls ./subj.sub*/sub*.results/mask_group*.HEAD`             
        
# Simulations for FWE corrected cluster-size inference
# 6.83639 6.69775 6.9135is the average of second line
# in blur_est.sub_xxx.1D over the 16 subjects
3dClustSim -both -mask mask+tlrc -fwhmxyz 6.83639 6.69775 6.9135 -prefix ClustSim 