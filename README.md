
# Social Inequality  
## Trends over Time and Associations with Societal Factors

**Authors:**  Aymen Feki, Moez Daghfous, Aziz Gheni, Fadi Bouachour  

Responsible for content: Aymen Feki
---

## General Information

This repository contains all data, scripts, and results required to reproduce the project:

**“Social Inequality – Trends over Time and Associations with Democratic Values, Health, and Safety.”**

The project was developed and tested using:

- **R version 4.5.1**

All required packages are available from CRAN.  
For a complete list of packages used in the analysis, see `env_setup.R` in the root directory.

---

## Usage Instructions

1. **Environment setup**  
   Run `env_setup.R` first.  
   This script installs and loads all required packages, sets global options, initializes helper functions for data handling and visualization,
loads the data, and performs preprocessing.

2. **Data processing and analysis**  
   Run `main.R` located in the `Program/` directory.  
   This script orchestrates the full workflow by sourcing the analysis scripts
   (`analysis_income_inequality.R`, `analysis_gender_inequality.R`,
   `analysis_societal_impacts.R`), which generate and save all figures to `Results/`.

3. **Report / presentation generation**  
   Open and render `Presentation.qmd` in the root directory to generate the final presentation.

---

## Directory Structure

### **Root Directory**

- `env_setup.R` – environment and package setup  
- `README.md` – project documentation  
- `Executive_Summary.pdf` – summary of results  
- `Presentation.qmd` – Quarto presentation source  

---

### **Data**

Contains the raw data used in the analysis (CSV format), including:

- Gini Index (before and after tax)
- Gender Inequality Index
- EIU Democarcy Index
- Homicide Rate
- UHC Service Coverage Index (Healthcare Access)
- World Population

---

### **Work.data**

Contains processed and intermediate datasets generated during data cleaning and preprocessing in RDS format.

---

### **Program**

Contains all R scripts used for data loading, preprocessing, visualization, and analysis:

- `config.R` – global configuration (selected countries/continents, color palette, ggplot theme)
- `utils.R` – helper utilities and statistical functions (e.g., Spearman correlation, weighted stats, average calculation)
- `functions.R` – plotting functions (time-series, density plots, boxplots, scatter plots)
- `load_data.R` – data preparation pipeline (loads raw CSVs, harmonizes columns, merges datasets, saves/loads RDS files)
- `analysis_income_inequality.R` – figures for income inequality (density, time trends, boxplots)
- `analysis_gender_inequality.R` – figures for gender inequality (density, time trends, boxplots)
- `analysis_societal_impacts.R` – correlation/scatter plots between inequality and societal outcomes
- `main.R` – orchestrates the full analysis workflow by running the analysis scripts 

---

### **Results**

This directory contains the results (figures) of our analysis. They are all saved in `.png` format.

---

## Data sources and licensing

All analyses in this repository are based on data obtained from Our World in Data (https://ourworldindata.org).

- Visualizations, articles, and data processing by Our World in Data are licensed under [Creative Commons BY (CC BY)](https://creativecommons.org/licenses/by/4.0/).
- Most of the underlying data comes from third-party providers (e.g., World Bank, United Nations, WHO). These data are subject to the license terms of the original providers.
- We credit both Our World in Data and the original data providers in our documentation and cite them in all outputs.
---
