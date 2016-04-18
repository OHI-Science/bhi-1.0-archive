#######################################
## Extracting the mammal data
## MRF Mar 18 2016
#######################################

library(sp)
library(rgdal)
library(raster)
library(rgeos)
library(maptools)
library(dplyr)
library(tidyr)


mammal <- readOGR(dsn = "C:/Users/Melanie/Desktop/bhi_data/spp_ico/All_Mammals",
                layer = "Join_Mammals")
mammal <- mammal@data
mammal <- mammal %>%
  mutate(Subbasin = as.character(Subbasin)) %>%
  mutate(Subbasin = ifelse(mammal$Subbasin %in% grep("land Sea", mammal$Subbasin, value=TRUE), "Aland Sea", Subbasin),
         Subbasin = ifelse(Subbasin %in% "Gulf of Gdansk", "Gdansk Basin", Subbasin))

regions <- read.csv('bhi/baltic2015/prep/baltic_rgns_to_bhi_rgns_lookup_holas.csv') %>%
  select(rgn_id, Subbasin = basin_name)
setdiff(regions$Subbasin, mammal$Subbasin)
setdiff(mammal$Subbasin, regions$Subbasin)

mammal <- mammal %>%
  left_join(regions, by="Subbasin") %>%
  select(-OBJECTID, -Basin_name, -Subbasin) %>%
  gather("gis_name", "presence", -rgn_id) %>%
  filter(presence==1) %>%
  select(-presence)
  

### NOTE: Need to associate these regions with bhi regions:
## "Vistula lagoon"  "Curonia lagoon"  "Little Belt"     "Archipelago Sea"
## NOTE: Also need to associate mammal codes with names and vulnerability
  
write.csv(mammal, "bhi/baltic2015/prep/SPP/intermediate/mammal_extract.csv", row.names=FALSE)

