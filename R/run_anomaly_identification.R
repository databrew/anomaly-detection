#' This script is purposed to run anomaly identification
#' TBD on what kind of anomaly coding is required
library(dplyr)
library(magrittr)
library(purrr)
library(tidyr)
library(data.table)
library(glue)
source('R/utils.R')
source('R/anomaly_detection_function.R')

svc <- paws::s3()
S3_BUCKET_NAME <- 'databrew.org'
HH_S3_FILE_KEY <- 'kwale/clean-form/reconbhouseholdtraining/reconbhouseholdtraining.csv'
REGISTRATION_S3_FILE_KEY <- "kwale/clean-form/reconaregistrationtraining/reconaregistrationtraining.csv"
ANOMALIES_S3_FILE_KEY <- "kwale/anomalies/anomalies.csv"


get_registration_data <- function(){
  # Kwale Registration Forms
  filename <- tempfile()
  bucket_name <- glue::glue(
    Sys.getenv('BUCKET_PREFIX'),
    S3_BUCKET_NAME) # add prefix to differentiate prod/test
  get_s3_data(
    s3obj = svc,
    bucket= bucket_name,
    object_key = REGISTRATION_S3_FILE_KEY, # change this to clean data
    filename = filename) %>%
    fread(.) %>%
    as_tibble()
}

get_household_data <- function(){
  # Kwale Registration Forms
  filename <- tempfile()
  bucket_name <- glue::glue(
    Sys.getenv('BUCKET_PREFIX'),
    S3_BUCKET_NAME) # add prefix to differentiate prod/test
  get_s3_data(
    s3obj = svc,
    bucket= bucket_name,
    object_key = HH_S3_FILE_KEY, # change this to clean data
    filename = filename) %>%
    fread(.) %>%
    as_tibble()
}

# get registration data and its anomalies
reconaregistration <- get_registration_data()
reconbhousehold <- get_household_data()
anomaly_list <- dplyr::bind_rows(
  reconaregistration %>%
    get_duplicated_chv_id(.),
  reconaregistration %>%
    get_identical_cha_chv(.),
  reconbhousehold %>%
    get_duplicated_hh_id(.)
  ###############################################################
  # append more here, place function in anomaly_detection_function
  ###############################################################
)


# save data to s3
filename <- tempfile()
anomaly_list %>%
  write.csv(filename)
save_to_s3_bucket(
  s3obj = svc,
  file_path = filename,
  bucket_name = S3_BUCKET_NAME,
  object_key = ANOMALIES_S3_FILE_KEY)

