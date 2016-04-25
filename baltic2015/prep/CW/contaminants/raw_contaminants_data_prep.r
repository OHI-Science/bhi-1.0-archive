##----------------------------------------##
## FILE:  raw_contaminants_data_prep.r
##----------------------------------------##

## This file is to prep raw data from ICES and IVL so there will be consistent data for the database at level 1

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
## Read in IVL data
##----------------------------------------##
ices_raw = read.csv(file.path(dir_con, '/raw_prep/ICES_herring_pcb_dowload_22april2016_cleaned.csv'),
                   sep=";")
head (ices_raw)
dim(ices_raw)
str(ices_raw)

##----------------------------------------##
## ICES data cleaning and manipulations
##----------------------------------------##


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
# Country last(year)
# (fctr)      (dbl)
# 1 Estonia       2008
# 2 Finland       2012
# 3 Germany       2013
# 4  Latvia       2002
# 5  Poland       2014
# 6  Sweden       2013


##----------------------------------------##
## ICES change column names
##----------------------------------------##

ices1 = ices_raw %>% dplyr::rename(monit_program =MPROG, monit_purpose = PURPM,
                                country=Country, report_institute =RLABO,
                                station=STATN, monit_year=MYEAR, date_ices =DATE,
                                day=day, month=month,year=year,date=date,
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
length(unique(ices2$sub_samp_id)) #2123
length(unique(ices2$bulk_id)) #1
length(unique(ices2$sub_samp_ref)) #5105
length(unique(ices2$samp_id)) #558
length(unique(ices2$measurement_ref)) #51441

##----------------------------------------##
## ICES restrict data to >= 2000 , perhaps more consistent data
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
    ## lipid content, etc. needed to convert lipid basis samples into the wet weight are in the B-BIO column

    ## Links to B-BIO variable code:  http://vocab.ices.dk/?ref=78
    ## Linkes to OC-CB variable codes: http://vocab.ices.dk/?ref=37

## Remove specific variables
## remove PCB, SCB , SCB7 - these are summarized data or depreciated codes
ices3 = ices3 %>% filter(variable != "PCB" & variable != "SCB")
    ##check
    ##ices3 %>% select(param_group,variable) %>% distinct(.) %>% arrange(param_group, variable)


## remove liver samples, keep muscle and whole organism measurements

ices3 = ices3 %>%
        filter(matrix_analyzed !="liver") ## remove samples for liver tissue, keep muscle and whole organism (this is for length, weight)


## Align all measurements with sub_samp_ref (most unqiue)
## check, any observations do not have sub_samp_ref?
ices3 %>% filter(is.na(sub_samp_ref))  ## all observations have a subsample ref

ices3 %>% filter(vflag !="A") %>% select(vflag) %>%distinct(.)  ## A = acceptable, all others are blank, no problems


##----------------------------------------##
## ICES separate data into 3 objects
##----------------------------------------##
## Look-up methods
ices_lookup= ices3 %>%
  select(c(monit_program:not_used_in_datatype,analyt_lab:samp_id, param_group,variable,qflag,detect_lim,quant_lim,uncert_val,method_uncert))
str(ices_lookup)


#### TO DO


## b-bio data
ices3_bbio = ices3 %>%
  select(c(station,latitude,longitude,date,sub_samp_ref,sub_samp_id,samp_id,param_group,matrix_analyzed,variable,unit,value))%>% ## reorder columns, identifiers first, only variables and values
  filter(param_group == "B-BIO") %>% ## select only B-BIO
  mutate(variable = paste(variable,unit,sep="_"))  %>%  #combine variable with measurement unit
  select(-unit)%>% ## no longer needed
  arrange(station,date,sub_samp_ref)

## DUPLICATE PROBLEMS (data year >= 2000)
dim(ices3_bbio) #12698    11
ices3_bbio %>% select(-value)%>% distinct(.) %>% nrow()#12674; 24 duplicate rows


## find duplicates, look at sub_samp_ref and variable
ices3_bbio %>% group_by(station,date,sub_samp_ref,variable, matrix_analyzed)%>%summarise(n=n()) %>% ungroup()%>% filter(n>1) ## 24 unique sub_samp_ref & variables

  ## Duplicated sub_samp_ref IDs
  duplicated_1 = ices3_bbio %>% group_by(station,date,sub_samp_ref,variable)%>%summarise(n=n()) %>% ungroup() %>% filter(n>1) %>% select(sub_samp_ref) %>% distinct(.)

    dim(duplicated_1)  #24 total duplicated IDs
    duplicated_1 = duplicated_1$sub_samp_ref


    ## explore duplicates in ices3
           ## duplicated records
      duplicated_1_records = ices3 %>%
                              filter(sub_samp_ref %in% duplicated_1) %>%
                              select(country,date,matrix_analyzed,sub_samp_ref,sub_samp_id,measurement_ref, param_group,variable,value)%>%
                              arrange(sub_samp_ref,variable, measurement_ref)
      duplicated_1_records  ## All duplicates are two measurement of LIPIDWT% per sample, all from 2014


      ## countries
      duplicated_1_records %>% select(country) %>% distinct(.)  #Poland


## take the average LIPIDWT% per sample for the duplicates
      ices3_bbio= ices3_bbio %>%
                    group_by(station,latitude,longitude,date,sub_samp_ref,sub_samp_id,samp_id,param_group,matrix_analyzed,variable ) %>% # group by all columns except value
                    mutate(value= mean(value)) %>% ## value is equal to the mean value for each sample for each variable
                    ungroup() %>%
                    distinct(.)  ## retain ony distinct rows
      dim(ices3_bbio) #12674    11

#check for unique variables and matrix_analyzed
      ices3_bbio %>% select(matrix_analyzed,variable) %>% distinct(.) %>% arrange(variable)
      ## unique combination of variables and matrix_analyzed


## b-bio data wide format
      ices3_bbio_wide = ices3_bbio %>%
                        select(-matrix_analyzed) %>%
                        group_by(station,latitude,longitude,date,sub_samp_ref,sub_samp_id,samp_id,param_group) %>%
                        spread(variable,value)

      dim(ices3_bbio_wide); length(unique(ices3_bbio_wide$sub_samp_ref))  ## 1 row for every subsample ref.

## oc-cb data

##----------------------------------------##
############################################
##----------------------------------------##


##----------------------------------------##
## Read in IVL data
##----------------------------------------##
ivl_raw = read.csv(file.path(dir_con, '/raw_prep/IVL_herring_pcb_download_21april2016_cleaned.csv'),
                   sep=";")
head (ivl_raw)
dim(ivl_raw)
str(ivl_raw)


##----------------------------------------##
## IVL data cleaning and manipulations
##----------------------------------------##

## Add unique key for each sample

ivl1 = ivl_raw %>% mutate(id = seq(1,nrow(ivl_raw),1))

## Separate data into congener and qflag datasets

ivlcon = ivl1 %>% select(-c(PCB_sum_qflag              ,
                            PCB_sum_packad_kolonn_qflag,
                            PCB101_qflag               ,
                            PCB105_qflag               ,
                            PCB110_qflag               ,
                            PCB118_qflag               ,
                            PCB126_qflag               ,
                            PCB138_qflag               ,
                            PCB149_qflag               ,
                            PCB153_qflag               ,
                            PCB156_qflag               ,
                            PCB157_qflag               ,
                            PCB158_qflag               ,
                            PCB167_qflag               ,
                            PCB169_qflag               ,
                            PCB180_qflag               ,
                            PCB28_qflag                ,
                            PCB31_qflag                ,
                            PCB52_qflag                ,
                            PCB77_qflag   ))

ivlqflag = ivl1 %>% select(id               ,
                           ProvId           ,
                           lon              ,
                           lat              ,
                           Laen             ,
                           Laenskod         ,
                           Program          ,
                           station          ,
                           Kommun           ,
                           Datum            ,
                           Orginal_id       ,
                           Species          ,
                           Stat_id          ,
                           Count            ,
                           Alder            ,
                           Organ            ,
                           Extrlip_percent  ,
                           Individvikt_g    ,
                           Torrvikt_percent ,
                           Laengd_cm        ,
                           Provvikt_g       ,
                           Unit           ,
                           PCB_sum_qflag              ,
                           PCB_sum_packad_kolonn_qflag,
                           PCB101_qflag               ,
                           PCB105_qflag               ,
                           PCB110_qflag               ,
                           PCB118_qflag               ,
                           PCB126_qflag               ,
                           PCB138_qflag               ,
                           PCB149_qflag               ,
                           PCB153_qflag               ,
                           PCB156_qflag               ,
                           PCB157_qflag               ,
                           PCB158_qflag               ,
                           PCB167_qflag               ,
                           PCB169_qflag               ,
                           PCB180_qflag               ,
                           PCB28_qflag                ,
                           PCB31_qflag                ,
                           PCB52_qflag                ,
                           PCB77_qflag)

## gather data
### IVL con, one column for congener, 1 for value
ivlcon2 = ivlcon %>% group_by(id               ,
                         ProvId           ,
                         lon              ,
                         lat              ,
                         Laen             ,
                         Laenskod         ,
                         Program          ,
                         station          ,
                         Kommun           ,
                         Datum            ,
                         Orginal_id       ,
                         Species          ,
                         Stat_id          ,
                         Count            ,
                         Alder            ,
                         Organ            ,
                         Extrlip_percent  ,
                         Individvikt_g    ,
                         Torrvikt_percent ,
                         Laengd_cm        ,
                         Provvikt_g       ,
                         Unit                                 ) %>%
  gather(key=congener, value= pcb_value,c(
    PCB_SUM               ,
    PCB_sum_packad_kolonn ,
    PCB101                ,
    PCB105                ,
    PCB110                ,
    PCB118                ,
    PCB126                ,
    PCB138                ,
    PCB149                ,
    PCB153                ,
    PCB156                ,
    PCB157                ,
    PCB158                ,
    PCB167                ,
    PCB169                ,
    PCB180                ,
    PCB28                 ,
    PCB31                 ,
    PCB52                 ,
    PCB77                 ))%>%ungroup() %>% arrange(id)


## IVL qflag, group by qflag con and flag

ivlqflag2 =ivlqflag %>% group_by(id               ,
                                  ProvId           ,
                                  lon              ,
                                  lat              ,
                                  Laen             ,
                                  Laenskod         ,
                                  Program          ,
                                  station          ,
                                  Kommun           ,
                                  Datum            ,
                                  Orginal_id       ,
                                  Species          ,
                                  Stat_id          ,
                                  Count            ,
                                  Alder            ,
                                  Organ            ,
                                  Extrlip_percent  ,
                                  Individvikt_g    ,
                                  Torrvikt_percent ,
                                  Laengd_cm        ,
                                  Provvikt_g       ,
                                  Unit                                 ) %>%
  gather(key=qflag_congener, value= qflag,c(PCB_sum_qflag              ,
                                            PCB_sum_packad_kolonn_qflag,
                                            PCB101_qflag               ,
                                            PCB105_qflag               ,
                                            PCB110_qflag               ,
                                            PCB118_qflag               ,
                                            PCB126_qflag               ,
                                            PCB138_qflag               ,
                                            PCB149_qflag               ,
                                            PCB153_qflag               ,
                                            PCB156_qflag               ,
                                            PCB157_qflag               ,
                                            PCB158_qflag               ,
                                            PCB167_qflag               ,
                                            PCB169_qflag               ,
                                            PCB180_qflag               ,
                                            PCB28_qflag                ,
                                            PCB31_qflag                ,
                                            PCB52_qflag                ,
                                            PCB77_qflag)) %>%
  ungroup()%>% arrange(id)
