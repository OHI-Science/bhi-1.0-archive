## load any libraries needed across website pages
suppressPackageStartupMessages({
  library(tidyverse)
  library(stringr)
  library(knitr)
})

## brewed vars
study_area      <- "Baltic"
key             <- "bhi"
dir_scenario_gh <- "https://raw.githubusercontent.com/OHI-Science/bhi-1.0-archive/draft/baltic2015"

## knitr options for all webpages
knitr::opts_chunk$set(echo = FALSE, message = FALSE, warning = FALSE)

## read in variables
scores <- readr::read_csv(file.path(dir_scenario_gh, 'scores.csv'))
layers <- readr::read_csv(file.path(dir_scenario_gh, 'layers.csv'))
weight <- readr::read_csv(file.path(dir_scenario_gh, 'conf/goals.csv')) %>%
  select(goal, weight)

## save local copies of Rmds to knit-child ----

to_copy <- c('conf/web/goals.Rmd')

for (f in to_copy) { # f <- 'conf/web/goals.Rmd'

  fp <- file.path(dir_scenario_gh, f)

  ## if the url exists, save a copy.
  if (RCurl::url.exists(fp)) {
    f_web   <- readr::read_lines(fp)
    if ( tools::file_ext(fp) == 'Rmd' ) {
      f_local <- paste0('local_', basename(fp))
    } else {
      f_local <- basename(fp)
    }
    readr::write_lines(f_web, path = f_local, append = FALSE)
    message(sprintf('saving %s', f_local))
  } else {
    message(sprintf('%s does not exist', fp))
  }
}

