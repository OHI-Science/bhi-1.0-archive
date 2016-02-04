library(package = dplyr)
library(package = tidyr)
library(package = ggplot2)


#get GDP data from database
library(RMySQL)

#run your personal mysql config script to read in passcode

#connect to the BHI database
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection
dbListTables(con) # shows all tables in the DB

#fetch GPD data from database
t<-dbSendQuery(con, paste("select * from nama_10r_3gdp_ID_assigned where BHI_relevant =1;",sep="")) #BHI_relevant = 1 when geo\\time (NUTS3_ID) associated with 1 or more BHI_ID
data<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
head(data) #GPD data
dbClearResult(t) # clears selection (IMPORTANT!)
dbDisconnect(con) # closes connection (IMPORTANT!)

#data object overview and clean-up
glimpse(data)
#unique(data$unit)
#[1] "EUR_HAB"    "EUR_HAB_EU" "MIO_EUR"    "MIO_PPS"    "PPS_HAB"    "PPS_HAB_EU" #what are these different units?

#From Eurostat - info on unit of meausure from nama_10r_3gdp database page
#EUR_HAB = Euro per inhabitant
#EUR_HAB_EU = Euro per inhabitant in percentage of the EU average
#MIO_EUR = million euro
#MIO_PPS = Million Purchasing Power Standard
#PPS_HAB = Purchasing Power Standard per inhabitant
#PPS_HAB_EU = Purchasing Power Standards per inhabitant in percentage of the EU average


colnames(data)[1]="EUROSTAT_unit"  #replace geo\\time with NUTS3_ID
colnames(data)[2]="NUTS3_ID"  #replace geo\\time with NUTS3_ID

#select only GDP data, long data format, select only unit "MIO_EUR"
data.nuts3 =data %>%select(-starts_with("BHI"))%>%
  gather(YEAR,GDP, -EUROSTAT_unit, -NUTS3_ID)%>%
  mutate(GDP= replace(GDP,GDP==": ","NA"))%>%
  filter(EUROSTAT_unit=="MIO_EUR")%>%
  arrange(NUTS3_ID,YEAR)

data.nuts3 =data.nuts3%>%mutate(YEAR=as.numeric(YEAR), GDP=as.numeric(GDP))
glimpse(data.nuts3)

#Select BHI_ID Factors and NUTS3_ID, long data format, only MIO_EUR units, if factor is NA exlude because not BHI_ID & NUTS3 not associated
bhi.factor=data %>%select(EUROSTAT_unit,NUTS3_ID,starts_with("BHI"))%>%
  select(-BHI_relevant)%>%
  gather(BHI_ID,FACTOR_NUTS3,-EUROSTAT_unit, -NUTS3_ID)%>%
  filter(EUROSTAT_unit=="MIO_EUR")%>%
  filter(!is.na(FACTOR_NUTS3))%>%
  arrange(NUTS3_ID,BHI_ID)
glimpse(bhi.factor)


#join data.nuts3, bhi.factor to calculate GDP value per BHI_ID
bhi.nuts3.join = full_join(data.nuts3, bhi.factor, by=c("NUTS3_ID","EUROSTAT_unit"))

#assess number of NAS for each BHI_ID for each year - non-associated removed, so NAs only reflect missing data
bhi.na = bhi.nuts3.join%>%  group_by(BHI_ID,YEAR) %>%
  summarise(NUM_NA = sum(is.na(GDP)))%>%
  arrange(BHI_ID)%>%
  spread(key=YEAR, value=NUM_NA)
bhi.na

#any years no NAs in GDP for all BHI_ID?
bhi.na.year = bhi.nuts3.join%>%  group_by(BHI_ID,YEAR) %>%
  summarise(NUM_NA = sum(is.na(GDP)))%>%
  arrange(BHI_ID)%>%
  group_by(YEAR)%>%
  summarise(YEAR_NA=sum(NUM_NA))
bhi.na.year
#only 3 years


#calculate BHI_ID GDP, only 2010-2012 because no missing NUTS3 data

bhi.gdp= bhi.nuts3.join %>% filter(YEAR%in%c(2010,2011,2012))%>%
  group_by(BHI_ID,YEAR) %>%
  summarise(BHI_ID_GDP = sum(FACTOR_NUTS3*GDP, na.rm=TRUE)) %>%
  arrange(BHI_ID)

bhi.gdp

#bhi.gdp correct column headers
colnames(bhi.gdp)=c("rgn_id","year","gdp_mio_euro")

#write csv to layers
write.csv(bhi.gdp, "~/github/bhi/baltic2015/layers/le_gdp_bhi2015.csv", row.names = F)


#next steps - plot data, what about years where some NUTS# regions are missing data, can we fix?
