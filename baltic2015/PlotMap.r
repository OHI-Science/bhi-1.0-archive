## PlotMap plots data frame values onto a map with region identifiers, and saves output
## If there are multiple goals, will loop through and map all


library(ggplot2) # install.packages('ggplot2')
library(RColorBrewer) # install.packages('RColorBrewer')
library(dplyr)
library(tidyr)

PlotMap <- function(scores,         # dataframe with at least 2 columns: rgn_id and scores/values.
                    rgn_poly        = PrepSpatial('spatial/regions_gcs.geojson'), # default for OHI+
                    map_title       = element_blank(),
                    fld_rgn         = 'region_id',
                    fld_score       = 'score',
                    scale_label     = 'score',
                    scale_limits    = c(0, 100),
                    print_fig       = TRUE, ### print to display
                    fig_path        = NULL, ### path to save the plot as an image
                    # allow fig_png to be NULL and then pass it back as a list of ggplot objects so that you could modify it more on
                    overwrite       = TRUE) {
  ## DEBUG: setwd('baltic2015'); source('PrepSpatial.R'); scores_all <- read.csv('scores.csv'); scores <- scores_all %>% filter(goal == 'BD' & dimension == 'score') %>% filter(region_id != 0); fld_rgn <- 'region_id'; fld_score <- 'score'; scale_limits <- c(0, 100); map_title= 'Title'; scale_label = 'Biodiversity'; rgn_poly = PrepSpatial('spatial/regions_gcs.geojson'); PlotMap(scores, rgn_poly = rgn_poly, scale_label = 'test1', map_title = 'test2')


  ### rename columns for convenience...
  names(scores)[names(scores) == fld_rgn]   <- 'rgn_id'
  names(rgn_poly)[names(rgn_poly) == fld_rgn]   <- 'rgn_id'
  names(scores)[names(scores) == fld_score] <- 'score'

  ### join polygon with scores
  score_rgn <- rgn_poly %>%
    left_join(scores %>%
                dplyr::select(rgn_id, score),
              by = 'rgn_id')

  ## plot with ggplot; tmap was slow and requires different setup
  df_plot <- ggplot(data = score_rgn,
                    aes(x = long, y = lat, group = group, fill = score)) +
    theme(axis.ticks = element_blank(),
          axis.text  = element_blank(),
          axis.title = element_blank(),
          text       = element_text(family = 'Helvetica', color = 'gray30', size = 12),
          plot.title = element_text(size = rel(1.5), hjust = 0, face = 'bold'),
          legend.position = 'right') +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_fill_gradientn(colours = brewer.pal(10, 'RdYlBu'),
                         na.value = 'gray80',
                         limits = scale_limits,
                         name = scale_label) +
    geom_polygon(color = 'gray80', size = 0.1) +
    labs(title = map_title)

  if(print_fig) {
    print(df_plot)
  }

  if(!is.null(fig_path)) {
    ggsave(fig_path, plot = df_plot, width = 7, height = 7)
  }

  return(invisible(df_plot))
}
