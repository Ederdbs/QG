# 04g -- iteration 1, production editor

File: book/04g-joint-allocation.qmd (worktree). `make_downloads.R` re-run; book/downloads/04g-joint-allocation.R regenerated. Not rendered.

## 1. Edits applied

### Figures
- fig-joint-budget: cited before it appears (end of the sweep-description paragraph, `(@fig-joint-budget)`). Caption rewritten to stand alone: accuracy defined (correlation, predicted vs true), panels = plot h^2 x SCA level, points = cell means over 30 replicates, error bars = +/- 2 SE, scale (20 x 20 pools, half-sib families of four, eight locations, known components), source (`regenerate.R joint`).
- fig-joint-pev: cited before it appears (intro result 3, `(@fig-joint-pev)`). Caption rewritten: accuracy defined, 400 hybrids, each point a mean of 30 replicates, scale, budget, source.
- Both figures already had labels and fig-alt; no static images in the chapter. Labels unchanged.

### Tables
- All seven tables already labelled and cited before they appear.
- tbl-joint-literature: `col.names` added (`Refs` -> `References`).
- tbl-joint-live: `col.names` added (Strategy, Plots, Mean PEV of GCA, Female/Male coverage, `n_comp_cross`, `n_comp_loc`); caption adds half-sib families of five, plot h^2 = 0.3, low SCA, known components, one allocation per strategy.
- tbl-joint-freq: caption "defined in the text above" -> "defined in @sec-joint-freq"; "one simulated marker set" added.
- tbl-joint-made: header `Plot h2` -> `Plot $h^2$`; caption adds accuracy definition, scale, replicates, source.
- tbl-joint-strategy: headers `diff`/`Positive` -> `Mean difference`/`Positive cells`; caption updated to match, replicates and source added.
- tbl-joint-optimiser: headers `c` -> `$c$`, `Plot h2` -> `Plot $h^2$`; caption adds scale and budget.

### Equations
- Labelled: eq-joint-budget (B = n_c k r), eq-joint-model (the linear model), eq-joint-ssb (ANOVA decomposition), eq-joint-gd (GD identity), eq-joint-gdbs (GD_BS = 2 SS_B/(N_P N_SNP)), eq-joint-base (change of base).
- Cited: "the budget identity (@eq-joint-budget)"; "in the model below" -> "in @eq-joint-model"; "with the kernel above" -> "with the kernel of @eq-joint-model"; the assertion sentence before tbl-joint-freq now cites eq-joint-ssb/gd/gdbs/base.

### Callouts
- No change: callout-note (provenance/clarification) and callout-tip (checklist) are correctly typed and titled. No footnotes.

### Text
- Acronyms expanded at first use: SCA, PEV, GCA (intro list), BLUP, GLS (sec-joint-model), CDmean and G x E (literature prose), NC II (sec-joint-criteria), REML (limitations).
- Vague references replaced: "Result 1 below" -> "Result 1 (@sec-joint-results)"; "in the plans compared below" -> "in @sec-joint-results"; "Neither criterion above" -> "of @sec-joint-criteria"; "the sweep below" -> "the sweep of @sec-joint-results".
- Headings already in sentence case; citations already in Quarto syntax (no hand-typed author-year).

## 2. Findings passed on (quant-writer / quant-Rwrite)

- 04g-E1 book/04g-joint-allocation.qmd:158 (and :114) -- notation: the chapter writes GCA as $g^f_i$, $g^m_j$; book/90-notation.qmd (Mating design, Heterosis tables) uses $g^A_i$, $g^B_j$. Either align or add f/m to the notation appendix.
- 04g-E2 book/90-notation.qmd -- symbols used in 04g and absent from the notation appendix: $n_F$, $n_M$, $n_c$, $B$, $N_P$, $N_{SNP}$, $n_l$, $SS_B$, $GD_l$, $GD_P$, $\mathbf X_P$, $\mathbf Z$, $w$, $\sigma^2_{f\ell}$, $\sigma^2_{m\ell}$, $\sigma^2_{s\ell}$, $\mathbf A_f$, $\mathbf A_m$. Also $m$ = markers in the appendix vs male pool here (the chapter flags it at ~:520; the appendix does not).
- 04g-E3 book/04g-joint-allocation.qmd:223 -- `signif(ms, 2)` prints a raw 2 x 2 console matrix of results (diff, SE by SCA level). Either make it a labelled tbl- or suppress the print (prose already reports the numbers). Code change.
- 04g-E4 book/04g-joint-allocation.qmd:844 -- fig-joint-budget has `fig-width: 9`; at the 6.5 in Typst width it scales to ~0.72, so the rotated tick labels (`cex.axis = 0.75`) end up at ~6 pt and the panel titles at ~8 pt. Suggest fig-width 6.5 with re-checked label sizes, or shortening the tick labels. Needs a render check.
- 04g-E5 book/04g-joint-allocation.qmd:856 -- panel titles print "h2" instead of h^2 (use `bquote`/`expression`); x axis has no title (configuration). Code change.
- 04g-E6 book/04g-joint-allocation.qmd:622-709 -- tbl-joint-freq has 9 columns with long snake_case headers (`groups_between_pct`, `family_pairs`, ...); likely too wide for the Typst page. Transposing (strategies as columns, metrics as rows) would fit and keep the names the prose refers to. Code change (restructure).
- 04g-E7 book/04g-joint-allocation.qmd:271 -- tbl-joint-literature: five text-heavy columns with 9 rows; check Typst fit after render; consider splitting the Refs column into the prose or reducing to a citation-per-row table.
- 04g-E8 book/04g-joint-allocation.qmd:118 -- "appear below only in the label `tester k=2`": vague "below"; the label first appears in @fig-joint-budget, so "(@fig-joint-budget)" would do, but the sentence is the author's definition of $k$ -- left for quant-writer.
- 04g-E9 headings `### 1. The budget split...`, `### 2. ...`, `### 3. ...` are hand-numbered and unlabelled; the prose cites them as "result 1/2/3". Giving them `{#sec-joint-split}` etc. and citing with @sec- would make the references clickable; requires rewording result citations (quant-writer).

## 3. Orphaned figure files
None. No figure label was added or renamed; docs/04g-joint-allocation_files/figure-html/ and book/_freeze/04g-joint-allocation/figure-{html,typst}/ hold only fig-joint-budget-1 and fig-joint-pev-1, both still referenced. Caption and chunk-source edits invalidate the freeze, so 04g re-executes on next render.
