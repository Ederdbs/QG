<div align="center">

# 🧬 Genetic Diversity in Hybrid Breeding

### Quantitative genetics meets computational optimisation — keeping diversity in the loop while an algorithm picks your next generation of hybrids.

**[📖 Read the book online](https://ederdbs.github.io/QG/)** · **[⬇️ Download the PDF](https://ederdbs.github.io/QG/Genetic-Diversity-in-Hybrid-Breeding.pdf)** · **[📦 Install the R package](#-install-the-package)**

*21 chapters · 5 appendices · 247 pages · every derivation runnable in R*

</div>

---

## Why this exists

Genomic selection is very good at one thing: picking the highest-index
individuals. Left alone, it is also very good at quietly erasing the genetic
diversity a breeding programme depends on for the next ten years of gains.

This project answers a concrete question for hybrid breeding programmes:
**how do you select the best `n` hybrids from a pool of candidates while
provably limiting how much molecular diversity you give up**, relative to
what a random draw of the same size would have cost you anyway?

It combines three things that don't usually sit in one repository:

- 🧮 **Foundational quantitative genetics** — coancestry, gene diversity,
  Caballero & Toro's partition, optimal contribution theory — derived, not
  asserted.
- 🤖 **Modern optimisation** — differential evolution, local search, exact
  MILP oracles, all benchmarked against each other, not just described.
- 🌽 **Real plant-breeding relevance** — heterotic pools, MABC, AlphaSimR
  pipelines, a full staged breeding programme, reciprocal recurrent selection.

Every number quoted in the book is reproduced live from the code in this
repository — nothing here is a black box.

## What's inside the book

| Part | What you'll find |
|---|---|
| 🧩 **Foundations** | The coancestry matrix vs. the genomic relationship matrix — and why conflating them silently breaks your diversity metric · gene diversity in a subdivided population · the classical response-to-selection machinery, rebuilt from first principles |
| 🌱 **Simulation** | Simulating founder lines, heterotic pools and crosses from scratch · sizing a segregating population (F1→F4) · introgressing several genes by backcrossing · AlphaSimR from the ground up · a complete, staged plant breeding programme end to end |
| 📊 **Metrics** | A full catalogue of diversity metrics, benchmarked against a random-sampling null so you know which ones actually discriminate · heterosis and dominance, and what pool divergence buys you · metrics mapped onto every stage of a real pipeline · genomic prediction |
| ⚙️ **Optimisation** | Optimal contribution selection and the alpha diversity constraint · differential evolution for combinatorial selection · structure-aware search, certified bounds, and an exact oracle that proves optimality at small scale |
| 🔬 **Evidence & practice** | What the plant breeding literature actually establishes (and what it doesn't) · how diversity erodes across recurrent selection cycles · the limits of every metric here · a worked, end-to-end case study with a checklist you can reuse |

**Highlights you can check yourself, in the book, with code:**
- Why `1 − θ` and Nei's expected heterozygosity are the *same number* — one exact identity, one fewer metric to argue about.
- Why constraining gene diversity alone still lets 10% of your rare alleles quietly vanish — and the diagnostic that catches it.
- Why a naive "upper bound" on the optimisation used in the literature isn't actually a bound — and the Lagrangian fix that is.
- A certified, DE-warm-started selection routine that hugs the theoretical optimum, benchmarked against greedy, truncation, local search and an exact MILP oracle.

## 📦 Install the package

The methods behind the book live in `hybdiv`, an R package. Install it straight from GitHub:

```r
# install.packages("remotes")
remotes::install_github("ederdbs/QG")
```

```r
library(hybdiv)

st1 <- stage1_simulate()
res <- stage2_select(st1$X, st1$f, st1$hybrids, n_sel = 200)
res$metrics
```

That's it — no compilation steps to worry about, no external solvers required
for the core workflow (only `DEoptim` is a hard dependency).

---

## For contributors

<details>
<summary>Building the book from source</summary>

```sh
Rscript inst/scripts/render_book.R   # HTML + Typst PDF, both into docs/
quarto render book --to html         # HTML only, while iterating
cd book && quarto preview            # live reload while editing
```

The book renders against the **installed** package, so run
`Rscript -e 'devtools::install()'` after any change to `R/` that a chapter
calls — otherwise a new export is invisible and the chapter fails with
`object 'foo' not found`.

Light examples run live at render; expensive results are cached in `book/data`
and `book/figs` and refreshed with `book/scripts/regenerate.R`. `docs/` is
committed, because GitHub Pages serves it straight from `main`.

</details>

<details>
<summary>Developing the package</summary>

```sh
Rscript -e 'devtools::document(); devtools::load_all()'
Rscript -e 'devtools::test()'     # 390 checks, ~1 min
Rscript -e 'devtools::check()'    # 0 errors, 0 warnings, 1 known note
```

The one note is `.cursorignore`: tracked, but absent from `.Rbuildignore`, so
`R CMD check` flags it as a stray hidden file. Adding `^\.cursorignore$` there
(or untracking it) restores 0/0/0.

Only `DEoptim` is a hard dependency (used solely by `sel_de()`/`sel_de_fast()`).
`quadprog`, `highs`, `bWGR` and `AlphaSimR` are suggested, each guarded by
`requireNamespace()` and each needed by exactly one area. Everything else, plots
included, is base R.

### Runnable pipelines

The book runs everything at a reduced scale so it renders quickly. These run the
same work at the production scale of `sim_config` and write to `report/`:

```sh
Rscript inst/scripts/run_all.R          # two-stage pipeline, ~4 min
Rscript inst/scripts/run_benchmark.R    # metrics benchmark + plots, ~6 min
Rscript inst/scripts/run_mabc.R         # MABC scans + figures, ~3 min
Rscript inst/scripts/run_alphasimr.R    # reciprocal recurrent selection, ~2 min
```

`run_benchmark.R` produces the numeric results quoted below. All ship with the
installed package, so `system.file("scripts", "run_all.R", package = "hybdiv")`
finds them from anywhere.

</details>

---
