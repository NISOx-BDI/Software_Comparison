#!/bin/bash

. /storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/SCRIPTS/ConfigFeatPreSC.sh
shopt -s nullglob # No-match globbing expands to null

cd $Base

Src=$Study/FSL/SCRIPTS
fsfs=$(echo $Src/sub-01-run-01-analysis.fsf)

for ((j=1;j<=$Nrun;j++)) ; do

	RUN=run-$(printf %02d $j)
	
	for ((i=2;i<=$Nsub;i++)) ; do

	    SUB=sub-$(printf %02d $i)

	    echo -n "===== Subject $SUB $RUN   "

	    for fsf in $fsfs ; do

		echo -n "$(basename $fsf .fsf) "
		ImData=$Study/FSL/PREPROCESSING/FUNCTIONAL/"$SUB"_"$TASK"_"$RUN"_bold.nii
		sTDIM=$(fslinfo "$ImData" | awk '/^dim4/ {print $2}')
		cat $fsf | \
			sed 's/@@RUN@@/'$RUN'/g' | \
		    sed 's/@@SUB@@/'$SUB'/g' | \
		    sed 's/@@TDIM@@/'$sTDIM'/' \
		    > $Src/$SUB-$RUN-analysis.fsf
	    done

	    echo " "

	done
done


for ((j=2;j<=$Nrun;j++)) ; do

	RUN=run-$(printf %02d $j)

	for fsf in $fsfs ; do
		echo -n "===== Subject sub-01 $RUN   "
		echo -n "$(basename $fsf .fsf) "
		Sub01ImData=$Study/FSL/PREPROCESSING/FUNCTIONAL/sub-01_"$TASK"_"$RUN"_bold.nii
		Sub01sTDIM=$(fslinfo "$Sub01ImData" | awk '/^dim4/ {print $2}')
		cat $fsf | \
		  sed 's/@@RUN@@/'$RUN'/g' | \
	  	  sed 's/@@SUB@@/'sub-01'/g' | \
	   	  sed 's/@@TDIM@@/'$Sub01sTDIM'/' \
	   	 > $Src/sub-01-$RUN-analysis.fsf
	done
done

for fsf in $fsfs ; do
	echo -n "===== Subject sub-01 run-01   "
	echo -n "$(basename $fsf .fsf) "
	Sub01Run01ImData=$Study/FSL/PREPROCESSING/FUNCTIONAL/sub-01_"$TASK"_run-01_bold.nii
	Sub01Run01sTDIM=$(fslinfo "$Sub01Run01ImData" | awk '/^dim4/ {print $2}')
	cat $fsf | \
		sed 's/@@RUN@@/'run-01'/g' | \
	    sed 's/@@SUB@@/'sub-01'/g' | \
	    sed 's/@@TDIM@@/'$Sub01sTDIM'/' \
	    > $Src/$(basename $fsf)
done



echo " "

echo "#### To run..."

for ((i=1;i<=$Nsub;i++)) ; do
	for ((j=1;j<=Nrun;j++)) ; do
	SUB=sub-$(printf %02d $i)
	RUN=run-$(printf %02d $j)
    	for fsf in $fsfs ; do
		echo "feat $Src/$SUB-$RUN-analysis.fsf; \\"
    	done
    done
done
