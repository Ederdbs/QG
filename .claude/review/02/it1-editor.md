# 02-subdivided -- production editor, iteration 1

File: book/02-subdivided.qmd (line numbers below are post-edit).

## 1. Edits applied

### Figures (checklist 1)
- None. The chapter has no figures.

### Tables (checklist 2)
- Mating-system meter kable (:139-153): added `#| label: tbl-mating-meter` and a standalone `#| tbl-cap:`. Removed the `caption =` argument (it would have produced a second caption). Added `col.names` so the header reads `$G_i$` and not the literal `G_i`. Cited at :137 before the table.
- Partition kable (:223-239): added `#| label: tbl-gd-partition` and a `#| tbl-cap:` that defines $\bar f$, $\tilde f$, $\tilde s$, $H_e$ and $H_o$. Removed `caption =`. Cited at :216-217.
- Keystone pipe table (:560-564): added the caption `: ... {#tbl-keystone}`, which defines $\tilde s$, $\tilde H_o$, $\theta$ and $\alpha$. Cited at :558.

### Equations (checklist 3)
- Labelled nine equations: `eq-fii-he` (:93), `eq-self-coancestry` (:103), `eq-alpha-g` (:128), `eq-nei-distance` (:163), `eq-fbar-decomp` (:191), `eq-f-stats` (:209), `eq-gd-partition` (:221), `eq-ratio-identities` (:246), `eq-ne-meta` (:488). No label collides with any other chapter.
- Added citations to them:
  - "use $\alpha_i$ below" became `@eq-alpha-g` (:118).
  - `@eq-nei-distance` (:179) and `@eq-self-coancestry` (:182) in the tip.
  - "In @eq-fbar-decomp, each accession's contribution..." (:193).
  - `@eq-alpha-g` for the metapopulation $G$ (:249).
  - `@eq-ne-meta` at :496, and at :545 replacing "result used above".
  - `@eq-gd-partition` in the keystone section (:555).
- No Caballero & Toro equation numbers were reintroduced.

### Callouts (checklist 4)
- `callout-important` "$F_i$ here is molecular, and is not $F_{IS}$" (:113) became `callout-warning`. It describes a trap in comparing values across panels, not a design decision.
- `callout-caution` "What this does and does not license" (:427) became `callout-note`, as a clarification of scope. `caution` is not used in this book.
- The unattributed blockquote "Harvesting the same number of seeds..." (:499) became `callout-tip` with the title "Equal seed contributions double $N_e$". The text is unchanged.

### Text (checklist 5)
- Acronyms:
  - GD is now expanded at first use (:216, "gene diversity ($GD$)").
  - "DH" was used only once, so it is written out as "doubled-haploid" (:325).
  - "QTL" was used only once, so it is written out as "quantitative trait loci" (:462).
  - "S1" became "stage S1" (:581).
- Citation: the hand-typed "treatment of Caballero & Toro" became `@caballero2002` (:554).
- Cross-references:
  - Added the heading id `{#sec-ct-removal}` (:399).
  - "We reproduce that result numerically below" became `@sec-ct-removal` (:19).
  - "the 0.67% quoted above" became `@sec-ct-removal` (:543).
  - "none of the identities below hold" became "...of this chapter hold" (:44).
- Headings were already in sentence case. No change.

### Downloads
- Ran `Rscript book/scripts/make_downloads.R`. This regenerated book/downloads/02-subdivided.R. It also refreshed 04c, 05 and 91, whose sources other agents had already modified in this worktree.

## 2. Findings passed on

- 02-E1 book/02-subdivided.qmd:383 -- `ct_glob` is printed as raw console output. It is the chapter's computed-vs-published results table, so it should be `knitr::kable(ct_glob)` in a chunk labelled `tbl-ct-example-global` with a caption. That needs a code change and a relabel, so it goes to quant-Rwrite. The prose at :386 should then cite it.
- 02-E2 book/02-subdivided.qmd:409 -- `fmt(lg)` (loss/gain per subpopulation, census and equal weights, `dist`) is also raw console output standing in for the results table that :412-418 discusses. It needs kable, a `tbl-` label and a caption. Column names `delta_pct`, `delta_pct_equal` and `dist` need readable headers with units (%).
- 02-E3 book/02-subdivided.qmd:75 and :446-448 -- `fmt(fl_rng)` and the `oc$c_i` / `c(GD_before, ...)` vectors print as console output. The prose already quotes the values inline. Either hide them (`#| echo`/`results` is an option I could set, but suppressing output is an authorial choice) or render them as small tables. Decision for quant-writer.
- 02-E4 book/02-subdivided.qmd:144, :228-237 -- The table cells use ASCII pseudo-math ("~ 0.5", "-> 1.0", "GD_T = 1 - f_bar", "s_til", "He", "H_o / 2"). book/90-notation.qmd typesets the same quantities as `$GD_T$`, `$1 - \bar f$`, and so on. The cells need LaTeX math. This is a change to the data.frame contents, outside my remit.
- 02-E5 book/02-subdivided.qmd:223-239 -- @tbl-gd-partition sits between @eq-gd-partition and the sentence that continues it ("with the clean identities", :241). Move the table after the identities, or rephrase :241 so it stands alone. This is a layout move.
- 02-E6 book/02-subdivided.qmd:128 -- Symbol clash. $\alpha_i$ (the subpopulation $F_{IS}$ analogue) shares its letter with $\alpha$, the book's diversity-loss constraint, and the chapter uses both in @tbl-keystone. Similarly $G_i$ / $G$ (:128, :248) are close to VanRaden $\mathbf{G}$ and $\mathbf{G}_{0.5}$. Neither $\alpha_i$ nor $G_i$ is in book/90-notation.qmd. Either add both there with a disambiguating note, or rename them.
- 02-E7 book/02-subdivided.qmd:24 and :488 -- $n$ (number of subpopulations) and $N$ / $N_i$ (subpopulation sizes) clash with the notation appendix, where $n$ is hybrids selected and $N$ is candidate hybrids. $N_T$, $N_e$, $V_W$, $V_B$, $\mathbf{D}_{ij}$, $\bar d_{ij}$, $H_{o,i}$, $F_i$, $\alpha_i$ and $G_i$ are absent from book/90-notation.qmd. The chapter-local Notation section (:22-34) is the only definition of these.
- 02-E8 book/02-subdivided.qmd:102-105 -- $p_{k,l,i}$, the within-individual allele frequency, is the same object as the appendix's $x_{ik}$ (within-individual frequency, 0/0.5/1). The chapter uses a third index order (allele, individual, subpopulation) without linking it to $x_{ik}$. Add a link or align the symbols.
- 02-E9 book/02-subdivided.qmd:162, :181, :191 -- $\mathbf{D}_{ij}$ is a scalar element typeset in bold. The book reserves bold for matrices and vectors, so this should be $D_{ij}$, an element of $\mathbf{D}$. It is a symbol change across the chapter and in 04g (which cites "the $\bar D$" of this chapter), so it needs author sign-off.
- 02-E10 book/02-subdivided.qmd:469-472 -- $\mathbf{g}$ is used for the vector of breeding values. book/90-notation.qmd uses $\mathbf{u}$ for breeding values and $g^A_i$ for GCA.
- 02-E11 book/02-subdivided.qmd:560-564 -- The keystone pipe table has very long third-column cells (row 1 is about 200 characters). Check that it fits the Typst page. Shortening it is a wording change.
- 02-E12 book/02-subdivided.qmd:543, :419-424 -- "%" is attached to the number ("0.67%"). The book is mixed (65 attached, 63 spaced across book/*.qmd). A book-wide decision is needed. Not changed here.

## 3. Orphaned figure files

None. The chapter has no figures, and all new labels are `tbl-` labels on kable chunks. The freeze for 02 will be invalidated by the source change in any case.

There is a pre-existing duplicate, `book/_freeze/02-subdivided/execute-results/html 2.json`. It is tracked, so it belongs to the 64 known tracked duplicates; removing it needs an explicit `git rm`.
