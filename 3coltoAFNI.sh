#!/bin/bash

Base=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/ONSETS
shopt -s nullglob # No-match globbing expands to null

cd $Base

for f in *txt ; do

  AFNI1row="$(dirname $f)/$(basename $f .txt)"
  FSL3Col="$f"
  Col3=$(awk '{ print $3 }' $f)	
  Col3Array=( $Col3 )
  Fail=0

	for ((i=0;i<${#Col3Array[*]};i++)) ; do
		if [ "${Col3Array[i]}" != "1.0" ] ; then 
			Fail=1
			break
		fi
	done

	if [ "$Fail" = "0" ] ; then
		awk '{printf("%s ",$1)};END{print ""}' $f  "$FSL3col" > "$AFNI1row"_afni.1d
	else
		awk '{printf("%s*%s ",$1,$3)};END{print ""}' $f  "$FSL3col" > "$AFNI1row"_afni.1d
	fi
		
done
