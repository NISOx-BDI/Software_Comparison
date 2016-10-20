#!/bin/bash

Study=ds001

Base=/Users/maullz/Desktop/SOFTWARE_COMPARISON_DATA/RESULTS/$Study/AFNI/LEVEL1/subject_results/group.control/
shopt -s nullglob # No-match globbing expands to null

cd $Base

Nsub=16

cmds=$(echo subj.sub01/cmd.ap.sub01)

for cmd in $cmds ; do
	cat $cmd | \
	sed 's/sub-01/@@SUB@@/g' | \
	sed 's/sub01/@@SHORTSUB@@/g' \
	> subj.sub01/$(basename $cmd)
done
