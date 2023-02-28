#!/bin/bash
#`ls /mnt/nas/XWSEEGdataset/WM_BOLD_SEEG_DSI_huangyali/MRI/DATA_fMRIprep_output`
for subj in `ls /mnt/nas/XWSEEGdataset/WM_BOLD_SEEG_DSI_huangyali/MRI/DATA_fMRIprep_output`
do
fmriprep=/mnt/nas/XWSEEGdataset/WM_BOLD_SEEG_DSI_huangyali/MRI/DATA_fMRIprep_output/$subj/fmriprep
output=/mnt/nas/XWSEEGdataset/WM_BOLD_SEEG_DSI_huangyali/MRI/DATA_xcpd_24pglobalCSF_00102
mkdir $output
work=/mnt/nas/XWSEEGdataset/WM_BOLD_SEEG_DSI_huangyali/MRI/wd
mkdir $work
cc=/mnt/nas/XWSEEGdataset/WM_BOLD_SEEG_DSI_huangyali/MRI/DATA_confounds_globalCSF
#Run xcpd
echo ""
echo "Running xcpd on participant: $subj"
echo ""
# run xcp_d
unset PYTHONPATH;
docker run --rm -it \
	-v $fmriprep:/fmriprep:ro \
	-v $output:/output:rw \
    -v $work:/work:rw \
    -v $cc:/customc:ro \
    -v /mnt/h/project_manger/xlz_toolbox/toolbox/freesurfer:/fs_license:ro \
    -v /mnt/h/project_manger/xlz_toolbox/toolbox/templateflow:/templates:ro \
	pennlinc/xcp_d:0.0.9 \
    /fmriprep /output -w /work \
    --participant_label ${subj} \
    -t rest \
    -p 24P \
    -c /customc/${subj} \
    --lower-bpf 0.01 \
    --upper-bpf 0.2
done
#	
# 
