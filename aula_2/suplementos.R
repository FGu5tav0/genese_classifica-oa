library(ggplot2)
library(dplyr)
library(patchwork)
library(ggrepel)

# Dados -----------------------------------------------------------------

dados_a <- data.frame(
  grupo = c("Rocha\nsedimentar", "Rocha\nígnea", "Rocha\nmetamórfica"),
  valor = c(74, 18, 8)
)

dados_b <- data.frame(
  grupo = c("Rocha\nígnea", "Rocha\nmetamórfica", "Rocha\nsedimentar"),
  valor = c(65, 27, 8)
)

# Paleta fixa por categoria (mesma cor nos dois gráficos) ----------------

paleta <- c(
  "Rocha\nsedimentar" = "#C9A24B",
  "Rocha\nígnea" = "#9E4B3F",
  "Rocha\nmetamórfica" = "#4C6C7A"
)

# Função ------------------------------------------------------------------

graf_prop <- function(dados, titulo = "") {
  dados <- dados |>
    arrange(desc(grupo)) |>
    mutate(
      ymax = cumsum(valor),
      ymin = lag(ymax, default = 0),
      label = paste0(grupo, "\n", valor, "%"),
      pos = (ymax + ymin) / 2
    )

  ggplot(dados) +
    geom_rect(
      aes(
        xmin = 0,
        xmax = 1,
        ymin = ymin,
        ymax = ymax,
        fill = grupo
      ),
      color = "white",
      linewidth = 0.8
    ) +
    coord_polar(theta = "y", clip = "off") +
    xlim(0, 1.7) +
    geom_label_repel(
      aes(
        x = 1,
        y = pos,
        label = label,
        color = grupo
      ),
      nudge_x = 0.55,
      direction = "y",
      min.segment.length = 0,
      segment.size = 0.5,
      segment.curvature = 0,
      box.padding = 0.35,
      point.padding = 0.1,
      hjust = 0,
      lineheight = 0.9,
      fill = "white",
      label.size = 0,
      family = "serif",
      fontface = "bold",
      size = 4.6
    ) +
    scale_fill_manual(values = paleta) +
    scale_color_manual(values = paleta) +
    theme_void(base_family = "serif") +
    theme(
      legend.position = "none",
      plot.title = element_text(
        face = "bold",
        size = 18,
        hjust = 0.5
        # margin = margin(b = 8)
      )
      # plot.margin = margin(10, 10, 10, 10)
    ) +
    ggtitle(titulo)
}

# Gráficos ------------------------------------------------------------

p1 <- graf_prop(dados_a, "Rochas na superfície da Terra")
p2 <- graf_prop(dados_b, "Rochas na crosta terrestre")

painel <- (p1 + p2) +
  plot_annotation(
    # title = "Composição dos tipos de rocha",
    theme = theme(
      plot.title = element_text(
        face = "bold",
        family = "serif",
        size = 20,
        hjust = 0.5,
        margin = margin(b = 10)
      )
    )
  )

pt <- painel + ggview::canvas(width = 7, height = 4, dpi = 600)
pt

ggview::save_ggplot(plot = pt, file = "aula_2/imagens/rocha_composicao.jpeg")


# mapa litologico --------------------------------------------------------

library(tidyverse)
library(sf)

dado <- read_sf(
  "aula_2/mapa_litologico/Litologia/brasil_geologico_integrado.shp"
)

ggplot(dado) +
  geom_sf(aes(fill = CLASSE_ROC), linewidth = .1) +
  # scale_fill_viridis_c() +
  labs(
    fill = "Área",
    title = "Mapa"
  ) +
  theme_void() +
  theme(
    legend.position = "right",
    plot.title = element_text(face = "bold", size = 16)
  )
