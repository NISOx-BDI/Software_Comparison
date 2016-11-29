#!/bin/bash

Study=ds001

# Base=/Users/cmaumet/Projects/Data_sharing/dev/Software_Comparison/scripts/lib
shopt -s nullglob # No-match globbing expands to null

# cd $Base

Nsub=16

cmds=$(echo template_ds001_AFNI_level1)

for cmd in $cmds ; do
	cat $cmd | \
	sed 's/sub-01/@@SUB@@/g' | \
	sed 's/sub01/@@SHORTSUB@@/g' \
	> $(basename $cmd)
done
