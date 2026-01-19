# =========================================
# Main Analysis Script
# Social Inequality Project
# =========================================
# This script orchestrates the full analysis workflow.
#
# IMPORTANT:
# - This script assumes that `env_setup.R` has already been run
#   in the current R session.
#
# This script performs NO setup and NO package loading.
# =========================================

# ---- Environment guard ----
# Ensures that the analysis is only run after the environment
# has been properly initialized via env_setup.R.

if (!exists(".env_initialized", inherits = FALSE) ||
    !isTRUE(.env_initialized)) {
  stop(
    "Environment not initialized.\n",
    "Please run `env_setup.R` before running `Main.R`."
  )
}

# ---- Analysis sections ----

# =========================================
# 1. Income Inequality (Gini Index)
# =========================================
#
# This section analyzes income inequality over time and across countries
# using the Gini index.
#
# The sourced script:
#   - creates population-weighted density plots
#   - generates time-series plots for continents and selected countries
#   - compares cross-country differences using boxplots
#   - saves all resulting figures to the Results/ directory
source("Program/analysis_income_inequality.R")

gini.density
gini.continents.plot
gini.countries.plot
gini.countries.boxplot

# =========================================
# 2. Gender Inequality (GII)
# =========================================
#
# This section mirrors the income inequality analysis but focuses on
# the Gender Inequality Index (GII).
#
# The sourced script:
#   - - creates population-weighted density plot
#   - generates time-series plot for selected countries
#   - compares cross-country differences using boxplots
#   - saves all resulting figures to the Results/ directory
source("Program/analysis_gender_inequality.R")

gii.density
gii.countries.plot
gii.countries.boxplot

# =========================================
# 3. Societal Impacts of Inequality
# =========================================
#
# This section investigates how income inequality relates to
# broader societal outcomes.
#
# The analysis focuses on:
#   - Democracy
#   - Homicide rate
#   - Healthcare access
#
# The sourced script:
#   - creates scatter plots using Spearman correlation
#   - highlights selected countries in comparative plots
#   - exports all figures to the Results/ directory
source("Program/analysis_societal_impacts.R")

scatter.gini.democracy
scatter.highlight.gini.democracy
scatter.gini.homicide.rate
scatter.highlight.gini.homicide.rate
scatter.gini.healthcare.access
scatter.highlight.gini.healthcare.access
