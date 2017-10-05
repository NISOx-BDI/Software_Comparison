import nibabel as nib
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
from matplotlib import cm as cm

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

def correlation_matrix(df):
    mask = np.tri(df.shape[0], k=0)
    mask = 1-mask
    df = np.ma.array(df, mask=mask)
    fig = plt.figure()
    ax1 = fig.add_subplot(111)
    cmap = cm.get_cmap('Reds')
    cmap.set_bad('w')
    cax = ax1.imshow(df, interpolation="nearest", cmap=cmap)
    plt.title('Dice Coefficients')
    labels=['','AFNI','FSL','SPM','AFNI perm','FSL perm','SPM perm']
    ax1.set_xticklabels(labels,fontsize=6)
    ax1.set_yticklabels(labels,fontsize=6)
    # Add colorbar, make sure to specify tick locations to match desired ticklabels
    fig.colorbar(cax, ticks=[0,0.2,0.4,0.6,0.8,1])
    ax1.spines['right'].set_visible(False)
    ax1.spines['top'].set_visible(False)
    ax1.yaxis.set_ticks_position('left')
    ax1.xaxis.set_ticks_position('bottom')
    plt.show()

def dice(afni_exc_set_file, spm_exc_set_file,
         afni_reslice_spm_pos_exc, afni_spm_reslice_pos_exc,
         afni_perm_pos_exc, spm_perm_pos_exc,
         afni_reslice_spm_pos_exc_perm, afni_spm_reslice_pos_exc_perm,
         afni_exc_set_file_neg=None, spm_exc_set_file_neg=None,
         afni_reslice_spm_neg_exc=None, afni_spm_reslice_neg_exc=None,
         afni_reslice_fsl_pos_exc=None, afni_reslice_fsl_neg_exc=None, 
         afni_fsl_reslice_pos_exc=None, afni_fsl_reslice_neg_exc=None,
         fsl_exc_set_file=None, fsl_exc_set_file_neg=None, 
         fsl_reslice_spm_pos_exc=None, fsl_reslice_spm_neg_exc=None,
         fsl_spm_reslice_pos_exc=None, fsl_spm_reslice_neg_exc=None,
         fsl_perm_pos_exc=None, 
         afni_reslice_fsl_pos_exc_perm=None, afni_fsl_reslice_pos_exc_perm=None,
         fsl_reslice_spm_pos_exc_perm=None, fsl_spm_reslice_pos_exc_perm=None):

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
    
    # Get data from permutation test excursion set images
    afni_pos_dat_perm = nib.load(afni_perm_pos_exc).get_data()
    if fsl_perm_pos_exc is not None:
        fsl_pos_dat_perm = nib.load(fsl_perm_pos_exc).get_data()
    spm_pos_dat_perm = nib.load(spm_perm_pos_exc).get_data()
    
    # Get data from permutation test resliced images
    if fsl_perm_pos_exc is not None:
        afni_res_fsl_pos_dat_perm = nib.load(afni_reslice_fsl_pos_exc_perm).get_data()
        afni_fsl_res_pos_dat_perm = nib.load(afni_fsl_reslice_pos_exc_perm).get_data()
    
    afni_res_spm_pos_dat_perm = nib.load(afni_reslice_spm_pos_exc_perm).get_data()
    afni_spm_res_pos_dat_perm = nib.load(afni_spm_reslice_pos_exc_perm).get_data()
    
    if fsl_perm_pos_exc is not None:
        fsl_res_spm_pos_dat_perm = nib.load(fsl_reslice_spm_pos_exc_perm).get_data()
        fsl_spm_res_pos_dat_perm = nib.load(fsl_spm_reslice_pos_exc_perm).get_data()
    
    # *** Obtain Dice coefficient for each combination of images
    # Comparison of replication analyses
    if fsl_exc_set_file is not None:
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
    
    # Comparison of permutation tests
    if fsl_perm_pos_exc is not None:
        afni_res_fsl_pos_dice_perm = sorrenson_dice(afni_res_fsl_pos_dat_perm, fsl_pos_dat_perm)
        afni_fsl_res_pos_dice_perm = sorrenson_dice(afni_fsl_res_pos_dat_perm, afni_pos_dat_perm)
    
    afni_res_spm_pos_dice_perm = sorrenson_dice(afni_res_spm_pos_dat_perm, spm_pos_dat_perm)
    afni_spm_res_pos_dice_perm = sorrenson_dice(afni_spm_res_pos_dat_perm, afni_pos_dat_perm)
    
    if fsl_perm_pos_exc is not None:
        fsl_res_spm_pos_dice_perm = sorrenson_dice(fsl_res_spm_pos_dat_perm, spm_pos_dat_perm)
        fsl_spm_res_pos_dice_perm = sorrenson_dice(fsl_spm_res_pos_dat_perm, fsl_pos_dat_perm)
    
    # Intra-software comparison of replications against permutations
    afni_rep_perm_pos_dice = sorrenson_dice(afni_pos_dat, afni_pos_dat_perm)
    fsl_rep_perm_pos_dice = sorrenson_dice(fsl_pos_dat, fsl_pos_dat_perm)
    spm_rep_perm_pos_dice = sorrenson_dice(spm_pos_dat, spm_pos_dat_perm)
    
    # *** Printing results
    print "AFNI/FSL positive activation dice coefficient = %.6f" % afni_res_fsl_pos_dice
    print "FSL/AFNI positive activation dice coefficient = %.6f\n" % afni_fsl_res_pos_dice
    
    if afni_res_fsl_neg_dice != 0:
        print "AFNI/FSL negative activation dice coefficient = %.6f" % afni_res_fsl_neg_dice
        print "FSL/AFNI negative activation dice coefficient = %.6f\n" % afni_fsl_res_neg_dice

    print "AFNI/SPM positive activation dice coefficient = %.6f" % afni_res_spm_pos_dice
    print "SPM/AFNI positive activation dice coefficient = %.6f\n" % afni_spm_res_pos_dice

    if afni_res_spm_neg_dice != 0:
        print "AFNI/SPM negative activation dice coefficient = %.6f" % afni_res_spm_neg_dice
        print "SPM/AFNI negative activation dice coefficient = %.6f\n" % afni_spm_res_neg_dice

    print "FSL/SPM positive activation dice coefficient = %.6f" % fsl_res_spm_pos_dice
    print "SPM/FSL positive activation dice coefficient = %.6f\n" % fsl_spm_res_pos_dice
    
    if fsl_res_spm_neg_dice != 0:
        print "FSL/SPM negative activation dice coefficient = %.6f" % fsl_res_spm_neg_dice
        print "SPM/FSL negative activation dice coefficient = %.6f\n" % fsl_spm_res_neg_dice
        
    print "Permutation test AFNI/SPM positive activation dice coefficient = %.6f" % afni_res_spm_pos_dice_perm
    print "Permutation test SPM/AFNI positive activation dice coefficient = %.6f\n" % afni_spm_res_pos_dice_perm
    
    print "Permutation test AFNI/FSL positive activation dice coefficient = %.6f" % afni_res_fsl_pos_dice_perm
    print "Permutation test FSL/AFNI positive activation dice coefficient = %.6f\n" % afni_fsl_res_pos_dice_perm
    
    print "Permutation test FSL/SPM positive activation dice coefficient = %.6f" % fsl_res_spm_pos_dice_perm
    print "Permutation test SPM/FSL positive activation dice coefficient = %.6f\n" % fsl_spm_res_pos_dice_perm
    
    print "AFNI classical inference/permutation test positive activation dice coefficient = %.6f" % afni_rep_perm_pos_dice
    
    print "FSL classical inference/permutation test positive activation dice coefficient = %.6f" % fsl_rep_perm_pos_dice
    
    print "SPM classical inference/permutation test positive activation dice coefficient = %.6f" % spm_rep_perm_pos_dice
    
    # Creating a table of the Dice coefficients
    dice_coefficients = dict()
    dice_coefficients["1"] = [1, np.mean([afni_res_fsl_pos_dice_perm, afni_fsl_res_pos_dice_perm]),
                                np.mean([afni_res_spm_pos_dice_perm, afni_spm_res_pos_dice_perm]),
                                afni_rep_perm_pos_dice, 0, 0]
    dice_coefficients["2"] = [np.mean([afni_res_fsl_pos_dice_perm, afni_fsl_res_pos_dice_perm]), 1,
                                np.mean([fsl_res_spm_pos_dice_perm, fsl_spm_res_pos_dice_perm]),
                                0, fsl_rep_perm_pos_dice, 0]
    dice_coefficients["3"] = [np.mean([afni_res_spm_pos_dice_perm, afni_spm_res_pos_dice_perm]),                                           np.mean([fsl_res_spm_pos_dice_perm, fsl_spm_res_pos_dice_perm]), 1,
                                0, 0, spm_rep_perm_pos_dice]
    dice_coefficients["4"] = [afni_rep_perm_pos_dice, 0, 0,
                                      1, np.mean([afni_res_fsl_pos_dice_perm, afni_fsl_res_pos_dice_perm]),
                                      np.mean([afni_res_spm_pos_dice_perm, afni_spm_res_pos_dice_perm])]
    dice_coefficients["5"] = [0, fsl_rep_perm_pos_dice, 0,
                                     np.mean([afni_res_fsl_pos_dice_perm, afni_fsl_res_pos_dice_perm]), 1,
                                     np.mean([fsl_res_spm_pos_dice_perm, fsl_spm_res_pos_dice_perm])]
    dice_coefficients["6"] = [0, 0, spm_rep_perm_pos_dice,
                                    np.mean([afni_res_spm_pos_dice_perm, afni_spm_res_pos_dice_perm]),
                                    np.mean([fsl_res_spm_pos_dice_perm, fsl_spm_res_pos_dice_perm]), 1]

    df = pd.DataFrame(dice_coefficients)
    correlation_matrix(df)