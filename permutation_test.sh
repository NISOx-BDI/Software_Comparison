cd /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL2/permutation_test


# t-test analysis
3dttest++ -Clustsim 1 -prefix ttest++_Clustsim_result       \
          -mask /Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL2/permutation_test/../mask.nii   \
          -setA setA                   \
             01 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-01/sub01.results/stats.sub01+tlrc.HEAD[14]" \
             02 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-02/sub02.results/stats.sub02+tlrc.HEAD[14]" \
             03 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-03/sub03.results/stats.sub03+tlrc.HEAD[14]" \
             04 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-08/sub08.results/stats.sub08+tlrc.HEAD[14]" \
             05 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-09/sub09.results/stats.sub09+tlrc.HEAD[14]" \
             06 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-10/sub10.results/stats.sub10+tlrc.HEAD[14]" \
             07 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-11/sub11.results/stats.sub11+tlrc.HEAD[14]" \
             08 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-14/sub14.results/stats.sub14+tlrc.HEAD[14]" \
             09 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-15/sub15.results/stats.sub15+tlrc.HEAD[14]" \
             10 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-17/sub17.results/stats.sub17+tlrc.HEAD[14]" \
             11 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-18/sub18.results/stats.sub18+tlrc.HEAD[14]" \
             12 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-21/sub21.results/stats.sub21+tlrc.HEAD[14]" \
             13 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-22/sub22.results/stats.sub22+tlrc.HEAD[14]" \
             14 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-26/sub26.results/stats.sub26+tlrc.HEAD[14]" \
             15 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-27/sub27.results/stats.sub27+tlrc.HEAD[14]" \
             16 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-28/sub28.results/stats.sub28+tlrc.HEAD[14]" \
             17 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-30/sub30.results/stats.sub30+tlrc.HEAD[14]" \
             18 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-31/sub31.results/stats.sub31+tlrc.HEAD[14]" \
             19 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-32/sub32.results/stats.sub32+tlrc.HEAD[14]" \
             20 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-43/sub43.results/stats.sub43+tlrc.HEAD[14]" \
             21 "/Users/maullz/Desktop/Software_Comparison/ds109/AFNI/LEVEL1/sub-48/sub48.results/stats.sub48+tlrc.HEAD[14]" 
