##-------------------------------------------##
## ICES station attributes
##-------------------------------------------##
## This file combines the ices station dictionary, with numeric country codes, and a
## key to the impact codes in the MSTAT column


##-------------------------------------------##
## LIBRARIES and FILE PATHS
##-------------------------------------------##
## LIBRARIES
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(RMySQL)
library(stringr)
library(tools)
library(rprojroot)

##FILE PATHS
## rprojroot
root <- rprojroot::is_rstudio_project

## make_path() function to
make_path <- function(...) rprojroot::find_root_file(..., criterion = is_rstudio_project)

dir_layers = make_path('baltic2015/layers') # replaces  file.path(dir_baltic, 'layers')

source('~/github/bhi/baltic2015/prep/common.r')
dir_cw    = file.path(dir_prep, 'CW')
dir_con    = file.path(dir_prep, 'CW/contaminants')



##-------------------------------------------##
## READ IN DATA
##-------------------------------------------##
## Read in ICES station dictionary
station_dictionary = read.csv(file.path(dir_con,'raw_prep/station_dictionary.csv'), sep=";")

# and codes for siteimpact (eg. reference or impact type
impact_code = read.csv(file.path(dir_con,'raw_prep/Site_impact_lookup_ICES.csv'))


##country numeric code
country_code = read.csv(file.path(dir_con,'raw_prep/country_code_ices.csv'))


##-------------------------------------------##
##station_dictionary strtucture
str(station_dictionary)

## countries as character
station_dictionary = station_dictionary %>%
                    mutate(Country = as.character(Country),
                           Station_Name = as.character(Station_Name))
str(station_dictionary)

## Unique countries in station dictionary
station_dictionary %>% select(Country) %>% distinct(.)



## Replace Country codes in Station Dictionary with Names
unique(station_dictionary$Country)
#Portugal       Latvia         Russia         11             Faroe Islands  Greenland
#46             Norway         6              Poland         Ireland        64
# Lithuania      35             United Kingdom 29             Denmark        Estonia
#FINLAND        Finland        Sweden

codes_replace = c("11","46","06","29", "64","35")

country_code = country_code %>%
              select(Code, Description) %>%
              filter(Code %in% codes_replace)
country_code

station_dictionary = station_dictionary %>%
                    mutate(Country = ifelse(Country == "6", "Germany",
                                     ifelse(Country == "11", "Belgium",
                                     ifelse(Country == "29", "Spain",
                                     ifelse(Country == "35", "France",
                                     ifelse(Country == "46", "Iceland",
                                     ifelse(Country == "64", "The Netherlands",Country)))))))

station_dictionary %>% select(Country) %>% distinct(.)

## change Finland to lower case

station_dictionary = station_dictionary %>%
  mutate(Country = replace(Country, Country == "FINLAND", "Finland"))

station_dictionary %>% select(Country) %>% distinct(.)


##-------------------------------------------##
## Join station dictionary to Codes
impact_code = impact_code %>%
              dplyr::rename(MSTAT = Code,
                            MSTAT_Description = Description) %>%
              select(MSTAT, MSTAT_Description) %>%
              mutate(MSTAT = as.character(MSTAT),
                     MSTAT_Description= as.character(MSTAT_Description))%>%
              arrange(MSTAT)
impact_code


station_dictionary = station_dictionary %>%
                    arrange(MSTAT)

## what are unique MSTAT
station_dictionary %>% select(MSTAT) %>% distinct(.)  ## multiple categories in Single Column


station_RH = station_dictionary %>% filter(grepl("RH", MSTAT)) %>%
             select(Country, Station_Name, Latitude, Longitude) %>% distinct(.)%>%
              mutate(impact_RH = 1)   ## WFD R(HZ) - Representative of general conditions in terms of hazardous substances



station_B = station_dictionary %>% filter(grepl("B", MSTAT)) %>%
              select(Country, Station_Name, Latitude, Longitude) %>% distinct(.)%>%
              mutate(impact_B = 1)##WFD B - Baseline/Reference station

station_I = station_dictionary %>% filter(grepl("I", MSTAT)) %>%
  select(Country, Station_Name, Latitude, Longitude) %>% distinct(.)%>%
  mutate(impact_I = 1)## any type of indentified impact


## Join impact categories
station_dictionary = station_dictionary %>%
                    full_join(., station_RH, by=c("Country","Station_Name","Latitude","Longitude"))%>%
                    full_join(., station_B, by=c("Country","Station_Name","Latitude","Longitude")) %>%
                    full_join(., station_I, by=c("Country","Station_Name","Latitude","Longitude")) %>%
                    arrange(impact_RH,Country,Station_Name)
head(station_dictionary)

station_dictionary %>% arrange(impact_B,Country,Station_Name) %>% head()

station_dictionary %>% arrange(impact_I,Country,Station_Name) %>% head()


##-------------------------------------------##
## Clean and export

station_dictionary = station_dictionary %>%
                     select(ID:Purpose_temporal,All_Biota_Data,Contaminant_parameters_in_biota,impact_RH:impact_I)
head(station_dictionary)

station_dictionary %>% select(Station_Name) %>% filter(grepl("ä", Station_Name))
station_dictionary %>% select(Station_Name) %>% filter(grepl("ö", Station_Name))
station_dictionary %>% select(Station_Name) %>% filter(grepl("å", Station_Name))
station_dictionary %>% select(Station_Name) %>% filter(grepl("Ä", Station_Name))
station_dictionary %>% select(Station_Name) %>% filter(grepl("Ö", Station_Name))
station_dictionary %>% select(Station_Name) %>% filter(grepl("Å", Station_Name))

##fix non-english letters
station_dictionary = station_dictionary %>%
                      mutate(Station_Name2 = tolower(Station_Name))%>% ## station names all lower case
                     mutate(Station_Name2 = gsub("ä","ae",Station_Name2),
                            Station_Name2 = gsub("ö","oe",Station_Name2),
                            Station_Name2 = gsub("å","a",Station_Name2))
head(station_dictionary)

station_dictionary %>% filter(Country=="Sweden") %>% select(Station_Name, Station_Name2) %>% distinct(.)


## save

write.csv(station_dictionary, file.path(dir_con, 'raw_prep/station_impact_cleaned.csv'), row.names = FALSE)
