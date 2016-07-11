## liv_prep_database_call.r

## This file calls the data from the database and saves as a cvs in liv_data_database

## This file should be run prior to liv_prep.Rmd if data are updated in the database


##----------------------------------------------------#

## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')
## set additional directories

dir_liv    = file.path(dir_prep, 'LIV')


##----------------------------------------------------#
## DATE OF LAST DATA EXTRACTION FROM DATABASE ##
## **update this date when code is run**
## 11 JULY 2016  **Note, when these data were downloaded, employment data not joined to shapefile info, so download area and population info separately
## Note, two data files are not yet in the database, these were manually put as csv files in "eco_data_database"
  ## File names are: 'demo_gind_1_Data_cleaned.csv' which is national population size & 'naida_10_pe_1_Data_cleaned.csv' which is russia national population size and national employment

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


    ##Fetch NUTS2 Employment data
    t<-dbSendQuery(con, paste("select * from lfst_r_lfe2emprt_1_Data_NUTS2_cleaned;",sep=""))
    nuts2_employ <-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
    head(nuts2_employ)
    tail(nuts2_employ)
    dbClearResult(t) # clears selection (IMPORTANT!)


    ##Fetch NUTS2 Employment data
    t<-dbSendQuery(con, paste("select * from lfst_r_lfe2emprt_1_Data_NUTS0_cleaned;",sep=""))
    nuts0_employ <-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
    head(nuts0_employ)
    tail(nuts0_employ)
    dbClearResult(t) # clears selection (IMPORTANT!)

    ##fetch NUTS2 population and area by BHI regions
    t<-dbSendQuery(con, paste("select * from NUTS2_BHI_ID_Pop_density_in_buffer;",sep=""))
    nuts2_pop_area <-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
    head(nuts2_pop_area) #
    dbClearResult(t) # clears selection (IMPORTANT!)

    ## CLOSE CONNECTION
    dbDisconnect(con) # closes connection (IMPORTANT!)

##----------------------------------------------------#
## Write data to csv ##
write.csv(nuts2_employ, file.path(dir_liv, "liv_data_database/nuts2_employ.csv"),row.names = FALSE)
write.csv(nuts0_employ, file.path(dir_liv, "liv_data_database/nuts0_employ.csv"),row.names = FALSE)
write.csv(nuts2_pop_area, file.path(dir_liv, "liv_data_database/nuts2_pop_area.csv"),row.names = FALSE)
