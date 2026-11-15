# 04b-backcross-introgression -- iteration 3 verdict (form pass + M9/M11 only)

VERDICT: APPROVED

PREVIOUS IDS
- 04b-M9 -- CLOSED -- qmd:1078-1084 now says: at s = 0 the IBD criterion binds as well; linkage drag does not stop binding at s = 0; the table measures IBD alone, under rec_drag; the joint criterion at s = 0 was not run, so IBD is added, not substituted. That agrees with the chapter's own scope statement (qmd:432-440) and with my it2 run (at N = 200 drag still binds at s = 0). No new number.
- 04b-M11 -- CLOSED -- pointer is now `max_use` of @sec-choosing and @sec-combinatorial, with @sec-ocs named for the continuous `upper` cap. grep: max_use 3 in 07, 7 in 10, 0 in 09; 09:362-366 describes the `upper` cap as the continuous analogue of the usage cap of 10.
- 04b-M10 -- note, unchanged, limit declared in the text (qmd:1180-1183).
- All it2 CLOSED items stay closed; nothing in the text they rest on moved (see Verified).

DISQUALIFYING FAILURES
None.

NON-DISQUALIFYING OBSERVATIONS (1 failure + 1 note; below the threshold of three)
- 04b-M12 qmd:869 (tbl-bc-dragcmp caption) -- "drag in cM at BC3 of the programme above" invites a match with tbl-bc-traj, but the two use different meiosis seeds (6 vs 7). Under rec_drag tbl-bc-traj gives 60.0 cM at BC3 and tbl-bc-dragcmp gives 45 cM (rec_bg 70). Both captions state their seed and "one replicate, illustrative", so no claim is wrong; the shared label "the programme" is loose. Not disqualifying.
- 04b-M10 (note) as above.

RULINGS ON CONTESTED EDITOR ITEMS
- E4 (mabc_sizing.png / mabc_policies.png label size): form of a static figure; belongs to quant-editor, not a criterion of mine. Contest accepted as deferral. Not counted. It remains an open form item for the figure pass; I did not measure the printed font size.
- E7 (callout-important vs callout-warning for the repulsion scope limit): judgement. The callout states an applicability limit of the model, and the text under it says the model does not describe that case; no content failure either way. Contest upheld.
- E8 (fig-bc-flow colours): palette convention, form. The colours encode role (elite, donor), not pool, and no text claim depends on them. Contest upheld; not counted.

WHAT WAS VERIFIED
- Diff basis: git cannot give the it2 text (HEAD is the pre-review chapter; it1/it2/it3 edits are all uncommitted, no it2 snapshot exists). I read the whole chapter (1214 lines) and compared its numbers with those I recorded in it2-verdict.md.
- Chapter code: `knitr::purl` (documentation = 0), then `pkgload::load_all("..")`, sourced from `book/`: "OK elapsed 11.8 s"; every stopifnot passes (MB vs mabc_opt, f2 replicate counts, n_for_count survival, tbl-bc-psame equality with p_same_segment, tbl-bc-sizing-live == mabc_analytical_sizing.csv, s0 upper limits < 0.95, conversion ratio asserts, IBD identities).
- Numbers unchanged against it2 record: tbl-bc-s0 P(IBD) s = 0: 0.532 [0.487, 0.576] (N 60), 0.782 [0.743, 0.817] (200), 0.822 [0.786, 0.855] (400); s = 0.6: 0.932, 1.000, 1.000; p_lost 0.088/0/0 and 0.068/0/0. tbl-bc-conversion-cost: GD 0.0231, 0.0548, 0.4383.
- New/recast tables: tbl-bc-traj (pr$traj, columns gen, ibd, dose, drag, n_fg, ibd_pop_mean, fail match the caption and R/08_mabc.R:472-473, 490-492); tbl-bc-dragcmp (rec_bg 70, rec_drag 45, seed 7); tbl-bc-sizing-live (sizing_table names identical to mb_sz, asserted equal); tbl-bc-psame (asserted against the closed form). tbl-bc-recheck: built directly from mabc_allocation_recheck.csv, only the index label renamed (script -> rec_bg, drag -> rec_drag); the 10 rows (5 schedules x 2 indices) are consistent with the prose (rec_drag 120/120/120 0.969 [0.956, 0.979], 40/120/200 0.955; 20/150/190 p_lost 0.063; 300/40/20 0.681) and the in-chunk z asserts pass.
- Cross-references: every @tbl/@fig/@eq/@sec cited in the chapter has exactly one definition (27 local labels, no duplicates); external labels exist (sec-hp-ibd 00, sec-coancestry 01, sec-baseline 06, sec-choosing 07, sec-ocs 09, sec-combinatorial 10, sec-sizing/-verify/eq-sizing-n95/tbl-sizing-saturation 04, sec-era-programme 05, sec-hp-cycle/tbl-hp-stages 00). The four new tables are cited before their chunk. New heading ids sec-bc-model, sec-bc-fixation, sec-bc-connects resolve.
- 90-notation: n_keep row added, both vectors have 14 entries; the symbol is used in the chapter as in the row (3 homozygotes).
- fig-bc-f2 legend at "bottomright": rendered the chunk code to a scratch PNG (scratchpad/f2.png); the legend clears all curves and points.
- Captions that quote numbers (cap_fg, cap_fix, cap_recheck, cap_f2, cap_pol, cap_idx) are computed from the data; no hard-coded result introduced.

NOT VERIFIED
- HTML/Typst render, `fig-alt: !expr` in YAML, and the visual placement of the new tables in the PDF: no render run (as in it2). Not decisive for the claims.
- Rodgers-Melnick et al. (2015), Lu et al. (2002), Haldane (1919) page attribution: as in it2 (rest on it1-refs.md; chapter states its own limits). Not decisive.
- Printed legibility of mabc_sizing.png / mabc_policies.png (E4): not measured; form, quant-editor.
