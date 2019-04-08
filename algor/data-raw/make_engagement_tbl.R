# Michael D Garrett. mcnair algorithmic thinking project
#
# Create the table of engagement data from the raw Excel file
#

## Load packages

library(dplyr)     # dplyr
library(readxl)    # read_excel
library(purrr)     # map

dpath <- file.path(".", "data-raw", "engagement.xlsx")
segments  <- c("IIIA", "IIIB", "IIIC")

engagement_tbl <- segments %>%
  map_dfr(read_excel, path = dpath) %>%
  mutate(segment = factor(segment, ordered = TRUE),
         teacher = factor(teacher))

# Quick checks for reasonableness

glimpse(engagement_tbl)

engagement_tbl %>% group_by(segment) %>% summarize(n())

## Save as list of all tables as package data

usethis::use_data(engagement_tbl, overwrite = TRUE)
