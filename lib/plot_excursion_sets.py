from nilearn import plotting
from nilearn.image import math_img
import numpy as np
from nilearn.masking import apply_mask
from nilearn.image import load_img, new_img_like
from nilearn._utils.niimg_conversions import _safe_get_data
import nibabel as nib

def plot_excursion_sets(exc_sets):

    for soft, (mask_file, (exc_set_file, exc_set_file_neg), stat_file) in sorted(exc_sets.items()):
        # Remove NaNs
        n = nib.load(exc_set_file)
        d = n.get_data()
        exc_set_nonan = nib.Nifti1Image(np.nan_to_num(d), n.affine, header=n.header)

        n = nib.load(exc_set_file_neg)
        d = n.get_data()
        exc_set_neg_nonan = nib.Nifti1Image(np.nan_to_num(d), n.affine, header=n.header)

        # Combine activations and deactivations in a single image 
        to_display = math_img("img1-img2", img1=exc_set_nonan, img2=exc_set_neg_nonan)

        # Display x=4, y=32 and y=38 as in the manuscript
        display = plotting.plot_stat_map(to_display, display_mode='x', cut_coords=[4, 32], draw_cross=False, colorbar=True, 
                               title=soft.upper(), threshold=0.000001, vmax=4.2)
        display = plotting.plot_stat_map(to_display, cut_coords=[38], draw_cross=False, display_mode='y', 
                               threshold=0.000001, colorbar=False, vmax=4.2)
        # Additional plot: slices along z
        display = plotting.plot_stat_map(to_display, cut_coords=[-32, -18, 0, 12, 24, 40, 58], draw_cross=False, display_mode='z', 
                               threshold=0.000001, colorbar=False, vmax=4.2, title=soft.upper())
    #     # Analysis mask
    #     display = plotting.plot_roi(mask_file, title=soft.upper()+': Analysis mask')

    #     # Analysis mask
    #     display = plotting.plot_roi(mask_file, title=soft.upper()+': Analysis mask', 
    #                                 cut_coords=7, draw_cross=False, display_mode='z')


    plotting.show()