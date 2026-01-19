
# =========================================
# Societal Impacts of Income Inequality (Averages)
# =========================================
#
# Uses country-level averages from:
#   data.avgs$democracy.index
#   data.avgs$homicide.rate
#   data.avgs$healthcare.access
#
# Each point represents ONE COUNTRY.
# =========================================

# ---- 1. Democracy ----
scatter.gini.democracy <- plot_scatter(
  df   = data.avgs$democracy.index,
  xvar = "gini.avg",
  yvar = "democracy.avg",
  xlab = "Gini Index (After Tax)",
  ylab = "Democracy Index",
  subtitle = "Democracy Index = EIU-DI"
)

suppressWarnings(
  ggsave(
    filename = "scatter_gini_democracy.png",
    plot     = scatter.gini.democracy,
    path     = "Results",
    width    = 12,
    height   = 8,
    units    = "in",
    dpi      = 600
  )
)

# ---- 2. Democracy (Highlighted Countries) ----
scatter.highlight.gini.democracy <- plot_scatter_highlight(
  df     = data.avgs$democracy.index,
  xvar   = "gini.avg",
  yvar   = "democracy.avg",
  sel    = sel.countries,
  colors = global.colors,
  xlab   = "Gini Index (After Tax)",
  ylab   = "Democracy Index",
  subtitle = "Democracy Index = EIU-DI"
)

suppressWarnings(
  ggsave(
    filename = "scatter_highlight_gini_democracy.png",
    plot     = scatter.highlight.gini.democracy,
    path     = "Results",
    width    = 12,
    height   = 8,
    units    = "in",
    dpi      = 600
  )
)

# ---- 3. Homicide Rate ----
scatter.gini.homicide.rate <- plot_scatter(
  df   = data.avgs$homicide.rate,
  xvar = "gini.avg",
  yvar = "homicide.avg",
  xlab   = "Gini Index (After Tax)",
  ylab = "Homicide Rate (per 100,000)"
)

suppressWarnings(
  ggsave(
    filename = "scatter_gini_homicide_rate.png",
    plot     = scatter.gini.homicide.rate,
    path     = "Results",
    width    = 12,
    height   = 8,
    units    = "in",
    dpi      = 600
  )
)

# ---- 4. Homicide Rate (Highlighted Countries) ----
scatter.highlight.gini.homicide.rate <- plot_scatter_highlight(
  df     = data.avgs$homicide.rate,
  xvar   = "gini.avg",
  yvar   = "homicide.avg",
  sel    = sel.countries,
  colors = global.colors,
  xlab   = "Gini Index (After Tax)",
  ylab   = "Homicide Rate (per 100,000)"
)

suppressWarnings(
  ggsave(
    filename = "scatter_highlight_gini_homicide_rate.png",
    plot     = scatter.highlight.gini.homicide.rate,
    path     = "Results",
    width    = 12,
    height   = 8,
    units    = "in",
    dpi      = 600
  )
)

# ---- 5. Healthcare Access ----
scatter.gini.healthcare.access <- plot_scatter(
  df   = data.avgs$healthcare.access,
  xvar = "gini.avg",
  yvar = "healthcare.avg",
  xlab   = "Gini Index (After Tax)",
  ylab = "Healthcare Access (UHC Index)",
  subtitle = " Healcare Access = UHC-SCI"
)

suppressWarnings(
  ggsave(
    filename = "scatter_gini_healthcare_access.png",
    plot     = scatter.gini.healthcare.access,
    path     = "Results",
    width    = 12,
    height   = 8,
    units    = "in",
    dpi      = 600
  )
)

# ---- 6. Healthcare Access (Highlighted Countries) ----
scatter.highlight.gini.healthcare.access <- plot_scatter_highlight(
  df     = data.avgs$healthcare.access,
  xvar   = "gini.avg",
  yvar   = "healthcare.avg",
  sel    = sel.countries,
  colors = global.colors,
  xlab   = "Gini Index (After Tax)",
  ylab   = "Healthcare Access (UHC Index)",
  subtitle = " Healcare Access = UHC-SCI"
)

suppressWarnings(
  ggsave(
    filename = "scatter_highlight_gini_healthcare_access.png",
    plot     = scatter.highlight.gini.healthcare.access,
    path     = "Results",
    width    = 12,
    height   = 8,
    units    = "in",
    dpi      = 600
  )
)
