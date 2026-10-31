// Page furniture and type for the Typst PDF. Fonts are the ones Typst bundles
// (Libertinus) plus system sans with fallbacks, so the build needs no install.
#let sans = ("Avenir Next", "Helvetica Neue", "Libertinus Sans", "DejaVu Sans")
#let pool-a = rgb("#1f5f8b")
#let pool-b = rgb("#d98e04")
#set par(justify: true, leading: 0.68em, spacing: 0.95em)
#set text(lang: "en", hyphenate: true)
#show heading: set text(font: sans, weight: "semibold")
#show heading.where(level: 2): set block(above: 1.6em, below: 0.8em)
#show raw: set text(font: ("Menlo", "DejaVu Sans Mono"), size: 8.2pt)
// Code boxes: light grey fill, thin frame, pool-A bar on the left. Plain
// (unhighlighted) blocks are raw; highlighted R goes through Quarto's
// `Skylighting()`, which draws its own block, so it is redefined here -- header
// includes come after Quarto's definitions and shadow them.
#let code-box = (width: 100%, inset: (x: 9pt, y: 7pt), radius: (right: 3pt), stroke: (left: 2pt + pool-a.lighten(35%), rest: 0.4pt + luma(215)), fill: luma(243), above: 1.1em, below: 1.1em)
#show raw.where(block: true): set block(..code-box)
#let Skylighting(fill: none, number: false, start: 1, sourcelines) = {
  let blocks = []
  let lnum = start - 1
  for ln in sourcelines {
    if number {
      lnum = lnum + 1
      blocks = blocks + box(width: if start + sourcelines.len() > 999 { 30pt } else { 24pt }, text(fill: rgb("#aaaaaa"), [ #lnum ]))
    }
    blocks = blocks + ln + EndLine()
  }
  block(..code-box, blocks)
}
#show figure.caption: set text(font: sans, size: 8.5pt)
#show figure.where(kind: table): set figure.caption(position: top)
#set table(stroke: (x, y) => if y == 0 { (bottom: 0.8pt) } else { (bottom: 0.3pt + luma(200)) }, inset: (x: 6pt, y: 4pt))
#show table: set text(size: 8.8pt)
#set page(numbering: "1", footer: context { set text(font: sans, size: 8pt, fill: luma(120)); align(center)[#counter(page).display()] })

// Cover (book/cover.pdf, drawn by book/scripts/make_cover.R). Header includes
// sit before the title page in Quarto's Typst template, so this is page one.
#page(margin: 0pt, header: none, footer: none, image("cover.pdf", width: 100%, height: 100%))
#counter(page).update(0)
