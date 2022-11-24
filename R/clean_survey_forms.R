#' This script is purposed to clean survey forms and save to s3
library(paws)
library(dplyr)
library(magrittr)
library(purrr)
library(tidyr)
library(data.table)
library(glue)
source('R/utils.R')
source('R/cleaning_functions.R')

svc <- paws::s3()

S3_BUCKET_NAME <- 'databrew.org'
RAW_HH_S3_FILE_KEY <- 'kwale/raw-form/reconbhouseholdtraining/reconbhouseholdtraining.csv'
CLEAN_HH_S3_FILE_KEY <- 'kwale/clean-form/reconbhouseholdtraining/reconbhouseholdtraining.csv'
RAW_REGISTRATION_S3_FILE_KEY <- "kwale/raw-form/reconaregistrationtraining/reconaregistrationtraining.csv"
CLEAN_REGISTRATION_S3_FILE_KEY <- "kwale/clean-form/reconaregistrationtraining/reconaregistrationtraining.csv"

# Kwale Registration Forms
filename <- tempfile()
bucket_name <- glue::glue(
  Sys.getenv('BUCKET_PREFIX'),
  S3_BUCKET_NAME) # add prefix to differentiate prod/test
registration <- get_s3_data(
  s3obj = svc,
  bucket= bucket_name,
  object_key = RAW_REGISTRATION_S3_FILE_KEY,
  filename = filename) %>%
  fread(.) %>%
  as_tibble(.name_repair = 'unique') %>%
  clean_kwale_registration_forms(.)
registration %>%
  write.csv(filename)
save_to_s3_bucket(
  s3obj = svc,
  file_path = filename,
  bucket_name = S3_BUCKET_NAME,
  object_key = CLEAN_REGISTRATION_S3_FILE_KEY)


# Kwale Household Forms
filename <- tempfile()
bucket_name <- glue::glue(
  Sys.getenv('BUCKET_PREFIX'),
  S3_BUCKET_NAME) # add prefix to differentiate prod/test
get_s3_data(
  s3obj = svc,
  bucket= bucket_name,
  object_key = RAW_HH_S3_FILE_KEY,
  filename = filename) %>%
  fread(.) %>%
  as_tibble(.name_repair = 'unique') %>%
  clean_kwale_household_forms(.) %>%
  write.csv(filename)
save_to_s3_bucket(
  s3obj = svc,
  file_path = filename,
  bucket_name = S3_BUCKET_NAME,
  object_key = CLEAN_HH_S3_FILE_KEY)

