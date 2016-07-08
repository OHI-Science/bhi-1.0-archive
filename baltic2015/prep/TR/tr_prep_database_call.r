## tr_prep_database_call.r

## This file calls the data from the database and saves as a cvs in tr_data_database

## This file should be run prior to tr_prep.Rmd if data are updated in the database


##----------------------------------------------------#
## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')
## set additional directories
dir_tr    = file.path(dir_prep, 'TR')
##----------------------------------------------------#


##----------------------------------------------------#
## DATE OF LAST DATA EXTRACTION FROM DATABASE ##
## **update this date when code is run**
## 8 JULY 2016
##----------------------------------------------------#


##----------------------------------------------------#
## Get GDP data from database ##

## library(RMySQL) # required


## STEP 1:
##run your personal mysql config script to read in passcode


## STEP 2:
## Connect to the BHI database

con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection
dbListTables(con) # shows all tables in the DB

    ##fetch accommodation stays data from database
    t<-dbSendQuery(con, paste("select * from tour_occ_nin2_1_Data_ID_assigned;",sep=""))
    accom<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
    head(accom) #NUTS2 accommodation stays
    dbClearResult(t) # clears selection (IMPORTANT!)

    t<-dbSendQuery(con, paste("select * from tour_occ_nin2c_1_Data_ID_assigned;",sep=""))
    accom_coast<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
    head(accom_coast) #NUTS2 accommodation stays
    dbClearResult(t) # clears selection (IMPORTANT!)

    ##fetch NUTS2 population and area by BHI regions
    t<-dbSendQuery(con, paste("select * from NUTS2_BHI_ID_Pop_density_in_buffer;",sep=""))
    nuts2_pop_area <-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
    head(nuts2_pop_area) #
    dbClearResult(t) # clears selection (IMPORTANT!)


dbDisconnect(con) # closes connection (IMPORTANT!)


##----------------------------------------------------#
## Write data to csv ##
write.csv(accom, file.path(dir_tr, "tr_data_database/accom.csv"),row.names = FALSE)
write.csv(accom_coast, file.path(dir_tr, "tr_data_database/accom_coast.csv"),row.names = FALSE)
write.csv(nuts2_pop_area, file.path(dir_tr, "tr_data_database/nuts2_pop_area.csv"),row.names = FALSE)
