# =========================================
# Environment Setup Script
# Social Inequality Project
# =========================================
#
# Sourcing this file sets up the complete R environment
# required for running the Social Inequality project.
#
# This script:
# - Sets the working directory (RStudio only)
# - Installs and loads all required CRAN packages
# - Loads global configuration and helper functions
# - Loads and processes the raw data
# - Fixes invalid object names (macOS issue)
# - Defines a flag indicating successful initialization
#
# This script should be run ONCE per session
# before running main.R
# =========================================

# ---- Set working directory ----
#
# When run interactively in RStudio, set the working directory
# to the location of this script so that relative paths work correctly.
# This step is skipped in non-interactive environments.

if (interactive() &&
    requireNamespace("rstudioapi", quietly = TRUE) &&
    rstudioapi::isAvailable()) {
  setwd(dirname(rstudioapi::getSourceEditorContext()$path))
}

# ---- Required packages (CRAN only) ----
#
# These packages are required for data handling, visualization,
# validation, and statistical analysis throughout the project.

packages <- c(
  "dplyr",
  "ggplot2",
  "stringr",
  "forcats",
  "checkmate",
  "countrycode",
  "rlang",
  "purrr",
  "readr",
  "tidyr"
)

# ---- Install and load packages ----
#
# Each package is installed only if missing, then loaded.
# This ensures reproducibility on a clean system.

for (pkg in packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    library(pkg, character.only = TRUE)
  }
}

# ---- Load project configuration and helper functions ----
#
# These scripts define:
# - global.colors, sel.countries, continents
# - ggplot2 theme settings
# - statistical helper functions
# - plotting functions used in all analyses

source("Program/config.R")
source("Program/utils.R")
source("Program/functions.R")

# ---- Prepare and load processed data ----
#
# The data preparation function is executed here ONCE.
# This step:
# - loads raw CSV files
# - cleans and harmonizes datasets
# - saves processed data as RDS files
# - loads the processed data into the global environment

source("Program/load_data.R")
prepare_data()                 # creates/updates RDS if needed
data <- load_processed_data()  # loads into memory

countries.data <- data$countries.data
regions        <- data$regions
data.avgs      <- data$data.avgs

# ---- macOS variable-name sanitation ----
#
# On some macOS systems, object names may contain invalid
# characters such as "/". This loop fixes such names to
# avoid issues with tidyverse and ggplot2 evaluation.

for (var in ls(envir = .GlobalEnv)) {
  if (stringr::str_detect(var, "/")) {
    clean_name <- gsub("/", "", var)
    assign(clean_name, get(var, envir = .GlobalEnv), envir = .GlobalEnv)
    rm(list = var, envir = .GlobalEnv)
  }
}

# ---- Environment initialization flag ----
#
# This flag is checked by main.R to ensure that the environment
# has been properly initialized before any analysis is run.

.env_initialized <- TRUE
message("Environment successfully initialized.")
