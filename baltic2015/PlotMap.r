## PlotMap plots data frame values onto a map with region identifiers, and saves output
## If there are multiple goals, will loop through and map all




library(ggplot2) # install.packages('ggplot2')
library(tmap)
library(RColorBrewer) # install.packages('RColorBrewer')

library(dplyr)
library(tidyr)
setwd('baltic2015')
scores_all <- read.csv('scores.csv')
scores <- scores_all %>%
  filter(goal == 'BD' & dimension == 'score') %>%
  filter(region_id != 0)

fld_rgn <- 'region_id'
fld_score <- 'score'
scale_limits <- c(0, 100)
map_title       = 'craptastic'
scale_label     = 'Biodiversity'

mapfile_path = 'spatial/regions_gcs.geojson'
rgn_poly <-     readOGR(dsn = normalizePath(mapfile_path), "OGRGeoJSON")

PlotMap(scores, rgn_poly, scale_label = 'test1', map_title = 'test2')

PlotMap <- function(scores,         # dataframe with at least 2 columns: rgn_id and scores/values.
                    rgn_poly,       # = rgdal::readOGR(dsn = 'spatial', layer = 'regions_gcs', ), ### default for OHI+
                    fld_rgn         = 'region_id',
                    fld_score       = 'score',
                    map_title       = element_blank(),
                    scale_label     = 'score',
                    scale_limits    = c(0, 100),
                    print_map       = TRUE, ### print to display
                    fig_path        = NULL, ### path to save the plot as an image; NULL doesn't save
                    overwrite       = TRUE) {

  ### rename columns for convenience...
  names(scores)[names(scores) == fld_rgn]   <- 'rgn_id'
  names(rgn_poly@data)[names(rgn_poly@data) == fld_rgn]   <- 'rgn_id'
  names(scores)[names(scores) == fld_score] <- 'score'

  ### join polygon with scores
  rgn_poly@data <- rgn_poly@data %>%
    left_join(scores %>%
                dplyr::select(rgn_id, score),
              by = 'rgn_id')


  tmap_plot <- qtm(rgn_poly, fill = 'score')

  # df_plot <- ggplot(data = score_rgn,
  #                   aes(x = long, y = lat, group = group, fill = score)) +
  #   theme(axis.ticks = element_blank(),
  #         axis.text  = element_blank(),
  #         axis.title = element_blank(),
  #         text       = element_text(family = 'Helvetica', color = 'gray30', size = 12),
  #         plot.title = element_text(size = rel(1.5), hjust = 0, face = 'bold'),
  #         legend.position = 'right') +
  #   theme(panel.grid.major = element_blank(),
  #         panel.grid.minor = element_blank(),
  #         panel.background = element_blank()) +
  #   scale_fill_gradientn(colours = brewer.pal(10, 'RdYlBu'),
  #                        na.value = 'gray80',
  #                        limits = scale_limits,
  #                        name = scale_label) +
  #   geom_polygon(color = 'gray80', size = 0.1) +
  #   labs(title = map_title)

  if(print_map) {
    print(tmap_plot)
  }

  if(!is.null(fig_path)) {
    save_tmap(fig_path, plot = tmap_plot, width = 7, height = 7)
  }

  return(invisible(tmap_plot))
}
