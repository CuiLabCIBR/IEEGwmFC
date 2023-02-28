%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% convert the T1 image to the acpc coordinate system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clear; close all;
start_env;
subj_list = [1];
T1_raw_datapath = 'E:\IEEG_DSI_connectome\WM_fMRI_iEEG_DSI\MRI\DATA_BIDS';
CT_datapath = 'E:\IEEG_DSI_connectome\WM_fMRI_iEEG_DSI\IEEG\Electrodes';
nn = 1;
        % preprocessing of the anatomical CT
        sub = subj_list(nn);
        subj_ID = ['sub-', num2str(sub, '%04d')];
        % import the anatomical MRI into MATLAB workspace
        T1path = fullfile(T1_raw_datapath, subj_ID, 'ses-001', 'anat', [subj_ID, '_ses-001_run-001_T1w.nii']);
        CT = ft_read_mri(CTpath);

% if the subject does not have the BOLD file, the freesufer file can not
% obtain from the fMRIprep
% using the code below here
clc; clear; close all;
start_fieldtrip;
workpath = '/Volumes/IEEGDSI/IEEG_DSI_connectome/IEEGprep/IEEGprep';
cd(workpath);
sub_list = [1];
for ss = 1:length(sub_list)
    sub = sub_list(ss);
    subj_ID = ['sub-',num2str(sub,'%04d')];
    cd(fullfile(workpath, subj_ID,'anat'));
    % import the anatomical MRI into MATLAB workspace
    T1fname = [subj_ID,'_ses-001_run-001_T1.nii'];
    T1raw = ft_read_mri(T1fname);

    % determine the nativ orientation of the anatomical MRI's left-right axis 
    ft_determine_coordsys(T1raw);

    % align the anatomical MRI to the ACPC coordinate system
    % https://static-content.springer.com/esm/art%3A10.1038%2Fs41596-018-0009-6/MediaObjects/41596_2018_9_MOESM7_ESM.mp4
    % the origin is at the anterior commissure (AC)
    % the y axis runs along the line between the AC and the posterior commissure(PC)
    % the z axis lies in the midline dividing the two cerebral hemishperes 
        % specify the AC and PC, 
        % specify the interhemishphere location along the midline at the top of the bran
        % specify a location in the brains's right hemisphere
    % 1. select points in each of the two hemispheres and note the change in
    % X-coordinates int the command window
    % 2. Hitting "R" on the keyboard assigns the current crosshair positions to
    % a point in the right hemisphere
    % 3. identify the anterior commissure, a small white matter tract that
    % connects the two hemispheres. It is located slightly posterior to the
    % genu of the corpus callosum.
    % 4. Hitting "A" on the keyboard assigns the current crosshair position to
    % the anterior commissure
    cfg = [];
    cfg.method = 'interactive'; 
    cfg.coordsys = 'acpc'; 
    T1_acpc = ft_volumerealign(cfg, T1raw);

    % write the preprocessed anatomical MRI out to a file
    cfg = [];
    cfg.filename = [subj_ID '_ses-001_run-001_T1W_acpc'];
    cfg.filetype = 'nifti';
    cfg.parameter = 'anatomy';
    ft_volumewrite(cfg, T1_acpc);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% freesurfer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;
close all;
start_fieldtrip;
workpath = '/Volumes/IEEGDSI/IEEG_DSI_connectome/IEEGprep/IEEGprep';
cd(workpath);
sub_list = 41;
for ss = 1:length(sub_list)
    sub = sub_list(ss);
    subj_ID = ['sub-',num2str(sub,'%04d')];
    cd(fullfile(workpath, subj_ID,'anat'));
    % execute freesufer's recon-all functionality
    % This set of commands will create a folder named  freesurfer% This set of commands will create a folder named  freesurfer' in the subject directory, with  in the subject directory, with 
    % subdirectories containing a multitude of FreeSurfer-generated files.
    fshome = '/Applications/freesurfer/7.2.0';
    subdir = pwd;
    mrfile = [subj_ID '_ses-001_run-001_T1W_acpc.nii'];
    system(['export FREESURFER_HOME=', fshome, '; ', ...
        'source $FREESURFER_HOME/SetUpFreeSurfer.sh; ', ...
        'mri_convert -c -oc 0 0 0 ' mrfile ' ' [subdir '/tmp.nii'] '; ', ...
        'recon-all -i ' [subdir '/tmp.nii'] ' -s ' 'freesurfer' ' -sd ' subdir ' -all']);
end