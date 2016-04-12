## PlotMapCall.r: create maps from scores.csv
## called from calculate_scores.r
## assuming filepath = setwd('~/github/bhi/baltic2015')


## setup ----
source('PrepSpatial.r') # until added to ohicore
source('PlotMap.r')     # until added to ohicore

## prepare for mapping
spatial_prepped = PrepSpatial('spatial/regions_gcs.geojson') # can be .geojson or .shp
goal_labels     = setNames(conf$goals$name, conf$goals$goal)
path_figures    = 'reports/figures'


## map each goal and subgoal ----
for (g in names(goal_labels)){ # g ='FP'

  ## filter scores for goal g
  scores_g = read.csv('scores.csv') %>%
    filter(dimension == 'score',
           goal == g)

  ## labeling setup
  print(sprintf('Mapping %s . . .', goal_labels[g]))

  ## plot scores on map
  PlotMap(scores_g,
          spatial_prepped,
          map_title = sprintf('Ocean Health Index scores: %s', goal_labels[g]),
          fig_png   = sprintf('%s/map_%s.png', path_figures, gsub(' ','_', g)))

}

