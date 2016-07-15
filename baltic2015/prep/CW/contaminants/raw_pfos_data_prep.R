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
ices3 %>% select(param_group,variable, matrix_analyzed,basis_determination) %>% distinct(.) %>% arrange(param_group, variable, matrix_analyzed)
##DRYWT% and EXLIP% have been measured for both muscle and liver
## all of the compounds except PFOS measured only in the liver.
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

## create variable combining variable and matrix analyzed

ices4 = ices3 %>%
        mutate(variable_matrix = paste(variable,"_",matrix_analyzed, sep=""))%>%
        select(-variable, -matrix_analyzed)


## keep variables for both liver and muscle for now

## check, any observations do not have sub_samp_ref?
ices4 %>% filter(is.na(sub_samp_ref))  ## all observations have a subsample ref

ices4 %>% filter(vflag !="A") %>% select(vflag) %>%distinct(.)  ## A = acceptable, all others are blank, no problems


##----------------------------------------##
##----------------------------------------##
## ICES separate data into 3 objects
##----------------------------------------##

##----------------------------------------##
## Look-up methods
ices_lookup= ices4 %>%
  select(c(monit_program:not_used_in_datatype,analyt_lab:samp_id, param_group,variable_matrix,basis_determination,qflag,detect_lim,quant_lim,uncert_val,method_uncert))
str(ices_lookup)

##save ices lookup
##write.csv(ices_lookup, file.path(dir_con, 'raw_prep/ices_pfos_lookup_unique_measurements.csv'))

##----------------------------------------##
## b-bio data
## These data are length, weight, fat and lipid content
##----------------------------------------##
ices4_bbio = ices4 %>%
  select(c(station,latitude,longitude,date,sub_samp_ref,sub_samp_id,samp_id,param_group,basis_determination,variable_matrix,unit,value))%>% ## reorder columns, identifiers first, only variables and values
  filter(param_group == "B-BIO") %>% ## select only B-BIO
  mutate(variable_matrix = paste(variable_matrix,unit,sep="_"))  %>%  #combine variable with measurement unit
  select(-unit)%>% ## no longer needed
  arrange(station,date,sub_samp_ref)

## ANY DUPLICATE PROBLEMS (data year >= 2000)
dim(ices4_bbio) #4503    12
ices4_bbio %>% select(-value)%>% distinct(.) %>% nrow()#4479  ## duplicate rows

## Duplicated sub_samp_ref IDs
duplicated_1 = ices4_bbio %>% group_by(station,date,sub_samp_ref,variable_matrix)%>%summarise(n=n()) %>% ungroup() %>% filter(n>1) %>% select(sub_samp_ref) %>% distinct(.)

dim(duplicated_1)  #24 total duplicated IDs
duplicated_1 = duplicated_1$sub_samp_ref

# explore duplicates in ices4
## duplicated records
duplicated_1_records = ices4 %>%
  filter(sub_samp_ref %in% duplicated_1) %>%
  select(country,date,sub_samp_ref,sub_samp_id,measurement_ref, param_group,basis_determination,variable_matrix,value)%>%
  arrange(sub_samp_ref,variable_matrix, measurement_ref)
duplicated_1_records  ## All duplicates are two measurement of LIPIDWT% per sample, all from 2014  ## same tissue, no basis_determination entered

## countries
duplicated_1_records %>% select(country) %>% distinct(.)  #Poland


## take the average LIPIDWT%_muscle per sample for the duplicates
ices4_bbio= ices4_bbio %>%
  group_by(station,latitude,longitude,date,sub_samp_ref,sub_samp_id,samp_id,param_group,variable_matrix ) %>% # group by all columns except value
  mutate(value= mean(value)) %>% ## value is equal to the mean value for each sample for each variable
  ungroup() %>%
  distinct(.)  ## retain ony distinct rows
dim(ices4_bbio) #4479   11

##check for unique variables and matrix_analyzed
ices4_bbio %>% select(basis_determination,variable_matrix) %>% distinct(.) %>% arrange(variable_matrix)
## unique combination of variable_matrix

##remove basis_determination  it is not recorded
ices4_bbio = ices4_bbio %>% select(-basis_determination)

# b-bio data wide format
ices4_bbio_wide = ices4_bbio %>%
  group_by(station,latitude,longitude,date,sub_samp_ref,sub_samp_id,samp_id,param_group) %>%
  spread(variable_matrix,value) %>%
  ungroup()%>%
  dplyr::rename(param_bbio = param_group)


dim(ices4_bbio_wide); length(unique(ices4_bbio_wide$sub_samp_ref))  ## 1 row for every subsample ref.
##----------------------------------------##


#----------------------------------------##
## o-fl data
## This is congener concentration data
##----------------------------------------##
ices4_ofl = ices4 %>%
  select(c(station,latitude,longitude,date,sub_samp_ref,sub_samp_id,samp_id,param_group,basis_determination,variable_matrix,unit,value))%>% ## reorder columns, identifiers first, only variables and values
  filter(param_group == "O-FL") %>% # select only O-FL
  filter(grepl("PFOS",variable_matrix)) %>% #select only PFOS (both liver and muscle)
  arrange(station,date,sub_samp_ref)

dim(ices4_ofl)
head(ices4_ofl)
str(ices4_ofl)

## Any congeners with lipid weight
ices4_ofl %>% select(basis_determination) %>% distinct(.)
ices4_ofl %>% filter(basis_determination == "lipid weight")
##NO


## different units for the data
ices4_ofl %>% select(unit) %>%distinct(.)  ## ng/g, ug/kg  ## these are equivalent units but best to still have all in same
ices4_ofl %>% select(variable_matrix,unit) %>%distinct(.)  ## only PFOS_muscle ug/kg

ices4_ofl %>% filter(unit == "ug/kg") %>% nrow() ## 24 samples - these are the samples from Poland.


## convert all to ug/kg (this is unit for the PFOS GES boundary)

## select only the part of the unit look up needed, all conversions to ug/kg
unit_lookup_ug_kg = unit_lookup %>% filter(ConvertUnit == "ug/kg")


ices4_ofl = ices4_ofl %>%
  left_join(., unit_lookup_ug_kg, by=c("unit" = "OriginalUnit")) %>%  ## combine data with the conversion factor
  mutate(value2 = value*ConvertFactor) ## calculate value in ug/kg

ices4_ofl

##save unit conversion data for reference
#write.csv(ices4_ofl, file.path(dir_con, 'raw_prep/ices_pfos_congener_unit_conversion.csv'))


## Remove the original values and merge the congener with the unit
ices4_ofl = ices4_ofl %>%
  select(-value,-unit, -ConvertFactor)%>%  ##remove columns not needed
  mutate(variable = paste(variable_matrix,ConvertUnit,sep="_")) %>% ## now variable and unit single text
  select(-ConvertUnit) %>%  ## column not needed
  dplyr::rename(value=value2)

#check unique variables
ices4_ofl %>% select(variable) %>% distinct(.) #16

## are there duplicate measurements per subsampe_ref
ices4_ofl %>% select(sub_samp_ref) %>% distinct(.) %>% nrow(.) #237 unique sub_sample_ref

ices4_ofl %>% select(sub_samp_ref,variable) %>% distinct(.) %>% nrow(.) #237
ices4_ofl %>% select(sub_samp_ref,variable, basis_determination) %>% distinct(.) %>% nrow(.) #237



## Then spread data
ices4_ofl_wide = ices4_ofl %>%
  group_by(station,latitude,longitude,date,sub_samp_ref,sub_samp_id,samp_id,param_group, basis_determination) %>%
  spread(variable,value) %>%
  dplyr::rename(param_ocdx = param_group) %>%
  ungroup() %>%
  arrange(station, date, sub_samp_ref)

dim(ices4_ofl_wide) #237 12
ices4_ofl_wide %>% select(sub_samp_ref)%>%distinct(.) %>% nrow()#237 ## one row for every unique sub_samp_ref




##----------------------------------------##
## Join ices4_ofl_wide with ices3_bbio_wide
## do this so can convert from wet weight to lipid weight
##----------------------------------------##

ices5 = left_join(ices4_ofl_wide, ices4_bbio_wide,
                  by=c("station","latitude","longitude",
                       "date","sub_samp_ref","sub_samp_id", "samp_id"))


head(ices5)
colnames(ices5)
dim(ices5) ##237 27   ## same number of rows as occb
ices5 %>% select(sub_samp_ref) %>% distinct(.) %>% nrow()

## save unconverted, merged data
#write.csv(ices5, file.path(dir_con,'raw_prep/ices_pfos_congener_biodata_weight_basis_unconverted.csv'))

##----------------------------------------##
## Data Conversion
##
## NO Data conversion from dry to wet weight needed, Data are already in wet weight
## Convert liver values into those for muscle using conversion values from Faxneld et al 2014. (https://www.diva-portal.org/smash/get/diva2:767385/FULLTEXT01.pdf)
## Do this because Polish 2014 measured in muscle tissue
## Follow methods in the HELCOM core indicator p.9 (http://www.helcom.fi/Core%20Indicators/PFOS_HELCOM%20core%20indicator%202016_web%20version.pdf)
## Use the mean liver:muscle ratio for all species (17.9), see Table 8 in Faxneld et al 2014
##----------------------------------------##


ices6 = ices5 %>%
  select(-param_bbio,-param_ocdx, -variable_matrix)%>%
  mutate(pfos_tissue_original_type = ifelse(is.na(`PFOS_liver_ug/kg`),"muscle","liver"),
         pfos_converted_ug_kg =ifelse(pfos_tissue_original_type == "liver", `PFOS_liver_ug/kg`/17.9,`PFOS_muscle_ug/kg`))%>%
         select(-`PFOS_liver_ug/kg`,-`PFOS_muscle_ug/kg`)%>%
         mutate(variable = "pfos_ug_kg_muscle_equiv_con") %>%
         dplyr::rename(value=pfos_converted_ug_kg )%>%
  select(station:basis_determination,`AGMAX_whole organism_y`:`WTMIN_whole organism_g`, pfos_tissue_original_type,variable,value) ## reorder

##plot converted
ggplot(ices6)+
  geom_point(aes(date,value),color="red",shape = 8)+
  ylab("pfos_ug_kg_muscle_equiv_con")

dim(ices6)




##----------------------------------------##
## combine harmonized data with ices_lookup
##do this so have country and monitoring program info, and qflaugs
##----------------------------------------##

## reduce ices_lookup to only relevant columns, need to remove duplicate detect lim and other info for the wet / lipid dups
ices_lookup1 = ices_lookup %>%
  select(-sex_specimen,-not_used_in_datatype, -analyt_lab,-ref_source,
         -method_storage, -method_pretreat,-method_pur_sep,-method_chem_fix,-method_chem_extract,
         -method_analysis,-formula_calc,-test_organism,-sampler_type,-factor_compli_interp,
         -analyt_method_id,-measurement_ref, -basis_determination) %>%
  filter(param_group == "O-FL") %>% ## only select lookup info about pfos
  filter(grepl("PFOS",variable_matrix)) %>% #select only PFOS (both liver and muscle)
  select(-param_group)%>% ## don't need param_group
  mutate(variable = "pfos_ug_kg_muscle_equiv_con")%>% ## this column will match the congener column in ices6
  distinct(.) %>% ## might have duplicates because sub_samp_ref with duplicate wet & lipid weight basis (this removes some but not all)
  arrange(station, date, sub_samp_ref)

dim(ices_lookup1) #237  24


## join ices6 and ices_lookup
ices7 = left_join(ices6,
                  ices_lookup1,
                  by=c("station","date","latitude","longitude","sub_samp_id",
                       "sub_samp_ref","samp_id", "variable") )%>%
  select(country,monit_program,monit_purpose,report_institute,station,
         latitude,longitude, date, monit_year,date_ices,
         ##day, month,  ## can add when re run with data called from the database
         year,species,
         sub_samp_ref,sub_samp_id, samp_id,num_indiv_subsample, bulk_id,
         basis_determination,
         `AGMEA_whole organism_y`,
         `DRYWT%_liver_%`,`DRYWT%_muscle_%`,
         `EXLIP%_liver_%`,`EXLIP%_muscle_%`,
         `LIPIDWT%_muscle_%`,
         `LNMEA_whole organism_cm`,`WTMEA_whole organism_g`,
         qflag, detect_lim, quant_lim,uncert_val,method_uncert,pfos_tissue_original_type,variable, value) %>%  ## reorder columns
  arrange(station,date, sub_samp_ref)

dim(ices7) ##237  34
dim(ices6) ## 237 25
head(ices7)



##----------------------------------------##
## ASSIGN BHI REGIONS TO LAT-LON locations
##----------------------------------------##

##----------------------------------------##
## 1. Get unique lat-lon-station

pfos_loc = ices7 %>%
           select(country,station,latitude,longitude) %>%
           distinct()
dim(pfos_loc)

pfos_coord = pfos_loc %>%
             select(longitude,latitude)  ## only lon and lat

##----------------------------------------##
## 2. Load spatial libraries
require(sp)
require(rgdal)
require(maps)


##----------------------------------------##
## 3. Read in BHI region shape files


## this is
BHIshp = readOGR('C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/shapefiles/BHI_shapefile_projected',
                "BHI_shapefile_projected")
BHIshp2 = spTransform(BHIshp, CRS("+proj=longlat +init=epsg:4326"))
print(proj4string(BHIshp2))


##----------------------------------------##
## 4. Set lat-lon to same projection as the shapefile
pfos_coord_sp<-SpatialPoints(pfos_coord, proj4string = CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
pfos_coord_spt<-spTransform(pfos_coord_sp,CRS(proj4string(BHIshp2)))


##----------------------------------------##
## 4. Use over to assign BHI polygon name (BHI region ID) to each lat-lon

pfos_coord_spt$BHI_ID <- over(pfos_coord_spt, BHIshp2)$BHI_ID

pfos_coord_spt

## one NA - this is from Langö in Stockholm Archipelago (also a problem when Marc assigned for other data), will add manually


##----------------------------------------##
## 5. Final loc object

pfos_bhi = bind_cols(data.frame(pfos_coord_spt@coords),pfos_coord_spt@data) %>%
           bind_cols(., dplyr::rename(pfos_loc, lat_loc=latitude,lon_loc =longitude)) %>%
           select(country,station,lat_loc,lon_loc,BHI_ID)%>%
           dplyr::rename(latitude = lat_loc, longitude = lon_loc) %>%
           mutate(BHI_ID = ifelse(station == "Lagnoe",29,BHI_ID))


pfos_bhi


##----------------------------------------##
## JOIN BHI REGIONS INFO to PFOS data
##----------------------------------------##
ices8 = full_join(ices7,pfos_bhi,by=c("country","station","latitude","longitude"))%>%
  select(country,monit_program,monit_purpose,report_institute,station,
         latitude,longitude, BHI_ID, date, monit_year,date_ices,
         ##day, month,  ## can add when re run with data called from the database
         year,species,
         sub_samp_ref,sub_samp_id, samp_id,num_indiv_subsample, bulk_id,
         basis_determination,
         `AGMEA_whole organism_y`,
         `DRYWT%_liver_%`,`DRYWT%_muscle_%`,
         `EXLIP%_liver_%`,`EXLIP%_muscle_%`,
         `LIPIDWT%_muscle_%`,
         `LNMEA_whole organism_cm`,`WTMEA_whole organism_g`,
         qflag, detect_lim, quant_lim,uncert_val,method_uncert,pfos_tissue_original_type,variable, value) %>%  ## reorder columns
  arrange(station,date, sub_samp_ref)



## do not want to spread the data because the qflag, detli etc is unique to each congener

##----------------------------------------##
## SAVE and EXPORT
##----------------------------------------##
write.csv(ices8, file.path(dir_con, "raw_prep/ices_herring_pfos_cleaned.csv"),row.names = FALSE)

