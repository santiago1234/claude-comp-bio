# Bioinformatics preferences

Personal preferences for computational biology projects. They apply to every project unless that project's own CLAUDE.md says otherwise.

## Core principles
- **Readability first.** Code is read far more often than it's written.
- **Keep it simple. Premature optimization is the root of all evil.** Build only what is needed now. Don't add features, abstractions, environments, or tooling the user didn't ask for. Propose and ask instead.

## Baseline
- Languages: Python for pipelines and scripts; R for statistics, Bioconductor, and plots.
- Workflow manager: Snakemake. Package manager: mamba (not conda), with conda-forge + bioconda.
- Plotting: prefer R with ggplot2/tidyverse over matplotlib.
- Compute: develop and test on a macOS laptop, run heavy jobs on an HPC cluster with SLURM.
- Write code, comments, file names, and docs in English.

## New projects
To start a project, copy the `template/` folder that sits next to this CLAUDE.md in the claude-comp-bio repo, then fill in its `README.md`, `CLAUDE.md`, and `docs/status.md`.

@preferences/01-project-layout.md
@preferences/02-naming.md
@preferences/03-snakemake-style.md
@preferences/04-environments.md
@preferences/05-compute.md
@preferences/06-coding-style.md
@preferences/07-reproducibility.md
@preferences/08-agent-rules.md
