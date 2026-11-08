# 02-subdivided -- iteration 3 verdict (quant-judge)

Chapter: book/02-subdivided.qmd (1114 lines, uncommitted), worktree /Users/ederdbs/Documents/SB_quanti_gen-review-01-05, branch review-01-05. Scope: the form pass after the iteration-2 APPROVED (editor.md, editor-response.md, book/references.bib diff, the places in the chapter they touch). Caballero & Toro 2002 re-read (PDF in reference/papers, text extracted) at the Table 4 footnote, Table 5, the reference list and Eq. 6. book/Rplots.pdf: absent, nothing to delete. No file other than this report created in the worktree.

VERDICT: APPROVED

New IDs: disqualifying 0; non-disqualifying 1 (02-M12, Info). Established non-disqualifying failures overall: 1 (02-M9, unchanged). Threshold (three) not reached.

## PREVIOUS IDS

All iteration-2 IDs stay as ruled in it2-verdict.md (no reopening: no number, claim, equation or chunk logic changed; see WHAT WAS VERIFIED). Editor IDs:
- 02-E1 -- accepted, see ruling 1.
- 02-E2 -- accepted, see ruling 2.
- 02-E3 -- owed -> 90 (named chapter; chapter 02 true without it: the symbols are defined in 02's Notation). Not a blocking item.
- 02-E4 -- owed -> 00-E8 (named; Typst layout of long cells in tbl-keystone; content unaffected).
- 02-E5 -- ruling 3: note kept, accepted.
- 02-E6 -- accepted: positional "chunk above/below" replaced by @tbl-toy-partition / @tbl-keystone-check where a label exists, by the code-font chunk label where not; no analysis code touched.

## DISQUALIFYING FAILURES

None.

## RULINGS REQUESTED

1. laval2000 and wright1969 (book/references.bib:1965-1982) and the sentences citing them (:358, :746, :1020).
   Established, by me:
   - C&T 2002 reference list prints, for the Laval, Iannuccelli, ..., Ollivier (2000) Genet Sel Evol 32, 187-203 entry, the title "Estimation of the coancestry coefficient: Basis for a short term genetic distance"; the list also prints the Reynolds, Weir & Cockerham (1983) entry (Genetics 105, 767-779) under that title, which is its correct title. So the 2002 list carries a wrong title for Laval; that is a defect of the list, not of the book.
   - Crossref (10.1186/1297-9686-32-2-187): title "Genetic diversity of eleven European pig breeds", Genet Sel Evol, vol. 32, issue 2, 15 March 2000, article number 187, 14 authors matching the bib list in order. Crossref gives no page range.
   - Europe PMC record for the same DOI (queried by me): title "Genetic diversity of eleven European pig breeds", pages 187-203, 2000, volume 32. So pages 187--203 are independently established, not only from the C&T list. The bib entry (Crossref title, pages 187--203) is correct. Pandoc citeproc renders both keys ("Wright (1969)", "Laval et al. (2000)") from book/references.bib.
   - C&T 2002 text: Table 5 is titled "Reanalysis of genetic diversity with the data of Laval et al. (2000)"; the sentence at :746 (pig breeds of @laval2000 reanalysed in @caballero2002 Table 5, column 3) is what the paper says. Eq. 6, p. 291: "Wright's (1969) F-statistics are obtained as"; the reference list: "Wright S (1969) Evolution and the Genetics of Populations. Vol. 2, The Theory of Gene Frequencies. The University of Chicago Press, Chicago, USA." The bib entry equals that.
   UNVERIFIED (stays so): the year 1969 of Wright vol. 2 rests on the C&T 2002 list; Crossref shows reviews of vol. 2 dated 1970-71 (Biometrics, BioScience, Pop. Studies, J. Anim. Ecol.), consistent with 1969 but not proof; Open Library lists 1969 only at series level, not for the volume. Volume pages/ISBN not checked. My own recollection that vol. 2 is 1969 is memory, not a check. The chapter keeps this scope: "as cited there", "the original papers were not read for it" (:357-361), and @wright1969 is listed among the sources "not read for this chapter, and therefore reported only as the secondary sources attribute them" (:1019-1021). No number depends on it. Entries and sentences ACCEPTABLE as they stand.

2. FRBA and DESH definitions. C&T 2002 Table 4 footnote reads: "FRBA: Basque (France)", "DESH: Schwaebisch-Haellisches (Germany)" (umlauts in the PDF). Chapter :747 "FRBA (Basque, France; the breed codes are defined in the footnote to Table 4 of @caballero2002)" and :1001 "breed DESH, Schwabisch-Hallisches, Germany" (written with umlauts in the .qmd) are exactly that, nothing added. FRBA's first use is :747 (the later ones :752, :1003 follow); DESH's only first use is :1001. The statement that the codes are defined in the footnote to Table 4 is true. ACCEPTED.

3. 02-E5, callout-note "What this does and does not license" (:757-764). RULING: the contest is upheld; the callout stays a note. Reason on content: the box states the scope of the removal result (it does not license discarding a low-diversity accession), i.e. it is a clarification of what the preceding result does and does not show; ignoring it changes no computed number, which is the quant-editor definition of warning ("a trap that produces a wrong number", .claude/agents/quant-editor.md:58). The practical advice is flagged in the text as the author's judgement and is not presented as a result (criterion 4 satisfied). Nothing to change.

## NON-DISQUALIFYING OBSERVATIONS

- 02-M9 (Low, unchanged, from it2) :781-799 -- genic-variance derivation kept in 02, redundant with 02b.
- 02-M10 (Low, unverified, from it2) :863 -- Falconer & Mackay "ch. 4" locator in a code comment / script.
- 02-M11 (Info, from it2) :743 -- "the authors argue that weighting by size is desirable".
- 02-M12 (Info, new) book/references.bib:1965 -- the C&T 2002 list prints the Reynolds-Weir-Cockerham title for the Laval entry; the book's entry follows Crossref. A reader who compares the bibliography with C&T's list will see a different title. Not a defect of the book; refcheck should carry it at close as a note on the entry. No effect on any claim.

## WHAT WAS VERIFIED

- Chapter code: knitr::purl of the current chapter, sourced from book/ against pkgload::load_all of the worktree (own scratch script): no error, every stopifnot passes, 4.4 s; no Rplots.pdf produced. Printed values: tbl-toy-partition G (N_i(1-f_ii) weighted) 0.6441, census 0.6490, GD_T 0.4304 = GD_WI 0.1097 + GD_BI 0.1986 + GD_BS 0.1221; tbl-keystone-check GD_WI-hyb 0.1806, GD_T 0.3215 = GD_BI 0.2809 + GD_BS 0.0406, GD_WI 0.0000, F_ST 0.1263 (= 0.0406/0.3215; it2: 0.1262791); worked example census delta (-6.65, +1.84, -3.91, -0.81), equal (-6.92, +6.47, -6.94, -3.56), computed = published to 4 dp (f-bar 0.3256, f-tilde 0.4535, GD_T 0.6744, F_ST 0.1897); all equal the it2 values.
- The two converted chunks (:480-, :1056-): the analysis lines and stopifnot are the iteration-2 ones; what was added is `fmt()` and `kable()` at the end of each (display only), with a name-indexed label vector in tbl-keystone-check. Both captions state data, seed (1, 7), scale (25+25 lines, 2000 markers) and units, and match the code; the sentence at :470 and :477 cite @tbl-toy-partition before the chunk.
- Downloadable script book/downloads/02-subdivided.R: old labels `ct-identities`/`keystone-check` absent from chapter and script; the label `tbl-keystone-check` appears in code comments (:376, :835), consistent with the rename.
- Cross-references: ids sec-ct-notation (:32), sec-ct-fij (:84), sec-ct-species (:583), sec-ct-removal (:692), sec-ct-oc (:767) exist; the uses (:163, :364, :371, :589, :860) point at the right sections by content. Quarto resolution itself not run (render deferred).
- Acronym expansion "gene diversity ($GD$)" at Notation: present.
- pandoc --citeproc against book/references.bib with the two new keys: resolves.

## NOT VERIFIED

- Year 1969 of Wright vol. 2 (above), volume pages/ISBN: C&T 2002 list only, plus reviews in 1970-71. Non-decisive: no number rests on it, and the chapter states the source was not read.
- Rendered HTML/Typst output of the new tables and Quarto cross-reference resolution: render deferred to close (docs/ and _freeze/ are stale by design).
- Wright 1969, Cockerham 1967/1969, Nei 1973 beyond its abstract, Lindgren 1997, Falconer & Mackay, Meuwissen 1997 beyond its abstract: sources absent, reported by the chapter as attributions of C&T 2002 / Toro & Caballero 2005; unchanged since it2.

## OWED ROWS (unchanged names)

- 02-E3 -> 90 (add or declare local: p-tilde_{k,i}, c_i, theta_w); 02-E4 -> 00-E8; refcheck at close: M12 note on laval2000; plus the it2 rows to 08, 90, 11b, 00, 05 (wright1951) as listed in it2-verdict.md.
