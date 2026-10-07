# References on project organization and computing practices

Not imported into CLAUDE.md (to save context). Read it when you need the rationale.

| Paper | Key idea we adopt |
|---|---|
| Noble WS (2009). *A Quick Guide to Organizing Computational Biology Projects.* PLoS Comput Biol 5(7):e1000424 | Dated experiment folders, a `runall` driver per experiment, a dated lab notebook, `data/` kept separate from `results/`. |
| Wilson G et al. (2017). *Good Enough Practices in Scientific Computing.* PLoS Comput Biol 13(6):e1005510 | Raw data are untouchable. One folder per project with README/doc/data/src/results. Descriptive file names. Record every step. |
| Wilson G et al. (2014). *Best Practices for Scientific Computing.* PLoS Biol 12(1):e1001745 | Automate with a workflow manager, use version control, don't repeat yourself. |
| Sandve GK et al. (2013). *Ten Simple Rules for Reproducible Computational Research.* PLoS Comput Biol 9(10):e1003285 | Record how every result was produced, no manual edits, version the environment, record seeds, link final figures to their data. |
| Schnell S (2015). *Ten Simple Rules for a Computational Biologist's Laboratory Notebook.* PLoS Comput Biol 11(9):e1004385 | Dated entries covering what, why, and where the results are, failures included. |
| Mölder F et al. (2021). *Sustainable Data Analysis with Snakemake.* F1000Research 10:33 | Standard `workflow/` + `config/` layout, per-rule environments, `module` to reuse workflows. |
| Ziemann M et al. (2023). *The Five Pillars of Computational Reproducibility.* Brief Bioinform 24(4):bbad375 | Literate programming, version control, environments or containers, data sharing, documentation. |
