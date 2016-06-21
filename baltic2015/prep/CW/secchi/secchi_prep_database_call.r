## secchi_prep_database_call.r

## This file calls the data from the database and saves as a cvs in secchi_data_database

## This file should be run prior to secchi_prep.Rmd if data are updated in the database

## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')
## set additional directories
dir_cw    = file.path(dir_prep, 'CW')
dir_secchi    = file.path(dir_prep, 'CW/secchi')


## 1. access the database with MySQL()


## 2. extract data
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection

# load ICES data
t<-dbSendQuery(con, "select `secchi`, `BHI_ID`, `Month`, `Year`, `Assessment_unit`, `HELCOM_COASTAL_CODE`, `HELCOM_ID`, `Date`, `Latitude`, `Longitude`, `Cruise`, `Station` from ICES_secchi_ID_assigned;") #  where `HELCOM_COASTAL_CODE` > 0
data1<-fetch(t,n=-1) # ICES data#loads selection and assigns it to variable 'data'
dbClearResult(t) # clears selection (IMPORTANT!)
# load SMHI data
t<-dbSendQuery(con, "select `value`, `BHI_ID`, `Month`, `Year`, `unit`, `HELCOM_COASTAL_CODE`, `HELCOM_ID`, `Latitude`, `Date`, `Longitude`, `Provtagningstillfaelle.id`, `Stationsnamn` from Sharkweb_data_secchi_ID_assigned;")
data2<-fetch(t,n=-1) # SMHI data #loads selection and assigns it to variable 'data'

dbClearResult(t) # clears selection (IMPORTANT!)
dbDisconnect(con) # closes connection (IMPORTANT!)


## Save as csv file to
write.csv(data1, file.path(dir_secchi, 'secchi_data_database/ices_secchi.csv'))
write.csv(data2, file.path(dir_secchi, 'secchi_data_database/smhi_secchi.csv'))
