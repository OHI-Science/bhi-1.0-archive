#######################################
## Extracting the fish data
## MRF Mar 18 2016
#######################################
library(sp)
library(rgdal)
library(raster)
library(rgeos)
library(maptools)
library(dplyr)
library(tidyr)

regions <- read.csv('baltic2015/prep/baltic_rgns_to_bhi_rgns_lookup_holas.csv') %>%
  select(rgn_id, Subbasin = basin_name)

names <- read.csv('baltic2015/prep/SPP/raw/fish_species.csv')

### some additional stuff to identify some missing subbasins in the "baltic_rgns_to_bhi_rgns_lookup_holas.csv"
# tmp <-  readOGR(dsn = "/var/data/ohi/git-annex/Baltic/spp/Fishes/Pelecus cultratus (LC)",
#                layer = "Pelecus_cultratus_combo")
# tmp <- tmp[tmp$Subbasin == "Southern Baltic Proper", ]
# bhi <- readOGR(dsn = "/var/data/ohi/git-annex/clip-n-ship/bhi/spatial", layer = "rgn_offshore_gcs")
# bhi <- spTransform(bhi, CRS(proj4string(tmp)))
# plot(bhi)
# plot(tmp, add=TRUE, col="red")
#
# plot(tmp, add=TRUE, col="red")

fish <- readOGR(dsn = "/var/data/ohi/git-annex/Baltic/spp/All_Fish",
                layer = "all_fish")
fish <- fish@data
fish <- fish %>%
  mutate(Subbasin = as.character(Subbasin)) %>%
  mutate(Subbasin = ifelse(fish$Subbasin %in% grep("land Sea", fish$Subbasin, value=TRUE), "Aland Sea", Subbasin),
         Subbasin = ifelse(Subbasin %in% "Gulf of Gdansk", "Gdansk Basin", Subbasin))

setdiff(fish$Subbasin, regions$Subbasin)


fish <- fish %>%
  left_join(regions, by="Subbasin") %>%
  select(-OBJECTID, -Basin_name, -Subbasin, -ET_ID) %>%
  gather("gis_name", "presence", -rgn_id) %>%
  filter(presence==1) %>%
  select(-presence) %>%
  left_join(names, by="gis_name") %>%
  select(rgn_id, species_name, IUCN=iucn)

write.csv(fish, "baltic2015/prep/SPP/intermediate/fish.csv", row.names=FALSE)

