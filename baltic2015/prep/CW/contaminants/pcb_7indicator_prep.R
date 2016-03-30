## 7 indicator PCBs prep

#Libraries
library(dplyr)
library(tidyr)
library(RMySQL)
library(ggplot2)

#Run individual MySQL config code



#########################################
##----------------------------##
## Get PCB data from database

con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection

t<-dbSendQuery(con, "select * from filtered_merged_pcb_ID_assigned;") #`Source`, `Country`, `Species`, `Variable`, `Value`, `Unit`, `BHI_ID`, `Date`, `Year`, `Qflag`,
data<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
dbClearResult(t) # clears selection (IMPORTANT!)
dbDisconnect(con) # closes connection (IMPORTANT!)


## Data attributes
colnames(data)
dim(data)


##NOTES

## Values for the detection limit (DETLI) and quantification limit (LMQNT) are in the original units provided by each country.
## Measured values however, have been standardized to mg/kg.  This will make it challenging to check whether
## values provided are given as simply the detection limit or the quantification limit

## Manually reviewing original data for units and detection limit levels by country
## looking in file "ICES sill original data 2015112.csc"
## LMQNT is rarely reported
## DETLI is more often reported but not always reported
## summary csv in contaminants prep folder "pcb_country_units_detli.csv"
    ## Some countries use multiple reporting units: Some countries have multiple detection limits reported for a single congener (must vary by machine by year)
    ## this csv has all congeners, units, and detli/lmqnt unique by monitoring year
## "unit_conversion_lookup.csv" created to help with different unit conversions

## Checked years 2009-2013 in original data (use this file "raw_dat_quant_detect_check.csv")
    ## Did check in excel
    ## Filtered by 2009 -2013
    ## Looked for values with QFLAG entry
    ## Looked to see if the value matched the DETLI or LMQNT value
    ## For these years, if QFLAG == '<'or 'Q' then what is entered in the value column is equal to the value
    ## given in LMQNT. if QFLAG == 'D' then the value is equal to what is entered for DETLI.
    ## This might not be true for earlier years (either detection limit not given, or value not replaced)


#################################
##------------------------#
## select limited columns, filter for years 2009-2013

data2 = data %>% select(source = Source, country=Country, station=Station,
                        bhi_id=BHI_ID,
                        lat=Latitude,lon=Longitude,
                        year=Year, date=Date, variable = Variable, qflag=QFLAG,
                        value=Value, unit=Unit, vflag =VFLAG, detli=DETLI, lmqnt=LMQNT,
                        sub_id=SUBNO,bio_id=tblBioID, samp_id=tblSampleID,num_indiv_subsamp=NOINP)%>%  #select columns, rename
        mutate(date = as.Date(date,format="%Y-%m-%d"))%>%
        filter(year %in% c(2009:2013))
head(data2)
dim(data2) #[1] 6873   19
##------------------------#
##unique variables
unique(data2$variable) #"CB101" "CB118" "CB138" "CB153" "CB180" "CB28"  "CB52"  "CB105"
##CB105 is not one of the ICES 7 variables, remove

data2 = data2 %>% filter(variable != "CB105") ;dim(data2) #6818   19

##remove location :Vaederoearna 58.51560 10.90010 -- this is on the west coast

data2 = data2 %>% filter(station!= "Vaederoearna")
dim(data2) #6400   19


##------------------------#
##unique identifiers
##number of unique bio_id
data2%>% select(bio_id)%>%distinct(bio_id)%>% nrow(.) #1142
length(unique(data2$bio_id)) #1142

##number unique samp_id
data2%>% select(samp_id)%>%distinct(samp_id)%>% nrow(.) #220

##number unique sub_id
data2%>% select(sub_id)%>%distinct(sub_id)%>% nrow(.) #517


##------------------------#
## Lookup tables
##location lookup
loc_lookup = data2 %>% select(country,bhi_id,station,lat,lon)%>%
  distinct(.)
loc_lookup
## Two swedish sites without BHI-ID
    ## Vaederoearna 58.51560 10.90010 -- this is on the west coast, this has now been removed above
    ## Storfjaerden       NA       NA  -- quick IVL search indicates is near Piteå -- Have email the IVL database manager for lat-lon
        ##is sampled on 2 dates (between 2009-2013)

##country/bhi_id/bio_id/lat/long/station
id_lookup = data2 %>% select(country,bhi_id,station,bio_id)%>%
            distinct(.)%>%
            arrange(bio_id) %>%
            mutate(new_id = seq(1,length(bio_id))) #create new ID value that is numeric is paired with ICES/IVL ID
head(id_lookup)


##------------------------#
## spread data - so congeners across columns

data3 = data2 %>% right_join(.,id_lookup, by="bio_id")%>% #join with bio_id
  select(new_id,date,variable,value)%>%
        spread(.,variable, value )%>%
        arrange(new_id)
head(data3)  #not all congeners measured for each bio_id

nrow(data3) #1142

##gather data again to long format for plotting
data3=data3 %>% gather(key= variable, value = value ,CB101,CB118,CB138,CB153,CB180,CB28,CB52, na.rm=FALSE )%>%
      arrange(new_id,variable)

## plot by bio_id
windows()
ggplot(data3) + geom_point(aes(new_id, value,colour=variable))

##join data3 with country data and explore conger measurements by country
data4 = data3 %>% full_join(.,id_lookup, by="new_id")

windows()
ggplot(data4) + geom_point(aes(new_id, value, colour=variable))+
  facet_wrap(~country)

windows()
ggplot(data4) + geom_point(aes(new_id, value))+
  facet_wrap(~variable+country)

    ## German values very high for a few congeners (CB138, CB153)
    ## need to check closer to see if multiple measurement for the same sample ID

windows()
ggplot(filter(data4, country=="Germany" & new_id < 200)) + geom_point(aes(new_id, value))+
  facet_wrap(~variable)
data4 %>% filter(country=="Germany" & new_id < 200)%>%
    spread(variable, value)
    ## data are multiple new_id/bio_id but many samples per station & data - as would expect
    ##  different combos of congeners measured for different bio_ids at the same station and date


## how many individuals sampled in different samples
data5 = data4 %>% left_join(.,select(data2,bio_id,num_indiv_subsamp), by="bio_id")
head(data5)

windows()
ggplot(distinct(data5,new_id)) + geom_point(aes(new_id, num_indiv_subsamp))+
  facet_wrap(~country)
    ##need to investigate Swedish data - some id's with many individuals pooled

  data5 %>% filter(country=="Sweden" & num_indiv_subsamp > 1)



## Data steps
## need a final concentration value for each congener
    ## if congener was at the detection or quantification limit, need to adjust value
    ## if value given is detli, recommendation is adj_value = detect lim value / 2
    ## if value given is lmqnt,recommendation is adj_value = quant lim value / sqrt(2)

## Need to sum 7 PCB congeners within in a fih

## inspect data variation within a BHI region and data coverage

## average/median value of samples taken within a BHI region

## gap-filling or data smoothing decisions
