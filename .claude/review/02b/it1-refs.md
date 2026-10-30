# 02b-response -- references, iteration 1

Scope: /Users/ederdbs/Documents/SB_quanti_gen-review/book/02b-response.qmd. The chapter has
**no `@key` citations at all**. Its only `@` uses are `@sec-` cross-references. Three sources
are named in plain prose (Smith 1936, Hazel 1943, Kempthorne & Nordskog 1959). All three have
correct bib entries, but the prose never links to them.

## Findings

**02b-B1 -- book/02b-response.qmd:191 -- MISSING SOURCE (unlinked)**
"Smith-Hazel index (Smith 1936; Hazel 1943)" is plain text, so it does not reach the
bibliography. `smith1936` and `hazel1943` exist and are correct (checked below). Replace with
`[@smith1936; @hazel1943]`.
The attribution itself is the canonical one (b = P^-1 G a, which maximises cor(I, H)). Full
text was not read: Hazel 1943 (PMC1209225) is a scanned PDF only, and Smith 1936 is paywalled
(Wiley). No equation number is claimed, so this is low risk.

**02b-B2 -- book/02b-response.qmd:218, :247 -- MISSING SOURCE (unlinked)**
"Kempthorne & Nordskog (1959)" is plain text. Use `@kempthorne1959`, which is correct and
already cited this way in 09-optimal-contributions.qmd:48 and 04c:1125.

**02b-B3 -- book/02b-response.qmd:222-224 -- UNVERIFIED (notation only)**
The displayed restricted-index formula is attributed to Kempthorne & Nordskog.
- I checked the algebra and it is correct. With C = G R, R'G b = 0 holds identically. It equals
  the Kempthorne-Nordskog form [I - P^-1 G R (R'G P^-1 G R)^-1 R'G] P^-1 G a.
- The original text is on JSTOR (10.2307/2527598) and I could not reach it. So it is
  UNVERIFIED that this is their notation, as opposed to the later C-matrix form found in
  secondary texts.
- The chapter does not claim verbatim notation. "Posed exactly the same problem ... zero
  expected change" agrees with the paper's title and its standard description.

**02b-B4 -- book/02b-response.qmd:205-207 -- WRONG (unsupported technical claim)**
"[Equal economic and equal index weights] coincide only when P^-1 G is proportional to the
identity, which requires the traits to be equally variable, equally heritable and mutually
uncorrelated."
- P^-1 G = cI holds if and only if G = cP. That means equal heritabilities and genetic
  covariances proportional to phenotypic ones (r_G = r_P). Traits may differ in variance and may
  be correlated.
- Counterexample: P = [[4,1.2],[1.2,1]] with G = 0.5 P gives b = 0.5 a.
- With a = (1,1), b proportional to a needs only P^-1 G 1 proportional to 1, which is weaker
  still.
- So "only when", "equally variable" and "mutually uncorrelated" are all incorrect.
- Suggested source: Hazel 1943 (10.1093/genetics/28.6.476), or Falconer & Mackay 1996 ch. 19
  (`falconer1996`).

**02b-B5 -- book/02b-response.qmd:37-41, :73 -- MISSING SOURCE**
The breeder's equation R = i r sigma_A and the intensity formula i = phi(z)/q have no
citation. Proposed source: Falconer & Mackay 1996, ch. 11 (`falconer1996`, already in the
bib; a book, no DOI). Lush 1937 is not in the bib, and I am not proposing it without a record
I checked.

**02b-B6 -- book/02b-response.qmd:101-111, :133-141 -- MISSING SOURCE**
Splitting additive variance into genic variance plus a gametic-phase disequilibrium term is
Bulmer's result. Proposed source: `bulmer1971`, already in the bib and used in 11c, DOI
10.1086/282718 (Crossref: Am. Nat. 105(943):201-211, 1971, which matches the bib).

**02b-B7 -- book/02b-response.qmd:149, :179-183 -- MISSING SOURCE**
"general combining ability *is* the additive part", and the claim that SCA "does not
accumulate across cycles the way the general components do", have no citation. Proposed
sources, both already in the bib:
- `sprague1942` (J. Am. Soc. Agron. 34:923-932; no DOI in the bib, and none checked)
- `comstock1949`, 10.2134/agronj1949.00021962004100080006x

**02b-B8 -- book/02b-response.qmd:246, :252-253 -- WRONG (minor)**
"A sixty-year-old theorem": 1959 is 67 years before 2026. Write "a theorem from 1959" or
"nearly seventy-year-old".

## Bib metadata checked (Crossref API, api.crossref.org/works/<doi>)

| Key | Result |
|---|---|
| smith1936 | OK: Smith, Ann. Eugen. 7(3):240-250, 1936 |
| hazel1943 | OK: Hazel, Genetics 28(6):476-490, 1943 (PubMed 17247099) |
| kempthorne1959 | OK: Kempthorne & Nordskog, Biometrics 15(1):10-, 1959 (Crossref gives only the first page) |
| bulmer1971 | OK: Bulmer, Am. Nat. 105(943):201-211, 1971 |

## Other checks

- Unresolved `@key`s: none. The chapter cites no keys, and `@sec-` labels are out of scope.

Checked: 0 `@key` citations (there are none), 3 prose-named sources with 4 bib entries resolved
via Crossref DOI and PubMed, 1 equation verified algebraically (original UNVERIFIED, JSTOR),
and 5 uncited claims matched to sources already in the bib.
