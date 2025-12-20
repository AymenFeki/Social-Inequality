### ENVIRONMENT SETUP FILE FOR INEQUALITY PROJECT
### This script sets the working directory, installs missing packages,
### loads libraries, cleans objects, and sources all project functions.

## Set working directory to the folder where this file is located

if (rstudioapi::isAvailable()) {
  setwd(dirname(rstudioapi::getSourceEditorContext()$path))
} else {
  message("RStudio not available — skipping setwd()")
}

## Install missing packages (CRAN only)

packages <- c(
  "dplyr",
  "readr",
  "stringr",
  "tidyr",
  "tidyverse",
  "ggplot2",
  "checkmate",
  "janitor",
  "forcats",
  "countrycode",
  "rlang"
)

for (pkg in packages) {
  if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
    install.packages(pkg)
    library(pkg, character.only = TRUE)
  }
}

## Global ggplot Theme

theme_set(
  theme_minimal(base_size = 10) +
    theme(
      plot.title = element_text(hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5),
      legend.title = element_text(size = 15),
      legend.text = element_text(size = 10),
      legend.key.size = unit(1, "lines"),
      legend.box.margin = margin_auto(1),
      axis.ticks.length = unit(0.3, "cm"),
      axis.ticks = element_line(linewidth = 0.5),
      panel.border = element_rect(color = "black", fill = NA),
      legend.position = "right",
      panel.grid.minor = element_blank()
    )
)

# theme_set(
#   theme_minimal(base_size = 20) +
#     theme(
#       # Legend
#       legend.title = element_text(size = 30),
#       legend.text = element_text(size = 25),
#       legend.key.size = unit(2.5, "lines"),
#       legend.box.margin = margin_auto(6),
#       legend.position = "right",
#       
#       # Axis titles (THIS is what you want for labels)
#       axis.title.x = element_text(size = 30, margin = margin(t = 15)),
#       axis.title.y = element_text(size = 30, margin = margin(r = 15)),
#       
#       # Axis tick labels (numbers)
#       axis.text.x = element_text(size = 24),
#       axis.text.y = element_text(size = 24),
#       
#       # Axis ticks (lines)
#       axis.ticks.length = unit(0.4, "cm"),
#       axis.ticks = element_line(linewidth = 0.8),
#       
#       # Panel
#       panel.border = element_rect(color = "black", fill = NA),
#       panel.grid.minor = element_blank()
#     )
# )

## if variables named with "/" at first, which often occurs for MAC users, rename them

for (var in ls()) {
  if (str_detect(var, "/")) {
    new_var <- gsub("/", "", var)
    assign(new_var, get(var))
  }
}

## Remove temporary variables created in this setup file

rm(pkg, packages)
rm(var)

message("Environment successfully initialized")
