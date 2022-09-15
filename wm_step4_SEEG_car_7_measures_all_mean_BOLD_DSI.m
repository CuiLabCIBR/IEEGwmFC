%% step4: load SEEG data, then downsample and compute the correlation matrix; compute the dice of the two correlaiton matrix.
%% author: yali huang, 2021-18-11
clear;
close all;

load('sub_02_wm_electrode.mat');
load('sub_02_gm_electrode.mat');

%%%%%%% load BOLD

load('sub_02_corr_ROI_bold_dilation3D18_2009.mat');

 %%%%%%%%% load DSI data      
  load('F:\WM_fMRI_iEEG_DSI\DSI\DSIstudio\stepsize0.5_SL\stepsize0.5_SL.mat');

  load('sub_02_reloc_for_DSI_car.mat');
  
  DSI_conn_1 = SC(2).adjMatrix_fibercount;
  DSI_conn_2 = SC(2).adjMatrix_meanlength;
  DSI_conn_3 = SC(2).adjMatrix_fiberncount;
  DSI_conn_4 = SC(2).adjMatrix_qa;
  DSI_conn = DSI_conn_1(new_loc,new_loc);
  
  DSI_conn=log10(1+DSI_conn);
  
  figure,imagesc(DSI_conn);colorbar;
  
%%%%%% load SEEG

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

%%%%%%%%%%%%%%下采样
data2 = downsample(data1',4);  %
data3 = data2';
%%%%%%%%%%%%read data
% time = 1536;
% data_ROI = data3(:,10001:10000+500*3);% % % % time interval %
% figure,plot(data_ROI(1,:));
%%%%%%%%%%%%%%%%%求平均

for kn=1:10   
      data4(kn,:,:) = squeeze(data3(:,(kn-1)*3072+1:kn*3072));
end

data_ROI = squeeze(mean(data4,1));
figure,plot(data_ROI(1,:));

%%%%%%%%%%%%%%%%%%%%detrend
fs = SEEGdata.data_common_average_rereference.fsample/4; TR = 1/fs; order = 1;
data_detrend = demean_detrend(data_ROI,TR,order);  % % % % % % detrend
figure,plot(data_detrend(1,:));
% figure,plot(data_detrend(2,:));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bandfreq{1} = [4 1];    %%%% delta
bandfreq{2} = [8 4];     %%% theta
bandfreq{3} = [13 8];     %%% alpha
bandfreq{4} = [30 13];    %%% beta
bandfreq{5} = [40 30];    %%% gamma
bandfreq{6} = [70 40];    %% high gamma
bandfreq{7} = [170 70];   %%% HBF
bandfreq{8} = [20 1];
bandfreq{9} = [50 1];
bandfreq{10} = [100 1];

XTickL1={'1-4';'4-8';'8-13';'13-30';'30-40';'40-70';'70-170'};


for bandf=1:7
    
    LOWPASS_HZ = bandfreq{bandf}(1,1);    HIGHPASS_HZ = bandfreq{bandf}(1,2);
    lopasscutoff=LOWPASS_HZ/(0.5/TR); % since TRs vary have to recalc each time
    hipasscutoff=HIGHPASS_HZ/(0.5/TR); % since TRs vary have to recalc each time
    %Using filter order of 1
    filtorder = 1;
    [butta, buttb] = butter(filtorder,[hipasscutoff lopasscutoff]); % % % % % %
    data_filt = filtfilt(butta,buttb,data_detrend');% % % % % %
    
    %%%%%%%%%%
    %%%%%1 compute pearson correlation ,first wm, then gm......202112
    %%%% first step in WM
    filteredData_wm = data_filt(:,WM_id);
    corr = corrcoef(filteredData_wm);
       
    corr(logical(eye(size(corr))))=0;
    figure( 'Position',[380 250 1000 420]),subplot(1,2,1),imagesc(corr);colorbar;colormap(jet); title('SEEG-WM');
    corr_up = triu(corr);
    corr_triup_seeg_wm = corr_up(:);
    corr_triup_seeg_wm(all(corr_triup_seeg_wm==0,2))=[]; %    
    
%     corr_seeg_wm_sub02_allbandf{bandf} = corr;
      corr_seeg_wm_fc_allbandf{bandf} = corr;
    
    clear corr;
    
    %%%%%%%%%%%%%%%%%%%%BOLD
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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%下面是加载DSI，及对DSI去零，然后再跟BOLD和SEEG做对比
    
    temp1 = DSI_conn(WM_id,:);
    corr_DSI_wm = temp1(:,WM_id);
    figure,imagesc(corr_DSI_wm);colormap(jet);title('DSI-WM');axis off;colorbar;
    
    corr_DSI_wm(corr_DSI_wm==0)=1;
    corr_DSI_wm(logical(eye(size(corr_DSI_wm))))=0;
    corr_up = triu(corr_DSI_wm);
    corr_triup_DSI_wm = corr_up(:);
    corr_triup_DSI_wm(all(corr_triup_DSI_wm==0,2))=[]; %
    corr_triup_DSI_wm(corr_triup_DSI_wm==1)=0;
    
    %%%%% DSI ---- SEEG
    
    dice_para(1,:) = corr_triup_DSI_wm;
    dice_para(2,:) = corr_triup_seeg_wm;
    
    ind = find(corr_triup_DSI_wm>0);  %  链接为0的去掉
    
    dice_para2 = dice_para(:,ind);    
    dice_para2(1,:) = NormalizeMiMa(dice_para2(1,:));  %%%% 与文中图5b显示的矩阵中结果一致，所以做了这个变换
    dice_para2(2,:) = NormalizeMiMa(dice_para2(2,:));
    
    [R2, P2] = corrcoef(dice_para2');    
    R_pearson_DSIseeg_wmwm(bandf)=R2(1,2);
    
    figure,imagesc(corr_DSI_wm);colormap(jet);
    title(['R=' num2str(R2(1,2))]);    
    clear dicepara; clear dicepara2;
    %%%%%%%%%%%%%%%%%%%%%%%% DSI --- BOLD
    
    dice_para(1,:) = corr_triup_DSI_wm;
    dice_para(2,:) = corr_triup_BOLD_wm;
    
    dice_para2 = dice_para(:,ind);
    dice_para2(1,:) = NormalizeMiMa(dice_para2(1,:));  %%%% 与文中图5b显示的矩阵中结果一致，所以做了这个变换
    dice_para2(2,:) = NormalizeMiMa(dice_para2(2,:));
    
    [R3, P3] = corrcoef(dice_para2');
    R_pearson_DSIbold_wmwm(bandf)=R3(1,2);
    
    figure,imagesc(corr_DSI_wm);colormap(jet);
    title(['R=' num2str(R3(1,2))]);    
    clear dicepara; clear dicepara2;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    close all;
    
end

figure,bar(R_pearson_seegbold_wmwm);title(num2str(mean(R_pearson_seegbold_wmwm)));
% ylim([0 0.7]);
ylabel('pearson-correlation');xlabel('frequency band(Hz)');
set(gca,'xticklabel',XTickL1);

figure,bar(R_pearson_DSIseeg_wmwm);title(num2str(mean(R_pearson_DSIseeg_wmwm)));
% ylim([0 0.7]);
ylabel('pearson-correlation');xlabel('frequency band(Hz)');
set(gca,'xticklabel',XTickL1);

figure,bar(R_pearson_DSIbold_wmwm);title(num2str(mean(R_pearson_DSIbold_wmwm)));
% ylim([0 0.7]);
ylabel('pearson-correlation');xlabel('frequency band(Hz)');
set(gca,'xticklabel',XTickL1);

save('F:\WM_fMRI_iEEG_DSI_code_backup_0627\WM_results_0627\sub_02_results_step4_SEEG_DSI_BOLD.mat','R_pearson_seegbold_wmwm','R_pearson_DSIseeg_wmwm',...
    'R_pearson_DSIbold_wmwm','XTickL1');
%%%%#################################


save('F:\WM_fMRI_iEEG_DSI_code_backup_0627\WM_results_0627\sub_02_seeg_corr_wm_allbandf.mat','corr_seeg_wm_fc_allbandf');

















