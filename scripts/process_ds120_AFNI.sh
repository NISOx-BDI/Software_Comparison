#!/bin/bash
#$ -V
#$ -S /bin/bash
#$ -l h_vmem=16G
#$ -l h_rt=12:00:00
#$ -o /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/log
#$ -e /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/log

. /etc/profile

module add afni

python /home/maullz/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/scripts/process_ds120_AFNI.py
