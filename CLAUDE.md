# Bioinformatics preferences

Personal preferences for computational biology projects. They apply to every project unless that project's own CLAUDE.md says otherwise.

## Core principles
- **Readability first.** Code is read far more often than it's written.
- **Keep it simple. Premature optimization is the root of all evil.** Build only what is needed now. Don't add features, abstractions, environments, or tooling the user didn't ask for. Propose and ask instead.

## Baseline
- Languages: Python for pipelines, scripts, and plots; R only for statistics or Bioconductor, when really needed.
- Workflow manager: Snakemake. Package manager: mamba (not conda), with conda-forge + bioconda.
- Plotting: matplotlib by default, so envs don't need R installed. Use R with ggplot2 only if the user asks.
- Compute: develop and test on a macOS laptop, run heavy jobs on an HPC cluster with SLURM.
- Write code, comments, file names, and docs in English.

## New projects
To start a project, copy the `template/` folder that sits next to this CLAUDE.md in the claude-comp-bio repo, then fill in its `README.md`, `CLAUDE.md`, and `docs/status.md`.

@preferences/01_project_layout.md
@preferences/02_naming.md
@preferences/03_snakemake_style.md
@preferences/04_environments.md
@preferences/05_compute.md
@preferences/06_coding_style.md
@preferences/07_reproducibility.md
@preferences/08_agent_rules.md
