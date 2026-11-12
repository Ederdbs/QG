# 05-genomic-era -- reference verification, iteration 1

Chapter: book/05-genomic-era.qmd. Bib: book/references.bib. 12 keys cited; all 12 resolve in references.bib (check 2 clean).
Local copies read in full: reference/papers/Management of genetic diversity in the era of genomics.pdf (Meuwissen 2020) and
Analysis_of_genetic_diversity_for_the_management_o.pdf (Caballero & Toro 2002), via pdftotext. Metadata resolved against Crossref and PubMed.

## Findings

### 05-B1  05:360-364  wright1951 -- "the form @wright1951 introduced"  -- UNVERIFIED
Text: F_drift "has the algebraic form of the standardised-variance definition of F_ST ... the form @wright1951 introduced and @holsinger2009 separate from ...".
- Wright 1951 full text not reachable (Wiley 403; not in PMC; no local copy). Looked at: local reference/, PubMed (PMID 24540312, no abstract), PMC/Europe-side search, publisher.
- Indirect evidence (secondary, not FULL TEXT): PMC4578636 quotes Wright (1951, p. 325): "F_ST in the broad sense can always be obtained, at least empirically" for the variance of gene frequencies, and says this "led to a common definition" F_ST = s^2/(pbar(1-pbar)). So the variance-over-pbar(1-pbar) form is associated with Wright 1951, but "introduced" is a priority claim the source cannot confirm (Wright's F-statistics date from the 1940s; Holsinger & Weir full text, PMC4687486, says Wright and Malecot "introduced F-statistics" in the 1940s-50s and defines theta = var(p)/[pi(1-pi)] without naming the 1951 paper in the text I could read).
- Meuwissen 2020 (p.4, after Eq. 1B) itself says only "F_drift is similar to the definition of F_ST (Holsinger and Weir, 2009)": it does not cite Wright 1951.
- Holsinger & Weir part (FULL TEXT PMC4687486): they do discuss several statistics called F_ST/theta/G_ST/Phi_ST/R_ST, so "separate ... from the several other quantities" is supported.
- Suggest: "the form given by @wright1951 and set out by @holsinger2009" (drop "introduced"), unless the user checks Wright 1951 p.325 directly.

### 05-B2  bib wright1951  -- metadata note (not WRONG)
- Year 1951: correct. PubMed (PMID 24540312): Ann Eugen, 1951 Mar, vol 15, issue 4, pp 323-54. DOI 10.1111/j.1469-1809.1949.tb02451.x resolves to this paper; "1949" in the DOI is the Wiley issue-date artefact (Crossref lists issued 1949-01, volume 15 issue 1). So the 1949 DOI vs 1951 year is not a conflict; 1951 is the standard citation year.
- `number = {1}` follows Crossref/Wiley; PubMed says issue 4. Inconsistent sources; harmless (pages identify it). Optional: drop `number`, or note either.
- Authors/title/journal/volume/pages correct.

### 05-B3  05:80-81  comstock1949 -- PENDING (user-declared, no copy; content not searched)
Only metadata checked: Crossref for 10.2134/agronj1949.00021962004100080006x returns Comstock, Robinson, Harvey; Agron. J. 41(8):360-367; Aug 1949; title matches bib. Attribution ("lines chosen on hybrid performance against the opposite pool and recycled inside their own pool") left PENDING.

### 05-B4  05:157, 178, 325, 389  falconer1996 chapter numbers -- UNVERIFIED
No copy of Falconer & Mackay (1996); no PMC/web full text. Publisher TOC (Pearson, 4th ed, partial) gives: 3-4 Small populations I-II (F, deltaF, Ne), 7 Values and Means (average effect of a gene substitution, so "Ch. 7" at 389 is consistent), 13 Inbreeding and crossbreeding I (changes of mean value). The chapter cites "Ch. 14" for inbreeding depression ID = 2F sum d p q (05:325); the Pearson list omits "Selection: II" so its numbering is probably off by one and Ch. 14 may be right, but this is unconfirmed. Check 05:325 against the book. "Ch. 3" at 05:178 (H_t = H_0(1-F_t)): the publisher list makes Ch. 3 "Small Populations I", plausible but unconfirmed.
Bib entry (Longman, Harlow, 4th ed, 1996) correct.

### 05-B5  05:175-178  wright1922  -- UNVERIFIED (attribution), metadata OK
"@wright1922 defined F as the correlation between uniting gametes". Crossref: Wright S, Am Nat 56(645):330-338, 1922, doi 10.1086/279872 -- bib correct. Full text not reached (JSTOR). Indirect, FULL TEXT: Meuwissen 2020 Discussion p.12 says "In the classical work of Wright (1922) two natural measures of inbreeding were introduced ... drift ... and heterozygosity" -- consistent with the chapter's framing, but says nothing about "correlation between uniting gametes".

### 05-B6  05:119 (tbl-cap)  toro2014 -- source not read
Caption: "G_0.5 [@toro2014] = 4f - 2J". Bib metadata correct (Crossref: Toro, Villanueva, Fernandez, Livest Sci 166:48-53, 2014, doi 10.1016/j.livsci.2014.04.020). Toro 2014 itself not read (not local, paywalled). FULL TEXT (Meuwissen 2020 p.2): "GVR0.5 is proportional to homozygosity and molecular coancestry (Toro et al., 2014)" and Methods p.3 "G0.5 ... elements proportional to the expected homozygosity of progeny ... (Toro et al., 2014)". The exact form 4f - 2J is the book's own algebra, not checked against Toro. UNVERIFIED at the primary source; supported at second hand.

### 05-B7  05:1557-1563  vanraden2008 -- UNVERIFIED (nuance)
"For the centred VanRaden forms [@vanraden2008] ... Z is centred on the population's own allele frequencies, so its columns sum to zero." Metadata OK (PubMed 18946147; J Dairy Sci 91(11):4414-23, 2008). Only the abstract was reached: it says genomic inbreeding "required accurate estimates of allele frequencies in the base population", i.e. VanRaden's G is built with BASE-population frequencies, and Meuwissen 2020 Methods (p.3) uses p0 (Z_ij = -2p0j, ...), not the current population's frequencies. The chapter's "population's own frequencies => exact zero eigenvalue" is the book's construction; Meuwissen's own explanation is only "one eigenvalue of zero due to the centring of the genotypes" (p.7). Keep the attribution to VanRaden for the form of G only; the "own frequencies" step should not be presented as VanRaden's. Level: ABSTRACT.

## Verified (FULL TEXT, Meuwissen 2020 = meuwissen2020, doi 10.3389/fgene.2020.00880; Front Genet 11:880, 2020; authors Meuwissen, Sonesson, Gebregiwergis, Woolliams -- metadata correct)
- 05:18-21 IBS vs IBD, classical equivalence restored under IBD: Conclusion bullet 1, p.14 ("Discrepancy ... occurs when ... IBS, but not when derived using IBD").
- 05:29 G_VR constrains drift: p.4 ("it is this empirical measure that is being directly addressed when using GVR2"; GVR1 less extreme).
- 05:162-164 log(1-F_drift) approx linear for all schemes, log(1-F_hom) marked curvature under some (G_ROH given as example): p.9, Fig. 4 text ("approximately linear ... GROH (M,M) show marked curvilinearity").
- 05:188 "their Eq. 1A defines N_SNP as total marker count": Eq. 1A p.4, "NSNP is the total number of loci". Eq. 1A/1B match chapter Eqs. era-fhom and era-fdrift.
- 05:416 "their Eq. 3": Fhom - Fdrift = 2cov(dp/sqrt(p0(1-p0)); (p0-1/2)/sqrt(p0(1-p0))), p.4, labelled (3). Matches @eq-era-cov exactly. Eq. (2) is the equivalence under E[dp|p0]=0 (chapter's unnumbered equation) -- consistent.
- 05:360, 374 "approximation to the squared total intensity i^2 applied to the marker", Liu & Woolliams non-linearity: p.5 verbatim ("viewed as an approximation to the squared total intensity (i^2) applied to the marker, where i ~ dp/sqrt(p0(1-p0))"; "not linear with frequency (see Liu and Woolliams, 2010)").
- 05:427-429 divergence persists with random GEBVs (G_VR2(~,M)): Table 2 (dF_hom 0.0085 vs dF_drift 0.0059, Panel N) and Conclusion.
- 05:503-507 MAF-spectrum quote: Conclusion bullet 2, p.14, verbatim. "depends on the distribution of (p0 - 1/2)": Discussion p.12, verbatim. Four panels from the same WGS data: Methods.
- 05:580-583, 649-662 G_LA beat A in 65 and G_ROH in 62 of 100 replicates (P<0.01) at same averaged inbreeding, "Genetic Gain" section p.10: correct (65 -> A, 62 -> G_ROH). "only scheme to meet both targets": Conclusion p.14.
- 05:645-651 Table 2 Panel N (generation 20): dF_hom/dF_drift/gap = GVR2(M,M) .0103/.0068/.054; GVR2(M,D) .0101/.0068/.05; GVR1 .008/.0069/.021; Gi(p) .0065/.0077/-.031; G0.5 .0073/.0176/-.17; GROH .0054/.0088/-.07; GLA .0043/.0049/-.01; A .007/.0084/-.021: all match the chapter's data.frame. Table 3 gains 7.124, 7.107, 6.680, 7.111, 6.734, 9.099, 7.188, 9.890: match. SE bounds (<2.5e-5, <2.2e-4, <3e-3 for table-3 F columns; gain SE <=0.004) match table footnotes. G_VR2(~,M) dF_drift 0.0059 (Panel N): match. Nine schemes in Table 2: match.
- 05:697-699 "within 2% of the target for both Panels M and N": p.9 verbatim. G_LA Panel M dF_drift 0.0049: Table 2 match.
- 05:700-707 (reading 2): A exceeded target "by 40% in both panels" (p.9): chapter's note that this rounds 0.0070 (40%) and 0.0084 (68%) is accurate.
- 05:1550-1556 alpha = 0.01 added to the diagonal; zero eigenvalue "due to the centring of the genotypes": Methods p.7, verbatim. G_ROH not guaranteed PSD: same page.
- 05:1518 IBD schemes (A, G_LA, G_ROH) select most parents; VanRaden-type (VR1, VR2, Gi(p), G0.5) fewest: p.8 ("Number of Parents").
- 05:1763-1766, 1769-1776, 1778-1782, 1792-1795 quotes ("changes in allele frequency result from multiple copies of a subset of base generation alleles, so increasing frequency is promoting IBD based inbreeding"; "what happens in a sample of loci does not necessarily predict what happens at loci outside that subset"; Wood et al. 2014 "Causative alleles ... quite evenly distributed across the genome"; "direct inclusion of the known defects in the breeding goal seems more effective in controlling their frequencies"; "the potential covariance between the change in allele frequency and the initial frequency is expected to increase, since the inbreeding management term is more important in pure conservation schemes"): all verbatim in Discussion pp.12-13. MHC example: p.13. Chapter's reading that Wood et al. is about human stature is the chapter's gloss; the Meuwissen sentence does not name the trait (checked against Wood title/Crossref).
- tbl-era-matrix-signs and tbl-era-side-by-side (G_VR1 = G_VR2 reweighted by w_k = 2p0(1-p0); di/dp = [p(1-p)]^-1/2 after Liu & Woolliams; G_0.5 loses variance early; G_i(p) reverses sign): Discussion p.12 and Results p.8-9, consistent.

## Verified (FULL TEXT, Caballero & Toro 2002 = caballero2002; Conserv Genet 3(3):289-299; doi resolves; metadata correct)
- 05:214, 1439: GD_T = 1 - fbar, GD_BS = ftilde - fbar, GD_WI = 1 - stilde, GD_BI = stilde - ftilde: Eq. (7), p.291. F_ST = GD_BS/GD_T: Eq. (6) and (8). So the chapter's "F_ST column = Nei G_ST of gd_partition()" (05:364-365) is consistent with the C&T partition. fbar = (theta_A+2theta_AB+theta_B)/4 and ftilde = (theta_A+theta_B)/2 for two equal-weight pools is the chapter's specialisation of Eq. (5)/(7).

## Verified metadata only / ABSTRACT
- nei1973 (Proc Natl Acad Sci 70(12):3321-3323, doi 10.1073/pnas.70.12.3321; PubMed 4519626): metadata correct. ABSTRACT: "gene diversity ... can be analyzed into its components ... within and between subpopulations ... measures of the absolute and relative magnitudes of gene differentiation". Supports "Nei's He = gene diversity" and G_ST as Nei's relative measure; the name G_ST itself is not in the abstract (full text not reached; PMC427228 exists, not fetched). Level: ABSTRACT.
- holsinger2009 (Nat Rev Genet 10(9):639-650, doi 10.1038/nrg2611; PMC4687486): metadata correct; FULL TEXT read, see B1.
- liu2010 (Genet Res 92(2):157-166, doi 10.1017/S0016672310000145): Crossref metadata correct; content cited only via Meuwissen (see above); not read.
- wood2014 (Nat Genet 46(11):1173-1186, doi 10.1038/ng.3097): Crossref correct (first author Wood; `and others` in bib is fine); cited only as Meuwissen's own citation, not read.

## Unsupported / unsourced claims (check 4)
No MISSING SOURCE finding. Hypothetical numbers (05:160 N_e = 50 -> deltaF = 0.01, which is 1/(2 N_e)); the "six cycles ... deltaF about 1%" and disease-resistance hitch-hiking examples (05:~425, 29-31) are illustrations, labelled as such. R-gene analogue (05:~1777) is explicitly flagged "offered as such, nothing in this book measures it". `ΔF = 1/(2Ne)` could carry [@falconer1996, Ch. 3-4], which is already cited two sentences earlier.

## Counts
Citations checked: 12 keys. FULL TEXT: meuwissen2020 (all attributions, 28 occurrences), caballero2002 (2), holsinger2009 (1, review only). ABSTRACT: nei1973, vanraden2008. Metadata-only (Crossref/PubMed): wright1922, wright1951, comstock1949, falconer1996 (book, no DOI), liu2010, wood2014, toro2014. UNVERIFIED attribution: wright1951 (B1), wright1922 (B5), falconer1996 chapter numbers (B4), toro2014 (B6), vanraden2008 (B7). PENDING: comstock1949 (B3). Equation/table numbers cited from Meuwissen (Eq. 1A, 3, Tables 2, 3): all correct. Wrong metadata: 0; wrong attributions: 0.
