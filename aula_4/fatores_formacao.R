library(DiagrammeR)

library(DiagrammeRsvg)
library(rsvg)

diagrama <- grViz(
  "
digraph fatores_solo {

  graph [
    layout = neato,
    overlap = false,
    splines = false,
    bgcolor = white,
    margin = 0
  ]

  node [
    fontname = Helvetica,
    fontcolor = black
  ]

  # ---------------------------------------------------------
  # Título
  # ---------------------------------------------------------

  titulo [
    label = 'Fatores de formação do solo',
    shape = plaintext,
    fontsize = 26,
    pos = '0,5.2!',
    pin = true
  ]

  # ---------------------------------------------------------
  # Estrela central
  # ---------------------------------------------------------

  solo [
    label = 'Solo',
    shape = star,
    sides = 5,
    style = filled,
    fillcolor = '#FFC000',
    color = black,
    penwidth = 1,
    fontsize = 28,
    width = 2.8,
    height = 2.8,
    fixedsize = true,
    pos = '0,2.2!',
    pin = true
  ]

  # ---------------------------------------------------------
  # Cinco fatores
  # ---------------------------------------------------------

  material [
    label = 'Material de\\norigem',
    shape = plaintext,
    fontsize = 22,
    pos = '0,4.25!',
    pin = true
  ]

  clima [
    label = 'Clima',
    shape = plaintext,
    fontsize = 22,
    pos = '3.25,2.70!',
    pin = true
  ]

  organismos [
    label = 'Organismos',
    shape = plaintext,
    fontsize = 22,
    pos = '-3.25,2.70!',
    pin = true
  ]

  relevo [
    label = 'Relevo',
    shape = plaintext,
    fontsize = 22,
    pos = '-1.85,0.15!',
    pin = true
  ]

  tempo [
    label = 'Tempo',
    shape = plaintext,
    fontsize = 22,
    pos = '1.85,0.15!',
    pin = true
  ]

}
"
)

# Visualizar
diagrama

# ---------------------------------------------------------
# Exportar para SVG
# ---------------------------------------------------------

svg_xml <- export_svg(diagrama)

writeLines(
  svg_xml,
  "fatores_formacao_solo.svg"
)

# ---------------------------------------------------------
# Exportar para PNG
# ---------------------------------------------------------

rsvg_png(
  charToRaw(svg_xml),
  file = "fatores_formacao_solo.png",
  width = 1600,
  height = 1000
)


# segundo ----------------------------------------------------------------

library(DiagrammeR)
library(DiagrammeRsvg)
library(rsvg)

g <- grViz(
  "
digraph solos {

  graph [layout = dot, rankdir = LR, bgcolor = 'white', splines = spline,
         nodesep = 0.3, ranksep = 0.55, fontname = 'Helvetica',
         pad = 0.35, compound = true]

  node [shape = box, style = 'rounded,filled', fontname = 'Helvetica',
        fontsize = 12, fontcolor = '#1A1A1A', color = '#9AA5B1',
        fillcolor = '#F4F6F8', penwidth = 1.2, margin = '0.16,0.09', height = 0.42]

  edge [fontname = 'Helvetica', fontsize = 10, fontcolor = '#3D4852',
        color = '#8C97A3', penwidth = 1.3, arrowsize = 0.7]

  # ---------------- ORIGEM ----------------
  subgraph cluster_origem {
    label = 'ORIGEM'
    fontname = 'Helvetica-Bold'; fontsize = 11; fontcolor = '#6B7480'
    style = 'rounded,dashed'; color = '#C3CBD4'; margin = 14
    rocha   [label = 'Minerais\\ne rochas', fillcolor = '#E8E2D5', color = '#B9AC91']
    plantas [label = 'Plantas',             fillcolor = '#DFF0D8', color = '#8FBF77']
  }

  # ---------------- FORMADOS NO LOCAL ----------------
  subgraph cluster_insitu {
    label = 'FORMADOS NO LOCAL'
    fontname = 'Helvetica-Bold'; fontsize = 11; fontcolor = '#6B7480'
    style = 'rounded,dashed'; color = '#C3CBD4'; margin = 14
    residual [label = 'Material\\nRESIDUAL', fontname = 'Helvetica-Bold',
              fillcolor = '#EFE3C8', color = '#C9A227']
    organico [label = 'Material\\nORGÂNICO', fontname = 'Helvetica-Bold',
              fillcolor = '#CDE8C4', color = '#5E9E4A']
  }

  # ---------------- TRANSPORTADOS ----------------
  subgraph cluster_transp {
    label = 'MATERIAIS DE ORIGEM TRANSPORTADOS'
    fontname = 'Helvetica-Bold'; fontsize = 11; fontcolor = '#4A5561'
    style = 'rounded'; color = '#AEBCC9'; bgcolor = '#FAFBFC'; margin = 16

    subgraph cluster_agua {
      label = 'pela água'; fontsize = 10; fontcolor = '#2F6690'
      style = 'rounded,dashed'; color = '#9CC2DE'; margin = 12
      lacustre [label = 'Lacustre',          fillcolor = '#D6E9F8', color = '#6FA8D6']
      aluvial  [label = 'Aluvial (fluvial)', fillcolor = '#D6E9F8', color = '#6FA8D6']
      marinho  [label = 'Marinho',           fillcolor = '#D6E9F8', color = '#6FA8D6']
    }

    subgraph cluster_gelo {
      label = 'pelo gelo'; fontsize = 10; fontcolor = '#4F6678'
      style = 'rounded,dashed'; color = '#A9BCC9'; margin = 12
      morenas [label = 'Morenas, till', fillcolor = '#DDE7EF', color = '#8FA9BF']
      outros  [label = 'Outwash, lacustre,\\naluvial, marinho',
               fillcolor = '#D6E9F8', color = '#6FA8D6']
    }

    subgraph cluster_seco {
      label = 'vento / gravidade'; fontsize = 10; fontcolor = '#8A6D1E'
      style = 'rounded,dashed'; color = '#D8C79A'; margin = 12
      eolico   [label = 'Eólico\\n(loess, dunas)', fillcolor = '#F7EBC4', color = '#D9B441']
      coluvial [label = 'Coluvial',                fillcolor = '#EADFD2', color = '#B08968']
    }
  }

  # ---------------- Nós de bifurcação ----------------
  node [shape = point, width = 0.07, color = '#8C97A3', fillcolor = '#8C97A3', label = '']
  agua; gelo; degelo;

  # ---------------- Fluxos ----------------
  rocha   -> residual [label = 'intemperismo\\nno local',   color = '#8A7A55', fontcolor = '#6B5E3F']
  plantas -> organico [label = 'acúmulo em\\náreas úmidas', color = '#5E9E4A', fontcolor = '#3F6B32']

  residual -> agua     [label = 'água',      color = '#4A90C4', fontcolor = '#2F6690']
  residual -> gelo     [label = 'gelo',      color = '#7E97AB', fontcolor = '#4F6678']
  residual -> eolico   [label = 'vento',     color = '#D9B441', fontcolor = '#9A7C1E']
  residual -> coluvial [label = 'gravidade', color = '#B08968', fontcolor = '#7A5C42']

  agua -> lacustre [label = 'lagos',   color = '#4A90C4', fontcolor = '#2F6690']
  agua -> aluvial  [label = 'rios',    color = '#4A90C4', fontcolor = '#2F6690']
  agua -> marinho  [label = 'oceanos', color = '#4A90C4', fontcolor = '#2F6690']

  gelo   -> morenas [label = 'deposição\\ndireta', color = '#7E97AB', fontcolor = '#4F6678']
  gelo   -> degelo  [label = 'água de degelo',     color = '#7E97AB', fontcolor = '#4F6678']
  degelo -> outros  [label = 'fluvioglacial',      color = '#4A90C4', fontcolor = '#2F6690']
}
"
)

g

# Exportar em alta resolução
svg <- charToRaw(export_svg(g))
rsvg_png(svg, "materiais_origem_solo.png", width = 3000)
rsvg_pdf(svg, "materiais_origem_solo.pdf")


# processos --------------------------------------------------------------
library(DiagrammeR)

grViz(
  "
digraph processos {

  graph [
    layout = neato,
    overlap = false,
    splines = curved,
    bgcolor = 'white',
    margin = 0.2
  ]

  node [
    shape = circle,
    style = filled,
    fillcolor = 'white',
    color = '#555555',
    penwidth = 1.5,
    fontname = 'Arial',
    fontsize = 13,
    fixedsize = true,
    width = 1.65,
    height = 1.65
  ]

  edge [
    color = '#777777',
    penwidth = 1.6,
    arrowsize = 0.7
  ]


  # =====================================================
  # CENTRO
  # =====================================================

  centro [
    label = 'Processos\\npedogenéticos',
    fillcolor = '#D9EAF7',
    color = '#1F4E79',
    penwidth = 3,
    fontsize = 18,
    width = 2.6,
    height = 2.6,
    pos = '0,0!'
  ]


  # =====================================================
  # PROCESSOS
  # =====================================================

  latolizacao [
    label = 'Latolização\\nou\\nFerralitização',
    pos = '0,5!'
  ]

  paludizacao [
    label = 'Paludização',
    pos = '-3.5,4!'
  ]

  podzolizacao [
    label = 'Podzolização',
    pos = '3.5,4!'
  ]

  gleizacao [
    label = 'Gleização',
    pos = '5.5,1.5!'
  ]

  ferrolise [
    label = 'Ferrólise',
    pos = '5.5,-1.5!'
  ]

  melanizacao [
    label = 'Melanização',
    pos = '3.5,-4!'
  ]

  lessivagem [
    label = 'Argiluviação\\nou\\nLessivagem',
    pos = '0,-5.5!'
  ]

  plintizacao [
    label = 'Plintização\\ne Laterização',
    pos = '-3.5,-4!'
  ]

  vertizacao [
    label = 'Vertização',
    pos = '-5.5,-1.5!'
  ]

  sulfurizacao [
    label = 'Sulfidização e\\nSulfurização\\n(Tiomorfismo)',
    pos = '-5.5,1.5!'
  ]

  sodificacao [
    label = 'Sodificação e\\nSolodização',
    pos = '-3.5,6.5!'
  ]

  leucinização [
    label = 'Leucinização',
    pos = '3.5,6.5!'
  ]

  salinizacao [
    label = 'Salinização',
    pos = '7,4!'
  ]


  # =====================================================
  # CONEXÕES COM O CENTRO
  # =====================================================

  centro -> latolizacao
  centro -> paludizacao
  centro -> podzolizacao
  centro -> gleizacao
  centro -> ferrolise
  centro -> melanizacao
  centro -> lessivagem
  centro -> plintizacao
  centro -> vertizacao
  centro -> sulfurizacao
  centro -> sodificacao
  centro -> leucinização
  centro -> salinizacao

}
"
) -> dia

dia

svg_xml <- export_svg(dia)

writeLines(
  svg_xml,
  "aula_4/imagens/processos.svg"
)
