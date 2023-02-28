#!/bin/bash
# step-1 creat the SRC file
# user manual https://dsi-studio.labsolver.org/doc/cli_t1.html
for subj in {0001..0112}
do

echo ""
echo "Running dsistudio on participant: sub-$subj"
echo ""
subj_ID=sub-$subj;

# step 1 : generate src file
# dwi file
dwi_file_path=step_4_dsiprep/qsiprep/$subj_ID/ses-001/dwi
dwi_file=$dwi_file_path/${subj_ID}_ses-001*_space-T1w_desc-preproc_dwi.nii.gz
bval_file=$dwi_file_path/${subj_ID}_ses-001*_space-T1w_desc-preproc_dwi.bval
bvec_file=$dwi_file_path/${subj_ID}_ses-001*_space-T1w_desc-preproc_dwi.bvec
# output folder
mkdir step_6_dsistudio_gqi
mkdir step_6_dsistudio_gqi/$subj_ID
output_folder=step_6_dsistudio_gqi/$subj_ID
output_src_file=$output_folder/${subj_ID}_ses-001_space-T1w_desc-preproc_dwigqi.src.gz
#Run dsistudio 
dsi_studio --action=src --source=$dwi_file \
--bval=$bval_file --bvec=$bvec_file \
--output=$output_src_file

# step 2 : reconstruction
#src file
src_file=$output_src_file
#Run dsistudio reconstruction
dsi_studio --action=rec --source=$src_file \
--method=4 --param0=1.25 --align_acpc=0 --check_btable=1 --record_odf=1 \
--odf_order=8 --num_fiber=5 --output=$output_folder

done
