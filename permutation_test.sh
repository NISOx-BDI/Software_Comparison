cd /storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL2/permutation_test

fslmerge -t contrasts /storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL1/sub-*/combined.gfeat/cope1.feat/stats/cope1.nii.gz
randomise -i contrasts -o OneSampT_pos -1 -x -c `ptoz 0.01` -n 10000 -m /storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL2/permutation_test/../group.gfeat/cope1.feat/mask.nii.gz
fslmaths OneSampT_pos_clustere_corrp_tstat1 -thr 0.95 -bin -mul OneSampT_pos_tstat1 05FWECorrected_OneSampT_pos_exc_set

fslmaths contrasts -mul -1 negative_contrasts
randomise -i negative_contrasts -o OneSampT_neg -1 -x -c `ptoz 0.01` -n 10000 -m /storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL2/permutation_test/../group.gfeat/cope1.feat/mask.nii.gz 
fslmaths OneSampT_neg_clustere_corrp_tstat1 -thr 0.95 -bin -mul OneSampT_neg_tstat1 -mul -1 05FWECorrected_OneSampT_neg_exc_set 
