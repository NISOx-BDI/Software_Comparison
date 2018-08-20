import nibabel as nib
from nibabel.processing import resample_from_to
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
from matplotlib import cm as cm
import scipy
import os
import warnings

def sorrenson_dice(data1_file, data2_file, reslice=True):
    # Load nifti images
    data1_img = nib.load(data1_file)
    data2_img = nib.load(data2_file)

    # Load data from images
    data2 = data2_img.get_data()
    data1 = data1_img.get_data()

    # Get asbolute values (positive and negative blobs are of interest)
    data2 = np.absolute(data2)
    data1 = np.absolute(data1)

    if reslice:
        # Resample data1 on data2 using nearest nneighbours
        data1_resl_img = resample_from_to(data1_img, data2_img, order=0)
        # Load data from images
        data1_res = data1_resl_img.get_data()
        data1_res = np.absolute(data1_res)
            
        # Resample data2 on data1 using nearest nneighbours
        data2_resl_img = resample_from_to(data2_img, data1_img, order=0)        
        data2_res = data2_resl_img.get_data()
        data2_res = np.absolute(data2_res)

    # Masking (compute Dice using intersection of both masks)
    if reslice:
        background_1 = np.logical_or(np.isnan(data1), np.isnan(data2_res))
        background_2 = np.logical_or(np.isnan(data1_res), np.isnan(data2))

        data1 = np.nan_to_num(data1)
        data1_res = np.nan_to_num(data1_res)
        data2 = np.nan_to_num(data2)
        data2_res = np.nan_to_num(data2_res)

        num_activated_1 = np.sum(data1 > 0)
        num_activated_res_1 = np.sum(data1_res>0)
        num_activated_2 = np.sum(data2>0)
        num_activated_res_2 = np.sum(data2_res>0)

        dark_dice_1 = np.zeros(2)
        if num_activated_1 != 0:
            dark_dice_1[0] = np.sum(data1[background_1]>0).astype(float)/num_activated_1*100
        if num_activated_res_1 != 0:
            dark_dice_1[1] = np.sum(data1_res[background_2]>0).astype(float)/num_activated_res_1*100

        dark_dice_2 = np.zeros(2)
        if num_activated_2 != 0:
            dark_dice_2[0] = np.sum(data2[background_2]>0).astype(float)/num_activated_2*100
        if num_activated_res_2 != 0:
            dark_dice_2[1] = np.sum(data2_res[background_1]>0).astype(float)/num_activated_res_2*100

        data1[background_1] = 0
        data2_res[background_1] = 0

        data1_res[background_2] = 0
        data2[background_2] = 0
    else:
        background = np.logical_or(np.isnan(data1), np.isnan(data2))

        data1 = np.nan_to_num(data1)
        data2 = np.nan_to_num(data2)

        num_activated_1 = np.sum(data1 > 0)
        num_activated_2 = np.sum(data2>0)

        dark_dice = np.zeros(2)
        if num_activated_1 !=0:
            dark_dice[0] = np.sum(data1[background]>0).astype(float)/num_activated_1*100

        if num_activated_2 !=0:
            dark_dice[1] = np.sum(data2[background]>0).astype(float)/num_activated_2*100

        data1[background] = 0
        data2[background] = 0

    # Vectorize
    data1 = np.reshape(data1, -1)
    data2 = np.reshape(data2, -1)
    if reslice:
        data1_res = np.reshape(data1_res, -1)
        data2_res = np.reshape(data2_res, -1)

    if reslice:
        dice_res_1 = 1-scipy.spatial.distance.dice(data1_res>0, data2>0)
        dice_res_2 = 1-scipy.spatial.distance.dice(data1>0, data2_res>0)

        if not np.isclose(dice_res_1, dice_res_2, atol=0.01):
            warnings.warn("Resliced 1/2 and 2/1 dices are not close")

        if not np.isclose(dark_dice_1[0], dark_dice_1[1], atol=0.01):
            warnings.warn("Resliced 1/2 and 2/1 dark dices 1 are not close")

        if not np.isclose(dark_dice_2[0], dark_dice_2[1], atol=0.01):
            warnings.warn("Resliced 1/2 and 2/1 dark dices 2 are not close")

        dices = (dice_res_1, dark_dice_1[1], dark_dice_2[1])
    else:
        dices = (1-scipy.spatial.distance.dice(data1>0, data2>0), dark_dice[0], dark_dice[1])
    
    return dices


def ds109_dice_matrix(df, filename=None):
    mask = np.tri(df.shape[0], k=0)
    mask = 1-mask
    dfmsk = np.ma.array(df[:,:,0], mask=mask)
    fig = plt.figure(figsize=(8,8))
    ax1 = fig.add_subplot(111)
    cmap = cm.get_cmap('Reds')
    cmap.set_bad('w')

    cax = ax1.imshow(dfmsk, interpolation="nearest", cmap=cmap, vmin=0, vmax=1)

    for (i, j, k), z in np.ndenumerate(df):
        if (j < i):
            if (k == 0):
                ax1.text(j, i, '{:0.3f}'.format(z), ha='center', va='center',
                         bbox=dict(boxstyle='round', facecolor='white', 
                         edgecolor='0.3'))
            else:
                if (k == 1):
                    offset = -.25
                else:
                    offset = +.25
                if round(z) > 0:
                    ax1.text(j+offset, i+.3, '{:0.0f}%'.format(z), ha='center',
                             va='center',
                             bbox=dict(boxstyle='round', facecolor='grey',
                             edgecolor='0.3'))


    plt.title('Positive Activation Dice Coefficients', fontsize=15)
    labels=['','AFNI','FSL','SPM','AFNI perm','FSL perm','SPM perm']
    ax1.set_xticklabels(labels,fontsize=12)
    ax1.set_yticklabels(labels,fontsize=12)
    # Add colorbar, make sure to specify tick locations to match desired ticklabels
    fig.colorbar(cax, ticks=[0,0.2,0.4,0.6,0.8,1], fraction=0.046, pad=0.04)
    ax1.spines['right'].set_visible(False)
    ax1.spines['top'].set_visible(False)
    ax1.yaxis.set_ticks_position('none')
    ax1.xaxis.set_ticks_position('none')

    if filename is not None:
        plt.savefig(os.path.join('img', filename))

    plt.show()


def negative_dice_matrix(df, filename=None):
    mask = np.tri(df.shape[0], k=0)
    mask = 1-mask
    dfmsk = np.ma.array(df[:,:,0], mask=mask)
    fig = plt.figure(figsize=(8,8))
    ax1 = fig.add_subplot(111)
    cmap = cm.get_cmap('Blues')
    cmap.set_bad('w')
    cax = ax1.imshow(dfmsk, interpolation="nearest", cmap=cmap, vmin=0, vmax=1)

    for (i, j, k), z in np.ndenumerate(df):
        if (j < i):
            if (k == 0):
                ax1.text(j, i, '{:0.3f}'.format(z), ha='center', va='center',
                         bbox=dict(boxstyle='round', facecolor='white', 
                         edgecolor='0.3'))
            else:
                if (k == 1):
                    offset = -.25
                else:
                    offset = +.25
                if round(z) > 0:
                    ax1.text(j+offset, i+.3, '{:0.0f}%'.format(z), ha='center',
                             va='center',
                             bbox=dict(boxstyle='round', facecolor='grey',
                             edgecolor='0.3'))

    plt.title('Negative Activation Dice Coefficients', fontsize=15)
    labels=['','AFNI','FSL','SPM','AFNI perm','FSL perm','SPM perm']
    ax1.set_xticklabels(labels,fontsize=12)
    ax1.set_yticklabels(labels,fontsize=12)
    # Add colorbar, make sure to specify tick locations to match desired ticklabels
    fig.colorbar(cax, ticks=[0,0.2,0.4,0.6,0.8,1], fraction=0.046, pad=0.04)
    ax1.spines['right'].set_visible(False)
    ax1.spines['top'].set_visible(False)
    ax1.yaxis.set_ticks_position('none')
    ax1.xaxis.set_ticks_position('none')

    if filename is not None:
        plt.savefig(os.path.join('img', filename))

    plt.show()

def ds109_neg_dice_matrix(df, filename=None):
    mask = np.tri(df.shape[0], k=0)
    mask = 1-mask
    dfmsk = np.ma.array(df[:, :, 0], mask=mask)
    fig = plt.figure()
    ax1 = fig.add_subplot(111)
    cmap = cm.get_cmap('Blues')
    cmap.set_bad('w')
    cax = ax1.imshow(dfmsk, interpolation="nearest", cmap=cmap, vmin=0, vmax=1)

    for (i, j, k), z in np.ndenumerate(df):
        if j < i:
            if (k == 0):
                ax1.text(j, i, '{:0.3f}'.format(z), ha='center', va='center',
                         bbox=dict(boxstyle='round', facecolor='white',
                         edgecolor='0.3'))
            else:
                if (k == 1):
                    offset = -.25
                else:
                    offset = +.25
                if round(z) > 0:
                    ax1.text(j+offset, i+.3, '{:0.0f}%'.format(z), ha='center',
                             va='center',
                             bbox=dict(boxstyle='round', facecolor='grey',
                             edgecolor='0.3'))

    plt.title('Negative Activation Dice Coefficients', fontsize=15)
    xlabels=['','AFNI', '', 'FSL']
    ylabels=['','','AFNI','','','','FSL','','']
    ax1.set_xticklabels(xlabels,fontsize=12)
    ax1.set_yticklabels(ylabels,fontsize=12)
    # Add colorbar, make sure to specify tick locations to match desired ticklabels
    fig.colorbar(cax, ticks=[0,0.2,0.4,0.6,0.8,1])
    ax1.spines['right'].set_visible(False)
    ax1.spines['top'].set_visible(False)
    ax1.yaxis.set_ticks_position('none')
    ax1.xaxis.set_ticks_position('none')

    if filename is not None:
        plt.savefig(os.path.join('img', filename))

    plt.show()


def ds120_dice_matrix(df, filename=None):
    mask = np.tri(df.shape[0], k=0)
    mask = 1-mask
    dfmsk = np.ma.array(df[:, :, 0], mask=mask)
    fig = plt.figure()
    ax1 = fig.add_subplot(111)
    cmap = cm.get_cmap('Reds')
    cmap.set_bad('w')
    cax = ax1.imshow(dfmsk, interpolation="nearest", cmap=cmap, vmin=0, vmax=1)

    for (i, j, k), z in np.ndenumerate(df):
        if j < i:
            if (k == 0):
                ax1.text(j, i, '{:0.3f}'.format(z), ha='center', va='center',
                         bbox=dict(boxstyle='round', facecolor='white',
                         edgecolor='0.3'))
            else:
                if (k == 1):
                    offset = -.25
                else:
                    offset = +.25
                if round(z) > 0:
                    ax1.text(j+offset, i+.3, '{:0.0f}%'.format(z), ha='center',
                             va='center',
                             bbox=dict(boxstyle='round', facecolor='grey',
                             edgecolor='0.3'))

    plt.title('Positive Activation Dice Coefficients', fontsize=15)
    xlabels=['','AFNI', '', 'SPM']
    ylabels=['','','AFNI','','','','SPM','','']
    ax1.set_xticklabels(xlabels,fontsize=12)
    ax1.set_yticklabels(ylabels,fontsize=12)
    # Add colorbar, make sure to specify tick locations to match desired ticklabels
    fig.colorbar(cax, ticks=[0,0.2,0.4,0.6,0.8,1])
    ax1.spines['right'].set_visible(False)
    ax1.spines['top'].set_visible(False)
    ax1.yaxis.set_ticks_position('none')
    ax1.xaxis.set_ticks_position('none')

    if filename is not None:
        plt.savefig(os.path.join('img', filename))

    plt.show()


def mask_using_nan(data_file, mask_file, filename=None):
    # Set masking using NaN's
    data_img = nib.load(data_file)
    data_orig = data_img.get_data()

    mask_img = nib.load(mask_file)
    mask_data = mask_img.get_data()

    if np.any(np.isnan(mask_data)):
        # mask already using NaN
        mask_data_nan = mask_data
    else:
        # Replace zeros by NaNs
        mask_data_nan = mask_data.astype(float)
        mask_data_nan[mask_data_nan == 0] = np.nan

    # If there are NaNs in data_file remove them (to mask using mask_file only)
    data_orig = np.nan_to_num(data_orig)

    # Replace background by NaNs
    data_nan = data_orig.astype(float)
    data_nan[np.isnan(mask_data_nan)] = np.nan

    # Save as image
    data_img_nan = nib.Nifti1Image(data_nan, data_img.get_affine())
    if filename is None:
        filename = data_file.replace('.nii', '_nan.nii')

    nib.save(data_img_nan, filename)

    return(filename)


def dice(afni_exc_set_file, spm_exc_set_file,
         afni_perm_pos_exc=None, spm_perm_pos_exc=None,
         afni_exc_set_file_neg=None, spm_exc_set_file_neg=None,
         fsl_exc_set_file=None, fsl_exc_set_file_neg=None, 
         fsl_perm_pos_exc=None, 
         afni_perm_neg_exc=None, fsl_perm_neg_exc=None, spm_perm_neg_exc=None,
         afni_stat_file=None, spm_stat_file=None, 
         afni_perm=None, spm_perm=None,
         fsl_stat_file=None, fsl_perm=None,
         study=None
         ):

    afni_exc_set_file = mask_using_nan(afni_exc_set_file, afni_stat_file)
    spm_exc_set_file = mask_using_nan(spm_exc_set_file, spm_stat_file)
    if afni_perm_pos_exc is not None:
        afni_perm_pos_exc = mask_using_nan(afni_perm_pos_exc, afni_perm)
    if spm_perm_pos_exc is not None:
        spm_perm_pos_exc = mask_using_nan(spm_perm_pos_exc, spm_perm)
    if spm_perm_neg_exc is not None:
        spm_perm_neg_exc = mask_using_nan(spm_perm_neg_exc, spm_perm)
    if afni_exc_set_file_neg is not None:
        afni_exc_set_file_neg = mask_using_nan(afni_exc_set_file_neg, afni_stat_file)
    if spm_exc_set_file_neg is not None:
        spm_exc_set_file_neg = mask_using_nan(spm_exc_set_file_neg, spm_perm)
    if fsl_exc_set_file is not None:
        fsl_exc_set_file = mask_using_nan(fsl_exc_set_file, fsl_perm)
    if fsl_exc_set_file_neg is not None:
        # We mask fsl exc set with fsl perm stat because we know FEAT and 
        # randomise use the same mask
        fsl_exc_set_file_neg = mask_using_nan(fsl_exc_set_file_neg, fsl_perm)
    if fsl_perm_neg_exc is not None:
        fsl_perm_neg_exc = mask_using_nan(fsl_perm_neg_exc, fsl_perm)
    if fsl_perm_pos_exc is not None:
        fsl_perm_pos_exc = mask_using_nan(fsl_perm_pos_exc, fsl_perm)
    if afni_perm_neg_exc is not None:
        afni_perm_neg_exc = mask_using_nan(afni_perm_neg_exc, afni_perm)

    # *** Obtain Dice coefficient for each combination of images
    # Comparison of replication analyses
    if fsl_exc_set_file is not None:
        afni_res_fsl_pos_dice = sorrenson_dice(fsl_exc_set_file, afni_exc_set_file)
        afni_res_fsl_neg_dice = sorrenson_dice(fsl_exc_set_file_neg, afni_exc_set_file_neg)

    afni_res_spm_pos_dice = sorrenson_dice(spm_exc_set_file, afni_exc_set_file)
    if afni_exc_set_file_neg is not None:
        afni_res_spm_neg_dice = sorrenson_dice(spm_exc_set_file_neg, afni_exc_set_file_neg)
    
    if fsl_exc_set_file is not None:
        fsl_res_spm_pos_dice = sorrenson_dice(spm_exc_set_file, fsl_exc_set_file)
        fsl_res_spm_neg_dice = sorrenson_dice(spm_exc_set_file_neg, fsl_exc_set_file_neg)
    
    # Comparison of permutation tests
    if fsl_perm_pos_exc is not None:
        afni_res_fsl_pos_dice_perm = sorrenson_dice(fsl_perm_pos_exc, afni_perm_pos_exc)
    if fsl_perm_neg_exc is not None:
        afni_res_fsl_neg_dice_perm = sorrenson_dice(fsl_perm_neg_exc, afni_perm_neg_exc)
    
    if afni_perm_pos_exc is not None:
        afni_res_spm_pos_dice_perm = sorrenson_dice(spm_perm_pos_exc, afni_perm_pos_exc)
    if afni_perm_neg_exc is not None:
        afni_res_spm_neg_dice_perm = sorrenson_dice(spm_perm_neg_exc, afni_perm_neg_exc)
    
    if fsl_perm_pos_exc is not None:
        fsl_res_spm_pos_dice_perm = sorrenson_dice(spm_perm_pos_exc, fsl_perm_pos_exc)
    if fsl_perm_neg_exc is not None:
        fsl_res_spm_neg_dice_perm = sorrenson_dice(spm_perm_neg_exc, fsl_perm_neg_exc)
    
    # Intra-software comparison of replications against permutations
    if afni_perm_pos_exc is not None:
        afni_rep_perm_pos_dice = sorrenson_dice(afni_perm_pos_exc, afni_exc_set_file, False)
        fsl_rep_perm_pos_dice = sorrenson_dice(fsl_perm_pos_exc, fsl_exc_set_file, False)
        spm_rep_perm_pos_dice = sorrenson_dice(spm_perm_pos_exc, spm_exc_set_file, False)
    if afni_perm_neg_exc is not None:
        afni_rep_perm_neg_dice = sorrenson_dice(afni_perm_neg_exc, afni_exc_set_file_neg, False)
        fsl_rep_perm_neg_dice = sorrenson_dice(fsl_perm_neg_exc, fsl_exc_set_file_neg, False)
        spm_rep_perm_neg_dice = sorrenson_dice(spm_perm_neg_exc, spm_exc_set_file_neg, False)
    
    # Comparison of permutations with parametric tests
    if afni_perm_pos_exc is not None:
        afni_fsl_perm_res_pos_dice = sorrenson_dice(fsl_perm_pos_exc, afni_exc_set_file)
        afni_spm_perm_res_pos_dice = sorrenson_dice(spm_perm_pos_exc, afni_exc_set_file)
        afni_perm_res_fsl_pos_dice = sorrenson_dice(afni_perm_pos_exc, fsl_exc_set_file)
        fsl_spm_perm_res_pos_dice = sorrenson_dice(spm_perm_pos_exc, fsl_exc_set_file)
        afni_perm_res_spm_pos_dice = sorrenson_dice(afni_perm_pos_exc, spm_exc_set_file)
        fsl_perm_res_spm_pos_dice = sorrenson_dice(fsl_perm_pos_exc, spm_exc_set_file)
    
    if afni_perm_neg_exc is not None:
        afni_fsl_perm_res_neg_dice = sorrenson_dice(fsl_perm_neg_exc, afni_exc_set_file_neg)
        afni_spm_perm_res_neg_dice = sorrenson_dice(spm_perm_neg_exc, afni_exc_set_file_neg)
        afni_perm_res_fsl_neg_dice = sorrenson_dice(afni_perm_neg_exc, fsl_exc_set_file_neg)
        fsl_spm_perm_res_neg_dice = sorrenson_dice(spm_perm_neg_exc, fsl_exc_set_file_neg)
        afni_perm_res_spm_neg_dice = sorrenson_dice(afni_perm_neg_exc, spm_exc_set_file_neg)
        fsl_perm_res_spm_neg_dice = sorrenson_dice(fsl_perm_neg_exc, spm_exc_set_file_neg)
    
    else:
        [afni_fsl_perm_res_neg_dice, afni_fsl_perm_res_neg_dice,
         afni_spm_perm_res_neg_dice, afni_spm_perm_res_neg_dice,
         afni_perm_res_fsl_neg_dice, afni_perm_res_fsl_neg_dice,
         fsl_spm_perm_res_neg_dice, fsl_spm_perm_res_neg_dice,
         afni_perm_res_spm_neg_dice, afni_perm_res_spm_neg_dice,
         fsl_perm_res_spm_neg_dice, fsl_perm_res_spm_neg_dice] = np.zeros(12)
        
    # *** Printing results
    if fsl_exc_set_file is not None:
        print "AFNI/FSL positive activation dice coefficient = %.6f, %.0f, %.0f" % afni_res_fsl_pos_dice
    print "AFNI/SPM positive activation dice coefficient = %.6f, %.0f, %.0f" % afni_res_spm_pos_dice
    if fsl_exc_set_file is not None:
        print "FSL/SPM positive activation dice coefficient = %.6f, %.0f, %.0f" % fsl_res_spm_pos_dice
        print "Permutation test AFNI/SPM positive activation dice coefficient = %.6f, %.0f, %.0f" % afni_res_spm_pos_dice_perm
        print "Permutation test AFNI/FSL positive activation dice coefficient = %.6f, %.0f, %.0f" % afni_res_fsl_pos_dice_perm
        print "Permutation test FSL/SPM positive activation dice coefficient = %.6f, %.0f, %.0f" % fsl_res_spm_pos_dice_perm
        print "AFNI classical inference/permutation test positive activation dice coefficient = %.6f, %.0f, %.0f" % afni_rep_perm_pos_dice
        print "FSL classical inference/permutation test positive activation dice coefficient = %.6f, %.0f, %.0f" % fsl_rep_perm_pos_dice
        print "SPM classical inference/permutation test positive activation dice coefficient = %.6f, %.0f, %.0f" % spm_rep_perm_pos_dice
        print "AFNI parametric/FSL permutation positive activation dice coefficient = %.6f, %.0f, %.0f" % afni_fsl_perm_res_pos_dice
        print "AFNI parametric/SPM permutation positive activation dice coefficient = %.6f, %.0f, %.0f" % afni_spm_perm_res_pos_dice
        print "FSL parametric/AFNI permutation positive activation dice coefficient = %.6f, %.0f, %.0f" % afni_perm_res_fsl_pos_dice
        print "FSL parametric/SPM permutation positive activation dice coefficient = %.6f, %.0f, %.0f" % fsl_spm_perm_res_pos_dice
        print "SPM parametric/AFNI permutation positive activation dice coefficient = %.6f, %.0f, %.0f" % afni_perm_res_spm_pos_dice
        print "SPM parametric/FSL permutation positive activation dice coefficient = %.6f, %.0f, %.0f" % fsl_perm_res_spm_pos_dice
 
    if spm_perm_neg_exc is not None:
        print "AFNI/FSL negative activation dice coefficient = %.6f, %.0f, %.0f" % afni_res_fsl_neg_dice
        print "AFNI/SPM negative activation dice coefficient = %.6f, %.0f, %.0f" % afni_res_spm_neg_dice
        print "FSL/SPM negative activation dice coefficient = %.6f, %.0f, %.0f" % fsl_res_spm_neg_dice
        print "Permutation test AFNI/SPM negative activation dice coefficient = %.6f, %.0f, %.0f" % afni_res_spm_neg_dice_perm
        print "Permutation test AFNI/FSL negative activation dice coefficient = %.6f, %.0f, %.0f" % afni_res_fsl_neg_dice_perm
        print "Permutation test FSL/SPM negative activation dice coefficient = %.6f, %.0f, %.0f" % fsl_res_spm_neg_dice_perm
        print "AFNI classical inference/permutation test negative activation dice coefficient = %.6f, %.0f, %.0f" % afni_rep_perm_neg_dice
        print "FSL classical inference/permutation test negative activation dice coefficient = %.6f, %.0f, %.0f" % fsl_rep_perm_neg_dice
        print "SPM classical inference/permutation test negative activation dice coefficient = %.6f, %.0f, %.0f" % spm_rep_perm_neg_dice    
        print "AFNI parametric/FSL permutation negative activivation dice coefficient = %.6f, %.0f, %.0f" % afni_fsl_perm_res_neg_dice
        print "AFNI parametric/SPM permutation negative activivation dice coefficient = %.6f, %.0f, %.0f" % afni_spm_perm_res_neg_dice
        print "FSL parametric/AFNI permutation negative activivation dice coefficient = %.6f, %.0f, %.0f" % afni_perm_res_fsl_neg_dice
        print "FSL parametric/SPM permutation negative activivation dice coefficient = %.6f, %.0f, %.0f" % fsl_spm_perm_res_neg_dice
        print "SPM parametric/AFNI permutation negative activivation dice coefficient = %.6f, %.0f, %.0f" % afni_perm_res_spm_neg_dice
        print "SPM parametric/FSL permutation negative activivation dice coefficient = %.6f, %.0f, %.0f" % fsl_perm_res_spm_neg_dice
    
    elif fsl_exc_set_file_neg is not None:
        print "AFNI/FSL negative activation dice coefficient = %.6f, %.0f, %.0f" % afni_res_fsl_neg_dice

    # Creating a table of the Dice coefficients
    if fsl_exc_set_file is not None:
        dice_coefficients = np.zeros([6, 6, 3])

        for i in range(0, 3):
            dice_coefficients[:, 0, i] = [
                1,
                afni_res_fsl_pos_dice[i],
                afni_res_spm_pos_dice[i],
                afni_rep_perm_pos_dice[i],
                afni_fsl_perm_res_pos_dice[i],
                afni_spm_perm_res_pos_dice[i]
                ]
            dice_coefficients[:, 1, i] = [
                afni_res_fsl_pos_dice[i],
                1,
                fsl_res_spm_pos_dice[i],
                afni_perm_res_fsl_pos_dice[i],
                fsl_rep_perm_pos_dice[i],
                fsl_spm_perm_res_pos_dice[i]
                ]
            dice_coefficients[:, 2, i] = [
                afni_res_spm_pos_dice[i],
                fsl_res_spm_pos_dice[i],
                1,
                afni_perm_res_spm_pos_dice[i],
                fsl_perm_res_spm_pos_dice[i],
                spm_rep_perm_pos_dice[i]
                ]
            dice_coefficients[:, 3, i] = [
                afni_rep_perm_pos_dice[i],
                afni_perm_res_fsl_pos_dice[i],
                afni_perm_res_spm_pos_dice[i],
                1,
                afni_res_fsl_pos_dice_perm[i],
                afni_res_spm_pos_dice_perm[i]
                ]
            dice_coefficients[:, 4, i] = [
                afni_fsl_perm_res_pos_dice[i],
                fsl_rep_perm_pos_dice[i],
                fsl_perm_res_spm_pos_dice[i],
                afni_res_fsl_pos_dice_perm[i],
                1,
                fsl_res_spm_pos_dice_perm[i]
                ]
            dice_coefficients[:, 5, i] = [
                afni_spm_perm_res_pos_dice[i],
                fsl_spm_perm_res_pos_dice[i],
                spm_rep_perm_pos_dice[i],
                afni_res_spm_pos_dice_perm[i],
                fsl_res_spm_pos_dice_perm[i],
                1
                ]

        # pos_df = pd.DataFrame(dice_coefficients)
        ds109_dice_matrix(dice_coefficients, 'Fig_' + study + '_Dice.png')

        if spm_perm_neg_exc is not None:
            negative_dice_coefficients = np.zeros([6, 6, 3])

            for i in range(0, 3):
                negative_dice_coefficients[:, 0, i] = [
                    1,
                    afni_res_fsl_neg_dice[i],
                    afni_res_spm_neg_dice[i],
                    afni_rep_perm_neg_dice[i],
                    afni_fsl_perm_res_neg_dice[i],
                    afni_spm_perm_res_neg_dice[i]
                    ]
                negative_dice_coefficients[:, 1, i] = [
                    afni_res_fsl_neg_dice[i],
                    1,
                    fsl_res_spm_neg_dice[i],
                    afni_perm_res_fsl_neg_dice[i],
                    fsl_rep_perm_neg_dice[i],
                    fsl_spm_perm_res_neg_dice[i]
                    ]
                negative_dice_coefficients[:, 2, i] = [
                    afni_res_spm_neg_dice[i],
                    fsl_res_spm_neg_dice[i],
                    1,
                    afni_perm_res_spm_neg_dice[i],
                    fsl_perm_res_spm_neg_dice[i],
                    spm_rep_perm_neg_dice[i]
                    ]
                negative_dice_coefficients[:, 3, i] = [
                    afni_rep_perm_neg_dice[i],
                    afni_perm_res_fsl_neg_dice[i],
                    afni_perm_res_spm_neg_dice[i],
                    1,
                    afni_res_fsl_neg_dice_perm[i],
                    afni_res_spm_neg_dice_perm[i]
                    ]
                negative_dice_coefficients[:, 4, i] = [
                    afni_fsl_perm_res_neg_dice[i],
                    fsl_rep_perm_neg_dice[i],
                    fsl_perm_res_spm_neg_dice[i],
                    afni_res_fsl_neg_dice_perm[i],
                    1,
                    fsl_res_spm_neg_dice_perm[i]
                    ]
                negative_dice_coefficients[:, 5, i] = [
                    afni_spm_perm_res_neg_dice[i],
                    fsl_spm_perm_res_neg_dice[i],
                    spm_rep_perm_neg_dice[i],
                    afni_res_spm_neg_dice_perm[i],
                    fsl_res_spm_neg_dice_perm[i],
                    1
                    ]
            negative_dice_matrix(negative_dice_coefficients, 'Fig_' + study + '_neg_Dice.png')
        elif fsl_exc_set_file_neg is not None:
            ds109_neg_dice_coefficients = np.zeros([2, 2, 3])
            
            for i in range(0, 3):
                ds109_neg_dice_coefficients[:, 0, i] = [1, afni_res_fsl_neg_dice[i]]
                ds109_neg_dice_coefficients[:, 1, i] = [afni_res_fsl_neg_dice[i], 1]

            ds109_neg_dice_matrix(ds109_neg_dice_coefficients, 'Fig_' + study + '_Dice.png')
            
    else:
        ds120_dice_coefficients = np.zeros([2, 2, 3])

        for i in range(0, 3):
            ds120_dice_coefficients[:, 0, i] = [1, afni_res_spm_pos_dice[i]]
            ds120_dice_coefficients[:, 1, i] = [afni_res_spm_pos_dice[i], 1]

        ds120_dice_matrix(ds120_dice_coefficients, 'Fig_' + study + '_Dice.png')
