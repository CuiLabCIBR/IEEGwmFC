#!/bin/bash
#SBATCH --job-name=fmriprep
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu 8000
#SBATCH -p q_fat_c
#SBATCH --qos=high_c
#SBATCH -o /GPFS/cuizaixu_lab_permanent/xulongzhou/IEEG_DSI_connectome/MRIprep/workdir/job.%j.out
#SBATCH -e /GPFS/cuizaixu_lab_permanent/xulongzhou/IEEG_DSI_connectome/MRIprep/workdir/job.%j.error.txt
module load singularity/3.7.0
#!/bin/bash
#User inputs:
BidsDir=/GPFS/cuizaixu_lab_permanent/xulongzhou/IEEG_DSI_connectome/MRIprep/step_1_BIDS
wd=/GPFS/cuizaixu_lab_permanent/xulongzhou/IEEG_DSI_connectome/MRIprep/workdir
output=/GPFS/cuizaixu_lab_permanent/xulongzhou/IEEG_DSI_connectome/MRIprep/step_6_fmriprep
fs_license=/GPFS/cuizaixu_lab_permanent/xulongzhou/tool/freesurfer
subj=$1
nthreads=40
#Run fmriprep
echo ""
echo "Running fmriprep on participant: sub-$subj"
echo ""
#Run fmriprep
export SINGULARITYENV_TEMPLATEFLOW_HOME=/GPFS/cuizaixu_lab_permanent/xulongzhou/tool/cache_fmriprep/templateflow
unset PYTHONPATH; singularity run --cleanenv \
    -B $wd:/wd \
    -B $BidsDir:/BIDS \
    -B $output:/output \
    -B $fs_license:/fs_license \
    /usr/nzx-cluster/apps/fmriprep/singularity/fmriprep-20.2.1.simg \
    /BIDS \
    /output \
    participant \
    --participant_label sub-${subj} \
    -w /wd \
    --fs-license-file /fs_license/license.txt \
    --output-spaces T1w:res-2 MNI152NLin6Asym:res-2 MNI152NLin2009cAsym:res-2 \
    --return-all-components \
    --notrack --verbose \
    --skip-bids-validation \
    --debug all \
    --stop-on-first-crash \
    --use-syn-sdc \
    --resource-monitor \
    --cifti-output 91k
