
global.colors <- c(
  "United States" = "#EE7733",
  "India" = "#0077BB",
  "Kazakhstan" = "#33BBEE",
  "Germany" = "#EE3377",
  "South Africa" = "#009988",
  "Niger" = "darkgreen",
  "Australia" = "#AA4499",
  "Brazil" = "#F2CD5D",
  
  #Continents
  
  "Africa (WID)" = "darkgreen",
  "Asia (WID)" = "#004488",
  "Europe (WID)" = "#EE3377",
  "North America (WID)" = "#EE7733",
  "Oceania (WID)" = "#AA4499",
  "Latin America (WID)" = "#F2CD5D"
)

sel.countries <- c(
  "United States", "Brazil", "Germany",
  "South Africa", "India", "Australia",
  "Kazakhstan", "Niger"
)

continents <- c(
  "Africa (WID)", "Asia (WID)", "Europe (WID)",
  "North America (WID)", "Oceania (WID)",
  "Latin America (WID)"
)


plot_line <- function(df, yvar, sel, colors, title, xlab, ylab, start_year = NULL) {
  requireNamespace("checkmate", quietly = TRUE)
  requireNamespace("ggplot2", quietly = TRUE)
  requireNamespace("dplyr", quietly = TRUE)
  
  # ASSERTIONS
  assert_data_frame(df)
  assert_character(yvar, len = 1)
  assert_character(ylab, len = 1)
  
  # Filter by year
  if (!is.null(start_year)) {
    df <- df %>% filter(year >= start_year)
  }
  # Check for Lengend title
  legend.title <- if (all(sel %in% continents)) "Continent" else "Country"
  # Plot
  ggplot(df %>% filter(country %in% sel) %>% filter(!is.na(.data[[yvar]])),
         aes(year, .data[[yvar]], color = country)) +
    geom_smooth(se = FALSE, linewidth = 1.2) +
    scale_color_manual(values = colors,
                       labels = remove_wid) +
    labs(title = title, x = xlab, y = ylab, color = legend.title) +
    guides(color = guide_legend(override.aes = list(linewidth = 2)))
}

plot_box <- function(df, yvar, sel, colors, title, ylab) {
  requireNamespace("checkmate", quietly = TRUE)
  requireNamespace("ggplot2", quietly = TRUE)
  requireNamespace("dplyr", quietly = TRUE)
  requireNamespace("forcats", quietly = TRUE)
  
  # ASSERTIONS
  assert_columns(df, c("country", yvar))
  assert_character(ylab, len = 1)
  
  # Filter selected countries and reorder factor based on median of y-variable
  df_filtered <- df %>%
    filter(country %in% sel) %>%
    mutate(country = forcats::fct_reorder(country, .data[[yvar]], .fun = median, na.rm = TRUE))
  
  ggplot(df_filtered, aes(country, .data[[yvar]], fill = country)) +
    geom_boxplot(alpha = 0.85, outlier.size = 1.2) +
    scale_fill_manual(values = colors) +
    labs(title = title, y = ylab, x = "", fill = "Country") +
    guides(fill = guide_legend(override.aes = list(size = 10))) +
    theme(
      legend.position = "none",
      axis.text.x = element_text(
        angle = 45,
        hjust = 1,
        vjust = 1
      )
    )
}

plot_scatter <- function(df, xvar, yvar, title, xlab, ylab, subtitle = NULL) {
  requireNamespace("checkmate", quietly = TRUE)
  requireNamespace("ggplot2", quietly = TRUE)
  requireNamespace("dplyr", quietly = TRUE)
  
  # ASSERTIONS
  assert_columns(df, c(xvar, yvar))
  
  assert_character(xlab, len = 1)
  assert_character(ylab, len = 1)
  
  # Compute the SP coefficient
  rho <- compute_spearman(df, xvar, yvar)
  
  # Plot
  ggplot(df, aes_string(x = xvar, y = yvar)) +
    geom_point(alpha = 0.6, color = "darkblue", size = 2) +
    annotate(
      "text",
      x = Inf, y = Inf, hjust = 1.1, vjust = 1.5,
      label = paste0("Spearman ρ = ", round(rho, 3)),
      size = 5
    ) +
    labs(title = title, x = xlab, y = ylab, subtitle = subtitle)
}

plot_scatter_highlight <- function(df, xvar, yvar, sel, colors, title, xlab, ylab, subtitle = NULL) {
  requireNamespace("checkmate", quietly = TRUE)
  requireNamespace("ggplot2", quietly = TRUE)
  requireNamespace("dplyr", quietly = TRUE)
  requireNamespace("rlang", quietly = TRUE)
  
  # ASSERTIONS
  assert_columns(df, c("country", xvar, yvar)) 
  
  assert_character(xlab, len = 1)
  assert_character(ylab, len = 1)
  
  # Split Data to selected countries and others
  df.other <- df %>% filter(!country %in% sel)
  df.selected <- df %>% filter(country %in% sel)
  
  # Compute the SP coefficient
  rho <- compute_spearman(df, xvar, yvar)
  
  # Plot
  ggplot() +
    geom_point(
      data = df.other,
      aes_string(x = xvar, y = yvar),
      color = "darkgray",
      alpha = 0.6,
      size = 2
    ) +
    geom_point(
      data = df.selected,
      aes_string(x = xvar, y = yvar, color = "country"),
      size = 2.8
    ) +
    scale_color_manual(values = colors) +
    annotate(
      "text", x = Inf, y = Inf, hjust = 1.1, vjust = 1.5,
      label = paste0("Spearman ρ = ", round(rho, 3)),
      size = 5
    ) +
    labs(title =title, x = xlab, y = ylab, color = "Country", subtitle = subtitle) +
    guides(color = guide_legend(override.aes = list(size = 3)))
}

# statistics are population-weighted
plot_density <- function(data, var, title, weight = "population") {
  # ---- Packages ----
  requireNamespace("ggplot2", quietly = TRUE)
  requireNamespace("dplyr", quietly = TRUE)
  requireNamespace("checkmate", quietly = TRUE)
  
  # ---- Assertions ----
  checkmate::assert_choice(var, choices = names(data))
  checkmate::assert_choice(weight, choices = names(data))
  checkmate::assert_numeric(data[[var]], any.missing = TRUE)
  checkmate::assert_numeric(data[[weight]], any.missing = TRUE)
  
  # ---- Clean data (critical for weighted KDE) ----
  df <- data %>%
    dplyr::filter(
      is.finite(.data[[var]]),
      is.finite(.data[[weight]]),
      .data[[weight]] > 0
    )
  
  # ---- Weighted statistics ----
  stats <- weighted_stats(df, var, weight)
  
  mean.val   <- stats$mean
  median.val <- stats$median
  sd.val     <- stats$sd
  skew.val   <- stats$skewness
  
  stats.label <- paste0(
    "Mean: ", round(mean.val, 3), "\n",
    "Median: ", round(median.val, 3), "\n",
    "SD: ", round(sd.val, 3), "\n",
    "Skewness: ", round(skew.val, 3)
  )
  # ---- Plot ----
  ggplot2::ggplot(df, ggplot2::aes(x = .data[[var]])) +
    ggplot2::geom_rect(
      aes(
        xmin = mean.val - sd.val,
        xmax = mean.val + sd.val,
        ymin = 0,
        ymax = Inf,
        fill = "± 1 SD"
      ),
      alpha = 0.15,
      inherit.aes = FALSE
    ) +
    ggplot2::geom_density(
      ggplot2::aes(weight = .data[[weight]]),
      fill = "#8c7ae6",
      alpha = 0.4,
      linewidth = 1
    ) +
    # Mean line
    ggplot2::geom_vline(
      ggplot2::aes(xintercept = mean.val, color = "Mean"),
      linewidth = 1.2
    ) +
    # Median line
    ggplot2::geom_vline(
      ggplot2::aes(xintercept = median.val, color = "Median"),
      linewidth = 1.2,
      linetype = "dashed"
    ) +
    ggplot2::scale_fill_manual(
      name = "Dispersion",
      values = c("± 1 SD" = "#4da3ff")
    ) +
    # Legends
    ggplot2::scale_color_manual(
      name = "Statistic",
      values = c(
        "Mean"   = "blue",
        "Median" = "red"
      )
    ) +
    # Stats annotation
    ggplot2::annotate(
      "text",
      x = Inf, y = Inf,
      label = stats.label,
      hjust = 1.1, vjust = 1.3,
      size = 3,
      fontface = "bold"
    ) +
    # Labels
    ggplot2::labs(
      title = title,
      subtitle = "Population-weighted distribution",
      x = tools::toTitleCase(var),
      y = "Density"
    ) +
    ggplot2::guides(
      fill = guide_legend(
        override.aes = list(alpha = 1)
      )) +
    ggplot2::theme(
      legend.position = "bottom"
    )
}

#----- Remove "(WID)" from continent names for legend cleaning

remove_wid <- function(x) {
  requireNamespace("checkmate", quietly = TRUE)
  
  assert_character(x, any.missing = FALSE)
  
  gsub(" \\(WID\\)", "", x)
}

## Compute the Spearman Correlation coefficient

compute_spearman <- function(df, var1, var2) {
  requireNamespace("checkmate", quietly = TRUE)
  
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

## Assertion Helper Function

assert_columns <- function(df, cols) {
  requireNamespace("checkmate", quietly = TRUE)
  
  assert_data_frame(df)
  assert_character(cols, any.missing = FALSE)
  assert_names(colnames(df), must.include = cols)
}

# Compute the average

compute_country_average <- function(df, var) {
  requireNamespace("dplyr", quietly = TRUE)
  requireNamespace("checkmate", quietly = TRUE)
  
  # Assertions
  assert_data_frame(df)
  assert_choice("country", names(df))
  assert_choice(var, names(df))

  # Compute averages
  name <- paste0(var, ".avg")
  
  df %>%
    group_by(country) %>%
    summarise(!!name := mean(.data[[var]], na.rm = TRUE)) %>%
    ungroup()
}

# Seperate countries and regions

seperate_data <- function(df) {
  requireNamespace("checkmate", quietly = TRUE)
  requireNamespace("countrycode", quietly = TRUE)
  requireNamespace("dplyr", quietly = TRUE)
  
  assert_data_frame(df)
  
  df_flagged <- df %>%
    mutate(
      iso3 = countrycode(country, "country.name", "iso3c", warn = FALSE)
    )
  
  regions <- df_flagged %>% 
    filter(is.na(iso3)) %>%
    select(-iso3)
  
  countries <- df_flagged %>%
    filter(!is.na(iso3)) %>%
    mutate(
      country = countrycode(iso3, "iso3c", "country.name"),
      code = iso3
    ) %>%
    select(-iso3)
  
  return(list(
    countries = countries,
    regions = regions
  ))
}

# Compute the weighted Moments

weighted_stats <- function(data, var, weight = "population") {
  requireNamespace("checkmate", quietly = TRUE)
  requireNamespace("dplyr", quietly = TRUE)
  
  assert_data_frame(data)
  assert_choice(var, names(data))
  assert_choice(weight, names(data))
  assert_numeric(data[[var]], any.missing = TRUE)
  assert_numeric(data[[weight]], any.missing = TRUE)
  
  df <- data %>%
    dplyr::select(.data[[var]], .data[[weight]]) %>%
    dplyr::filter(
      !is.na(.data[[var]]),
      !is.na(.data[[weight]]),
      .data[[weight]] > 0
    )
  
  x <- df[[var]]
  w <- df[[weight]]
  
  w.mean <- sum(w * x) / sum(w)
  w.var <- sum(w * (x - w.mean)^2) / sum(w)
  w.sd  <- sqrt(w.var)
  w.skewness <- sum(w * (x - w.mean)^3) / (sum(w) * w.sd^3)
  
  o <- order(x)
  x.sorted <- x[o]
  w.sorted <- w[o]
  cw <- cumsum(w.sorted) / sum(w.sorted)
  w.median <- x.sorted[which(cw >= 0.5)[1]]
  
  list(
    mean = w.mean,
    median = w.median,
    sd = w.sd,
    variance = w.var,
    skewness = w.skewness,
    n.obs = length(x),
    total.weight = sum(w)
  )
}
