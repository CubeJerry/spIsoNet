#!/bin/bash
#SBATCH --job-name=spisonet_pipeline
#SBATCH --partition=gpuq
#SBATCH --gres=gpu:A30:1
#SBATCH --time=12:00:00
#SBATCH --mem=10G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8

module load micromamba

export MAMBA_ROOT_PREFIX="${MAMBA_ROOT_PREFIX:-/vast/scratch/users/$USER/.micromamba}"
ENV_NAME="spisonet"
SCRATCH_ROOT="/vast/scratch/users/$USER"

eval "$(micromamba shell hook --shell bash)"
micromamba activate "$MAMBA_ROOT_PREFIX/$ENV_NAME"

export RELION_EXTERNAL_RECONSTRUCT_EXECUTABLE="python $SCRATCH_ROOT/spIsoNet/spIsoNet/bin/relion_wrapper.py"
export CONDA_ENV="$ENV_NAME"

# Go to spIsoNet directory
cd "$SCRATCH_ROOT/spIsoNet"

# Arguments
HALF1="$1"           # Half-map A
HALF2="$2"           # Half-map B
MASK="$3"            # Mask file
PROJECT="$4"         # Project name (used for folder & FSC3D filename)
LIMIT_RES="${5:-3.5}" # Optional: resolution limit, default 3.5 Å


PROJECT_CLEAN="${PROJECT// /_}"

# Create output folder
OUTPUT_DIR="$SCRATCH_ROOT/$PROJECT_CLEAN"
mkdir -p "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR/independent"

# FSC3D output filename
FSC_OUT="$PROJECT_CLEAN.mrc"

# Step 1: 3DFSC calculation
python spIsoNet/bin/spisonet.py fsc3d \
    "$HALF1" \
    "$HALF2" \
    "$MASK" \
    --ncpus $SLURM_CPUS_PER_TASK \
    --limit_res "$LIMIT_RES" \
    --o "$OUTPUT_DIR/$FSC_OUT"

echo "3DFSC calculation completed: $OUTPUT_DIR/$FSC_OUT"

# Step 2: Anisotropy Correction (and independent training)
export CUDA_VISIBLE_DEVICES=0

python spIsoNet/bin/spisonet.py reconstruct \
    "$HALF1" "$HALF2" \
    --aniso_file "$OUTPUT_DIR/$FSC_OUT" \
    --mask "$MASK" \
    --limit_res "$LIMIT_RES" \
    --output_dir "$OUTPUT_DIR"

python spIsoNet/bin/spisonet.py reconstruct \
    "$HALF1" "$HALF2" \
    --aniso_file "$OUTPUT_DIR/$FSC_OUT" \
    --mask "$MASK" \
    --independent \
    --limit_res "$LIMIT_RES" \
    --output_dir "$OUTPUT_DIR/independent"

echo "Reconstruction completed: $OUTPUT_DIR"
