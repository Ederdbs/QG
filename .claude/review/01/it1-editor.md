# 01-coancestry -- quant-editor, iteration 1

## 1. Edits applied (book/01-coancestry.qmd)

### Figures
None in the chapter. Nothing to do.

### Tables
- `:285-298` the `knitr::kable()` table now has `#| label: tbl-matrix-roles` and `#| tbl-cap:` (stand-alone caption naming both matrices with `@eq-vanraden-g` / `@eq-f-molecular`); the kable `caption =` argument removed so the caption is not duplicated. Cited before it appears with a new lead sentence at `:283` ("@tbl-matrix-roles sets the two matrices side by side.").

### Equations
- Labelled: `eq-hybrid-dosage` (:30), `eq-x-freq` (:46), `eq-vanraden-g` (:66), `eq-g-sum-zero` (:86), `eq-f-molecular` (:149), `eq-f-matrix` (:177), `eq-g05` (:255). No label clash elsewhere in the book.
- "the double sum" -> "the double sum of @eq-f-molecular" (:165); "the identity-by-state average above" -> "of @eq-f-molecular" (:236); "the one demonstrated above" -> "demonstrated in @eq-g-sum-zero" (:241); "With the 0/1/2 coding above" -> "of @eq-hybrid-dosage" (:248); "the centering identity" -> "the centering identity of @eq-g-sum-zero" (:305).

### Callouts
- `:129` `callout-important` -> `callout-warning`: the box explains the trap that yields a meaningless diversity number from G, not a design decision. Title kept.

### Text
- Acronyms expanded at first use: GBLUP (:69-70, "genomic best linear unbiased prediction (GBLUP)"), BLAS (:182, "Basic Linear Algebra Subprograms (BLAS)").
- Citation syntax: hand-typed "Nejati-Javaremi et al. [-@nejatijavaremi1997]" -> narrative `@nejatijavaremi1997` (:233).
- Cross-reference: "The next chapter takes f" -> "@sec-subdivided takes f" (:311).
- Headings checked: already sentence case.

### Downloads
`Rscript book/scripts/make_downloads.R` run; `book/downloads/01-coancestry.R` regenerated. Not rendered.

## 2. Findings passed on

Notation (symbols that do not match `book/90-notation.qmd`) -- quant-writer, either the chapter or the appendix must move:
- **01-E1** `book/01-coancestry.qmd:19-20` -- the line genotype matrix is `$\mathbf{M}^{L}$`, coded {0, 2}. Notation `90-notation.qmd:14,23` lists it as `$\mathbf{G}^L$`, "coded 0/1". Both the symbol and the coding disagree, and `G^L` collides with VanRaden `G`.
- **01-E2** `:29,45,62` -- `$\mathbf{M}^{H}$` (hybrid dosage) has no entry; the appendix has `$\mathbf{M}$` (`90-notation.qmd:14,22`). Add `M^H`/`M^L` to the appendix or drop the superscripts.
- **01-E3** `:157,206-207` -- `$f_{ii}$` is used as an individual's self-coancestry, with `F_i = 2 f_ii - 1`. The appendix (`90-notation.qmd:57,62-63`) defines `$f_{ii}$` as "coancestry within subpopulation i" and uses `$s_i$` for self-coancestry, `F_i = 2 s_i - 1`. Direct clash in the first technical chapter.
- **01-E4** `:172` -- `$\mathbf{s} = \mathbf{X}\mathbf{1}$` (row sums) collides with the appendix's `$s_i$` (self-coancestry). Suggest another letter (e.g. `$\mathbf{r}$`).
- **01-E5** `:255` vs `90-notation.qmd:47` -- the chapter states correctly that `G_0.5 = 4f - 2J` is an affine function of f, "not f itself"; the appendix says "**this is f**". The appendix must be corrected to match.
- **01-E6** `:62` -- `$\mathbf{Z}$` (centered dosage) is listed in the appendix only as the genomic-prediction design matrix (`u = Z beta`, :172) and as joint-allocation subgroup indicators (:271). Same letter, three meanings; at least add this one.
- **01-E7** `:176,260` -- `$\mathbf{J}$` (matrix of ones) is not in the appendix.

Symbols used before they are defined -- quant-writer:
- **01-E8** `:84` (@eq-g-sum-zero) uses `$q_k$`, defined only at `:110`. Write `p_k(1-p_k)` as in @eq-vanraden-g or define `q_k` right after the equation.
- **01-E9** `:176` (@eq-f-matrix) uses `$\mathbf{J}$`, defined only at `:260` ("with J the N x N matrix of ones"). Move the definition up to @eq-f-matrix.
- **01-E10** `:90` -- `$\theta$` (group coancestry) appears in `N_s = 1/(2 theta)` without ever being defined in the chapter ("Group coancestry is proportional to that sum" names the concept but not the symbol or its normalisation `n^{-2} 1'f1`, diagonal included). This chapter is where the reader first meets theta.
- **01-E11** `:172` -- `$\mathbf{X}$` (hybrid marker matrix, entries `x_ik` of @eq-x-freq) is used in @eq-f-matrix but never named as the matrix of `x_ik`; one clause at @eq-x-freq would fix it.

Tables / raw output -- quant-Rwrite:
- **01-E12** `:94-97`, `:189-192`, `:215-217`, `:273` -- results are shown as printed named vectors (`c(sum_G = ...)`, `fmt(c(minimum = ...))`, `range(G05)`), i.e. raw console output standing in for small results tables. They are demonstrations, so acceptable as code output, but if the book wants them as numbered tables they need `#| label: tbl-...`/`#| tbl-cap:` and a `data.frame` + `knitr::kable()`, which is a code change. Low priority; author's call.
- **01-E13** `:293` (tbl-matrix-roles, Range column) -- "centered, signed" for G sits next to "[0, 1]" for f; the f row is a range, the G row is a property. If the column is meant to be comparable, quant-writer could give G's actual range type (unbounded, signed). Content change, not applied.

## 3. Orphaned figure files
None. The chapter has no figures; `docs/01-coancestry_files/` does not exist and `book/_freeze/01-coancestry/` holds only `execute-results/{html,typ}.json`. Labelling the table chunk renames no PNG. The freeze is stale (chunk options and new chunks since the last render) and needs a full render (both formats).
