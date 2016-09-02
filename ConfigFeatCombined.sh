#!/bin/bash

. /storage/essicd/data/NIDM-Ex/bin/ConfigFeatPreCombined.sh
shopt -s nullglob # No-match globbing expands to null

cd $Base

Src=$Study/FSL/SCRIPTS
fsfs=$(echo $Src/sub-01-combined-analysis.fsf)

for ((i=2;i<=$Nsub;i++)) ; do

    SUB=sub-$(printf %02d $i)

    echo -n "===== Subject $SUB    "

    for fsf in $fsfs ; do

	echo -n "$(basename $fsf .fsf) "
	cat $fsf | \
	    sed 's/@@SUB@@/'$SUB'/'  \
	    > $Src/$SUB-combined-analysis.fsf
    done

    echo " "

done

for fsf in $fsfs ; do
	echo -n "===== Subject sub-01    "
	echo -n "$(basename $fsf .fsf) "
	cat $fsf | \
	    sed 's/@@SUB@@/'sub-01'/'  \
	    > $Src/$(basename $fsf)
done

echo " "

echo "#### To run..."

for ((i=1;i<=$Nsub;i++)) ; do
SUB=sub-$(printf %02d $i)
    for fsf in $fsfs ; do
	echo "feat $Src/$SUB-combined-analysis.fsf; \\"
    done

done
