clear; 
close all;
load('sub_01_wm_electrode.mat');
load('sub_01_gm_electrode.mat');
set(0,'defaultfigurecolor','white');

load('sub_01_corr_ROI_bold_dilation3D18_2009.mat');

corr = squeeze(mean(corr_BOLD_nodes_WM,1));

perm =[1:3 6:2:18 24 28:2:34 26 4 7:2:19 27:2:35 25 5 20:23 36:38];

temp1 = corr(perm,:);
corr = temp1(:,perm);

BOLD_wm_corr = corr;

corr_triup_BOLD = triu(corr);

corr_triup_bold_wm = corr_triup_BOLD(:);
corr_triup_bold_wm(all(corr_triup_bold_wm==0,2))=[]; %

clear corr;

%%%%%%%%%%%%%%%%%%%%%%%%%%seeg

load('sub_01_seeg_corr_wm_allbandf.mat');

n=1;

corr = corr_seeg_wm_sub01_allbandf{n};

temp1 = corr(perm,:);
corr = temp1(:,perm);

SEEG_wm_corr = corr;

corr_tridown_SEEG = tril(corr);
corr_triup_SEEG = triu(corr);

corr_triup_seeg_wm = corr_triup_SEEG(:);
corr_triup_seeg_wm(all(corr_triup_seeg_wm==0,2))=[]; %

corr_com1 = corr_tridown_SEEG + corr_triup_BOLD;

figure('position',[100,100,260,250]),imagesc(corr_com1);

colormap(jet);
view(45,90);

text(9,-3,'BOLD FC');   text(-14,20,'SEEG FC');    axis off;axis tight;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = find(abs(corr_triup_seeg_wm)>0.001);

temp1 = corr_triup_seeg_wm(ind);
temp2 = corr_triup_bold_wm(ind);

dice_para(1,:) = temp1;
dice_para(2,:) = temp2;

[R1,P1] = corrcoef(dice_para');

figure('position', [100, 100, 300, 250]),
s = scatter(corr_triup_seeg_wm(ind), corr_triup_bold_wm(ind),20,'filled');
s.LineWidth = 0.4;

xlabel('SEEG-FC'); ylabel('BOLD-FC'); title(['r = ',num2str(R1(1,2),'%.2f')]);




