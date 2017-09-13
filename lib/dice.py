import nibabel as nib
import numpy as np

def sorrenson_dice(data1, data2):
    data1 = np.nan_to_num(data1)
    data2 = np.nan_to_num(data2)
    
    zero_indices_data1 = data1 == 0
    non_zero_indices_data1 = data1 != 0
    zero_indices_data2 = data2 == 0
    non_zero_indices_data2 = data2 != 0
    
    intersection_data = data1 
    intersection_data[zero_indices_data2] = 0 # All values close to 0 in data1 or data2 are 0 in the intersection array
    intersection_indices = intersection_data != 0
    intersection_data[intersection_indices] = 1 # All values in the union of data1 and data2 are set to 1
    numerator = 2*np.sum(intersection_data)
    
    data1[non_zero_indices_data1] = 1
    data2[non_zero_indices_data2] = 1
    denominator = np.sum(data1) + np.sum(data2)
    
    dice_coefficient = numerator/denominator
    return dice_coefficient

def dice(afni_exc_set_file, spm_exc_set_file,
         afni_reslice_spm_pos_exc, afni_spm_reslice_pos_exc, 
         afni_exc_set_file_neg=None, spm_exc_set_file_neg=None,
         afni_reslice_spm_neg_exc=None, afni_spm_reslice_neg_exc=None,
         afni_reslice_fsl_pos_exc=None, afni_reslice_fsl_neg_exc=None, 
         afni_fsl_reslice_pos_exc=None, afni_fsl_reslice_neg_exc=None,
         fsl_exc_set_file=None, fsl_exc_set_file_neg=None, 
         fsl_reslice_spm_pos_exc=None, fsl_reslice_spm_neg_exc=None,
         fsl_spm_reslice_pos_exc=None, fsl_spm_reslice_neg_exc=None):

    # Get data from excursion set images
    afni_pos_dat = nib.load(afni_exc_set_file).get_data()
    if afni_exc_set_file_neg is not None:
        afni_neg_dat = nib.load(afni_exc_set_file_neg).get_data()
    if fsl_exc_set_file is not None:
        fsl_pos_dat = nib.load(fsl_exc_set_file).get_data()
        fsl_neg_dat = nib.load(fsl_exc_set_file_neg).get_data()
    spm_pos_dat = nib.load(spm_exc_set_file).get_data()
    if spm_exc_set_file_neg is not None:
        spm_neg_dat = nib.load(spm_exc_set_file_neg).get_data()

    # Get data from resliced images
    if fsl_exc_set_file is not None:
        afni_res_fsl_pos_dat = nib.load(afni_reslice_fsl_pos_exc).get_data()
        afni_res_fsl_neg_dat = nib.load(afni_reslice_fsl_neg_exc).get_data()
        afni_fsl_res_pos_dat = nib.load(afni_fsl_reslice_pos_exc).get_data()
        afni_fsl_res_neg_dat = nib.load(afni_fsl_reslice_neg_exc).get_data()

    afni_res_spm_pos_dat = nib.load(afni_reslice_spm_pos_exc).get_data()
    if afni_reslice_spm_neg_exc is not None:
        afni_res_spm_neg_dat = nib.load(afni_reslice_spm_neg_exc).get_data()
    afni_spm_res_pos_dat = nib.load(afni_spm_reslice_pos_exc).get_data()
    if afni_spm_reslice_neg_exc is not None:
        afni_spm_res_neg_dat = nib.load(afni_spm_reslice_neg_exc).get_data()
    
    if fsl_exc_set_file is not None:
        fsl_res_spm_pos_dat = nib.load(fsl_reslice_spm_pos_exc).get_data()
        fsl_res_spm_neg_dat = nib.load(fsl_reslice_spm_neg_exc).get_data()
        fsl_spm_res_pos_dat = nib.load(fsl_spm_reslice_pos_exc).get_data()
        fsl_spm_res_neg_dat = nib.load(fsl_spm_reslice_neg_exc).get_data()

        afni_res_fsl_pos_dice = sorrenson_dice(afni_res_fsl_pos_dat, fsl_pos_dat)
        afni_fsl_res_pos_dice = sorrenson_dice(afni_fsl_res_pos_dat, afni_pos_dat)
        afni_res_fsl_neg_dice = sorrenson_dice(afni_res_fsl_neg_dat, fsl_neg_dat)
        afni_fsl_res_neg_dice = sorrenson_dice(afni_fsl_res_neg_dat, afni_neg_dat)

    afni_res_spm_pos_dice = sorrenson_dice(afni_res_spm_pos_dat, spm_pos_dat)
    afni_spm_res_pos_dice = sorrenson_dice(afni_spm_res_pos_dat, afni_pos_dat)
    if afni_reslice_spm_neg_exc is not None:
        afni_res_spm_neg_dice = sorrenson_dice(afni_res_spm_neg_dat, spm_neg_dat)
    if afni_spm_reslice_neg_exc is not None:
        afni_spm_res_neg_dice = sorrenson_dice(afni_spm_res_neg_dat, afni_neg_dat)
    
    if fsl_exc_set_file is not None:
        fsl_res_spm_pos_dice = sorrenson_dice(fsl_res_spm_pos_dat, spm_pos_dat)
        fsl_spm_res_pos_dice = sorrenson_dice(fsl_spm_res_pos_dat, fsl_pos_dat)
        fsl_res_spm_neg_dice = sorrenson_dice(fsl_res_spm_neg_dat, spm_neg_dat)
        fsl_spm_res_neg_dice = sorrenson_dice(fsl_spm_res_neg_dat, fsl_neg_dat)

        print "AFNI/FSL positive activation dice coefficient = %s" % afni_res_fsl_pos_dice
        print "FSL/AFNI positive activation dice coefficient = %s\n" % afni_fsl_res_pos_dice

        print "AFNI/FSL negative activation dice coefficient = %s" % afni_res_fsl_neg_dice
        print "FSL/AFNI negative activation dice coefficient = %s\n" % afni_fsl_res_neg_dice

    print "AFNI/SPM positive activation dice coefficient = %s" % afni_res_spm_pos_dice
    print "SPM/AFNI positive activation dice coefficient = %s\n" % afni_spm_res_pos_dice

    if afni_reslice_spm_neg_exc is not None:
        print "AFNI/SPM negative activation dice coefficient = %s" % afni_res_spm_neg_dice
        print "SPM/AFNI negative activation dice coefficient = %s\n" % afni_spm_res_neg_dice

    if fsl_exc_set_file is not None:
        print "FSL/SPM positive activation dice coefficient = %s" % fsl_res_spm_pos_dice
        print "SPM/FSL positive activation dice coefficient = %s\n" % fsl_spm_res_pos_dice

        print "FSL/SPM negative activation dice coefficient = %s" % fsl_res_spm_neg_dice
        print "SPM/FSL negative activation dice coefficient = %s\n" % fsl_spm_res_neg_dice