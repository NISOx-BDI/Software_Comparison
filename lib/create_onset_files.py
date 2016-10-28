import os
from subprocess import check_call
import glob
import re


def create_onset_files(study_dir, OnsetDir, conditions):

    if not os.path.isdir(OnsetDir):
        os.mkdir(OnsetDir)

    sub_dirs = glob.glob(os.path.join(study_dir, 'sub-*'))

    for sub_dir in sub_dirs:
        event_files = glob.glob(os.path.join(sub_dir, 'func', '*.tsv'))

        subreg = re.search('sub-\d+', sub_dir)
        sub = subreg.group(0)

        for event_file in event_files:

            runreg = re.search('run-\d+', sub_dir)
            sub_run = sub + runreg.group(0)

            for cond in conditions:
                if isinstance(cond[0], str):
                    FSL3colfile = os.path.join(
                        OnsetDir, sub_run + '_' + cond[0])
                    check_call(
                        'BIDSto3col.sh -b 4 -e ' + cond[1][0] +
                        ' -d ' + cond[1][1] + ' '
                        + event_file + ' '
                        + FSL3colfile, shell=True)
                else:
                    for cond_name, cond_bids_name in dict(
                            zip([cond[0][1:]], cond[1])):
                        FSL3colfile = os.path.join(
                            OnsetDir, sub_run, cond[1][0])
                        check_call(
                            'BIDSto3col.sh -b 4 -e ' + cond_bids_name +
                            ' -h ' + cond_bids_name + ' ' +
                            event_file + ' ' + FSL3colfile)
                        FSL3col_pmod = FSL3colfile + '_pmod.txt'
                        FSL3col_renamed = FSL3col_pmod.replace(
                            cond[1][0] + '_pmod', cond_name)
                        os.rename(FSL3col_pmod, FSL3col_renamed)
