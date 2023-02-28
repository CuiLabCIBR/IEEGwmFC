#!/bin/bash
#SBATCH --job-name=dsiprep
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=8G
#SBATCH -p q_cn
module pruge
module load singularity/3.7.0
#User inputs:
subj=$1
bids=/GPFS/cuizaixu_lab_permanent/xulongzhou/IEEG_DSI_connectome/MRIprep/DATA_BIDS
fs_input=/GPFS/cuizaixu_lab_permanent/xulongzhou/IEEG_DSI_connectome/MRIprep/DATA_freesurfer
fs_license=/GPFS/cuizaixu_lab_permanent/xulongzhou/IEEG_DSI_connectome/code/freesurfer
workpath=/GPFS/cuizaixu_lab_permanent/xulongzhou/IEEG_DSI_connectome/MRIprep/DATA_dsiprep_work
output=/GPFS/cuizaixu_lab_permanent/xulongzhou/IEEG_DSI_connectome/MRIprep/DATA_dsiprep_qsiprep0160rc3
#Make directory
if [ ! -d $output ]; then
    mkdir $output
fi
if [ ! -d $workpath ]; then
    mkdir $workpath
fi
#Run dsiprep using qsiprep
echo " "
echo "Running dsiprep using qsiprep on participant: sub-$subj"
echo " "
export SINGULARITYENV_TEMPLATEFLOW_HOME=/home/cuizaixu_lab/xulongzhou/.cache/templateflow
unset PYTHONPATH;
singularity run --cleanenv \
    -B $bids:/bids \
    -B $fs_license:/freesurfer_license \
    -B $fs_input:/freesurfer_input \
    -B $output:/output_path \
    -B $workpath:/work_path \
    /home/cuizaixu_lab/xulongzhou/.singularity/qsiprep-0.16.0RC3.sif \
    /bids \
    /output_path \
    -w /work_path \
    participant \
    --participant_label sub-${subj} \
    --nthreads 4 \
    --mem-mb 32000 \
    --fs-license-file /freesurfer_license/license.txt \
    --skip_bids_validation \
    --notrack \
    --output_resolution 2 \
    --denoise-method dwidenoise \
    --unringing-method mrdegibbs \
    --hmc_model 3dSHORE \
    --freesurfer-input /freesurfer_input \
    --recon-input /output/qsiprep \
    --recon_spec dsi_studio_gqi
