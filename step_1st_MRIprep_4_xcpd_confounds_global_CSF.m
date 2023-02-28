%% generate confounds file
%% step 0: set the env
clc;clear;close all;
addpath('H:\project_manger\xlz_toolbox\toolbox\fieldtrip');
ft_defaults;
%% read the condounds file
pathfMRIprep = 'Z:\WM_BOLD_SEEG_DSI_huangyali\MRI\DATA_fMRIprep_output';
subjDir = dir(fullfile(pathfMRIprep, 'sub*'));
for SS = 1:length(subjDir)
    subjID = subjDir(SS).name;
    confoundsFile = fullfile(pathfMRIprep, subjID, 'fmriprep', subjID, 'ses-001', 'func', [subjID, '_ses-001_task-rest_run-1_desc-confounds_timeseries.tsv']);
    confounds = ft_read_tsv(confoundsFile);
    tsvfolder = ['Z:\WM_BOLD_SEEG_DSI_huangyali\MRI\DATA_confounds_CSF\', subjID];
    mkdir(tsvfolder);
%     CSM = table;
%     CSM.global_signal = confounds.global_signal;
%     CSM.csf = confounds.csf;
%     CSM.trans_x = confounds.trans_x;
%     CSM.trans_x_derivative1 = confounds.trans_x_derivative1;
%     CSM.trans_x_power2 = confounds.trans_x_power2;
%     CSM.trans_x_derivative1_power2 = confounds.trans_x_derivative1_power2;
%     CSM.trans_y = confounds.trans_y;
%     CSM.trans_y_derivative1 = confounds.trans_y_derivative1;
%     CSM.trans_y_power2 = confounds.trans_y_power2;
%     CSM.trans_y_derivative1_power2 = confounds.trans_y_derivative1_power2;
%     CSM.trans_z = confounds.trans_z;
%     CSM.trans_z_derivative1 = confounds.trans_z_derivative1;
%     CSM.trans_z_power2 = confounds.trans_z_power2;
%     CSM.trans_z_derivative1_power2 = confounds.trans_z_derivative1_power2;
%     CSM.rot_x = confounds.rot_x;
%     CSM.rot_x_derivative1 = confounds.rot_x_derivative1;
%     CSM.rot_x_power2 = confounds.rot_x_power2;
%     CSM.rot_x_derivative1_power2 = confounds.rot_x_derivative1_power2;
%     CSM.rot_y = confounds.rot_y;
%     CSM.rot_y_derivative1 = confounds.rot_y_derivative1;
%     CSM.rot_y_power2 = confounds.rot_y_power2;
%     CSM.rot_y_derivative1_power2 = confounds.rot_y_derivative1_power2;
%     CSM.rot_z = confounds.rot_z;
%     CSM.rot_z_derivative1 = confounds.rot_z_derivative1;
%     CSM.rot_z_power2 = confounds.rot_z_power2;
%     CSM.rot_z_derivative1_power2 = confounds.rot_z_derivative1_power2;
%     tsvname =fullfile(tsvfolder, [subjID, '_ses-001_task-rest_run-1_desc-confounds_timeseries.tsv']);
%     writetable(CSM, tsvname, "FileType", "text", 'Delimiter', '\t');
%%
    tsvname =fullfile(tsvfolder, [subjID, '_ses-001_task-rest_run-1_desc-custom_timeseries.tsv']);
    delete(tsvname);
    CSM(:, 1) = confounds.global_signal;
    CSM(:, 2) = confounds.csf;
    for LL = 1:length(CSM(:, 1))
        fileID = fopen(tsvname, 'a+');
%         fprintf(fileID, '%10.10f ', CSM(LL, 1));
        fprintf(fileID, '%10.10f\n', CSM(LL, 2));
        fclose(fileID);
    end
end
