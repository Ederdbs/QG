# Audit 02b-response -- iteration 1

Scope: book/02b-response.qmd (271 lines), R/15_response.R, book/_common.R, the called
functions in R/05, R/09, R/13. Frozen outputs (book/_freeze/02b-response/execute-results/html.json)
re-run against the worktree with pkgload: every printed number reproduces (pred 5.908, real 5.116,
skew -0.170, genic 25.205, gap -2.721, shares 0.238/0.228/0.535, b_u 0.5703/0.5156, b_r -0.1207/0.3621).
Freeze is current. Verification script: scratchpad a02b.R (not in repo).

## Findings

### 02b-R1 (major, science) -- the overprediction is sampling noise, not a property of the population
book/02b-response.qmd:56-57, 73-76, 78-84, 86-94.
Prose: realised intensity is low because the index is left-skewed ("a property of *this*
population, not an error"); the regression gap is a failure of bivariate normality in a two-pool
population; the callout says the gap "is not noise and does not shrink with more markers" and to
read the equation as an upper bound.
Evidence:
- Same chunk, residual e = gv - b*I: mean(e[sel]) = -0.546, naive SE sd(e)/sqrt(60) = 0.436,
  z = -1.25 (and hybrids sharing parents make the true SE larger).
- Finite-N expected intensity (4000 draws of the top 60 of 625 normals): 1.7706, sd 0.066;
  observed i_real 1.701 is ~1 sd below. Also line 73 "exact for a normal criterion" holds only
  for an infinite population.
- Same simulate_pools() call over seeds 1:30: regression prediction > realised in 60% of seeds,
  mean relative gap 0.9% (SE 1.2%); index skewness mean -0.001 (range -0.29..0.24). Seed 1 is an
  unlucky draw, not a structural bias.
- "does not shrink with more markers" is asserted, never computed.
- Contradicts @sec-alphasimr (04c-alphasimr-pipeline.qmd:740-795), which replicates 20 draws and
  finds the equation unbiased with near-normal intensity.
Fix direction: replicate over seeds (or report the SE) before attributing the gap; drop the
"upper bound" callout or support it with a replicated, inline-computed number.

### 02b-R2 (major, science) -- V_genic is NOT sum beta^2 p q "up to a coding constant" in hybrids
book/02b-response.qmd:122-127, and 258-259.
For a hybrid x_k = (u_A + u_B)/2 of inbreds from two pools, Var(x_k) = (pA qA + pB qB)/4 =
p q / 2 - (pA - pB)^2 / 8. Verified on the chapter's own X: max deviation 1.5e-15 for both forms.
The ratio Var(x_k) / (p_k q_k) ranges 0.107..0.501 across loci (cor 0.94, not 1);
genic_var = 25.21 vs sum beta^2 p q / 2 = 27.92. The missing term is exactly the between-pool
divergence (the GD_BS / F_ST piece), so the "same sum, weighted differently" sentence fails
precisely where the book's populations live. Line 258-259 ("a diversity constraint is a variance
constraint in disguise") overstates further and contradicts the chapter's own lines 129-140.

### 02b-R3 (major, numbers) -- the example G is not a covariance matrix
book/02b-response.qmd:197. G = [[2.0, 0.9], [0.9, 0.3]]: eigenvalues 2.388, -0.088;
implied genetic correlation 0.9 / sqrt(2.0 * 0.3) = 1.16. Every Smith-Hazel and restricted
weight printed (lines 200-202, 231-236), including the negative restricted yield weight -0.1207,
is computed on an impossible G. (P - G is PD: eigenvalues 2.066, 0.634; only G is wrong.)
Pick a G with |r_g| < 1 and re-derive; add stopifnot(all(eigen(G)$values >= 0)).

### 02b-R4 (major, science) -- wrong condition for b proportional to a; contradicts the package
book/02b-response.qmd:205-207: "They coincide only when P^-1 G is proportional to the identity,
which requires the traits to be equally variable, equally heritable and mutually uncorrelated."
R/15_response.R:62-70 already states the correct condition: b ~ a iff a is an eigenvector of
P^-1 G; G = c P suffices and says nothing about equal variance or zero correlation.
Counterexample with the chapter's own P: index_smith_hazel(P, 0.5 * P, c(1, 1)) = (0.5, 0.5),
with traits of variance 4 and 1 and covariance 1.2. "Proportional to the identity" is also not
necessary (eigenvector of P^-1 G suffices).

### 02b-R5 (moderate, science) -- "No metric in this book can see the disequilibrium term" is false
book/02b-response.qmd:133-140. eff_dim() (R/01_metrics.R:275, exported, in metrics_full) is the
participation ratio of the double-centred f, whose nonzero spectrum is the marker covariance
spectrum -- a multilocus quantity. Test: permute each column of the chapter's X independently
(all allele frequencies identical, max |colMeans diff| = 0, theta identical 0.67191) ->
eff_dim over all 625 hybrids goes 46.6 -> 451.9. The listed metrics are single-locus; the
callout title and "no metric" are not. Restrict the claim to the listed metrics or to the
constrained/cheap ones, and note that eff_dim sees LD but unweighted by effect.

### 02b-R6 (check 3) -- identities asserted in prose, printed but not stopifnot()-ed
- :78-80 "agree to machine precision", b S_I == i r sigma_A (difference exactly 0 here) --
  displayed only through fmt(..., 3).
- :105-118 Var(X beta) - V_genic == 2 sum_{k<l} beta_k beta_l Cov(x_k, x_l) -- chunk prints
  oracle_deviation 1.07e-14 against ref_genic_var but asserts nothing, and never checks the LD
  identity itself (my check: deviation 2.2e-14).
- :164-170 reconstruction and "orthogonal, so their variances add exactly" -- printed
  (5.1e-13, 9.2e-14), no stopifnot; pairwise covariances gA/gB/sc are 1e-16..4e-16, also unasserted.
- :239-240 "moves the restricted trait by exactly zero" -- shown only as 0.000 after rounding to
  4 dp; actual R'G b_r = 2.1e-17. Needs stopifnot(abs(...) < 1e-12).

### 02b-R7 (check 1) -- hand-typed numbers
- :11-15 "after eight cycles", "arrives at cycle 8": book/data/cycles_crossover.csv gives a
  crossover of 5..12 (alpha 0.02) and 9..15 (alpha 0.005) across seeds; 8 is seed 1 at alpha 0.02.
  Read it inline from that file or drop the number.
- :252 "A sixty-year-old theorem" (also R/15_response.R:12-13 "sixty year old"): 1959 -> 2026 is
  67 years; compute or say "1959".
- :215 "five percent" is an illustrative quotation, not a result -- not a finding.

### 02b-R8 (minor) -- "has never once been used to compute a response" is false
book/02b-response.qmd:41-42. usefulness_criterion() (R/05_pipeline_metrics.R:279) is
mu + i h sigma, documented with i from sel_intensity(); 08-pipeline-stages.qmd:219 calls it so;
04c-alphasimr-pipeline.qmd:751 uses sel_intensity() in a replicated breeder's-equation sweep.
Also "since @sec-stages" points forward (chapter 08 follows 02b in _quarto.yml).

### 02b-R9 (minor) -- plain-text citations with bib entries available
book/02b-response.qmd:191, 217-218, 247. references.bib has smith1936, hazel1943,
kempthorne1959; use @keys so they render and appear in 99-references.

### 02b-R10 (minor, clarity) -- the GCA/SCA shares are of a toy dominance trait, not of gv
book/02b-response.qmd:145-183. The section opens on additive variance of breeding values, then
decomposes H = heterosis_value(X, d) with d ~ N(0.3, 0.1) drawn ad hoc -- a dominance-only value
that shares nothing with gv = X beta used everywhere else. "sca = 53.5%" is the SCA share of
that heterosis, not of hybrid genetic variance; the additive effects beta are absent from H.
State it, or decompose gv + H.

## Checks with no finding
- Check 2 (seeds): simulate_pools(seed = 1) seeds internally (R/09_reference.R:29);
  set.seed(7) at :152 sits immediately before rnorm(); no AlphaSimR. None.
- Check 4 (reads): the chapter reads nothing from disk. None.
- Check 5 (exports): simulate_pools, sel_intensity, genic_var, ref_genic_var, heterosis_gca_sca,
  heterosis_value, index_smith_hazel, index_restricted all exported (NAMESPACE) and the installed
  bodies are identical to the worktree (deparse comparison, 8/8 TRUE). No install needed. None.
- Check 6 (chunks/figures): no chunk was changed in this iteration; the chapter produces no
  figures (no docs/02b-response_files/, no figure-* dirs in _freeze). Any fix adding a chunk
  orphans nothing. None.
- Verified correct: Smith-Hazel b = P^-1 G a matches a numerical maximiser of cor(H, I)
  (proportional to 6.8e-5, optim tolerance); index_restricted equals the null-space oracle
  b = N (N'PN)^-1 N'Ga (deviation 1.1e-16) and the K&N formula at :222-224 matches the code;
  genic_var vs ref_genic_var 1.07e-14.
