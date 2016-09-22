## PlotMapMulti
## Loops through multiple goals and map all calling PlotMap

PlotMapMulti <- function(scores          = read.csv('scores.csv'), # dataframe with regions, goals, dimensions, scores
                         spatial_poly    = PrepSpatial('spatial/regions_gcs.geojson'),
                         fld_value_id    = 'region_id', # header of scores variable; likely 'rgn_id' or 'region_id'
                         fld_value_score = 'score', # header of scores variable; likely 'score' or 'value'
                         dim_choice      = 'score', # header of scores variable; likely "future", "pressures", "resilience", "score", "status", "trend"
                         print_fig       = FALSE,
                         save_fig        = TRUE,
                         # active_plotly   = FALSE, ## takes too long, causes RStudio to crash
                         path_figures    = 'reports/figures',
                         scale_label     = 'score',
                         scale_limits    = c(0, 100)) {
                         # TODO: interactive = FALSE
  # DEBUG: scores=read.csv('scores.csv'); spatial_poly = readOGR(dsn = normalizePath(mapfile_path), "OGRGeoJSON"); fld_value_id = 'region_id'; fld_value_score = 'score';dim_choice = 'score'; print_fig = TRUE; save_fig = TRUE; path_figures = 'reports/figures'; map_title= element_blank();  scale_label = 'score';  scale_limits = c(0, 100)

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
  for (g in goals){ # g ='AO'

    print(sprintf('Mapping %s . . .', g))

    ## filter scores for goal g
    scores_g <-  scores %>%
      filter(goal == g)


    ## plot map!
    PlotMap(scores       = scores_g,
            rgn_poly     = spatial_poly,
            fld_rgn      = fld_value_id,
            fld_score    = fld_value_score,
            print_fig    = print_fig,
            fig_path     = sprintf('%s/map_%s.png', path_figures, g),
            map_title    = sprintf('Ocean Health Index: %s', g),
            scale_label  = scale_label,
            scale_limits = scale_limits)
    #DEBUG scores = scores_g; rgn_poly = spatial_poly; fld_rgn= fld_value_id;fld_score = fld_value_score;print_fig = print_fig; fig_path = sprintf('%s/map_%s.png', path_figures, g); map_title = map_title;scale_label = scale_label;scale_limits = scale_limits

  }


}
