from urllib2 import urlopen, URLError, HTTPError
from urllib2 import Request
from shutil import copyfile
import json
import os

def download_data(nv_collection, study):
    request = Request('http://neurovault.org/api/collections/' + nv_collection + '/nidm_results/?limit=184&format=json')
    response = urlopen(request)
    elevations = response.read()
    data = json.loads(elevations)

    pwd = os.path.dirname(os.path.realpath('__file__'))
    input_dir = os.path.join(pwd, "input")
    root = os.path.dirname(pwd)
    data_dir = os.path.join(input_dir, study)

    if not os.path.isdir(data_dir):
        if not os.path.isdir(input_dir):
            os.makedirs(input_dir)
        os.makedirs(data_dir)

    for nidm_result in data["results"]:
        url = nidm_result["zip_file"]
        study_name = nidm_result["name"]

        localzip = os.path.join(data_dir, study_name + ".zip")
        localzip_rel = localzip.replace(pwd, '.')
        if not os.path.isfile(localzip):
            # Copy .nidm.zip export locally in a the data directory
            try:
                f = urlopen(url)
                print("downloading " + url + " at " + localzip_rel)
                with open(localzip, "wb") as local_file:
                    local_file.write(f.read())
            except HTTPError, e:
                raise Exception(["HTTP Error:" + str(e.code) + url])
            except URLError, e:
                raise Exception(["URL Error:" + str(e.reason) + url])
        else:
            print(url + " already downloaded at " + localzip_rel)

    for afni_image, local_name in (
            ('Negative_clustered_t_stat.nii.gz', 'afni_exc_set_neg.nii.gz'), 
            ('Positive_clustered_t_stat.nii.gz', 'afni_exc_set_pos.nii.gz'),
            ('3dMEMA_result_t_stat_masked.nii.gz', 'afni_stat.nii.gz'),
            ('mask.nii.gz', 'afni_mask.nii.gz')):

        url = "http://neurovault.org/media/images/" + nv_collection + '/' + afni_image
        local_file = os.path.join(data_dir, local_name)
        if not os.path.isfile(local_file):
            # Copy file locally in a the data directory
            try:
                f = urlopen(url)
                print("downloading " + url + " at " + local_file)
                with open(local_file, "wb") as local_fid:
                    local_fid.write(f.read())
            except HTTPError, e:
                raise Exception(["HTTP Error:" + str(e.code) + url])
            except URLError, e:
                raise Exception(["URL Error:" + str(e.reason) + url])
        else:
            print(url + " already downloaded at " + local_file)

    for euler_char_file, local_name in (
            ('AFNI/LEVEL2/euler_chars.csv', 'afni_euler_chars.csv'),
            ('FSL/LEVEL2/group.gfeat/cope1.feat/stats/euler_chars.csv', 'fsl_euler_chars.csv'),
            ('SPM/LEVEL2/euler_chars.csv', 'spm_euler_chars.csv'),
            ('AFNI/LEVEL2/permutation_test/euler_chars.csv', 'afni_perm_euler_chars.csv'),
            ('FSL/LEVEL2/permutation_test/euler_chars.csv', 'fsl_perm_euler_chars.csv'),
            ('SPM/LEVEL2/permutation_test/euler_chars.csv', 'spm_perm_euler_chars.csv')):

        local_file = os.path.join(data_dir, local_name)
        if not os.path.isfile(local_file):
            copyfile(os.path.join(root, study, euler_char_file), local_file)
        else:
            print(url + " already copied at " + local_file)

    resl_imgages = (
        'afni_fsl_reslice.nii.gz', 'afni_fsl_reslice_pos_exc.nii.gz','afni_fsl_reslice_neg_exc.nii.gz',
        'afni_reslice_fsl.nii.gz', 'afni_reslice_fsl_pos_exc.nii.gz','afni_reslice_fsl_neg_exc.nii.gz',
        'afni_spm_reslice.nii.gz', 'afni_spm_reslice_pos_exc.nii.gz','afni_spm_reslice_neg_exc.nii.gz',
        'afni_reslice_spm.nii.gz', 'afni_reslice_spm_pos_exc.nii.gz','afni_reslice_spm_neg_exc.nii.gz',
        'fsl_spm_reslice.nii.gz', 'fsl_spm_reslice_pos_exc.nii.gz','fsl_spm_reslice_neg_exc.nii.gz',
        'fsl_reslice_spm.nii.gz', 'fsl_reslice_spm_pos_exc.nii.gz','fsl_reslice_spm_neg_exc.nii.gz',
        'afni_fsl_reslice_perm.nii.gz', 'afni_fsl_reslice_pos_exc_perm.nii.gz',
        'afni_reslice_fsl_perm.nii.gz', 'afni_reslice_fsl_pos_exc_perm.nii.gz',
        'afni_spm_reslice_perm.nii.gz', 'afni_spm_reslice_pos_exc_perm.nii.gz',
        'afni_reslice_spm_perm.nii.gz', 'afni_reslice_spm_pos_exc_perm.nii.gz',
        'fsl_spm_reslice_perm.nii.gz', 'fsl_spm_reslice_pos_exc_perm.nii.gz',
        'fsl_reslice_spm_perm.nii.gz', 'fsl_reslice_spm_pos_exc_perm.nii.gz',
        'afni_perm_reslice_fsl_pos_exc.nii.gz',
        'afni_perm_fsl_reslice_pos_exc.nii.gz',
        'afni_reslice_fsl_perm_pos_exc.nii.gz', 'afni_reslice_fsl_perm_neg_exc.nii.gz',
        'afni_fsl_perm_reslice_pos_exc.nii.gz', 'afni_fsl_perm_reslice_neg_exc.nii.gz',                        
        'afni_perm_reslice_spm_pos_exc.nii.gz',
        'afni_perm_spm_reslice_pos_exc.nii.gz',
        'afni_reslice_spm_perm_pos_exc.nii.gz',
        'afni_spm_perm_reslice_pos_exc.nii.gz',
        'fsl_perm_reslice_spm_pos_exc.nii.gz', 'fsl_perm_reslice_spm_neg_exc.nii.gz',
        'fsl_perm_spm_reslice_pos_exc.nii.gz', 'fsl_perm_spm_reslice_neg_exc.nii.gz',        
        'fsl_reslice_spm_perm_pos_exc.nii.gz',
        'fsl_spm_perm_reslice_pos_exc.nii.gz',
        )

    if study not in ('ds109'):
        # There is no deactivations in ds109 with AFNI perm and SnPM
        resl_imgages.append(
            'afni_fsl_reslice_neg_exc_perm.nii.gz',
            'afni_reslice_fsl_neg_exc_perm.nii.gz',
            'afni_spm_reslice_neg_exc_perm.nii.gz',
            'afni_reslice_spm_neg_exc_perm.nii.gz',
            'fsl_spm_reslice_neg_exc_perm.nii.gz',
            'fsl_reslice_spm_neg_exc_perm.nii.gz',
            'afni_perm_reslice_fsl_neg_exc.nii.gz',
            'afni_perm_fsl_reslice_neg_exc.nii.gz',
            'afni_perm_reslice_spm_neg_exc.nii.gz',
            'afni_perm_spm_reslice_neg_exc.nii.gz',
            'afni_reslice_spm_perm_neg_exc.nii.gz',
            'afni_spm_perm_reslice_neg_exc.nii.gz',
            'fsl_reslice_spm_perm_neg_exc.nii.gz',
            'fsl_spm_perm_reslice_neg_exc.nii.gz'
            )

    for resliced_image in resl_imgages:

        url = "http://neurovault.org/media/images/" + nv_collection + '/' + resliced_image
        local_file = os.path.join(data_dir, resliced_image)
        if not os.path.isfile(local_file):
            # Copy file locally in a the data directory
            try:
                f = urlopen(url)
                print("downloading " + url + " at " + local_file)
                with open(local_file, "wb") as local_fid:
                    local_fid.write(f.read())
            except HTTPError, e:
                raise Exception(["HTTP Error:" + str(e.code) + url])
            except URLError, e:
                raise Exception(["URL Error:" + str(e.reason) + url])
        else:
            print(url + " already downloaded at " + local_file)

    perm_img_to_local_name = (
        ('perm_ttest++_Clustsim_result_t_stat_masked.nii.gz', 'afni_perm.nii.gz'), 
        ('perm_Positive_clustered_t_stat.nii.gz', 'afni_perm_exc_set_pos.nii.gz'),
        ('perm_mask.nii.gz', 'afni_perm_mask.nii.gz'),
        ('OneSampT_tstat1.nii.gz', 'fsl_perm.nii.gz'),
        ('05FWECorrected_OneSampT_pos_exc_set.nii.gz', 'fsl_perm_exc_set_pos.nii.gz'),
        ('05FWECorrected_OneSampT_neg_exc_set.nii.gz', 'fsl_perm_exc_set_neg.nii.gz'),
        ('snpmT%2B.nii.gz', 'spm_perm.nii.gz'),
        ('SnPM_pos_filtered.nii.gz', 'spm_perm_exc_set_pos.nii.gz')
    )

    if study not in ('ds109'):
        # There is no deactivations in ds109 with AFNI perm
        perm_img_to_local_name.append(
            ('perm_Negative_clustered_t_stat.nii.gz', 'afni_perm_exc_set_neg.nii.gz'),)
        # There is no deactivations in ds109 with SnPM (SPM perm)
        perm_img_to_local_name.append(
            ('SnPM_neg_filtered.nii.gz', 'spm_perm_exc_set_neg.nii.gz'),)

    for perm_image, local_name in perm_img_to_local_name:

        url = "http://neurovault.org/media/images/" + nv_collection + '/' + perm_image
        local_file = os.path.join(data_dir, local_name)
        if not os.path.isfile(local_file):
            # Copy file locally in a the data directory
            try:
                f = urlopen(url)
                print("downloading " + url + " at " + local_file)
                with open(local_file, "wb") as local_fid:
                    local_fid.write(f.read())
            except HTTPError, e:
                raise Exception(["HTTP Error:" + str(e.code) + url])
            except URLError, e:
                raise Exception(["URL Error:" + str(e.reason) + url])
        else:
            print(url + " already downloaded at " + local_file)