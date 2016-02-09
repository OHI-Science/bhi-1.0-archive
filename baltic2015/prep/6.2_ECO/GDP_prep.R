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
glimpse(bhi.nuts3.join)


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
#only 3 years with no NaA

#get NUTS3_ID which have NAS 2000-2009
nuts3.na.names=bhi.nuts3.join%>% filter(YEAR>=2000 & YEAR <=2012)%>%
  group_by(NUTS3_ID) %>%
  summarise(NUM_NA = sum(is.na(GDP)))%>%
  filter(NUM_NA!=0)
nuts3.na.names




#####calculate BHI_ID GDP, only 2010-2012 because no missing NUTS3 data#####

bhi.gdp= bhi.nuts3.join %>% filter(YEAR%in%c(2010,2011,2012))%>%
  group_by(BHI_ID,YEAR) %>%
  summarise(BHI_ID_GDP = sum(FACTOR_NUTS3*GDP, na.rm=TRUE)) %>%
  arrange(BHI_ID)

bhi.gdp

#bhi.gdp correct column headers
colnames(bhi.gdp)=c("rgn_id","year","gdp_mio_euro")

#write csv to layers
write.csv(bhi.gdp, "~/github/bhi/baltic2015/layers/le_gdp_bhi2015.csv", row.names = F)


###TESTS / EXPLORARTORY ###
#calculate BHI_ID GDP, for subset of BHI_ID (no missing years of data) 2000-2012
#use for testing the scores
#will export csv only to prep folder

#get BHI_ID which do not have NAs, restrict to before 2013
bhi.no.na.names=bhi.nuts3.join%>% filter(YEAR<2013)%>%
  group_by(BHI_ID) %>%
  summarise(NUM_NA = sum(is.na(GDP)))%>%
  filter(NUM_NA==0)
bhi.no.na.names

bhi.gdp.temp= bhi.nuts3.join %>% filter(YEAR<2013)%>%
  filter(BHI_ID%in% bhi.no.na.names$BHI_ID)%>%
  group_by(BHI_ID,YEAR) %>%
  summarise(BHI_ID_GDP = sum(FACTOR_NUTS3*GDP, na.rm=TRUE)) %>%
  arrange(BHI_ID)

bhi.gdp.temp
#bhi.gdp correct column headers
colnames(bhi.gdp.temp)=c("rgn_id","year","gdp_mio_euro")

#write to csv in prep folder
write.csv(bhi.gdp.temp, "~/github/bhi/baltic2015/prep/6.2_ECO/le_gdp_tempbhi2015.csv", row.names = F)

##---##
#Test ECO status, trend calc


head(bhi.gdp.temp)


le_gdp=read.csv("~/github/bhi/baltic2015/prep/6.2_ECO/le_gdp_tempbhi2015.csv")
head(le_gdp)

#from Functions.r
# ECO calculations ----
eco = le_gdp %>%
  mutate(
    rev_adj =gdp_mio_euro,
    sector = 'gdp') %>%
  # adjust rev with national GDP rates if available. Example: (rev_adj = gdp_usd / ntl_gdp)
  select(rgn_id, year, sector, rev_adj)
eco

# ECO status
eco_status = eco %>%
  filter(!is.na(rev_adj)) %>%
  filter(year >= max(year, na.rm=T) - 4) %>% # reference point is 5 years ago
  # across sectors, revenue is summed
  group_by(rgn_id, year) %>%
  summarize(
    rev_sum  = sum(rev_adj, na.rm=T)) %>%
  # reference for revenue [e]: value in the current year (or most recent year) [c], relative to the value in a recent moving reference period [r] defined as 5 years prior to [c]
  arrange(rgn_id, year) %>%
  group_by(rgn_id) %>%
  mutate(
    rev_sum_first  = first(rev_sum)) %>%
  # calculate final scores
  ungroup() %>%
  mutate(
    score  = pmin(rev_sum / rev_sum_first, 1) * 100) %>%
  # get most recent year
  filter(year == max(year, na.rm=T)) %>%
  # format
  mutate(
    goal      = 'ECO',
    dimension = 'status') %>%
  select(
    goal, dimension,
    region_id = rgn_id,
    score)
eco_status

# ECO trend
eco_trend = eco %>%
  filter(!is.na(rev_adj)) %>%
  filter(year >= max(year, na.rm=T) - 4 ) %>% # 5 year trend
  # get sector weight as total revenue across years for given region
  arrange(rgn_id, year, sector) %>%
  group_by(rgn_id, sector) %>%
  mutate(
    weight = sum(rev_adj, na.rm=T)) %>%
  # get linear model coefficient per region-sector
  group_by(rgn_id, sector, weight) %>%
  do(mdl = lm(rev_adj ~ year, data=.)) %>%
  summarize(
    weight = weight,
    rgn_id = rgn_id,
    sector = sector,
    # TODO: consider how the units affect trend; should these be normalized? cap per sector or later?
    sector_trend = pmax(-1, pmin(1, coef(mdl)[['year']] * 5))) %>%
  # get weighted mean across sectors per region
  group_by(rgn_id) %>%
  summarize(
    score = weighted.mean(sector_trend, weight, na.rm=T)) %>%
  # format
  mutate(
    goal      = 'ECO',
    dimension = 'trend') %>%
  select(
    goal, dimension,
    region_id = rgn_id,
    score)

eco_trend




##########


#plot data, what about years where some NUTS# regions are missing data, can we fix?
#Plot MIO data by year by NUTS3 to assess what is missing
#use bhi.nuts3.join because only includs NUTS3 beloning to a BHI_ID
unique(bhi.nuts3.join$NUTS3_ID) #81 unique NUTS3 regions

#plot each BHI_ID, plot for each all NUTS3
bhi.id = sort(unique(bhi.nuts3.join$BHI_ID))
windows(40,20)
par(mfrow=c(5,8), mar=c(2,2,1,.5),oma=c(2,2,2,2))
for(ID in bhi.id){
  bhi.nuts3.join%>%filter(BHI_ID==ID)%>%
    group_by(NUTS3_ID)%>%
    arrange(YEAR)%>%
    with(plot(GDP~YEAR, type='p',pch=19, col="gray",
              xlim=c(2000,2013),main=ID))
   }






