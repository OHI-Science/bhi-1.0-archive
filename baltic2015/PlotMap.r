#' PlotMap
#' Plots static maps of OHI scores.
#'
#' @param scores dataframe with at least 2 columns: rgn_id and values.Must have the same length as the number of regions to map
#' @param spatial_poly dataframe of spatial boundaries; prepared by PrepSpatial()
#' @param map_title optional title for map
#' @param include_land whether or not to map land behind OHI regions. SEE TODOs BELOW
#' @param fld_rgn usually rgn_id or region_id; default 'region_id'
#' @param fld_score column name of value to plot; default 'score'
#' @param scale_label default to 'score' TODO: necessary?
#' @param scale_limits default to c(0, 100)
#' @param print_fig logical to print to display; default TRUE
#' @param fig_path file path to save png; default NULL
#'
#' @return (invisible) ggplot object
#' @export
#'
#' @examples
#'
#'

##### temporary (until added to ohicore)
library(ggplot2) # install.packages('ggplot2')
library(RColorBrewer) # install.packages('RColorBrewer')
library(dplyr)
library(tidyr)

## see: https://github.com/hadley/ggplot2/wiki/plotting-polygon-shapefiles

PlotMap <- function(scores,
                    spatial_poly,
                    map_title       = element_blank(),
                    fld_rgn         = 'region_id',
                    fld_score       = 'score',
                    scale_label     = 'score',
                    scale_limits    = c(0, 100),
                    print_fig       = TRUE, ### print to display
                    fig_path        = NULL) { ### path to save the plot as an image
                    # allow fig_png to be NULL and then pass it back as a list of ggplot objects so that you could modify it more on {
  ## DEBUG: fld_rgn <- 'region_id'; fld_score <- 'score'; scale_limits <- c(0, 100);
  ## PlotMap(scores, spatial_poly = spatial_poly, scale_label = 'test1', map_title = 'test2')



  ### rename columns for convenience...
  names(scores)[names(scores) == fld_rgn]   <- 'rgn_id'
  names(spatial_poly)[names(spatial_poly) == fld_rgn]   <- 'rgn_id'
  names(scores)[names(scores) == fld_score] <- 'score'

  ### join polygon with scores
  score_rgn <- spatial_poly %>%
    left_join(scores %>%
                dplyr::select(rgn_id, score),
              by = 'rgn_id')


  ## Mel's color palette ----
  reds <-  grDevices::colorRampPalette(
    c("#A50026", "#D73027", "#F46D43", "#FDAE61", "#FEE090"),
    space="Lab")(65)
  blues <-  grDevices::colorRampPalette(
    c("#E0F3F8", "#ABD9E9", "#74ADD1", "#4575B4", "#313695"))(35)
  myPalette <-   c(reds, blues)


  ## plot with ggplot; tmap was slow and requires different setup
  df_plot <- ggplot(score_rgn) +
    geom_sf(aes(fill = score)) +
    scale_fill_gradientn(colours = myPalette,
                         na.value = "gray80",
                         limits = scale_limits,
                         name = scale_label) +
    labs(title = map_title)


  ### TODO: plot optional land .shp
  # function parameter: include_land    = TRUE,
  # if(include_land) {
  #
  #   ## consider:
  #     ## - downres-ing shapefiles like downres_polygons.r: https://github.com/OHI-Science/ohiprep/blob/9daf812e910b80cf3042b24fcb458cf62e359b1a/globalprep/spatial/downres_polygons.R; see calls from https://github.com/OHI-Science/ohi-global/blob/draft/global2015/Reporting/map_fxns.R
  #     ## - Hadleys' ggmap tiles that work with ggplot2 https://github.com/dkahle/ggmap#ggmap
  #     ## translating this whole function to tmap
  #
  # }

  if(print_fig) {
    print(df_plot)
  }

  if(!is.null(fig_path)) {
    ggsave(fig_path, plot = df_plot, width = 7, height = 7)
  }

  # tested July 2016: plotly super super slow, causes RStudio to crash.
  # if(active_plotly) {
  #   ggplotly(df_plot, tooltip = c("region_id", "score"))
  # }

  return(invisible(df_plot))
}
