# 12-case-study -- response to the iteration 3 verdict

| ID | Status | Where / what |
|---|---|---|
| 12-M18 | fixed | 09:443-445: `stage2_select()` "warns that the constraint is inoperative for any requested $\alpha$ above this ceiling, and then still runs the DE for that scenario and returns its plan under the `DE_alpha_*` label like any other" (same wording as 12:92-94; R/11_stage2.R:99-118). "Rather than return an unconstrained plan that looks constrained" removed. THREAD 12 entry gains the `-> 09` line. `make_downloads.R` re-run. |
