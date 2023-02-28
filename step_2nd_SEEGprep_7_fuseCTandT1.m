%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fuse CT and T1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
start_env;
subj_list = [1];
T1_datapath = 'E:\IEEG_DSI_connectome\WM_fMRI_iEEG_DSI\MRI\DATA_fMRIprep_output';
CT_datapath = 'E:\IEEG_DSI_connectome\WM_fMRI_iEEG_DSI\IEEG\Electrodes';
for nn = 1:length(subj_list)
        % preprocessing of the anatomical CT
        sub = subj_list(nn);
        subj_ID = ['sub-', num2str(sub, '%04d')];
        % import the freesurfer-processed MRI into the MATLAB workspace for the purpose of fusing with the CT scan
        T1path = fullfile(T1_datapath, subj_ID, 'freesurfer', subj_ID, 'mri', 'T1.mgz');
        fsmri_acpc = ft_read_mri(T1path);
        fsmri_acpc.coordsys = 'acpc';
        % Import the acpc anatomical CT into MATLAB workspace
        CTpath = fullfile(CT_datapath, subj_ID, 'Electrodes', [subj_ID, '_ses-001_run-001_CT_acpc.nii']);
        ct_acpc = ft_read_mri(CTpath);
        ct_acpc.coordsys = 'acpc';
        % fuse the CT with the MRI using the below command
        cfg = [];
        cfg.method = 'spm';
        cfg.spmversion = 'spm12';
        cfg.coordsys = 'acpc';
        cfg.viewresult = 'yes';
        ct_acpc_f = ft_volumerealign(cfg, ct_acpc, fsmri_acpc);
        % carefully examine the interactive figure 
        % save the report picture
        % Write the MRI-fused anatomical CT out to a file using the command below.
        cfg = [];
        cfg.filename = [workpath,'/IEEGprep/IEEGprep/',subj_ID,'/anat/',subj_ID,'_ses-001_run-001_CT_acpc'];
        cfg.filetype = 'nifti';
        cfg.parameter = 'anatomy';
        ft_volumewrite(cfg,ct_acpc);
end
