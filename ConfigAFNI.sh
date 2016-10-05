#!/bin/bash

. /Users/maullz/Desktop/SOFTWARE_COMPARISON_DATA/bin/ConfigAFNIpre.sh
shopt -s nullglob # No-match globbing expands to null

cd $Base

cmds=$(echo subj.sub01/cmd.ap.sub01)

for ((i=2;i<=$Nsub;i++)) ; do
	SUB=sub-$(printf %02d $i)
	SHORTSUB=sub$(printf %02d $i)

	mkdir subj.$SHORTSUB

	echo -n "===== Subject $SUB    "

	for cmd in $cmds ; do

		cat $cmd | \
	    sed 's/@@SUB@@/'$SUB'/g' | \
	    sed 's/@@SHORTSUB@@/'$SHORTSUB'/g' \
	    > subj.$SHORTSUB/cmd.ap.$SHORTSUB
    done

   echo " "
done

for cmd in $cmds ; do
	echo -n "===== Subject sub-01    "

	cat $cmd | \
	sed 's/@@SUB@@/'sub-01'/g' | \
    sed 's/@@SHORTSUB@@/'sub01'/g' \
	 > subj.sub01/$(basename $cmd)
done

echo " "

echo "#### To run..."

for ((i=1;i<=$Nsub;i++)) ; do

	SHORTSUB=sub$(printf %02d $i)
   
    for cmd in $cmds ; do
		echo "subj.$SHORTSUB/cmd.ap.$SHORTSUB; \\"
    done

done
