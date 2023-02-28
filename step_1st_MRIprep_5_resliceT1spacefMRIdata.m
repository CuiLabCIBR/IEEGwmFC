clc; clear; close all;
addpath('H:\project_manger\xlz_toolbox\toolbox\spm12');
% reslice the MRI file
xcpdPath = 'Z:\WM_BOLD_SEEG_DSI_huangyali\MRI\DATA_xcpdprep_output';
% the fMRI dir
subjDir = dir(fullfile(xcpdPath, 'sub*'));
for SS = 1:length(subjDir)
    subjID = subjDir(SS).name;
    fMRIDir = dir(fullfile(xcpdPath, subjID, '**', [subjID, '*space-T1w_desc-residual_bold.nii*']));
    voxsiz = [2 2 2]; % new voxel size {mm}
    V = spm_vol(fullfile(fMRIDir.folder, fMRIDir.name));
    for i=1:numel(V)
        bb = spm_get_bbox(V(i));
        VV(1:2)   = V(i);
        VV(1).mat = spm_matrix([bb(1,:) 0 0 0 voxsiz])*spm_matrix([-1 -1 -1]);
        VV(1).dim = ceil(VV(1).mat \ [bb(2,:) 1]' - 0.1)';
        VV(1).dim = VV(1).dim(1:3);
        spm_reslice(VV, struct('mean', false, 'which', 1, 'interp', 0)); % 1 for linear
    end
end