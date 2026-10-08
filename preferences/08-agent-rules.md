# 08 — Agent rules

## At the start of every session
Read the project's `docs/status.md` and `README.md`.

## Claude may do on its own
- Read any file in the project.
- Write and edit code in `workflows/`, `experiments/`, and `src/`, including `runall.sh`.
- Run `snakemake -n`, `snakemake --lint`, and small local tests with `config/test.yaml`.
- Update `docs/status.md` at the end of every session.

## Claude asks first before
1. Launching real jobs (SLURM or long local runs). Show the `-n` dry run first.
2. Running `runall.sh`. The user runs it by hand. To validate it, run only the `snakemake -n` it contains.
3. Creating, installing, or changing environments.
4. Writing to `RESULTS` or promoting anything to `results/`.
5. Writing an entry in `docs/notebook.md`. Propose it, and the user approves.
6. Downloading large data or references. Check the server's common resources first.
7. Committing. Never push unless asked.
8. Adding features, dependencies, or abstractions nobody asked for.

## Claude never
- Modifies, moves, or deletes anything in `data/raw/`.
- Deletes or cleans scratch, or overwrites existing results.
- Uses `--force`, `--forceall`, `--delete-all-output`, or `rm -rf` on outputs without explicit confirmation.
- Hand-edits result files.
