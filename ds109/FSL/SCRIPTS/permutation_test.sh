cd /storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/FSL/LEVEL2/permutation_test

fslmerge -t contrasts /storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/FSL/LEVEL1/sub-*/combined.gfeat/cope1.feat/stats/cope1.nii.gz
randomise -i contrasts -o OneSampT -d /storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/FSL/LEVEL2/permutation_test/../group.gfeat/design.mat -t /storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/FSL/LEVEL2/permutation_test/../group.gfeat/design.con -x -c `ptoz 0.005` -n 10000 -m /storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds109/FSL/LEVEL2/permutation_test/../group.gfeat/cope1.feat/mask.nii.gz
fslmaths OneSampT_clustere_corrp_tstat1 -thr 0.95 -bin -mul OneSampT_tstat1 05FWECorrected_OneSampT_pos_exc_set
fslmaths OneSampT_clustere_corrp_tstat2 -thr 0.95 -bin -mul OneSampT_tstat2 05FWECorrected_OneSampT_neg_exc_set
