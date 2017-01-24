## wgi_pressure_database_call.r

## This file calls the data from the database and saves as a cvs in data_database

## This file should be run prior to wig_pressure_prep.Rmd if data are updated in the database


## Data not in database currently, 13 July 2016

##----------------------------------------------------#
## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')
## set additional directories
dir_wgi    = file.path(dir_prep, 'pressures/wgi_social')
##----------------------------------------------------#



##----------------------------------------------------#
## DATE OF LAST DATA EXTRACTION FROM DATABASE ##
## **update this date when code is run**
##
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

## Fetch data

## CLOSE CONNECTION
dbDisconnect(con) # closes connection (IMPORTANT!)

##----------------------------------------------------#



##----------------------------------------------------#
## Write data to csv ##
