#!/bin/bash
#
# Script: Amendds120tsv.sh
# Purpose: Amends all the ds120 tsv files in a directory, concatenating the trial_type with trial_phase columns so BIDSto3col.sh can be applied
# Author: A Bowring a.bowring@warwick.ac.uk
# Version: 1.0   20 April 2017
#

Usage() {
cat <<EOF
Usage: `basename $0` Dir 

Reads all .tsv files in subdirectories of Dir, and concatenates the third column with the fourth column.
This is for particular use with ds120 tsv files to concatenate the trial_type and trial_phase columns
so BIDSto3col.sh can obtain 'incentive + response' conditions
EOF
exit
}

if (( $# < 1 )) ; then
    Usage
fi

Dir="$1"
for file in $(find $1 -name '*_events.tsv')
do 
awk 'BEGIN {OFS="\t"}; NR>1 {$3=$3"_"$4} {print $0}' < "$file" > "$file"_temp
mv "$file"_temp "$file"
done
