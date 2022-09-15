
%% step2: extraction the ROI timecourse based on the above;

clear; close all;

boldname = 'sub-0002_ses-001_task-rest_run-1_space-MNI152NLin2009cAsym_desc-residual_res-2_bold.nii.gz';
 
filepath = 'F:\WM_fMRI_iEEG_DSI\MRI\DATA_xcpdprep_output\sub-0002\xcp_d\sub-0002\ses-001\func\'; 

nii = load_nii([filepath boldname]);

fmri4d = nii.img; 

[s1, s2, s3, s4] = size(fmri4d);

fmri3d = squeeze(fmri4d(:,:,:,1));

image = spm_vol([filepath boldname]);

trans_matrix = image(1).mat;

load('sub_02-mni2matlab.mat');

for n = 1:size(matlab_xyz,1)
    
    x = matlab_xyz(n,1);
    
    y = matlab_xyz(n,2);
    
    z = matlab_xyz(n,3);
    
    clear kernel_image;
    
    clear cimage;
    
    kernel_image = zeros(size(fmri3d));
    
    kernel_image(x,y,z) = 1;
    
    cimage = dilation3D18_forICA(kernel_image);
    
    ind1 = find(cimage==1);
    
    for m=1:length(ind1)
        
        [X(m),Y(m),Z(m)] = ind2sub(size(fmri3d),ind1(m));
        
        dynam = squeeze(fmri4d(X(m),Y(m),Z(m),:));
        
        dynam_M(m,:) = dynam;
        
    end
    
    dynam_M(all(dynam_M==0,2),:) = [];
    
    dynam_M(all(isnan(dynam_M),2),:) = [];
    
    ROI_mean_ts(n,:)=mean(dynam_M,1);
     
end

ROI_mean_ts_allsubs = ROI_mean_ts(:,6:end);

save('sub_02_ts_ROI_bold_dilation3D18_2009.mat','ROI_mean_ts_allsubs');

