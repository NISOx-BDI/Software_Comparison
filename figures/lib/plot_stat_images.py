from nilearn import plotting

def plot_stat_images(afni_stat_file, spm_stat_file, max_activation, array, Title, fsl_stat_file=None):
    plotting.plot_stat_map(afni_stat_file, vmax=max_activation, title="AFNI: " + Title, display_mode='ortho', cut_coords=array, draw_cross=False)
    if fsl_stat_file is not None:
        plotting.plot_stat_map(fsl_stat_file, vmax=max_activation, title="FSL: " + Title, display_mode='ortho', cut_coords=array, draw_cross=False)
    plotting.plot_stat_map(spm_stat_file, vmax=max_activation, title="SPM: " + Title, display_mode='ortho', cut_coords=array, draw_cross=False)
    
    plotting.show()