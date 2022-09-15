
clear; close all;

set(0,'defaultfigurecolor','w');

list = dir([pwd '\WM_results_0627_60seconds\*SEEG_DSI_BOLD.mat']);

wm_dsi_bold = [];

wm_dsi_seeg = [];

wm_seeg_bold = [];

seegbold_wmwm_saveRdata = [];

DSIseeg_wmwm_saveRdata =[];

temp = [];

temp0 = [];

Xtick = [];

for n=1:length(list)
    
    load([list(n).folder '\' list(n).name]);
    
    wm_dsi_bold = [wm_dsi_bold;R_pearson_DSIbold_wmwm'];    
    
    wm_dsi_seeg = [wm_dsi_seeg;R_pearson_DSIseeg_wmwm'];
    
    wm_seeg_bold = [wm_seeg_bold;R_pearson_seegbold_wmwm'];    
    
    seegbold_wmwm_saveRdata = [seegbold_wmwm_saveRdata;R_pearson_seegbold_wmwm];    
    
    DSIseeg_wmwm_saveRdata = [DSIseeg_wmwm_saveRdata;R_pearson_DSIseeg_wmwm];      
               
    temp = [temp;R_pearson_seegbold_wmwm];   
    temp0 = [temp0;R_pearson_DSIbold_wmwm];    
        
    Xtick = [Xtick;XTickL1(1:7)];
    
end

% save('D:\R_work\matdata\seegbold_wmwm_saveRdata.mat','seegbold_wmwm_saveRdata','-v7');
% save('D:\R_work\matdata\DSIseeg_wmwm_saveRdata.mat','DSIseeg_wmwm_saveRdata','-v7');

figure( 'Position',[488 342 760 420]);
grouporder=XTickL1;
vs = violinplot(wm_dsi_bold, Xtick,'GroupOrder',grouporder);title('DSI-BOLD-WM\_FC-similarity');
ylabel('WM-coherence');
xlabel('Frequency(Hz)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%

figure( 'Position',[488 342 760 420]);
vs = violinplot(wm_dsi_seeg, Xtick,'GroupOrder',grouporder);  title('DSI-SEEG-WM\_FC-similarity');
ylabel('Correlation');
xlabel('Frequency(Hz)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%

figure( 'Position',[488 342 760 420]);
vs = violinplot(wm_seeg_bold, Xtick,'GroupOrder',grouporder); title('BOLD-SEEG-WM\_FC-similarity');
ylabel('Correlation');
xlabel('Frequency(Hz)');





