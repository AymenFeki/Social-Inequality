
### Source project functions and load the necassary data
source("Program/functions.R")
source("Program/load_data.R")

### Load all data
loaded <- load_all_data()

countries.data <- loaded$countries.data
data.avgs <- loaded$data.avgs
regions <- loaded$regions
### Make the plots

## Income Inequality
gini.density <- plot_density(
  countries.data, 
  "gini",
  title = "Distribution Of Gini Index")
ggsave(filename = "gini_denisty.pdf", plot = gini.density, path = "Results",
       width = 12, height = 8, units = "in", dpi = 600)

# Income Inequality among continents
gini.continents.plot <- plot_line(
  regions,
  yvar = "gini",
  sel = continents,
  colors = global.colors,
  title = "Income Inequality Over Time (Continents)",
  xlab = "Years",
  ylab = "Gini Index"
)
ggsave(filename = "gini_continents.pdf", plot = gini.continents.plot, path = "Results",
       width = 12, height = 8, units = "in", dpi = 600)

# Income Inequality changes over the years among certain countiries
gini.countries.plot <- plot_line(
  countries.data,
  yvar = "gini",
  sel = sel.countries,
  colors = global.colors,
  title = "Income Inequality Over Time (Countries)",
  xlab = "Years",
  ylab = "Gini Index",
  start_year = 2000
)
ggsave(filename = "gini_countries.pdf", plot = gini.countries.plot, path = "Results",
       width = 12, height = 8, units = "in", dpi = 600)

# Income Inequality comparison between certain countries
gini.countries.boxplot <- plot_box(
  countries.data,
  yvar = "gini",
  sel = sel.countries,
  colors = global.colors,
  title = "Income Inequality Across Selected Countries",
  ylab = "Gini Index"
)
ggsave(filename = "gini_countries_boxplot.pdf", plot = gini.countries.boxplot, path = "Results",
       width = 12, height = 8, units = "in", dpi = 600)

## Gender Inequality
gii.density <- plot_density(
  countries.data,
  "gii",
  title = "Distribution Of Gender Inequality Index")
ggsave(filename = "gii_density.pdf", plot = gii.density, path = "Results",
       width = 12, height = 8, units = "in", dpi = 600)

# Gender Inequality changes over the years among certain countiries
gii.countries.plot <- plot_line( 
  countries.data, 
  yvar = "gii",
  sel = sel.countries,
  colors = global.colors,
  title = "Gender Inequality Over Time (Countries)",
  xlab = "Years",
  ylab = "Gii",
  start_year = 2000
)
ggsave(filename = "gii_countries.pdf", plot = gii.countries.plot, path = "Results",
       width = 12, height = 8, units = "in", dpi = 600)

# Gender Inequality comparison between certain countries
gii.countries.boxplot <- plot_box(
  countries.data,
  yvar = "gii",
  sel = sel.countries,
  colors = global.colors,
  title = "Gender Inequality Across Selected Countries",
  ylab = "Gii"
)
ggsave(filename = "gii_countries_boxplot.pdf", plot = gii.countries.boxplot, path = "Results",
       width = 12, height = 8, units = "in", dpi = 600)

## Income Inequality VS Homicide Rate
scatter.gini.homicide <- plot_scatter(
  countries.data %>% drop_na(gini, homicide.rate),
  xvar = "gini",
  yvar = "homicide.rate",
  title = "Income Inequality and Homicide Rates",
  xlab = "Gini Index",
  ylab = "Homicide Rate (per 100.000)"
)
ggsave(filename = "scatter_gini_homicide.pdf", plot = scatter.gini.homicide, path = "Results",
       width = 12, height = 8, units = "in", dpi = 600)

scatter.highlight.gini.homicide <- plot_scatter_highlight(
  countries.data %>% drop_na(gini, homicide.rate),
  xvar = "gini",
  yvar = "homicide.rate",
  sel = sel.countries,
  colors = global.colors,
  title = "Income Inequality and Homicide Rates",
  xlab = "Gini Index",
  ylab = "Homicide Rate (per 100.000)"
)
ggsave(filename = "scatter_highlight_gini_homicide.pdf", plot = scatter.highlight.gini.homicide, path = "Results",
       width = 12, height = 8, units = "in", dpi = 600)

## Income Inequality VS Democracy
scatter.gini.democracy <- plot_scatter(
  countries.data %>% drop_na(gini, democracy),
  xvar = "gini",
  yvar = "democracy",
  title = "Income Inequality and Democracy",
  xlab = "Gini Index",
  ylab = "Democracy Index"
)
ggsave(filename = "scatter_gini_democracy.pdf", plot = scatter.gini.democracy, path = "Results",
       width = 12, height = 8, units = "in", dpi = 600)

scatter.highlight.gini.democracy <- plot_scatter_highlight(
  countries.data %>% drop_na(gini, democracy),
  xvar = "gini",
  yvar = "democracy",
  sel = sel.countries,
  colors = global.colors,
  title = "Income Inequality and Democracy",
  xlab = "Gini Index",
  ylab = "Democracy Index"
)
ggsave(filename = "scatter_highlight_gini_democracy.pdf", plot = scatter.highlight.gini.democracy, path = "Results",
       width = 12, height = 8, units = "in", dpi = 600)

## Income Inequality VS Healthcare Access
scatter.gini.healthcare <- plot_scatter(
  countries.data %>% drop_na(gini, SCI),
  xvar = "gini",
  yvar = "SCI",
  title = "Income Inequality and Healthcare Access",
  xlab = "Gini Index",
  ylab = "Healthcare Access",
  subtitle = "Healthcare Access = UHC Service Coverage Index"
)
ggsave(filename = "scatter_gini_healthcare.pdf", plot = scatter.gini.healthcare, path = "Results",
       width = 12, height = 8, units = "in", dpi = 600)

scatter.highlight.gini.healthcare <- plot_scatter_highlight(
  countries.data %>% drop_na(gini, SCI),
  xvar = "gini",
  yvar = "SCI",
  sel = sel.countries,
  colors = global.colors,
  title = "Income Inequality and Healthcare Access",
  xlab = "Gini Index",
  ylab = "Healthcare Access",
  subtitle = "Healthcare Access = UHC Service Coverage Index"
)
ggsave(filename = "scatter_highlight_gini_healthcare.pdf", plot = scatter.highlight.gini.democracy, path = "Results",
       width = 12, height = 8, units = "in", dpi = 600)
