
clear; close all;
set(0,'defaultfigurecolor','w') 

list = dir([pwd '\WM_results_0627_60seconds\*HFB.mat']);

wm_cohence = [];
gm_cohence = [];

wm_plv = [];
gm_plv = [];

wm_pearson = [];
gm_pearson = [];

wm_seegbold = [];

Xtick = [];
XTickL1={'40-180';'60-120';'60-140';'70-170';'180-250'};


for n=1:length(list)
    
    load([list(n).folder '\' list(n).name]); 
       
    wm_pearson = [wm_pearson;R_pearson_seegbold_wmwm(1:4)'];
    
    wm_seegbold = [wm_seegbold;R_pearson_seegbold_wmwm(1:4)];
    
    Xtick = [Xtick;XTickL1(1:4)];
    
end

% save('D:\R_work\matdata\HFBenvelope_wmwm_saveRdata.mat','wm_seegbold','-v7');

grouporder=XTickL1;

figure( 'Position',[488 342 760 420]);
vs = violinplot(wm_pearson, Xtick,'GroupOrder',grouporder);
ylabel('Correlation');
xlabel('Frequency(Hz)'); title('BOLD-SEEG\_HFB\_envelope(0.1-1Hz)');



