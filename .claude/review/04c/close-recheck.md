# 04c-alphasimr-pipeline -- close re-check against the new render

RESULT: REOPENED -- 04c-E3 only (figure form, editor's domain). No disqualifying criterion fails. Every
hand-written qualitative claim and every conditional verdict in Step 8 holds on the new draw.

Inputs: docs/04c-alphasimr-pipeline.html (06:19) and book/_freeze/04c-alphasimr-pipeline/execute-results/html.json
(06:17), which agree (6.244, 0.156, 14.972, 1.64, -0.0037, 0.587 and "within the two-sided" each appear in the JSON).
Also figure-html/fig-alphasimr-cycles-1.png (06:16). Rendered Step 8 text: scratch step8.txt.

## Step 8 claims against the new draw
- F_ST and GD_BS rise, with each step many s.d. wide: F_ST 0.021/0.044/0.260/0.568, s.d. <= 0.014; GD_BS 0.007/0.013/0.078/0.187, s.d. <= 0.007. HOLDS.
- The heterosis divergence share rises (0.021 -> 0.365). HOLDS.
- GD_T is not flat. It dips and then rises: 0.310, 0.302, 0.299, 0.330. The rise from 100 to 1000 is 16 s.e. HOLDS.
- The rise comes entirely from fixed-difference sites, and every other site falls: GD_T_other is monotone at 0.310 -> 0.302 -> 0.294 -> 0.236, while GD_T_fixed goes 0 -> 0.094. HOLDS.
- The three-term identity: 0.479 + 0.052 + 0.006 = 0.537, and 0.248 + 0.053 + 0.002 = 0.303. HOLDS.
- The ratio rises (t = 6.2) and cor_perse_GCA falls (0.953 -> 0.909, t = -5.7). Both are below Step 6's 0.997. HOLDS.
- The split-0 identity: 1 - 2(0.229) = 0.542, against 0.098. HOLDS.
- Branch "fall of the additive part": add-only gives 0.17 and dom-only gives 0.098, so the branch resolves correctly. GCA_var_dom changes by 0.001 (t = 0.1), which resolves to "not distinguishable". That fits "the ratio can rise without the dominance part growing at all". HOLDS.
- Covariance branch: max |mean|/s.e. is 1.64, below 2.09, so it resolves to "within ... at every split". The ratio contrast resolves to "beyond". HOLDS.
- Paired response: mean_tc_A t = 14.5, mean_tc_B t = 14.6, hybrid t = 15.0, so "is beyond". gd_elite_mean t = -6.6, gd_pool_mean t = -6.8, GD_BS t = +7.7, F_ST t = +7.5, and all resolve to "beyond". GD_BS is positive, so the "moving apart" conditional applies. HOLDS.
- The control loses diversity too: relative loss 0.506/0.500 in the control against 0.587/0.594 under selection, so "exceeds" resolves correctly. HOLDS.
- mean_tc pooling buys little: cor 0.89, sd_pooled 1.145 against sd_A/sd_B 1.198/1.158 and 0.833 if independent. HOLDS.
- Per-draw ratio 0.9, so "a single draw does not settle its sign". HOLDS.
- gd_A and gd_B are asymmetric (t = -4.4 and -5.6), consistent with the text. HOLDS.
- Stage-2 paragraph: the ceiling is positive in this draw. Truncation alpha is 0.0011, and the DE rows for budgets 0 to 0.08 % sit at alpha -0.0037 with index 1.2743, below truncation's 1.2884. DE_alpha_0.11 equals truncation. The text frames the non-positive ceiling as "depending on the draw" and does not claim it here. HOLDS (as in it2 run b).
- Step 6 forward reference (:974-976, "Step 8 separates the two routes"): consistent with the above.

## 04c-M7 / 04c-M8 in this draw
- 04c-M7 BITES, in the same direction as it2 run b. cor_AB(gd_elite) = +0.156, and sd_pooled 0.020 is above the independent value of 0.019. "Close ... pooling does what it should" still holds loosely, since sd_A/sd_B of 0.027/0.026 fall to 0.020. The text still does not condition on the sign. It stays non-disqualifying.
- 04c-M8 DOES NOT BITE. The covariance resolves to "within the two-sided 5 % point at every split", so the following clause reads correctly.
- Accumulated M: still 2.

## Figure (fig-alphasimr-cycles-1.png)
- 04c-E3 -- REOPENED. Right panel ("Diversity erosion"), bottomleft legend: the lower whisker and cap of the cycle-3 "pool B elites, selected" bar (about 0.094) run down into the legend. The cap sits on the first legend row, "pool A elites, selected", and the legend text extends past cycle 3, so it no longer ends before the cycle-3 bars. The it2 closure was explicitly per draw ("placement fixed while ylim is data-driven"), and this draw breaks it. The left panel is clear: the cycle-3 bar sits to the right of the legend text, and cycles 1-2 sit below it. The figure does not contradict the text or caption (criterion 5 is not engaged), so this is a form defect for quant-editor.

## Side observation (form, not reopened)
- All tbl-subcap strings render literally in the HTML: backticks, `$...$`, `@caballero2002`, `@tbl-alphasimr-cycle1`, `@tbl-alphasimr-rep1`, and the new `*i r* σ~A~`. Markdown is not processed in knitr tbl-subcap here, so the post-approval edit to the breeders subcaption shows as raw `*i r* σ~A~`. It is not a contradiction. It is for quant-editor.

---

# Recheck 2 -- after the editor pass and a new MaCS draw

RESULT: CONFIRMED (approval stands). 04c-E3 is CLOSED. One new caption-math defect, 04c-E8, is recorded below. It is form only, for quant-editor, and does not reopen the approval.

Inputs: docs/04c-alphasimr-pipeline.html (06:29), execute-results/html.json (06:27), typ.json (06:29), and
figure-html/fig-alphasimr-cycles-1.png (06:27). Rendered Step 8 text: scratch step8b.txt.

## Step 8 claims against the new draw (all HOLD)
- F_ST rises 0.021 / 0.045 / 0.256 / 0.569 and GD_BS 0.006 / 0.014 / 0.076 / 0.189, with s.d. <= 0.017 / 0.009. The smallest step (GD_BS 0 -> 10, 0.008 against s.d. 0.001-0.002) is still 4-8 s.d.
- The heterosis divergence share goes 0.020 -> 0.365.
- GD_T dips and then rises: 0.312, 0.305, 0.298, 0.332. The rise from 100 to 1000 is 16 s.e.
- GD_T_other falls monotonically (0.312, 0.305, 0.293, 0.238) and GD_T_fixed goes 0 -> 0.094. "Entirely from fixed-difference sites" holds.
- The three-term identity holds: 0.409 + 0.046 + 0.014 = 0.469, and 0.238 + 0.052 + 0.020 = 0.310.
- The ratio goes 0.100 -> 0.179 (t = 5.3) and cor_perse_GCA 0.951 -> 0.909 (t = -5.2). Both are below 0.997.
- Split-0 identity: 1 - 2(0.231) = 0.538, against 0.098.
- Additive branch: add-only gives 0.154 and dom-only 0.110, so the branch resolves correctly. GCA_var_dom changes by +0.007 (t = 0.6), which resolves to "not distinguishable". That fits "the ratio can rise without the dominance part growing".
- Covariance: the largest |mean|/s.e. is 1.65, below 2.09, so it resolves to "within ... at every split". |2 cov| / var(dom) = 0.31, consistent with 0.014 / 0.046. The ratio contrast resolves to "beyond".
- Paired t values (47 d.f., t_crit 2.01): mean_tc_A 15.0, mean_tc_B 15.9, hybrid 16.7, gd_elite_mean -6.8, gd_pool_mean -7.2, GD_BS +9.0, F_ST +8.1. All resolve to "beyond", and GD_BS is positive.
- Relative loss: 0.583 / 0.599 selected against 0.532 / 0.498 in the control. "Exceeds" and "control loses too" both hold.
- mean_tc pooling: cor 0.93, sd_pooled 1.198 against sd_A / sd_B of 1.282 / 1.159 and 0.864 if independent. "Does not reduce that noise" holds; sd_pooled is even above sd_B.
- Per-draw ratio prints as "1" (0.016 / 0.017). "A single draw does not settle its sign" holds, as in it2 run b.
- gd_A and gd_B are asymmetric (t = -3.1 and -5.4), consistent with the text.
- Stage 2: the ceiling is NEGATIVE in this draw. Truncation alpha is -0.0169, the DE budgets 0 to -1.69 % are all negative, and every DE_alpha row equals ref_truncation. This is exactly the conditional case the text describes ("may warn ... every DE_alpha row coincides with ref_truncation").

## 04c-M7 / 04c-M8
- 04c-M7: the sign flips back to that of it2 run a. cor_AB(gd_elite) = -0.19, and sd_pooled 0.017 is below the independent value of 0.018. "Close ... pooling does what it should" holds. The finding (an unconditioned verdict on a draw-dependent sign) still stands as non-disqualifying, and this draw shows the sign alternating, as recorded.
- 04c-M8: does not bite, because the covariance resolves to "within".
- Accumulated M: 2.

## Figure
- 04c-E3 -- CLOSED. Both legends now sit below the panels, outside the plot regions, so no legend-data overlap is possible in any draw. The right panel's selected curves lie below the control's at cycles 2-4, consistent with the negative gd t values. Labels and caption agree with the text.

## Captions
- All 40 figcaptions (table, sub-table and figure captions) were scanned after removing `<code>` and MathJax spans. There is 0 literal markdown (backticks, `$`, `@`, `*x`, `~`) and 0 unresolved cross-references (`?@`, quarto-unresolved-ref). The sub-captions are now plain short labels, and their details sit in the parent tbl-cap, where `@tbl-alphasimr-cycle1`, `@tbl-alphasimr-rep1` and `@caballero2002` now resolve ("Table 9.20", "Table 9.21", "Caballero and Toro (2002)").
- 04c-E8 (new, form, quant-editor) -- book/04c-alphasimr-pipeline.qmd:809, the tbl-alphasimr-breeders caption. The source is `$i\\,r\\,\\sigma_A$`, and the freeze JSON carries `$i\,r\,\sigma_A$`. The HTML, however, emits `\(i,r,\sigma_A\)`: the thin-space backslashes are lost, so MathJax shows "i,r,σ_A", which reads as a list rather than the product i r σ_A. This is the same caption whose escaping prompted the post-approval edit. The variable name R_i_r_sdA and the chunk code (`i_emp * r_emp * sqrt(vA)`) make the meaning recoverable, so criterion 5 is not engaged. `$S h^2$` in the same caption renders correctly.
