library(package = dplyr)

#### prep for matching positions with basins in GIS ####

# path_in ex. '~/github/BHI-issues/raw_data/Contaminants/ContaminantsBiota2015824_PCB.csv'
# path_out ex. "~/github/BHI-issues/raw_data/Contaminants/to_gis.txt"
# ... ex. Country, STATN, MYEAR, DATE,  Species, Value, MUNIT

gis_prep <- function(path_in, path_out, ...) {

raw_data <- read.table(file = path_in, header = TRUE, sep = ",")

raw_data = raw_data %>%
  select(Latitude, Longitude, ...) %>%
  mutate(ID = row.names(.))

to_gis =
  raw_data %>%
  select(ID, Latitude, Longitude) %>%
  distinct(Latitude, Longitude)

## save the positions for raw_data data to look-up rgn_label in GIS.
write.table(to_gis, path_out, sep = " ", row.names = F)
}

# gis_prep('~/github/BHI-issues/raw_data/Contaminants/ContaminantsBiota2015824_PCB.csv',
#          "~/github/BHI-issues/raw_data/Contaminants/to_gis.txt",
#          Country, STATN, MYEAR, DATE, Species, Value, MUNIT)


## Make into function to make general for any point data files
## read GIS table with positions and corresponding rgn_label

# path_in2 ex. '~/github/BHI-issues/raw_data/Contaminants/pcb_spatialjoin.csv'
# path_out ex. "~/github/BHI-issues/raw_data/Contaminants/joined_data.csv"
# ex. raw_country = Name_1, raw_basin = Name
# ex. MYEAR, DATE, Species, STATN, Value, MUNIT

gis_prep2 <- function(path_in_raw, path_in2, path_out, ...) {

## read rgn_labels
  rgn_labels = read.table(file = '~/github/bhi/baltic2015/layers/rgn_labels.csv', header = TRUE, sep = ",")
## read raw data
  raw_data <- read.table(file = path_in_raw, header = TRUE, sep = ",")
  raw_data = raw_data %>%
    select(Latitude, Longitude, ...) %>%
    mutate(ID = row.names(.))
## read spatial join file from gis. Then create label column that matches rgn_label names
  gis_data = read.table(file = path_in2, header = TRUE, sep = ",")
  stat_to_rgn =
    gis_data %>%
    rename(country = Name_1, basin = Name) %>%
    select(Latitude, Longitude, basin, country) %>%
    mutate(label = paste(substring(country,1,3), basin, sep = " - "))
  ## join raw_data to gis spatial join file to match positions with rgn_label
  data =
    full_join(stat_to_rgn, rgn_labels, by = "label") %>%
    full_join(., raw_data, by = c("Latitude" = "Latitude", "Longitude" = "Longitude")) #%>%
    select(rgn_id, label, basin, country, Latitude, Longitude, ...)

  write.csv(data, path_out, row.names = F)
}

gis_prep2('~/github/BHI-issues/raw_data/Contaminants/ContaminantsBiota2015824_PCB.csv',
          '~/github/BHI-issues/raw_data/Contaminants/pcb_spatialjoin.csv',
          "~/github/BHI-issues/raw_data/Contaminants/test_data.csv",
          Country, STATN, MYEAR, DATE, Species, Value, MUNIT)
