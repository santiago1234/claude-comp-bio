# 03 — Snakemake style

**Guiding principles: readability first, keep it simple.** Don't add Snakemake features nobody asked for.

## Canonical example

Every Snakefile and rule must look like this:

```python
from snakemake.utils import min_version
min_version("9.0")

configfile: "config/config.yaml"

SCRATCH  = config["scratch"]
RESULTS  = config["results"]
CHROMS   = config["chroms"]
HAP_IBD  = config["hap_ibd_jar"]

wildcard_constraints:
    chrn   = r"\d+|X|Y",
    sample = r"[A-Za-z0-9_]+",

localrules: all, freeze_samples


rule freeze_vcf:
    """
    VCF containing both query and reference samples.
    """
    input:
        vcf     = config["vcf"],
        samples = f"{SCRATCH}/freeze_samples.txt",
    output:
        vcf = temp(f"{SCRATCH}/vcf/freeze_chr{{chrn}}.vcf.gz"),
    log:
        f"{SCRATCH}/logs/freeze_vcf/chr{{chrn}}.log"
    benchmark:
        f"{SCRATCH}/logs/freeze_vcf/chr{{chrn}}.benchmark.tsv"
    threads: 4
    resources:
        mem_mb  = 8000,     # calibrated from benchmark: max_rss ~ 5 GB
        runtime = 120,      # minutes
    conda:
        "../envs/bcftools.yaml"
    shell:
        """
        bcftools view \
            --threads {threads} \
            -S {input.samples} \
            {input.vcf} \
            -Oz -o {output.vcf} 2> {log}
        """
```

## 0. Snakefile header
Use this order: `min_version`, then `configfile:`, then **UPPERCASE constants** read from the config, then `wildcard_constraints:`, then `localrules:`.
- The scratch and results directories are always called `SCRATCH` and `RESULTS` (config keys `scratch:` and `results:`). Never `RESDIR`, `OUTDIR`, etc.
- Build paths with f-strings on those constants. Escape wildcards with double braces: `f"{SCRATCH}/vcf/chr{{chrn}}.vcf.gz"`.

## 1. Named inputs and outputs, readable assignments
- Every `input:`, `output:`, and `params:` entry is named. Never use positional access (`output[0]`).
- Put spaces around `=` and **align the `=` in a column** within a block.
- Every rule except `all` has a docstring saying what it produces.

## 2. Logs and benchmarks
- Every rule has `log:` and `benchmark:`, except trivial ones (`cp`, `touch`, a small `cat`).
- Both live in the same folder under scratch, `{SCRATCH}/logs/<rule_name>/`:
  - log: `<wildcards>.log`
  - benchmark: `<wildcards>.benchmark.tsv`
- Redirect the tool's stderr to the log (`2> {log}`).
- Use benchmarks to calibrate `resources`.

## 3. Nothing hard-coded
- Every path, binary, threshold, and list goes in the config. No absolute paths in the Snakefile or rules.
- Comment every config key: what it is, plus units or format.
- A workflow ships example and test configs in `workflows/<name>/config/`, always including a small `test.yaml`. **Configs for real runs live in the experiment folder** that runs the workflow, passed with `--configfile` or `module ... config:`.
- Read required keys (`scratch`, `results`, inputs) with `config["key"]` so a missing one fails loudly. Use `config.get("key", default)` only for optional parameters.
- Sample lists:
  - `.txt` with one ID per line and no header, when a tool consumes the list directly (`bcftools -S`).
  - `.tsv` with a header (`sample`, `population`, `fq1`...), loaded with pandas, when there is metadata or one file per sample.

## 4. Input functions
- A one-line lookup can be an inline lambda: `vcf = lambda wc: config["vcfs"][wc.cohort],`.
- Anything with logic goes in a named function with a docstring, in `rules/common.smk`:
  ```python
  def get_query_samples(wildcards):
      """Return the sample list file for a given cohort."""
      ...
  ```

## 5. Execution: always `shell:`
- Call CLI tools directly in `shell:`.
- Call your own scripts as CLIs from `shell:` with **named arguments**, parsed with `argparse`:
  ```python
  shell:
      """
      python src/global_ancestry.py \
          --beds {input.beds} \
          --out {output.csv} 2> {log}
      """
  ```
- Don't use `script:` or `run:`.
- Use triple-quoted, multi-line `shell:` with one option per line.

## 6. No wrappers
Don't use `wrapper:`. Write a visible `shell:` command with its own env in `envs/`. Use a wrapper only if the user explicitly asks for one.

## 7. `temp()`, `protected()`, `directory()`
- Never wrap anything in `RESULTS` with `temp()`.
- Use `temp()` only for large intermediates in `SCRATCH` that are cheap to regenerate (per-chromosome filtered VCFs, unsorted BAMs, chunks). Small or expensive intermediates stay in scratch without `temp()` so they can be inspected.
- To debug, run with `--notemp`.
- Use `protected()` for expensive outputs (hours of compute, or paper results).
- `directory()` is mandatory when an output is a folder.

## 8. Threads and resources
- Heavy rules declare `threads`, `mem_mb`, and `runtime` (in minutes). Use only these standard names, never `mem_gb`.
- The command uses `{threads}` and values derived from `resources` (e.g. `-Xmx` via `params`), never hard-coded numbers:
  ```python
  params:
      xmx = lambda wc, resources: int(resources.mem_mb * 0.8),
  ```
- Put trivial rules in `localrules:`. They take their defaults from the profile.
- Add a comment with the calibration taken from the benchmark.
- Use dynamic resources (`attempt`) and `retries:` only if the user asks.

## 9. Version and profiles
- Snakemake 9+ with `snakemake-executor-plugin-slurm`, and `min_version("9.0")` at the top.
- Keep two profiles in the project's `profiles/` directory:
  ```yaml
  # profiles/slurm/config.yaml
  executor: slurm
  jobs: 50
  software-deployment-method: conda
  default-resources:
    mem_mb: 4000
    runtime: 60
    slurm_partition: "<TODO>"   # see 05-compute.md
  latency-wait: 60
  rerun-incomplete: true
  printshellcmds: true
  ```
  ```yaml
  # profiles/local/config.yaml
  cores: 4
  software-deployment-method: conda
  printshellcmds: true
  ```
- Always do a dry run (`-n`) before a real run:
  ```bash
  snakemake --profile profiles/local --configfile config/test.yaml -n
  snakemake --profile profiles/slurm --configfile config.yaml
  ```

## 10. Wildcard constraints
- Use one global `wildcard_constraints:` block in the header, covering **every wildcard** the workflow uses.
- No per-rule constraints unless they're needed.
- Patterns mirror the naming rules in 02-naming.md (e.g. `sample = r"[A-Za-z0-9_]+"`).

## TODO (still to be decided)
- 11. Placement of `rule all` and use of `expand()`.
- 12. Formatting and linting (`snakefmt` would strip the spaces around `=`; `snakemake --lint`).
- 13. Other readability details: directive order, blank lines between rules, file split (`rules/*.smk`).
