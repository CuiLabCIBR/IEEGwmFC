clear;close all;

load('sub_01_corr_ROI_bold_dilation3D18_2009.mat');

corr = squeeze(mean(corr_BOLD_nodes_WM,1));

load('sub_01_wm_electrode.mat');
load('sub_01_gm_electrode.mat');
perm =[1:3 6:2:18 24 28:2:34 26 4 7:2:19 27:2:35 25 5 20:23 36:38];

temp1 = corr(perm,:);
corr = temp1(:,perm);

corr = NormalizeMiMa(corr); %%% �Ա���ʾ�������任

BOLD_wm_corr = corr;

corr_triup_BOLD = triu(corr);
corr_triup_bold_wm = corr_triup_BOLD(:);
corr_triup_bold_wm(all(corr_triup_bold_wm==0,2))=[]; %

clear corr;

%%%%%%%%%%%%%%%%%%%%%%%%%%DSI
%%%%%%%%% load DSI data

load([pwd '\DSIstudio\stepsize0.5_SL\stepsize0.5_SL.mat']);
load('sub_01_reloc_for_DSI_car.mat');  %%  DSI����ROI��ѡȡ��������ΪROI�����������SEEG�Ĳ�һ�£���SEEGΪ��׼����

DSI_conn_1 = SC(1).adjMatrix_fibercount;
DSI_conn_2 = SC(1).adjMatrix_meanlength;
DSI_conn_3 = SC(1).adjMatrix_fiberncount;
DSI_conn_4 = SC(1).adjMatrix_qa;
DSI_conn = DSI_conn_1(new_loc,new_loc);

DSI_conn=log10(1+DSI_conn);

temp1 = DSI_conn(WM_id,:);
corr = temp1(:,WM_id); clear temp1;

%%%%%%% reorder using the perm
temp1 = corr(perm,:);
corr = temp1(:,perm);
corr = NormalizeMiMa(corr);

DSI_wm_corr = corr;  %save for later figure

corr_tridown_DSI = tril(corr);
corr_triup_DSI = triu(corr);

corr_com1 = corr_tridown_DSI + corr_triup_BOLD;

figure('position',[100,100,260,250]),imagesc(corr_com1);
% title('SEEG FC (left) and BOLD FC (right)');
view(45,90);

text(9,-3,'BOLD FC'); text(-14,20,'DSI SC');

axis off;axis tight;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����forFig5cͼ

clear;
load('sub_01_wm_electrode.mat');
load('sub_01_gm_electrode.mat');
perm =[1:3 6:2:18 24 28:2:34 26 4 7:2:19 27:2:35 25 5 20:23 36:38];

%%%%%%% load BOLD

load('sub_01_corr_ROI_bold_dilation3D18_2009.mat');

corr = squeeze(mean(corr_BOLD_nodes_WM,1));

temp1 = corr(perm,:);
corr = temp1(:,perm); clear temp1;

corr_up = triu(corr);
corr_triup_BOLD_wm = corr_up(:);
corr_triup_BOLD_wm(all(corr_triup_BOLD_wm==0,2))=[]; %

%%%%%%%%% load DSI data

load([pwd '\DSIstudio\stepsize0.5_SL\stepsize0.5_SL.mat']);
load('sub_01_reloc_for_DSI_car.mat');  %%  DSI����ROI��ѡȡ��������ΪROI�����������SEEG�Ĳ�һ�£���SEEGΪ��׼����

DSI_conn_1 = SC(1).adjMatrix_fibercount;
DSI_conn_2 = SC(1).adjMatrix_meanlength;
DSI_conn_3 = SC(1).adjMatrix_fiberncount;
DSI_conn_4 = SC(1).adjMatrix_qa;
DSI_conn = DSI_conn_1(new_loc,new_loc);

DSI_conn=log10(1+DSI_conn);

temp1 = DSI_conn(WM_id,:);
corr_DSI_wm = temp1(:,WM_id);
%%%%%%% reorder using the perm

temp1 = corr_DSI_wm(perm,:);
corr_DSI_wm = temp1(:,perm);

corr_DSI_wm(corr_DSI_wm==0)=1;
corr_DSI_wm(logical(eye(size(corr_DSI_wm))))=0;
corr_up = triu(corr_DSI_wm);
corr_triup_DSI_wm = corr_up(:);
corr_triup_DSI_wm(all(corr_triup_DSI_wm==0,2))=[]; %
corr_triup_DSI_wm(corr_triup_DSI_wm==1)=0;

%%%%% DSI ---- SEEG

dice_para(1,:) = corr_triup_DSI_wm;
dice_para(2,:) = corr_triup_BOLD_wm;

ind = find(corr_triup_DSI_wm>0);  %  ����Ϊ0��ȥ��

dice_para2 = dice_para(:,ind);
dice_para2(1,:) = NormalizeMiMa(dice_para2(1,:));  %%%% ������ͼ5b��ʾ�ľ����н��һ�£�������������任
dice_para2(2,:) = NormalizeMiMa(dice_para2(2,:));

%%%%%%  ע�⣬�������任ǰ�󲢲��ı�R��ֵ

[R1, P1] = corrcoef(dice_para2');  %%%%%% 

dsi_corr = dice_para2(1,:);
bold_corr = dice_para2(2,:);

figure('position',[100,100,300,250]),s=scatter(dsi_corr,bold_corr,20,'filled');
s.LineWidth = 0.4;

ylabel('BOLD-FC'); xlabel('DSI-SC');
title(['r = ',num2str(R1(1,2),'%.2f')]);
xlim([-1.25 1.25]);
ylim([-1.25 1.25]);

