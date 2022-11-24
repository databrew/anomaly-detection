# DataBrew ODK Anomaly Detection

This repository is used for DataBrew ODK forms anomaly detection. Survey forms will be processed through data cleaning process and anomaly identification. This process will going through continuous iteration to increase survey data quality.

## Reproducing Environment

### Clone repository

``` r
git clone https://github.com/databrew/anomaly-detection.git
```

This project uses `renv` to restore all the libraries being used for data processing. It is recommended to use `renv` library to reproduce this analysis

### Install Renv

    install.packages("renv")

### Initiate Renv

    library(renv)
    renv::restore()

The above command will reproduce the analysis environment used for data stored in S3

## Contributing

### Data Cleaning Functions
All data cleaning functions are [here]('R/cleaning_functions.R'). 
Once function is created, append your function in [here]('R/clean_survey_forms.R')

### Anomaly Detection Functions
All anomaly detection functions are [here]('R/anomaly_detection_function.R'). To add more anomaly identification procedure, create a new function that takes in registration/household data that returns a tibble dataframe with these 3 columns `type`, `anomaly_id`, `description`. 
Once function is created, append your function in [here]('R/run_anomaly_identification.R')
