# <project-name>

One paragraph: what question this project answers.

## Layout
- `data/raw/`: original inputs (read-only). See `data/README.md`.
- `data/resources/`: references, annotations, sample metadata.
- `data/generated/`: in-project data that act as inputs, not results.
- `workflows/`: reusable Snakemake pipelines.
- `experiments/YYMMDD-keywords/`: dated analyses, each run with `bash runall.sh`.
- `results/`: curated key outputs (may be a symlink to a NAS).
- `docs/status.md`: current state. `docs/notebook.md`: dated lab notebook.
- `profiles/`: Snakemake profiles (`local`, `slurm`).

## Setup
    ln -s <scratch-dir>/<project> scratch
    ln -s <persistent-results-dir> results
