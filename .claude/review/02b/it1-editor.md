# 02b-response -- editor, iteration 1

## 1. Edits applied (book/02b-response.qmd only)

Tables (sect. 2)
- I added `#| label: tbl-...` and `#| tbl-cap:` to five previously unlabelled `fmt(data.frame(...))` chunks: tbl-response-breeders, tbl-response-gap, tbl-response-gca-sca, tbl-response-smith-hazel and tbl-response-restricted. Each one is now cited with `@tbl-` before it appears. "The table below" became @tbl-response-gap and "Read the shares:" became @tbl-response-gca-sca. Every caption is written from the code alone: scale, seed, what each column holds, units.

Equations (sect. 3)
- I added labels: eq-response-breeders (R = i r sigma_A), eq-response-genic, eq-response-ld (the disequilibrium term), eq-response-smith-hazel (promoted from inline to display) and eq-response-restricted.
- I defined P, G and a after eq-response-smith-hazel, and beta_k and x_k after eq-response-genic.
- I replaced "the equation above" with @eq-response-breeders, "the covariance term above" with @eq-response-ld, and "the equation suggests" with @eq-response-breeders. @eq-response-genic is now cited at the per-locus ratio paragraph.

Callouts (sect. 4)
- "What is genuinely new in this book, then": callout-note became callout-important, because it states the book's design (the restricted direction is gene diversity).

Text (sect. 5)
- DE is expanded at first use (callout-warning) as "differential evolution (DE) selector".
- "Kempthorne and Nordskog restricted" became "@kempthorne1959 restricted", replacing a hand-typed citation.

I ran `Rscript book/scripts/make_downloads.R`, which regenerated book/downloads/02b-response.R. No render.

## 2. Findings for quant-writer / quant-Rwrite

- 02b-E1 book/02b-response.qmd:100 -- The `response-replicated` chunk outputs a table but has no `tbl-` label. I could not add one without renaming the label, which the brief forbids. Rename it to `tbl-response-replicated` and add a tbl-cap: "Over 30 seeds of the same simulate_pools() call: mean, s.e., min and max of the relative gap 1 - realised/predicted, the realised intensity and the index skewness." Then cite it at "the next chunk repeats" (l. 95-96).
- 02b-E2 book/02b-response.qmd:169, 191, 248-265 -- `response-genic`, `response-hybrid-var` and the GCA/SCA identity chunk print named vectors as raw console output. Either wrap them in fmt(data.frame(...)) with tbl- labels or hide them with `#| results: hide` and quote the values inline. This is a code change.
- 02b-E3 book/02b-response.qmd:58, 72-77, 360-362 -- Table headers are R identifiers: sigma_A, i_normal_theory, R_with_realised_i, R_from_regression, index_skew, w_yield, gain_in_restricted_trait. They need readable headers through `col.names`/`setNames`. The names are built inside data.frame(), so changing them is a code change.
- 02b-E4 book/02b-response.qmd:293 vs 252 -- $H$ means the aggregate genotype a'g (Smith-Hazel) and also the heterosis value heterosis_value(X, d) in the GCA/SCA section. One of the two needs renaming.
- 02b-E5 book/02b-response.qmd:52-, 293- -- $\mathbf{G}$ here is the trait genetic covariance matrix. book/90-notation.qmd reserves $\mathbf{G}$ for the VanRaden relationship matrix. A distinct symbol (e.g. $\boldsymbol\Sigma_G$, with $\boldsymbol\Sigma_P$ for P) or an explicit local-scope note is needed, and 90-notation should record it.
- 02b-E6 book/02b-response.qmd:341 -- $r$ is used both for accuracy (eq-response-breeders) and as the number of restrictions ("t x r matrix"). $t$ (number of traits) is not in 90-notation either.
- 02b-E7 book/90-notation.qmd (Response to selection table) -- These symbols are missing: $\mathbf{P}$, $\mathbf{G}$ (trait covariance), $\mathbf{C}$, $b$ (regression of value on index), $S_I$, $q$/$z$/$\varphi$ (intensity formula), $p_{Ak}$, $p_{Bk}$ and $u_{Ak}$ (the 0/1 line allele; $\mathbf{u}$ is GEBV in the notation file), and $H$. Notation writes $V_{genic}$ but the chapter writes $V_{\text{genic}}$, so one form should be chosen.
- 02b-E8 book/90-notation.qmd:352-354 -- The note says $R = i r \sigma_A$ "runs above the realised response in a structured hybrid population -- see @sec-response". That contradicts the revised chapter, where the 30-seed mean gap sits within 2 s.e. of zero. It needs rewording (scientific claim).
- 02b-E9 book/02b-response.qmd:95-96 -- "the next chunk" is an informal forward reference. It resolves once E1 gives the table a label.
- 02b-E10 book/02b-response.qmd:220-230 -- The callout-warning title is "The frequency-based metrics cannot see the disequilibrium term". The callout fits "trap that produces a wrong number" only implicitly. The writer should confirm the type, or say in the body which number goes wrong (a flat-GD reading taken as flat V_A).

## 3. Orphaned figure files

None. The chapter has no figures. The new labels apply to table chunks only, so no PNG is renamed. After the next render, the chapter's freeze entry (book/_freeze/02b-response/) will be regenerated because the source changed.
