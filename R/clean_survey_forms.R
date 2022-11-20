#' This script is purposed to clean survey forms and save to s3
library(paws)
library(dplyr)
library(magrittr)
library(purrr)
library(tidyr)
library(data.table)
source('R/utils.R')
source('R/cleaning_functions.R')

svc <- paws::s3()
cf <- config::get()

# Kwale Registration Forms
filename <- tempfile()
get_s3_data(
  s3obj = svc,
  bucket= cf$kwale$registration$s3$bucket_name,
  object_key = cf$kwale$registration$s3$keys$raw_input,
  filename = filename) %>%
  fread(.) %>%
  as_tibble(.name_repair = 'unique') %>%
  clean_kwale_registration_forms(.) %>%
  write.csv(filename)
save_to_s3_bucket(
  s3obj = svc,
  file_path = filename,
  bucket_name = cf$kwale$registration$s3$bucket_name,
  object_key = cf$kwale$registration$s3$keys$clean_output)


# Kwale Household Forms
filename <- tempfile()
get_s3_data(
  s3obj = svc,
  bucket= cf$kwale$household$s3$bucket_name,
  object_key = cf$kwale$household$s3$keys$raw_input,
  filename = tempfile()) %>%
  fread(.) %>%
  as_tibble(.name_repair = 'unique') %>%
  clean_kwale_household_forms(.) %>%
  write.csv(filename)
save_to_s3_bucket(
  s3obj = svc,
  file_path = filename,
  bucket_name = cf$kwale$household$s3$bucket_name,
  object_key = cf$kwale$household$s3$keys$clean_output)

