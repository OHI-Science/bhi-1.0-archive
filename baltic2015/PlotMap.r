

library(ggplot2) # install.packages('ggplot2')
library(RColorBrewer) # install.packages('RColorBrewer')

PlotMap <- function(scores          = scores_g,
                    spatial_prepped = spatial_prepped,
                    map_title       = sprintf('Ocean Health Index scores: %s', unique(scores$goal)),
                    fig_png         = sprintf('%s/map_%s.png', path_figures, gsub(' ','_', unique(scores$goal))),
                    scale_label     = element_blank(),
                    scale_limits    = c(0, 100),
                    overwrite       = TRUE) {


   ## prepare scores variable ----

  ## ensure scores has unique values
  if(anyDuplicated(scores$region_id)) {
    stop('PlotMap() requires one value per region_id.
                 Please call PlotMap() with only one goal and dimension.')
  }

  ## if exists, filter out rgn_id == 0
  if (0 %in% scores$region_id){
    #  print('Removing region_id == 0 for mapping')
    scores = scores %>%
      filter(region_id != 0)
  }


  ## join polygon with scores
  spatial_prepped = spatial_prepped %>%
    left_join(scores, by = 'region_id')


  ## plot map
  res = 72
  if (overwrite | !file.exists(fig_png)){
    png(fig_png, width=res*7, height=res*7)

    ## plot!
    df_plot = ggplot(data = spatial_prepped,
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
    print(df_plot)

    dev.off()
  }

}
