#!/bin/bash
#SBATCH --job-name=huangyali_xcpd
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu 2000
#SBATCH -p lab_fat
#SBATCH -o /GPFS/cuizaixu_lab_permanent/xulongzhou/IEEG_DSI_connectome/WM_fMRI_iEEG_DSI/report/MRIprep_report/xcpdprep/job.%j.out
#SBATCH -e /GPFS/cuizaixu_lab_permanent/xulongzhou/IEEG_DSI_connectome/WM_fMRI_iEEG_DSI/report/MRIprep_report/xcpdprep/job.%j.error.txt


module pruge
module load singularity
#User inputs:

subj=$1
xcpdprep_output=/GPFS/cuizaixu_lab_permanent/xulongzhou/IEEG_DSI_connectome/WM_fMRI_iEEG_DSI/MRI/DATA_xcpdprep_output
xcpdprep_work=/GPFS/cuizaixu_lab_permanent/xulongzhou/IEEG_DSI_connectome/WM_fMRI_iEEG_DSI/MRI/DATA_xcpdprep_work
fs_license=/GPFS/cuizaixu_lab_permanent/xulongzhou/IEEG_DSI_connectome/code/freesurfer
fmriprep_output=/GPFS/cuizaixu_lab_permanent/xulongzhou/IEEG_DSI_connectome/WM_fMRI_iEEG_DSI/MRI/DATA_fMRIprep_output

#Run xcpd
echo ""
echo "Running xcpd on participant: sub-$subj"
echo "fmriprep_filepa: $fmriprep_output/sub-$subj/fmriprep"
echo ""

#Make fmriprep directory and participant directory in derivatives folder
if [ ! -d $xcpdprep_output ]; then
    mkdir $xcpdprep_output
fi

if [ ! -d $xcpdprep_output/sub-${subj} ]; then
    mkdir $xcpdprep_output/sub-${subj}
fi

if [ ! -d $xcpdprep_work ]; then
    mkdir $xcpdprep_work
fi

if [ ! -d $xdprep_work/sub-${subj} ]; then
    mkdir $xcpdprep_work/sub-${subj}
fi

# run xcp_d
export SINGULARITYENV_TEMPLATEFLOW_HOME=/GPFS/cuizaixu_lab_permanent/xulongzhou/tool/cache_fmriprep/templateflow
unset PYTHONPATH;singularity run --cleanenv \
	-B $fmriprep_output/sub-${subj}/fmriprep:/fmriprep \
	-B $xcpdprep_output/sub-${subj}:/out \
    	-B $xcpdprep_work/sub-${subj}:/work \
    	/GPFS/cuizaixu_lab_permanent/xulongzhou/apps/xcp_d.sif \
    	/fmriprep \
    	/out \
    	-w /work \
    	--participant_label sub-${subj} \
    	-t rest \
    	-p 24P \
    	--lower-bpf 0.01 \
    	--upper-bpf 0.2

