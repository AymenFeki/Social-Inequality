
# =========================================
# Data Loading and Preprocessing Script
# =========================================
#
# This script defines the data preparation pipeline for the project.
#
# It providesuser-facing functions:
#
# 1. `prepare_data()`:
#    - loads all raw CSV datasets used in the project,
#    - harmonizes variable names and formats,
#    - merges datasets by country and year,
#    - separates countries from aggregate regions,
#    - computes country-level averages,
#    - saves cleaned datasets as RDS files for reproducible reuse.
#
# 2. `load_processed_data()`:
#    - loads the previously prepared RDS files into memory
#      for fast and reproducible analysis.
#
# This script performs NO analysis or visualization.
# All analysis is handled in separate scripts sourced by main.R.
#
# Dependencies:
# - env_setup.R (packages, helper functions, configuration)
# =========================================

library(dplyr)
library(purrr)

# ---- 1. Prepare and save cleaned datasets ----

#' Prepare and cache all datasets for analysis
#'
#' @description
#' Loads all raw CSV datasets used in the project, standardizes variable names,
#' merges them by country and year, separates countries from aggregate regions,
#' computes country-level averages, and saves the resulting clean datasets
#' as RDS files in the `Work.data/` directory.
#'
#' This function is intended to be run **once per session** (typically from
#' `env_setup.R`). If processed datasets already exist on disk, the function
#' will skip recomputation unless explicitly instructed otherwise.
#'
#' @details
#' The following datasets are loaded and merged:
#' \itemize{
#'   \item Gini Coefficient before tax
#'   \item Gini Coefficient after tax
#'   \item Gender Inequality Index (GII)
#'   \item Democracy Index
#'   \item Homicide Rate
#'   \item Healthcare Access Index (SCI)
#'   \item Population
#' }
#'
#' All datasets are merged using `country` and `year`.
#' Aggregate regions are separated from country-level observations
#' using helper utilities defined in `utils.R`.
#'
#' The resulting objects are saved as:
#' \itemize{
#'   \item `Work.data/countries-data.rds`
#'   \item `Work.data/regions.rds`
#'   \item `Work.data/data-avgs.rds`
#' }
#'
#' @param overwrite Logical. If `TRUE`, forces regeneration of the processed
#'   datasets even if cached RDS files already exist. Default is `FALSE`.
#'
#' @return Invisibly returns `NULL`. This function is called for its
#'   side effects (data preparation and saving).
#'
#' @examples
#' \dontrun{
#' # Prepare data from raw CSV files
#' prepare_data()
#'
#' # Force regeneration of cached datasets
#' prepare_data(overwrite = TRUE)
#' }

prepare_data <- function(overwrite = FALSE) {
  
  # ---- Skip preparation if data already exists ----
  if (!overwrite &&
      file.exists("Work.data/countries-data.rds") &&
      file.exists("Work.data/regions.rds") &&
      file.exists("Work.data/data-avgs.rds")) {
    return(invisible(NULL))
  }
  
  # ---- Load raw datasets ----
  
  df.gini.beforetax <- read.csv("Data/beforetax-gini-coefficient.csv") %>% 
    rename(
      country = Country,
      year = Year,
      beforetax.gini = Gini.coefficient..before.tax...World.Inequality.Database.
    )
  
  df.gini.aftertax <- read.csv("Data/aftertax-gini-coefficient.csv") %>% 
    rename(
      aftertax.gini = gini
    )
  
  df.gii <- read.csv("Data/gender-inequality-index.csv") %>% 
    rename(
      country = Entity,
      code    = Code,
      year    = Year,
      gii     = Gender.Inequality.Index
    )
  
  df.democracy <- read.csv("Data/EIU-democracy-index.csv") %>% 
    rename(
      country   = Entity,
      code      = Code,
      year      = Year,
      EIUDI = Democracy.index
    )
  
  df.homicide <- read.csv("Data/homicide-rate.csv") %>% 
    rename(
      country       = Entity,
      code          = Code,
      year          = Year,
      homicide.rate = Homicide.rate.per.100.000.population...sex..Total...age..Total
    )
  
  df.SCI <- read.csv("Data/UHC-service-coverage-index.csv") %>% 
    rename(
      country = Entity,
      year    = Year,
      SCI     = UHC.service.coverage.index
    )
  
  df.pop <- read.csv("Data/world-population.csv") %>% 
    rename(
      country    = Entity,
      code       = Code,
      year       = Year,
      population = Population...Sex..all...Age..all...Variant..estimates
    )
  
  # ---- Merge datasets ----
  
  raw.data <- reduce(
    list(df.gini.beforetax, df.gini.aftertax, df.democracy, df.homicide, df.gii, df.SCI, df.pop),
    ~ left_join(.x, .y, by = c("country", "year"))
  ) %>%
    select(
      country,
      year,
      beforetax.gini,
      aftertax.gini,
      gii,
      EIUDI,
      homicide.rate,
      SCI,
      population
    ) %>%
    filter(year >= 2000, year <= 2023)
  
  # ---- Separate countries and regions ----
  
  separated <- seperate_data(raw.data)
  countries.data <- separated$countries
  regions <- separated$regions %>%
    mutate(
      country = dplyr::recode(
        country,
        "Latin America (WID)" = "South America (WID)"
      )
    )

  # ---- Compute country averages ----
  #
  # Country-level averages for (after-tax Gini) vs. each societal outcome.
  # Each row represents one country.
  
  gini_democracy_avgs <- compute_country_averages(
    countries.data,
    xvar = "aftertax.gini",
    yvar = "EIUDI"
  ) %>%
    rename(
      gini.avg      = x.avg,
      democracy.avg = y.avg
    )
  
  gini_homicide_avgs <- compute_country_averages(
    countries.data,
    xvar = "aftertax.gini",
    yvar = "homicide.rate"
  ) %>%
    rename(
      gini.avg     = x.avg,
      homicide.avg = y.avg
    )
  
  gini_health_avgs <- compute_country_averages(
    countries.data,
    xvar = "aftertax.gini",
    yvar = "SCI"
  ) %>%
    rename(
      gini.avg       = x.avg,
      healthcare.avg = y.avg
    )
  
  data.avgs <- list(
    democracy.index    = gini_democracy_avgs,
    homicide.rate      = gini_homicide_avgs,
    healthcare.access  = gini_health_avgs
  )
  
  # ---- Save processed datasets ----
  
  saveRDS(countries.data, "Work.data/countries-data.rds")
  saveRDS(regions,        "Work.data/regions.rds")
  saveRDS(data.avgs,      "Work.data/data-avgs.rds")
}

# ---- 2. Load processed datasets ----

#' Load cached, processed datasets
#'
#' @description
#' Loads cleaned datasets previously generated by `prepare_data()`
#' from the Work.data/ directory.
#'
#' @return A named list containing country-level data, regional aggregates,
#' and the country-average datasets used for the scatter plots.
load_processed_data <- function() {
  
  list(
    countries.data = readRDS("Work.data/countries-data.rds"),
    regions        = readRDS("Work.data/regions.rds"),
    data.avgs      = readRDS("Work.data/data-avgs.rds")
  )
}  
