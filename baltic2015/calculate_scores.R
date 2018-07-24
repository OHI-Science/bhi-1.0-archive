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

# ## source
# source('https://raw.githubusercontent.com/OHI-Science/ohi-global/draft/eez/MappingFunction.R')
# PlotMap(goal_plot = "AO")

## source until added to ohicore
source('PlotMap.r')
source('PlotMapMulti.r')

## Make Maps ----

## BHI regions
PlotMapMulti(scores       = readr::read_csv('scores.csv') %>% filter(region_id < 300),
             spatial_poly = sf::st_read(dsn = 'spatial', layer = 'regions_gcs.geojson'),
             path_figures = 'reports/figures/BHI_regions')

## EEZ regions
PlotMapMulti(scores       = readr::read_csv('scores.csv') %>% filter(region_id > 300 & region_id < 500),
             spatial_poly = sf::st_read(dsn = 'spatial', layer = 'regions_EEZ') %>%
               dplyr::rename(rgn_id = eez_id),
             path_figures = 'reports/figures/EEZ')

## SUBBASIN regions
PlotMapMulti(scores       = readr::read_csv('scores.csv') %>% filter(region_id > 500),
             spatial_poly = sf::st_read(dsn = 'spatial', layer = 'BHI_SUBBASIN_regions.shp'),
             path_figures = 'reports/figures/SUBBASIN')


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








