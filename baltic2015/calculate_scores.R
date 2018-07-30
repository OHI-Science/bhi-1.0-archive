## calculate_scores.R

## This script calculates OHI scores with the `ohicore` package.
## - configure_toolbox.r ensures your files are properly configured for `ohicore`.
## - The `ohicore` function CalculateAll() calculates OHI scores.

## set working directory for all OHI calculations
setwd(here::here('baltic2015'))

## run the configure_toolbox.r script to check configuration
source("configure_toolbox.r")

## calculate scenario scores
scores <- CalculateAll(conf, layers)
write_csv(scores, 'scores.csv', na='')


## visualize scores ----


## Maps for Each Goal ----
# Note: these spatial files are in baltic2015/spatial; `create_bhi_reporting_boundaries.Rmd` creates EEZ and SUBBASIN

## source until added to ohicore
source('https://raw.githubusercontent.com/OHI-Science/bhi/draft/baltic2015/PlotMap.r')

## super helpful resources:
# https://github.com/jenniferthompson/RLadiesIntroToPurrr/blob/master/intro_purrr.pdf
# http://r4ds.had.co.nz/iteration.html#the-map-functions
# https://speakerdeck.com/jennybc/row-oriented-workflows-in-r-with-the-tidyverse


## BHI regions
scores <- readr::read_csv('scores.csv') %>%
  filter(region_id < 300) %>%
  split(.$goal)

purrr::map(scores, PlotMap,
           spatial_poly = sf::st_read(dsn = 'spatial', layer = 'regions_gcs'),
           dir_figures = 'reports/figures/BHI_regions')


## EEZ regions
scores <- readr::read_csv('scores.csv') %>%
  filter(region_id > 300 & region_id < 500) %>%
  split(.$goal)

purrr::map(scores, PlotMap,
           spatial_poly = sf::st_read(dsn = 'spatial', layer = 'regions_EEZ'),
           dir_figures = 'reports/figures/EEZ')


## SUBBASIN regions
scores <- readr::read_csv('scores.csv') %>%
  filter(region_id > 500) %>%
  split(.$goal)

purrr::map(scores, PlotMap,
           spatial_poly = sf::st_read(dsn = 'spatial', layer = 'regions_SUBBASIN'),
           dir_figures = 'reports/figures/SUBBASIN')


## Flower plots for each region ----
source('https://raw.githubusercontent.com/OHI-Science/arc/master/circle2016/plot_flower_local.R')

rgns_complete <- read.csv('spatial/regions_lookup_complete.csv')
rgn_names <- read.csv('spatial/regions_lookup_complete.csv') %>%
  dplyr::rename(rgn_id = region_id)

## BHI regions
rgns <- rgns_complete %>%
  filter(type %in% c('bhi', 'GLOBAL'))
rgns_to_plot <- rgns$region_id

PlotFlower(region_plot = rgns_to_plot,
           assessment_name = "Baltic",
           dir_fig_save    = "reports/figures/BHI_regions")


## EEZ regions
rgns <- rgns_complete %>%
  filter(type %in% c('eez'))
rgns_to_plot <- rgns$region_id

PlotFlower(region_plot = rgns_to_plot,
           assessment_name = "Baltic",
           dir_fig_save    = "reports/figures/EEZ")


## SUBBASIN regions
rgns <- rgns_complete %>%
  filter(type %in% c('subbasin'))
rgns_to_plot <- rgns$region_id

PlotFlower(region_plot = rgns_to_plot,
           assessment_name = "Baltic",
           dir_fig_save    = "reports/figures/SUBBASIN")








