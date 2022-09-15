clear; 

close all;

set(0,'defaultfigurecolor','w');

load('sub_02_reloc_for_CAR.mat');

LegendStr = new_loc(:,2);

indx = [];

for n=1:size(LegendStr,1)

a=LegendStr(n,:);

ind = strfind(a,'White');

if isempty(ind{1,1}) continue;
    
else indx = [indx; n]; end   

end

WM_id = indx; 

WM_id = sort(WM_id);

save('sub_02_wm_electrode','WM_id');







 
 
 
 
 
 

 
 
 