
%  clear; close all;
%seeg data


filepath = 'F:\WM_fMRI_iEEG_DSI\IEEG\IEEGprep\sub-0002\ieeg\awake\IEEGprep_common_average_reference\';

seegdataname = 'sub-0002_state-awake_ses-001_task-rest_run-001_common-average-reference_filtering-05-300_de-artifiact.mat';

SEEGdata = load([filepath seegdataname]);

label_name = SEEGdata.data_common_average_rereference.label;

data0 = SEEGdata.data_common_average_rereference.trial;
data1 = data0{1,1};
figure,plot(data1(1,:));

%loc data

chan_locname = 'F:\WM_fMRI_iEEG_DSI\report\electrodes\sub-0002_3mm.tsv';

elenode = tdfread(chan_locname);

for n=1:size(label_name,1)
    
   tm1=label_name{n};
   
   new_loc{n,1}=tm1;
  
   for k=1:size(elenode.Channel,1)
       
    tm2=elenode.Channel(k,:);

    tm2(find(isspace(tm2))) = []; 
    
    ind2 =  strcmp(tm1,tm2);

     if (ind2) break;
       
     else continue; 
%          
     end
     
   end 
     
      new_loc{n,2}=elenode.ASEG(k,:);
      new_loc{n,3}=elenode.MNI(k,:);  
    
end

save('sub_02_reloc_for_CAR.mat','new_loc');






