
# =========================================
# Plotting Functions for Social Inequality
# =========================================

# ---- Setup ----

library(ggplot2)
library(dplyr)
library(forcats)
library(checkmate)

# ---- 1. Time series plots ----

#' Plot time-series trends for selected countries or regions
#'
#' @param df Data frame with columns country, year, and yvar
#' @param yvar Character. Numeric variable name
#' @param sel Character vector of countries or regions
#' @param colors Named character vector for colors
#' @param xlab Character. X-axis label
#' @param ylab Character. Y-axis label
#' @param title Character. Plot title
#' @param subtitle Character. Plot subtitle
#'
#' @return ggplot object
plot_line <- function(df, yvar, sel, colors, xlab, ylab, title = "", subtitle = "") {
  
  assert_data_frame(df)
  assert_choice(yvar, names(df))
  assert_numeric(df[[yvar]], any.missing = TRUE)
  assert_character(sel, any.missing = FALSE)
  assert_true(length(sel) > 0)
  assert_character(xlab, len = 1)
  assert_character(ylab, len = 1)
  assert_character(title, len = 1)
  assert_character(subtitle, len = 1)
  
  
  # Determine legend title
  legend.title <- if (all(sel %in% continents)) "Continent" else "Country"
  
  # Create time-series plot
  ggplot(
    df %>% filter(country %in% sel, !is.na(.data[[yvar]])),
    aes(
      x = year,
      y = .data[[yvar]],
      color = country,
      group = country
    )
  ) +
    geom_line(linewidth = 0.5, alpha = 0.7) +
    geom_point(size = 1.5, alpha = 1) +
    scale_color_manual(values = colors, labels = remove_wid) +
    labs(
      x = xlab,
      y = ylab,
      title = title,
      subtitle = subtitle,
      color = legend.title
    ) +
    guides(color = guide_legend(override.aes = list(linewidth = 1)))
}

# ---- 2. Box plots ----

#' Plot boxplots for selected countries
#'
#' @param df Data frame with country and yvar
#' @param yvar Character. Numeric variable
#' @param sel Character vector of countries
#' @param colors Named color vector
#' @param ylab Character. Y-axis label
#' @param title Character. Plot title
#' @param subtitle Character. Plot subtitle
#'
#' @return ggplot object
plot_box <- function(df, yvar, sel, colors, ylab, title = "", subtitle = "") {
  
  assert_columns(df, c("country", yvar))
  assert_character(sel, any.missing = FALSE)
  assert_true(length(sel) > 0)
  assert_character(ylab, len = 1)
  assert_character(title, len = 1)
  assert_character(subtitle, len = 1)
  
  # Filter selected countries and remove missing values
  # Each box summarizes the distribution of values over time for one country
  df_filtered <- df %>%
    filter(
      country %in% sel,
      !is.na(.data[[yvar]])
    ) %>%
    mutate(
      country = fct_reorder(country, .data[[yvar]], median)
    )
  
  # Create boxplot
  ggplot(df_filtered, aes(country, .data[[yvar]], fill = country)) +
    geom_boxplot(alpha = 0.85, outlier.size = 1.2) +
    scale_fill_manual(values = colors) +
    labs(
      y = ylab,
      x = "",
      title = title,
      subtitle = subtitle,
      fill = "Country"
    ) +
    theme(
      legend.position = "none",
      axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)
    )
}

# ---- 3. Scatter plots ----

#' Scatter plot with Spearman correlation
#'
#' @param df Data frame
#' @param xvar Character. X variable
#' @param yvar Character. Y variable
#' @param xlab Character. X-axis label
#' @param ylab Character. Y-axis label
#' @param title Character. Plot title
#' @param subtitle Character. Plot subtitle
#'
#' @return ggplot object
plot_scatter <- function(df, xvar, yvar, xlab, ylab, title = "", subtitle = "") {
  
  assert_columns(df, c(xvar, yvar))
  assert_numeric(df[[xvar]], any.missing = TRUE)
  assert_numeric(df[[yvar]], any.missing = TRUE)
  assert_character(title, len = 1)
  assert_character(subtitle, len = 1)
  
  # Compute Spearman correlation
  rho <- compute_spearman(df, xvar, yvar)
  
  # Create scatter plot
  ggplot(df, aes(x = .data[[xvar]], y = .data[[yvar]])) +
    geom_point(alpha = 0.6, color = "darkblue", size = 2) +
    
    # Annotate correlation coefficient in the top-right corner
    annotate(
      "text",
      x = Inf, y = Inf,
      hjust = 1.1,
      vjust = 1.5,
      label = enc2utf8(paste0("Spearman ρ = ", round(rho, 3))),
      size = 5
    ) +
    labs(
      x = xlab,
      y = ylab,
      title = title,
      subtitle = subtitle
    )
}

# ---- 4. Scatter plots (highlighted countries) ----

#' Scatter plot highlighting selected countries
#'
#' @param df Data frame
#' @param xvar Character. X variable
#' @param yvar Character. Y variable
#' @param sel Character vector of countries
#' @param colors Named color vector
#' @param xlab Character. X-axis label
#' @param ylab Character. Y-axis label
#' @param title Character. Plot title
#' @param subtitle Character. Plot subtitle
#'
#' @return ggplot object
plot_scatter_highlight <- function(df, xvar, yvar, sel, colors, xlab, ylab, title = "", subtitle = "") {
  
  assert_columns(df, c("country", xvar, yvar))
  assert_numeric(df[[xvar]], any.missing = TRUE)
  assert_numeric(df[[yvar]], any.missing = TRUE)
  assert_character(sel, any.missing = FALSE)
  assert_true(length(sel) > 0)
  assert_character(title, len = 1)
  assert_character(subtitle, len = 1)
  
  # Split data into highlighted and background groups
  df_other <- df %>% filter(!country %in% sel)
  df_sel   <- df %>% filter(country %in% sel)
  
  # Compute Spearman correlation
  rho <- compute_spearman(df, xvar, yvar)
  
  # Create layered scatter plot
  ggplot() +
    # Background points (all other countries)
    geom_point(
      data = df_other,
      aes(x = .data[[xvar]], y = .data[[yvar]]),
      color = "darkgray",
      alpha = 0.6,
      size = 2
    ) +
    # Highlighted countries
    geom_point(
      data = df_sel,
      aes(x = .data[[xvar]], y = .data[[yvar]], color = country),
      size = 2.8
    ) +
    scale_color_manual(values = colors) +
    # Correlation annotation
    annotate(
      "text",
      x = Inf,
      y = Inf,
      hjust = 1.1,
      vjust = 1.5,
      label = enc2utf8(paste0("Spearman ρ = ", round(rho, 3))),
      size = 5
    ) +
    labs(
      x = xlab,
      y = ylab,
      title = title,
      subtitle = subtitle,
      color = "Country"
    )
}

# ---- 5. Density plots ----

#' Plot population-weighted density with summary statistics
#'
#' @description
#' Creates a population-weighted kernel density plot for a numeric variable
#' and overlays vertical reference lines for the weighted mean and median.
#'
#' @param df Data frame.
#' @param var Character. Name of numeric variable to plot.
#' @param weight Character. Name of population weight variable.
#' @param xlab Character. X-axis label.
#' @param title Character. Plot title
#'
#' @return ggplot object.
plot_density <- function(df, var, weight = "population", xlab, title = "") {
  
  # ---- Input checks ----
  assert_choice(var, names(df))
  assert_choice(weight, names(df))
  assert_character(xlab, len = 1)
  assert_numeric(df[[var]], any.missing = TRUE)
  assert_numeric(df[[weight]], any.missing = TRUE)
  assert_character(title, len = 1)
  
  # ---- Remove missing and invalid values ----
  df <- df %>%
    filter(
      is.finite(.data[[var]]),
      is.finite(.data[[weight]]),
      .data[[weight]] > 0
    )
  
  # ---- Compute population-weighted statistics ----
  stats <- weighted_stats(df, var, weight)
  
  # ---- Create density plot ----
  ggplot(df, aes(x = .data[[var]])) +
    geom_density(
      aes(weight = .data[[weight]]),
      fill = "#8c7ae6",
      alpha = 0.4,
      linewidth = 1
    ) +
    geom_vline(
      aes(xintercept = stats$mean, color = "Mean"),
      linewidth = 1.2
    ) +
    geom_vline(
      aes(xintercept = stats$median, color = "Median"),
      linetype = "dashed",
      linewidth = 1.2
    ) +
    scale_color_manual(
      name   = "Statistic",
      values = c("Mean" = "blue", "Median" = "red")
    ) +
    labs(
      x        = xlab,
      y        = "Density",
      title = title,
      subtitle = "Population-weighted distribution"
    ) +
    theme(legend.position = "bottom")
}
