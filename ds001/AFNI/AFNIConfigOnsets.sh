#!/bin/bash

Con1="cash_demean"
Con2="control_pumps_demean"
Con3="explode_demean"
Con4="pumps_demean"
Nsub=16
Study=ds001

Base=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/"$Study"/AFNI/ONSETS
shopt -s nullglob # No-match globbing expands to null

cd $Base

for ((i=1;i<=$Nsub;i++)) ; do
	cat sub-"$(printf %02d $i)"_*_"$Con1"_afni.1d > sub-"$(printf %02d $i)"_combined_"$Con1"_afni.1d
	cat sub-"$(printf %02d $i)"_*_"$Con2"_afni.1d > sub-"$(printf %02d $i)"_combined_"$Con2"_afni.1d
	cat sub-"$(printf %02d $i)"_*_"$Con3"_afni.1d > sub-"$(printf %02d $i)"_combined_"$Con3"_afni.1d
	cat sub-"$(printf %02d $i)"_*_"$Con4"_afni.1d > sub-"$(printf %02d $i)"_combined_"$Con4"_afni.1d
done

