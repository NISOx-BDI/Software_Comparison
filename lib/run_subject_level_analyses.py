import glob
import string
import os
from subprocess import check_call


def run_subject_level_analyses(level1_dir, sub_level_fsf, level2_dir):

    scripts_dir = os.path.join(level2_dir, os.pardir, 'SCRIPTS')

    if os.path.isdir(scripts_dir):
        os.mkdir(scripts_dir)

    sub_dirs = glob.glob(os.path.join(level1_dir, 'sub-*'))

    for sub_dir in sub_dirs:
        subreg = re.search('sub-\d+', sub_dir)
        sub = subreg.group(0)

        values['out_dir'] = os.path.join(sub_dir, "combined")

        feat_dirs = glob.glob(os.path.join(sub_dir, sub, '*.feat'))

        for i, feat_dir in enumerate(feat_dirs):
            values['feat_' + str(i+1)] = feat_dir

            with open(sub_level_fsf) as f:
                tpm = f.read()
                t = string.Template(tpm)
                sub_fsf = t.substitute(values)

            sub_fsf_file = os.path.join(scripts_dir, sub + '_level2.fsf')
            with open(sub_fsf_file, "w") as f:
                f.write(sub_fsf)

            check_call("feat " + sub_fsf_file)

# out_dir='/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL1/sub-01/combined'
# feat_1=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL1/sub-01/run-01.feat
# feat_2=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL1/sub-01/run-02.feat
# feat_3=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL1/sub-01/run-03.feat
