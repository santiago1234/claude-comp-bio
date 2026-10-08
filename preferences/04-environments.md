# 04 — Environments

**Principle: premature optimization is the root of all evil.** The user decides environments based on what is being built. Don't create, split, or install envs proactively. Propose and ask.

## Default: one env per workflow, activated by hand
- Each workflow has a single env file: `workflows/<name>/envs/<name>.yaml`.
- The user activates it before running: `mamba activate <name>`, then `snakemake ...`.
- Rules don't carry a `conda:` directive, and profiles don't set `software-deployment-method: conda`.
- Experiments reuse a workflow's env, or the project-wide `envs/`, whenever possible. An experiment gets its own `envs/` only if it really needs one.

## Exception: per-rule envs (only when the user asks)
Use per-rule envs only in specific cases, such as tools with incompatible dependencies. Then:
- Rules use `conda: "../envs/<tool>.yaml"`.
- Profiles add `software-deployment-method: conda`.

## Tooling
- Use `mamba`, not `conda`, for creating, installing, and activating: `mamba env create -f envs/<name>.yaml`.
- Channels: `conda-forge` then `bioconda`, with `channel_priority: strict`. Never use `defaults`.

## Env files
```yaml
name: ibd-detect
channels:
  - conda-forge
  - bioconda
dependencies:
  - python=3.12
  - snakemake=9
  - bcftools=1.21
  - pandas
```
- Pin versions of the main tools only. Leave the rest unpinned.
- Get R packages from conda (`r-tidyverse`, `bioconductor-*`). Never call `install.packages()` inside scripts.
- Use `pip:` (inside the same yaml) only for packages that don't exist on conda.
- To freeze the exact state of an important run, export it if the user asks: `mamba env export > envs/<name>.lock.yaml`.

## Tools not on conda
Put the binary or repo in the workflow's `bin/` and its path in the config (`hap_ibd_jar: "bin/hap-ibd.jar"`). Record in `bin/README.md` where each one came from, its version, and the download date.
