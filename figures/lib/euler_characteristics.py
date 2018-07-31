import matplotlib.pyplot as plt

def euler_characteristics(euler_chars, Title):
    plt.style.use('seaborn-colorblind')
    clm_list = []
    for column in euler_chars.columns:
        clm_list.append(column)
 
    thresholds = euler_chars[clm_list[0]].values
    
    # Euler Characteristic plot
    if len(euler_chars.columns)==7:
        afni_ecs = euler_chars[clm_list[1]].values
        fsl_ecs = euler_chars[clm_list[2]].values
        spm_ecs = euler_chars[clm_list[3]].values
        
        plt.plot(thresholds, afni_ecs, lw = '1.5')
        plt.plot(thresholds, fsl_ecs, lw = '1.5')
        plt.plot(thresholds, spm_ecs, lw = '1.5')
    
        plt.legend(['AFNI', 'FSL', 'SPM'], bbox_to_anchor=(1.27, 1))
        
    else:
        afni_ecs = euler_chars[clm_list[1]].values
        spm_ecs = euler_chars[clm_list[2]].values
        
        plt.plot(thresholds, afni_ecs, lw = '1.5')
        plt.plot(thresholds, spm_ecs, lw = '1.5')
        
        plt.legend(['AFNI', 'SPM'], bbox_to_anchor=(1.27, 1))
    
    plt.xlabel('Threshold')
    plt.ylabel('Euler Characteristic')

    plt.title('Euler Characteristics: ' + Title)

    plt.show()
    
    # Cluster Count plot
    if len(euler_chars.columns)==7:
        afni_ccs = euler_chars[clm_list[4]].values
        fsl_ccs = euler_chars[clm_list[5]].values
        spm_ccs = euler_chars[clm_list[6]].values
        
        plt.plot(thresholds, afni_ccs, lw = '1.5')
        plt.plot(thresholds, fsl_ccs, lw = '1.5')
        plt.plot(thresholds, spm_ccs, lw = '1.5')
    
        plt.legend(['AFNI', 'FSL', 'SPM'], bbox_to_anchor=(1.27, 1))
        
    else:
        afni_ccs = euler_chars[clm_list[3]].values
        spm_ccs = euler_chars[clm_list[4]].values
        
        plt.plot(thresholds, afni_ccs, lw = '1.5')
        plt.plot(thresholds, spm_ccs, lw = '1.5')
        
        plt.legend(['AFNI', 'SPM'], bbox_to_anchor=(1.27, 1))
    
    plt.xlabel('Threshold')
    plt.ylabel('Cluster Count')

    plt.title('Cluster Counts: ' + Title)

    plt.show()
    