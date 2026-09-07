# `doc/` — source material

These are the working documents the book was built from. They are kept as
provenance: each one is the original analysis, in the language and format it was
written in, before being translated and reorganised into `book/`.

**For reading, use the book**: <https://ederdbs.github.io/QG/>. These files are
not maintained in step with it.

| Source | Language | Became |
|---|---|---|
| `caballero_toro/*.md` | PT-BR | Chapter 2, *Diversity in a subdivided population* |
| `diversity_metrics/metricas_diversidade_genomica.md` | PT-BR | Chapter 5, *Diversity metrics in the genomic era* |
| `diversity_metrics/diversity_metrics.Rmd` | EN | Chapters 1 and 6 |
| `diversity_metrics/metric_selection.Rmd` | EN | Chapter 7, *Choosing metrics* |
| `diversity_metrics/pipeline_stages.Rmd` | EN | Chapter 8, *Metrics at each pipeline stage* |
| `diversity_metrics/plant_maize_diversity.Rmd` + `*_synthesis.md` | EN | Chapter 11, *What the plant literature establishes* |
| `F2size/` | PT-BR | Chapter 4, *Sizing a segregating population* |
| `multigenes/` | EN | Chapter 5, *Introgressing several genes by backcrossing* |

The four loose `.R` files (`00_sim_ref.R`, `fast_metrics.R`, `pipeline_metrics.R`,
and `F2size/maize_wide_cross_sim.R`) were folded into the `hybdiv` package and
are **superseded** — edit `R/`, not these. The `.csv` and `.png` artefacts are
copied into `book/data` and `book/figs`, which is where the book reads them
from; `book/scripts/regenerate.R` is how they are refreshed.

The multi-gene MABC simulator went the same way: its engine and decision layer
are now `R/08_mabc.R` and its driver is `inst/scripts/run_mabc.R`, so
`multigenes/` keeps only the review, the README and the artefacts. Chapter 5
reads those CSVs and figures from `book/data` and `book/figs` (as `mabc_*`);
`Rscript inst/scripts/run_mabc.R` is how they are refreshed.

Generated `.html` renders have been removed: they are reproducible from the
`.Rmd` sources, and the book replaces them.

Two chapters have no `doc/` source. *Heterosis, dominance and what divergence
buys* and *Diversity across cycles* were written directly in `book/`, against
`R/13_dominance.R` and `R/14_cycles.R`; there is no prior document they were
translated from. Their cached results come from
`Rscript book/scripts/regenerate.R cycles`.
