## PlotMapMulti
## Loops through multiple goals and map all calling PlotMap

library(dplyr)

# prep_sp = PrepSpatial('spatial/regions_gcs.geojson')

PlotMapMulti <- function(scores          = read.csv('scores.csv'), # dataframe with regions, goals, dimensions, scores
                         spatial_regions = prep_sp, # PrepSpatial('spatial/regions_gcs.geojson'),
                         fld_value_id    = 'region_id', # likely 'rgn_id' or 'region_id' of map regions
                         fld_value_score = 'score', # value to display on map
                         dim_choice      = 'score', # choice of "future", "pressures", "resilience", "score", "status", "trend"
                         print_map       = TRUE,
                         save_map        = TRUE,
                         path_figures    = 'reports/figures',
                         map_title       = element_blank(),
                         scale_label     = 'score',
                         scale_limits    = c(0, 100),
                         overwrite       = TRUE) {


  ## setup ----

  ## check field values in scores column names
  if ( !fld_value_score %in% names(scores) | !fld_value_id %in% names(scores) ) {
    stop(sprintf('Column name "%s" or "%s" not found in scores variable, please modify PlotMap() function call.',
                 fld_value_score, fld_value_id))
  }

  ## if exists, remove region_id == 0 for mapping
  if (0 %in% scores[[fld_value_id]]){
    scores <- scores[scores[[fld_value_id]] != 0, ] # figure this out with filter() someday
  }

  ## if exists, filter dimension for 'score'
  if ( 'dimension' %in% names(scores) ) {
    scores <- scores %>%
      filter(dimension == dim_choice)
  }

  ## loop over each goal and subgoal ----

  goals <- unique(scores$goal)
  for (g in goals){ # g ='BD'

    print(sprintf('Mapping %s . . .', g))

    ## filter scores for goal g
    scores_g <-  scores %>%
      filter(goal == g)


    ## plot map!
    PlotMap(scores_g,
            sp_rgn       = spatial_regions,
            # fld_rgn      = fld_value_id,
            # fld_score    = fld_value_score,
            print_map    = print_map,
            fig_path     = sprintf('%s/map_%s.png', path_figures, g),
            map_title    = map_title,
            scale_label  = scale_label,
            scale_limits = scale_limits,
            overwrite    = overwrite)


  }


}