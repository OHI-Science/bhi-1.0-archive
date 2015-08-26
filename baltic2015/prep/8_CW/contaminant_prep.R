## Processing contaminant data to create data layers for score calculation. Data downloaded from ICES

library(package = dplyr)

#### prep for matching positions with basins in GIS ####

## make into a function to create files for GIS from any point data file with positions
pcb <- read.table(file = '~/github/BHI-issues/raw_data/Contaminants/ContaminantsBiota2015824_PCB.csv', header = TRUE, sep = ",")

pcb = pcb %>%
  select(Country, STATN, MYEAR, DATE, Latitude, Longitude, Species, Value, MUNIT) %>%
  mutate(ID = row.names(.))

pcb_to_gis =
  pcb %>%
  select(ID, Latitude, Longitude) %>%
  distinct(Latitude, Longitude)

## save the positions for pcb data to look-up rgn_label in GIS.
write.table(pcb_to_gis, "~/github/BHI-issues/raw_data/Contaminants/pcb_dist.txt", sep = " ", row.names = F)
write.csv(pcb_to_gis, "~/github/BHI-issues/raw_data/Contaminants/pcb_dist.csv", row.names = F)

## Make into function to make general for any point data files
## read GIS table with positions and corresponding rgn_label
stat_to_rgn = read.table(file = '~/github/BHI-issues/raw_data/Contaminants/pcb_spatialjoin.csv', header = TRUE, sep = ",")
## read rgn_labels
rgn_labels = read.table(file = '~/github/bhi/baltic2015/layers/rgn_labels.csv', header = TRUE, sep = ",")

stat_to_rgn =
  stat_to_rgn %>%
  select(HELCOM_ID, Name, Name_1, Latitude, Longitude, ID) %>%
  mutate(label = paste(substring(Name_1,1,3), Name, sep = " - "))

pcb_data =
  full_join(stat_to_rgn, rgn_labels, by = "label") %>%
  full_join(., pcb, by = c("Latitude" = "Latitude", "Longitude" = "Longitude")) %>%
  rename(country = Name_1, basin = Name) %>%
  select(rgn_id, label, MYEAR, DATE, Species, STATN, Latitude, Longitude, Value, MUNIT)

write.csv(pcb_data, "~/github/BHI-issues/raw_data/Contaminants/pcb_data.csv", row.names = F)


#### calculating status and trend values ####


