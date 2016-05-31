##----------------------------------------##
## FILE:  raw_dioxin_data_prep.r
##----------------------------------------##

## This file is to prep raw PCB data from ICES and IVL so there will be consistent data for the database at level 1

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


########################################################################################
## DIOXIN ##
########################################################################################

##----------------------------------------##
## Read in ICES data
##----------------------------------------##
ices_raw = read.csv(file.path(dir_con, '/raw_prep/ICES_herring_dioxin_download_11may2016_cleaned.csv'),
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
length(unique(ices2$sub_samp_id)) #749
length(unique(ices2$bulk_id)) #1
length(unique(ices2$sub_samp_ref)) #752
length(unique(ices2$samp_id)) #109
length(unique(ices2$measurement_ref)) #8562

##----------------------------------------##
## ICES restrict data to >= 2000
##----------------------------------------##
ices3 = ices2 %>% filter(year >= 2000)
dim(ices2); dim(ices3)


##----------------------------------------##
## ICES parameters & conversion
## lipid v. weight weight, units
##----------------------------------------##

##What are the specific parameters
##unique parameter groups and associated variables
ices3 %>% select(param_group,variable) %>% distinct(.) %>% arrange(param_group, variable)
  ##OC-DX contains the dioxin congeners
  ##B-BIO is age, length, weight, % fat. % lipids


## which samples are not muscle or whole organism?
ices3 %>% select(param_group,variable, matrix_analyzed) %>% distinct(.) %>% arrange(param_group, variable, matrix_analyzed)
    ##DRYWT% and EXLIP% have been measured for both muscle and liver

## exclude liver matrix samples

ices3 = ices3 %>%
  filter(matrix_analyzed !="liver") ## remove samples for liver tissue, keep muscle and whole organism (this is for length, weight)


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
#write.csv(ices_lookup, file.path(dir_con, 'raw_prep/ices_dixion_lookup_unique_measurements.csv'))


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
dim(ices3_bbio) #2979   12
ices3_bbio %>% select(-value)%>% distinct(.) %>% nrow()#2979 , no duplicate rows

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


##----------------------------------------##
## oc-dx data
## This is congener concentration data
##----------------------------------------##
ices3_ocdx = ices3 %>%
  select(c(station,latitude,longitude,date,sub_samp_ref,sub_samp_id,samp_id,param_group,matrix_analyzed,basis_determination,variable,unit,value))%>% ## reorder columns, identifiers first, only variables and values
  filter(param_group == "OC-DX") %>% ## select only OC-DX
  arrange(station,date,sub_samp_ref)

dim(ices3_ocdx)
head(ices3_ocdx)
str(ices3_ocdx)

## Any congeners with lipid weight
ices3_ocdx %>% select(basis_determination) %>% distinct(.)
ices3_ocdx %>% filter(basis_determination == "lipid weight")
##YES

ices3_ocdx %>% filter(basis_determination == "lipid weight") %>% select(sub_samp_ref) %>% distinct(.) %>% nrow()


## different units for the data
ices3_ocdx %>% select(unit) %>%distinct(.)  ## pg/g, ng/kg  ## these are equivalent units but best to still have all in same
ices3_ocdx %>% select(variable,unit) %>%distinct(.)  ## only CDF2N ng/kg

## convert all to ug/kg (this is unit for the non-dioxin PCB GES boundary)

## select only the part of the unit look up needed, all converstions to ug/kg
unit_lookup_pg_g = unit_lookup %>% filter(ConvertUnit == "pg/g")


ices3_ocdx = ices3_ocdx %>%
  left_join(., unit_lookup_pg_g, by=c("unit" = "OriginalUnit")) %>%  ## combine data with the conversion factor
  mutate(value2 = value*ConvertFactor) ## calculate value in pg/g

ices3_ocdx

##save unit conversion data for reference
#write.csv(ices3_ocdx, file.path(dir_con, 'raw_prep/ices_dioxin_congener_unit_conversion.csv'))


## Remove the original values and merge the congener with the unit
ices3_ocdx = ices3_ocdx %>%
  select(-value,-unit, -ConvertFactor)%>%  ##remove columns not needed
  mutate(variable = paste(variable,ConvertUnit,sep="_")) %>% ## now variable and unit single text
  select(-ConvertUnit) %>%  ## column not needed
  dplyr::rename(value=value2)

#check unique variables
ices3_ocdx %>% select(variable) %>% distinct(.) #16

## are there duplicate measurements per subsampe_ref
ices3_ocdx %>% select(sub_samp_ref) %>% distinct(.) %>% nrow(.) #238 unique sub_sample_ref

ices3_ocdx %>% select(sub_samp_ref,variable) %>% distinct(.) %>% nrow(.) #3208
ices3_ocdx %>% select(sub_samp_ref,variable, basis_determination) %>% distinct(.) %>% nrow(.) #4264  ## seems like sub_samp_ref associated with wet & lipid weight?

## Duplicated sub_samp_ref IDs
duplicated_1 = ices3_ocdx %>% group_by(station,date,sub_samp_ref,variable)%>%summarise(n=n()) %>% ungroup() %>% filter(n>1) %>% select(sub_samp_ref) %>% distinct(.)
  dim(duplicated_1)  #66 total duplicated sub_samp_ref
  duplicated_1 = duplicated_1$sub_samp_ref

  ## explore duplicates in ices3
  ## duplicated records
  duplicated_1_records = ices3 %>%
    filter(sub_samp_ref %in% duplicated_1) %>%
    select(country,date,matrix_analyzed,sub_samp_ref,sub_samp_id,measurement_ref, param_group,basis_determination,variable,value)%>%
    arrange(sub_samp_ref,variable, measurement_ref)
  duplicated_1_records  ## duplicates appear to be wet and lipid weight basis measurements congeners

  ## how many of the dates does this account for
  duplicated_1_records %>% select(date) %>%distinct(.)%>% nrow(); ices3_ocdx %>% select(date) %>%distinct(.)%>% nrow() #31 distinct sample dates; 1/3 of 97 unique dates

  ##check to see if is all pairs of wet and lipid weight
  duplicated_1_records %>% filter(param_group =="OC-DX") %>%select(sub_samp_ref)%>% distinct(.) %>% nrow() ##66
  duplicated_1_records %>%filter(param_group =="OC-DX") %>%select(variable,sub_samp_ref)%>% distinct(.) %>% nrow() ## 1056

   duplicated_1_records %>% filter(param_group =="OC-DX") %>% group_by(variable,sub_samp_ref)%>%summarise(n=n()) %>% ungroup() %>% filter(n>1)
      ## all have 2
   duplicated_1_records %>% filter(param_group =="OC-DX") %>% group_by(variable,sub_samp_ref)%>%summarise(n=n()) %>% ungroup() %>% filter(n>1) %>% select(variable) %>% distinct()
      ## 16 different variables
   duplicated_1_records %>% filter(param_group =="OC-DX") %>%group_by(variable,sub_samp_ref)%>%summarise(n=n()) %>% ungroup() %>% filter(n==1)

   duplicated_1_records %>% filter(param_group =="OC-DX") %>% select(variable,basis_determination) %>% distinct(.)


  ## any wet weight basis that does not have a lipid weight basis
  ices3_ocdx %>% filter(basis_determination=="wet weight") %>% select(sub_samp_ref)%>% distinct(.) %>% nrow() ##106
      ##yes, so some of these are only reported as wet weight
  ices3_ocdx %>% filter(basis_determination=="wet weight") %>%filter(!(sub_samp_ref %in% duplicated_1))
      ## 40 records, all for congener CDF2N


## Exclude lipid weight samples if duplicated in wet weight
## check if excluding works correctly
check_exclude = ices3_ocdx %>%
                mutate(dupexclude = ifelse(sub_samp_ref %in% duplicated_1 & basis_determination == "lipid weight", 1, 0)) %>%
                filter(dupexclude == 0) ## select only the wet weight dups

dim(check_exclude); dim(ices3_ocdx)
check_exclude %>% group_by(station,date,sub_samp_ref,variable)%>%summarise(n=n()) %>% ungroup() %>% filter(n>1) %>% select(sub_samp_ref) %>% distinct(.)
## appears this excludes duplicates

## Exclude
ices3_ocdx =ices3_ocdx %>%
              mutate(dupexclude = ifelse(sub_samp_ref %in% duplicated_1 & basis_determination == "lipid weight", 1, 0)) %>%
              filter(dupexclude == 0)%>% ## select only the wet weight dups
              select(-dupexclude)


## Then spread data
ices3_ocdx_wide = ices3_ocdx %>%
  select(-matrix_analyzed) %>%
  group_by(station,latitude,longitude,date,sub_samp_ref,sub_samp_id,samp_id,param_group, basis_determination) %>%
  spread(variable,value) %>%
  dplyr::rename(param_ocdx = param_group) %>%
  ungroup() %>%
  arrange(station, date, sub_samp_ref)

dim(ices3_ocdx_wide) #238   25
ices3_ocdx_wide %>% select(sub_samp_ref)%>%distinct(.) %>% nrow()#238 ## one row for every unique sub_samp_ref



##----------------------------------------##
## Join ices3_ocdx_wide with ices3_bbio_wide
## do this so can convert from wet weight to lipid weight
##----------------------------------------##

ices4 = left_join(ices3_ocdx_wide, ices3_bbio_wide,
                  by=c("station","latitude","longitude",
                       "date","sub_samp_ref","sub_samp_id", "samp_id"))


head(ices4)
colnames(ices4)
dim(ices4) ##238 31   ## same number of rows as occb
ices4 %>% select(sub_samp_ref) %>% distinct(.) %>% nrow()

## save unconverted, merged data
#write.csv(ices4, file.path(dir_con,'raw_prep/ices_dioxin_congener_biodata_weight_basis_unconverted.csv'))

##----------------------------------------##
## CONVERT lipid weight measurements to wet weight
## multiple the congener concentration (if lipid based) by (EXLIP%_% / 100)
##----------------------------------------##
ices5 = ices4 %>%
  ##group_by(c(station:basis_determination, param_bbio:WTMIN_g)) %>% ## group by all id and bbio variable
  gather(congener, value,`CDD1N_pg/g`:`TCDD_pg/g`) %>%
  arrange(station,date, sub_samp_ref) %>% ##long data format
  mutate(value2 = ifelse(basis_determination=="lipid weight", (value* (`EXLIP%_%`/100)),value)) ## create new value column, if value is lipid weight convert, otherwise keep value
dim(ices5) #3808    18


## plot data to see if reasonable
ggplot(ices5) + geom_point(aes(date,value2, colour=factor(latitude)))+
  facet_wrap(~congener, scales="free_y")
ggplot(ices5) + geom_point(aes(date,value2,shape = basis_determination))+
  facet_wrap(~congener, scales="free_y")



## clean data set so only values based on wet weight
ices5 = ices5 %>%
  select(-value, -param_ocdx,-param_bbio) %>%
  dplyr::rename(basis_determination_orginaldata = basis_determination,
                value=value2) %>%
  filter(!is.na(value)) %>% ## remove the congeners not measured
  arrange(station, date, sub_samp_ref)
dim(ices5) #3208    15


##----------------------------------------##
## combine harmonized data with ices_lookup
##do this so have country and monitoring program info, and qflaugs
##----------------------------------------##

## reduce ices_lookup to only relevant columns, need to remove duplicate detect lim and other info for the wet / lipid dups
ices_lookup = ices_lookup %>%
              mutate(dupexclude = ifelse(sub_samp_ref %in% duplicated_1 & basis_determination == "lipid weight", 1, 0)) %>% ## n
              filter(dupexclude == 0) %>% ## select only the wet weight dups
              select(-sex_specimen,-matrix_analyzed, -not_used_in_datatype, -analyt_lab,-ref_source,
                     -method_storage, -method_pretreat,-method_pur_sep,-method_chem_fix,-method_chem_extract,
                     -method_analysis,-formula_calc,-test_organism,-sampler_type,-factor_compli_interp,
                     -analyt_method_id,-measurement_ref, -basis_determination, -dupexclude) %>%
              filter(param_group == "OC-DX") %>% ## only select lookup info about congener variables
              select(-param_group)%>% ## don't need param_group
              mutate(congener_unit = paste(variable, "_pg/g", sep=""))%>% ## this column will match the congener column in ices5
              select(-variable) %>% ##no longer need this column
              distinct(.) %>% ## might have duplicates because sub_samp_ref with duplicate wet & lipid weight basis (this removes some but not all)
              arrange(station, date, sub_samp_ref)

dim(ices_lookup) #3208 23



## join ices5 and ices_lookup
ices6 = left_join(ices5,
                  ices_lookup,
                  by=c("station","date","latitude","longitude","sub_samp_id",
                       "sub_samp_ref","samp_id", "congener"="congener_unit") )%>%
  mutate(basis_determination_converted = "wet weight") %>%  ## add column to have current basis clear
  select(country,monit_program,monit_purpose,report_institute,station,
         latitude,longitude, date, monit_year,date_ices,
         ##day, month,  ## can add when re run with data called from the database
         year,species,
         sub_samp_ref,sub_samp_id, samp_id,num_indiv_subsample, bulk_id,
         basis_determination_orginaldata,basis_determination_converted,
         AGMEA_y,`DRYWT%_%`, `EXLIP%_%`,
         LNMEA_cm,WTMEA_g ,
         qflag, detect_lim, quant_lim,uncert_val,method_uncert,congener, value) %>%  ## reorder columns
  dplyr::rename(basis_determination_originalcongener = basis_determination_orginaldata) %>%
  arrange(station,date, sub_samp_ref)

dim(ices6) #3208   31
dim(ices5) #3208   15  ## some how rows were added


## do not want to spread the data because the qflag, detli etc is unique to each congener

## save and export
write.csv(ices6, file.path(dir_con, "raw_prep/ices_herring_dioxin_cleaned.csv"),row.names = FALSE)


