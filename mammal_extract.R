#####################################
## Extracting the mammal data
#####################################

library(sp)
library(rgdal)
library(raster)
library(rgeos)
library(maptools)

source('../ohiprep/src/R/common.R')

# function to get rid of extensions
no.extension <- function(astring) {
  if (substr(astring, nchar(astring), nchar(astring))==".") {
    return(substr(astring, 1, nchar(astring)-1))
  } else {
    no.extension(substr(astring, 1, nchar(astring)-1))
  }
}

#### BHI map
bhi <- readOGR(dsn = "/var/data/ohi/git-annex/clip-n-ship/bhi/spatial", layer = "rgn_offshore_gcs")
