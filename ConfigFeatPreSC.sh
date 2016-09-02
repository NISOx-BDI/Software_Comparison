#!/bin/bash

###  Stuff to be run only once for Feat configuration

Base=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON
shopt -s nullglob # No-match globbing expands to null

cd $Base

Study=ds001
Nsub=16
Nrun=3
TASK=task-balloonanalogrisktask
CON01=pumps_demean
CON02=cash_demean
CON03=explode_demean
CON04=control_pumps_demean
fsfs=$(echo $Study/FSL/SCRIPTS/sub-01-run-01-analysis.fsf)
#fsfs=$TemplSubj/RESULTS/Taste_Bev.fsf

for fsf in $fsfs ; do
    cat $fsf | \
	sed 's/^\(set fmri(npts) \).*$/\1@@TDIM@@/' | \
	sed 's%^\(set feat_files(1) "\).*PREPROCESSING/FUNCTIONAL/sub-01_'$TASK'_run-01_bold%\1'$Base'/'$Study'/SPM/PREPROCESSING/FUNCTIONAL/@@SUB@@_'$TASK'_@@RUN@@_bold%' | \
	sed 's%^\(set highres_files(1) "\).*ANATOMICAL/sub-01_T1w_brain%\1'$Base'/'$Study'/SPM/PREPROCESSING/ANATOMICAL/@@SUB@@_T1w_brain%' | \
	sed 's%^\(set fmri(outputdir) "\).*FSL/LEVEL1/sub-01/run-01%\1'$Base'/'$Study'/FSL/LEVEL1/@@SUB@@/@@RUN@@%' | \
	sed 's%^\(set fmri(custom1) "\).*FSL/ONSETS/sub-01_run-01_'$CON01'.txt%\1'$Base'/'$Study'/FSL/ONSETS/@@SUB@@_@@RUN@@_'$CON01'.txt%' | \
	sed 's%^\(set fmri(custom2) "\).*FSL/ONSETS/sub-01_run-01_'$CON02'.txt%\1'$Base'/'$Study'/FSL/ONSETS/@@SUB@@_@@RUN@@_'$CON02'.txt%' | \
	sed 's%^\(set fmri(custom3) "\).*FSL/ONSETS/sub-01_run-01_'$CON03'.txt%\1'$Base'/'$Study'/FSL/ONSETS/@@SUB@@_@@RUN@@_'$CON03'.txt%' | \
	sed 's%^\(set fmri(custom4) "\).*FSL/ONSETS/sub-01_run-01_'$CON04'.txt%\1'$Base'/'$Study'/FSL/ONSETS/@@SUB@@_@@RUN@@_'$CON04'.txt%'   \
	> $Study/FSL/SCRIPTS/$(basename $fsf)
done 
