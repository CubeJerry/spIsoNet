#!/bin/bash
#SBATCH --job-name=spisonet_install
#SBATCH --partition=regular
#SBATCH --time=01:00:00
#SBATCH --mem=16G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4

# Load micromamba module
module load micromamba

# Set micromamba root to scratch
export MAMBA_ROOT_PREFIX="${MAMBA_ROOT_PREFIX:-/vast/scratch/users/$USER/.micromamba}"
mkdir -p "$MAMBA_ROOT_PREFIX"

# Create micromamba environment from spIsoNet setup.yml
ENV_NAME="spisonet"
SCRATCH_ROOT="/vast/scratch/users/$USER"
cd "$SCRATCH_ROOT"
[ -d spIsoNet ] || git clone https://github.com/CubeJerry/spIsoNet.git
cd spIsoNet

micromamba env create -f setup.yml -p "$MAMBA_ROOT_PREFIX/$ENV_NAME" -y
micromamba activate "$MAMBA_ROOT_PREFIX/$ENV_NAME"

# Set environment variables for Misalignment Correction
export RELION_EXTERNAL_RECONSTRUCT_EXECUTABLE="python $SCRATCH_ROOT/spIsoNet/spIsoNet/bin/relion_wrapper.py"
export CONDA_ENV="$ENV_NAME"

echo "spIsoNet installed in $MAMBA_ROOT_PREFIX/$ENV_NAME and environment variables set."
