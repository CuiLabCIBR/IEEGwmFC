clear;
close all;
load('sub_01_wm_electrode.mat');
load('sub_01_gm_electrode.mat');

perm =[1:3 6:2:18 24 28:2:34 26 4 7:2:19 27:2:35 25 5 20:23 36:38];

load('sub_01_seeg_corr_wm_allbandf.mat');
n=1;
corr = corr_seeg_wm_sub01_allbandf{n};

temp1 = corr(perm,:);
corr = temp1(:,perm);
corr = NormalizeMiMa(corr);

SEEG_wm_corr = corr;  %save for later figure

corr_tridown_SEEG = tril(corr);
corr_triup_SEEG = triu(corr);
corr_triup_SEEG_wm = corr_triup_SEEG(:);
corr_triup_SEEG_wm(all(corr_triup_SEEG_wm==0,2))=[]; %
clear corr;

%%%%%%%%%%%%%%%%%%%%%%%%%%DSI
%%%%%%%%% load DSI data

load([pwd '\DSIstudio\stepsize0.5_SL\stepsize0.5_SL.mat']);
load('sub_01_reloc_for_DSI_car.mat');  %%  DSI数据ROI重选取和排序，因为ROI里面的数据与SEEG的不一致，以SEEG为标准对齐

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

corr_com1 = corr_tridown_DSI + corr_triup_SEEG;

figure('position',[100,100,260,250]),imagesc(corr_com1);
% title('SEEG FC (left) and BOLD FC (right)');
colormap(jet);
view(45,90);

text(9,-3,'SEEG FC');text(-14,20,'DSI SC');
axis off;axis tight;
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%下面forFig5b图

clear;
load('sub_01_wm_electrode.mat');
load('sub_01_gm_electrode.mat');
perm =[1:3 6:2:18 24 28:2:34 26 4 7:2:19 27:2:35 25 5 20:23 36:38];

%%%%%%% load SEEG

load('sub_01_seeg_corr_wm_allbandf.mat');
n=1;
corr = corr_seeg_wm_sub01_allbandf{n};

temp1 = corr(perm,:);
corr = temp1(:,perm);

corr_tridown_SEEG = tril(corr);
corr_triup_SEEG = triu(corr);
corr_triup_SEEG_wm = corr_triup_SEEG(:);
corr_triup_SEEG_wm(all(corr_triup_SEEG_wm==0,2))=[]; %

%%%%%%%%% load DSI data

load([pwd '\DSIstudio\stepsize0.5_SL\stepsize0.5_SL.mat']);
load('sub_01_reloc_for_DSI_car.mat');  %%  DSI数据ROI重选取和排序，因为ROI里面的数据与SEEG的不一致，以SEEG为标准对齐

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
dice_para(2,:) = corr_triup_SEEG_wm;

ind = find(corr_triup_DSI_wm>0);  %  链接为0的去掉

dice_para2 = dice_para(:,ind);
dice_para2(1,:) = NormalizeMiMa(dice_para2(1,:));  %%%% 与文中图5b显示的矩阵中结果一致，所以做了这个变换
dice_para2(2,:) = NormalizeMiMa(dice_para2(2,:));

[R1, P1] = corrcoef(dice_para2');  %%%%%% 0.3044 ，与主程序的结果是一致的, P1 为0.0001

dsi_wm_corr = dice_para2(1,:);
seeg_wm_corr = dice_para2(2,:);

figure('position',[100,100,300,250]),s=scatter(dsi_wm_corr,seeg_wm_corr,20,'filled');
s.LineWidth = 0.4;
ylabel('SEEG-FC'); xlabel('DSI-SC');
title(['r = ',num2str(R1(1,2),'%.2f')]);
xlim([-1.25 1.25]);
ylim([-1.25 1.25]);
%

