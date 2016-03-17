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
  select(rgn_id, label, basin, country, MYEAR, DATE, Species, STATN, Latitude, Longitude, Value, MUNIT)

# write.csv(pcb_data, "~/github/BHI-issues/raw_data/Contaminants/pcb_data.csv", row.names = F)


#### calculating status and trend values ####

pcb_data <- read.table(file = '~/github/BHI-issues/raw_data/Contaminants/pcb_data.csv', header = T, sep = ",")
pcb_data$DATE <- as.Date(levels(pcb_data$DATE)[as.numeric(pcb_data$DATE)], "%d/%m/%Y")

count(pcb_data, Species)
df <- count(pcb_data, MUNIT, Species)

pcb_data = pcb_data %>%
  mutate(Value.new = ifelse(MUNIT == "ng/g", Value,
                            ifelse(MUNIT == "%", NA,                      #This should be Value*10^7 but gives to high value
                                   ifelse(MUNIT == "ug/kg", Value,
                                          ifelse(MUNIT == "mg/kg", Value*10^3, NA)))))

#### Plot to check data ####

library(ggplot2)

pcb_data %>%
filter(Species == "Clupea harengus", MUNIT %in% c("ug/kg", "ng/g", "pg/g", "mg/kg"), rgn_id == 30) %>%
  ggplot(aes(x=DATE, y=Value.new, colour = STATN)) +
  geom_point(aes(group = rgn_id, shape = MUNIT)) +
  ggtitle("Clupea harengus, rgn 30") + ylab("ug/kg") +
  xlim(as.Date(c('2000-01-01', '2014-01-01'))) + ylim(0, 10)

windows()
pcb_data %>%
  filter(MUNIT %in% c("ug/kg", "ng/g", "pg/g", "mg/kg"), DATE > as.Date('2000-01-01')) %>%
  ggplot(aes(x=DATE, y=Value.new, colour = rgn_id, shape = MUNIT)) + geom_point(aes(group = Species)) +
  ylab("ug/kg") + xlim(as.Date(c('2000-01-01', '2014-01-01'))) +
  facet_wrap(~ basin, ncol = 3, scales = "free_y")

# It seems that the variation at each measurement can be very large.
# But that this is not due to sampling from different station.
# Create timeseries for each region by avereging by sample date

pcb_avg = pcb_data %>%
  filter(MUNIT %in% c("ug/kg", "ng/g", "pg/g", "mg/kg")) %>%
  group_by(basin, rgn_id, Species, DATE) %>%
  summarise(Value.avg = mean(Value.new, na.rm=T))

windows()
pcb_avg %>%
  filter(DATE > as.Date('2000-01-01')) %>%
  ggplot(aes(x=DATE, y=Value.avg, colour = Species)) + geom_point(aes(group = Species)) +
  ylab("ug/kg") + xlim(as.Date(c('2000-01-01', '2014-01-01'))) +
  facet_wrap(~ basin, ncol = 3, scales = "free_y")

pcb_trend_basin = pcb_avg %>%
  group_by(basin, Species) %>%
  filter(!is.na(Value.avg)) %>% filter(DATE > as.Date('2000-01-01')) %>%
  do(mod = lm(Value.avg ~ DATE, data = .)) %>%
  mutate(slope = summary(mod)$coeff[2]) %>%
  select(-mod)

pcb_trend_rgn = pcb_avg %>%
  group_by(basin, rgn_id, Species) %>%
  filter(!is.na(Value.avg)) %>% filter(DATE > as.Date('2000-01-01')) %>%
  do(mod = lm(Value.avg ~ DATE, data = .)) %>%
  mutate(slope = summary(mod)$coeff[2], intercept = summary(mod)$coeff[1]) %>%
#   summarise(status) %>%
  select(-mod)


