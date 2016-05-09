## PlotMap plots data frame values onto a map with region identifiers, and saves output
## If there are multiple goals, will loop through and map all




library(ggplot2) # install.packages('ggplot2')
library(RColorBrewer) # install.packages('RColorBrewer')

PlotMap <- function(scores          = scores, # dataframe with at least 2 columns: rgn_id and scores/values.
                    fld_value_id    = 'region_id', # likely 'rgn_id' or 'region_id' of map regions
                    fld_value_score = 'score', # likely 'score' or 'value' to display on map
                    spatial_regions = spatial_regions,
                    path_figures    = 'reports/figures',
                    fig_png   = sprintf('%s/map_%s.png', path_figures, g),
                    # allow fig_png to be NULL and then pass it back as a list of ggplot objects so that you could modify it more on
                    scale_label     = element_blank(),
                    scale_limits    = c(0, 100),
                    overwrite       = TRUE) {


    map_title = sprintf('Ocean Health Index scores: %s', g)

      ## join polygon with scores
    sp_regions <- spatial_regions %>%
      left_join(scores_g, by = fld_value_id)


    ## plot map!
    res = 100
    if (overwrite | !file.exists(fig_png)){
      png(fig_png, width=res*7, height=res*7)

      df_plot = ggplot(data = sp_regions,
                       aes(x = long, y = lat, group = group, fill = score)) +
        theme(axis.ticks = element_blank(), axis.text = element_blank(),
              text = element_text(family = 'Helvetica', color = 'gray30', size = 12),
              plot.title = element_text(size = rel(1.5), hjust = 0, face = 'bold'),
              legend.position = 'right') +
        theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank()) +
        scale_fill_gradientn(colours = brewer.pal(10, 'RdYlBu'), na.value = 'gray80',
                             limits = scale_limits) +
        geom_polygon(color = 'gray80', size = 0.1) +
        labs(title = map_title,
             fill  = element_blank(),
             x = NULL, y = NULL)

      ## if save plots as .pngs

      print(df_plot) # try ggsave(fig_png, df_plot) someday, but was taking forever
      dev.off()

      ## else
      ## return(df_plot) -- save this into a list. create an empty list and add to it.
      # can set the name of the item in the list to be the name of the goal.

    }


}
