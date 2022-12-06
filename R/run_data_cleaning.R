#' @description: This script is purposed to clean survey forms and save to s3
#' @author: atediarjo@gmail.com
library(paws)
library(dplyr)
library(magrittr)
library(purrr)
library(tidyr)
library(data.table)
library(glue)
source('R/utils.R')
source('R/data_cleaning_function.R')

svc <- paws::s3()
S3_BUCKET_NAME <- glue::glue(
  Sys.getenv('BUCKET_PREFIX'),
  'databrew.org')
HH_S3_FILE_KEY <- 'kwale/raw-form/reconbhousehold/reconbhousehold.csv'
REGISTRATION_S3_FILE_KEY <- "kwale/raw-form/reconaregistration/reconaregistration.csv"
CLEAN_HH_S3_FILE_KEY <- 'kwale/clean-form/reconbhousehold/reconbhousehold.csv'
CLEAN_REGISTRATION_S3_FILE_KEY <- "kwale/clean-form/reconaregistration/reconaregistration.csv"
ANOMALIES_S3_FILE_KEY <- "kwale/anomalies/anomalies.csv"


get_registration_data <- function(){
  # Kwale Registration Forms
  filename <- tempfile()
  bucket_name <- S3_BUCKET_NAME
  get_s3_data(
    s3obj = svc,
    bucket= S3_BUCKET_NAME,
    object_key = REGISTRATION_S3_FILE_KEY, # change this to clean data
    filename = filename) %>%
    fread(.) %>%
    as_tibble() %>%
    as_tibble(.name_repair = 'unique')
}

get_household_data <- function(){
  # Kwale Household Forms
  filename <- tempfile()
  get_s3_data(
    s3obj = svc,
    bucket= S3_BUCKET_NAME,
    object_key = HH_S3_FILE_KEY, # change this to clean data
    filename = filename) %>%
    fread(.) %>%
    as_tibble() %>%
    as_tibble(.name_repair = 'unique')
}


# get registration forms and cleand ataset
filename <- tempfile(fileext = ".csv")
registration <- get_registration_data() %>%
  clean_registration_data(.) %>%
  fwrite(filename, row.names = FALSE)
save_to_s3_bucket(
  s3obj = svc,
  file_path = filename,
  bucket_name = S3_BUCKET_NAME,
  object_key = CLEAN_REGISTRATION_S3_FILE_KEY)


# get household forms and clean dataset
filename <- tempfile(fileext = ".csv")
household <- get_household_data() %>%
  clean_household_data(.) %>%
  fwrite(filename, row.names = FALSE)
save_to_s3_bucket(
  s3obj = svc,
  file_path = filename,
  bucket_name = S3_BUCKET_NAME,
  object_key = CLEAN_HH_S3_FILE_KEY)

