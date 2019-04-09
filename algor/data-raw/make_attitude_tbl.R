# Michael D Garrett. mcnair algorithmic thinking project
#
# Create the table of pre/post attitude data from the raw Excel file
#

## Load packages

library(dplyr)     # dplyr
library(readxl)    # read_excel
library(purrr)     # map

dpath <- file.path(".", "data-raw", "class_session.xlsx")
sheets  <- excel_sheets(dpath)

# First two sheets are pre/post attitude about STEM in HS ("courses"). Stack
# them and identify with a factor.
attitude_ihs_tbl <- sheets[1:2] %>%
  map_dfr(read_excel, path = dpath, .id = "timing") %>%
  mutate(timing = factor(timing, levels = c(1,2), labels =c("pre", "post"),
                         ordered = TRUE)
        )

# Second two sheets are pre/post attitude about STEM after HS ("study and
# work"). Stack them and identify with a factor
attitude_ahs_tbl <- sheets[3:4] %>%
  map_dfr(read_excel, path = dpath, .id = "timing") %>%
  mutate(timing = factor(timing, levels = c(1,2), labels =c("pre", "post"),
                         ordered = TRUE)
        )

## Quick checks for reasonableness

glimpse(attitude_ihs_tbl)
glimpse(attitude_ahs_tbl)

# Should be one pre, one post for each ID
attitude_ihs_tbl %>% group_by(ID, timing) %>% summarize(n())
attitude_ahs_tbl %>% group_by(ID, timing) %>% summarize(n())

## Save as list of all tables as package data

usethis::use_data(attitude_ihs_tbl, overwrite = TRUE)
usethis::use_data(attitude_ahs_tbl, overwrite = TRUE)