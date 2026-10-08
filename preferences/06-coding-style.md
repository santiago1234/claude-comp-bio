# 06 — Coding style (Python and R)

Scripts are CLIs called from Snakemake `shell:` (see 03-snakemake-style.md, point 5). Each one must also run on its own.

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
    parser.add_argument("--out", type=Path, required=True, help="Output CSV")
    args = parser.parse_args()
    ...


if __name__ == "__main__":
    main()
```

## R
- Follow the tidyverse style guide. Use tidyverse for data wrangling and ggplot2 for plots (preferred over matplotlib).
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

## Both
- Anything random takes a `--seed` argument with a fixed default.
- Validate inputs at the start, with error messages that say what failed and why.
