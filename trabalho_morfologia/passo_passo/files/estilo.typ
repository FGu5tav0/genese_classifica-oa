// ===== Estilo: ficha de descrição morfológica do solo (IFPR) =====
#let fonte = ("Arial", "Liberation Sans", "Inter")

// Página simples, sem barra decorativa, cabeçalho ou numeração
#set page(
  paper: "a4",
  margin: (x: 2cm, y: 1.8cm),
  numbering: none,
  background: none,
  header: none,
  footer: none,
)
#set text(lang: "pt", font: fonte, size: 11pt, fill: black)
#set par(justify: true, leading: 0.55em, spacing: 0.8em)

// Cabeçalho institucional: logo à esquerda, três linhas centralizadas
#let cabecalho(instituicao, curso, disciplina, logo: "logo-ifpr.png") = {
  grid(
    columns: (3.6cm, 1fr),
    column-gutter: 0.5cm,
    align: horizon,
    image(logo, width: 3.6cm),
    align(center)[
      #set par(justify: false, leading: 0.9em)
      #text(size: 14pt, weight: "bold")[#instituicao] \
      #text(size: 14pt, weight: "bold")[#curso] \
      #text(size: 14pt, weight: "bold")[#disciplina]
    ],
  )
  v(0.2em)
  line(length: 100%, stroke: 0.8pt + black)
  v(0.3em)
}

// ===== Título e subtítulo =====
#let titulo(texto, subtitulo: none) = {
  align(center)[
    #set par(justify: false)
    #text(size: 17pt, weight: "bold")[#texto]
    #if subtitulo != none {
      v(0.15em)
      text(size: 12pt, fill: luma(90))[#subtitulo]
    }
  ]
  v(0.4em)
}

// Lista de questões numeradas "1)", "2)"...
#let questoes(..itens) = {
  set enum(numbering: "1)", indent: 0.8cm, body-indent: 0.5em, spacing: 0.7em)
  set par(justify: false)
  enum(..itens.pos())
}

// Descrição de um horizonte: nome + profundidade em negrito/recuo deslocado
#let horizonte(nome, prof, corpo) = block(width: 100%, above: 0.9em, below: 0.4em)[
  #set par(hanging-indent: 1.3cm, justify: true)
  #nome#h(0.5em)#prof,#h(0.3em)#corpo
]


// ===== Características morfológicas: cor + símbolo =====
// Cada característica tem uma cor de texto e um símbolo geométrico próprio.
#let simbolo(forma, cor, tam: 0.8em) = box(
  width: tam, height: tam, baseline: 0.1em,
  {
    if forma == "circulo" { circle(radius: tam / 2, fill: cor, stroke: none) }
    else if forma == "quadrado" { rect(width: tam * 0.9, height: tam * 0.9, fill: cor, stroke: none) }
    else if forma == "triangulo" { polygon.regular(vertices: 3, size: tam, fill: cor, stroke: none) }
    else if forma == "losango" { rotate(45deg, rect(width: tam * 0.65, height: tam * 0.65, fill: cor, stroke: none)) }
    else if forma == "pentagono" { polygon.regular(vertices: 5, size: tam, fill: cor, stroke: none) }
    else if forma == "hexagono" { polygon.regular(vertices: 6, size: tam, fill: cor, stroke: none) }
    else if forma == "estrela" {
      let r1 = tam / 2
      let r2 = tam / 4.5
      let pts = range(10).map(i => {
        let r = if calc.even(i) { r1 } else { r2 }
        let a = -90deg + i * 36deg
        (r1 + r * calc.cos(a), r1 + r * calc.sin(a))
      })
      polygon(fill: cor, stroke: none, ..pts.map(p => (p.at(0), p.at(1))))
    }
  },
)

#let caracteristicas = (
  cor:          (nome: "Cor",          cor: rgb("#8B4513"), forma: "circulo"),
  textura:      (nome: "Textura",      cor: rgb("#D32F2F"), forma: "quadrado"),
  estrutura:    (nome: "Estrutura",    cor: rgb("#1565C0"), forma: "triangulo"),
  poros:        (nome: "Poros",        cor: rgb("#7B1FA2"), forma: "losango"),
  consistencia: (nome: "Consistência", cor: rgb("#2E7D32"), forma: "pentagono"),
  transicao:    (nome: "Transição",    cor: rgb("#E65100"), forma: "hexagono"),
  raizes:       (nome: "Raízes",       cor: rgb("#00796B"), forma: "estrela"),
)

// Um item: símbolo + rótulo em negrito + valor, tudo na cor da característica
#let item-carac(chave, valor) = {
  let c = caracteristicas.at(chave)
  [#simbolo(c.forma, c.cor) #h(0.15em) #text(fill: c.cor, weight: "bold")[#c.nome:] #text(fill: c.cor)[#valor]]
}

// Legenda das características
#let legenda() = block(
  width: 100%, inset: (x: 8pt, y: 6pt), radius: 3pt,
  stroke: 0.6pt + luma(160), fill: luma(248),
)[
  #set par(justify: false)
  #text(weight: "bold", size: 9.5pt)[Legenda:]
  #h(0.5em)
  #for (i, (chave, c)) in caracteristicas.pairs().enumerate() {
    [#simbolo(c.forma, c.cor, tam: 0.75em) #h(0.1em) #text(fill: c.cor, weight: "bold", size: 9.5pt)[#c.nome]]
    if i < caracteristicas.len() - 1 { h(0.9em) }
  }
]

// Card de um horizonte, com cada característica em sua cor e símbolo
#let perfil(nome, prof, ..args) = {
  let d = args.named()
  block(
    width: 100%, breakable: false, above: 0.9em, below: 0.3em,
    inset: (x: 10pt, y: 8pt), radius: 3pt,
    stroke: (left: 4pt + luma(60), rest: 0.5pt + luma(190)),
  )[
    #set par(justify: false, leading: 0.5em)
    #text(size: 12.5pt, weight: "bold")[#nome] #h(0.4em)
    #text(size: 10.5pt, fill: luma(90))[#prof]
    #v(0.35em)
    #for chave in ("cor", "textura", "estrutura", "poros", "consistencia", "transicao", "raizes") {
      if chave in d {
        item-carac(chave, d.at(chave))
        linebreak()
      }
    }
  ]
}
