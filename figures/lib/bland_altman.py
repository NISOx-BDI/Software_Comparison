import nibabel as nib
from nibabel.processing import resample_from_to
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import matplotlib.ticker as ticker
from matplotlib.ticker import ScalarFormatter, FormatStrFormatter
from matplotlib.axes import Axes
import os


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


def mask_using_nan(data_img):
    # Set masking using NaN's
    data_orig = data_img.get_data()

    if np.any(np.isnan(data_orig)):
        # Already using NaN
        data_img_nan = data_img
    else:
        # Replace zeros by NaNs
        data_nan = data_orig
        data_nan[data_nan == 0] = np.nan
        # Save as image
        data_img_nan = nib.Nifti1Image(data_nan, data_img.get_affine())

    return(data_img_nan)


def bland_altman_values(data1_file, data2_file, reslice_on_2=True,
                        *args, **kwargs):

    # Load nifti images
    data1_img = nib.load(data1_file)
    data2_img = nib.load(data2_file)

    # Set masking using NaN's
    data1_img = mask_using_nan(data1_img)
    data2_img = mask_using_nan(data2_img)

    if reslice_on_2:
        # Resample data1 on data2 using nearest nneighbours
        data1_resl_img = resample_from_to(data1_img, data2_img, order=0)

        # Load data from images
        data1 = data1_resl_img.get_data()
        data2 = data2_img.get_data()
    else:
        # Resample data2 on data1 using nearest nneighbours
        data2_resl_img = resample_from_to(data2_img, data1_img, order=0)

        # Load data from images
        data1 = data1_img.get_data()
        data2 = data2_resl_img.get_data()

    # Vectorise input data
    data1 = np.reshape(data1, -1)
    data2 = np.reshape(data2, -1)

    in_mask_indices = np.logical_not(
        np.logical_or(
            np.logical_or(np.isnan(data1), np.absolute(data1) == 0),
            np.logical_or(np.isnan(data2), np.absolute(data2) == 0)))

    data1 = data1[in_mask_indices]
    data2 = data2[in_mask_indices]

    mean = np.mean([data1, data2], axis=0)
    diff = data1 - data2  # Difference between data1 and data2

    md = np.mean(diff)                   # Mean of the difference
    sd = np.std(diff, axis=0)            # Standard deviation of the difference

    return mean, diff, md, sd


def z_to_t(z_stat_file, t_stat_file, N):
    # Convert AFNI permutation Z-stat back to T-stat
    df = N-1

    z_stat_img = nib.load(z_stat_file)

    z_stat = z_stat_img.get_data()
    t_stat = np.zeros_like(z_stat)

    # Handle large and small values differently to avoid underflow
    t_stat[z_stat < 0] = stats.t.ppf(stats.norm.cdf(z_stat[z_stat < 0]), df)
    t_stat[z_stat > 0] = stats.t.isf(stats.norm.sf(z_stat[z_stat > 0]), df)

    t_stat_img = nib.Nifti1Image(t_stat, z_stat_img.affine)
    t_stat_img.to_filename(t_stat_file)

    return(t_stat_file)


def bland_altman_plot(f, gs, stat_file_1, stat_file_2, title, x_lab, y_lab,
                      reslice_on_2=True, filename=None, lims=(-10,10,-8,8)):
    ax1 = f.add_subplot(gs[:-1, 1:5])
    mean, diff, md, sd = bland_altman_values(
        stat_file_1, stat_file_2, reslice_on_2)
    hb = ax1.hexbin(mean, diff, bins='log', cmap='viridis', gridsize=50, extent=lims)
    ax1.axis(lims)
    ax1.axhline(linewidth=1, color='r')
    ax1.set_title(title)
    ax2 = f.add_subplot(gs[:-1, 0], xticklabels=[], sharey=ax1)
    ax2.set_ylim(lims[2:4])
    ax2.hist(diff, 100, range=lims[2:4],histtype='stepfilled',
             orientation='horizontal', color='gray')
    ax2.invert_xaxis()
    ax2.set_ylabel('Difference' + y_lab)
    ax3 = f.add_subplot(gs[-1, 1:5], yticklabels=[], sharex=ax1)
    ax3.hist(mean, 100, range=lims[0:2],histtype='stepfilled',
             orientation='vertical', color='gray')
    ax3.set_xlim(lims[0:2])
    ax3.invert_yaxis()
    ax3.set_xlabel('Average' + x_lab)
    ax4 = f.add_subplot(gs[:-1, 5])
    ax4.set_aspect(20)
    pos1 = ax4.get_position()
    ax4.set_position([pos1.x0 - 0.025, pos1.y0, pos1.width, pos1.height])
    cb = f.colorbar(hb, cax=ax4)
    cb.set_label('log10(N)')

    if filename is not None:
        plt.savefig(os.path.join('img', filename))


def bland_altman(Title, afni_stat_file, spm_stat_file, AFNI_SPM_title,
                 AFNI_FSL_title=None, FSL_SPM_title=None, fsl_stat_file=None,
                 num_subjects=None, study=''):

    if num_subjects is not None:
        afni_stat_file = z_to_t(
            afni_stat_file,
            afni_stat_file.replace('.nii.gz', '_t.nii.gz'),
            num_subjects)

    plt.style.use('seaborn-colorblind')
    # Create Bland-Altman plots
    # AFNI/FSL B-A plots
    if fsl_stat_file is not None:
        f = plt.figure(figsize=(13, 5))

        gs0 = gridspec.GridSpec(1, 2)

        gs00 = gridspec.GridSpecFromSubplotSpec(
            5, 6, subplot_spec=gs0[0], hspace=0.50, wspace=1.3)
        
        if Title in 'Bland-Altman Plots: BOLD images':
            x_label = ' of % BOLD values'
            y_label = ' of % BOLD values (AFNI - FSL)'
            lims=(-1,1,-1.8,1.8)
        else:
            x_label = ' of T-statistics'
            y_label = ' of T-statistics (AFNI - FSL)'
            lims=(-10,10,-8,8)

        bland_altman_plot(f, gs00, afni_stat_file, fsl_stat_file,
                          AFNI_FSL_title, x_label,
                          y_label, False,
                          'Fig_' + study + '_BA_AFNI_FSL.png', lims=lims)

        gs01 = gridspec.GridSpecFromSubplotSpec(
            5, 6, subplot_spec=gs0[1], hspace=0.50, wspace=1.3)

        bland_altman_plot(f, gs01, afni_stat_file, fsl_stat_file,
                          'FSL reslice on AFNI Bland-Altman',
                          ' of T-statistics',
                          ' of T-statistics (AFNI - FSL)')

        f.suptitle(Title, fontsize=20, x=0.47, y=1.00)

        plt.show()

    # AFNI/SPM B-A plots
    f = plt.figure(figsize=(13, 5))

    if fsl_stat_file is None:
        f.suptitle(Title, fontsize=20, x=0.47, y=1.00)

    gs0 = gridspec.GridSpec(1, 2)

    gs00 = gridspec.GridSpecFromSubplotSpec(
        5, 6, subplot_spec=gs0[0], hspace=0.50, wspace=1.3)

    if fsl_stat_file is None:
        if Title in 'Bland-Altman Plots: R^2 images':
            x_label = 'of R^2 values'
            y_label = 'of R^2 values (AFNI - SPM)'
            lims = (0, 0.6, -0.3, 0.4)
        else:
            x_label = ' of F-statistics'
            y_label = ' of F-statistics (AFNI - SPM)'
            lims=(0,20,-15,15)
    elif Title in 'Bland-Altman Plots: BOLD images':
        x_label = ' of % BOLD values'
        y_label = ' of % BOLD values (AFNI - SPM)'
        lims=(-1,1,-1.8,1.8) 
    else:
        x_label = ' of T-statistics'
        y_label = ' of T-statistics (AFNI - SPM)'
        lims=(-10,10,-8,8)

    bland_altman_plot(f, gs00, afni_stat_file, spm_stat_file,
                      AFNI_SPM_title,
                      x_label,
                      y_label, False,
                      'Fig_' + study + '_BA_AFNI_SPM.png',
                      lims=lims)

    gs01 = gridspec.GridSpecFromSubplotSpec(
        5, 6, subplot_spec=gs0[1], hspace=0.50, wspace=1.3)

    bland_altman_plot(f, gs01, afni_stat_file, spm_stat_file,
                      'SPM reslice on AFNI Bland-Altman',
                      x_label,
                      y_label,
                      lims=lims)

    plt.show()

    # FSL/SPM B-A plots
    if fsl_stat_file is not None:
        f = plt.figure(figsize=(13, 5))

        gs0 = gridspec.GridSpec(1, 2)

        gs00 = gridspec.GridSpecFromSubplotSpec(
            5, 6, subplot_spec=gs0[0], hspace=0.50, wspace=1.3)
        
        if Title in 'Bland-Altman Plots: BOLD images':
            x_label = ' of % BOLD values'
            y_label = ' of % BOLD values (FSL - SPM)'
            lims=(-1,1,-1.8,1.8)
        else:
            x_label = ' of T-statistics'
            y_label = ' of T-statistics (FSL - SPM)'
            lims=(-10,10,-8,8)

        bland_altman_plot(f, gs00, fsl_stat_file, spm_stat_file,
                          FSL_SPM_title,
                          x_label,
                          y_label,
                          False,
                          'Fig_' + study + '_BA_FSL_SPM.png',
                          lims=lims)

        gs01 = gridspec.GridSpecFromSubplotSpec(
            5, 6, subplot_spec=gs0[1], hspace=0.50, wspace=1.3)

        bland_altman_plot(f, gs01, fsl_stat_file, spm_stat_file,
                          'SPM reslice on FSL Bland-Altman',
                          ' of T-statistics',
                          ' of T-statistics (FSL - SPM)',
                          )

        plt.show()


def bland_altman_intra(Title, afni_stat_file, afni_perm_file,
                       fsl_stat_file, fsl_perm_file,
                       spm_stat_file, spm_perm_file, num_subjects=None,
                       study = ''):
    plt.style.use('seaborn-colorblind')

    if num_subjects is not None:
        afni_perm_file = z_to_t(
            afni_perm_file,
            afni_perm_file.replace('.nii.gz', '_t.nii.gz'),
            num_subjects)

    # AFNI Parametric/AFNI Permutation Bland-Altman
    f1 = plt.figure(figsize=(13, 5))

    gs0 = gridspec.GridSpec(1, 2)

    gs00 = gridspec.GridSpecFromSubplotSpec(
        5, 6, subplot_spec=gs0[0], hspace=0.50, wspace=1.3)

    bland_altman_plot(f1, gs00, afni_stat_file, afni_perm_file,
                      'AFNI Para - Perm',
                      ' of T-statistics',
                      ' of T-statistics (Para - Perm)',
                      filename='Fig_' + study + '_BA_AFNI.png'
                      )

    # FSL Parametric/FSL Permutation Bland-Altman
    f = plt.figure(figsize=(13, 5))

    gs0 = gridspec.GridSpec(1, 2)


    gs01 = gridspec.GridSpecFromSubplotSpec(
        5, 6, subplot_spec=gs0[0], hspace=0.50, wspace=1.3)

    bland_altman_plot(f, gs01, fsl_stat_file, fsl_perm_file,
                      'FSL Para - Perm',
                      ' of T-statistics',
                      ' of T-statistics (Para - Perm)',
                      filename='Fig_' + study + '_BA_FSL.png'
                      )

    # SPM Parametric/SPM Permutation Bland-Altman
    f = plt.figure(figsize=(13, 5))

    gs0 = gridspec.GridSpec(1, 2)

    gs02 = gridspec.GridSpecFromSubplotSpec(
        5, 6, subplot_spec=gs0[0], hspace=0.50, wspace=1.3)

    bland_altman_plot(
        f, gs02, spm_stat_file, spm_perm_file,
        'SPM Para - Perm',
        ' of T-statistics',
        ' of T-statistics (Para - Perm)',
        filename='Fig_' + study + '_BA_SPM.png'
        )

    # tick_formatter = ticker.ScalarFormatter(useOffset=False)
    # tick_formatter.set_powerlimits((-6, 6))
    # ax1.yaxis.set_major_formatter(FixedOrderFormatter(-7))

    f1.suptitle(Title, fontsize=20, x=0.47, y=1.00)

    plt.show()
    
def scatter_values(data1_file, data2_file, reslice_on_2=True,
                        *args, **kwargs):

    # Load nifti images
    data1_img = nib.load(data1_file)
    data2_img = nib.load(data2_file)

    # Set masking using NaN's
    data1_img = mask_using_nan(data1_img)
    data2_img = mask_using_nan(data2_img)

    if reslice_on_2:
        # Resample data1 on data2 using nearest nneighbours
        data1_resl_img = resample_from_to(data1_img, data2_img, order=0)

        # Load data from images
        data1 = data1_resl_img.get_data()
        data2 = data2_img.get_data()
    else:
        # Resample data2 on data1 using nearest nneighbours
        data2_resl_img = resample_from_to(data2_img, data1_img, order=0)

        # Load data from images
        data1 = data1_img.get_data()
        data2 = data2_resl_img.get_data()

    # Vectorise input data
    data1 = np.reshape(data1, -1)
    data2 = np.reshape(data2, -1)

    in_mask_indices = np.logical_not(
        np.logical_or(
            np.logical_or(np.isnan(data1), np.absolute(data1) == 0),
            np.logical_or(np.isnan(data2), np.absolute(data2) == 0)))

    data1 = data1[in_mask_indices]
    data2 = data2[in_mask_indices]


    return data1, data2

def scatter_plot(f, gs, stat_file_1, stat_file_2, title, x_lab, y_lab,
                      reslice_on_2=True, filename=None, lims=(-10,10,-8,8)):
    ax1 = f.add_subplot(gs[:-1, 1:5])
    data1, data2 = scatter_values(
        stat_file_1, stat_file_2, reslice_on_2)
    hb = ax1.hexbin(data1, data2, bins='log', cmap='viridis', gridsize=50, extent=lims)
    ax1.axis(lims)
    ax1.plot(ax1.get_xlim(), ax1.get_ylim(), color='r', linewidth=1)
    #ax1.axhline(linewidth=1, color='r')
    ax1.set_title(title)
    ax2 = f.add_subplot(gs[:-1, 0], xticklabels=[], sharey=ax1)
    ax2.set_ylim(lims[2:4])
    ax2.hist(data2, 100, range=lims[2:4],histtype='stepfilled',
             orientation='horizontal', color='gray')
    ax2.invert_xaxis()
    ax2.set_ylabel(y_lab)
    ax3 = f.add_subplot(gs[-1, 1:5], yticklabels=[], sharex=ax1)
    ax3.hist(data1, 100, range=lims[0:2],histtype='stepfilled',
             orientation='vertical', color='gray')
    ax3.set_xlim(lims[0:2])
    ax3.invert_yaxis()
    ax3.set_xlabel(x_lab)
    ax4 = f.add_subplot(gs[:-1, 5])
    ax4.set_aspect(20)
    pos1 = ax4.get_position()
    ax4.set_position([pos1.x0 - 0.025, pos1.y0, pos1.width, pos1.height])
    cb = f.colorbar(hb, cax=ax4)
    cb.set_label('log10(N)')

    if filename is not None:
        plt.savefig(os.path.join('img', filename))
        
def bland_altman_bold(Title, afni_bold_file, spm_bold_file, AFNI_SPM_title,
                 AFNI_FSL_title=None, FSL_SPM_title=None, fsl_bold_file=None,
                 study=''):

    plt.style.use('seaborn-colorblind')
    
    if fsl_bold_file is not None:
        # Create BA plots
        # AFNI/FSL BA plots

        f = plt.figure(figsize=(13, 5))

        gs0 = gridspec.GridSpec(1, 2)

        gs00 = gridspec.GridSpecFromSubplotSpec(
            5, 6, subplot_spec=gs0[0], hspace=0.50, wspace=1.3)


        x_label = ' of % BOLD values'
        y_label = ' of % BOLD values (AFNI - FSL)'
        if study in 'ds001_bold':
            lims = (-0.25, 0.25, -0.25, 0.25)
        else:
            lims=(-0.6,0.6,-0.5,0.5)

        bland_altman_plot(f, gs00, afni_bold_file, fsl_bold_file,
                     AFNI_FSL_title, x_label,
                     y_label, False,
                     'Fig_' + study + '_BOLD_AFNI_FSL.png', lims=lims)

        gs01 = gridspec.GridSpecFromSubplotSpec(
            5, 6, subplot_spec=gs0[1], hspace=0.50, wspace=1.3)

        f.suptitle(Title, fontsize=20, x=0.47, y=1.00)

        plt.show()

    # AFNI/SPM BA plots
    f = plt.figure(figsize=(13, 5))

    gs0 = gridspec.GridSpec(1, 2)

    gs00 = gridspec.GridSpecFromSubplotSpec(
        5, 6, subplot_spec=gs0[0], hspace=0.50, wspace=1.3)

    if fsl_bold_file is not None:
        x_label = ' of % BOLD values'
        y_label = ' of % BOLD values (AFNI - SPM)'
        if study in 'ds001_bold':
            lims = (-0.25, 0.25, -0.25, 0.25)
        else:
            lims=(-0.6,0.6,-0.5,0.5)   
    else:
        x_label = ' of R^2 values'
        y_label = ' of R^2 values (AFNI - SPM)'
        lims=(0,0.7,-0.5,0.5)

    bland_altman_plot(f, gs00, afni_bold_file, spm_bold_file, 
                      AFNI_SPM_title,
                      x_label,
                      y_label, False,
                      'Fig_' + study + '_BA_AFNI_SPM.png',
                      lims=lims)

    gs01 = gridspec.GridSpecFromSubplotSpec(
        5, 6, subplot_spec=gs0[1], hspace=0.50, wspace=1.3)
    
    if fsl_bold_file is None:
        f.suptitle(Title, fontsize=20, x=0.47, y=1.00)
    
    plt.show()
    
    if fsl_bold_file is not None:
        # FSL/SPM BA plots
        f = plt.figure(figsize=(13, 5))

        gs0 = gridspec.GridSpec(1, 2)

        gs00 = gridspec.GridSpecFromSubplotSpec(
            5, 6, subplot_spec=gs0[0], hspace=0.50, wspace=1.3)

        x_label = ' of % BOLD values'
        y_label = ' of % BOLD values (FSL - SPM)'
        if study in 'ds001_bold':
            lims = (-0.25, 0.25, -0.25, 0.25)
        else:
            lims=(-0.6,0.6,-0.5,0.5) 


        bland_altman_plot(f, gs00, fsl_bold_file, spm_bold_file, 
                          FSL_SPM_title,
                          x_label,
                          y_label,
                          False,
                          'Fig_' + study + '_BA_FSL_SPM.png',
                          lims=lims)

        gs01 = gridspec.GridSpecFromSubplotSpec(
            5, 6, subplot_spec=gs0[1], hspace=0.50, wspace=1.3)


        plt.show()
