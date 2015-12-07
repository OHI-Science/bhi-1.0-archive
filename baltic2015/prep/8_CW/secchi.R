library(package = dplyr)
library(package = tidyr)
library(RMySQL)
library(ggplot2)

### read mysql config

conf<-read.csv("C:/Users/lvikt/Documents/Jobb/BHI/Data and goal descriptions/Database/mysql_conf.txt") # set your path to your mysql_conf
conf<-as.matrix(conf)

### MySQL commands
### IMPORTANT: whenever you open a MySQL connection with 'dbConnect' make sure that you close it directly after your querry!!!
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI",host=conf[,3], port=3306) # sets up the connection

t<-dbSendQuery(con, "select `secchi`, `BHI_ID`, `Month`, `Year`, `Assessment_unit`, `HELCOM_COASTAL_CODE`, `HELCOM_ID` from ICES_secchi_ID_assigned;") #  where `HELCOM_COASTAL_CODE` > 0
data<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
dbClearResult(t) # clears selection (IMPORTANT!)
dbDisconnect(con) # closes connection (IMPORTANT!)

# Load secchi data from database
rgn_id <- read.table(file = "~/github/bhi/baltic2015/layers/rgn_global_gl2014.csv", header = TRUE, sep = ",", stringsAsFactors = F)
rgn_id <- rename(rgn_id, BHI_ID = rgn_id) %>%
  mutate(basin = gsub(" ", "_", substring(label,7)))

# load target levels set by HELCOM
target <- read.table(file = "~/github/bhi/baltic2015/prep/8_CW/eutro_targets.csv", header = TRUE, sep = ",", stringsAsFactors = F)
target <- full_join(target, rgn_id, by = 'basin')

data <- data %>%
  mutate(country = paste(substring(Assessment_unit, 1, 3)))

data2 = full_join(data, rgn_id, by = 'BHI_ID') %>%
  full_join(., select(target, -basin, -label), by = 'BHI_ID')

summer_secchi_all <-
  data2 %>%
  filter(Month %in% c(6:9)) %>%
  mutate(country = substring(label,1,3), target = summer_secchi) %>%
  group_by(BHI_ID, Year) %>%
  summarise(secchi = mean(secchi, na.rm = T), year = mean(Year, na.rm = T), target = max(target), HELCOM_ID = max(HELCOM_ID), country = max(country), label =max(label), basin = max(basin)) %>%
  mutate(score = pmin(1, secchi/target))

  val_basin = filter(summer_secchi_all, BHI_ID == 5)
  val_basin$BHI_ID = 6

  duplicate.data <- function(value_BHI_ID, val_df, nodata_BHI_ID) {
    temp = filter(val_df, BHI_ID == value_BHI_ID)
    temp$BHI_ID = nodata_BHI_ID
    return(temp)
  }

  summer_secchi_all = bind_rows(summer_secchi_all,
                                duplicate.data(5, summer_secchi_all, 6),     # DK Sound = SE Sound
                                duplicate.data(36, summer_secchi_all, 35),   # SE Aland Sea = FI Aland Sea
                                duplicate.data(13, summer_secchi_all, 11))   # SE Arkona = GE Arkona

  summer_secchi_all = filter(summer_secchi_all, label != 'Den - The Sound')

  status_score = summer_secchi_all %>%
    group_by(BHI_ID) %>%
    summarise_each(funs(last), BHI_ID, score) %>%
    rename(rgn_id = BHI_ID)

  #  write csv files to layers folder ####
   write.csv(status_score, "~/github/bhi/baltic2015/layers/cw_nu_status.csv", row.names = F)

#### plot ####

summer_secchi_coastal <-
  data2 %>%
  filter(Month %in% c(6:9), HELCOM_COASTAL_CODE > 0) %>%
  # mutate(country = paste(substring(Assessment_unit, 1, 3))) %>%
  mutate(country = substring(label,1,3), target = summer_secchi) %>%
  group_by(BHI_ID, Year) %>%
  summarise(secchi = mean(secchi, na.rm = T), year = mean(Year, na.rm = T), target = max(target), HELCOM_ID = max(HELCOM_ID), country = max(country), label =max(label), basin = max(basin))

summer_secchi_opensea <-
  data2 %>%
  filter(Month %in% c(6:9), HELCOM_COASTAL_CODE <= 0) %>%
  mutate(country = substring(label,1,3), target = summer_secchi) %>%
  group_by(BHI_ID, Year) %>%
  summarise(secchi = mean(secchi, na.rm = T), year = mean(Year, na.rm = T), target = max(target), HELCOM_ID = max(HELCOM_ID), country = max(country), label =max(label), basin = max(basin))

# write.csv(summer_secchi,'~/github/BHI-issues/raw_data/ICES/summer_secchi.csv')
# write.csv(summer_secchi_opensea,'~/github/BHI-issues/raw_data/ICES/summer_secchi_opensea.csv')

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
  geom_point(data = summer_secchi_all, aes(x = year, y = secchi), color = 'green') +
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

windows()
ggplot() +
  geom_point(data = summer_secchi_all, aes(x = year, y = score, color = country)) +
  xlim(2005, 2015) +
  ylim(0,1) +
  facet_wrap(~BHI_ID, ncol = 6, drop = F)
