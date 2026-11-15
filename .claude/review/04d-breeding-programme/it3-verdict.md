# 04d-breeding-programme -- verdict, iteration 3

Text: book/04d-breeding-programme.qmd (1087 lines). Worktree: /Users/ederdbs/Documents/SB_quanti_gen-review-04-06.
Inputs: it2-verdict.md, it2-response.md, the chapter, Gaynor 2017 (pdftotext of reference/AlphaSimR_Course PDF), 04c:2160-2180, 04f:2092-2112, 11-plant-literature.qmd (462-466, 670-672, 683, 716).
Recomputed: the full chapter was run end to end (purl of the .qmd, working dir book/, 5 arms x 120 seeds + 48-seed neutral probe, 4 min 30 s, all stopifnot passed). Scratch: /private/tmp/claude-501/-Users-ederdbs-Documents-SB-quanti-gen/b21c3252-fade-4466-9e3d-6022a32fa781/scratchpad/it3/ (ch.R, ch.rda, ch.out, an.R, gaynor.txt).

VERDICT: APPROVED

PREVIOUS IDS (re-review only)
- 04d-D10 -- CLOSED -- GD_off = GD n/(n-1) is the right transformation (theta = 1/n + (1-1/n) theta_off for f_ii = 1; identity checked in the chunk on a 60 x 200 homozygous matrix and `diag(f) == 1` asserted for DH lines and for the founders). Recomputed independently from ch.rda: relative loss against the founders on GD_off ps PYT 0.2556 (0.2492 with the diagonal), ps parents 0.2243 (0.2541), gs PYT 0.3007 (0.2948), gs parents 0.2853 (0.3128); founders GD 0.4875, GD_off 0.5000; year-1 GD_off PYT 0.4761, parents 0.4731; year-1 loss columns identical under both versions (ps PYT 0.218, parents 0.180, gs 0.266 / 0.245; asserted). Founders-to-parents gap 0.0269 on GD_off against 0.0440 with the diagonal; diagonal weight 0.0171 (per seed and on the means). The writer is right and my 0.019 in it2 was a slip. The text prints what the chunk computes. The remaining with-diagonal levels (arm table, ledger) are labelled as not on one scale; within a column n is constant, so contrasts between arms are unaffected by the factor (1 - 1/n).
- 04d-D11 -- CLOSED -- (a) 04c:2172-2174 no longer quotes 04d: it states in 04c's own words that 04d measures against its year 1 or its founders and has no random-parent arm, and its control truncates on phenotype; all of that is in 04d (no reference distribution of random subsets, "A random-parent arm ... is not built here", ctl = phenotype truncation). (b) 04f:2101-2105 now says a replicate in 04d is an independent draw of plot error only and the GxE deviate is one draw per phenotyping call shared by all entries, so its replicates are not locations: agrees with 04d (msq 0.2016 at reps 1 and 0.2001 at reps 8 in my run; division by reps would give 0.0252). 04d adds no random-parents or no-selection arm (arms ps, l1, l2, gs, ctl in `programme-design`; it says so in the Selection-or-bottleneck section and in the Assumptions), so the 04c random-arm sentences (04c:2168-2176, 2291, 2352) stay true. No other chapter quotes 04d numbers (grep of README, 00, 04g, 90-93: pointers only).
- 04d-M8 -- CLOSED -- line 31-33: replicates are no longer called locations; the course's term is flagged and sent to the `reps` section.
- 04d-M9 -- CLOSED -- bootstrap over seeds (the unit of replication), my own stream (seed 99, 4000): gs/ps 1.511 (1.456-1.568), l2 1.465 (1.418-1.513), ctl 1.320 (1.278-1.362); l2 ratio minus L ratio 0.192 (0.144-0.241), ctl 0.0169 (-0.025-0.059). Printed in the chapter: 1.51 (1.46-1.56), 1.46 (1.42-1.51), 1.32 (1.28-1.36), 0.19 (0.14-0.24), 0.017 (-0.025-0.059). Same conclusion; the two `stopifnot` tie "excludes zero" / "includes zero" to the render. The intensity caveat (16 of 76 against 16 of 16) is in the text.
- 04d-M10 -- CLOSED; the contest is upheld, the writer is right and I was wrong. On the PDF text each page ends with its running footer and the next begins with the Wiley banner: the footer "2382" is line 591 and the banner of the next page line 592, "2383" is line 649. "Optimal contribution theory (Woolliams et al., 2015) and introgression of new genetic variation are well established solutions for averting decline of genetic variance" is line 549-551, inside the 2382 page; the Bulmer paragraph ("Increased selection accuracy results in the Bulmer effect ...", factors "effective population size, selection intensity, selection accuracy, and the number of cycles per year") is line 596-603, inside the 2383 page. The p. 2385 remark I cited is a different sentence. The chapter now gives OCS p. 2382 and Bulmer p. 2383, the "length of the cycle" attached to Bulmer is gone, and "often reported" is replaced by a statement that claims no source. Quoted factors match the paper.
- 04d-M11 -- CLOSED -- ledger cells carry s.e. (checked in ch.out: e.g. year-15 PYT 0.3660 (0.0020) ps, 0.3438 (0.0030) gs). Neutral probe recomputed: neutral share ps 97.2 % (my bootstrap 95.5-99.1), gs 94.6 % (93.0-96.1); printed 97 % (95-99), 95 % (93-96). Within-seed QTL minus neutral loss: ps 0.0061 (0.0021) t 2.92, gs 0.0142 (0.0022) t 6.43, difference of differences 0.0081 (0.0030) t 2.71; printed 0.006 (0.002) t 2.9, 0.014 (0.002) t 6.4, 0.008 (0.003) t 2.7. The sentence now says the loss is mostly, not entirely, shared with neutral loci and that the probe does not separate bottleneck from selection (linked neutral loci, different founders, 48 seeds).
- 04d-M12 -- CLOSED -- the chunk measures the mean squared departure directly: 0.2016 (reps 1) and 0.2001 (reps 8) in my run, printed 0.202 / 0.200, 0.025 if reps divided GxE; the text says the rank-one check shows only the shared per-call deviate.
- 04d-M13 -- CLOSED -- 11-plant-literature.qmd 462-466, 670-672, 683 and 716 now say a year-15 stock beside the arms' mean cycle lengths, not a per-cycle or per-unit-time rate, and not hybrid maize; consistent with 04d lines 9-14 and 1031.

Earlier IDs D1-D9 and M1-M7: unchanged text, results reproduced again in this run (gain 0.0575 / 0.0661 / 0.0842 / 0.0869 / 0.0759; L 4.25 / 4.25 / 3.34 / 3.35 / 3.26; pooled gs - ps GD_PYT -0.0222 (0.0035) t -6.4, batch t -2.83 -1.31 -4.77 -1.72 -4.34; ctl - l2 GD_PYT +0.0009 (0.0040) t 0.23; neutral probe gs - ps +0.044 (0.014) QTL, +0.036 (0.014) neutral, t 3.2 and 2.6). Remain closed.

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS
- 04d-M14 book/04d-breeding-programme.qmd:408 -- states as fact that @sec-alphasimr's Step 8 `runMacs2()` founders "are not reproducible"; 04c:229-232 says this was not tested. USER DECISION, carried from iteration 2, reported only. The chapter's own argument needs only `quickHaplo()` determinism, which the chunk asserts (years 1-5 identical in 600/600 runs). Not counted towards rejection.
- 04d-M15 `tbl-programme-arms`, `tbl-programme-ledger` -- levels are still on the with-diagonal GD, so the GD_PYT and GD_par columns (n = 60 and 16) are not comparable by level; the captions and text say so. Legitimate as written; a reader may still compare them. Non-counted.

Two non-disqualifying observations in total (M14 is a user decision, M15 is cosmetic): below the threshold of three.

WHAT WAS VERIFIED
- Full chapter run, 4 min 30 s, no error, every `stopifnot` passed (identical years 1-5 for four arms x 120 seeds, identical(ps1, ...), rank one, msq ratio > 0.5, bootstrap interval signs, probe t > critical, QTL = segSites, diag f = 1, GD_off identity, year-1 loss equal under both versions).
- GD_off columns and the 0.017 diagonal share: an.R on ch.rda, values above (founders 0.48753 / 0.50003; yr-1 0.47609 / 0.47309; gap 0.02694 vs 0.04401, diff 0.017067).
- Bootstrap ratios and intervals (seed 99) and probe statistics (seed 77): values above, agree with the chapter within resample noise in the third decimal.
- Gaynor pages 2382 (OCS) and 2383 (Bulmer) by line position of running footers in the pdftotext output; 2.36 / 2.47 (p. 2379 page), "major driver" (p. 2381 page).
- Table values of the arms, contrasts, batches, ledger and loss tables read from ch.out against the chapter's prose.
- 04c:2168-2176, 04f:2101-2105 and 11 edited rows read; grep for "random-selection baseline" and "locations as independent": the only hit is the new 04c sentence.
- Dispersion and pairing: the unit is the seed throughout; arms are analysed as paired differences; bootstrap over seeds; probe on its own 48 seeds, with its limits declared.

NOT VERIFIED
- Meuwissen et al. (2001) beyond its abstract -- full text not available; the chapter scopes its use to the abstract clause and says the full text was not consulted. Non-decisive.
- MaCS statements about `runMacs2()` -- not tested; user decision (M14).
- Rendered HTML/PDF and `_freeze` -- not rendered by me; the response says they are stale. The code and text were verified from the knit of the source.
- The 24-seed quick variant -- not used; no claim here rests on it.
