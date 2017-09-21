cd /storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/FSL/LEVEL2/permutation_test

fslmerge -t contrasts /storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/FSL/LEVEL1/sub-*/combined.gfeat/cope1.feat/stats/cope1.nii.gz
randomise -i contrasts -o OneSampT -1 -x -c `ptoz 0.005` -n 10000 
fslmaths OneSampT_clustere_corrp_tstat1 -thr 0.95 -bin -mul OneSampT_clustere_corrp_tstat1 05FWECorrected_OneSampT_clustere_corrp_tstat1
