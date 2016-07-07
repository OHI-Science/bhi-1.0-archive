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
##
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
    t<-dbSendQuery(con, paste("select * from tour_occ_nin2_1_Data_ID_assigned;",sep="")) #BHI_relevant = 1 when geo\\time (NUTS3_ID) associated with 1 or more BHI_ID
    accom.data<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
    head(accom.data) #NUTS2 accommodation stays
    dbClearResult(t) # clears selection (IMPORTANT!)

    t<-dbSendQuery(con, paste("select * from tour_occ_nin2c_1_Data_ID_assigned;",sep="")) #BHI_relevant = 1 when geo\\time (NUTS3_ID) associated with 1 or more BHI_ID
    accom.coast.data<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
    head(accom.coast.data) #NUTS2 accommodation stays
    dbClearResult(t) # clears selection (IMPORTANT!)

    ##fetch BHI-NUTS attributes
    t<-dbSendQuery(con, paste("select * from AT_COAST_NUTS2_BHI_inland_25km_AT ;",sep="")) #BHI_relevant = 1 when geo\\time (NUTS3_ID) associated with 1 or more BHI_ID
    nuts2_bhi_area<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
    head(nuts2_bhi_area) #
    dbClearResult(t) # clears selection (IMPORTANT!)

    t<-dbSendQuery(con, paste("select * from AT_Pop_Density_BHI_inland_25km ;",sep="")) #BHI_relevant = 1 when geo\\time (NUTS3_ID) associated with 1 or more BHI_ID
    popdensity2005_inland<-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
    head(popdensity2005_inland) #popdensity data
    dbClearResult(t) # clears selection (IMPORTANT!)

dbDisconnect(con) # closes connection (IMPORTANT!)


##----------------------------------------------------#
## Write data to csv ##
