# comp-bio-ia

My preferences for agentic bioinformatics with Claude Code.

## Core principles

- **Readability first.** Code is read far more often than it's written.
- **Keep it simple. Premature optimization is the root of all evil** (Knuth). Build only what is needed now. No features, abstractions, environments, or tooling before they're needed.

## Contents

- `CLAUDE.md`: entry point; imports everything in `preferences/`.
- `preferences/`: layout, naming, Snakemake style, environments, compute, coding style, reproducibility, agent rules.
- `template/`: project skeleton to copy when starting a new project.
- `references/papers.md`: papers behind these choices, with links.

## Install (on each machine)

    git clone https://github.com/santiago1234/claude-comp-bio.git ~/claude-comp-bio
    echo '@~/claude-comp-bio/CLAUDE.md' >> ~/.claude/CLAUDE.md

Check it loaded: open Claude Code anywhere and run `/memory`.

## Start a new project

    cp -r ~/claude-comp-bio/template ~/path/to/new-project
