clear;
close all;
filepath = ['F:\WM_fMRI_iEEG_DSI\IEEG\IEEGprep\sub-0002\ieeg\' ...
    'awake\IEEGprep_common_average_reference\'];
seegdataname = ['sub-0002_state-awake_ses-001_task-rest_run-001_' ...
    'common-average-reference_filtering-05-300_de-artifiact.mat'];
SEEGdata = load([filepath seegdataname]);
label_name = SEEGdata.data_common_average_rereference.label;
load('F:\WM_fMRI_iEEG_DSI\DSI\SC_20220510.mat');
DSI_label_name = SC(2).channels;
%%%%%%%%%%%%%%%
for n=1:size(label_name,1)
        tm1=label_name{n};
        for k=1:size(DSI_label_name,1)
                tm2=DSI_label_name{k};
                ind2 =  strcmp(tm1,tm2);
                if (ind2) 
                    break;
                else 
                    continue;
                end
        end
        new_loc(n,1)=k;
end
for n = 1:size(label_name,1)
        tt{n,1} = DSI_label_name{new_loc(n),1};
end
save('sub_02_reloc_for_DSI_car.mat', 'new_loc');






