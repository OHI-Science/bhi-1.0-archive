## load any libraries needed across website pages
suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(tidyr)
  library(stringr)
  library(knitr)
})

## brewed vars
study_area      <- "Baltic"
key             <- "bhi"
dir_scenario_gh <- "https://raw.githubusercontent.com/OHI-Science/bhi/draft/baltic2015"
app_url         <- "http://ohi-science.nceas.ucsb.edu/bhi"

## knitr options for all webpages
knitr::opts_chunk$set(echo = FALSE, message = FALSE, warning = FALSE)

## read in variables if they exist (i.e. don't try for prep repos)
scores_csv <- file.path(dir_scenario_gh, 'scores.csv')
layers_csv <- file.path(dir_scenario_gh, 'layers.csv')
conf_csv   <- file.path(dir_scenario_gh, 'conf/goals.csv')

if (RCurl::url.exists(scores_csv)) scores <- readr::read_csv(scores_csv)
if (RCurl::url.exists(layers_csv)) layers <- readr::read_csv(layers_csv)
if (RCurl::url.exists(conf_csv))   weight <- readr::read_csv(conf_csv) %>%
  select(goal, weight)

## if variables don't exist give a message
if ( !all( (!RCurl::url.exists(scores_csv)) | (!RCurl::url.exists(layers_csv)) | (!RCurl::url.exists(conf_csv))) ) {
 message('scores.csv, layers.csv, or conf/goals.Rmd may be missing')
}

# read config
config = new.env()
source(file.path(dir_scenario_gh, 'conf/config.R'), config)


## save local copy of conf/goals.Rmd
conf_goals_rmd <- file.path(dir_scenario_gh, 'conf/goals.Rmd')

if (RCurl::url.exists(scores_csv)) {
  conf_goals <- readr::read_lines(conf_goals_rmd)
  readr::write_lines(conf_goals, path = 'conf_goals.Rmd', append = FALSE)
}


## save local copies of conf/goals/*.Rmd
dir_conf_goals_web   <- file.path(dir_scenario_gh, 'conf/goals')
dir_conf_goals_local <- file.path('goals')

if (!exists(dir_conf_goals_local)) dir.create(dir_conf_goals_local)

for (i in weight$goal) { # i = 'FP'

  ## account for upper or lowercase
  fn_upper <- sprintf('%s/%s.Rmd', dir_conf_goals_web, i)
  fn_lower <- sprintf('%s/%s.Rmd', dir_conf_goals_web, stringr::str_to_lower(i))

  message(sprintf('trying %s...\n', i))

  if (RCurl::url.exists(fn_upper)) {
    readr::read_lines(fn_upper) %>%
      readr::write_lines(path = sprintf('%s/%s.Rmd', dir_conf_goals_local, i), append = FALSE)

  } else if (RCurl::url.exists(fn_lower)) {
    readr::read_lines(fn_lower) %>%
      readr::write_lines(path = sprintf('%s/%s.Rmd', dir_conf_goals_local, i), append = FALSE)
  }
}



