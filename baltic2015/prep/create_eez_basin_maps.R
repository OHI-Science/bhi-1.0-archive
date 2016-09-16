## create_eez_basin_maps.r

# libraries
library(tidyverse)

library(rgdal)
# library(raster)
library(maptools)

dir_baltic <- '~/github/bhi/baltic2015'
mapfile    <- path.expand(file.path(dir_baltic, 'spatial/regions_gcs.geojson'))
rgns       <- read.csv(file.path(dir_baltic, 'spatial/regions_lookup_complete_wide.csv'))

## Fortify SpatialPolygonsDataFrames into a data.frame for ggplot
bhi  <-  rgdal::readOGR(dsn = mapfile, "OGRGeoJSON")
bhi@data <- bhi@data %>%
  left_join(rgns %>%
              dplyr::rename(rgn_id  = region_id,
                            rgn_nam = region_name), by = c('rgn_id', 'rgn_nam'))
## attempt 1
ID <- bhi@data$eez_id
##bhi2 <- unionSpatialPolygons(bhi, ID) took 20 mins, did something, but not enough

## attempt 2. also did something but not enough
lps <- coordinates(bhi)
ID <- cut(lps[,1], quantile(lps[,1]), include.lowest=TRUE)
reg4 <- unionSpatialPolygons(bhi, ID)
plot(reg4)

## attempt 3 -> TRY?
d <- bhi@data
d$rgn_id[d$eez_id == 301] <- 1
bhi3 <- unionSpatialPolygons(bhi, d$rgn_id)
plot(bhi3)

ID <- bhi@data$eez_id - 300 ## keep them in the same numeric range as before


## attempt 4 FAIL due to orphan hole, index 378 http://stackoverflow.com/questions/11072542/merge-neighboring-regions-in-r-aggregate-spatial-data
library(rgeos)
d <- bhi@data %>%
  filter(eez_id == 301)
bhi4 <- gUnionCascaded(bhi[d$rgn_id,]) ##regionOfInterest <- gUnionCascaded(xx[c(3,5), ])
Error in createPolygonsComment(p) :
#   rgeos_PolyCreateComment: orphaned hole, cannot find containing polygon for hole at index 24
# In addition: There were 50 or more warnings (use warnings() to see the first 50)
# > plot(bhi3)
# Error in plot(bhi3) : object 'bhi3' not found

## Attempt 5: try using the .shp from git annex to avoid orphan holes...


lps <- coordinates(poly)
ID <- cut(lps[,1], quantile(lps[,1]), include.lowest=TRUE)
reg4 <- unionSpatialPolygons(nc1, ID)



# ?maptools::unionSpatialPolygons

nc1 <- readShapePoly(system.file("shapes/sids.shp", package="maptools")[1],
                     proj4string=CRS("+proj=longlat +datum=NAD27"))
lps <- coordinates(nc1)
ID <- cut(lps[,1], quantile(lps[,1]), include.lowest=TRUE)
reg4 <- unionSpatialPolygons(nc1, ID)
row.names(reg4)



## NCEAS example:
# https://www.nceas.ucsb.edu/scicomp/usecases/PolygonDissolveOperationsR

InputPolygons = readShapePoly("NCCounties.shp",proj4string= CRS("projection and datum parameters"))
ProjectedPolygons = spTransform(InputShapefile,CRS(""projection and datum parameters"))

# get vector containing the label points (lat/long)

PolyLabelPts <- getSpPPolygonsLabptSlots(ProjectedPolygons)
# generate four assignment bins: quartiles of label pt longs

IDOneBin <- cut(lps[,1], range(lps[,1]), include.lowest=TRUE)
# dissolve the polygons into the four bins

DissolveResult <- unionSpatialPolygons(ProjectedPolygons ,IDOneBin)
# Convert to PolySet for PBSMapping area calculations

DissolveResultPS <- SpatialPolygons2PolySet(NcDissolve)
# one simple example: aggregating a polygon attribute

AreasOfResult = calcArea(DissolveResultPS)



#
# script demonstrares polygon dissolve using maptools
# and area calculation using PBSmapping package.
#
# first, load the R packages that we will need
#
                                                   library(maptools)   # for geospatial services; also loads foreign and sp
                                                   library(gpclib)     # General Polygon Clipping library
                                                   library(rgdal)      # for map projection work; also loads sp
                                                   library(PBSmapping) # for GIS_like geospatial object manipulation / anslysis including poly
#
# Part 1:
# First example, derived from the maptools unionSpatialPolygon() method documentation in the R
# maptools user manual: We calculate and sum the area of each polygon in the North Carolina map.
# Then, use unionSpatialPolygons() to dissolve the county polygon boundries, and assign each
# polygon's area to one of four regions, based on longitude thresholds.
#

# Transform the polygons (which were read in as unprojected geographic coordinates)
# to an Albers Equal Area projection.
#
                                                   NorthCaroProj = spTransform(NorthCaroBase,CRS("+proj=aea +ellps=GRS80 +datum=WGS84"))
#
# Convert to a PolygonSet for compatability with PBSmapping package routines.
#
NorthCaroProjPS = SpatialPolygons2PolySet(NorthCaroProj)
#
plotPolys(NorthCaroProjPS, proj = TRUE,col="wheat1",xlab="longitude",ylab="latitude")
#
# polygon area calculations
#
                                                   print("Calculating North Carolina polygon areas...")
                                                   attr(NorthCaroProjPS, "projection") <- "LL"
                                                   NCPolyAreas = calcArea(NorthCaroProjPS,rollup=1)
#
# Compute the area of state by summing the area of the counties.
#
                                                   numCountyPolys = length(NCPolyAreas[,1])
                                                   NCArea = sum(NCPolyAreas[1:numCountyPolys,2])
                                                   print(sprintf("North Carolina (%d county polygons) area: %g sq km. Hit key to continue",
                                                                                  numCountyPolys,NCArea))
                                                                                  browser()
                               #
                               # create a set of 'breakpoints' that unionSpatialPolygons() method will use to
                               # place the dissolved polygons into one of four longitude 'zones' on the output map:
                               # Each county/polygon's x/y label coordinates gives the location of that polygon's center.
                               #
                                                                                  print("Dissolving North Carolina polygons...")

                                                                                  lps <- getSpPPolygonsLabptSlots(NorthCaroProj)
                               #
                               # Assign each county to one of four longitudinal 'bins':
                               #
                                                                                  IDFourBins <- cut(lps[,1], quantile(lps[,1]), include.lowest=TRUE)
                               #
                               # Dissolve operations: result is a SpatialPolygons object.
                               # Convert to PolySet to display new polygons and calculate areas.0
                               #
                                                                                  NcDissolve   <- unionSpatialPolygons(NorthCaroProj ,IDFourBins)
                                                                                  NcDissolvePSFour <- SpatialPolygons2PolySet(NcDissolve)
                                                                                  plotPolys(NcDissolvePSFour, proj = TRUE,col="wheat1",xlab="longitude",ylab="latitude")
                               #
                               # projecton attribute must be "UTM" or "LL" for areas in km ** 2
                               #
                                                                                  attr(NcDissolvePSFour, "projection") <- "LL"
                                                                                  NCDissolvePolyAreas = calcArea(NcDissolvePSFour ,rollup=1)
                               #
                               # sum the areas of all polygons in the poly set -
                               # the expression 'length(NCDissolvePolyAreas [,1]' returns the number of polygons
                               #
                                                                                  NCDissolveArea = sum(NCDissolvePolyAreas [1:length(NCDissolvePolyAreas [,1]),2])
                               #
                                                                                  print(sprintf("North Carolina (four regions) area: %g sq km. Hit key to continue",
                                                                                  NCDissolveArea))
                                                                                  browser()
                               #
                               # next, lets put all county polygons into a single 'bin' to get just a county outline:
                               # replace the quantile() call with one to range(), that returns just the min/max of the lps[,1] vector.
                               #
                                                                                  print("Dissolving North Carolina polygons (again)...")
                                                                                  IDOneBin <- cut(lps[,1], range(lps[,1]), include.lowest=TRUE)
                                                                                  NcDissolve   <- unionSpatialPolygons(NorthCaroProj ,IDOneBin)
                                                                                  NcDissolvePSOne <- SpatialPolygons2PolySet(NcDissolve)

                                                                                  plotPolys(NcDissolvePSOne, proj = TRUE,col="wheat1",xlab="longitude",ylab="latitude")
                               #
                               # projecton attribute must be "UTM" or "LL" for areas in km ** 2
                               #
                                                                                  print("Calculating North Carolina polygon area (again)...")
                                                                                  attr(NcDissolvePSOne, "projection") <- "LL"
                                                                                  NCDissolvePolyAreas = calcArea(NcDissolvePSOne ,rollup=1)
                                                                                  print(sprintf("North Carolina (1 region) area: %g sq km. Hit key to continue",NCDissolveArea))
                               #
                                                                                  browser()
                               #
                               # close all the graphics devices
                               #
