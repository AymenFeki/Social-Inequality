
# =========================================
# Income Inequality Analysis (Gini Index before and after tax)
# =========================================
#
# This script analyzes income inequality using the Gini index.
#
# It produces:
#   - a population-weighted density plot,
#   - time-series trends for continents,
#   - time-series trends for selected countries,
#   - cross-country comparisons using boxplots.
#
# All figures are saved to the Results/ directory.
#
# Dependencies:
# - env_setup.R (packages, helper functions, configuration)
# =========================================

# ---- 1. Distribution of Income Inequality ----
#
# Population-weighted density of the Gini index
# across all countries.

gini.density <- plot_density(
  df    = countries.data,
  var   = "aftertax.gini",
  xlab = "Gini Index (After Tax)"
)

ggsave(
  filename = "gini_density.png",
  plot     = gini.density,
  path     = "Results",
  width    = 12,
  height   = 8,
  units    = "in",
  dpi      = 600
)


# ---- 2. Income Inequality over Time (Continents) ----
#
# Time-series trends for continents

gini.continents.plot <- plot_line(
  df       = regions,
  yvar     = "beforetax.gini",
  sel      = continents,
  colors   = global.colors,
  xlab     = "Year",
  ylab     = "Gini Index (After Tax)"
)

ggsave(
  filename = "gini_continents.png",
  plot     = gini.continents.plot,
  path     = "Results",
  width    = 12,
  height   = 8,
  units    = "in",
  dpi      = 600
)


# ---- 3. Income Inequality over Time (Countries) ----
#
# Time-series trends for selected countries

gini.countries.plot <- plot_line(
  df         = countries.data,
  yvar       = "aftertax.gini",
  sel        = sel.countries,
  colors     = global.colors,
  xlab       = "Year",
  ylab       = "Gini Index (After Tax)"
)

ggsave(
  filename = "gini_countries.png",
  plot     = gini.countries.plot,
  path     = "Results",
  width    = 12,
  height   = 8,
  units    = "in",
  dpi      = 600
)


# ---- 4. Cross-country Comparison ----
#
# Boxplot comparison of income inequality
# across selected countries.

gini.countries.boxplot <- plot_box(
  df     = countries.data,
  yvar   = "aftertax.gini",
  sel    = sel.countries,
  colors = global.colors,
  ylab   = "Gini Index (After Tax)",
  subtitle = "Boxplots summarize income inequality over time for each country"
)

ggsave(
  filename = "gini_countries_boxplot.png",
  plot     = gini.countries.boxplot,
  path     = "Results",
  width    = 12,
  height   = 8,
  units    = "in",
  dpi      = 600
)
