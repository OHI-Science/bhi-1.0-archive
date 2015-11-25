library(package = dplyr)
library(package = tidyr)
library(RMySQL)
library(ggplot2)

conf<-read.csv("~/Jobb/BHI/Data and goal descriptions/mysql_conf lena.txt")
conf<-as.matrix(conf)

con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI",host=conf[,3], port=3306)
t<-dbSendQuery(con, "select `secchi`, `BHI_ID`, `Month`, `Year`, `Assessment_unit`, `HELCOM_COASTAL_CODE`, `HELCOM_ID` from ICES_secchi_ID_assigned  where `HELCOM_COASTAL_CODE` > 0;")
data<-fetch(t,n=-1)
dbClearResult(t)


# Load secchi data from database data <- (call to server)
# secchi <- read.table(file = '~/github/BHI-issues/raw_data/ICES/ICES_secchi.csv', header = T, sep = ",")
# data<- secchi %>%
#   mutate(date =  as.Date(yyyy.mm.ddThh.mm), month = as.numeric(format(date, "%m"))) %>%
#   rename(basin = Assessment.Unit.METAVAR.TEXT)
rgn_id <- read.table(file = "~/github/bhi/baltic2015/layers/rgn_global_gl2014.csv", header = TRUE, sep = ",", stringsAsFactors = F)
rgn_id <- rename(rgn_id, BHI_ID = rgn_id)

data <- data %>%
  mutate(country = paste(substring(Assessment_unit, 1, 3)))

summer_secchi <-
  data %>%
  filter(Month %in% c(6:9), HELCOM_COASTAL_CODE > 0) %>%
  mutate(country = paste(substring(Assessment_unit, 1, 3))) %>%
  group_by(BHI_ID, Year) %>%
  summarise(secchi = mean(secchi, na.rm = T), year = mean(Year, na.rm = T), country =max(country))

summer_secchi_opensea <-
  data %>%
  filter(Month %in% c(6:9), HELCOM_COASTAL_CODE <= 0) %>%
  group_by(BHI_ID, Year) %>%
  summarise(secchi = mean(secchi, na.rm = T), year = mean(Year, na.rm = T), HELCOM_ID =max(HELCOM_ID))

# write.csv(summer_secchi,'~/github/BHI-issues/raw_data/ICES/summer_secchi.csv')
# write.csv(summer_secchi_opensea,'~/github/BHI-issues/raw_data/ICES/summer_secchi_opensea.csv')

windows()
ggplot(summer_secchi) +
  geom_point(aes(x = year, y = secchi, color = country)) +
#   geom_point(data = filter(data, HELCOM_COASTAL_CODE > 0), aes(x = Year, y = secchi, color = country)) +
  xlim(1995, 2015) +
  facet_wrap(~BHI_ID) +
  ggtitle("Coastal areas")

windows()
ggplot() +
  geom_point(data = summer_secchi_opensea, aes(x = year, y = secchi), color = 'blue') +
  geom_point(data = summer_secchi, aes(x = year, y = secchi), color = 'red') +
  xlim(1995, 2015) +
  facet_wrap(~BHI_ID)
