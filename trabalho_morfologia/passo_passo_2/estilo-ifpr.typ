// ===== Estilo customizado (baseado em estilo.typ, com logo do IFPR) =====
#let cor-principal = rgb("#0F766E")
#let cor-suave = rgb("#E6F4F1")
#let cor-texto = rgb("#1F2937")

#set text(lang: "pt", fill: cor-texto)
#set par(justify: true, leading: 0.7em)

// Barra decorativa no topo + cabeçalho (logo) e rodapé
#set page(
  background: place(top, rect(width: 100%, height: 0.9cm, fill: cor-principal)),
  header-ascent: 12%,
  header: {
    align(left + bottom, image("logo-ifpr.png", height: 1.2cm))
    v(-0.3em)
    line(length: 100%, stroke: 0.4pt + luma(200))
  },
  footer: context {
    set text(size: 8.5pt, fill: luma(110), font: "Inter")
    line(length: 100%, stroke: 0.4pt + luma(200))
    v(-0.4em)
    grid(columns: (1fr, auto), [], [Página #counter(page).display() de #counter(page).final().first()])
  },
)

// Títulos
#show heading: set text(font: "Inter", fill: cor-principal, weight: "bold")
#show heading.where(level: 1): it => {
  v(1.2em, weak: true)
  it
  v(-0.5em)
  line(length: 100%, stroke: 1.2pt + cor-principal)
  v(0.4em)
}

// Links, código e citações
#show link: set text(fill: cor-principal)
#show raw.where(block: true): it => block(fill: luma(246), stroke: 0.5pt + luma(220), inset: 10pt, radius: 4pt, width: 100%, it)
#show raw.where(block: false): it => box(fill: cor-suave, inset: (x: 3pt), outset: (y: 3pt), radius: 2pt, it)
#show quote.where(block: true): it => block(stroke: (left: 3pt + cor-principal), inset: (left: 12pt, y: 6pt), text(style: "italic", it.body))

// Tabelas
#set table(
  stroke: (x, y) => if y == 0 { (bottom: 1pt + cor-principal) } else { (bottom: 0.4pt + luma(210)) },
  fill: (x, y) => if y == 0 { cor-suave },
  inset: 7pt,
)
#show table: set text(size: 9pt)
#show table: set par(justify: false)

// Blocos de destaque (sem dependências externas)
#let destaque(titulo, cor, corpo) = block(
  width: 100%, breakable: false, inset: (x: 12pt, y: 9pt), radius: 4pt,
  fill: cor.lighten(88%), stroke: (left: 3.5pt + cor),
)[
  #text(font: "Inter", weight: "bold", fill: cor, size: 9.5pt)[#upper(titulo)] \
  #corpo
]

// ===== Auxiliares para o documento =====
#let kg = [Kg#super[−1]]
#let campo(rotulo, valor) = (text(weight: "bold", fill: cor-principal)[#rotulo], valor)
#let horizonte(sigla, texto) = (text(weight: "bold", fill: cor-principal)[#sigla], texto)
#let h(x) = table.cell(fill: cor-suave, align: center + horizon, strong(x))
#let hc(x, ..args) = table.cell(fill: cor-suave, align: center + horizon, ..args, strong(x))

// Tabelas com 2 linhas de cabeçalho
#let tabela-analitica(colunas, ..conteudo) = block(breakable: false, width: 100%)[
  #table(
    columns: colunas,
    align: center + horizon,
    fill: none,
    stroke: (x, y) => if y >= 2 { (bottom: 0.4pt + luma(210)) },
    table.hline(y: 0, stroke: 1pt + cor-principal),
    ..conteudo,
  )
]
