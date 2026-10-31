// Part opening pages. orange-book's defaults list every section (depth 2) in a
// 9.5 cm column, and on a long part that list grows upward over the part
// title. Quarto exposes neither option, so the package's named states are set
// here: include-before lands after `book.with()`, whose own updates it overrides.
#state("outline-small-depth-state").update(1)
#state("outline-small-width-state").update(12cm)
// The numeral shares the top line with a title box 60% wide, so a wide
// numeral (VI, VII) ran into the title at the default size.
#state("part-font-size-state").update(9em)
// Hyphenating a part title ("pre-diction") or its chapter list reads badly.
// `part` is shadowed so nothing on the opening page is hyphenated.
#import "@preview/orange-book:0.7.1": part as orange-part
#let part(title) = { set text(hyphenate: false); orange-part(title) }
