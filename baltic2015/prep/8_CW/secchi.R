library(package = dplyr)
library(package = tidyr)
library(RMySQL)
library(ggplot2)

# SETTING CONSTANTS
min_year = 2000        # earliest year to use as a start for regr_length timeseries, !!!THIS NEED TO BE filtered out BEFORE FILLING MISSING RGN WITH NA!!!
regr_length = 10       # number of years to use for regression
future_year = 5        # the year at which we want the likely future status
min_regr_length = 5    # min actual number of years with data to use for regression. !! SHORTER THAN regr_length !!

### read mysql config
# run your personal mysql config script to read in passcode

### MySQL commands
### IMPORTANT: whenever you open a MySQL connection with 'dbConnect' make sure that you close it directly after your querry!!!
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection

# load ICES data
t<-dbSendQuery(con, "select `secchi`, `BHI_ID`, `Month`, `Year`, `Assessment_unit`, `HELCOM_COASTAL_CODE`, `HELCOM_ID`, `Date`, `Latitude`, `Longitude`, `Cruise`, `Station` from ICES_secchi_ID_assigned;") #  where `HELCOM_COASTAL_CODE` > 0
data1<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
dbClearResult(t) # clears selection (IMPORTANT!)
# load SMHI data
t<-dbSendQuery(con, "select `value`, `BHI_ID`, `Month`, `Year`, `unit`, `HELCOM_COASTAL_CODE`, `HELCOM_ID`, `Latitude`, `Date`, `Longitude`, `Provtagningstillfaelle.id`, `Stationsnamn` from Sharkweb_data_secchi_ID_assigned;")
data2<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'

dbDisconnect(con) # closes connection (IMPORTANT!)

# filter data and bind rows for ices and smhi data
ices <- data1 %>%
  filter(!is.na(BHI_ID)) %>%
  select(BHI_ID, secchi, Year, Month, HELCOM_COASTAL_CODE, HELCOM_ID, Latitude, Longitude, Cruise, Station, Date) %>%
  mutate(supplier = 'ices')

smhi <- data2 %>%
  filter(!is.na(BHI_ID)) %>%
  rename(secchi = value) %>%
  select(BHI_ID, secchi, Year, Month, HELCOM_COASTAL_CODE, HELCOM_ID, Latitude, Longitude, Cruise = Provtagningstillfaelle.id, Station = Stationsnamn, Date) %>%
  mutate(supplier = 'smhi', Cruise = as.character(Cruise))

allData = bind_rows(ices, smhi) %>%
  rename(rgn_id = BHI_ID)

#### preparing data for functions.R ####
values <- allData %>%
  # rename(rgn_id = BHI_ID) %>%
  group_by(rgn_id, Year) %>%
  filter(Month %in% c(6:9)) %>%
  summarise(summer_secchi = mean(secchi, na.rm = F), year = mean(Year, na.rm = F)) %>%
  select(rgn_id, year, values = summer_secchi) %>%
  filter(year >= min_year) %>%
  ungroup(.)

# write.csv(values, "~/github/bhi/baltic2015/layers/cw_nu_values.csv")

# Load target levels set by HELCOM ????MOVE THIS DATA TO SERVER???? and make normalisation in functions.R
# Load rgn_id file from repository
rgn_id <- read.table(file = "~/github/bhi/baltic2015/layers/rgn_global_gl2014.csv", header = TRUE, sep = ",", stringsAsFactors = F)
rgn_id <- rgn_id %>% mutate(basin = gsub(" ", "_", substring(label,7)), country = paste(substring(label, 1, 3)))

target <- read.table(file = "~/github/bhi/baltic2015/prep/8_CW/eutro_targets_HELCOM.csv", header = TRUE, sep = ",", stringsAsFactors = F)
target <- full_join(target, rgn_id, by = 'basin') %>%
  rename(ref_point = summer_secchi) %>%
  select(rgn_id, ref_point) %>%
  filter(!is.na(rgn_id))

# write.csv(target, "~/github/bhi/baltic2015/layers/cw_nu_secchi_targets.csv", row.names = F)

#### preparing data for ODV ####
# headers needed for odv
# odv_headers = c('Cruise', 'Station','Type','yyyy-mm-ddThh:mm','Latitude [degrees_north]','Longitude [degrees_east]','Bot. Depth [m]','Secchi Depth [m]:METAVAR:DOUBLE','HELCOM_COASTAL_CODE:METAVAR:TEXT','HELCOM_ID:METAVAR:TEXT','Datasource:METAVAR:TEXT','PRES [db]:PRIMARYVAR:DOUBLE','VARIABLE1 [unit]:DOUBLE')
odv_data = allData %>%
  mutate(Type = 'B', 'Bot. Depth [m]' = 0, 'PRES [db]:PRIMARYVAR:DOUBLE' = 0) %>%
  rename('yyyy-mm-ddThh:mm' = Date, 'Latitude [degrees_north]' = Latitude, 'Longitude [degrees_east]' = Longitude, 'Datasource:METAVAR:TEXT' = supplier, 'Secchi Depth [m]:DOUBLE' = secchi) %>%
  select(Cruise, Station, Type, 11, 7, 8, 12, 14, 2)

unique(odv_data$`Datasource:METAVAR:TEXT`)

# write.table(odv_data, "~/odv_data.txt", sep = ";")

#### preparing data for plotting and analysing ####
allData = left_join(rgn_id, allData, by = 'rgn_id') %>%
  mutate(id_label = paste(.$label, .$rgn_id)) %>%
  select(-c(Cruise, Station, Longitude, Latitude)) %>%
  left_join(., target, by = 'rgn_id')

summer_mean <-
  allData %>%
  filter(Month %in% c(6:9)) %>%
  group_by(rgn_id, Year) %>%
  summarise(summer_secchi = mean(secchi, na.rm = F), year = mean(Year, na.rm = F), country = max(country), id_label =max(id_label), HELCOM_COASTAL_CODE = max(HELCOM_COASTAL_CODE), HELCOM_ID = max(HELCOM_ID))

#### calculate coastal and open sea summer secchi ####

summer_secchi_coastal <-
  allData %>%
  filter(Month %in% c(6:9), HELCOM_COASTAL_CODE > 0) %>%
  group_by(rgn_id, Year) %>%
  summarise(secchi = mean(secchi, na.rm = T), year = mean(Year, na.rm = T), country = max(country), id_label =max(id_label), HELCOM_ID = max(HELCOM_ID), country = max(country)) #, basin = max(basin) label =max(label)) #%>%

summer_secchi_opensea <-
  allData %>%
  filter(Month %in% c(6:9), HELCOM_COASTAL_CODE <= 0) %>%
  group_by(rgn_id, Year) %>%
  summarise(secchi = mean(secchi, na.rm = T), year = mean(Year, na.rm = T), country = max(country), id_label =max(id_label), HELCOM_ID = max(HELCOM_ID), country = max(country)) #, basin = max(basin) label =max(label)) #%>%

# write.csv(summer_secchi,'~/github/BHI-issues/raw_data/ICES/summer_secchi.csv')
# write.csv(summer_secchi_opensea,'~/github/BHI-issues/raw_data/ICES/summer_secchi_opensea.csv')

#### plot to check data ####
cbPalette = c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# plots all summer mean data
windows()
ggplot() +
  geom_point(data = summer_secchi_opensea, aes(x = year, y = secchi, color = 'open sea')) +
  geom_point(data = summer_secchi_coastal, aes(x = year, y = secchi, color = 'coastal')) +
  geom_point(data = summer_mean, aes(x = year, y = summer_secchi, color = 'all')) +
  geom_line(data = allData, aes(x = Year, y = ref_point, color = 'ref')) +
  # discrete_scale(aesthetics = c('open sea' = 'blue', 'coastal'= 'green', 'all' = 'grey'), name = 'area') +
  scale_color_manual('Area',values = c('open sea' = cbPalette[1], 'coastal'=  cbPalette[2], 'all' =  cbPalette[3], 'ref' = cbPalette[4])) +
  xlim(2000, 2015) +
  # ylim(2,12) +
  ggtitle("Mean secchi June-Sept") +
  facet_wrap(~rgn_id, ncol = 5, drop = F)

# plots status time-series from functions.R
windows()
ggplot() +
  geom_point(data = status_score, aes(x = year, y = status*100)) +
  ggtitle("Status scores from functions.R") +
  facet_wrap(~rgn_id, ncol = 5, drop = F)

# plots status and trend from functions.R
ylims = data.frame(region_id = 1:42, dimension = 'status', score = 0) %>%
  bind_rows(., data.frame(region_id = 1:42, dimension = 'status', score = 100)) %>%
  bind_rows(., data.frame(region_id = 1:42, dimension = 'trend', score = -1)) %>%
  bind_rows(., data.frame(region_id = 1:42, dimension = 'trend', score = 1)) %>%
  arrange(region_id)

windows(pointsize = 14)
ggplot() +
  geom_point(data = ylims, aes(x = region_id, y = score), color = 'white', size = 0) +      # to get the correct scales for trend and status
  geom_point(data = filter(scores, goal == 'CW', dimension %in% c('status', 'trend')),
             aes(x = region_id, y = score, color = as.factor(region_id)), size = 2) +
  ggtitle("Status and trend scores from functions.R") +
  facet_wrap(~dimension, ncol = 2, drop = F, scales = 'free_y') +
  ggsave(file="CW_status_trend.pdf", width = 210, height = 297, units = "mm")

# plot allData by country / region
windows()
ggplot() +
  geom_point(data = allData, aes(x = Year, y = secchi, color = as.factor(BHI_ID))) +
  xlim(1995, 2015) +
  facet_wrap(~country, ncol = 3, drop = F)
# plot allData by region / supplier
windows()
ggplot() +
  geom_point(data = allData, aes(x = Year, y = secchi, color = as.factor(country), shape = supplier)) +
  xlim(1995, 2015) +
  facet_wrap(~id_label, drop = F)

# plots all data and summer mean
windows()
ggplot() +
  geom_point(data = filter(allData, supplier == 'smhi'), aes(x = Year, y = secchi, color = supplier), size = 2) +
  geom_point(data = filter(allData, supplier == 'ices'), aes(x = Year, y = secchi, color = supplier)) +
  geom_point(data = summer_mean, aes(x = year, y = summer_secchi, color = 'mean')) +
  scale_color_manual(values = c('smhi' = cbPalette[3], 'ices'= cbPalette[2], 'mean' = 'black')) +
  xlim(1995, 2015) +
  ggtitle('summer data') +
  facet_wrap(~id_label, drop = F)

# plots Swedish summer data, showing, smhi, ices and summer mean for them
windows()
ggplot() +
  geom_point(data = filter(allData, country == 'Swe', supplier == 'smhi', Month %in% c(6:9)), aes(x = Year, y = secchi, color = supplier), size = 2) +
  geom_point(data = filter(allData, country == 'Swe', supplier == 'ices', Month %in% c(6:9)), aes(x = Year, y = secchi, color = supplier)) +
  geom_point(data = filter(summer_mean, country == 'Swe'), aes(x = year, y = summer_secchi, color = 'mean')) +
  scale_color_manual(values = c('smhi' = cbPalette[3], 'ices'= cbPalette[2], 'mean' = 'black')) +
  xlim(1995, 2015) +
  ggtitle('summer data') +
  facet_wrap(~id_label, drop = F)


# Cannot plot score before combining secchi depth and target
# windows()
# ggplot() +
#   geom_point(data = summer_secchi_all, aes(x = year, y = score, color = country)) +
#   xlim(2005, 2015) +
#   ylim(0,1) +
#   facet_wrap(~BHI_ID, ncol = 6, drop = F)
