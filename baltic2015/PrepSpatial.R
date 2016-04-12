## PlotMap.R
## This function takes a dataframe of scores and plots them to appropriate OHI regions.
## 'scores' is a data frame with unique rows of variables rgn_id and score
## TODO: also enable optional land .shp


library(maptools) # install.packages('maptools')
library(broom) # install.packages('broom')
library(rgdal) # install.packages('rgdal')

PrepSpatial <- function(mapfile_path = 'subcountry2014/spatial/rgn_offshore_gcs.shp') {
  # can be .geojson or .shp

  ## identify spatial file type ----

  ## spatial filetype
  fp = mapfile_path %>% normalizePath()
  fp_sans_ext = fp %>% tools::file_path_sans_ext()
  shp_ext = tools::file_ext(fp)

  ## if shapefile, prepare
  if (shp_ext == 'shp') {

    ## Fortify SpatialPolygonsDataFrames into a data.frame for ggplot
    poly_rgn    <- readShapePoly(fn = fp_sans_ext)

  ## if geojson, prepare
  } else if (shp_ext == 'geojson'){

    poly_rgn = readOGR(dsn = mapfile_path, "OGRGeoJSON")

  } else {
    print('Sorry, only .shp or .geojson files are supported at this time.')

  }

  ## tidy
  poly_rgn_df <- broom::tidy(poly_rgn) %>% # use broom::tidy() instead of ggplot2::fortify()
    dplyr::rename(region_id = id) %>%
    mutate(region_id = as.integer(region_id))

  return(poly_rgn_df)

}
