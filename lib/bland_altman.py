import nibabel as nib
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import matplotlib.ticker as ticker
from matplotlib.ticker import ScalarFormatter, FormatStrFormatter

class FixedOrderFormatter(ScalarFormatter):
    """Formats axis ticks using scientific notation with a constant order of 
    magnitude"""
    def __init__(self, order_of_mag=0, useOffset=True, useMathText=False):
        self._order_of_mag = order_of_mag
        ScalarFormatter.__init__(self, useOffset=useOffset, 
                                 useMathText=useMathText)
    def _set_orderOfMagnitude(self, range):
        """Over-riding this to avoid having orderOfMagnitude reset elsewhere"""
        self.orderOfMagnitude = self._order_of_mag

def bland_altman_plot(data1, data2, *args, **kwargs):
    # Vectorise input data
    data1 = np.reshape(data1, -1)
    data2 = np.reshape(data2, -1)

    in_mask_indices = np.logical_not(np.logical_or(
    np.logical_or(np.isnan(data1), np.absolute(data1) == 0),
    np.logical_or(np.isnan(data2), np.absolute(data2) == 0)))

    data1 = data1[in_mask_indices]
    data2 = data2[in_mask_indices]

    mean      = np.mean([data1, data2], axis=0)
    diff      = data1 - data2                   # Difference between data1 and data2
    
    # UNCOMMENT TO GET RID OF AFNI ds109 OUTLIERS
    #non_outlier_indices = np.logical_and(abs(mean) < 10, abs(diff) < 7)
    #mean = mean[non_outlier_indices]
    #diff = diff[non_outlier_indices]
    
    md        = np.mean(diff)                   # Mean of the difference
    sd        = np.std(diff, axis=0)            # Standard deviation of the difference
    
    return mean, diff, md, sd

def bland_altman(Title, afni_stat_file, spm_stat_file,
                 afni_reslice_spm, afni_spm_reslice, AFNI_SPM_title, AFNI_FSL_title=None, FSL_SPM_title=None,
                 fsl_stat_file=None, fsl_reslice_spm=None,
                 afni_fsl_reslice=None, afni_reslice_fsl=None, fsl_spm_reslice=None):
    plt.style.use('seaborn-colorblind')
    
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
       
    # Create Bland-Altman plots
    # AFNI/FSL B-A plots
    if fsl_stat_file is not None:
        f = plt.figure(figsize=(13, 5))
        
        f.suptitle(Title, fontsize=20, x=0.47, y=1.00)
        
        gs0 = gridspec.GridSpec(1, 2)
        
        gs00 = gridspec.GridSpecFromSubplotSpec(5, 6, subplot_spec=gs0[0], hspace=0.50, wspace=1.3)
        
        ax1 = f.add_subplot(gs00[:-1, 1:5])
        mean, diff, md, sd = bland_altman_plot(afni_res_fsl_dat, fsl_dat)
        hb = ax1.hexbin(mean, diff, bins='log', cmap='viridis', gridsize=50)
        ax1.axhline(linewidth=1, color='r')
        ax1.set_title(AFNI_FSL_title)
        ax2 = f.add_subplot(gs00[:-1, 0], xticklabels=[], sharey=ax1)
        ax2.hist(diff, 100, histtype='stepfilled',
                    orientation='horizontal', color='gray')
        ax2.invert_xaxis()
        ax2.set_ylabel('Difference of T-statistics (AFNI - FSL)')
        ax3 = f.add_subplot(gs00[-1, 1:5], yticklabels=[], sharex=ax1)
        ax3.hist(mean, 100, histtype='stepfilled',
                    orientation='vertical', color='gray')
        ax3.invert_yaxis()
        ax3.set_xlabel('Average of T-statistics')
        ax4 = f.add_subplot(gs00[:-1,5])
        ax4.set_aspect(20)
        pos1 = ax4.get_position()
        ax4.set_position([pos1.x0 - 0.025, pos1.y0, pos1.width, pos1.height])
        cb = f.colorbar(hb, cax=ax4)
        cb.set_label('log10(N)')
        
        gs01 = gridspec.GridSpecFromSubplotSpec(5, 6, subplot_spec=gs0[1], hspace=0.50, wspace=1.3)
        
        ax5 = f.add_subplot(gs01[:-1, 1:5])
        mean, diff, md, sd = bland_altman_plot(afni_dat, afni_fsl_res_dat)
        hb = ax5.hexbin(mean, diff, bins='log', cmap='viridis', gridsize=50)
        ax5.axhline(linewidth=1, color='r')
        ax5.set_title('FSL reslice on AFNI Bland-Altman')
        ax6 = f.add_subplot(gs01[:-1, 0], xticklabels=[], sharey=ax5)
        ax6.hist(diff, 100, histtype='stepfilled',
                    orientation='horizontal', color='gray')
        ax6.invert_xaxis()
        ax6.set_ylabel('Difference of T-statistics (AFNI - FSL)')
        ax7 = f.add_subplot(gs01[-1, 1:5], yticklabels=[], sharex=ax5)
        ax7.hist(mean, 100, histtype='stepfilled',
                    orientation='vertical', color='gray')
        ax7.invert_yaxis()
        ax7.set_xlabel('Average of T-statistics')
        ax8 = f.add_subplot(gs01[:-1,5])
        ax8.set_aspect(20)
        pos1 = ax8.get_position()
        ax8.set_position([pos1.x0 - 0.025, pos1.y0, pos1.width, pos1.height])
        cb = f.colorbar(hb, cax=ax8)
        cb.set_label('log10(N)')
        
        plt.show()

    # AFNI/SPM B-A plots
    f = plt.figure(figsize=(13, 5))
    
    if fsl_stat_file is None:
        f.suptitle(Title, fontsize=20, x=0.47, y=1.00)

    gs0 = gridspec.GridSpec(1, 2)

    gs00 = gridspec.GridSpecFromSubplotSpec(5, 6, subplot_spec=gs0[0], hspace=0.50, wspace=1.3)

    ax1 = f.add_subplot(gs00[:-1, 1:5])
    mean, diff, md, sd = bland_altman_plot(afni_res_spm_dat, spm_dat)
    hb = ax1.hexbin(mean, diff, bins='log', cmap='viridis', gridsize=50)
    ax1.axhline(linewidth=1, color='r')
    ax1.set_title(AFNI_SPM_title)
    ax2 = f.add_subplot(gs00[:-1, 0], xticklabels=[], sharey=ax1)
    ax2.hist(diff, 100, histtype='stepfilled',
             orientation='horizontal', color='gray')
    ax2.invert_xaxis()
    ax2.set_ylabel('Difference of T-statistics (AFNI - SPM)')
    ax3 = f.add_subplot(gs00[-1, 1:5], yticklabels=[], sharex=ax1)
    ax3.hist(mean, 100, histtype='stepfilled',
             orientation='vertical', color='gray')
    ax3.invert_yaxis()
    if fsl_stat_file is None:
        ax3.set_xlabel('Average of F-statistics')
    else:
        ax3.set_xlabel('Average of T-statistics')     
    ax4 = f.add_subplot(gs00[:-1,5])
    ax4.set_aspect(20)
    pos1 = ax4.get_position()
    ax4.set_position([pos1.x0 - 0.025, pos1.y0, pos1.width, pos1.height])
    cb = f.colorbar(hb, cax=ax4)
    cb.set_label('log10(N)')

    gs01 = gridspec.GridSpecFromSubplotSpec(5, 6, subplot_spec=gs0[1], hspace=0.50, wspace=1.3)

    ax5 = f.add_subplot(gs01[:-1, 1:5])
    mean, diff, md, sd = bland_altman_plot(afni_dat, afni_spm_res_dat)
    hb = ax5.hexbin(mean, diff, bins='log', cmap='viridis', gridsize=50)
    ax5.axhline(linewidth=1, color='r')
    ax5.set_title('SPM reslice on AFNI Bland-Altman')
    ax6 = f.add_subplot(gs01[:-1, 0], xticklabels=[], sharey=ax5)
    ax6.hist(diff, 100, histtype='stepfilled',
             orientation='horizontal', color='gray')
    ax6.invert_xaxis()
    ax6.set_ylabel('Difference of T-statistics (AFNI - SPM)')
    ax7 = f.add_subplot(gs01[-1, 1:5], yticklabels=[], sharex=ax5)
    ax7.hist(mean, 100, histtype='stepfilled',
             orientation='vertical', color='gray')
    ax7.invert_yaxis()
    ax7.set_xlabel('Average of T-statistics')
    ax8 = f.add_subplot(gs01[:-1,5])
    ax8.set_aspect(20)
    pos1 = ax8.get_position()
    ax8.set_position([pos1.x0 - 0.025, pos1.y0, pos1.width, pos1.height])
    cb = f.colorbar(hb, cax=ax8)
    cb.set_label('log10(N)')

    plt.show()

    # FSL/SPM B-A plots
    if fsl_stat_file is not None:
        f = plt.figure(figsize=(13, 5))

        gs0 = gridspec.GridSpec(1, 2)

        gs00 = gridspec.GridSpecFromSubplotSpec(5, 6, subplot_spec=gs0[0], hspace=0.50, wspace=1.3)

        ax1 = f.add_subplot(gs00[:-1, 1:5])
        mean, diff, md, sd = bland_altman_plot(fsl_res_spm_dat, spm_dat)
        hb = ax1.hexbin(mean, diff, bins='log', cmap='viridis', gridsize=50)
        ax1.axhline(linewidth=1, color='r')
        ax1.set_title(FSL_SPM_title)
        ax2 = f.add_subplot(gs00[:-1, 0], xticklabels=[], sharey=ax1)
        ax2.hist(diff, 100, histtype='stepfilled',
                 orientation='horizontal', color='gray')
        ax2.invert_xaxis()
        ax2.set_ylabel('Difference of T-statistics (FSL - SPM)')
        ax3 = f.add_subplot(gs00[-1, 1:5], yticklabels=[], sharex=ax1)
        ax3.hist(mean, 100, histtype='stepfilled',
                 orientation='vertical', color='gray')
        ax3.invert_yaxis()
        ax3.set_xlabel('Average of T-statistics')
        ax4 = f.add_subplot(gs00[:-1,5])
        ax4.set_aspect(20)
        pos1 = ax4.get_position()
        ax4.set_position([pos1.x0 - 0.025, pos1.y0, pos1.width, pos1.height])
        cb = f.colorbar(hb, cax=ax4)
        cb.set_label('log10(N)')

        gs01 = gridspec.GridSpecFromSubplotSpec(5, 6, subplot_spec=gs0[1], hspace=0.50, wspace=1.3)

        ax5 = f.add_subplot(gs01[:-1, 1:5])
        mean, diff, md, sd = bland_altman_plot(fsl_dat, fsl_spm_res_dat)
        hb = ax5.hexbin(mean, diff, bins='log', cmap='viridis', gridsize=50)
        ax5.axhline(linewidth=1, color='r')
        ax5.set_title('SPM reslice on FSL Bland-Altman')
        ax6 = f.add_subplot(gs01[:-1, 0], xticklabels=[], sharey=ax5)
        ax6.hist(diff, 100, histtype='stepfilled',
                 orientation='horizontal', color='gray')
        ax6.invert_xaxis()
        ax6.set_ylabel('Difference of T-statistics (FSL - SPM)')
        ax7 = f.add_subplot(gs01[-1, 1:5], yticklabels=[], sharex=ax5)
        ax7.hist(mean, 100, histtype='stepfilled',
                 orientation='vertical', color='gray')
        ax7.invert_yaxis()
        ax7.set_xlabel('Average of T-statistics')
        ax8 = f.add_subplot(gs01[:-1,5])
        ax8.set_aspect(20)
        pos1 = ax8.get_position()
        ax8.set_position([pos1.x0 - 0.025, pos1.y0, pos1.width, pos1.height])
        cb = f.colorbar(hb, cax=ax8)
        cb.set_label('log10(N)')

        plt.show()

def bland_altman_intra(Title, afni_stat_file, afni_perm_file,
                 fsl_stat_file, fsl_perm_file,
                 spm_stat_file, spm_perm_file):
    plt.style.use('seaborn-colorblind')
    
    # Get data from stat images
    afni_stat_dat = nib.load(afni_stat_file).get_data()
    afni_perm_dat = nib.load(afni_perm_file).get_data()
    fsl_stat_dat = nib.load(fsl_stat_file).get_data()
    fsl_perm_dat = nib.load(fsl_perm_file).get_data()
    spm_stat_dat = nib.load(spm_stat_file).get_data()
    spm_perm_dat = nib.load(spm_perm_file).get_data()
          
    # AFNI Parametric/AFNI Permutation Bland-Altman
    f = plt.figure(figsize=(6.5, 5))
    
    f.suptitle(Title, fontsize=20, x=0.40, y=3.70)
    f.subplots_adjust(hspace=0.3, top=3.58, bottom=1.0, left=0.1, right=0.8)
    
    gs0 = gridspec.GridSpec(3, 1)
   
    gs00 = gridspec.GridSpecFromSubplotSpec(5, 6, subplot_spec=gs0[0], hspace=0.50, wspace=0.65)
    ax1 = plt.subplot(gs00[:-1, 1:5])
    mean, diff, md, sd = bland_altman_plot(afni_stat_dat, afni_perm_dat)
    hb = ax1.hexbin(mean, diff, bins='log', cmap='viridis', gridsize=50)
    ax1.axhline(linewidth=1, color='r')
    ax1.set_title('AFNI Para/Perm')
    ax2 = plt.subplot(gs00[:-1, 0], xticklabels=[], sharey=ax1)
    ax2.hist(diff, 100, histtype='stepfilled',
             orientation='horizontal', color='gray')
    ax2.invert_xaxis()
    ax2.set_ylabel('Difference of T-statistics (Para - Perm)')
    ax3 = plt.subplot(gs00[-1, 1:5], yticklabels=[], sharex=ax1)
    ax3.hist(mean, 100, histtype='stepfilled',
             orientation='vertical', color='gray')
    ax3.invert_yaxis()
    ax3.set_xlabel('Average of T-statistics')
    ax4 = plt.subplot(gs00[:-1,5])
    ax4.set_aspect(20)
    pos1 = ax4.get_position()
    ax4.set_position([pos1.x0 - 0.045, pos1.y0, pos1.width, pos1.height])
    cb = f.colorbar(hb, cax=ax4)
    cb.set_label('log10(N)')
    
    
    # FSL Parametric/FSL Permutation Bland-Altman
    gs01 = gridspec.GridSpecFromSubplotSpec(5, 6, subplot_spec=gs0[1], hspace=0.50, wspace=0.65)
    ax1 = plt.subplot(gs01[:-1, 1:5])
    mean, diff, md, sd = bland_altman_plot(fsl_stat_dat, fsl_perm_dat)
    hb = ax1.hexbin(mean, diff, bins='log', cmap='viridis', gridsize=50)
    ax1.axhline(linewidth=1, color='r')
    ax1.set_title('FSL Para/Perm')
    ax2 = plt.subplot(gs01[:-1, 0], xticklabels=[], sharey=ax1)
    ax2.hist(diff, 100, histtype='stepfilled',
             orientation='horizontal', color='gray')
    ax2.invert_xaxis()
    ax2.set_ylabel('Difference of T-statistics (Para - Perm)')
    ax3 = plt.subplot(gs01[-1, 1:5], yticklabels=[], sharex=ax1)
    ax3.hist(mean, 100, histtype='stepfilled',
             orientation='vertical', color='gray')
    ax3.invert_yaxis()
    ax3.set_xlabel('Average of T-statistics')
    ax4 = plt.subplot(gs01[:-1,5])
    ax4.set_aspect(20)
    pos1 = ax4.get_position()
    ax4.set_position([pos1.x0 - 0.045, pos1.y0, pos1.width, pos1.height])
    cb = f.colorbar(hb, cax=ax4)
    cb.set_label('log10(N)')

    # SPM Parametric/SPM Permutation Bland-Altman
    gs02 = gridspec.GridSpecFromSubplotSpec(5, 6, subplot_spec=gs0[2], hspace=0.50, wspace=1.3)
    ax1 = plt.subplot(gs02[:-1, 1:5])
    
    tick_formatter = ticker.ScalarFormatter(useOffset=False)
    tick_formatter.set_powerlimits((-6, 6))
    ax1.yaxis.set_major_formatter(FixedOrderFormatter(-7))
    
    mean, diff, md, sd = bland_altman_plot(spm_stat_dat, spm_perm_dat)
    hb = ax1.hexbin(mean, diff, bins='log', cmap='viridis', gridsize=50)
    ax1.axhline(linewidth=1, color='r')
    ax1.set_title('SPM Para/Perm')
    ax2 = plt.subplot(gs02[:-1, 0], xticklabels=[], sharey=ax1)
    ax2.hist(diff, 100, histtype='stepfilled',
             orientation='horizontal', color='gray')
    ax2.invert_xaxis()
    ax2.set_ylabel('Difference of T-statistics (Para - Perm)')
    ax3 = plt.subplot(gs02[-1, 1:5], yticklabels=[], sharex=ax1)
    ax3.hist(mean, 100, histtype='stepfilled',
             orientation='vertical', color='gray')
    ax3.invert_yaxis()
    ax3.set_xlabel('Average of T-statistics')
    ax4 = plt.subplot(gs02[:-1,5])
    ax4.set_aspect(20)
    pos1 = ax4.get_position()
    ax4.set_position([pos1.x0 - 0.045, pos1.y0, pos1.width, pos1.height])
    cb = f.colorbar(hb, cax=ax4)
    cb.set_label('log10(N)')

    plt.show()