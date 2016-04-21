##-------------------------------------------##
## FILE: contaminants_prep_database_call.r
##-------------------------------------------##

##-------------------------------------------##
## READ ME:
## This file calls the data from the database and saves as a cvs in contaminants_data_database
## This file should be run prior to contaminants_prep.Rmd if data are updated in the database
## In this file, both "filtered" data from the database (level 1 ) and "unfiltered" data (database level 2)
## are extracted.  "Filtered" means that Marc tried to eliminate duplicates between ICES and IVL
## To do this he looked for unique station, year, and value.  (because some early samples on have year, not full date)
## It appears that there are still duplicates, however.

##-------------------------------------------##
## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')
## set additional directories
dir_cw    = file.path(dir_prep, 'CW')
dir_con    = file.path(dir_prep, 'CW/contaminants')


##-------------------------------------------##
## Extract "unfiltered data" from database level 0
    ## has no BHI ID
##-------------------------------------------##
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_0",host=conf[,3], port=3306) # sets up the connection

t<-dbSendQuery(con, "select * from ICES_pcb_unfiltered;") #`Source`, `Country`, `Species`, `Variable`, `Value`, `Unit`, `BHI_ID`, `Date`, `Year`, `Qflag`,
data1 <-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
dbClearResult(t) # clears selection (IMPORTANT!)

t<-dbSendQuery(con, "select * from IVL_pcb_unfiltered;") #`Source`, `Country`, `Species`, `Variable`, `Value`, `Unit`, `BHI_ID`, `Date`, `Year`, `Qflag`,
data2 <-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
dbClearResult(t) # clears selection (IMPORTANT!)

dbDisconnect(con) # closes connection (IMPORTANT!)


ices_unfilter = data1 %>% select(source = Source, country=Country, station=Station,
                lat=Latitude,lon=Longitude,
                year=Year, date=Date, variable = Variable, qflag=QFLAG,
                value=Value, unit=Unit, vflag =VFLAG, detli=DETLI, lmqnt=LMQNT,
                sub_id=SUBNO,bio_id=tblBioID,
                samp_id=tblSampleID,num_indiv_subsamp=NOINP)  #select columns, rename


ivl_unfilter = data2 %>% select(source = Source, country=Country, station=Station,
                               lat=Latitude,lon=Longitude,
                               year=Year, date=Date, variable = Variable, qflag=QFLAG,
                               value=Value, unit=Unit, vflag =VFLAG, detli=DETLI, lmqnt=LMQNT,
                               sub_id=SUBNO,bio_id=tblBioID,
                               samp_id=tblSampleID,num_indiv_subsamp=NOINP)  #select columns, rename

data1=c()
data2=c()


## Save as csv file to
readr::write_csv(ices_unfilter, file.path(dir_con, 'contaminants_data_database/ices_unfilter.csv'))
readr::write_csv(ivl_unfilter, file.path(dir_con, 'contaminants_data_database/ivl_unfilter.csv'))




##-------------------------------------------##
## Extract "filtered data" from database level 1
##-------------------------------------------##
## 1. access the database with MySQL()


## 2. extract data


## Get PCB data from database

con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection

t<-dbSendQuery(con, "select * from filtered_merged_pcb_ID_assigned;") #`Source`, `Country`, `Species`, `Variable`, `Value`, `Unit`, `BHI_ID`, `Date`, `Year`, `Qflag`,
data <-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
dbClearResult(t) # clears selection (IMPORTANT!)
dbDisconnect(con) # closes connection (IMPORTANT!)


## Preliminary data cleaning prior to writing csv
data2 = data %>% select(source = Source, country=Country, station=Station,
                        bhi_id=BHI_ID,
                        lat=Latitude,lon=Longitude,
                        year=Year, date=Date, variable = Variable, qflag=QFLAG,
                        value=Value, unit=Unit, vflag =VFLAG, detli=DETLI, lmqnt=LMQNT,
                        sub_id=SUBNO,bio_id=tblBioID,
                        samp_id=tblSampleID,num_indiv_subsamp=NOINP)%>%  #select columns, rename
                mutate(date = as.Date(date,format="%Y-%m-%d"))
dim(data2)
str(data2)


pcb_data=data2

## Save as csv file to
readr::write_csv(pcb_data, file.path(dir_con, 'contaminants_data_database/pcb_data_filter.csv'))


