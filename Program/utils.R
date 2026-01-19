
# =========================================
# utils.R
# Helper and statistical utility functions
# =========================================

library(checkmate)
library(dplyr)
library(countrycode)

# ---- 1. Remove "(WID)" from region names ----
#'
#' @description Cleans continent or region names by removing the "(WID)" suffix
#'              for improved legend readability.
#'
#' @param x Character vector. Region or continent names.
#'
#' @return Character vector of cleaned names.
remove_wid <- function(x) {
  assert_character(x, any.missing = FALSE)
  gsub(" \\(WID\\)", "", x)
}

# ---- 2. Assert presence of required columns ----
#'
#' @description Checks whether a data frame contains a given set of columns.
#'
#' @param  df Data frame.
#' @param cols Character vector. Names of required columns.
#'
#' @return NULL. Throws an error if columns are missing.
assert_columns <- function(df, cols) {
  assert_data_frame(df)
  assert_character(cols, any.missing = FALSE)
  assert_names(colnames(df), must.include = cols)
}

# ---- 3. Compute Spearman rank correlation ----
#'
#' @description Computes Spearman's rank correlation coefficient between
#'              two numeric variables.
#'
#' @param df Data frame containing the variables.
#' @param var1 Character string. Name of the first numeric variable.
#' @param var2 Character string. Name of the second numeric variable.
#'
#' @return Numeric scalar. Spearman correlation coefficient (ρ).
compute_spearman <- function(df, var1, var2) {
  assert_columns(df, c(var1, var2))
  assert_numeric(df[[var1]], any.missing = TRUE)
  assert_numeric(df[[var2]], any.missing = TRUE)
  
  cor(
    df[[var1]],
    df[[var2]],
    method = "spearman",
    use = "complete.obs"
  )
}

# ---- 4. Separate country-level and region-level data ----
#'
#' @description Splits a data frame into country-level observations
#'              and aggregated regional observations using ISO3 codes.
#'
#' @param df Data frame containing a `country` column (character).
#'
#' @return List with two data frames:
#' \describe{
#'   \item{countries}{Country-level data frame}
#'   \item{regions}{Region-level data frame}
#' }
seperate_data <- function(df) {
  assert_data_frame(df)
  
  df_flagged <- df %>%
    mutate(
      iso3 = countrycode(country, "country.name", "iso3c", warn = FALSE)
    )
  
  list(
    countries = df_flagged %>% filter(!is.na(iso3)) %>% select(-iso3),
    regions   = df_flagged %>% filter(is.na(iso3))  %>% select(-iso3)
  )
}

# ---- 5. Compute population-weighted mean and median ----
#'
#' @description Calculates population-weighted mean and median
#'              for a numeric variable.
#'
#' @param df Data frame.
#' @param var Character string. Name of numeric variable of interest.
#' @param weight Character string. Name of numeric weight variable
#'               (default: "population").
#'
#' @return List containing:
#' \describe{
#'   \item{mean}{Numeric. Population-weighted mean}
#'   \item{median}{Numeric. Population-weighted median}
#' }
weighted_stats <- function(df, var, weight = "population") {
  
  # ---- Input checks ----
  assert_choice(var, names(df))
  assert_choice(weight, names(df))
  
  # ---- Remove missing and invalid values ----
  df <- df %>%
    filter(
      !is.na(.data[[var]]),
      !is.na(.data[[weight]]),
      .data[[weight]] > 0
    )
  
  x <- df[[var]]
  w <- df[[weight]]
  
  # ---- Weighted mean ----
  w.mean <- sum(w * x) / sum(w)
  
  # ---- Weighted median ----
  ord <- order(x)
  x <- x[ord]
  w <- w[ord]
  cum_w <- cumsum(w) / sum(w)
  w.med <- x[which(cum_w >= 0.5)[1]]
  
  list(
    mean   = w.mean,
    median = w.med
  )
}

# ---- 6. Compute country-level averages for two variables ----
#'
#' @description Computes country-level averages for two variables
#'              independently over all available observations.
#'
#' @details
#' The procedure is as follows:
#' \enumerate{
#'   \item Select country–year observations for the two variables.
#'   \item Compute country-level means separately for each variable.
#'   \item Retain one row per country.
#' }
#'
#' @param df Data frame containing country–year observations.
#' @param xvar Character string. Name of the first numeric variable (e.g. Gini).
#' @param yvar Character string. Name of the second numeric variable
#'             (e.g. democracy, homicide rate, healthcare access).
#'
#' @return Data frame with one row per country and the following columns:
#' \describe{
#'   \item{country}{Country name}
#'   \item{x.avg}{Average of `xvar` over all available years}
#'   \item{y.avg}{Average of `yvar` over all available years}
#' }
#'
#' @examples
#' \dontrun{
#' df_avg <- compute_country_averages(
#'   countries.data,
#'   xvar = "aftertax.gini",
#'   yvar = "democracy"
#' )
#' }

compute_country_averages <- function(df, xvar, yvar) {
  
  assert_data_frame(df)
  assert_choice(xvar, names(df))
  assert_choice(yvar, names(df))
  
  df %>%
    group_by(country) %>%
    summarise(
      x.avg = mean(.data[[xvar]], na.rm = TRUE),
      y.avg = mean(.data[[yvar]], na.rm = TRUE),
      .groups = "drop"
    )
}
