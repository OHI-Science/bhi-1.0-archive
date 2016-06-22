ico\_prep
================

Prepare Iconic Species data layer for goal Sense of Place
=========================================================

``` r
## Libraries
library(readr)
```

    ## Warning: package 'readr' was built under R version 3.2.4

``` r
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(tidyr)
library(ggplot2)
```

    ## Warning: package 'ggplot2' was built under R version 3.2.4

``` r
library(RMySQL)
```

    ## Loading required package: DBI

``` r
library(stringr)
library(tools)
library(rprojroot) # install.packages('rprojroot')
```

    ## Warning: package 'rprojroot' was built under R version 3.2.4

``` r
## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')

## rprojroot
root <- rprojroot::is_rstudio_project


## make_path() function to 
make_path <- function(...) rprojroot::find_root_file(..., criterion = is_rstudio_project)



dir_layers = make_path('baltic2015/layers') # replaces  file.path(dir_baltic, 'layers')


# root$find_file("README.md")
# 
# root$find_file("ao_need_gl2014.csv")
# 
# root <- find_root_file("install_ohicore.r", 
# 
# withr::with_dir(
#   root_file("DESCRIPTION"))


dir_ico    = file.path(dir_prep, 'ICO')

## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_ico, 'ico_prep.rmd')
```

1. Background
-------------

2. Data
-------

### 2.1 Data sources

HELCOM provides species checklists for the Baltic that include distribution and a complete list of all species assessed with IUCN criteria.
*Pros for using these <data:*>
Much more representative set of species included for Baltic Sea biodiversity.
*Cons for using these <data:*>
Distribution is provided for most taxa groups at the basin scale - coaser resolution for calculation. Bird distribution is only by country (Germany has a couple of regions), therefore, will need additional expert information to allocate to basin or all bird species associated with a country will be allocated to all a country's BHI regions.

[HELCOM species checklists](http://helcom.fi/baltic-sea-trends/biodiversity/red-list-of-species) (see bottom right of page for links to excel sheets) were downloaded on 14 June 2016

Joni Kaitaranta (HELCOM) emailed the complete list of species assessed using IUCN red list criteria on 14 June 2016.

### 2.2 Data folder for raw data

These data are in the folder 'SPP/data\_checklist\_redlist'

### 2.3 Data for ICO

Data in the folder 'ICO/data\_database' were exported from the [spp\_prep.rmd](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/SPP/spp_prep.md) in Section 5.6.2

### 2.4 Selecting ICO species

Iconic fish and mammals species have been selected to represent ICO. When bird species have distributions by basin (rather than country), ICO can be updated to include those. Included species are: - Cod
- Flounder
- Herring
- Perch
- Pike
- Salmon
- Trout
- Sprat
- grey seal / gray seal
- European otter / Euraisan otter
- harbour seal / common seal
- harbour porpoise
- ringed seal

### References for Redlist criteria / threat levels

[HELCOM Red List](http://www.helcom.fi/baltic-sea-trends/biodiversity/red-list-of-species) based on [IUCN criteria.](http://www.iucnredlist.org/technical-documents/categories-and-criteria).

**Threat categories** *Evaluated species* Extinct (EX)
Regionally Extinct (RE)
Extinct in the Wild (EW)
Critically Endangered (CR) Endangered (EN)
Vulnerable (VU)
Near Threatened (NT)
Least Concern (LC) Data Deficient (DD) Not Applicable (NA)
*Not-evaluated species* Not Evaluated (NE)

3. Goal model
-------------

This goal model is similar to the SPP goal model, but for the select group of ICO species.

Xico\_basin = 1- sum\[wi\]/R

wi = threat weights for each species i present in each basin R = total number of species in each basin
(eg. score equals 1 when all species i have wi of LC)

Scale min value = score is 0 when 75% of species are extinct.\*
\*From Halpern et al 2012, SI. "We scaled the lower end of the biodiversity goal to be 0 when 75% species are extinct, a level comparable to the five documented mass extinctions"

wi from Halpern et al 2012, SI EX = 1.0
CR = 0.8
EN = 0.6
VU = 0.4
NT = 0.2
LC = 0 DD = not included, "We did not include the Data Deficient classification as assessed species following previously published guidelines for a mid-point approach"

4. Prepare ICO data layer
-------------------------

### 4.1 Data organization

#### 4.1.1 Read in Data

``` r
## read in data...
spp_dist_vuln = read.csv(file.path(dir_ico,'data_database/checklist_redlist_data_for_status.csv'), stringsAsFactors = FALSE)

dim(spp_dist_vuln)
```

    ## [1] 25771     7

``` r
str(spp_dist_vuln)
```

    ## 'data.frame':    25771 obs. of  7 variables:
    ##  $ taxa_group             : chr  "breeding birds" "breeding birds" "breeding birds" "breeding birds" ...
    ##  $ latin_name             : chr  "Actitis hypoleucos" "Alca torda" "Anas clypeata" "Anas platyrhynchos" ...
    ##  $ common_name            : chr  NA NA NA NA ...
    ##  $ helcom_category        : chr  "NT" "LC" "LC" "LC" ...
    ##  $ helcom_category_numeric: num  0.2 0 0 0 0 0 0 0 0.4 0.2 ...
    ##  $ basin                  : chr  NA NA NA NA ...
    ##  $ presence               : int  NA NA NA NA NA NA NA NA NA NA ...

``` r
ico_spp_list = read.csv(file.path(dir_ico,'data_database/ico_species_selection_fish_mammals.csv'),sep=";", stringsAsFactors = FALSE)

dim(ico_spp_list) #13  2
```

    ## [1] 13  2

``` r
str(ico_spp_list)
```

    ## 'data.frame':    13 obs. of  2 variables:
    ##  $ common_name: chr  "Cod" "Flounder" "Herring" "Perch" ...
    ##  $ latin_name : chr  "Gadus morhua" "Platichthys flesus" "Clupea harengus" "Perca fluviatilis" ...

#### 4.1.2 Select ICO species from spp\_dist\_vuln

``` r
ico_spp_data = left_join(ico_spp_list,spp_dist_vuln,
                         by=c("latin_name","common_name"))

dim(ico_spp_data) #224   7
```

    ## [1] 224   7

``` r
ico_spp_data %>% select(common_name)%>%distinct()%>%nrow() #13
```

    ## [1] 13

#### 4.1.3 Plot ICO species by basin

Small difference in species presence/absence by basin

``` r
ggplot(ico_spp_data)+
  geom_point(aes(common_name,presence, colour=helcom_category))+
  facet_wrap(~basin)+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("Presence/Absence of ICO species by basin")
```

![](ico_prep_files/figure-markdown_github/plot%20ico%20species%20by%20basin-1.png)<!-- -->

### 4.2 Calculate status

#### 4.2.1 Calculate status by basin

``` r
sum_wi_basin =ico_spp_data %>%
              select(basin,helcom_category_numeric)%>%
              dplyr::rename(weights=helcom_category_numeric)%>%
              group_by(basin)%>%
              summarise(sum_wi =sum(weights))%>%
              ungroup()
dim(sum_wi_basin) #17 2
```

    ## [1] 17  2

``` r
## count the number of species in each BHI region
sum_spp_basin = ico_spp_data %>%
                filter(presence != 0) %>% # select only present taxa
                select(basin, latin_name)%>%
                dplyr::count(basin)
dim(sum_spp_basin) #17 2
```

    ## [1] 17  2

``` r
ico_status_basin = full_join(sum_wi_basin,sum_spp_basin, by="basin") %>%
             mutate(wi_spp = sum_wi/n,
                    status = 1 - wi_spp)
```

##### 4.2.2 Scale lower end to zero if 75% extinct

Currently, species are labled regionally extinct

``` r
## calculate percent extinct in each region
spp_ex_basin = ico_spp_data  %>%
              filter(presence != 0) %>% # select only present taxa
              dplyr::rename(weights=helcom_category_numeric)%>%## remove birds
              filter(weights == 1)
spp_ex_basin
```

    ## [1] common_name     latin_name      taxa_group      helcom_category
    ## [5] weights         basin           presence       
    ## <0 rows> (or 0-length row.names)

``` r
## which are RE (regionally extinct)
##None are regionally extinct


##total extinct per basin

# spp_ex_basin_n = spp_ex_basin %>%
#                   select(basin,latin_name)%>%
#                   dplyr::count(basin)%>%
#                   dplyr::rename(n_extinct = n)

    ## because none are extinct, do not use code above, instead use

    spp_ex_basin_n =ico_spp_data  %>%
                    select(basin)%>%
                    distinct()%>%
                    mutate(n_extinct=0)

## join to basin status
ico_status_basin = ico_status_basin %>%
                   full_join(.,spp_ex_basin_n, by="basin") %>%
                   mutate(n_extinct = ifelse(is.na(n_extinct),0,n_extinct))

## calculated the % extinct in each basin. if >75% then status score is 0
ico_status_basin =ico_status_basin %>%
                  mutate(prop_extinct = n_extinct / n,
                         status = ifelse(prop_extinct>=0.75, 0, status))
```

#### 4.2.3 Plot status by basin

``` r
## Plot status
ggplot(ico_status_basin)+
  geom_point(aes(basin,round(status*100)),size=3)+
  ylim(0,100)+
  ylab("Status") + 
  xlab("Basin")+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("ICO status by Basin")
```

![](ico_prep_files/figure-markdown_github/plot%20ico%20basin%20status-1.png)<!-- -->

``` r
## Size points to number of species in a region
ggplot(ico_status_basin)+
  geom_point(aes(basin,round(status*100), size=n))+
  ylim(0,100)+
  ylab("Status") + 
  xlab("Basin")+
  scale_size(breaks =c(10,11,12), labels=c("10","11","12"), range=c(2,4))+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y =  element_text(colour="grey20",size=6))+
  ggtitle("ICO status by Basin, n= species richness")
```

![](ico_prep_files/figure-markdown_github/plot%20ico%20basin%20status-2.png)<!-- -->

### 4.3 Apply basin status to BHI regions

#### 4.3.1 Load BHI region basin lookup

``` r
## read in basin BHI region lookup

basin_lookup = read.csv(file.path(dir_ico,'bhi_basin_country_lookup.csv'),sep=";")%>%
                select(Subbasin,BHI_ID)%>%
                dplyr::rename(basin = Subbasin,
                              rgn_id = BHI_ID)
```

#### 4.3.2 Join lookup to status

``` r
ico_status = ico_status_basin %>%
             full_join(.,basin_lookup, by="basin")
```

    ## Warning in outer_join_impl(x, y, by$x, by$y): joining factor and character
    ## vector, coercing into character vector

``` r
ico_status = ico_status %>%
             select(rgn_id,status,n)

dim(ico_status)
```

    ## [1] 42  3

#### 4.3.3 Plot BHI region status

``` r
## Size points to number of species in a region
ggplot(ico_status)+
  geom_point(aes(rgn_id,round(status*100), size=n))+
  ylim(0,100)+
  ylab("Status") + 
  xlab("BHI region")+
  scale_size(breaks =c(10,11,12), labels=c("10","11","12"), range=c(2,4))+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y =  element_text(colour="grey20",size=6))+
  ggtitle("ICO status by BHI region, n= species richness")
```

![](ico_prep_files/figure-markdown_github/plot%20BHI%20region%20status-1.png)<!-- -->

5. ICO trend
------------

We have no trend for ICO at the moment - will set to NA in functions.r

6. Data layers for layers folder
--------------------------------

``` r
## ICO status
ico_status = ico_status %>%
             select(rgn_id, status)%>%
             dplyr::rename(score=status)


## write csv to layers
write.csv(ico_status, file.path(dir_layers,'ico_status_bhi2015.csv'),row.names=FALSE)
```
