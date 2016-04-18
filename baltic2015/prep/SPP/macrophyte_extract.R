#######################################
## Extracting the macro data
## MRF Mar 18 2016
#######################################

### NOTE: need inland extraction of HELCOM cells
### Need species name translation


regions <- read.csv("baltic2015/prep/spatial/helcom_to_rgn_bhi_sea.csv")

names <- read.csv('baltic2015/prep/SPP/raw/macrophyte_species.csv')

macro <- readOGR(dsn = "/var/data/ohi/git-annex/Baltic/spp/All_Macrophytes",
                layer = "Join_macrophytes")

macro_data <- macro@data %>%
  gather("gis_name", "present", -CELLCODE) %>%
  filter(present > 0) %>%
  left_join(names, by="gis_name") %>%
  left_join(regions, by="CELLCODE") %>%
  select(rgn_id, species_name, IUCN) %>%
  unique() %>%
  filter(!is.na(rgn_id)) %>%                ### N=17 grids that fell outside the water.  Probably want to extract the data with land/ocean spatial file
  data.frame()                              ### instead of ocean only


write.csv(macro_data, "baltic2015/prep/SPP/intermediate/macrophytes.csv", row.names=FALSE)

