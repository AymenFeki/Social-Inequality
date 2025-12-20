### Social Inequality

### Trends over Time and Associations with other factors

**Author:** Aymen Feki, Moez Daghfous, Aziz Gheni, Fadi Bouachour 
**Responsible for content:**

## General Instructions

This repository contains all data, programs, and results for the project\
**"Social Inequality – Trends over Time and Associations with Democratic Values, Life Satisfaction, Health, and Safety".**

The project was developed and tested using:

-   **R version 4.5.1**

All required packages are available on CRAN.

For a full list of packages loaded during the analysis, please refer to\
`env_setup.R` in the root directory of our project.

## Usage

1.  **First**, run `env_setup.R`.\
    This script installs and loads all required packages, sets global options,\
    and loads helper functions for plotting and data handling.

2.  **To clean the data and generate the plots**, run `Main.R` \ found in the 
    Program folder.

3.  **To generate the final report or presentation**, open `presentation.qmd`\
    in the root directory.

## Directory Structure

### **Root Directory**

-   `env_setup.R`\
-   `README.md`\
-   `Executive_Summary.pdf`
-   `Presentation.qmd`\

### **Data**

This directory contains the raw data used for the analysis, including:

-   Gini Coefficient\
-   Gender Inequality Index\
-   Democracy Index\
-   Homicide Rate\

All files are provided as `.csv`.

### **Work.Data**

This directory is intended for the processed dataset.\

### **Program**

This directory contains all R scripts used for data cleaning, preprocessing, visualization, and analysis.\
File names reflect their functionality:

-   `functions.R`\
-   `load_data.R`\
-   `Main.R`\

### **Results**

This directory contains all generated results, including:

-   Figures (`.png`)

## Additional Notes

-   All analyses rely on publicly available data sources.\
-   The project focuses on the relationship between social inequality and major societal outcomes such as democracy, crime.\
-   The repository structure is designed for reproducibility and clarity, following best practices from previous statistical projects.
