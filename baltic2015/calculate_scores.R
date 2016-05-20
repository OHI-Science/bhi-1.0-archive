## Overview
## calculate_scores.R calculates scores for all OHI dimensions (status, trend, pressures, resilience, likely future state, and overall Index scores).

## When you begin, this script will calculate all dimensions using the 'templated' data and goal models provided.
## As you develop goal models with your own data, we recommend that you work on one goal at a time with pre_scores.R and functions.R
## instead of calculating scores for all dimensions using CalculateAll(). Goal and subgoal models are individual R functions
## in functions.R. You can run them individually from functions.r as you modify them
## calculate "current status" and "trend".

## When you are done with all the goal model modifications, you can come back here, and run the following scripts, which combines "current status" and "trend"
## with pressures and resilience to finish your OHI scores calculations.

source('~/github/bhi/baltic2015/pre_scores.R')

## calculate scenario scores
scores = CalculateAll(conf, layers, debug=T)
write.csv(scores, 'scores.csv', na='', row.names=F)


## plot maps of scores
source('PrepSpatial.r')  # until added to ohicore
source('PlotMap.r')      # until added to ohicore
source('PlotMapMulti.r') # until added to ohicore
PlotMapMulti(scores       = scores,
             spatial_poly = PrepSpatial('spatial/regions_gcs.geojson'), # can be .geojson or .shp
             path_figures = 'reports/figures')


## Display app locally.
## Note 1: to stop the app, type Ctrl+C or Esc, or closing the window.
## Note 2: if it does not load properly the first time, stop and run again.
source('launch_app_code.r')


## Display app on ohi-science.org/bhi (merge to published branch)
merge_branches = F

if (merge_branches) {
  # switch to draft branch and get latest
  system('git checkout draft')
  system('git commit -m "committing draft branch"')
  system('git pull')
  # merge published with the draft branch
  system('git checkout published')
  system('git merge draft')
  system('git push origin published')

  # switch to draft branch and get latest
  system('git checkout draft; git pull')
}
