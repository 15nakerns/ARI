# Michael D Garrett. mcnair algorithmic thinking project
#
# Create the table of subjtive task value data from the raw Excel file
#

## Load packages

library(dplyr)     # dplyr
library(readxl)    # read_excel
library(purrr)     # map

# Raw data is a multisheet excel file
dpath <- file.path(".", "data-raw", "class_session.xlsx")
ds_sheets <- "IV"

# fold each sheet into a single dataframe
task_value_tbl <- ds_sheets %>%
  purrr::map_dfr(~ readxl::read_excel(path = dpath, sheet = ds_sheets)) %>%
  mutate(segment = factor(segment, ordered = TRUE))

# Quick checks for reasonableness

glimpse(task_value_tbl)

task_value_tbl %>% group_by(segment) %>% summarize(n())

## Save as list of all tables as package data

usethis::use_data(task_value_tbl, overwrite = TRUE)
