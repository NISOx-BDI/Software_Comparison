import nibabel as nib
import numpy as np
import matplotlib.pyplot as plt

def bland_altman_plot(data1, data2, *args, **kwargs):
    in_mask_indices = np.logical_not(np.logical_or(
    np.logical_or(np.isnan(data1), np.absolute(data1) == 0),
    np.logical_or(np.isnan(data2), np.absolute(data2) == 0)))

    data1 = data1[in_mask_indices]
    data2 = data2[in_mask_indices]

    mean      = np.mean([data1, data2], axis=0)
    diff      = data1 - data2                   # Difference between data1 and data2
    md        = np.mean(diff)                   # Mean of the difference
    sd        = np.std(diff, axis=0)            # Standard deviation of the difference
    
    plt.hexbin(mean, diff)
    # plt.scatter(mean, diff, marker = '.', linewidth = '0', *args, **kwargs)
    mean_line = plt.axhline(md,           color='red', linestyle='-')
    pos_95_prct = plt.axhline(md + 1.96*sd, color='red', linestyle='--')
    neg_95_prct = plt.axhline(md - 1.96*sd, color='red', linestyle='--')
    plt.plot(np.unique(mean), np.poly1d(np.polyfit(mean, diff, 1))(np.unique(mean)), color = 'green', lw = 4)
    plt.xlabel('Average of T-statistics')
    plt.ylabel('Difference of T-statistics')
    return md, sd

def bland_altman(afni_stat_file, spm_stat_file,
                 afni_reslice_spm, afni_spm_reslice,
                 fsl_stat_file=None, fsl_reslice_spm=None,
                 afni_fsl_reslice=None, afni_reslice_fsl=None, fsl_spm_reslice=None):
    
    # Get data from stat images
    afni_dat = nib.load(afni_stat_file).get_data()
    spm_dat = nib.load(spm_stat_file).get_data()
    if fsl_stat_file is not None:
        fsl_dat = nib.load(fsl_stat_file).get_data()

    # Get data from resliced images   
    afni_res_spm_dat = nib.load(afni_reslice_spm).get_data()
    afni_spm_res_dat = nib.load(afni_spm_reslice).get_data()
    if fsl_stat_file is not None:
        afni_res_fsl_dat = nib.load(afni_reslice_fsl).get_data()
        fsl_res_spm_dat = nib.load(fsl_reslice_spm).get_data()
        afni_fsl_res_dat = nib.load(afni_fsl_reslice).get_data()
        fsl_spm_res_dat = nib.load(fsl_spm_reslice).get_data()

    afni_1d = np.reshape(afni_dat, -1)
    spm_1d = np.reshape(spm_dat, -1)
    afni_res_spm_1d = np.reshape(afni_res_spm_dat, -1)
    afni_spm_res_1d = np.reshape(afni_spm_res_dat, -1)
    if fsl_stat_file is not None:
        fsl_1d = np.reshape(fsl_dat, -1)
        afni_res_fsl_1d = np.reshape(afni_res_fsl_dat, -1)
        afni_fsl_res_1d = np.reshape(afni_fsl_res_dat, -1)
        fsl_res_spm_1d = np.reshape(fsl_res_spm_dat, -1)
        fsl_spm_res_1d = np.reshape(fsl_spm_res_dat, -1)
    
    if fsl_stat_file is not None:
        bland = bland_altman_plot(afni_res_fsl_1d, fsl_1d)
        plt.title('AFNI/FSL Bland-Altman')
        plt.show()
        mean, sd = bland
        print "Mean = %s" % mean
        print "SD = %s" % sd

        bland = bland_altman_plot(afni_1d, afni_fsl_res_1d)
        plt.title('FSL/AFNI Bland-Altman')
        plt.show()
        mean, sd = bland
        print "Mean = %s" % mean
        print "SD = %s" % sd

    bland = bland_altman_plot(afni_res_spm_1d, spm_1d)
    plt.title('AFNI/SPM Bland-Altman')
    plt.show()
    mean, sd = bland
    print "Mean = %s" % mean
    print "SD = %s" % sd

    bland = bland_altman_plot(afni_1d, afni_spm_res_1d)
    plt.title('SPM/AFNI Bland-Altman')
    plt.show()
    mean, sd = bland
    print "Mean = %s" % mean
    print "SD = %s" % sd
    
    if fsl_stat_file is not None:
        bland = bland_altman_plot(fsl_res_spm_1d, spm_1d)
        plt.title('FSL/SPM Bland-Altman')
        plt.show()
        mean, sd = bland
        print "Mean = %s" % mean
        print "SD = %s" % sd

        bland = bland_altman_plot(fsl_1d, fsl_spm_res_1d)
        plt.title('SPM/FSL Bland-Altman')
        plt.show()
        mean, sd = bland
        print "Mean = %s" % mean
        print "SD = %s" % sd