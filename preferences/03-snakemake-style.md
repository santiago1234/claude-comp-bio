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

## 11. `rule all`, `expand()`, and includes
- `rule all` is the first rule, right after the header.
- It has only named `input:`. No `output:`, `shell:`, or `log:`. Real work goes in its own rule.
- Its targets are the final outputs in `RESULTS`, not scratch intermediates or logs.
- Use `expand()` with an f-string and double braces. Don't concatenate strings:
  ```python
  rule all:
      input:
          ibd = expand(f"{RESULTS}/ibd/mex.chr{{chrn}}.ibd.gz", chrn = CHROMS),
          hbd = expand(f"{RESULTS}/ibd/mex.chr{{chrn}}.hbd.gz", chrn = CHROMS),


  include: "rules/common.smk"
  include: "rules/prepare_data.smk"
  include: "rules/ibd.smk"
  ```
- Put the `include:` lines right after `rule all`, with `rules/common.smk` always first.
- If the target list grows past about 5 entries, move it into `get_final_targets()` in `common.smk`.

## 12. Formatting and linting
- Don't use `snakefmt`. It strips the spaces around `=` and the column alignment from point 1. Format by hand following this guide.
- Run `snakemake --lint` when a workflow is finished or before an important commit, and fix what it reports. If a lint warning contradicts this guide, the guide wins.
- Before running, check in this order: `--lint`, then `-n`, then the real run.

## 13. Readability details
- Use a fixed directive order in every rule:
  docstring, `input`, `output`, `log`, `benchmark`, `params`, `threads`, `resources`, `conda`, `shell`.
- Leave two blank lines between rules.
- Always use double quotes. Use triple double quotes for docstrings and `shell:`.
- Add a trailing comma after every entry in `input`, `output`, `params`, and `resources`, so git diffs stay clean.
- File split:
  - Small workflow (about 5 rules or fewer): everything in the `Snakefile`.
  - Larger workflow: the `Snakefile` holds only the header, `rule all`, and the `include:` lines. Rules go in `rules/<step>.smk` and helper functions in `rules/common.smk`.
- Comment only where it adds something: why a parameter has its value, a resource calibration, or an unusual format. Don't comment the obvious.
