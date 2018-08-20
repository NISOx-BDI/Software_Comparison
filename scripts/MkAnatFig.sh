#!/bin/bash

shopt -s nullglob # No-match globbing expands to null

cd /home/essicd/data/NIDM-Ex/BIDS_Data/RESULTS/SOFTWARE_COMPARISON


Img=( mean_mni_anat mean_mni_mean_func std_mni_anat std_mni_mean_func )
Mx=(  175           250                40           50 )

for ((i=0;i<${#Img[*]};i++)) ; do
     for f in `ls -1 */*/mean_mni_images/*${Img[i]}*nii*  | grep -vE 'sub|unstandardised|AFNI_NL|AFNI_OLD|FSL_NL|FSL_OLD'` ; do
 	slicer $f -i 0 ${Mx[i]} -a ${f%%.*}.png
     done
done



# create empty images for FSL ds120; clone from ds109

mkdir -p ds120/FSL/mean_mni_images

for f in ds109/FSL/mean_mni_images/*png ; do
    convert $f -background White -compose Dst -flatten ${f/ds109/ds120}
done

for png in \
    "mean_mni_anat.png" \
    "mean_mni_mean_func.png" \
    "std_mni_anat.png" \
    "std_mni_mean_func.png" ; do 
    
    montage ds{001,109,120}/{AFNI,FSL,SPM}/mean_mni_images/*$png -tile x3 -geometry '1x1+2+2<' figures/$png
done
