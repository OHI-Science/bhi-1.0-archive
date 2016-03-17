#######################################
## Extracting the species data for BHI
#######################################

library(sp)
library(rgdal)
library(raster)
library(rgeos)
library(maptools)

#### BHI map
bhi <- readOGR(dsn = "../regions", layer = "rgn_offshore_gcs")

### Getting a HELCOM map
helcom <- readOGR(dsn= 'benthos/Agrypnetes crassicornis (DD)',
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
pi <- intersect(helcom, bhi, progress="text")
areas <- data.frame(area=sapply(pi@polygons, FUN=function(x) {slot(x, 'area')}))
row.names(areas) <- sapply(pi@polygons, FUN=function(x) {slot(x, 'ID')})
# Combine attributes info and areas 
attArea <- spCbind(pi, areas)
aggregate(area~rgn_id + CELLCODE, data=attArea, FUN=sum)
