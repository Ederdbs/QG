VERDICT: APPROVED

PREVIOUS IDS
- 04c-D1 -- CLOSED -- book/04c-alphasimr-pipeline.qmd:247-258 states only (i) the build mechanism (separate html.json/typ.json executions, each calling the founder draw again; verified: book/_freeze/04c-alphasimr-pipeline/execute-results/ holds html.json 04:55 and typ.json 04:57, and Step 8 calls alphasimr_founder_pools() at :1453/:1528/:1908), (ii) that coincidence of two runMacs2() draws is "not established here" (one runMacs() pair per render, runMacs2() unmeasured), (iii) that founder-dependent numbers "may" differ, and (iv) a rule of practice (no conclusion on a statistic near a critical value). "Differs", "re-execution of either" and "what was measured is..." are gone. No contradiction with the callout's "Not established" (:229-233), with :1480-1482 and :1769 (runMacs2 not tested), or with the asserted chunk facts (stopifnot on R stream, no assertion on ma vs mb).
- 04c-M1 -- CLOSED -- :1757-1763 is conditional ("If the founders differ ... could fall on either side"), scoped to "no inference drawn in this paragraph", and says the render's wording and counts do depend on it. cov_t_crit/t_bonf_sweep are inline R, defined at :1634/:1640.
- 04c-M2 -- CLOSED for :205-207 (mechanism sentence removed; text keeps only the identical .Random.seed assertion and its consequence). See residual observation M3 below.
- RC-1..RC-5 -- unchanged from it5 (RC-1 closes with D1).

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
- 04c-M3 book/04c-alphasimr-pipeline.qmd:305-307 -- "the MaCS call leaves R's stream where a fixed number of sample.int() calls leaves it" is the same unsourced mechanism as M2, in another place. The chunk only shows rs_ma == rs_mb, not equality with any sample.int() count. Not decisive (nothing downstream depends on the sample.int() count; only on stream equality after the pair). Alone does not reject.

WHAT WAS VERIFIED
- Freeze entries: ls -l of book/_freeze/04c-alphasimr-pipeline/execute-results/ -> html.json (Nov 12 04:55) and typ.json (04:57), distinct files; both parse as JSON with keys hash/result.
- Callout text read in full (:220-262), chunk :163-198 (stopifnot at :176-177, no ma-vs-mb assertion), covariance paragraph :1748-1763 and chunk :1625-1645, Step 8 statements :1476-1482 and :1769.

NOT VERIFIED
- Rendered output: not rendered by instruction; the frozen results still hold pre-edit text. Text-level check only.
- Whether the HTML and PDF of the next render differ; the text no longer depends on it.
