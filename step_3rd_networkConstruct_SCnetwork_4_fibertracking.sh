#!/bin/bash
# step 3 fiber tracking https://dsi-studio.labsolver.org/doc/cli_t3.html

workpath=/mnt/e/WMseegBoldFCanalysis/DSIprocessing
cd $workpath
#  
for subj in 0001 0002 0008 0009 0010 0011 0012 0013 0014 0015 0016 0017 0020 0021 0022 0023
do

echo ""
echo "Running dsistudio on participant: sub-$subj"
echo ""
subj_ID=sub-$subj;

# run fiber tracking
stepsize=0.5 #0.1 0.2 0.5 1 2
talg=0
turning_angle=90
#fib file
fib_fd=dsistudio_gqi_SRC_recon/$subj_ID
fib=$fib_fd/${subj_ID}_*odf.gqi.1.25.fib.gz
#output
mkdir dsistudio_fibertracking
output_subfolder=dsistudio_fibertracking/$subj_ID
mkdir $output_subfolder
output_fibertracking=$output_subfolder/stepsize05_tracking0_angle90_2_350_200000
mkdir $output_fibertracking
#roi file
roi_fd=elec_atlas/$subj_ID/anat
roi=$roi_fd/${subj_ID}_dsispace_ROI.nii
#t1t2file
t1w_fd=DATA_qsiprep_output/$subj_ID/qsiprep/$subj_ID/ses-001/dwi
t1=$t1w_fd/${subj_ID}_ses-001*_space-T1w_desc-preproc_dwi.nii.gz
#Run dsistudio reconstruction
dsi_studio --action=trk --source=$fib \
--fiber_count=2000000 \
--fa_threshold=0 \
--turning_angle=$turning_angle \
--step_size=$stepsize \
--min_length=2 \
--max_length=350 \
--method=$talg \
--otsu_threshold=0.6 \
--connectivity=${roi} \
--connectivity_threshold=0 \
--connectivity_type=pass \
--connectivity_value=count,ncount,mean_length,qa,trk \
--output=$output_fibertracking/ > $output_fibertracking/${subj_ID}_fibertrack_out.txt
done
