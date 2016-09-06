#!/bin/bash

### Script to convert all .tsv onset files to 3col files for a given study

Base=/storage/essicd/data/NIDM-Ex/BIDS_Data/
shopt -s nullglob # No-match globbing expands to null

cd $Base

Study=ds001
BIDSStudy=ds001_R1.1.0
NSub=16
NRun=3
TASK=balloonanalogrisktask
CON01Input=pumps_demean
CON01Output=pumps
CON02Input=cash_demean
CON02Output=cash
CON03Input=explode_demean
CON03Output=explode
CON04Input=control_pumps_demean
CON04Output=control_pumps

for ((i=1;i<=$NSub;i++)) ; do

	SUB=sub-$(printf %02d $i)
	TSVDir=DATA/BIDS/"$BIDSStudy"/"$SUB"/func
	ThreeColDir=RESULTS/SOFTWARE_COMPARISON/"$Study"/FSL/ONSETS	
	
	for ((j=1;j<=$NRun;j++)) ; do

		RUN=run-$(printf %02d $j)

		BIDSto3col.sh -e "$CON01Input" -h "$CON01Input" -n "$TSVDir"/"$SUB"_task-"$TASK"_"$RUN"_events.tsv "$ThreeColDir"/"$SUB"_"$RUN"_"$CON01Output"_fixed
		BIDSto3col.sh -e "$CON01Input" -d "$CON01Input" -n "$TSVDir"/"$SUB"_task-"$TASK"_"$RUN"_events.tsv "$ThreeColDir"/"$SUB"_"$RUN"_"$CON01Output"_RT

		BIDSto3col.sh -e "$CON02Input" -h "$CON02Input" -n "$TSVDir"/"$SUB"_task-"$TASK"_"$RUN"_events.tsv "$ThreeColDir"/"$SUB"_"$RUN"_"$CON02Output"_fixed
		BIDSto3col.sh -e "$CON02Input" -d "$CON02Input" -n "$TSVDir"/"$SUB"_task-"$TASK"_"$RUN"_events.tsv "$ThreeColDir"/"$SUB"_"$RUN"_"$CON02Output"_RT

		BIDSto3col.sh -e "$CON03Input" -h "$CON03Input" -n "$TSVDir"/"$SUB"_task-"$TASK"_"$RUN"_events.tsv "$ThreeColDir"/"$SUB"_"$RUN"_"$CON03Output"_fixed

		BIDSto3col.sh -e "$CON04Input" -h "$CON04Input" -n "$TSVDir"/"$SUB"_task-"$TASK"_"$RUN"_events.tsv "$ThreeColDir"/"$SUB"_"$RUN"_"$CON04Output"_fixed
		BIDSto3col.sh -e "$CON04Input" -d "$CON04Input" -n "$TSVDir"/"$SUB"_task-"$TASK"_"$RUN"_events.tsv "$ThreeColDir"/"$SUB"_"$RUN"_"$CON04Output"_RT

	done
done



