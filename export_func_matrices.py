import glob
import os
import nibabel

data_dir = "/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON\
/ds001/FSL/LEVEL1/sub-**/run-**.feat/reg/"


reg_funcs = glob.glob(os.path.join(data_dir, 'example_func2highres.nii.gz'))
for reg_func in reg_funcs:
    print(reg_func)
