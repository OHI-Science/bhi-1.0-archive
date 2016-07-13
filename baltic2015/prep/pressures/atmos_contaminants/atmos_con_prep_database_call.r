## atmos_con_prep_database_call.r

## This file calls the data from the database and saves as a cvs in eco_data_database

## This file should be run prior to eco_prep.Rmd if data are updated in the database


##----------------------------------------------------#
## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')
## set additional directories
dir_atmos_con    = file.path(dir_prep, 'pressures/atmos_contaminants')
##----------------------------------------------------#



##----------------------------------------------------#
## DATE OF LAST DATA EXTRACTION FROM DATABASE ##
## **update this date when code is run**
## 13 JULY 2016
#----------------------------------------------------#


##----------------------------------------------------#
## Get GDP data from database ##

## library(RMySQL) # required


## STEP 1:
##run your personal mysql config script to read in passcode


## STEP 2:
## Connect to the BHI database
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_0",host=conf[,3], port=3306) # sets up the connection
dbListTables(con) # shows all tables in the DB

##PCB 153 deposition
t<-dbSendQuery(con, paste("select * from PCB_153_deposition_data_cleaned_by_JRG_data;",sep=""))
pcb153 <-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
head(pcb153)
tail(pcb153)
dbClearResult(t) # clears selection (IMPORTANT!)


## PCDDF
t<-dbSendQuery(con, paste("select * from PCDDF_deposition_data_BSEFS2014_cleaned_by_JRG_data;",sep=""))
pcddf <-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
head(pcddf )
tail(pcddf )
dbClearResult(t) # clears selection (IMPORTANT!)

## CLOSE CONNECTION
dbDisconnect(con) # closes connection (IMPORTANT!)



## Reconnect to the metafile level
con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="metafiles",host=conf[,3], port=3306) # sets up the connection
dbListTables(con) # shows all tables in the DB

## Basin lookup
t<-dbSendQuery(con, paste("select * from atmos_loading_basin_lookup;",sep=""))
atmos_loading_basin_lookup <-fetch(t,n=-1) # loads selection and assigns it to variable 'data'
head(atmos_loading_basin_lookup )
tail(atmos_loading_basin_lookup)
dbClearResult(t) # clears selection (IMPORTANT!)





## CLOSE CONNECTION
dbDisconnect(con) # closes connection (IMPORTANT!)

##----------------------------------------------------#


##----------------------------------------------------#
## CORRECT data objects

## currently database typo in object pcb153 in column substance (all entries should be pcb153)
pcb153 = pcb153  %>%
         mutate(substance = "PCB 153")



##----------------------------------------------------#
## Write data to csv ##
write.csv(pcb153, file.path(dir_atmos_con, "data_database/pcb153.csv"),row.names = FALSE)
write.csv(pcddf, file.path(dir_atmos_con, "data_database/pcddf.csv"),row.names = FALSE)
write.csv(atmos_loading_basin_lookup, file.path(dir_atmos_con, "data_database/atmos_loading_basin_lookup.csv"),row.names = FALSE)
