##----------------------------------------##
## FILE: congener_description.r
##----------------------------------------##

# This file is to match the PCB and Dioxin congener code with their full description (eg. full compound name)

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
##----------------------------------------##
## READ IN
##----------------------------------------##
## congener descriptions from ICES
congener_descrip = read.csv(file.path(dir_con, 'ices_param_code_description_all.csv'),sep=";") %>%
                  mutate(Code = as.character(Code))

##unique pcb_congeners
pcb_congener = read.csv(file.path(dir_con, 'raw_prep/ICES_herring_pcb_dowload_22april2016_cleaned.csv'),sep=";") %>%
  select(PARAM) %>%
  distinct(.) %>%
  filter(grepl("CB",PARAM))%>%
  mutate(PARAM = as.character(PARAM))
pcb_congener


#unique dixoin congeners
diox_congener = read.csv(file.path(dir_con, '/raw_prep/ICES_herring_dioxin_download_11may2016_cleaned.csv'),
         sep=";")%>%
  select(PARAM) %>%
  distinct(.) %>%
  filter(grepl(c("CD|TC"),PARAM))%>%
  mutate(PARAM = as.character(PARAM))
diox_congener


congeners = bind_rows(pcb_congener,diox_congener) %>%
            left_join(.,congener_descrip, by=c("PARAM" = "Code")) %>%
            select(PARAM, Description,Deprecated) %>%
            mutate(Deprecated = as.character(Deprecated))%>%
            filter(Deprecated == " False") %>% ## removes PCB, and SCB which we do not use and are deprecated
            select(-Deprecated) %>%
            filter(PARAM != "SCB7") %>% ## remove, this is a summary value
            dplyr::rename(congener = PARAM,
                          congener_full = Description)%>%
            arrange(congener)

congeners %>% print(n=35)

write.csv(congeners,file.path(dir_con, "ices_congeners.csv"))

