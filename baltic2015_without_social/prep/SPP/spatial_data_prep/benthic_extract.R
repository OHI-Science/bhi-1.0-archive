########################################################################
##
##  Organizes benthic data
##
##  MRF March 17 2016
##
######################################################################

library(dplyr)
library(tidyr)

### Benthic
species <- read.csv("baltic2015/prep/SPP/raw/benthic_species.csv")

### Regions
regions <- read.csv("baltic2015/prep/spatial/helcom_to_rgn_bhi_sea.csv")


#### Benthos Helcom data:
spatial <- read.csv('baltic2015/prep/SPP/raw/benthos_spatial_data.csv')

benthos <- spatial %>%
  select(-FID_1) %>%
  gather("gis_name", "present", -1) %>%
  filter(present > 0) %>%
  left_join(species, by="gis_name") %>%
  left_join(regions, by="CELLCODE") %>%
  select(rgn_id, species_name, IUCN) %>%
  unique() %>%
  filter(!is.na(rgn_id)) %>%                ### N=18 grids that fell outside the water.  Probably want to extract the data with land/ocean spatial file
  data.frame()                              ### instead of ocean only

write.csv(benthos, "baltic2015/prep/SPP/intermediate/benthos.csv", row.names=FALSE)
