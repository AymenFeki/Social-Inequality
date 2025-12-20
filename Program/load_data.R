## Loads all the needed Datasets and saves them for future use
source("Program/functions.R")

load_all_data <- function() {
  requireNamespace("readr", quietly = TRUE)
  requireNamespace("dplyr", quietly = TRUE)

  df.gini <- read.csv("Data/gini-coefficient.csv") %>%
    rename(
      country = Country,
      year = Year,
      gini = Gini.coefficient..before.tax...World.Inequality.Database.
    )

  df.gii <- read.csv("Data/gender-inequality-index.csv") %>% 
    rename(
      country = Entity,
      code = Code,
      year = Year,
      gii = Gender.Inequality.Index
    )

  df.democracy <- read.csv("Data/democracy-index.csv") %>% 
    rename(
      country = Entity,
      code = Code,
      year = Year,
      democracy = Democracy.index
    )

  df.homicide <- read.csv("Data/homicide-rate.csv") %>% 
    rename(
      country = Entity,
      code = Code,
      year = Year,
      homicide.rate = Homicide.rate.per.100.000.population...sex..Total...age..Total
    )

  df.SCI <- read.csv("Data/healthcare-access.csv") %>% 
    rename(
      country = Entity,
      year = Year,
      SCI = UHC.service.coverage.index
    )
  
  df.pop <- read.csv("Data/population.csv") %>% 
    rename(
      country = Entity,
      code = Code,
      year = Year,
      population = Population...Sex..all...Age..all...Variant..estimates
    )
  
  raw.data <- purrr::reduce(
    list(df.gini, df.democracy, df.homicide, df.gii, df.SCI, df.pop),
    ~ dplyr::left_join(.x, .y, by = c("country", "year"))
  ) %>%
    select(
      country,
      year,
      gini,
      gii,
      democracy,
      homicide.rate,
      SCI,
      population
    )
  
  # Separate countries and regions
  separated <- seperate_data(raw.data)
  countries.data <- separated$countries
  regions <- separated$regions
  
  # Compute country averages (NO population averaging)
  data.avgs <- countries.data %>%
    group_by(country) %>%
    summarise(
      across(
        .cols = c(gini, gii, democracy, homicide.rate, SCI),
        .fns = ~ mean(.x, na.rm = TRUE),
        .names = "{.col}.avg"
      ),
      .groups = "drop"
    )
  
  # Save clean objects
  saveRDS(countries.data, "Work.data/countries-data.rds")
  saveRDS(regions, "Work.data/regions.rds")
  saveRDS(data.avgs, "Work.data/data-avgs.rds")
  
  return(list(
    countries.data = countries.data,
    regions = regions,
    data.avgs = data.avgs
  ))
}
