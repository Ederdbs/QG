# Iteration 3 verdict, chapter 04 (form pass only)

VERDICT: APPROVED

Scope: form-pass diff (editor.md, editor-response.md). The it2-approved text was never committed or copied, so no literal `git diff` against it exists; the form pass was judged by reading every edit the editor lists in the current chapter and re-running the chapter. Every number the it2 verdict recorded was reproduced.

PREVIOUS IDS
- 04-D1..D6, 04-M1..M17 -- remain CLOSED; no text bearing on them changed (numbers below reproduced).
- 04-M18..M21 -- unchanged status (non-decisive, carried).
- Editor E1, E2, E3, E5, E7 (fixed): accepted, see below. E4, E6 (not assigned): need the rendered PNG/PDF, non-decisive, carried. E8 (part), E9, E10 (contested): rulings below.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
- 04-M22 (form, owner quant-editor) 04-E4 and 04-E6 (legend overlap in fig-sizing-ancestry; wrapping of tbl-sizing-saturation / working-numbers in Typst) remain unchecked: no render was run. Not a content failure.
- 04-M18 and M19 unchanged (qmd:1129-1131 "show"; single seed of the distortion arm).

RULINGS ON CONTESTED ITEMS
- E9 (callout-warning on "The distorters are plausible, not measured"): UPHELD as is. Form/design choice; the callout warns of a trap that yields a wrong field-area number; `callout-warning` is used in 17 chapters for the same purpose. No content effect.
- E10 (tbl-sizing-f1 uses formatC(digits=3, "g"), saturation uses fmt_ms): UPHELD. The f1 caption declares "three significant digits"; fmt() rounds to decimals and would show 0.001 and 0 at n = 20 (1000*0.5^20 = 0.00095), contradicting the caption. formatC is consistent with the stated rule. Differing precisions in tbl-sizing-saturation are per-quantity and changing them would change displayed numbers.
- E8 (n_final): UPHELD. grep: n_final occurs only in code (qmd:491) and inline `r` expressions (533, 535), never as a symbol in prose; needs no notation row. n_rep row added to 90-notation (chunk runs, vectors aligned); `c` is defined in the caption of tbl-sizing-f4-identities; `m` left, no prose use in this chapter conflicts. Minor: the n_rep row says "(the n_rep column of the cached grid)" while the symbol is also used for live arms (n_rep_chk, 20-population arms); not a failure.

WHAT WAS VERIFIED
- Purled chapter (knitr::purl, run from book/, 34 s): no error, all stopifnot() pass, including the bridge asserts (GD = D/2, N_s = 1/(2 - D), GD_greedy <= bound) and the new distorter-table guard (k > 0.5 for gametic, w11 < w00 for zygotic).
- Split bridge table: printed `bridge` object. Table 1 (n_F2, D, theta, GD, Ns, fixed, bound): 30: 0.9648/0.5176/0.4824/0.9660/0/0.5; 120: 0.9852/0.5074/0.4926/0.9854; 480: 0.9877/0.5062/0.4938/0.9878. Table 2: GD_random (s.d.) 0.4543 (0.0079), 0.4531 (0.0084), 0.4507 (0.0099); GD_greedy 0.4787, 0.4870, 0.4881; GD and bound match table 1. Same values and same fmt(.,4) as before; GD_random_sd folded into "mean (s.d.)" (no value lost). Prose ranges (greedy 0.479-0.488, panel 0.482-0.494, random 0.451-0.454, N_s 0.966-0.988) agree.
- Captions of tbl-sizing-bridge and tbl-sizing-bridge-subsets match their columns and parameters (n_sub = 10 guard, 200 subsets, seeds 3 + N and 100 + n_F2); "asserted in the chunk that builds @tbl-sizing-bridge" is true (stopifnot in that chunk).
- tbl-sizing-distorters caption (type, chr, position, k = P1 transmission through male gamete, w00/w01/w11, placeholder labels) against `f2_distorters` printed and roxygen/comments in R/06_f2size.R:44-55: accurate; cited in SA5 and consistent with "all three act against P2".
- Reproduced it2 numbers: distortion arm 0.752 (0.013) vs closed form 0.831; D N90 bracket 70-110; min(p,1-p) bracket 30-350; k = 3 first crossing 50, k = 5 270, k = 8/10 not reached (0.293, 0.057 at 390); het table F2 0.497, F3 0.254, F4 0.127.
- Cross-reference edits (grep of all @tbl-/@fig-/@sec- targets in the chapter): tbl-sizing-twin (484), fig-sizing-multilocus (726), fig-sizing-diversity (541), @sec-era-programme (1078) all point to existing labels and to the object described; no prose number changed. n_rep column rename: caption/code consistent in verify-junctions, ssd-grid, bulk-vs-ssd; "s.e." labels in verify-het and steps match captions.
- 90-notation.qmd chunk executes after the n_rep row; downloads: make_downloads.R re-run leaves book/downloads/04-population-sizing.R byte-identical in diff stat (author's regeneration current).
- Scratch only; stray book/Rplots.pdf from my runs deleted; working tree otherwise as found.

NOT VERIFIED
- Literal diff against the it2 text (not saved); verification is by reading the listed edits and reproducing every it2 number.
- Rendered HTML/Typst PDF, figure legends (E4), table wrapping (E6), _freeze.
- Items listed in it2 NOT VERIFIED (refcheck UNVERIFIED citations, non-decisive; SA4 interference; sensitivity runs) unchanged.
