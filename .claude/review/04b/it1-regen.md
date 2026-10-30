# 04b -- iteration 1, regeneration of the two unwritten tables (04b-R1/D1)

Worktree `/Users/ederdbs/Documents/SB_quanti_gen-review`. Files changed:
`inst/scripts/run_mabc.R`, `book/data/mabc_index_comparison.csv`,
`book/data/mabc_allocation_recheck.csv`. Chapter prose and R/ untouched; no render.

## Script changes (inst/scripts/run_mabc.R)

- `INDEX_KEYS <- c(script = "rec_bg", drag = "rec_drag")`: the chapter's labels are kept, and
  now map to R/08 strategy keys explicitly (written to a `strategy` column). This makes the
  chapter's claim "script = rec_bg" true by construction (it was uncheckable before, D1).
- `paired_cell(n_sched, k, s, R, seed, map, w, opt)`: one cell, both indices on common random
  numbers. `set.seed(seed)` draws R per-replicate seeds; for each replicate
  `set.seed(rs[rp])` immediately before `make_shared_ibd()`, and again before each index's
  `run_bc_program()` (same backbone, same starting RNG state for both arms). Summarised with
  the package's `summarise_reps()`; CP bounds with `cp_lo/cp_hi`.
- `run_index_comparison()` (experiment D) -> `mabc_index_comparison.csv`; cells k in {3,4} x
  N in {80,150,250,400}, s = 0.60, uniform schedule rep(N, 3). Cell seed
  `opt$seed + 1000*k + N`.
- `run_allocation_recheck()` (experiment E) -> `mabc_allocation_recheck.csv`; k = 3, s = 0.60,
  schedules 300/40/20, 120/120/120, 20/150/190, 40/120/200, 200/120/40 (total 360). Cell seed
  `opt$seed + 1e6*bc1 + 1e3*bc2 + bc3` (unique while each size < 1000, asserted).
  **Index choice:** this table is explicitly an index comparison (two blocks), so both indices
  are kept; the drag (rec_drag) block is the main-strategy evidence.
- New options in `DEFAULT_OPT`: `idx_genes, idx_N, idx_s, idx_rep = 1000, recheck_genes,
  recheck_rep = 1000, recheck_sched`.
- CLI: `--only=index_comparison,allocation_recheck` runs only those targets (no full scan) and
  writes `mabc_<target>.csv` into `--out`. Header documents
  `Rscript inst/scripts/run_mabc.R --out=book/data --only=index_comparison,allocation_recheck`.
  run_mabc.R is now the writer of all six `book/data/mabc_*.csv`.
- New self-check T15: `paired_cell` returns `identical()` output regardless of prior RNG state.
  Header updated to "36 checks".

Columns: old columns kept, same names and order of the cited ones; added
`strategy, s, n_rep, seed, ibd_sd, p_lost, p_ibd` (index file also gets them; recheck adds
`bc1, bc2, bc3, k`). The chapter's `reshape()` calls subset explicit columns, so they still work.

## Cost

Measured per paired replicate (both indices): 4-12 ms (k = 3/4, N = 80-400), 5 ms for a 360-plant
schedule. Extrapolated ~70 s + ~25 s at 1000 reps. Measured: index_comparison 58.6 s,
allocation_recheck 25.4 s (84 s total, one core). O(R * sum(n_sched) * m), m = 344.
Replicates raised 300/250 -> 1000 (CP half-width <= 0.031 at any p).

## Old vs new: numbers the chapter cites

| Where (04b qmd) | Quantity | old | new |
|---|---|---|---|
| 292 | IBD cost of drag index, pp (mean script - drag) | 1.1 (1.088) | 0.9 (0.924) |
| 294 | drag saved, cM | 19.2 | 18.7 |
| 296 | max P(both), k = 4, drag | 0.987 | 0.987 |
| 297 | N at that max | 400 | 400 |
| 299 | script, k = 4, N = 400 | 0.767 | 0.764 |
| 370 | worst schedule | 300/40/20 | 300/40/20 |
| caption fig-bc-index | replicates | "300" (typed) | 1000 (now `n_rep` column) |
| caption recheck table | replicates / s | not stated / typed 0.60 | 1000 / `s` column |

Not inline but in the displayed tables / R/08 docstring (select_parent): k = 3, N = 150:
0.813 vs 0.997 -> 0.812 vs 0.988; k = 4, N = 400: 0.767 vs 0.987 -> 0.764 vs 0.987.
Docstring "cost is 1.5-2 points of IBD": new range 0.26-1.19 pp (mean 0.92) -- still wrong (M4).

Other cells that moved beyond the old CI: index k = 3, N = 80, drag 0.930 -> 0.893
[0.872, 0.911] (old lo 0.895); k = 3, N = 250, script 0.860 -> 0.893.

Recheck, drag block (new, 1000 reps): 120/120/120 0.969 [0.956, 0.979]; 40/120/200 0.955
[0.940, 0.967]; 200/120/40 0.924 [0.906, 0.940]; 20/150/190 0.872 [0.850, 0.892];
300/40/20 0.681 [0.651, 0.710]. Old: 0.988, 0.940, 0.932, 0.876, 0.656.
Script block: 0.775, 0.749, 0.662, 0.632, 0.427 (old 0.772, 0.748, 0.680, 0.640, 0.448).

## Conclusions: what holds, what weakens

- Index ranking (drag > script) holds at every cell of both tables; the wall at k = 4 is still
  the index's (0.764 vs 0.987 at N = 400). Holds.
- D2: four genes at N = 400 under rec_drag are now **certified on the CP lower bound**
  (0.987 [0.978, 0.993], 1000 reps) -- but not at N = 250 (lo 0.901). The uniform scan's
  0.967 [0.906, 0.993] on 90 reps is consistent with it; the 1000-rep estimate is the precise
  one. The writer should cite `lo`, not the point estimate, and drop `which.max` on p_both.
- D11 "IBD constraint met in every replicate": `p_ibd` now in the table. False in the strict
  sense: k = 4, N = 80 has p_ibd = 0.976 (all of it gene loss, p_ibd = 1 - p_lost), and
  k = 3, N = 80, drag has p_ibd = 0.999 with p_lost = 0 (one replicate in 1000 kept the genes
  and missed 0.90). Defensible: "met in every replicate that kept the genes, but one".
- **Weakens -- "balanced wins under both indices"** (370): balanced 120/120/120 is still the
  best point estimate under both, but it no longer separates from 40/120/200: drag 0.969 vs
  0.955 (CIs overlap; unpaired z ~ 1.6), script 0.775 vs 0.749 (z ~ 1.4). The old drag gap
  (0.988 vs 0.940) was significant; at 1000 reps it is not. Schedules are not paired with each
  other (only indices are), so this is an unpaired comparison. Robust statement: balanced and
  mildly back-loaded are tied; front-loaded 300/40/20 is clearly worst; the extreme back-load
  20/150/190 clearly loses.
- D3 mechanism: the data still contradict "BC3 converts plants into drag reduction far more
  efficiently". The extreme schedules lose largely by losing the genes in their 20-plant
  generation: p_lost = 0.063 (20/150/190) and 0.057 (300/40/20); the unlinked closed form for
  20 plants at k = 3 is (7/8)^20 = 0.069. Under drag, 20/150/190 has p_ibd = 0.937 and
  p_both = 0.872 even though survivors are not worse on drag (61 cM vs 55 balanced).

## Checks

- `Rscript inst/scripts/run_mabc.R --test`: 36/36 pass, 3.3 s.
- `devtools::test()`: FAIL 0 | WARN 0 | SKIP 0 | PASS 487.
- Old tables kept for diff in the scratchpad: `old_idx.csv`, `old_re.csv`.
