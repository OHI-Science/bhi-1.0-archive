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


## plot maps of scores
source('PrepSpatial.r')  # until added to ohicore
source('PlotMap.r')      # until added to ohicore
source('PlotMapMulti.r') # until added to ohicore
PlotMapMulti(scores       = scores,
             spatial_poly = PrepSpatial('spatial/regions_gcs.geojson'),
             path_figures = 'reports/figures')
PlotMap(scores %>% filter(goal == 'CW'), fig_path = 'reports/figures/map_CW.png')


## Make Flower Plots ----
source('PlotFlowerMulti.R')
rgns_complete <- read.csv('spatial/regions_lookup_complete.csv') # %>% filter(type %in% c('eez', 'subbasin'))
rgns_to_plot <- rgns_complete$region_id

rgn_names <- read.csv('spatial/regions_lookup_complete.csv') %>%
  dplyr::rename(rgn_id = region_id)

PlotFlowerMulti(scores          = read.csv('scores.csv'),
                rgns_to_plot    = rgns_to_plot,
                rgn_names       = rgn_names,
                assessment_name = 'Baltic')
