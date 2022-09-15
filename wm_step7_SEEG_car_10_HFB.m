%% step4: load SEEG data, then downsample and compute the correlation matrix; compute the dice of the two correlaiton matrix.
%% author: yali huang, 2021-18-11
clear;
close all;
filepath = 'F:\WM_fMRI_iEEG_DSI\IEEG\IEEGprep\sub-0002\ieeg\awake\IEEGprep_common_average_reference\';

seegdataname = 'sub-0002_state-awake_ses-001_task-rest_run-003_common-average-reference_filtering-05-300_de-artifiact.mat';

 SEEGdata = load([filepath seegdataname]);

label_name = SEEGdata.data_common_average_rereference.label;

data0 = SEEGdata.data_common_average_rereference.trial;

for tn = 1:length(data0)
    temp = data0{1,tn};
    size_trial(tn)=size(temp,2);
end

[val pos]=max(size_trial);

data1 = data0{1,pos};
figure,plot(data1(1,:));

%%%%%%%%%%%%read data
data_ROI = data1(:,1:2048*100);% % % % time interval % 
%%%%%%%%%%%%%%%%%%%%detrend

fs = SEEGdata.data_common_average_rereference.fsample; TR = 1/fs; order = 1;
data_detrend = demean_detrend(data_ROI,TR,order);  % % % % % % detrend
figure,plot(data_detrend(1,:));

bandfreq{1} = [180 40];
bandfreq{2} = [120 60];  %  Open multimodal iEEG-fMRI dataset from
bandfreq{3} = [140 60];  % li guangye
bandfreq{4} = [170 70];  % Josey
bandfreq{5} = [250 180]; % HFO

XTickL1={'40-180';'60-120';'60-140';'70-170';'180-250'};

XTickL1={'40-180';'60-120';'60-140';'70-170';'180-250'};

for bandf=1:5
    %     bandf=1;
    LOWPASS_HZ = bandfreq{bandf}(1,1);    HIGHPASS_HZ = bandfreq{bandf}(1,2);  
    lopasscutoff=LOWPASS_HZ/(0.5/TR); % since TRs vary have to recalc each time
    hipasscutoff=HIGHPASS_HZ/(0.5/TR); % since TRs vary have to recalc each time
    %Using filter order of 1
    filtorder = 7;
    [butta, buttb] = butter(filtorder,[hipasscutoff lopasscutoff]); % % % % % %
    data_filt_1 = filtfilt(butta,buttb,data_detrend');% % % % % %
      
    %%%%%
    LOWPASS_HZ = 1;    HIGHPASS_HZ = 0.1;  
    lopasscutoff=LOWPASS_HZ/(0.5/TR); % since TRs vary have to recalc each time
    hipasscutoff=HIGHPASS_HZ/(0.5/TR); % since TRs vary have to recalc each time
    %Using filter order of 1
    filtorder = 1;
    [butta, buttb] = butter(filtorder,[hipasscutoff lopasscutoff]); % % % % % %
    
    %%%%%
    
    for kk=1:size(data_filt_1,2)    
        
    abs_hilbert(:,kk) = abs(hilbert(data_filt_1(:,kk)));    
    
    data_filt_envelp(:,kk) = filtfilt(butta,buttb,abs_hilbert(:,kk));% % % % % %

    end
    
    data_filt = data_filt_envelp;
    corr = corrcoef(data_filt);
    corr(logical(eye(size(corr))))=0;
    figure,imagesc(corr);colorbar;colormap(jet); title('SEEG-all');
    clear corr;
    %%%%%%%%%%
    %%%%%1 compute pearson correlation ,first wm, then gm......202112
    %%%% first step in WM
    load('sub_02_wm_electrode.mat');
    filteredData_wm = data_filt(:,WM_id);
    corr = corrcoef(filteredData_wm);
    corr(logical(eye(size(corr))))=0;
    figure( 'Position',[380 250 1000 420]),subplot(1,2,1),imagesc(corr);colorbar;colormap(jet); title('SEEG-WM');
    corr_up = triu(corr);
    corr_triup_seeg_wm = corr_up(:);
    corr_triup_seeg_wm(all(corr_triup_seeg_wm==0,2))=[]; %
    clear corr;
    
    load('sub_02_corr_ROI_bold_dilation3D18_2009.mat');
    corr = squeeze(mean(corr_BOLD_nodes_WM,1));
    corr_up = triu(corr);
    corr_triup_BOLD_wm = corr_up(:);
    corr_triup_BOLD_wm(all(corr_triup_BOLD_wm==0,2))=[]; %
    
    dice_para(1,:) = corr_triup_BOLD_wm;
    dice_para(2,:) = corr_triup_seeg_wm;
    
    [R1, P1] = corrcoef(dice_para'); clear dice_para;
    R_pearson_seegbold_wmwm(bandf)=R1(1,2);
    
    subplot(1,2,2),imagesc(corr);colorbar;colormap(jet); title(['SEEG-wm-BOLD-wm-band(1-' num2str(LOWPASS_HZ) 'Hz) R=' num2str(R1(1,2))]);
    clear corr;
    
    %%%%%%%%first step compute in GM
    load('sub_02_gm_electrode.mat');
    filteredData_gm = data_filt(:,GM_id);
    corr = corrcoef(filteredData_gm);
    corr(logical(eye(size(corr))))=0;
    figure( 'Position',[380 250 1000 420]),subplot(1,2,1),imagesc(corr);colorbar;colormap(jet); title('SEEG-GM');
    corr_up = triu(corr);
    corr_triup_seeg_gm = corr_up(:);
    corr_triup_seeg_gm(all(corr_triup_seeg_gm==0,2))=[]; %
    clear corr;
    
    corr = squeeze(mean(corr_BOLD_nodes_GM,1)); % average
    corr(logical(eye(size(corr))))=0;
    corr_up = triu(corr);
    corr_triup_BOLD_gm = corr_up(:);
    corr_triup_BOLD_gm(all(corr_triup_BOLD_gm==0,2))=[]; %
    
    dice_para2(1,:) = corr_triup_BOLD_gm;
    dice_para2(2,:) = corr_triup_seeg_gm;
    
    [R2, P2] = corrcoef(dice_para2');
    R_pearson_seegbold_gmgm(bandf)=R2(1,2);
    
    subplot(1,2,2),imagesc(corr);colorbar;colormap(jet); title(['SEEG-gm-BOLD-gm-band(1-' num2str(LOWPASS_HZ) 'Hz) R=' num2str(R2(1,2))]);
    
    clear corr;       
    close all;    
end

figure,bar(R_pearson_seegbold_wmwm);title(num2str(mean(R_pearson_seegbold_wmwm)));
ylabel('coherence');xlabel('frequency band(Hz)');
set(gca,'xticklabel',XTickL1);

figure,bar(R_pearson_seegbold_gmgm);title(num2str(mean(R_pearson_seegbold_gmgm)));
ylabel('coherence');xlabel('frequency band(Hz)');
set(gca,'xticklabel',XTickL1);

save('F:\WM_fMRI_iEEG_DSI_code_backup_0627\WM_results_0627\sub_02_results_step7_HFB.mat','R_pearson_seegbold_wmwm',...
    'R_pearson_seegbold_gmgm');
%%%%#################################














