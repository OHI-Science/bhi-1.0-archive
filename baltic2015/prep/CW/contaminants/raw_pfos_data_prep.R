#----------------------------------------##
## FILE:  raw_pfos_data_prep.r
##----------------------------------------##

## This file is to prep raw PFOS data from ICES so there will be consistent data for the database at level 1

##----------------------------------------##
## LIBRARIES

library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(RMySQL)
library(stringr)
library(tools)
library(rprojroot)

##----------------------------------------##
##FILE PATHS
## rprojroot
root <- rprojroot::is_rstudio_project

## make_path() function to
make_path <- function(...) rprojroot::find_root_file(..., criterion = is_rstudio_project)

dir_layers = make_path('baltic2015/layers') # replaces  file.path(dir_baltic, 'layers')

source('~/github/bhi/baltic2015/prep/common.r')
dir_cw    = file.path(dir_prep, 'CW')
dir_con    = file.path(dir_prep, 'CW/contaminants')



##----------------------------------------##
## Read in ICES data
##----------------------------------------##
ices_raw = read.csv(file.path(dir_con, '/raw_prep/ices_herring_pfos_download_17_july_2016_cleaned.csv'),
                    sep=";")
head (ices_raw)
dim(ices_raw)
str(ices_raw)

##----------------------------------------##
## Read in unit conversion lookup
##----------------------------------------##
unit_lookup = read.csv(file.path(dir_con,'unit_conversion_lookup.csv'),sep=";")
unit_lookup

#----------------------------------------##
## ICES Check number of dates and years sample by country
##----------------------------------------##

ices_country_year = ices_raw %>%
  select(Country,year) %>%
  distinct(.) %>%
  arrange(Country,year)
ices_country_year

## get last year for each country
ices_country_year %>% group_by(Country) %>% summarise(last(year)) %>% ungroup()


##----------------------------------------##
## ICES data cleaning and manipulations
##----------------------------------------##
##----------------------------------------##
## ICES change column names
## ICES column name descriptor(http://dome.ices.dk/Download/Contaminants%20and%20effects%20of%20contaminants%20in%20biota.pdf)
##----------------------------------------##

ices1 = ices_raw %>% dplyr::rename(monit_program =MPROG, monit_purpose = PURPM,
                                   country=Country, report_institute =RLABO,
                                   station=STATN, monit_year=MYEAR, date_ices =icesDATE,
                                   ##day=day, month=month,## add these back in when data in database
                                   year=year,date=Date,
                                   latitude=Latitude, longitude = Longitude,
                                   species=Species, sex_specimen=SEXCO,num_indiv_subsample=NOINP,
                                   matrix_analyzed=MATRX,not_used_in_datatype=NODIS,
                                   param_group=PARGROUP,variable=PARAM, basis_determination=BASIS, qflag=QFLAG,
                                   value=Value,unit = MUNIT, vflag=VFLAG, detect_lim = DETLI,
                                   quant_lim = LMQNT, uncert_val = UNCRT, method_uncert=METCU,
                                   analyt_lab=ALABO, ref_source = REFSK, method_storage =METST,
                                   method_pretreat = METPT,method_pur_sep = METPS, method_chem_fix= METFP,
                                   method_chem_extract =METCX,method_analysis =METOA, formula_calc=FORML,
                                   test_organism=Test.Organism, sampler_type =SMTYP, sub_samp_id =SUBNO,
                                   bulk_id = BULKID, factor_compli_interp = FINFL,
                                   analyt_method_id = tblAnalysisID, measurement_ref = tblParamID,
                                   sub_samp_ref = tblBioID, samp_id= tblSampleID)

colnames(ices1)

##Key columns
##basis_determination : L = lipid weight, D=dry weight, W = wet weight

## Improve clarity of column content

ices2 = ices1 %>%
  mutate(basis_determination = ifelse(basis_determination =="L", "lipid weight",
                                      ifelse(basis_determination =="W", "wet weight",
                                             ifelse(basis_determination =="D", "dry weight",""))),
         matrix_analyzed = ifelse(matrix_analyzed =="LI", "liver",
                                  ifelse(matrix_analyzed =="MU", "muscle",
                                         ifelse(matrix_analyzed =="WO", "whole organism",""))))

## which ids are most unique
length(unique(ices2$sub_samp_id)) #757
length(unique(ices2$bulk_id)) #1
length(unique(ices2$sub_samp_ref)) #799
length(unique(ices2$samp_id)) #113
length(unique(ices2$measurement_ref)) #5807

##----------------------------------------##
## ICES restrict data to >= 2000
##----------------------------------------##
ices3 = ices2 %>% filter(year >= 2000)
dim(ices2); dim(ices3)
## do even though data no earlier than 2005

##----------------------------------------##
## ICES parameters & conversion
## lipid v. weight weight, units
##----------------------------------------##


##What are the specific parameters
##unique parameter groups and associated variables
ices3 %>% select(param_group,variable) %>% distinct(.) %>% arrange(param_group, variable)
##O-FL contains multiple compounds:  PFOS, PFOA,PFDOA, PFBS,PFHpA,PFHXS,PFHxA

##B-BIO is age, length, weight, % fat. % lipids

## which samples are not muscle or whole organism?
ices3 %>% select(param_group,variable, matrix_analyzed) %>% distinct(.) %>% arrange(param_group, variable, matrix_analyzed)
##DRYWT% and EXLIP% have been measured for both muscle and liver
## all of the compounds except PFOS measured only in the liver. We will not use these compounds anyway.
## PFOS measured in both muscle and liver

## how many PFOS muscle obs
ices3 %>%
  select(param_group,variable, matrix_analyzed,value) %>%
  filter(variable == 'PFOS' & matrix_analyzed == 'muscle') %>%
  nrow()## 24 observations

## how many PFOS liver obs
ices3 %>%
  select(param_group,variable, matrix_analyzed,value) %>%
  filter(variable == 'PFOS' & matrix_analyzed == 'liver') %>%
  nrow()## 213 observations


## exclude liver matrix samples
dim(ices3) # 5807   45
ices3 = ices3 %>%
  filter(matrix_analyzed !="liver") ## remove samples for liver tissue, keep muscle and whole organism (this is for length, weight)
dim(ices3) #3687   45

## check, any observations do not have sub_samp_ref?
ices3 %>% filter(is.na(sub_samp_ref))  ## all observations have a subsample ref

ices3 %>% filter(vflag !="A") %>% select(vflag) %>%distinct(.)  ## A = acceptable, all others are blank, no problems


##----------------------------------------##
##----------------------------------------##
## ICES separate data into 3 objects
##----------------------------------------##

##----------------------------------------##
## Look-up methods
ices_lookup= ices3 %>%
  select(c(monit_program:not_used_in_datatype,analyt_lab:samp_id, param_group,variable,basis_determination,qflag,detect_lim,quant_lim,uncert_val,method_uncert))
str(ices_lookup)

##save ices lookup
#write.csv(ices_lookup, file.path(dir_con, 'raw_prep/ices_pfos_lookup_unique_measurements.csv'))

##----------------------------------------##
## b-bio data
## These data are length, weight, fat and lipid content
##----------------------------------------##
ices3_bbio = ices3 %>%
  select(c(station,latitude,longitude,date,sub_samp_ref,sub_samp_id,samp_id,param_group,matrix_analyzed,basis_determination,variable,unit,value))%>% ## reorder columns, identifiers first, only variables and values
  filter(param_group == "B-BIO") %>% ## select only B-BIO
  mutate(variable = paste(variable,unit,sep="_"))  %>%  #combine variable with measurement unit
  select(-unit)%>% ## no longer needed
  arrange(station,date,sub_samp_ref)

## ANY DUPLICATE PROBLEMS (data year >= 2000)
dim(ices3_bbio) #3663   12
ices3_bbio %>% select(-value)%>% distinct(.) %>% nrow()#23639  ## duplicate rows

## Duplicated sub_samp_ref IDs
duplicated_1 = ices3_bbio %>% group_by(station,date,sub_samp_ref,variable)%>%summarise(n=n()) %>% ungroup() %>% filter(n>1) %>% select(sub_samp_ref) %>% distinct(.)

dim(duplicated_1)  #24 total duplicated IDs
duplicated_1 = duplicated_1$sub_samp_ref

# explore duplicates in ices3
## duplicated records
duplicated_1_records = ices3 %>%
  filter(sub_samp_ref %in% duplicated_1) %>%
  select(country,date,matrix_analyzed,sub_samp_ref,sub_samp_id,measurement_ref, param_group,basis_determination,variable,value)%>%
  arrange(sub_samp_ref,variable, measurement_ref)
duplicated_1_records  ## All duplicates are two measurement of LIPIDWT% per sample, all from 2014  ## same tissue, no basis_determination entered

## countries
duplicated_1_records %>% select(country) %>% distinct(.)  #Poland


## take the average LIPIDWT% per sample for the duplicates
ices3_bbio= ices3_bbio %>%
  group_by(station,latitude,longitude,date,sub_samp_ref,sub_samp_id,samp_id,param_group,matrix_analyzed,variable ) %>% # group by all columns except value
  mutate(value= mean(value)) %>% ## value is equal to the mean value for each sample for each variable
  ungroup() %>%
  distinct(.)  ## retain ony distinct rows
dim(ices3_bbio) #3639   12

##check for unique variables and matrix_analyzed
ices3_bbio %>% select(matrix_analyzed,basis_determination,variable) %>% distinct(.) %>% arrange(variable)
## unique combination of variables and matrix_analyzed

##remove basis_determination  it is not recorded
ices3_bbio = ices3_bbio %>% select(-basis_determination)

# b-bio data wide format
ices3_bbio_wide = ices3_bbio %>%
  select(-matrix_analyzed) %>%
  group_by(station,latitude,longitude,date,sub_samp_ref,sub_samp_id,samp_id,param_group) %>%
  spread(variable,value) %>%
  ungroup()%>%
  dplyr::rename(param_bbio = param_group)


dim(ices3_bbio_wide); length(unique(ices3_bbio_wide$sub_samp_ref))  ## 1 row for every subsample ref.
##----------------------------------------##


#----------------------------------------##
## o-fl data
## This is congener concentration data
##----------------------------------------##
ices3_ofl = ices3 %>%
  select(c(station,latitude,longitude,date,sub_samp_ref,sub_samp_id,samp_id,param_group,matrix_analyzed,basis_determination,variable,unit,value))%>% ## reorder columns, identifiers first, only variables and values
  filter(param_group == "O-FL") %>% ## select only O-FL
  arrange(station,date,sub_samp_ref)
