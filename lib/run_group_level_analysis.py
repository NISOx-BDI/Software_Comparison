import glob
import string
import os
from subprocess import check_call


def run_group_level_analyses(level1_dir, group_level_fsf, level2_dir):

    scripts_dir = os.path.join(level2_dir, os.pardir, 'SCRIPTS')

    if os.path.isdir(scripts_dir):
        os.mkdir(scripts_dir)

    values['out_dir'] = level2_dir

    feat_dirs = glob.glob(os.path.join(level1_dir, 'sub-*', "combined.gfeat", "cope" + contrast_id + ".feat"))

    for i, feat_dir in enumerate(feat_dirs):
        values['feat_' + str(i+1)] = feat_dir

    with open(group_level_fsf) as f:
        tpm = f.read()
        t = string.Template(tpm)
        sub_fsf = t.substitute(values)

    group_fsf_file = os.path.join(scripts_dir, 'level3.fsf')
    with open(group_fsf_file, "w") as f:
        f.write(sub_fsf)

    check_call("feat " + group_fsf_file)

# out_dir=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL2/group
# feat_1=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL1/sub-01/combined.gfeat/cope1.feat
# feat_2=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL1/sub-02/combined.gfeat/cope1.feat
# feat_3=/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON/ds001/FSL/LEVEL1/sub-03/combined.gfeat/cope1.feat
# ...
