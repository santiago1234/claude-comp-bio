# comp-bio-ia

My preferences for agentic bioinformatics with Claude Code. This comes from my years working as a bioinformatician.

## Core principles

- **Readability first.** Code is read far more often than it's written.
- **Keep it simple. Premature optimization is the root of all evil** (Knuth). Build only what is needed now. No features, abstractions, environments, or tooling before they're needed.

## Contents

- `CLAUDE.md`: entry point; imports everything in `preferences/`.
- `preferences/`: layout, naming, Snakemake style, environments, compute, coding style, reproducibility, agent rules.
- `template/`: project skeleton to copy when starting a new project.
- `references/papers.md`: papers behind these choices, with links.

## How it works

These preferences live in one place (this repo) and every project follows them:

- `~/.claude/CLAUDE.md` is loaded by Claude Code in **every** session on the machine. It imports this repo's `CLAUDE.md`, which imports everything in `preferences/`.
- Each project stays independent: its own git repo, its own `CLAUDE.md` with project-specific context. Anything in a project's `CLAUDE.md` overrides these preferences.
- Improve a preference here once, `git pull` on each machine, and every project picks it up in the next session.

## 1. Install (once per machine: laptop and each server)

    git clone https://github.com/santiago1234/claude-comp-bio.git ~/claude-comp-bio
    mkdir -p ~/.claude
    echo '@~/claude-comp-bio/CLAUDE.md' >> ~/.claude/CLAUDE.md

Check it loaded: open Claude Code in any folder and run `/memory`. The list should show `~/claude-comp-bio/CLAUDE.md` and the `preferences/` files.

## 2. Start a new project

    cp -r ~/claude-comp-bio/template ~/path/to/new_project
    cd ~/path/to/new_project
    git init

Then fill in the `<project_name>` and `<TODO>` placeholders in `README.md`, `CLAUDE.md`, and `docs/status.md`, and rename or delete `experiments/YYMMDD-example/`. Or open Claude Code in the folder and ask it to do it.

## 3. Bring an existing project in line

Open Claude Code in the project and ask:

> Compare this project with my preferences and propose the changes to follow them. Don't move or modify anything in `data/raw/`.

At minimum, add a project `CLAUDE.md`, `docs/status.md`, and `docs/notebook.md` (copy them from `template/`). Reorganize the rest gradually, as you touch each part.

## 4. Keep preferences up to date

    cd ~/claude-comp-bio && git pull

Run it on every machine after changing a preference. Edit preferences here, never inside a project. If a single project needs something different, write it in that project's `CLAUDE.md`.
