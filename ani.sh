#!/bin/bash
echo "Please enter required inputs."

read -p "Enter path to Half-map A (with .mrc): " HALF1

read -p "Enter path to Half-map B (with .mrc): " HALF2

read -p "Enter path to Mask file (with .mrc): " MASK

read -p "Enter project name (will be used as output folder name): " PROJECT

read -p "Enter training resolution limit in Å (leave blank for default of 3.5 Å): " LIMIT_RES
LIMIT_RES=${LIMIT_RES:-3.5}

# Path to the main pipeline script
PIPELINE_SCRIPT="/vast/scratch/users/$USER/spIsoNet/jobscript.sh"

# Call the main script with provided arguments
sbatch "$PIPELINE_SCRIPT" "$HALF1" "$HALF2" "$MASK" "$PROJECT" "$LIMIT_RES"
