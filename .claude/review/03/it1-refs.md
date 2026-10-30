# 03-simulating-crosses -- references, iteration 1

Chapter: book/03-simulating-crosses.qmd. The chapter cites no bib key. Every `@` in it is an internal `@sec-` cross-reference (sec-coancestry, sec-heterosis-flat, sec-subdivided, sec-heterosis-alignment, sec-collapse, sec-case-study, sec-genomic-era, sec-baseline). So checks 1-3 have nothing to check. All findings come from check 4.
The chapter has no Haldane map function, no meiosis or crossover model and no maize heterotic-group claim. Those priorities do not apply to it.

### 03-B1 -- 03-simulating-crosses.qmd:39-48 -- MISSING SOURCE
"Two heterotic pools are generated with a Balding-Nichols model", together with the Beta(p(1-F)/F, (1-p)(1-F)/F) parametrisation, has no citation. `references.bib` has no Balding & Nichols entry, and no chapter of the book cites one, although 02b, 04c and 05b also use the model by name.
Proposed entry, resolved through Crossref at https://doi.org/10.1007/BF01441146:
Balding, D. J. & Nichols, R. A. (1995). A method for quantifying differentiation between populations at multi-allelic loci and its implications for investigating identity and paternity. Genetica 96(1-2):3-12. doi:10.1007/BF01441146.
The stated mean p_k and variance F_ST p_k(1-p_k) follow from the Beta parameters (alpha+beta = (1-F)/F, so var = p(1-p)F). I checked that algebraically, and it matches `simulate_lines()` in R/00_data.R:38-53, including the runif(0.05, 0.95) ancestral draw.
I did not read the paper's full text, so whether it uses this exact parametrisation is UNVERIFIED. It is the standard Balding-Nichols form.
Suggested key: `balding1995`. Add it to the bib and cite it here. The same key also serves 02b:26, 04c:13 and 05b:459/906.

### 03-B2 -- 03-simulating-crosses.qmd:177 -- MISSING SOURCE (minor)
"`sum(G)` is zero to machine precision". This is a property of VanRaden's centered G and is deferred to @sec-coancestry. Citing @vanraden2008 here would be cheap. The entry is in the bib, and its metadata was re-checked: J. Dairy Sci. 91:4414-4423, 2008, doi:10.3168/jds.2007-0980 resolves to "Efficient Methods to Compute Genomic Predictions". Optional, because the cross-reference already carries it (see 01-B3).

### 03-B3 -- 03-simulating-crosses.qmd:188-189 -- MISSING SOURCE
"recomputing it per scenario would silently zero out the historical memory of erosion -- the single most common error in applying these metrics." The "single most common error" part is an empirical claim with no source, and I found none that measures error frequency. I propose no citation. Soften it to "a common and silent error", or drop the superlative. The base-frequency point itself belongs to Meuwissen et al. 2020 (@meuwissen2020, already in the bib), which @sec-genomic-era covers.

### Checked, no finding
- l.99-100 "twentyfold range": 0.40/0.02 = 20, correct.
- l.113-114: 25 x 25 = 625 and 71 x 71 = 5041, correct.
- l.133-151: Cholesky correlation of marker effects. Standard construction, no attribution made.

Citations checked: 0 bib keys (the chapter cites none) and 8 internal @sec- refs (not bib). 3 uncited claims flagged. 2 DOIs resolved through Crossref (10.1007/BF01441146, 10.3168/jds.2007-0980). The Balding-Nichols moments were checked algebraically and against R/00_data.R.
