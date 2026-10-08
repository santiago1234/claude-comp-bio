# 06 — Coding style (Python and R)

Scripts are CLIs called from Snakemake `shell:` (see 03_snakemake_style.md, point 5). Each one must also run on its own.

## Python
- Follow PEP 8. Format with `ruff format` and check with `ruff check`. The aligned-`=` style is for Snakemake only, not Python.
- Script structure, in order:
  1. A module docstring saying what the script does.
  2. Imports: stdlib, then third-party, then local.
  3. Functions.
  4. `main()`, which parses arguments with `argparse` and runs the flow.
  5. `if __name__ == "__main__": main()`.
- No code at module level. Don't read `sys.argv` directly.
- Use named arguments (`--vcf`, `--out`), never positional ones.
- Add light type hints on function signatures: `def load_bed(path: Path) -> pd.DataFrame:`.
- Give every function a short docstring with Parameters and Returns.
- Use `pathlib.Path` for paths and `pandas` for tables.
- Plot with `matplotlib`. Save with `fig.savefig(args.out)`; never call `plt.show()` in a script.

```python
"""Compute global ancestry proportions from gnomix BED files."""
import argparse
from pathlib import Path

import pandas as pd


def compute_proportions(bed: pd.DataFrame) -> pd.DataFrame:
    """
    Compute per-sample ancestry proportions weighted by segment length.

    Parameters: bed with columns sample, ancestry, spos, epos.
    Returns: one row per sample, one column per ancestry.
    """
    ...


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--beds", type=Path, required=True, help="Directory with BED files")
    parser.add_argument("--out", type=Path, required=True, help="Output TSV")
    args = parser.parse_args()
    ...


if __name__ == "__main__":
    main()
```

## R
Use R only for statistics or Bioconductor, when really needed (it means installing R in the env). Plots default to matplotlib; use ggplot2 only if the user asks.
- Follow the tidyverse style guide. Use tidyverse for data wrangling.
- Use the native pipe `|>`, not `%>%`.
- Parse the CLI with `optparse`, using named arguments (`--input`, `--out`).
- Script structure, in order:
  1. The `#!/usr/bin/env Rscript` shebang.
  2. Libraries, inside `suppressPackageStartupMessages({ ... })`.
  3. Argument parsing.
  4. Functions.
  5. The main flow at the end.

```r
#!/usr/bin/env Rscript
suppressPackageStartupMessages({
  library(tidyverse)
  library(optparse)
})

opts <- parse_args(OptionParser(option_list = list(
  make_option("--input", type = "character", help = "Input TSV"),
  make_option("--out",   type = "character", help = "Output PDF")
)))

df <- read_tsv(opts$input, show_col_types = FALSE)

p <- df |>
  ggplot(aes(x = pc1, y = pc2, color = population)) +
  geom_point()

ggsave(opts$out, p, width = 6, height = 5)
```

## Bash: `runall.sh` (experiment driver)
Noble's driver script. The user reads it and runs it by hand, so **readability beats cleverness**:
- Start with a header comment: what the experiment does and how to run it.
- Put `set -euo pipefail` at the top.
- Set every path and parameter in UPPERCASE variables at the top. No hard-coded paths further down.
- Use numbered steps, each with a comment block and an `echo` showing progress.
- Put one command option per line, with `\`.
- No functions, loops, or logic beyond what's needed. It's a recipe, not a program.

```bash
#!/usr/bin/env bash
# 261007-ibd_mexico
# Detect IBD segments in MXB samples with the ibd_detect workflow,
# then summarize segment lengths per population.
#
# Usage:  mamba activate ibd_detect && bash runall.sh
set -euo pipefail

WORKFLOW="../../workflows/ibd_detect"
CONFIG="config.yaml"
PROFILE="../../profiles/slurm"
SCRATCH="/data/tmp/smedina/261007-ibd_mexico"

# ---- Step 1: run the IBD workflow on SLURM -------------------------
echo "[1/2] Running ibd_detect workflow..."
snakemake \
    --snakefile "${WORKFLOW}/Snakefile" \
    --configfile "${CONFIG}" \
    --profile "${PROFILE}"

# ---- Step 2: summarize segment lengths -----------------------------
echo "[2/2] Summarizing IBD segments..."
python src/summarize_ibd.py \
    --ibd-dir "${SCRATCH}/ibd" \
    --out results/ibd_summary.tsv

echo "Done."
```

## Both
- Anything random takes a `--seed` argument with a fixed default.
- Validate inputs at the start, with error messages that say what failed and why.
