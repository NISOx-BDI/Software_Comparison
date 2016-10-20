#!/bin/bash

###  Stuff to be run only once for Feat configuration

Base=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON
shopt -s nullglob # No-match globbing expands to null

cd $Base

Study=ds001
Nsub=16
Nrun=3
fsfs=$(echo $Study/FSL/SCRIPTS/sub-01-combined-analysis.fsf)
#fsfs=$TemplSubj/RESULTS/Taste_Bev.fsf

for fsf in $fsfs ; do
    cat $fsf | \
	sed 's%^\(set fmri(outputdir) "\).*FSL/LEVEL1/sub-01/combined%\1'$Base'/'$Study'/FSL/LEVEL1/@@SUB@@/combined%' | \
	sed 's%^\(set feat_files(1) "\).*FSL/LEVEL1/sub-01/run-01.feat%\1'$Base'/'$Study'/FSL/LEVEL1/@@SUB@@/run-01.feat%' | \
	sed 's%^\(set feat_files(2) "\).*FSL/LEVEL1/sub-01/run-02.feat%\1'$Base'/'$Study'/FSL/LEVEL1/@@SUB@@/run-02.feat%' | \
	sed 's%^\(set feat_files(3) "\).*FSL/LEVEL1/sub-01/run-03.feat%\1'$Base'/'$Study'/FSL/LEVEL1/@@SUB@@/run-03.feat%'   \
	> $Study/FSL/SCRIPTS/$(basename $fsf)
done 

