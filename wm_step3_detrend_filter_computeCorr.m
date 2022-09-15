%% step3: fitering and detrend of the BOLD, then compute the correlation matrix;
%% author: Yali Huang, 2021-18-11

clear;close all;

load('sub_02_ts_ROI_bold_dilation3D18_2009.mat');

load('sub_02_wm_electrode.mat');
load('sub_02_gm_electrode.mat');

 for k = 1:1
     
fMRIData = ROI_mean_ts_allsubs;

TR = 2;

%%%% design the filtering
LOWPASS_HZ = 0.2; HIGHPASS_HZ = 0.01;
lopasscutoff=LOWPASS_HZ/(0.5/TR); % since TRs vary have to recalc each time
hipasscutoff=HIGHPASS_HZ/(0.5/TR); % since TRs vary have to recalc each time
%Using filter order of 1
filtorder=1;
[butta, buttb]=butter(filtorder,[hipasscutoff lopasscutoff]);

%Interpolate data if scrubbing
%Use interpolation to account for gaps in time series due to motion scrubbing
%Apply temporal filter
filteredData=filtfilt(butta,buttb,fMRIData');

filteredData_1 = filteredData(:,WM_id);
[corr,p] = corrcoef(filteredData_1);
corr(logical(eye(size(corr))))=0;
corr_BOLD_nodes_WM(k,:,:) = corr;
clear corr;

filteredData_2 = filteredData(:,GM_id);
corr = corrcoef(filteredData_2);
corr(logical(eye(size(corr))))=0;
corr_BOLD_nodes_GM(k,:,:) = corr;
clear corr;

filteredData_3 = [filteredData_1 filteredData_2];
corr = corrcoef(filteredData_3);
corr(logical(eye(size(corr))))=0;
temp = size(filteredData_1,2);
corr_BOLD_nodes_WM_GM(k,:,:) = corr(1:temp,temp+1:end);
clear corr;

 end

save('sub_02_corr_ROI_bold_dilation3D18_2009.mat','corr_BOLD_nodes_WM','corr_BOLD_nodes_GM','corr_BOLD_nodes_WM_GM');



