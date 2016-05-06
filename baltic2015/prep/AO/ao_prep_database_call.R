## ao_prep_database_call.r

## This file calls the data from the database and saves as a cvs in secchi_data_database

## This file should be run prior to secchi_prep.Rmd if data are updated in the database

## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')
## set additional directories
dir_ao    = file.path(dir_prep, 'AO')


## TO DO When data are in the database

## 1. access the database with MySQL()


## 2. extract data

## NEED ao_coastalfish_ges_status, coastalfish_loc, ao_cpue_slope
