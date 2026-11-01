# 06 editor pass, iteration 1 (book/06-metric-catalogue.qmd)

Not rendered. Checks run:
- `knitr::purl` and `pkgload::load_all` in scratch `/Users/ederdbs/.claude/jobs/1f3dbb75/tmp/06ed`. The chapter runs end to end and every `stopifnot` passes.
- The purled code was diffed against the pre-edit purl. Apart from `#|` lines the only difference is one blank line, so no chunk code changed.
- Every `#| label`/`#| tbl-cap` line was parsed with `yaml::yaml.load`.
- Every `@eq-/@tbl-/@sec-` in the chapter resolves to exactly one label in the book.
- `make_downloads.R` was re-run. `book/Rplots.pdf` was not created.

The chapter has no figures, so checklist section 1 does not apply.

## 1. Edits applied

### Tables (checklist 2)
With `df-print: kable`, any chunk that printed a bare `fmt()` data frame produced an unnumbered table. Five such chunks are now labelled and captioned:
- tbl-catalogue-ene-ane
- tbl-catalogue-theta-pools
- tbl-catalogue-gd-partition
- tbl-catalogue-het-identity (renamed from `catalogue-het-identity`; that chunk produces no figure)
- tbl-catalogue-z

Captions:
- Each one states what is tabulated, the function that computes it, the scale (n = 60 of N = 625 hybrids, 25 + 25 lines, 2000 markers, simulation seed 1), what each of the five selections is (random with seed 42; trunc_cap with at most 4 uses per line; greedy_w with w = 0.001; greedy_div with w = 0; truncation), the units (dimensionless) and the rounding.
- The tbl-catalogue-z caption also gives the z definition (`B_full` = 1000 random subsets, seed 7) and a key for every column.
- All captions are plain double-quoted YAML, with backslashes doubled.

Citations and pointers:
- Each table is cited before it appears.
- "the z table of @sec-catalogue-null", "On the z scale of @sec-catalogue-null" and "the $z$ of `GD` in @sec-catalogue-null" now point to @tbl-catalogue-z.
- "Two things to read here" now reads "Two things to read in @tbl-catalogue-gd-partition".

### Equations (checklist 3)
Labelled:
- eq-catalogue-theta, eq-catalogue-split (replaces `\tag{1}`), eq-catalogue-gd-he, eq-catalogue-ns, eq-catalogue-ne-par, eq-catalogue-alleles-lost, eq-catalogue-ene-ane, eq-catalogue-deff, eq-catalogue-theta-pools, eq-catalogue-bias, eq-catalogue-alpha.
- None of these labels is used anywhere else in the book.

Positional references replaced:
- "equation (1)", the two "Eq. (1)", "the definition" (meaning @eq-catalogue-theta), "By @sec-identity" (now @eq-catalogue-gd-he) and "The formula is exact in expectation" (now @eq-catalogue-bias).
- Added citations of @eq-catalogue-ene-ane, @eq-catalogue-deff and @eq-catalogue-alpha in the prose that discusses them.

Symbol clash:
- The eigenvalues in $D_{\text{eff}}$ were $\lambda_i$, the same letter as the diversity weight. They are renamed $\gamma_i$, which is a local rename; $\gamma$ is used as a symbol nowhere else in the book.
- $\lambda$ now means only the within/between weight of @eq-catalogue-lambda and its $\lambda_d$, which is consistent with the $\lambda$ entry in the 90 heterosis table.
- `N_{e(\text{par})}` is now `N_{e,\text{par}}`, matching 90 and chapters 10, 10b, 11 and 12.

Symbols defined at first use:
- $x_{ik}$ and $m$ (before the factorisation).
- $N$ (after @eq-catalogue-ene-ane).
- $GD_{\text{random}(n)}$ (after @eq-catalogue-alpha).
- $y_k$ at its first use in "Decomposition by heterotic group", where it is glossed as $p_{Ak} - p_{Bk}$ of @eq-het-split.

### Callouts (checklist 4)
- "Global $\theta$ does not say which pool was eroded" changed from important to **note**. It is a clarification, not a design decision; after the iteration-1 rewrite it no longer claims a trap.
- That callout's body ended in ":" pointing at the chunk outside the callout. It now ends "Its output for the five selections follows."
- The callout-warning on $N_s$ stays as it is: a projection trap.
- The chapter has no caution callouts and no footnotes.

### Text (checklist 5)
- Acronyms defined at first use: E-NE and A-NE (:252-254, in prose; they were previously defined only in the bullets after the equation), and MAF (:219).
- Hand-typed "the Caballero & Toro partition" is now "the partition of @caballero2002 (@sec-subdivided)".
- "(`ne_lines_pool()`, below)" is now "(`ne_lines_pool()`)".
- Percent signs are separated from the number, as in the rest of the book: "5 %" (x3), "0 % loss", and three inline `r ...` values.
- Headings were already in sentence case.

## 2. Findings passed on

- **06-E1** `book/06-metric-catalogue.qmd:63-64`: the chunk prints the `cmp` data frame (a table) and then the `rank_correlation` vector. It cannot take a `tbl-` label without wrapping console output inside the table float, so it stays an unnumbered table. Suggested fix: move the Spearman value to an inline `r` expression in the prose (that is a code change), then label the table `tbl-catalogue-offdiag`. For quant-Rwrite.
- **06-E2** `:203, :227, :320, :412, :559`: per-selection results are printed as raw console named vectors. These are $N_{e,\text{par}}$, `alleles_lost`, `eff_dim`, the `ne_lines_pool()` matrix (not even via `fmt()`, so it does not become a kable) and $\alpha$. That is console output standing in for result tables. Suggestion: one `data.frame` per section, or a single per-selection table, each labelled and captioned. :412 is the table the callout of "Decomposition by heterotic group" announces. Code change; for quant-Rwrite or the writer. The check vectors at :91-98, :127, :155-158, :547 and :576 are diagnostics and are fine as they are.
- **06-E3** Symbols in this chapter missing from `book/90-notation.qmd`:
  - $\gamma_i$ and $D_{\text{eff}}$
  - $A_{\text{lost}}$ and MAF
  - E-NE and A-NE, and the distance $d_{ij} = 1 - f_{ij}$
  - $H_S$, $H_T$, $D_G$ and their per-locus forms
  - $A_T$, $A_S$, $D_A$
  - $\lambda_d$, $\bar d_H$, $\bar d_D$
  - $GD_{\text{random}(n)}$
  - $x_{ik}$ in this marker-value sense, if 90 does not already carry it

  For the writer, or for whoever owns 90.
- **06-E4** Symbol clashes I cannot resolve with a local rename without touching content:
  - (a) $d_{ij}$ (distance, :262) and $d_k$ (dominance deviation, :444-462) appear in the same chapter. 90 also has $D_{ij}$ (Nei minimum distance) and $\bar d_{ij}$ (mean distance between subpopulations), both different from $1 - f_{ij}$. Suggest a distinct distance symbol, for example $\delta_{ij}$, or the $\mathrm{MRD}^2_{ij}$ of 90 if the writer confirms $1 - f_{ij}$ equals it here; for hybrids it does not, because 90 states it only for inbred lines.
  - (b) The greedy index weight $w$ (`sel_greedy(w =)`, now in five captions) and the line-usage weights $\mathbf{w}$, $\mathbf{w}_A$ of @eq-catalogue-theta-pools.

  Writer's call.
- **06-E5** `:54`: the code comment `# Eq. (1) on every selection` refers to a number that no longer exists, because the equation is now @eq-catalogue-split. It is code, so I did not touch it. Suggest `# eq-catalogue-split on every selection`. For quant-Rwrite; trivial.
- **06-E6** `:400-410`: the "Global $\theta$" callout is now a note. If the writer means it as a warning ("do not read global $\theta$ as per-pool health"), the body needs one sentence that states the trap, and the type then becomes warning. Retyping it without that sentence would claim more than the body supports.

## 3. Orphaned figure files

None. The chapter has no figure chunks. `book/_freeze/06-metric-catalogue/` holds only `execute-results/{html,typ}.json`, and `docs/06-metric-catalogue_files/` does not exist. The renamed label `catalogue-het-identity` produced no PNG. The source changed, so 06 will re-execute on the next render, which must be a full both-format render so that `typ.json` is restored.
