clc;
clear;
close all;
% set the environment
% add the fieldtrip to the workpath
start_env;
fieldtrip_path = 'H:\software\matlab_toolbox\fieldtrip';
addpath(fieldtrip_path);
ft_defaults;
addpath function
% set 
workpath = 'E:\WM_fMRI_iEEG_DSI';
cd(workpath);
subj_list = [1, 2, 8:17, 20:23];
for ii = 1:1%:length(subj_list)
        % subject infotmation
        subj_ID = ['sub-', num2str(subj_list(ii), '%04d')];
        
        % load brainstorm MRI structure data
        SCS_convert_path= fullfile('H:\project_manger\brainstorm_database\Protocol01', 'anat', subj_ID, 'subjectimage_MRI_T1.mat');
        smri = load(SCS_convert_path);
        % save the anatomy image in brainstom space
        AnatFilename = [subj_ID, '_brainstormT1_space_T1.nii'];
        SavePath = fullfile(workpath, 'MRI', 'DATA_DSIstudio_output', subj_ID, 'anat');
        mkdir(SavePath);
        OutputFile = fullfile(SavePath, AnatFilename);
        out_mri_nii(smri, OutputFile, 'uint8');

        % electrode infomation
        tsvpath = fullfile(workpath, 'report', 'electrodes', [subj_ID, '_1mm.tsv']);
        electrode_tsv = ft_read_tsv(tsvpath);
        SCS_coord = electrode_tsv.SCS;
        SCS_coord = cellfun(@str2num, SCS_coord, 'UniformOutput', false);
        SCS_coord = cell2mat(SCS_coord);
        chan_label = electrode_tsv.Channel;
        MRI_coord = cs_convert(smri, 'scs', 'MRI', SCS_coord/1000); %convert SCS to MRI 
        MRI_coord = MRI_coord*1000;
         % construct ROI
        space = smri.Cube;
        space(:, :, :) = 0;
        radius = 1;
        ChanROIs = space;
        for CC = 1: length(chan_label) 
                chan_vox_coor = round(MRI_coord(CC, :));
                [sphereROI, vox_num] = xlz_constructROI(chan_vox_coor, space, radius);
                ChanROIs(sphereROI >= 1) = CC;
        end
        % save the anatomy image in brainstom space
        RoiFilename = [subj_ID, '_brainstormT1_space_ROI.nii'];
        SavePath = fullfile(workpath, 'MRI', 'DATA_DSIstudio_output', subj_ID, 'anat');
        mkdir(SavePath);
        OutputFile = fullfile(SavePath, RoiFilename);
        smri.Cube = ChanROIs;
        out_mri_nii(smri, OutputFile, 'uint8');
end

