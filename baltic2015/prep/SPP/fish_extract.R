#######################################
## Extracting the fish data
## MRF Mar 18 2016
#######################################

regions <- read.csv('bhi/baltic2015/prep/baltic_rgns_to_bhi_rgns_lookup_holas.csv') %>%
  select(rgn_id, Subbasin = basin_name)

names <- read.csv('bhi/baltic2015/prep/spp/raw/fish_species.csv')

fish <- readOGR(dsn = "C:/Users/Melanie/Desktop/bhi_data/spp_ico/All_Fish",
                layer = "all_fish")
fish <- fish@data
fish <- fish %>%
  mutate(Subbasin = as.character(Subbasin)) %>%
  mutate(Subbasin = ifelse(fish$Subbasin %in% grep("land Sea", fish$Subbasin, value=TRUE), "Aland Sea", Subbasin),
         Subbasin = ifelse(Subbasin %in% "Gulf of Gdansk", "Gdansk Basin", Subbasin))

setdiff(regions$Subbasin, fish$Subbasin)
setdiff(fish$Subbasin, regions$Subbasin)

### Need these subregions:
## [1] "Archipelago Sea"        "Vistula lagoon"        
## [3] "Curonian lagoon"        "Little Belt"           
## [5] "Southern Baltic Proper"

fish <- fish %>%
  left_join(regions, by="Subbasin") %>%
  select(-OBJECTID, -Basin_name, -Subbasin, -ET_ID) %>%
  gather("gis_name", "presence", -rgn_id) %>%
  filter(presence==1) %>%
  select(-presence) %>%
  left_join(names, by="gis_name")

write.csv(fish, "bhi/baltic2015/prep/SPP/intermediate/fish_extract.csv", row.names=FALSE)

