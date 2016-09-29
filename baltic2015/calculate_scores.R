## Overview
## calculate_scores.R calculates scores for all OHI dimensions (status, trend, pressures, resilience, likely future state, and overall Index scores).

## When you begin, this script will calculate all dimensions using the 'templated' data and goal models provided.
## As you develop goal models with your own data, we recommend that you work on one goal at a time with pre_scores.R and functions.R
## instead of calculating scores for all dimensions using CalculateAll(). Goal and subgoal models are individual R functions
## in functions.R. You can run them individually from functions.r as you modify them
## calculate "current status" and "trend".

## When you are done with all the goal model modifications, you can come back here, and run the following scripts, which combines "current status" and "trend"
## with pressures and resilience to finish your OHI scores calculations.

### To Debug:
# remove.packages('ohicore') #remove original ohicore
# devtools::load_all('~/github/ohicore') #load regional ohicore so not to affect the original ohicore accidentally
# debug=F

source('~/github/bhi/baltic2015/pre_scores.R')

## calculate scenario scores
scores = CalculateAll(conf, layers)
write.csv(scores, 'scores.csv', na='', row.names=F)


## source until added to ohicore
source('PrepSpatial.R')
source('PlotMap.r')
source('PlotMapMulti.r')
source('PlotFlowerMulti.R')

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


## Make Flower Plots ----
rgns_complete <- read.csv('spatial/regions_lookup_complete.csv')
rgn_names <- read.csv('spatial/regions_lookup_complete.csv') %>%
  dplyr::rename(rgn_id = region_id)

## BHI regions
rgns <- rgns_complete %>%
  filter(type %in% c('bhi'))
rgns_to_plot <- rgns$region_id

PlotFlowerMulti(scores          = readr::read_csv('scores.csv') %>% filter(region_id %in% rgns_to_plot),
                rgns_to_plot    = rgns_to_plot,
                rgn_names       = rgn_names,
                name_fig        = 'reports/figures/BHI_regions/flower',
                assessment_name = 'Baltic')

## EEZ regions
rgns <- rgns_complete %>%
  filter(type %in% c('eez'))
rgns_to_plot <- rgns$region_id

PlotFlowerMulti(scores          = readr::read_csv('scores.csv') %>% filter(region_id %in% rgns_to_plot),
                rgns_to_plot    = rgns_to_plot,
                rgn_names       = rgn_names,
                name_fig        = 'reports/figures/EEZ/flower',
                assessment_name = 'Baltic')

## SUBBASIN regions
rgns <- rgns_complete %>%
  filter(type %in% c('subbasin'))
rgns_to_plot <- rgns$region_id

PlotFlowerMulti(scores          = readr::read_csv('scores.csv') %>% filter(region_id %in% rgns_to_plot),
                rgns_to_plot    = rgns_to_plot,
                rgn_names       = rgn_names,
                name_fig        = 'reports/figures/SUBBASIN/flower',
                assessment_name = 'Baltic')






