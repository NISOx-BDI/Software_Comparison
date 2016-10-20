#!/bin/bash

## Compares 3col onsets created from BIDS .tsv events to old onset files

Base=/storage/essicd/data/NIDM-Ex/
shopt -s nullglob # No-match globbing expands to null

cd $Base

StudyOLD=ds000001
StudyNEW=ds001
Nsub=16
Nrun=3
Ncon=11
TASK=task-balloonanalogrisktask
CON01=pumps_fixed
CON02=pumps_fixed_pmod
CON03=pumps_RT
CON04=cash_fixed
CON05=cash_fixed_pmod
CON06=cash_RT
CON07=explode_fixed
CON08=explode_fixed_pmod
CON09=control_pumps_fixed
CON10=control_pumps_fixed_pmod
CON11=control_pumps_RT



for ((s=1;s<=Nsub;s++)) ; do

  s2=$(printf %02d $s)
  s3=$(printf %03d $s)

  for ((r=1;r<=Nrun;r++)); do

      r2=$(printf %02d $r)
      r3=$(printf %03d $r)

      for ((t=1; t<=Ncon;t++)); do
	      c2=$(printf %02d $t)
	      c3=$(printf %03d $t)

	      echo "Subject $s2 Run $r2 Contrast $c2"

	      TMPCON="CON$c2"

     	      A=Data/"$StudyOLD"/sub"$s3"/model/model001/onsets/task001_run"${r3}"/cond"$c3".txt
              B=BIDS_Data/RESULTS/SOFTWARE_COMPARISON/"$StudyNEW"/FSL/ONSETS/sub-"$s2"_run-"$r2"_"${!TMPCON}".txt
     
      ## some sort of diff, my diff snippet etc.
      # diff $A $B
		echo $A
		echo $B

		TMPFILE=$(mktemp) || { echo "Failed to create temp file"; exit 1; }

		paste $A $B >> $TMPFILE
	
		VAR=$(awk 'function abs(v) {return v < 0 ? -v : v}
 		 {d+=(abs($1-$4)>0.01)+(abs($2-$5)>0.01)+(abs($3-$6)>0.01)}
  		END{print d}' $TMPFILE)

		echo $VAR > $TMPFILE
		echo "Subject $s2 Run $r2 Contrast $c2" >> $TMPFILE

	done
  done
done

s=0

for f in /tmp/tmp.*; do
	t=$(sed '1q;d' $f)
	s=$(($s + $t))

	if [ "$t" != "0" ] ; then
	echo $(sed '2q;d' $f) >> /tmp/RESULTS
	echo $t >> /tmp/RESULTS
	fi
done

echo "In total $s events had unmatching values" >> /tmp/RESULTS
