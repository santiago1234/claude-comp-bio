#!/usr/bin/env bash
# YYMMDD-example
# TODO: one or two lines on what this experiment does.
#
# Usage:  mamba activate TODO_ENV && bash runall.sh
set -euo pipefail

WORKFLOW="../../workflows/TODO_WORKFLOW"
CONFIG="config.yaml"
PROFILE="../../profiles/slurm"

# ---- Step 1: run the workflow ---------------------------------------
echo "[1/2] Running workflow..."
snakemake \
    --snakefile "${WORKFLOW}/Snakefile" \
    --configfile "${CONFIG}" \
    --profile "${PROFILE}"

# ---- Step 2: summarize results --------------------------------------
echo "[2/2] Summarizing..."
python src/TODO_SCRIPT.py \
    --input "TODO_INPUT" \
    --out "results/TODO_OUTPUT.tsv"

echo "Done."
