#######################################
## Extracting the macro data
## MRF Mar 18 2016
#######################################

### NOTE: need inland extraction of HELCOM cells
### Need species name translation


regions <- read.csv("bhi/baltic2015/prep/spatial/helcom_to_rgn.csv")

names <- read.csv('bhi/baltic2015/prep/spp/raw/macro_species.csv')

macro <- readOGR(dsn = "C:/Users/Melanie/Desktop/bhi_data/spp_ico/All_Macrophytes",
                layer = "Join_macrophytes")

macro <- macro@data %>%
  gather("gis_name", "present", -CELLCODE) %>%
  filter(present > 0) %>%
#  left_join(species, by="gis_name") %>%
  left_join(regions, by="CELLCODE") %>%
  select(rgn_id, gis_name) %>%
  unique() %>%
  filter(!is.na(rgn_id)) %>%                ### N=17 grids that fell outside the water.  Probably want to extract the data with land/ocean spatial file
  data.frame()                              ### instead of ocean only


write.csv(macro, "bhi/baltic2015/prep/SPP/intermediate/macro_extract.csv", row.names=FALSE)

