##-------------------------------------------##
## FILE: contaminants_prep_database_call.r
##-------------------------------------------##

##-------------------------------------------##
## READ ME:
## This file calls the data from the database and saves as a cvs in contaminants_data_database
## This file should be run prior to contaminants_prep.Rmd if data are updated in the database

##-------------------------------------------##
## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')
## set additional directories
dir_cw    = file.path(dir_prep, 'CW')
dir_con    = file.path(dir_prep, 'CW/contaminants')



##----------------------------------------------------#
## DATE OF LAST DATA EXTRACTION FROM DATABASE ##
## **update this date when code is run**
## 13 JULY 2016
##----------------------------------------------------#



##-------------------------------------------##
## Extract ICES pcb herring data from database


## library(RMySQL) # required


## STEP 1:
##run your personal mysql config script to read in passcode


## STEP 2:
## Connect to the BHI database

con<-dbConnect(MySQL(),user=conf[,1],password=conf[,2],dbname="BHI_level_1",host=conf[,3], port=3306) # sets up the connection
dbListTables(con) # shows all tables in the DB

## Fetch ICES herring PCB data
t<-dbSendQuery(con, "select * from ICES_herring_pcb_cleaned_ID_assigned;")
ices_herring_pcb <-fetch(t,n=-1)
head(ices_herring_pcb)
tail(ices_herring_pcb)

dbClearResult(t) # clears selection (IMPORTANT!)

## Fetch ICES herring dioxin data
t<-dbSendQuery(con, "select * from ICES_herring_dioxins_cleaned_ID_assigned;")
ices_herring_dioxin <-fetch(t,n=-1)
head(ices_herring_dioxin)
tail(ices_herring_dixon)



dbDisconnect(con) # closes connection (IMPORTANT!)
##----------------------------------------------------#


##----------------------------------------------------#
## Write data to csv ##
write.csv(ices_herring_pcb, file.path(dir_con, 'contaminants_data_database/ices_herring_pcb.csv'), row.names=FALSE)

write.csv(ices_herring_dioxin, file.path(dir_con, 'contaminants_data_database/ices_herring_dioxin.csv'), row.names =FALSE)
##----------------------------------------------------#

