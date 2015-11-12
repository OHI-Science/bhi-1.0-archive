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
data <- data %>%
  mutate(country = paste(substring(Assessment_unit, 1, 3)))

summer_secchi <-
  data %>%
  filter(Month %in% c(6:9), HELCOM_COASTAL_CODE > 0) %>%
  mutate(country = paste(substring(Assessment_unit, 1, 3))) %>%
  group_by(BHI_ID) %>%
  summarise(secchi = mean(secchi, na.rm = T), year = mean(Year, na.rm = T), country =max(country)) %>%
#   filter(grepl("DEN|SWE|FIN|GER|POL|RUS|LIT|LAT|EST", HELCOM_ID)) %>%



windows()
ggplot(summer_secchi) +
  geom_point(aes(x = year, y = secchi, color = country)) +
  geom_point(data = filter(data, HELCOM_COASTAL_CODE > 0), aes(x = Year, y = secchi, color = country)) +
  xlim(1995, 2015) +
  facet_wrap(~BHI_ID)
