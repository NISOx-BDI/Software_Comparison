#!/bin/bash

## Script for converting 3col files into AFNI 1d files

# shopt -s nullglob # No-match globbing expands to null

###############################################################################
#
# Functions
#
###############################################################################

Usage() {
cat <<EOF
Usage: `basename $0` [options] 3coltoAFNI FSLOnsetDir 

Convert FSL 3-column onset files to AFNI onset file.

EOF
exit
}


Base="$1"
cd $Base

for f in *txt ; do

  AFNI1row="$(dirname $f)/$(basename $f .txt)"
  FSL3Col="$f"
  Col3=$(awk '{ print $3 }' $f)	
  Col3Array=( $Col3 )
  Col2=$(awk '{ print $2 }' $f)	
  Col2Array=( $Col2 )	

  Fail3Col=0
  Fail2Col=0

	for ((i=0;i<${#Col3Array[*]};i++)) ; do
		if [ "${Col3Array[i]}" != "1.0" ] ; then 
			Fail3Col=1
			break
		fi
	done

	for ((j=0;j<${#Col2Array[*]};j++)) ; do
		if [ "${Col2Array[j]}" != "${Col2Array[0]}" ] ; then 
			Fail2Col=1
			break
		fi
	done



	if [ "$Fail3Col" = "0" ] ; then
		if [ "$Fail2Col" = "0" ] ; then
## If neither amplitude or duration modulate, we obtain a standard onset file to be used with Block(d,p)
				awk '{printf("%s ",$1)};END{print ""}' $f  "$FSL3col" > "$AFNI1row"_afni.1d
		else
## If the duration modulates, we obtain an onset file with time:duration points to be used with -stim_times_IM
				awk '{printf("%s:%s ",$1,$2)};END{print ""}' $f  "$FSL3col" > "$AFNI1row"_afni.1d
		fi
			
	else
## If amplitude modules (parametric modulation), we obtain an onset file with time*amplitude points to be used with -stim_times_AM1
		awk '{printf("%s*%s ",$1,$3)};END{print ""}' $f  "$FSL3col" > "$AFNI1row"_afni.1d
	fi


			
done
