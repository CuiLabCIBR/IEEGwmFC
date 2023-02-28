clc;
clear;
close all;
% set the environment
% add the fieldtrip to the workpath
fieldtrip_path = 'H:\software\matlab_toolbox\fieldtrip';
addpath(fieldtrip_path);
ft_defaults;
addpath function
% set 
workpath = 'E:\IEEG_DSI_connectome\WM_fMRI_iEEG_DSI';
cd(workpath);
subj_list = [1, 2, 8:17, 20:23];
for ii = 1:1:length(subj_list)
        % subject infotmation
        subj_ID = ['sub-', num2str(subj_list(ii), '%04d')];
        % brainstromT1 anatomy image
        T1brainstorm_name = [subj_ID, '_brainstormT1_space_T1.nii'];
        T1brainstorm_path = fullfile(workpath, 'MRI', 'DATA_DSIstudio_output', subj_ID, 'anat', T1brainstorm_name);
        T1_brainstorm = ft_read_mri(T1brainstorm_path);
        % brainstromT1 space ROI image
        ROIbrainstorm_name = [subj_ID, '_brainstormT1_space_ROI.nii'];
        ROIbrainstorm_path = fullfile(workpath, 'MRI', 'DATA_DSIstudio_output', subj_ID, 'anat', ROIbrainstorm_name);
        ROI_brainstorm = ft_read_mri(ROIbrainstorm_path);
        % qsiprepT1 anatomy image
        T1qsiprep_name = [subj_ID, '_desc-preproc_T1w.nii.gz'];
        T1qsiprep_path = fullfile(workpath, 'MRI', 'DATA_qsiprep_output', subj_ID, 'qsiprep', subj_ID, 'anat', T1qsiprep_name);
        T1_qsiprep = ft_read_mri(T1qsiprep_path);
        % Align the individual MRI to the coordinate system of a target or template MRI by matching the two volumes
        % T1
        cfg = [];
        cfg.method = 'spm';
        cfg.spmversion = 'spm12';
        cfg.coordsys = 'acpc';
        cfg.viewresult = 'yes';
        [T1_brainstorm2qsiprep] = ft_volumerealign(cfg, T1_brainstorm, T1_qsiprep);
        % save the T1 image in qsiprep space
        sv_fd = fullfile(workpath, 'MRI', 'DATA_DSIstudio_output', subj_ID, 'anat');
        mkdir(sv_fd);
        save_filename = [subj_ID '_qsiprepT1_space_T1.nii'];
        cfg = [];
        cfg.filename = fullfile(sv_fd, save_filename);
        cfg.filetype = 'nifti';
        cfg.parameter = 'anatomy';
        ft_volumewrite(cfg, T1_brainstorm2qsiprep);
        % save the ROI image
        T1_brainstorm2qsiprep.anatomy = ROI_brainstorm.anatomy;
        sv_fd = fullfile(workpath, 'MRI', 'DATA_DSIstudio_output', subj_ID, 'anat');
        mkdir(sv_fd);
        save_filename = [subj_ID '_qsiprepT1_space_ROI.nii'];
        cfg = [];
        cfg.filename = fullfile(sv_fd, save_filename);
        cfg.filetype = 'nifti';
        cfg.parameter = 'anatomy';
        ft_volumewrite(cfg, T1_brainstorm2qsiprep);
         %%
         % qsiprepT1 space ROI image
        DSI_name = [subj_ID, '_ses*-preproc_dwi.nii.gz'];
        DSI_path = fullfile(workpath, 'MRI', 'DATA_qsiprep_output', subj_ID, 'qsiprep',subj_ID, 'ses-001', 'dwi');
        DSI_file = dir(fullfile(DSI_path, DSI_name));
        DSIimage = ft_read_mri(fullfile(DSI_file.folder, DSI_file.name));
        % qsiprepT1 space ROI image
        ROIdsistudio_name = [subj_ID, '_qsiprepT1_space_ROI.nii'];
        ROIdsistudio_path = fullfile(workpath, 'MRI', 'DATA_DSIstudio_output', subj_ID, 'anat', ROIdsistudio_name);
        ROI_dsitudio = ft_read_mri(ROIdsistudio_path);
        % 
        tsvpath = fullfile(workpath, 'report', 'electrodes', [subj_ID, '_1mm.tsv']);% electrode infomation
        electrode_tsv = ft_read_tsv(tsvpath);
        chans_label = electrode_tsv.Channel;
        Chans_ROI_dsi = zeros(size(DSIimage.anatomy(:, :, :,1)));
        Chans_ROI_qsiprepT1 = zeros(size(T1_qsiprep.anatomy));
        ROI_voxc_T1 = [];
        Refspace_coor = [];
        ROI_voxc_dsi = [];
        for CC = 1:length(chans_label)
            idx = find(ROI_dsitudio.anatomy == CC);
            [x, y, z] = ind2sub(size(ROI_dsitudio.anatomy), idx);
            ROI_voxc_T1 = [mean(x), mean(y), mean(z)];
            % covert the ROI from T1 space to diffusion space
            Refspace_coor = xlz_voxcel2refspace(ROI_voxc_T1, ROI_dsitudio.transform);
            ROI_voxc_dsi = xlz_refspace2voxcel(Refspace_coor, DSIimage.transform);
            ROI_voxc_qsiprepT1 = xlz_refspace2voxcel(Refspace_coor, T1_qsiprep.transform);
            % construct the ROI 
            space_dsi = zeros(size(DSIimage.anatomy(:, :, :,1)));
            radius_dis = 1;% 2mm
            [sphereROI_dsi, vox_num_dsi] = xlz_constructROI(ROI_voxc_dsi, space_dsi, radius_dis);
            Chans_ROI_dsi(sphereROI_dsi > 0) = CC;
%             space_qsiprepT1 = zeros(size(T1_qsiprep.anatomy));
%             radius_qsiprepT1 = 2; % 1mm
%             [sphereROI_qsiprepT1, vox_num_qsiprepT1] = xlz_constructROI(ROI_voxc_qsiprepT1, space_qsiprepT1, radius_qsiprepT1);
%             Chans_ROI_qsiprepT1(sphereROI_qsiprepT1 > 0) = CC;
            % save the dsi ROI coordinate to text file
%             sv_fd = fullfile(workpath, 'MRI', 'DATA_DSIstudio_output', subj_ID, 'anat', 'ROI');
%             mkdir(sv_fd);
%             idx = find(sphereROI_dsi > 0);
%             [X, Y, Z] = ind2sub(size(sphereROI_dsi), idx);
%             fileID = fopen(fullfile(sv_fd, [chans_label{CC},'.txt']), 'w');
%             formatSpec = '%4d %4d %4d \n';
%             for II = 1:length(X)
%                 print_voxc = [X(II), Y(II), Z(II)];
%                 fprintf(fileID, formatSpec, print_voxc);
%             end
%             fclose(fileID);
            % save the chan name as the ROI name
            sv_fd = fullfile(workpath, 'MRI', 'DATA_DSIstudio_output', subj_ID, 'anat');
            mkdir(sv_fd);
            fileID = fopen(fullfile(sv_fd, [subj_ID, '_dsispace_ROI.txt']), 'a+');
            formatSpec = ['%4d ', chans_label{CC}, '\n'];
            fprintf(fileID, formatSpec, CC);
            fclose(fileID);
        end
        %save the ROI image in dsi space
        RoiFilename = [subj_ID, '_dsispace_ROI.nii'];
        SavePath = fullfile(workpath, 'MRI', 'DATA_DSIstudio_output', subj_ID, 'anat');
        DSIimage.anatomy = Chans_ROI_dsi;
        mkdir(SavePath);
        cfg = [];
        cfg.filename = fullfile(SavePath, RoiFilename);
        cfg.filetype = 'nifti';
        cfg.parameter = 'anatomy';
        ft_volumewrite(cfg, DSIimage);
%         %save the ROI image in qsiprepT1 image
%         RoiFilename = [subj_ID, '_qsiprepT1_space_2_ROI.nii'];
%         SavePath = fullfile(workpath, 'MRI', 'DATA_DSIstudio_output', subj_ID, 'anat');
%         T1_qsiprep.anatomy = Chans_ROI_qsiprepT1;
%         mkdir(SavePath);
%         cfg = [];
%         cfg.filename = fullfile(SavePath, RoiFilename);
%         cfg.filetype = 'nifti';
%         cfg.parameter = 'anatomy';
%         ft_volumewrite(cfg, T1_qsiprep);
end