% sub-0001
clc;
clear;
close all;
start_env;
workpath = 'E:\WM_fMRI_iEEG_DSI';
addpath(fullfile(workpath, 'function'));
subj_list = [23];
for ii = 1:length(subj_list)
        subj_ID = ['sub-', num2str(subj_list(ii), '%04d')];
        datapath_deartifact_filtering = dir(fullfile(workpath, 'IEEG', 'IEEGprep', ...
            subj_ID, 'ieeg', 'awake', 'IEEGprep_deartifact_afterfilter'));% find the data
        for NN = 3:length(datapath_deartifact_filtering)
                load(fullfile(datapath_deartifact_filtering(NN).folder, ...
                    datapath_deartifact_filtering(NN).name));% load the data
                    % load the electrode file
                datapath_electrodes = fullfile(workpath, 'report', 'electrodes', ...
                            ['sub-', num2str(subj_list(ii), '%04d'), '_3mm.tsv']); 
                electrode_tsv = ft_read_tsv(datapath_electrodes);
                % define the common average electrode
                chan_label = data_deartifacts_afterfilter.label;
                [chan_group, elec_labels] = xlz_seeg_chan_label(chan_label);
                [data_common_average_rereference, grayM_reref, whiteM_reref, gray_chan, white_chan, na_chan] = ...
                            xlz_seegref_GMWMCA(data_deartifacts_afterfilter, electrode_tsv, chan_group);
                % save
                save_filefolder = fullfile(workpath, 'IEEG', 'IEEGprep', subj_ID, 'ieeg', 'awake', 'IEEGprep_common_average_reference');
                save_name = [subj_ID, '_state-awake_ses-001_task-rest_run-', num2str(NN-2, '%03d'), '_common-average-reference_filtering-05-300_de-artifiact.mat'];
                    mkdir(save_filefolder);
                save(fullfile(save_filefolder, save_name), 'data_common_average_rereference', 'gray_chan', 'white_chan', 'na_chan', '-v7.3');
        end
end