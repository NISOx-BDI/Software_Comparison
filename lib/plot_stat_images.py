from nilearn import plotting

def plot_stat_images(afni_stat_file, spm_stat_file, array, Title, fsl_stat_file=None):
    plotting.plot_stat_map(afni_stat_file, vmax=6, title="AFNI: " + Title, display_mode='ortho', cut_coords=array)
    if fsl_stat_file is not None:
        plotting.plot_stat_map(fsl_stat_file, vmax=6, title="FSL: " + Title, display_mode='ortho', cut_coords=array)
    plotting.plot_stat_map(spm_stat_file, vmax=6, title="SPM: " + Title, display_mode='ortho', cut_coords=array)