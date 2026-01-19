
# =========================================
# Global configuration for plots and figures
#
# This file defines:
# - Global color mappings
# - Selected countries and continents
# - A project-wide ggplot2 theme
#
# These objects control the appearance of all plots.
# =========================================

# ---- Color palette for countries and continents ----
#
# Named vector mapping entity names to colors.
# Used consistently across all line, box, and scatter plots.

global.colors <- c(
  "United States"      = "#EE7733",
  "Thailand"              = "#0077BB",
  "Germany"            = "#EE3377",
  "Zambia"               = "#009988",
  "Australia"          = "#AA4499",
  "Brazil"             = "#F2CD5D",
  "Africa (WID)"        = "darkgreen",
  "Asia (WID)"          = "#004488",
  "Europe (WID)"        = "#EE3377",
  "North America (WID)" = "#EE7733",
  "Oceania (WID)"       = "#AA4499",
  "South America (WID)" = "#F2CD5D"
)

# ---- Countries highlighted in comparative plots ----
#
# These countries are used in:
# - Time-series plots
# - Boxplots
# - Highlighted scatter plots

sel.countries <- c(
  "United States", "Brazil", "Germany",
  "Zambia", "Thailand", "Australia"
)

# ---- Continent aggregates ----
#
# Used to distinguish continent-level plots
# from country-level plots and to set legend titles.

continents <- c(
  "Africa (WID)", "Asia (WID)", "Europe (WID)",
  "North America (WID)", "Oceania (WID)",
  "South America (WID)"
)

# ---- Global ggplot2 theme ----
#
# This theme is applied automatically to *all* ggplot objects
# via theme_set(). Individual plot functions may add
# additional theme() calls on top of this base.

theme_set(
  theme_minimal(base_size = 10) +
    theme(
      # Center plot titles and subtitles
      plot.title    = element_text(hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5),
      
      # Legend appearance
      legend.title     = element_text(size = 15),
      legend.text      = element_text(size = 10),
      legend.key.size  = unit(1, "lines"),
      legend.box.margin = margin_auto(1),
      legend.position  = "right",
      
      # Axis styling
      axis.ticks.length = unit(0.3, "cm"),
      axis.ticks        = element_line(linewidth = 0.5),
      
      # Panel styling
      panel.border     = element_rect(color = "black", fill = NA),
      panel.grid.minor = element_blank()
    )
)
