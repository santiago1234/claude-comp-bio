# 02 — Naming

## General
- No spaces, accents, or special characters in any name.
- Code files use `snake_case`: `plot_volcano.py`, `run_deseq2.R`. Python can't import hyphenated modules.
- Folders, workflows, and env names also use `snake_case`: `workflows/rnaseq_align/`, env `rnaseq_align`.
- Never use hyphens in names we create. The only exception is the hyphen after the date in experiment folders (`261007-ibd_mexico`).
- Dated experiment folders use `YYMMDD-keywords` (see 01_project_layout.md).

## Data files
- Chain processing steps with dots, so the name tells you what happened to the file:
  `{sample}.trimmed.fastq.gz`, `{sample}.sorted.dedup.bam`, `{sample}.counts.tsv`.
- Keep standard extensions (`.fastq.gz`, `.bam`, `.vcf.gz`, `.tsv`, `.parquet`, `.h5ad`, `.rds`).
- Prefer `.tsv` over `.csv` for tabular data.

## Sample IDs
- Only `[A-Za-z0-9_]`, with no hyphens or dots: `tumor_rep1`, not `tumor-rep.1`.
  This keeps Snakemake wildcards unambiguous.
- Sample IDs are defined once, in the samples sheet. Never hard-code them.

## Scripts
- No numeric order prefixes. The Snakefile defines execution order.
- Name scripts with a verb plus an object: `filter_cells.py`, `plot_pca.py`.

## Dates
- Use the `YYMMDD-` prefix only for experiment folders. Files inside a dated folder don't need a date.
- Inside file contents and logs, write full ISO dates (`2026-10-07`).

## Snakemake rules
- `snake_case` verb plus object: `trim_reads`, `align_reads`, `count_features`.
- Rule files in `rules/` are named by step or topic: `qc.smk`, `align.smk`.
