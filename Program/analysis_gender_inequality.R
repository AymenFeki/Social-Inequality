# =========================================
# Gender Inequality Analysis (GII)
# =========================================
#
# This script analyzes gender inequality using the
# Gender Inequality Index (GII).
#
# It produces:
#   - a population-weighted density plot of GII,
#   - time-series trends for selected countries,
#   - cross-country comparisons using boxplots.
#
# All figures are saved to the Results/ directory.
#
# Dependencies:
# - env_setup.R (packages, helper functions, configuration)
# =========================================

# ---- 1. Distribution of Gender Inequality ----
#
# Population-weighted density of the Gender Inequality Index
# across all countries.

gii.density <- plot_density(
  df    = countries.data,
  var   = "gii",
  xlab = "GII"
)

ggsave(
  filename = "gii_density.png",
  plot     = gii.density,
  path     = "Results",
  width    = 12,
  height   = 8,
  units    = "in",
  dpi      = 600
)


# ---- 2. Gender Inequality over Time (Countries) ----
#
# Time-series trends for selected countries

gii.countries.plot <- plot_line(
  df         = countries.data,
  yvar       = "gii",
  sel        = sel.countries,
  colors     = global.colors,
  xlab       = "Year",
  ylab       = "GII"
)

ggsave(
  filename = "gii_countries.png",
  plot     = gii.countries.plot,
  path     = "Results",
  width    = 12,
  height   = 8,
  units    = "in",
  dpi      = 600
)


# ---- 3. Cross-country Comparison ----
#
# Boxplot comparison of gender inequality across
# selected countries.

gii.countries.boxplot <- plot_box(
  df     = countries.data,
  yvar   = "gii",
  sel    = sel.countries,
  colors = global.colors,
  ylab   = "GII",
  subtitle = "Boxplots summarize gender inequality over time for each country"
)

ggsave(
  filename = "gii_countries_boxplot.png",
  plot     = gii.countries.boxplot,
  path     = "Results",
  width    = 12,
  height   = 8,
  units    = "in",
  dpi      = 600
)