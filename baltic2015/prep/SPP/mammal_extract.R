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

## some species have multiple IUCN categories (probably due to subspecies)
## It would be ideal if we know which categories correspond to which regions,
## but these data are not available.
## two possible options are:
  ## 1. average them
  ## 2. use the most conservative option

## I am going with #2 for now, but this would be easy to change.


species <- read.csv('baltic2015/prep/SPP/raw/mammal_species.csv') %>%
  filter(!(species_name == "Phoca vitulina vitulina" & IUCN == "LC")) %>%
  filter(!(species_name == "Phocoena phocoena" & IUCN == "VU"))



mammal <- readOGR(dsn = "/var/data/ohi/git-annex/Baltic/spp/All_Mammals",
                layer = "Join_Mammals")
mammal <- mammal@data
mammal <- mammal %>%
  mutate(Subbasin = as.character(Subbasin)) %>%
  mutate(Subbasin = ifelse(mammal$Subbasin %in% grep("land Sea", mammal$Subbasin, value=TRUE), "Aland Sea", Subbasin),
         Subbasin = ifelse(Subbasin %in% "Gulf of Gdansk", "Gdansk Basin", Subbasin))

regions <- read.csv('baltic2015/prep/baltic_rgns_to_bhi_rgns_lookup_holas.csv') %>%
  select(rgn_id, Subbasin = basin_name)
setdiff(regions$Subbasin, mammal$Subbasin)
setdiff(mammal$Subbasin, regions$Subbasin)

mammal <- mammal %>%
  left_join(regions, by="Subbasin") %>%
  select(-OBJECTID, -Basin_name, -Subbasin) %>%
  gather("gis_name", "presence", -rgn_id) %>%
  filter(presence==1) %>%
  select(-presence) %>%
  left_join(species, by="gis_name") %>%
  select(rgn_id, species_name, IUCN)


write.csv(mammal, "baltic2015/prep/SPP/intermediate/mammals.csv", row.names=FALSE)

