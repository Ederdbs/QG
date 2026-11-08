# Verdict: book/03-simulating-crosses.qmd (iteration 1)

VERDICT: REJECTED

Worktree /Users/ederdbs/Documents/SB_quanti_gen-review-01-05, branch review-01-05. Lines are of the 456-line qmd as it stands. Read in full: the chapter, it1-audit.md (R), it1-refs.md (B), it1-continuity.md (C), THREAD entries 00, 01, 02, 02b, 05b with their Owed items naming 03, and the passages of 01, 02, 05b, 90 and R/00_data.R, R/09_reference.R they point to. The reference/ directory holds no copy of balding1995 or vanraden2008.

Counts: disqualifying 7 (high 3, medium 3, low 1); non-disqualifying 14 (medium 5, low 9). Three or more non-disqualifying observations independently reject as well.

## Rulings on the decisive items

1. C1/R1 (03:201-218): ACCEPTED, raised from M (R1) to disqualifying (03-D1). The claim is stated without the premises its sources attach to it. See 03-D1.
2. C2: ACCEPTED as H. Which chapter changes: 01 (01:374-376 uses p_{0,k} for the ancestral frequency, while 00:368, 05:97/186, 90:30 and 01:420 use p_{0,k}/p0 for the frozen base), 05b (plain p for the ancestral at 620, 670-675, 698, 1193) and 90 (Terms entry 587-590, which contradicts 90:513 inside 90). 03 does not change its symbol: p*_k is defined here at eq-balding-nichols and agrees with 90:513. What 03 must say today is a content requirement, not wording: that p*_k is the ancestral frequency of the draw, never observed in the data, and that `ctx$p0` (03:329) is `colMeans(X)` of the 625 hybrids (R/00_data.R:164), a sample quantity of this draw, a different object from p*_k and from the pool frequencies p_Ak, p_Bk. Today 03:329 does not say it. See 03-D7.
3. B1/B2: B1 is UNVERIFIED and I treat it as non-decisive (03-M1). B2 is a defect of content, not only of source (03-D6).
   - What 03 may attribute to balding1995: only what the abstract supports (a model expressed in one parameter) and the model's name. The Beta shapes, the mean and variance, and "F_BN is the expected divergence of each pool from the ancestral frequency" are the book's own specification, verified algebraically here and in the code. They may not be presented as the paper's content while the full text is unread. The multi-allelic Dirichlet form of the 1995 paper is my recollection, not verified. I cannot confirm any claim about the paper beyond the abstract.
   - vanraden2008 and "as it must be": sum(G) = 0 is a property of centring on the sample frequencies of the very panel (column sums of Z equal 0). It is not a property of VanRaden's G in general, and it is not a result of the 2008 paper that I can confirm. With a base-frequency centring, which is the book's own point (@sec-genomic-era), the sum is not zero. I checked this numerically: centring the 625 hybrids on arbitrary non-sample frequencies gave sum(G) = 658333, while the sample-centred `simulate_data()` gives -4.179e-11. The sentence has to carry the centring condition, and the property is 01's (@eq-g-sum-zero), not the citation's.
4. C3, C5, C6, C7, C15, R6: C3 accepted as disqualifying (03-D2). C5 accepted as disqualifying (03-D3), with C15 and R6 folded into it. C6 accepted as disqualifying (03-D4). C7 accepted as non-disqualifying (03-M9). R6 hand-typed numbers accepted as non-disqualifying (03-M14).

## PREVIOUS IDS

None (iteration 1).

## Disposition of the supplied findings

| ID | Ruling | Mapped to |
|---|---|---|
| R1 | accept, raised M to D | 03-D1 |
| R2 | accept, raised M to D | 03-D2 |
| R3 | accept (L) | 03-M2 |
| R4 | accept (L) | 03-M3 |
| R5 | accept (L) | 03-M4 |
| R6 | accept; the m = 1500 part raised to D, the hand-typed numbers stay M | 03-D3, 03-M14 |
| R7 | accept (L) | 03-M5 |
| R8 | accept, raised L to D | 03-D5 |
| R9 | accept (L), "upper bound" part raised to M | 03-M6 |
| R10 | accept (L) | 03-M7 |
| R11 | accept; the missing dispersion is a criterion-3 observation | 03-M13 |
| R12, R13, R14, R15 | accept as Info; R13 folded into 03-M11; R12 and R14 stay Info | -- |
| B1 | accept as UNVERIFIED, non-decisive | 03-M1 |
| B2 | accept, raised to D | 03-D6 |
| B3, B4, B5 | accept as Info; B4 (lines drawn directly at fixation) is folded into 03-D4 | -- |
| C1 | accept, H | 03-D1 |
| C2 | accept, H, owner 01/05b/90 | 03-D7 |
| C3 | accept, raised M to D | 03-D2 |
| C4 | accept (M) | 03-M8 |
| C5 | accept, raised M to D (verified) | 03-D3 |
| C6 | accept, raised M to D | 03-D4 |
| C7 | accept (M) | 03-M9 |
| C8 | accept (M) | 03-M10 |
| C9, C10, C11 | accept; owners 04, 04e, 08b; not charged to 03 | -- |
| C12 | accept (L) | 03-M11 |
| C13 | accept, raised L to D, merged with R8 | 03-D5 |
| C14 | accept (L) | 03-M12 |
| C15 | accept (L) | folded into 03-D3 and 03-M14 |

## DISQUALIFYING FAILURES

- 03-D1 [criteria 2, 4, 1; high] 03:201-218 (C1/R1) -- "Neutral divergence relocates diversity; it does not create heterosis" (03:214) and "@tbl-keystone ... states that GD_BS is nonetheless to be preserved rather than minimised" (03:215-217) are stated without the premises their sources attach to them.
  - The chapter's evidence is the heterozygous fraction of the A x B F1 and its split into GD_T and GD_BS. That quantity is heterosis only at flat dominance, d_k = 1 at every locus.
  - 02:1039 (the keystone row itself) says: "with flat dominance (d_k = 1), inbred parents and the complete A x B factorial ... there GD_BS is the divergence term of heterosis, to be preserved not minimised; outside those conditions it is not an identity".
  - 02:1085-1097 adds equal pool weights and says the statement "does not hold for non-flat dominance or for divergence that is aligned with the dominance effects", which @sec-heterosis-alignment treats.
  - 05b:602-610 scopes the same sentence to expected heterosis at d_k = 1.
  - Neither d_k = 1, nor inbred parents, nor the complete factorial, nor equal weights appears in the 03 paragraph. The equal pool sizes are mentioned only in a code comment (03:130).
  - The chapter's own data carry no dominance (03:287-288), so in this chapter the heterozygous fraction is not heterosis at all.
  - "nonetheless" (03:216) makes preservation read as a consequence of the flat line; in 02 and 05b it follows from alignment. The THREAD (02 Owed, naming 03) asks 03 to keep these conditions; it does not.
  - This is an assumption used and not declared (criterion 2) and an inference presented as a result (criterion 4). The heterozygous-fraction identity itself is correct and I verified it.

- 03-D2 [criterion 5; medium] 03:29, 329, 412, 414, 419, 433, 441, 444 (C3/R2) -- "pool" means the heterotic pools A and B in 03:56-190 and the 625 hybrids in "the candidate pool", "candidate-pool allele frequency vector", "the whole pool" and the table row "GD, whole pool".
  - The collision is concrete: 03:433 "the gene diversity of the whole pool" follows a section on GD within and between the two pools.
  - 00 settled "candidate set" (00-C13, 00-D17, closed at 00:368), and the THREAD owes the correction to 03 from the 00 and 05b entries. The label `fig-candidate-pool` itself is not at issue.
  - A term with two meanings inside one chapter, after the book fixed the name, is a redefined term.

- 03-D3 [criterion 5; medium] 03:112, 116, 142, 158, 173 (C5/C15/R6) -- the divergence grid sets m = 1500 and the captions call it "the book scale". `book_cfg$m` is 2000, and the same chapter prints it (03:20) and states 2000 markers (03:419). Nothing explains the departure.
  - I recomputed the F_BN = 0.15, seed 1, 25 + 25 line row. At m = 1500: heterozygous fraction 0.3674, GD_BS 0.0363, GD_T 0.3311. At m = 2000: 0.3617, 0.0336, 0.3281. The 0.3617 is the value quoted at the same F_BN, seed and data in 00 (00:435-447), 01 (tbl-diagonal) and 05b.
  - The reader meets two numbers for what the text presents as one quantity on one dataset. The range 0.363-0.3726 at 03:180-183 inherits the same scale.
  - The "book scale" label is false for m, and the table row at 0.15 does not reproduce the earlier chapters.
  - The conclusions (flatness, ratios 1 and 2) are not affected: I recomputed them at m = 1500 and they hold (03-D3 is a consistency failure, not a numerical error in the results).

- 03-D4 [criterion 2; high] chapter-wide, especially 03:56-99, 222-239, 281-290 (C6) -- the assumptions of the generator are never stated, and the rest of the book points to 03 for them.
  - Cited to 03: A5 (05:94-95, "drawn independently per locus (`simulate_lines()`)"), 00:31, 11b:76-79, 04c:12-15 and the whole of 04c's "what this adds over @sec-simulating-crosses" list (linkage, directional dominance, outbred founders, multi-generation).
  - The chapter shows only "2 x Bernoulli(p)". It never states the premises that make the F_ST accounting, the 1/n offsets and the factorial identities hold: independent loci, so linkage equilibrium by construction; no map and no recombination; lines drawn independently given the pool frequency, so unrelated within pool and with no shared descent; lines that are inbred by fiat at fixation, with no DH or selfing path (B4); neutral markers; effects at every marker; equal pool sizes; the complete A x B factorial, introduced as 03:222 "Every A x B combination is formed" without being called an assumption or pointed to 04e/04f/04g, which relax it.
  - The callout "What this simulation deliberately does not model" lists only GEBV error and dominance.
  - Assumptions are used throughout and declared nowhere. The identities of 02, 05b and 01 that 03 rests on are conditional on these.

- 03-D5 [criteria 1, 5; medium] 03:202, with 03:123, 130, 142 (R8/C13) -- "The heterozygous fraction of an A x B hybrid of inbred parents is exactly `1 - theta_AB`".
  - The identity per hybrid is 1 - f^L_ab. It holds exactly and the chapter proves it at 03:301-307. theta_AB is the mean coancestry between the pools, so 1 - theta_AB is the mean over the complete factorial (03:123-125). 01:360-380 and 02:596 state it correctly for the mean.
  - The same quantity is also named `between_pool_f` (03:123, 142), "f_AB" (03:130) and `theta_AB` (03:202) inside one chapter, against \bar f^L_AB in 01 and 90.
  - "Exactly" on a per-hybrid reading is a misstated identity and an inconsistent symbol, in the sentence on which the generalisation "not an artefact of this grid" rests.

- 03-D6 [criteria 1, 2, 7; low] 03:319-320 and the caption of tbl-ctx-check (B2) -- "`sum(G)` is zero to machine precision, as it must be for VanRaden's centred matrix [@vanraden2008]".
  - sum(G) = 0 holds only for centring on the sample frequencies of the panel (see ruling 3). That is a condition of the code `vanraden_G()` (p <- colMeans(M)/2) and of @eq-g-sum-zero in 01, not an identity of VanRaden's matrix, and not something I can confirm the paper states.
  - The condition is used and not declared, and the property is attributed to a source that is unverified for it. Given that the book's own discriminating point is G centred on its own panel against f, the omission is not cosmetic.

- 03-D7 [criteria 2, 5; high, open continuity H, owner 01/05b/90 with a 03 share] C2 -- the ancestral Balding-Nichols frequency has three symbols, and one is also the frozen base.
  - 01:374-376 writes p_{0,k}, the same symbol as the frozen base of the candidate set (00:368, 05:97/186, 90:30, 01:420 and `ctx$p0`).
  - 03 and 90:513 write p*_k. 05b and the 90 Terms entry write plain p.
  - The ancestral vector and the candidate-set base are different quantities in the simulation: the base is `colMeans(X)` of the hybrids (R/00_data.R:164), about (p̂_A + p̂_B)/2 of the sampled lines.
  - Per the rule that an open H finding from continuity rejects, 03 cannot be approved while this stands. 03's own symbol is correct. Its share is 03:329, which calls `p0` "the candidate-pool allele frequency vector" and "the base" without separating it from p*_k, at the one place both objects are in view (ruling 2). The symbol changes are owed in 01, 05b and 90.

## NON-DISQUALIFYING OBSERVATIONS

- 03-M1 (B1; medium) 03:58-63, eq-balding-nichols -- the Beta form and its attribution to balding1995 are UNVERIFIED. Only the abstract was reached. The abstract does not mention a Beta density, and the 1995 paper is, to my recollection which I could not verify, multi-allelic. The mean and variance are correct for the Beta given, and I confirmed `rbeta(p(1-F)/F, (1-p)(1-F)/F)` in R/00_data.R:38-45. Non-decisive because the generator is defined by the equation and no result depends on who first wrote it. Scope per ruling 3. 05b and 90 repeat the attribution and are not re-judged here.
- 03-M2 (R3) 03:323-331 -- "freezes two things", and the chunk `str(ctx[c("p0", "maf_pop", "index")])` shows three; only `p0` is explained.
- 03-M3 (R4) 03:335-336 -- "builds the same `ctx` as this chapter" is not asserted in the chapter. The audit measured it true except for `traits` column names. A claim of identity without its check.
- 03-M4 (R5) 03:131, 302-307, 312, 319 -- the exact identities use `all.equal` at its default 1.5e-8, and `abs(sum(G)) < 1e-8` is absolute, about 5 orders loose against the achieved 0 and 5.6e-17. "Machine precision" is true only relative to sum|G|, since sum(G) = -4.179e-11. tbl-ctx-check prints 0.0000, so the evidence for the sentence is invisible, and N, m and n_lines print as 625.0000, 2000.0000 and 50.0000.
- 03-M5 (R7) 03:181-187 -- inline digits via `fmt()` drop trailing zeros ("0.363 and 0.3726"), so precisions differ within one sentence, and "-0.1334" uses a hyphen-minus.
- 03-M6 (R9; medium) 03:104 and 03:285-288 -- two unconditional claims without evidence. "`fst` is the single most consequential parameter" is never compared with m, n or the trait correlation, and the chapter shows the heterozygous fraction does not depend on it. "Read every gain figure as an upper bound on what a real programme would realise" is true only for gain in true value at equal intensity and accuracy below 1, and does not apply to diversity metrics. Neither is shown here.
- 03-M7 (R10) 03:14-22, 89-92 -- the assertion hard-codes `fst = 0.15, seed = 1`, which duplicates 02b's arguments instead of reading them, and 02b has no matching assertion. `simulate_pools()` clamps both pool-frequency vectors to [1e-6, 1-1e-6] and `simulate_lines()` does not. I reproduced 4 + 2 of 4000 draws outside at m = 2000, seed 1, none exactly 0 or 1. The lines are identical, but "the same pool frequencies" holds only to 1e-6.
- 03-M8 (C4; medium) 03:101-218 -- the neutral-divergence sweep, the E[2p(1-p)] = 0.365 level, the finite-n offset and the "gain equals loss" accounting duplicate @sec-heterosis-flat (05b:602-787) with a different grid, seed and m. The formulas agree. Redundancy, and a source of the D3 inconsistency; the expectation and the offset belong to 05b.
- 03-M9 (C7; medium) 03:222-239, 285-289 -- the opener of the Simulation part cites none of 04, 04b, 04c, 04e or 08b. 04e relaxes the complete factorial and 08b closes the GEBV gap that the callout opens. For the missing dominance the pointer is @sec-case-study, which only names the extension (12:174-175, 12:262-266); the dominance side is 05b and 04c.
- 03-M10 (C8, plus mine) 03:412-448 -- the whole-set-against-random-subsets gap is computed here and in 06:578-590 with two numbers (0.68 % and 0.69 %, seed difference). In addition, tbl-gd-baseline reports the "apparent loss" from one set of 400 subsets with no Monte Carlo s.e. I reproduced 0.3280928 against 0.3258591 (s.e. of the mean 3.8e-5) and 0.6808 %, so the gap is about 58 s.e. and is not in doubt. The criterion is simulated-estimate-with-error, and the unreported error is the defect.
- 03-M11 (C12, R13) 03:249-275 -- `R` (target correlation), `B` (marker effects) and `L` (line matrix) in prose clash with 90 (R restriction matrix and response, B parent-usage incidence and β, L number of lines). n_A, n_B for lines per pool differ from 90:474 (female and male lines of @sec-mating).
- 03-M12 (C14) 03:319-321 -- "f is inside [0, 1]" omits what 01:222-250 establishes: f is identity in state, unrelated individuals are not at 0, and its level is set by the panel. tbl-ctx-check prints min f = 0.6447 and max f = 0.8318 without comment, so the assertion `min(f) >= 0` is weaker than 01's statement.
- 03-M13 (R11; medium) 03:180-185 -- the headline flat line is one draw per grid point, and the chapter says the spread "was not measured here", which is an honest limit (criterion 6 met). Yet the replicate chunk already simulates the ends of the grid and does not report the het fraction. I measured 60 seeds at m = 1500: mean 0.3640 (sd 0.0034) at F_BN = 0.02 and 0.3635 (sd 0.0068) at 0.40. The observed single-draw range of 0.0096 is within about 1.4 sd of that spread, so six single draws could not by themselves distinguish flat from a small trend. The claim is carried by the derivation (03:201-211), which I verified, not by the figure. A measured claim whose dispersion sits one chunk away from where it is needed.
- 03-M14 (R6 remainder, C15) 03:112, 419, 224 -- hand-typed scale numbers where the chunk holds the value ("25 + 25 lines, 625 ... 2000 markers", "400 random subsets of 60", "0.02 to 0.40", "71 lines per pool", `71^2`), and "book scale" against the book's "teaching scale".

Info (no action required): R12 (departure of realised trait correlations, mean maximum 0.198 over 20 draws per the audit, this draw 0.14), R14 (the 3 x 3 `R` is not subset to `n_traits`, works only at 3), R15, B3, B5 (derivations correct). C9 (04:15), C10 (04e:35-37) and C11 (08b:10-12) belong to 04, 04e and 08b.

## Owed items from the THREAD, status

- 01: heterozygous fraction flat across the F_BN grid, one pair per point (01:378-380): kept and true in expectation; dispersion is not in the chapter (03-M13).
- 02: drift ratios 1 and 2 in two equal pools (03:185-191) cite 02:606-613 correctly, and I reproduced mean 0.9987, sd 0.097 over 60 seeds; the conditions of the GD_BS row are NOT kept (03-D1).
- 02b: "the same lines and X" holds today (asserted with `identical`); the duplicated hard-codes remain (03-M7).
- 00 and 05b: "candidate pool" is still present (03-D2).
- "lighter form": absent from 03.

## What the chapter cannot be approved with (open at this iteration)

03-D1, 03-D2, 03-D3, 03-D4, 03-D5, 03-D6, 03-D7. The M items accumulate beyond three and independently reject.

## WHAT WAS VERIFIED

- Algebra, by hand. Per marker GD_BS = (p̂_A - p̂_B)^2/2 and GD_T = 2 p̄ q̄. E[GD_BS] = F p*q* + (1-F) p*q*/n. The loss of GD_T and the gain of GD_BS are both F p*q*(1 - 1/n). The change in GD_WS is -2 p*q*(1 - 1/n), so the ratios are 1 and 2. 1 - f_AB = GD_T + GD_BS for equal pools, because f_AB = 2 f_bar - f_til. All reproduce 03:204-211 and 03:131.
- Expected change 0.38 x 0.365/2 x (1 - 1/25) = 0.066576 (R). It agrees with the audit's replicate means within s.e. (dBS 0.06651, dT -0.06682).
- Trade ratios over 60 seeds (seed s, m = 1500, F_BN 0.40 minus 0.02, scratch script chk.R): GD_BS gain / GD_T loss mean 0.9987, sd 0.097. This agrees with the chapter's 200-seed mean 1.002 and sd 0.104.
- F_BN = 0.15, seed 1 row at m = 1500 against m = 2000 (R, pkgload of the worktree): het 0.3673835 against 0.3616896, GD_BS 0.03627 against 0.03360, GD_T 0.3311 against 0.3281 (basis for 03-D3).
- Replicate het fraction, 60 seeds at m = 1500: F_BN 0.02 mean 0.3640 sd 0.0034; 0.40 mean 0.3635 sd 0.0068 (basis for 03-M13). Expectation 0.365.
- Whole set against 400 random subsets of 60, seed 4, book scale: 0.3280928 against 0.3258591 (s.e. 3.8e-5), apparent loss 0.6808 % (matches the chapter and 06 within seed).
- `sum(simulate_data(...)$G)` = -4.178879e-11. Centring the same hybrids on arbitrary non-sample frequencies gives 658333 (illustration of ruling 3, 03-D6).
- Clamping: 4 (A) and 2 (B) of 2000 Beta draws lie within 1e-6 of 0 or 1 at m = 2000, F_BN 0.15; none is exactly 0 or 1, so p in (0,1) holds in floating point (03-M7).
- From the audit, consumed: a knit of the chapter ran in 3 s with every `stopifnot` passing, the numbers equal the freeze, the download script is in sync, all `@` targets resolve. I did not re-run these.

## NOT VERIFIED

- balding1995: the Beta form, the mean and variance, and the reading of F_BN as the expected divergence of each pool. The full text is paywalled and absent from reference/; only the abstract was seen (03-M1). A copy of the paper, of Balding (2003) or of Nicholson et al. (2002) would settle it.
- vanraden2008: full text not retrieved; whether the paper makes any statement about sum(G) = 0 (03-D6).
- The F_ST approximation F_BN/(2 - F_BN): derived and consistent with 90:150-167, but the originals behind 02 were not read (caballero2002 Eq. 8 is cited in 05b, not in 03).
- @sec-genomic-era and @sec-baseline beyond the labels and the sentences 03 cites. 05 and 06 were not re-read. 03:329-331 matches `build_ctx()`.
- A `quarto render` of the chapter in HTML or Typst. Only the knit of the audit, and the frozen figures, were checked.
