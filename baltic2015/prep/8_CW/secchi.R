library(package = plyr)
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

t<-dbSendQuery(con, "select `secchi`, `BHI_ID`, `Month`, `Year`, `Assessment_unit`, `HELCOM_COASTAL_CODE`, `HELCOM_ID` from ICES_secchi_ID_assigned;") #  where `HELCOM_COASTAL_CODE` > 0
data<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
dbClearResult(t) # clears selection (IMPORTANT!)
dbDisconnect(con) # closes connection (IMPORTANT!)

#### preparing data for functions.R ####
values <- data %>%
  rename(rgn_id = BHI_ID) %>%
  group_by(rgn_id, Year) %>%
  filter(Month %in% c(6:9)) %>%
  summarise(summer_secchi = mean(secchi, na.rm = F), year = mean(Year, na.rm = F)) %>%
  select(rgn_id, year, values = summer_secchi) %>%
  filter(year >= min_year) %>%
  ungroup(.)

# write(values, "~/github/bhi/baltic2015/layers/cw_nu_values.csv")

# Load target levels set by HELCOM ????MOVE THIS DATA TO SERVER???? and make normalisation in functions.R
# Load rgn_id file from repository
rgn_id <- read.table(file = "~/github/bhi/baltic2015/layers/rgn_global_gl2014.csv", header = TRUE, sep = ",", stringsAsFactors = F)
rgn_id <- rgn_id %>% mutate(basin = gsub(" ", "_", substring(label,7)))

target <- read.table(file = "~/github/bhi/baltic2015/prep/8_CW/eutro_targets_HELCOM.csv", header = TRUE, sep = ",", stringsAsFactors = F)
target <- full_join(target, rgn_id, by = 'basin') %>%
  rename(ref_point = summer_secchi) %>%
  select(rgn_id, ref_point) %>%
  filter(!is.na(rgn_id))

# write.csv(target, "~/github/bhi/baltic2015/layers/cw_nu_secchi_targets.csv", row.names = F)

#### preparing data for plotting and analysing ####

# adding country column to data from server
data2 <- data %>%
  rename(rgn_id = BHI_ID) %>%
  mutate(country = paste(substring(Assessment_unit, 1, 3))) %>%
  filter(!is.na(rgn_id))

sort(unique(data2$rgn_id))

# data2 = full_join(data2, rgn_id, by = 'rgn_id') #%>%
#   # select(-basin, -label)
# sort(unique(data2$rgn_id))

summer_secchi_all <-
  data2 %>%     # or if you want to use labels in plotting use, full_join(data2, rgn_id, by = 'rgn_id') %>%
  filter(Month %in% c(6:9)) %>%
  # mutate(country = substring(label,1,3)) %>%
  group_by(rgn_id, Year) %>%
  summarise(summer_secchi = mean(secchi, na.rm = F), year = mean(Year, na.rm = F), HELCOM_ID = max(HELCOM_ID), country = max(country)) #, basin = max(basin) label =max(label)) #%>%

sort(unique(summer_secchi_all$rgn_id))

#### calculate coastal and open sea summer secchi ####

summer_secchi_coastal <-
  data2 %>%
  filter(Month %in% c(6:9), HELCOM_COASTAL_CODE > 0) %>%
  # mutate(country = paste(substring(Assessment_unit, 1, 3))) %>%
  # mutate(country = substring(label,1,3), target = summer_secchi) %>%
  group_by(rgn_id, Year) %>%
  summarise(secchi = mean(secchi, na.rm = T), year = mean(Year, na.rm = T), HELCOM_ID = max(HELCOM_ID), country = max(country)) #, basin = max(basin) label =max(label)) #%>%

summer_secchi_opensea <-
  data2 %>%
  filter(Month %in% c(6:9), HELCOM_COASTAL_CODE <= 0) %>%
  group_by(rgn_id, Year) %>%
  summarise(secchi = mean(secchi, na.rm = T), year = mean(Year, na.rm = T), HELCOM_ID = max(HELCOM_ID), country = max(country)) #, basin = max(basin) label =max(label)) #%>%

# write.csv(summer_secchi,'~/github/BHI-issues/raw_data/ICES/summer_secchi.csv')
# write.csv(summer_secchi_opensea,'~/github/BHI-issues/raw_data/ICES/summer_secchi_opensea.csv')

#### plot to check data ####
windows()
ggplot(summer_secchi_coastal) +
  geom_point(aes(x = year, y = secchi, color = as.factor(rgn_id))) +
#   geom_point(data = filter(data, HELCOM_COASTAL_CODE > 0), aes(x = Year, y = secchi, color = country)) +
  xlim(1995, 2015) +
  ylim(2,12) +
  facet_wrap(~rgn_id) +
  ggtitle("Coastal areas")

windows()
ggplot() +
  geom_point(data = summer_secchi_opensea, aes(x = year, y = secchi), color = 'blue') +
  geom_point(data = summer_secchi_coastal, aes(x = year, y = secchi), color = 'red') +
  geom_point(data = summer_secchi_all, aes(x = year, y = summer_secchi), color = 'green') +
  xlim(1995, 2015) +
  ylim(2,12) +
  facet_wrap(~rgn_id, ncol = 6, drop = F)

windows()
ggplot() +
  geom_point(data = summer_secchi_opensea, aes(x = year, y = secchi, color = country)) +
  geom_point(data = summer_secchi_coastal, aes(x = year, y = secchi, color = country)) +
  xlim(1995, 2015) +
  ylim(2,12) +
  facet_wrap(~HELCOM_ID, ncol = 6, drop = F)

# Cannot plot score before combining secchi depth and target
# windows()
# ggplot() +
#   geom_point(data = summer_secchi_all, aes(x = year, y = score, color = country)) +
#   xlim(2005, 2015) +
#   ylim(0,1) +
#   facet_wrap(~BHI_ID, ncol = 6, drop = F)
