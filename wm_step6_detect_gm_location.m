clear; 

close all;

set(0,'defaultfigurecolor','w');

load('sub_02_reloc_for_CAR.mat');

LegendStr = new_loc(:,2);

indx = [];

for n=1:size(LegendStr,1)

a=LegendStr(n,:);

ind = strfind(a,'Cortex');

if isempty(ind{1,1}) continue;
    
else indx = [indx; n]; end   

end

GM_id = indx; 

GM_id = sort(GM_id);

save('sub_02_gm_electrode','GM_id');







 
 
 
 
 
 

 
 
 