## calculate_scores.R

## This script calculates OHI scores with the `ohicore` package.
## - configure_toolbox.r ensures your files are properly configured for `ohicore`.
## - The `ohicore` function CalculateAll() calculates OHI scores.

## set working directory for all OHI calculations
setwd("~/github/bhi/baltic2015")

## run the configure_toolbox.r script to check configuration
source("configure_toolbox.r")

## calculate scenario scores
scores <- CalculateAll(conf, layers)
write.csv(scores, 'scores.csv', na='', row.names=F)


## visualize scores ----

## source until added to ohicore
source('PrepSpatial.R')
source('PlotMap.r')
source('PlotMapMulti.r')

## Make Maps ----

## BHI regions
PlotMapMulti(scores       = readr::read_csv('scores.csv') %>% filter(region_id < 300),
             spatial_poly = PrepSpatial('spatial/regions_gcs.geojson'),
             path_figures = 'reports/figures/BHI_regions')

## EEZ regions
PlotMapMulti(scores       = readr::read_csv('scores.csv') %>% filter(region_id > 300 & region_id < 500),
             spatial_poly = PrepSpatial('spatial/BHI_EEZ_regions.shp'),
             path_figures = 'reports/figures/EEZ')

## SUBBASIN regions
PlotMapMulti(scores       = readr::read_csv('scores.csv') %>% filter(region_id > 500),
             spatial_poly = PrepSpatial('spatial/BHI_SUBBASIN_regions.shp'),
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
           assessment_name = "Baltic Sea",
           dir_fig_save    = "reports/figures/BHI_regions")


## EEZ regions
rgns <- rgns_complete %>%
  filter(type %in% c('eez'))
rgns_to_plot <- rgns$region_id

PlotFlower(region_plot = rgns_to_plot,
           assessment_name = "Baltic Sea",
           dir_fig_save    = "reports/figures/EEZ")


## SUBBASIN regions
rgns <- rgns_complete %>%
  filter(type %in% c('subbasin'))
rgns_to_plot <- rgns$region_id

PlotFlower(region_plot = rgns_to_plot,
           assessment_name = "Baltic Sea",
           dir_fig_save    = "reports/figures/SUBBASIN")








