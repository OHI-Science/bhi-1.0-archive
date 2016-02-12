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

# Load rgn_id file from repository
rgn_id <- read.table(file = "~/github/bhi/baltic2015/layers/rgn_global_gl2014.csv", header = TRUE, sep = ",", stringsAsFactors = F)
rgn_id <- rgn_id %>% mutate(basin = gsub(" ", "_", substring(label,7)))

# load target levels set by HELCOM ????MOVE THIS DATA TO SERVER???? and make normalisation in functions.R
# target <- read.table(file = "~/github/bhi/baltic2015/prep/8_CW/eutro_targets_HELCOM.csv", header = TRUE, sep = ",", stringsAsFactors = F)
# target <- full_join(target, rgn_id, by = 'basin') %>%
#   rename(rgn_id = BHI_ID) %>%
#   select(rgn_id, summer_secchi) %>%
#   filter(!is.na(rgn_id))
# write.csv(target, "~/github/bhi/baltic2015/prep/8_CW/secchi_targets.csv", row.names = F)

data <- data %>%
  rename(rgn_id = BHI_ID) %>%
  mutate(country = paste(substring(Assessment_unit, 1, 3))) %>%
  filter(!is.na(rgn_id))
sort(unique(data$rgn_id))

data2 = full_join(data, rgn_id, by = 'rgn_id') #%>%
  # select(-basin, -label)
sort(unique(data2$rgn_id))

summer_secchi_all <-
  data2 %>%
  filter(Month %in% c(6:9)) %>%
  mutate(country = substring(label,1,3)) %>%
  group_by(rgn_id, Year) %>%
  summarise(summer_secchi = mean(secchi, na.rm = F), year = mean(Year, na.rm = F), HELCOM_ID = max(HELCOM_ID), country = max(country), label =max(label), basin = max(basin)) #%>%
  # mutate(status = pmin(1, secchi/target))
sort(unique(summer_secchi_all$rgn_id))

summer_secchi = summer_secchi_all %>%
    group_by(rgn_id) %>%
    # summarise_each(funs(last), BHI_ID, status) %>%  # leaves only the last status score in the data frame
    select(rgn_id, year, summer_secchi) %>%
    filter(year >= min_year) %>%
    ungroup(.)

unique(status_score$rgn_id)

#  write csv files to layers folder ####
 spara = F
 if (spara == T){
   # write.csv(status_score, "~/github/bhi/baltic2015/layers/cw_nu_status.csv", row.names = F)
   write.csv(summer_secchi, "~/github/bhi/baltic2015/prep/8_CW/cw_nu_values.csv", row.names = F)
   }

#### calculate coastal and open sea summer secchi ####

summer_secchi_coastal <-
  data2 %>%
  filter(Month %in% c(6:9), HELCOM_COASTAL_CODE > 0) %>%
  # mutate(country = paste(substring(Assessment_unit, 1, 3))) %>%
  # mutate(country = substring(label,1,3), target = summer_secchi) %>%
  group_by(rgn_id, Year) %>%
  summarise(secchi = mean(secchi, na.rm = T), year = mean(Year, na.rm = T), HELCOM_ID = max(HELCOM_ID), country = max(country), label =max(label), basin = max(basin))

summer_secchi_opensea <-
  data2 %>%
  filter(Month %in% c(6:9), HELCOM_COASTAL_CODE <= 0) %>%
  group_by(rgn_id, Year) %>%
  summarise(secchi = mean(secchi, na.rm = T), year = mean(Year, na.rm = T), HELCOM_ID = max(HELCOM_ID), country = max(country), label =max(label), basin = max(basin))

# write.csv(summer_secchi,'~/github/BHI-issues/raw_data/ICES/summer_secchi.csv')
# write.csv(summer_secchi_opensea,'~/github/BHI-issues/raw_data/ICES/summer_secchi_opensea.csv')

#### plot to check data ####
windows()
ggplot(summer_secchi_coastal) +
  geom_point(aes(x = year, y = secchi, color = label)) +
#   geom_point(data = filter(data, HELCOM_COASTAL_CODE > 0), aes(x = Year, y = secchi, color = country)) +
  xlim(1995, 2015) +
  ylim(2,12) +
  facet_wrap(~label) +
  ggtitle("Coastal areas")

windows()
ggplot() +
  geom_point(data = summer_secchi_opensea, aes(x = year, y = secchi), color = 'blue') +
  geom_point(data = summer_secchi_coastal, aes(x = year, y = secchi), color = 'red') +
  geom_point(data = summer_secchi_all, aes(x = year, y = summer_secchi), color = 'green') +
  xlim(1995, 2015) +
  ylim(2,12) +
  facet_wrap(~label, ncol = 6, drop = F)

windows()
ggplot() +
  geom_point(data = summer_secchi_opensea, aes(x = year, y = secchi, color = country)) +
  geom_point(data = summer_secchi_coastal, aes(x = year, y = secchi, color = country)) +
  xlim(1995, 2015) +
  ylim(2,12) +
  facet_wrap(~basin, ncol = 6, drop = F)

# Cannot plot score before combining secchi depth and target
# windows()
# ggplot() +
#   geom_point(data = summer_secchi_all, aes(x = year, y = score, color = country)) +
#   xlim(2005, 2015) +
#   ylim(0,1) +
#   facet_wrap(~BHI_ID, ncol = 6, drop = F)
