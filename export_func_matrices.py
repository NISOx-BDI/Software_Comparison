import glob
import os

data_dir = "/storage/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON\
/ds001/FSL/LEVEL1/sub-01/run-01.feat/reg/"


#example_func2highres.nii
print(glob.glob(os.path.join(data_dir, '*.nii.gz')))
