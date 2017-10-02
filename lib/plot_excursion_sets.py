from nilearn import plotting
from nilearn.image import math_img
import numpy as np
from nilearn.masking import apply_mask
from nilearn.image import load_img, new_img_like
from nilearn._utils.niimg_conversions import _safe_get_data
import nibabel as nib
import matplotlib.pyplot as plt

def plot_excursion_sets(exc_sets, max_activation, x_coords, y_coords, z_coords):
    for i in range(0, len(sorted(exc_sets.items()))):
        if len(sorted(exc_sets.items())[i][1][1]) == 2:
            soft, (mask_file, (exc_set_file, exc_set_file_neg), stat_file) = sorted(exc_sets.items())[i]
            # Remove NaNs
            n = nib.load(exc_set_file)
            d = n.get_data()
            exc_set_nonan = nib.Nifti1Image(np.nan_to_num(d), n.affine, header=n.header)

            n = nib.load(exc_set_file_neg)
            d = n.get_data()
            exc_set_neg_nonan = nib.Nifti1Image(np.nan_to_num(d), n.affine, header=n.header)

            # Combine activations and deactivations in a single image 
            to_display = math_img("img1-img2", img1=exc_set_nonan, img2=exc_set_neg_nonan)

            # Display statistic maps
            display = plotting.plot_stat_map(to_display, display_mode='x', cut_coords=x_coords, draw_cross=False, colorbar=True, title=soft.upper(), threshold=0.000001, vmax=max_activation)
            display = plotting.plot_stat_map(to_display, cut_coords=y_coords, draw_cross=False, display_mode='y', threshold=0.000001, colorbar=False, vmax=max_activation)
            # Additional plot: slices along z
            display = plotting.plot_stat_map(to_display, cut_coords=z_coords, draw_cross=False, display_mode='z', threshold=0.000001, colorbar=False, vmax=max_activation, title=soft.upper())

            plotting.show()
        else:
            soft, (mask_file, exc_set_file, stat_file) = sorted(exc_sets.items())[i]
            # Remove NaNs
            n = nib.load(exc_set_file)
            d = n.get_data()
            exc_set_nonan = nib.Nifti1Image(np.nan_to_num(d), n.affine, header=n.header)

            # Combine activations and deactivations in a single image 
            to_display = exc_set_nonan

            # Display statistic maps
            display = plotting.plot_stat_map(to_display, display_mode='x', cut_coords=x_coords, draw_cross=False, colorbar=True, title=soft.upper(), threshold=0.000001, vmax=max_activation)
            display = plotting.plot_stat_map(to_display, cut_coords=y_coords, draw_cross=False, display_mode='y', threshold=0.000001, colorbar=False, vmax=max_activation)
            # Additional plot: slices along z
            display = plotting.plot_stat_map(to_display, cut_coords=z_coords, draw_cross=False, display_mode='z', threshold=0.000001, colorbar=False, vmax=max_activation, title=soft.upper())

            plotting.show()