# Michael D Garrett. mcnair algorithmic thinking project
#
# Create the table of subjtive task value data from the raw Excel file
#

## Load packages

library(dplyr)     # dplyr
library(readxl)    # read_excel
library(purrr)     # map

# Raw data is a multisheet excel file
dpath <- file.path(".", "data-raw", "engagement.xlsx")
ds_sheets <- readxl::excel_sheets(dpath)

# fold each sheet into a single dataframe
task_value_tidy <- ds_sheets %>%
  purrr::map_dfr(~ readxl::read_excel(path = dpath, sheet = .),
                 .id = "segment") %>%
  mutate(segment = factor(segment, ordered = TRUE),
         teacher = factor(teacher))

# Quick checks for reasonableness

glimpse(task_value_tidy)

engagement_tbl %>% group_by(segment) %>% summarize(n())

## Save as list of all tables as package data

usethis::use_data(engagement_tbl, overwrite = TRUE)
