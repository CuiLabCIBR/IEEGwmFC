%% step1: transfer MNI coordination to matlab;

clear; close all;
% 
% spmdir = '/GPFS/cuizaixu_lab_permanent/huangyali/MatlabToolBox/spm_d';
% addpath(genpath(spmdir));

% boldpath = '/GPFS/cuizaixu_lab_permanent/xulongzhou/DSI_IEEG/DSIprep/fMRIprep/sub-0002/fmriprep/sub-0002/ses-001/func/';
%  boldname = 'sub-0002_ses-001_task-rest_run-1_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz';

%  boldname = 'sub-0018_ses-001_task-rest_run-1_space-MNI152NLin6Asym_desc-residual_bold.nii.gz';

filepath = 'F:\WM_fMRI_iEEG_DSI\MRI\DATA_xcpdprep_output\sub-0002\xcp_d\sub-0002\ses-001\func\'; 
boldname = 'sub-0002_ses-001_task-rest_run-1_space-MNI152NLin2009cAsym_desc-residual_res-2_bold.nii.gz';

nii = load_nii([filepath boldname]);

fmri4d = nii.img; 

[s1, s2, s3, s4] = size(fmri4d);

fmri3d = squeeze(fmri4d(:,:,:,1));

image = spm_vol([filepath boldname]);

trans_matrix = image(1).mat;

load('sub_02_reloc_for_CAR.mat');


MNI_str = new_loc(:,3);

% 
% MNI_str = elecnode.MNI;

for n = 1:size(MNI_str,1)

tn = MNI_str{n,:};

MNI_coordinate = round(str2num(tn));

MNI = [MNI_coordinate';1];

matlab_coordinate = inv(trans_matrix)*MNI;

mt_cor = round(matlab_coordinate);

matlab_xyz(n,:)=mt_cor(1:3);

end

%%%% after transfermation, get rid of the 10

save('sub_02-mni2matlab.mat','matlab_xyz');



