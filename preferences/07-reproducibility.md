# 07 — Reproducibility and documentation

## `docs/status.md`: current project state (Claude maintains it)
- **Read it at the start of every session** to know where the project stands.
- **Update it at the end of every session** (or after any meaningful progress) without being asked.
- It's a snapshot, not a history: rewrite it so it stays short (one screen). The history goes in `notebook.md`.

```markdown
# Status — <project>
_Last updated: 2026-10-07_

## Current focus
One or two lines on what is being worked on right now.

## Done recently
- 261007-ibd-mexico: hap-ibd run on chr1-22, results in data_vault.

## Next steps
1. Filter IBD segments < 4 cM.
2. ...

## Open questions / blockers
- Which genetic map for chrX?
```

## `docs/notebook.md`: dated lab notebook (history)
- Newest entry on top. Record failures too (Schnell 2015).
- At the end of anything meaningful (an experiment, a key decision), **Claude proposes the entry and the user approves** it before it's written.

```markdown
## 2026-10-07 · 261007-ibd-mexico
**Goal:** detect IBD segments in MXB with hap-ibd.
**Done:** ran ibd-detect workflow on chr1-22 (config in experiments/261007-ibd-mexico/).
**Result:** ~2.1M segments; results in /data/data_vault/.../261007-ibd-mexico/.
**Next:** filter segments < 4 cM, compare across populations.
```

## Experiment README
Every `experiments/YYMMDD-keywords/README.md` follows this template:
```markdown
# 261007-ibd-mexico
**Question:** ...
**How to run:** `snakemake --profile ../../profiles/slurm --configfile config.yaml`
**Inputs:** ...
**Outputs:** scratch: ... | results: ...
**Status / conclusion:** ...
```

## Results provenance
`RESULTS` usually lives outside the repo (e.g. data_vault). Each results folder gets a minimal `README.md` with:
- the experiment that produced it,
- the date,
- the git commit (`git rev-parse --short HEAD`).

That way any file found on the NAS can be traced back to its origin.

## Raw data
For every dataset, `data/README.md` records the source, the download date, and a checksum (`md5sum`).

## Exploratory notebooks
Jupyter, Quarto, or Rmd notebooks live inside the experiment that uses them. They never replace a pipeline step. If notebook code produces something that gets reused, turn that code into a script.
