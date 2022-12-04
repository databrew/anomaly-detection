#' Helper function to set row values by uuid
#' @param data data input (tibble)
#' @param uuid the uuid of data (character)
#' @param mapping list of change in the row (list)
#' return tibble with changed row values
set_row_values <- function(data, uuid, mapping){
  key <- names(mapping)
  value <- unlist(mapping) %>% paste()
  data %>%
    dplyr::mutate(!!sym(key) := replace(
      !!sym(key), instanceID == uuid, value))
}

#' Helper function to set row values by uuid
#' @param data data input (tibble)
#' @param uuid list of uuid
#' return deleted rows
delete_row_values <- function(data, uuid = NULL){
  data %>%
    dplyr::filter(!instanceID %in% uuid)
}


#' This script is purposed to be cleaning function for data from s3 and saved to cleaned table
#' @param data
#' @return cleaned household data
clean_household_data <- function(data){
  return(data)
}


#' Function to clean registration forms
#' @param data registration forms
#' @return clean registration form
clean_registration_data <- function(data){
  data %>%
    # Anomaly Resolution Dec/02/2022
    # Trello: https://trello.com/c/oGY3UC6Z/1654-implement-isaiahs-ad-hoc-change-requests
    # Submitted by Isaiah
    # Resolved by atediarjo@gmail.com
    set_row_values(uuid = 'uuid:4393441c-6cd8-4971-93c1-6b4c0c81de1f',
                   mapping = list('wid' = '2042')) %>%
    set_row_values(uuid = 'uuid:77b61879-8cd5-4d55-b4e5-ed7256cd97bc',
                   mapping = list('wid' = '2028')) %>%
    set_row_values(uuid = 'uuid:b57d075b-270d-4827-85fc-0f0a374605c9',
                   mapping = list('wid' = '2011')) %>%
    set_row_values(uuid = 'uuid:3757f2b9-271b-4ff9-ba42-3aa432b1fd60',
                   mapping = list('wid' = '2045')) %>%
    delete_row_values(uuid =
                        c('uuid:7c900d1a-909e-4e39-b2dd-001ac334479e',
                          'uuid:dc005579-ce38-4ecf-8312-f36402611dd8',
                          'uuid:9a7bc546-d66b-46ce-afe5-b8d2143620c0',
                          'uuid:7c624b87-f10e-46e4-a17c-c47d8b426d44',
                          'uuid:ac320253-68ad-4003-949d-58411518ba41',
                          'uuid:ab4013f7-7091-43df-9285-7486a0a84f94',
                          'uuid:66dcc3ef-4d6b-4ef6-9b24-f4d36c3a565b',
                          'uuid:2f6c94a0-b7e9-47a8-b7e6-f9aae412cdc8',
                          'uuid:80bcc2de-56f9-44c4-8dfc-70c90cd43dfa',
                          'uuid:43c8f5f5-7f9a-4cf1-8d9c-67128cf80ab8',
                          'uuid:4f6cc00e-ff06-4daf-b16c-595a585bf74c',
                          'uuid:a5e72155-dab4-486f-87f9-104d004e8a22',
                          'uuid:91c0d545-5a3d-48e3-822c-170701ffe509'))
  return(data)
}


