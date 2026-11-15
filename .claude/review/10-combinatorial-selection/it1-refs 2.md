# Chapter 10 (book/10-combinatorial-selection.qmd) -- references, iteration 1

Cited keys in the chapter (non-@sec/@fig): `caballero2002` (l.40), `debeukelaer2018` (l.734). Both resolve in references.bib.
Bib metadata checked against Crossref (DOI resolved): caballero2002 (Conserv Genet 3(3):289-299, 2002), debeukelaer2018 (BMC Bioinformatics 19:203, 2018) and comstock1949 (Agron J 41(8):360-367, 1949; authors Comstock, Robinson, Harvey; title matches up to capitalisation): all correct.

## Findings

### 10-B1 -- l.738-741 (and l.734-737) -- WRONG (mischaracterised objective)
Chapter: "It is one application, on an allele-coverage objective rather than an index under a coancestry budget".
Source (De Beukelaer et al. 2018, FULL TEXT, Results "Optimizing E-NE and A-NE with local searches", p.~6, and Table 1 caption): the three-way comparison (random descent / parallel tempering / GA) was run "configured to maximize E-NE" only, i.e. entry-to-nearest-entry, a distance-based diversity measure (average distance from each core entry to its nearest other entry). It is not allelic richness / allele coverage (that is the separate HE/allelic-richness measure, not optimised in this comparison). Table 1 caption: "...when maximizing the entry-to-nearest-entry...". The subsection title "E-NE and A-NE" also overstates: A-NE is not in the three-algorithm comparison (the text says "We performed these experiments only for the E-NE measure").
Fix: "on a distance-based diversity objective (E-NE)". The caveat about transfer still holds.
Minor related wording: the paper calls all three "local search algorithms" in the Core Hunter framework, but the GA is a population method (uses random descent as mutation operator); the chapter's "optimising ... with local search rather than DE" is acceptable, but the sentence "rank three stochastic searches" is the faithful one.

### 10-B2 -- l.40 -- OK (FULL TEXT)
"molecular coancestry of @caballero2002, values in [0,1]". Caballero & Toro 2002, p.291, section "Molecular markers": "The molecular coancestry between all pairs of individuals can be simply obtained by applying Malecot's (1948) definition but referring to identity in state instead of identity by descent"; allele indicator p_{k,l,i} = 1 homozygote, 0.5 heterozygote, 0 other (Eq. 10 follows). Consistent with the {0,0.5,1} coding and the [0,1] range. (The Gram form f = tcrossprod(cbind(X,1-X))/m is the package's own computation, not claimed to be from the paper.)

### 10-B3 -- l.734-741 -- OK (FULL TEXT), details verified
- Four datasets: rice, coconut, maize, pea: yes (Datasets list).
- Section named "Optimizing E-NE and A-NE with local searches": yes (Results heading).
- Ranking PT > GA > random descent: yes ("parallel tempering yields the highest E-NE values"; GA "outperforms random descent ... not as effective as parallel tempering"; Table 1 means consistent in all four datasets).
- "twelve pairwise comparisons significant, Holm-adjusted Wilcoxon": yes (Wilcoxon rank-sum, 12 p-values, Holm; "All differences were statistically significant at alpha = 0.05", adjusted p 0.00013-0.00049).
- "many simple local searches run in parallel": the paper: "multiple cooperating local searches that are executed in parallel", each "performs the same procedure as random descent". OK.
- Note: no DE is tested in that paper; the chapter does not claim so (it states the transfer limits explicitly). OK.

### 10-B4 -- references.bib `comstock1949` -- no finding on metadata; NOT CITED in chapter 10
PENDING per instructions: existence and title only. Exists (Crossref, DOI 10.2134/agronj1949.00021962004100080006x resolves); title "A Breeding Procedure Designed To Make Maximum Use of Both General and Specific Combining Ability", Agron. J. 41(8):360-367. Full text not read. `grep` finds no `@comstock1949` in chapter 10 (uncited here; may be cited elsewhere).

### 10-B5 -- l.~720-725 and elsewhere -- MISSING SOURCE (minor, optional)
"epsilon-constraint method" (l.~758) is named without a citation; a primary source would be Haimes, Lasdon & Wismer (1971), IEEE Trans. Syst. Man Cybern. SMC-1:296-297, doi:10.1109/TSMC.1971.4308298. NOT looked up (UNVERIFIED -- cited from memory, verify before adding). No other uncited numeric/historical claims found: remaining numbers in the chapter are in-repo computed results (`fmt()`, cached CSVs).

## Where looked
Local: reference/papers/ (Caballero & Toro 2002 PDF, Core Hunter 3 PDF, read with pdftotext). Web: Crossref API for the three DOIs. PubMed/PMC not needed (local full text available).

## Summary
Citations checked: 2 distinct keys in chapter (3 attributions). FULL TEXT: 3 (caballero2002 l.40; debeukelaer2018 l.734-741 ranking/test/datasets; debeukelaer2018 objective -> WRONG). ABSTRACT: 0. UNVERIFIED: 2 (comstock1949 full text pending and uncited here; Haimes 1971 suggestion not looked up). Bib metadata verified by DOI for 3 entries.
