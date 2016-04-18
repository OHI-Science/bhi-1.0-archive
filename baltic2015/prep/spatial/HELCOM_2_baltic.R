#############################################
## Linking the HELCOM data to baltic regions
## MRF Mar 18 2016

## Data are in format of polygons that look
## and function like raster cells
## This script identifies which polygons land
## in which
#############################################

library(sp)
library(rgdal)
library(raster)
library(rgeos)
library(maptools)

source('../ohiprep/src/R/common.R')



###### Ocean regions ######################
#### BHI map
bhi <- readOGR(dsn = "/var/data/ohi/git-annex/clip-n-ship/bhi/spatial", layer = "rgn_offshore_gcs")


### Using the template from
### Getting a HELCOM map
helcom <- readOGR(dsn= '/var/data/ohi/git-annex/Baltic/HELCOM_to_BHIregion/raw/benthos/Agrypnetes crassicornis (DD)',
                   layer='Join_Benthic_invertebrates')
helcom <- helcom[, c("FID_1", "CELLCODE")]

# # testing ignore (this creates a smaller dataset to explore more easily)
# helcom <- helcom[, c("FID_1", "CELLCODE", "Abra_prism")]
# helcom@data$Abra_prism <- ifelse(sp_map@data$Abra_prism==0,
#                                  NA, sp_map@data$Abra_prism)
# helcom@data$Abra_prism <- factor(helcom@data$Abra_prism)
# helcom <- helcom[!is.na(helcom@data$Abra_prism), ]

#### transform the sp_map data to have the same
#### coordinate reference system as the region boundaries
bhi <- spTransform(bhi, CRS(proj4string(helcom)))

## make sure the transfomration seemed to go well (overlap of the 2 spatial files)
plot(helcom)
# this is when using a subset of the data extracted above
# text(helcom, labels=as.character(helcom@data$CELLCODE),
#      cex=0.5, font=2, offset=0.5, adj=c(0,2))
plot(bhi, add=TRUE, col="red")

## this code came from here:
## http://gis.stackexchange.com/questions/140504/extracting-intersection-areas-in-r
pi <- raster::intersect(helcom, bhi)
areas <- data.frame(area_m2=sapply(pi@polygons, FUN=function(x) {slot(x, 'area')}))
row.names(areas) <- sapply(pi@polygons, FUN=function(x) {slot(x, 'ID')})
# Combine attributes info and areas
attArea <- spCbind(pi, areas)
data <- aggregate(area_m2~rgn_id + CELLCODE, data=attArea, FUN=sum)
data$prop_area <- data$area_m2/1.000000e+08
hist(data$area_m2)
hist(data$prop_area)
data$type <- "bhi_sea"

write.csv(data, "baltic2015/prep/spatial/helcom_to_rgn_bhi_sea.csv", row.names=FALSE)



############################################
###### 50 km inland ######################

## NOTE: My idea was to get the 50 km inland data and merge it with the sea data to ensure that
## species landing slightly on land would be included.
## However, I let this run for over 24 hours and had no success.  I think there is something strange about the
## spatial file that is preventing this from working.

#### BHI map
bhi_inland <- readOGR(dsn = "/var/data/ohi/git-annex/Baltic/regions/BHI_regions_inland_buffer/BHI_inland_50km",
               layer = "BHI_inland_50km")


### Using the template from
### Getting a HELCOM map
helcom <- readOGR(dsn= '/var/data/ohi/git-annex/Baltic/HELCOM_to_BHIregion/raw/benthos/Agrypnetes crassicornis (DD)',
                  layer='Join_Benthic_invertebrates')
helcom <- helcom[, c("FID_1", "CELLCODE")]

#### transform the sp_map data to have the same
#### coordinate reference system as the region boundaries
bhi_inland <- spTransform(bhi_inland, CRS(proj4string(helcom)))

## make sure the transfomration seemed to go well (overlap of the 2 spatial files)
plot(helcom)
# this is when using a subset of the data extracted above
# text(helcom, labels=as.character(helcom@data$CELLCODE),
#      cex=0.5, font=2, offset=0.5, adj=c(0,2))
plot(bhi_inland, add=TRUE, col="red")

## this code came from here:
## http://gis.stackexchange.com/questions/140504/extracting-intersection-areas-in-r
pi <- raster::intersect(helcom, bhi_inland)
areas <- data.frame(area_m2=sapply(pi@polygons, FUN=function(x) {slot(x, 'area')}))
row.names(areas) <- sapply(pi@polygons, FUN=function(x) {slot(x, 'ID')})
# Combine attributes info and areas
attArea <- spCbind(pi, areas)
data <- aggregate(area_m2~rgn_id + CELLCODE, data=attArea, FUN=sum)
data$prop_area <- data$area_m2/1.000000e+08
hist(data$area_m2)
hist(data$prop_area)
data$type <- "bhi_inland50km"

write.csv(data, "baltic2015/prep/spatial/helcom_to_rgn_bhi_inland50km.csv", row.names=FALSE)

