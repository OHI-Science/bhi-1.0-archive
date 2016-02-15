# rm(list = ls())

library(dplyr)
library(tidyr)
library(RMySQL)
library(ggplot2)

# --------------

#run your personal mysql config script to read in passcode

### MySQL commands
### IMPORTANT: whenever you open a MySQL connection with 'dbConnect' make sure that you close it directly after your querry!!!
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection

t<-dbSendQuery(con, "select * from filtered_merged_pcb_ID_assigned;") #`Source`, `Country`, `Species`, `Variable`, `Value`, `Unit`, `BHI_ID`, `Date`, `Year`, `Qflag`,
data<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
dbClearResult(t) # clears selection (IMPORTANT!)
dbDisconnect(con) # closes connection (IMPORTANT!)

# set date format, filter and select columns
pcb = data %>%
  mutate(Date2 = as.Date(Date, "%Y-%m-%d")) %>%
  # filter(Year > 2000) %>%
  select(Source, Country, Station, Year, Date2, BHI_ID, Species, Variable, Value, Unit, TEF.adjusted.value)

# write.csv(pcb, "~/github/bhi/baltic2015/prep/8_CW/pcb_temp.csv", row.names = F)

#### Plot to check data ####
# NOTES and QUESTIONS:
# High reported PCB values from ICES for BHI_ID 17 (Poland), can not be correct in relation to other data
# Incomplete data coverage, most data are from Swedish or Finish waters
# How do we work with the different CBXX variables, should they be summed?

unique(pcb$Variable)

windows()
pcb %>% #filter(Source == "ICES") %>% #!grepl('P', Variable),
ggplot() +
  aes(x = Date2, y = Value, colour = Variable, shape = Unit) +
  geom_point() +
  facet_wrap(~BHI_ID, scales = "free_y")

windows()
pcb %>%
  ggplot() +
  aes(x = Date2, y = Value, colour = as.factor(BHI_ID), shape = Unit) +
  geom_point() +
  facet_wrap(~Variable, scales = "free_y")

windows()
pcb %>% filter(!is.na(TEF.adjusted.value), Year >= 2000) %>%
  ggplot() +
  aes(x = Date2, y = TEF.adjusted.value, colour = Country) +
  geom_point() +
  facet_wrap(~BHI_ID) #, scales = "free_y")


