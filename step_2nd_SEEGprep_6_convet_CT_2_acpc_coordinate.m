%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% convert the CT's coordinate systems into an approximation of the acpc coordinate system
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
        % Import the anatomical CT into MATLAB workspace
        CTpath = fullfile(CT_datapath, subj_ID, 'Electrodes', [subj_ID, '_ses-001_run-001_CT.nii']);
        CT = ft_read_mri(CTpath);
        % determine the native orientation
        ft_determine_coordsys(CT);
        % Align the anatomical CT to the CTF head surface coordinate system
        % 1. The peri-auricular points are located around the ear canal.
        % Here we know which side is left in the scan given that the patient had
        % grid implanted in the left hemisphere.
        % 2. Hitting 'L' on the keyboard assigns the current crosshair position
        % to a point in the left.
        % 3. Identify a similar peri-auricular point in the opposite right
        % hemisphere. And hit 'R' on the keyboard.
        % 4. Identify the nasion. This is the intersection between the frontal
        % and nasal bones of the skull. Hit 'N' on the keyboard.
        cfg = [];
        cfg.method = 'interactive';
        cfg.coordsys = 'ctf';
        ct_ctf = ft_volumerealign(cfg, CT);
        % automatically convert the CT's coordinate systems into an approximation of the acpc coordinate system
        addpath('H:\software\matlab_toolbox\spm12');
        ct_acpc = ft_convert_coordsys(ct_ctf, 'acpc');
        % write the preprocessed anatomical MRI out to a file
        cd(fullfile(CT_datapath, subj_ID, 'Electrodes'));
        cfg = [];
        cfg.filename = [subj_ID '_ses-001_run-001_CT_acpc'];
        cfg.filetype = 'nifti';
        cfg.parameter = 'anatomy';
        ft_volumewrite(cfg, ct_acpc);
end
