# 01 — Project layout

Based on Noble 2009, adapted for Snakemake. Rationale and sources: `references/papers.md`.

## Structure

```
project/
├── README.md                 # what the project is, how to navigate it
├── CLAUDE.md                 # project-specific context (overrides these prefs)
├── data/
│   ├── raw/                  # original inputs, READ-ONLY, never modified
│   ├── resources/            # references, annotations, sample metadata
│   ├── generated/            # data produced in-project that are inputs, not results
│   └── README.md             # source, download date, checksums for each dataset
├── workflows/                # reusable pipelines (no date)
│   └── <workflow-name>/
│       ├── README.md
│       ├── Snakefile
│       ├── rules/  envs/  src/  config/
├── experiments/              # dated analyses, each answers one question
│   └── YYMMDD-keywords/
│       ├── README.md         # goal, how to run, conclusion
│       ├── runall.sh         # Noble's driver script: the user runs it by hand
│       ├── Snakefile         # OPTIONAL; may `module` a workflow
│       ├── config.yaml
│       ├── src/              # scripts specific to this experiment
│       ├── envs/             # OPTIONAL, only if it needs its own env
│       └── results/          # local outputs (gitignored)
├── results/                  # curated key outputs (may be a symlink to a NAS)
├── docs/
│   ├── status.md             # current project state, updated by Claude each session
│   └── notebook.md           # dated lab notebook (history)
├── envs/                     # project-wide shared mamba envs
├── profiles/                 # snakemake profiles: local/, slurm/
└── scratch -> <scratch dir>  # symlink, gitignored (see 05-compute.md)
```

## Rules

- **Experiment folders** are named `YYMMDD-keywords`: a 6-digit date, a hyphen, then short kebab-case keywords (`261007-deseq2-tumor-vs-normal`). Use the date the experiment starts.
- **Every experiment has a `runall.sh`**, Noble's driver script. The user runs it by hand from the terminal (`bash runall.sh`). It runs the whole analysis in order, whether by calling Snakemake or the scripts directly. It must be very readable (see 06-coding-style.md).
- **Workflows and experiments have the same internal shape** (README, Snakefile, src, envs, results). A workflow is reusable and undated. An experiment is dated and answers one question.
- **Promote to `workflows/`**: when code from one experiment gets reused in another, move it to `workflows/` and call it with Snakemake's `module` directive. Do not copy-paste it.
- **`data/raw/` is read-only.** Never write, rename, or delete anything in it. Record provenance and checksums in `data/README.md`.
- **Where outputs go**: a workflow writes to `RESULTS`, the `results:` key of the run's config (often outside the repo). The experiment's own scripts, called from `runall.sh`, write small outputs to the experiment's local `results/`.
- **`data/` vs `results/`**: `data/generated/` holds things produced in-project that act as inputs (a filtered annotation, a custom index, a derived metadata table). `results/` holds findings.
- **Top-level `results/` is curated by the user.** It may live elsewhere, such as a NAS, through a symlink. Don't promote anything to it unless asked. When you do, use the experiment's folder name so the provenance is obvious, and never hand-edit what's inside.
- **Environment lookup order**: the experiment's `envs/` (if any), then the workflow's `envs/`, then the project-wide `envs/`.
- **Every experiment ends with an entry in `docs/notebook.md`** linking to its folder (see 07-reproducibility.md).
- Heavy intermediates go to `scratch/`, not to `results/`.

## Git

Commit: code, configs, envs, READMEs, docs, and small metadata in `data/resources/`.
Ignore: `data/raw/`, `data/generated/`, every `results/`, `scratch/`, `.snakemake/`.
