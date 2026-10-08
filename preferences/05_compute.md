# 05 — Compute and scratch

**Keep this flexible.** The user works on more than one server. Server-specific values (paths, partition) live only in configs and profiles, never in rules or scripts. The general rules below apply on any server.

## General rules
- Develop and test on the laptop with small data (`config/test.yaml`, `profiles/local`). Run real jobs on the server.
- Every analysis gets its own scratch folder: `<scratch>/YYMMDD-<keyword>/`, named after the experiment it belongs to. That path is the `scratch:` key in the run's config.
- The user cleans scratch by hand. Never delete or clean anything in scratch unless asked.
- The user chooses where `RESULTS` lives for each pipeline. Never delete or overwrite existing results.
- Check the server's shared fixed-data directory (genomes, genetic maps, masks) before downloading a reference. Reference it from the config; don't copy it.

## Current server: kexol
| What | Where |
|---|---|
| Scratch | `/data/tmp/smedina/YYMMDD-<keyword>/` |
| Fixed shared data (genomes, genetic maps, masks) | `/data/data_vault/smedina/data/common-resources/` |
| SLURM partition | `light` (default) |

On another server, ask the user for the equivalent values and record them in a section like this one.
