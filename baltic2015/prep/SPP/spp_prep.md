spp\_prep
================

Preparation of SPP data layers
------------------------------

**For Biodiverity goal**

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



dir_spp    = file.path(dir_prep, 'SPP')

## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_spp, 'spp_prep.rmd')
```

1. Background and Overview
--------------------------

### 1.1

"People value biodiversity in particular for its existence value. The risk of species extinction generates great emotional and moral concern for many people."

### 1.2 References

[Halpern et al. 2012. An index to assess the health and benefits of the global ocean. Nature 488: 615-620](http://www.nature.com/nature/journal/v488/n7413/full/nature11397.html)

[HELCOM Red List](http://www.helcom.fi/baltic-sea-trends/biodiversity/red-list-of-species) based on [IUCN criteria.](http://www.iucnredlist.org/technical-documents/categories-and-criteria).

**Threat categories** *Evaluated species* Extinct (EX)
Regionally Extinct (RE)
Extinct in the Wild (EW)
Critically Endangered (CR) Endangered (EN)
Vulnerable (VU)
Near Threatened (NT)
Least Concern (LC) Data Deficient (DD) Not Applicable (NA)
*Not-evaluated species* Not Evaluated (NE)

2. Data Extraction and Prep
---------------------------

Two different data sources and goal calculation approaches are explored. **Option 1**
HELCOM has spatial occurrence data layers for species and species are given an IUCN threat category.
*Pros for using these <data:*>
Data are spatially explicit, can score presence absence for each BHI region.
*Cons for using these <data:*>
These represent a very limited number of species in the Baltic (125 total) with the selection criteria being those with a spatial data layer in HELCOM. Many more species have been assessed using the IUCN criteria by HELCOM.

**Option 2** HELCOM provides species checklists for the Baltic that include distribution and a complete list of all species assessed with IUCN criteria.
*Pros for using these <data:*>
Much more representative set of species included for Baltic Sea biodiversity.
*Cons for using these <data:*>
Distribution is provided for most taxa groups at the basin scale - coaser resolution for calculation. Bird distribution is only by country (Germany has a couple of regions), therefore, will need additional expert information to allocate to basin or all bird species associated with a country will be allocated to all a country's BHI regions.

### 2.1 Data sources and information for HELCOM spatial data

Data extraction and prep was done by Melanie Frazer

#### 2.1.1 Data Sources

Species coverage and threat level data were obtained from the [HELCOM Biodiversity Map Service](http://maps.helcom.fi/website/Biodiversity/index.html) under 'Biodiversity' and then under 'Red List'.

Data were download in March 2016.

#### 2.1.2 Data extraction

Different taxa groups have different file types (grid files, polygons). Each species has a threat level assigned. Melanie worked to align taxa and species to BHI regions and assign the vulnerability code.

Folders associated with these data are:
- data
- intermediate
\_ raw

Scripts associated with these data are: - benthic\_extract.R
- bird\_data\_extract.R
- fish\_extract.R
- macrophyte\_extract.R
- mammal\_extract.R
- taxa\_combine.R

Melanie's notes on the data extraction process are below.

#### 2.1.3 Notes

##### 2.1.3.1 General Notes

**SPP data** For groups on the HELCOM grid (benthos): there is a key (prep/spatial/helcom\_to\_rgn\_bhi\_sea.csv) that translates the grid cells into baltic regions. The key was created using this script: prep/spatial/HELCOM\_2\_baltic.R.

For groups associated to HELCOM subbasin: this key was used to translate subbasins into baltic regions: prep/baltic\_rgns\_to\_bhi\_rgns\_lookup\_holas.csv

Helcom species data downloaded from here: <http://maps.helcom.fi/website/Biodiversity/index.html> I added some subbasins to these data based on emails from Mar 21 email from Marc and Lena The data I added is incomplete.

The taxa\_combine.R combines the 5 taxonomic groups: benthos, birds, fish, mammals, macrophytes into a single data frame.

To calculate the SPP score, the IUCN codes will be converted to numeric scores and then averaged within each region.

To calculate the ICO score, the species will be subset based on what is considered an iconic species and then the IUCN codes will be converted to numeric scores, and than averaged within each region.

##### 2.1.3.2 Benthic data

Weird thing: you can download a map for each species, but all the species are included in each file. The only difference is that there is a unique html downloaded from IUCN for the species in question.

These data are in the format of polygons that are functionally rasters.

The corresponding benthic dbf file is saved as csv: benthos\_spatial\_data.csv

Painstakingly made a file to match the names in .shp file with the species names and vulnerability: benthic\_species.csv

##### 2.1.3.3 Bird data

There was no combined Helcom spatial file for birds (like there was for the benthic data).

One complication was that some species had data in the format of the "raster-style" polygons. While others were actual range polygons.

Given this, each bird spatial file was opened and then the range polygons were overlapped with the bhi regions.

NOTE: one bird species fell out of the bhi polygon areas and was excluded. I would probably ignore....but it might be worth figuring out.

The spatial files downloaded from Helcom are located here: /var/data/ohi/git-annex/Baltic/spp/Birds

The script used to open each bird file and associate the polygons with BHI regions is: bird\_data\_extract.R

The extracted bird data is here: intermediate/birds.csv

##### 2.1.3.4 Mammal data

There is a combined file for mammals. The ranges are described using polygons that relate to subbasins.

Some species have multiple IUCN categories (probably due to subspecies) It would be ideal if we know which categories correspond to which regions, but these data are not available. two possible options are: 1. average them 2. use the most conservative option I am going with \#2 for now, but this would be easy to change (code in mammal\_extract.R).

The script used to extract the data was: mammal\_extract.R The extracted mammal data are here: intermediate/mammals.R

##### 2.1.3.5 Fish data

There is a combined file for fish. The range data are polygons that correspond to subbasins.

##### 2.1.3.6 Macrophyte data

N=17 datapoints fell outside the water. This could probably be corrected by extracting the CELLCODES that land inland with some buffer.
Don't know if this is worth the effort...

### 2.2 Data sources and information for checklist data

#### 2.2.1 Data sources

[HELCOM species checklists](http://helcom.fi/baltic-sea-trends/biodiversity/red-list-of-species) (see bottom right of page for links to excel sheets) were downloaded on 14 June 2016

Joni Kaitaranta (HELCOM) emailed the complete list of species assessed using IUCN red list criteria on 14 June 2016.

#### 2.2.2 Data folder

These data are in the folder 'SPP/data\_checklist\_redlist'

#### 2.2.3 Data treatment for presence/absence

Difference taxa groups had different levels and categorization of presence/absence. This is what is included as presence for BHI from the checklist.
*Breeding birds* presence = 'breeding' *Fish* presence = 'regular reproduction' or 'regular occurence, no reproduction'
*Macrophyte* presence = 'X'
*Mammal* presence = 'X'
*Invert* presence = 'X'

#### 2.2.4 Other notes

1.  Breeding birds list noted species that used to be present but are extinct in a separate category - identified as 0
2.  Fish are all occurrences since 1800 - so could have many temporary or extinct sp, Extinction not noted, exclude those labeled temporary.
3.  Macrophytes, Mammals, Inverts only have either X or blank.
4.  Macrophytes spp have many synonym names, manually combined so only the main latin name has all presence/absence occurences for all synonyms.

3. Goal status and trend
------------------------

BD goal will only be based on the SPP sub-component

### 3.1 Goal status

Xspp\_r = 1- sum\[wi\]/R; wi = threat weights for each species i, R = total number of species in BHI region r
Ref pt = R (eg. score equals 1 when all species i have wi of LC)
Scale min value = score is 0 when 75% of species are extinct.\*
\*From Halpern et al 2012, SI. "We scaled the lower end of the biodiversity goal to be 0 when 75% species are extinct, a level comparable to the five documented mass extinctions"

wi from Halpern et al 2012, SI EX = 1.0
CR = 0.8
EN = 0.6
VU = 0.4
NT = 0.2
LC = 0 DD = not included, "We did not include the Data Deficient classification as assessed species following previously published guidelines for a mid-point approach"

**Will do above calculation for basin, not BHI region if use checklist distributions**

### 3.2 Goal trend

TBD

Two alternative data sources and status calculations follow. Need to assess which is best.
==========================================================================================

4. Spatial data data layer preparation
--------------------------------------

### 4.1 Data organization

#### 4.1.1 Read in species data

``` r
## read in data...
data = read.csv(file.path(dir_spp, 'data/species_IUCN.csv'))
dim(data)
```

    ## [1] 2340    4

``` r
str(data)
```

    ## 'data.frame':    2340 obs. of  4 variables:
    ##  $ rgn_id      : int  2 1 5 6 32 40 38 36 42 3 ...
    ##  $ species_name: Factor w/ 154 levels "Abra prismatica",..: 1 1 1 1 2 2 2 2 2 4 ...
    ##  $ IUCN        : Factor w/ 6 levels "CR","DD","EN",..: 6 6 6 6 2 2 2 2 2 5 ...
    ##  $ taxa        : Factor w/ 5 levels "benthos","birds",..: 1 1 1 1 1 1 1 1 1 1 ...

#### 4.1.2 Set up vulnerability code

``` r
vuln_lookup = data %>%
              select(IUCN)%>%
              distinct(.) %>% ## unique vulnerability codes
              mutate(IUCN_numeric = ifelse(IUCN == 'EX',1,
                                    ifelse(IUCN == 'CR',0.8,
                                    ifelse(IUCN == 'EN', 0.6,
                                    ifelse(IUCN == 'VU', 0.4,
                                    ifelse(IUCN == 'NT', 0.2,
                                    ifelse(IUCN == 'LC',0,NA))))))) ## DD will receive NA
vuln_lookup ## note, no species with EX
```

    ##   IUCN IUCN_numeric
    ## 1   VU          0.4
    ## 2   DD           NA
    ## 3   NT          0.2
    ## 4   EN          0.6
    ## 5   LC          0.0
    ## 6   CR          0.8

#### 4.1.3 Join numeric vulnerability code to species

``` r
data2 = data %>%
        left_join(.,vuln_lookup, by= "IUCN")
head(data2)
```

    ##   rgn_id            species_name IUCN    taxa IUCN_numeric
    ## 1      2         Abra prismatica   VU benthos          0.4
    ## 2      1         Abra prismatica   VU benthos          0.4
    ## 3      5         Abra prismatica   VU benthos          0.4
    ## 4      6         Abra prismatica   VU benthos          0.4
    ## 5     32 Agrypnetes crassicornis   DD benthos           NA
    ## 6     40 Agrypnetes crassicornis   DD benthos           NA

#### 4.1.4 Plot by region

``` r
ggplot(data2)+
  geom_point(aes(rgn_id, species_name),size=1)+
  facet_wrap(~IUCN)+
  theme(axis.text.y = element_text(colour="grey20", size=2, angle=0, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle ("Species presence and vulnerability by region")
```

![](spp_prep_files/figure-markdown_github/plot%20raw%20by%20region-1.png)<!-- -->

``` r
ggplot(data2)+
  geom_point(aes(rgn_id, species_name, colour=taxa),size=1)+
  facet_wrap(~IUCN)+
  theme(axis.text.y = element_text(colour="grey20", size=2, angle=0, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle ("Species presence and vulnerability by region")
```

![](spp_prep_files/figure-markdown_github/plot%20raw%20by%20region-2.png)<!-- -->

#### 4.1.5 Distribution in IUCN categories

Benthos & macrophytes have many more DD

``` r
## how many in each category from each taxa group?
percent_vuln = data2 %>% 
  select(-rgn_id)%>%
  distinct()%>%
  select(IUCN,taxa) %>% 
  count(taxa,IUCN) %>%
  group_by(taxa)%>%
  mutate(n_tot = sum(n))%>%
  ungroup()%>%
  mutate(percent = round(n/n_tot,2)*100)%>%
  print(n=24)
```

    ## Source: local data frame [24 x 5]
    ## 
    ##           taxa   IUCN     n n_tot percent
    ##         (fctr) (fctr) (int) (int)   (dbl)
    ## 1      benthos     DD    23    54      43
    ## 2      benthos     EN     1    54       2
    ## 3      benthos     LC     4    54       7
    ## 4      benthos     NT     8    54      15
    ## 5      benthos     VU    18    54      33
    ## 6        birds     CR     1    22       5
    ## 7        birds     EN     5    22      23
    ## 8        birds     LC     1    22       5
    ## 9        birds     NT     8    22      36
    ## 10       birds     VU     7    22      32
    ## 11        fish     CR     4    50       8
    ## 12        fish     EN     3    50       6
    ## 13        fish     LC    27    50      54
    ## 14        fish     NT     9    50      18
    ## 15        fish     VU     7    50      14
    ## 16 macrophytes     DD     6    23      26
    ## 17 macrophytes     EN     3    23      13
    ## 18 macrophytes     LC     6    23      26
    ## 19 macrophytes     NT     4    23      17
    ## 20 macrophytes     VU     4    23      17
    ## 21     mammals     CR     1     5      20
    ## 22     mammals     LC     1     5      20
    ## 23     mammals     NT     1     5      20
    ## 24     mammals     VU     2     5      40

``` r
ggplot(percent_vuln, aes(x=taxa, y=percent, fill=IUCN))+
  geom_bar(stat="identity")+
  ggtitle("Percent of species in each IUCN category")
```

![](spp_prep_files/figure-markdown_github/distribution%20in%20IUCN%20categories-1.png)<!-- -->

#### 4.1.6 Total number of species in each taxa group by IUCN categroy

``` r
ggplot(percent_vuln, aes(x=taxa, y=n, fill=IUCN))+
  geom_bar(stat="identity")+
  ggtitle("Number of species in each IUCN category")
```

![](spp_prep_files/figure-markdown_github/number%20of%20species%20in%20each%20taxa%20group-1.png)<!-- -->

``` r
ggplot(filter(percent_vuln, IUCN != "DD"), aes(x=taxa, y=n, fill=IUCN))+
  geom_bar(stat="identity")+
  ggtitle("Number of species in each IUCN category without DD")
```

![](spp_prep_files/figure-markdown_github/number%20of%20species%20in%20each%20taxa%20group-2.png)<!-- -->

#### 4.1.7 Remove DD species

Species given DD are not included. See methods above and in Halpern et al. 2012

Benthos has a much larger number of species in DD category

``` r
data3 = data2 %>%
        filter(IUCN != "DD")
dim(data3);dim(data2)
```

    ## [1] 2205    5

    ## [1] 2340    5

#### 4.1.8 Check for duplicates

``` r
data3 %>% nrow() #2205
```

    ## [1] 2205

``` r
data3 %>% distinct() %>% nrow() #2096
```

    ## [1] 2096

``` r
## appears to be duplicates

##remove duplicates by selecting the distinct columns
data3 = data3 %>% 
        arrange(rgn_id,species_name) %>%
        distinct()
        
dim(data3) #2096
```

    ## [1] 2096    5

#### 4.1.7 Export Species list

Export species list to be check to see if sufficient coverage

``` r
species_list = data3 %>%
              select(species_name,taxa)%>%
              distinct(.)
dim(species_list) #125  1
```

    ## [1] 125   2

``` r
write.csv(species_list, file.path(dir_spp,'species_list_included.csv'), row.names=FALSE)
```

### 4.2 Data layer for functions.r

``` r
data3 = data3 %>%
        select(rgn_id, species_name, IUCN_numeric) %>%
        dplyr::rename(weights = IUCN_numeric)
##write.csv(data3, file.path(dir_layers, 'spp_div_vuln_bhi2015.csv'), row.names=FALSE)
```

### 4.3 Status calcalculation

#### 4.3.1 Calculate status

``` r
##sum the weights for each BHI region
sum_wi = data3 %>%
         group_by(rgn_id)%>%
         summarise(sum_wi =sum(weights))%>%
         ungroup()
dim(sum_wi)
```

    ## [1] 42  2

``` r
## count the number of species in each BHI region
sum_spp = data3 %>%
          select(rgn_id, species_name)%>%
          dplyr::count(rgn_id)
dim(sum_spp)
```

    ## [1] 42  2

``` r
data3%>% filter(rgn_id== 1) %>% nrow() ## check to make sure works
```

    ## [1] 83

``` r
head(sum_spp)
```

    ## Source: local data frame [6 x 2]
    ## 
    ##   rgn_id     n
    ##    (int) (int)
    ## 1      1    83
    ## 2      2    87
    ## 3      3    60
    ## 4      4    45
    ## 5      5    72
    ## 6      6    71

``` r
spp_status = full_join(sum_wi,sum_spp, by="rgn_id") %>%
             mutate(wi_spp = sum_wi/n,
                    status = 1 - wi_spp)
```

#### 4.3.2 Scale lower end to zero if 75% extinct

Currently, no species labeled extinct but will set up code in case used in the future

``` r
## calculate percent extinct in each region
spp_ex = data3 %>% 
         filter(weights == 1)
spp_ex
```

    ## [1] rgn_id       species_name weights     
    ## <0 rows> (or 0-length row.names)

``` r
## No species extinct
## IF spp are extinct, find % extinct out of total number of species for each region; join to the status calculation; set regions with 75% or more extinct to a score of 0
```

#### 4.3.3 Plot status

**BHI region map for reference**: ![alt text](~github/bhi/baltic2015/prep/LSP.BHI_ID_HOLAS_EEZ.png)

``` r
## Plot status
ggplot(spp_status)+
  geom_point(aes(rgn_id,round(status*100)),size=3)+
  ylim(0,100)+
  ylab("Status") + 
  xlab("BHI region")+
  ggtitle("SPP status by BHI region")
```

![](spp_prep_files/figure-markdown_github/plot%20spp%20status-1.png)<!-- -->

``` r
## Size points to number of species in a region
ggplot(spp_status)+
  geom_point(aes(rgn_id,round(status*100), size=n))+
  ylim(0,100)+
  ylab("Status") + 
  xlab("BHI region")+
  ggtitle("SPP status by BHI region, n= species richness")
```

![](spp_prep_files/figure-markdown_github/plot%20spp%20status-2.png)<!-- -->

5. Data layer preparation with checklist distribution data
----------------------------------------------------------

### 5.1 Data organization

#### 5.1.1 Read in data

``` r
bbirds = read.csv(file.path(dir_spp,'data_checklist_redlist/breedingbirds_dist_checklist.csv'), sep= ";", stringsAsFactors = FALSE)

fish = read.csv(file.path(dir_spp,'data_checklist_redlist/fish_dist_checklist.csv'), sep= ";", stringsAsFactors = FALSE)

invert = read.csv(file.path(dir_spp,'data_checklist_redlist/invert_dist_checklist.csv'), sep= ";", stringsAsFactors = FALSE)

macrophytes = read.csv(file.path(dir_spp,'data_checklist_redlist/macrophytes_dist_checklist.csv'), sep= ";", stringsAsFactors = FALSE)

mammals = read.csv(file.path(dir_spp,'data_checklist_redlist/mammals_dist_checklist.csv'), sep= ";", stringsAsFactors = FALSE)


redlist = read.csv(file.path(dir_spp,'data_checklist_redlist/helcom_redlist_allspecies.csv'), sep= ";", stringsAsFactors = FALSE)
```

#### 5.1.2 Data structure

``` r
str(bbirds)
```

    ## 'data.frame':    57 obs. of  13 variables:
    ##  $ latin_name                           : chr  "Actitis hypoleucos" "Alca torda" "Anas clypeata" "Anas platyrhynchos" ...
    ##  $ Sweden                               : chr  "X" "X" "X" "X" ...
    ##  $ Finland                              : chr  "X" "X" "X" "X" ...
    ##  $ Russia.St..Petersburg                : chr  "X" "X" "X" "X" ...
    ##  $ Russia.Kaliningrad                   : chr  "X" "-" "X" "X" ...
    ##  $ Estonia                              : chr  "X" "X" "X" "X" ...
    ##  $ Latvia                               : chr  "X" "-" "X" "X" ...
    ##  $ Lithuania                            : chr  "X" "-" "X" "X" ...
    ##  $ Poland                               : chr  "X" "-" "X" "X" ...
    ##  $ Germany.Mecklenburg.Western.Pomerania: chr  "X" "-" "X" "X" ...
    ##  $ Germany.Schleswig.Holstein           : chr  "(X)" "-" "X" "X" ...
    ##  $ Denmark                              : chr  "X" "X" "X" "X" ...
    ##  $ common_name                          : chr  "Common sandpiper" "Razorbill" "Northern shoveler" "Mallard" ...

``` r
str(fish)
```

    ## 'data.frame':    240 obs. of  23 variables:
    ##  $ latin_name            : chr  "Myxine glutinosa" "Lampetra fluviatilis" "Petromyzon marinus" "Lamna nasus" ...
    ##  $ Kattegat              : chr  "R" "X" "X" "T" ...
    ##  $ Great.Belt            : chr  "" "T" "T" "T" ...
    ##  $ Little.Belt           : chr  "" "T" "T" "T" ...
    ##  $ Kiel.Bay              : chr  "" "X" "T" "T" ...
    ##  $ Bay.of.Mecklenburg    : chr  "" "X" "T" "" ...
    ##  $ The.Sound             : chr  "" "X" "X" "T" ...
    ##  $ Arkona.Basin          : chr  "" "X" "T" "" ...
    ##  $ Bornholm.Basin        : chr  "" "X" "X" "" ...
    ##  $ Western.Gotland.Basin : chr  "" "X" "T" "" ...
    ##  $ Eastern.Gotland.Basin : chr  "" "X" "T" "" ...
    ##  $ Gulf.of.Gdansk        : chr  "" "X" "T" "" ...
    ##  $ Vistula.Lagoon        : chr  "" "X" "T" "" ...
    ##  $ Curonian.Lagoon       : chr  "" "X" "T" "" ...
    ##  $ Gulf.of.Riga          : chr  "" "X" "T" "" ...
    ##  $ Northern.Baltic.Proper: chr  "" "X" "" "" ...
    ##  $ Gulf.of.Finland       : chr  "" "X" "T" "" ...
    ##  $ Aland.Sea             : chr  "" "X" "T" "" ...
    ##  $ Archipelago.Sea       : chr  "" "X" "T" "T" ...
    ##  $ Bothnian.Sea          : chr  "" "X" "T" "" ...
    ##  $ The.Quark             : chr  "" "X" "T" "" ...
    ##  $ Bothnian.Bay          : chr  "" "X" "" "" ...
    ##  $ common_name           : chr  "Hagfish" "River lamprey" "Sea lamprey" "Porbeagle" ...

``` r
str(invert)
```

    ## 'data.frame':    1898 obs. of  34 variables:
    ##  $ latin_name            : chr  "Abietinaria abietina" "Ablabesmyia longistyla" "Ablabesmyia monilis" "Ablabesmyia phatta" ...
    ##  $ Kattegat              : chr  "X" "" "" "" ...
    ##  $ The.Sound             : chr  "X" "" "" "" ...
    ##  $ Little.Belt           : chr  "" "" "" "" ...
    ##  $ Great.Belt            : chr  "" "" "" "" ...
    ##  $ Kiel.Bay              : chr  "" "" "" "" ...
    ##  $ Bay.of.Mecklenburg    : chr  "X" "" "" "" ...
    ##  $ Arkona.Basin          : chr  "X" "" "" "" ...
    ##  $ Bornholm.Basin        : chr  "" "" "" "" ...
    ##  $ Eastern.Gotland.Basin : chr  "" "" "" "" ...
    ##  $ Western.Gotland.Basin : chr  "" "" "" "" ...
    ##  $ Northern.Baltic.Proper: chr  "" "" "" "" ...
    ##  $ Aland.Sea             : chr  "" "" "" "" ...
    ##  $ Archipelago.Sea       : chr  "" "" "" "" ...
    ##  $ Bothnian.Sea          : chr  "" "" "" "" ...
    ##  $ The.Quark             : chr  "" "" "X" "" ...
    ##  $ Bothnian.Bay          : chr  "" "" "" "" ...
    ##  $ Gulf.of.Finland       : chr  "" "X" "X" "X" ...
    ##  $ Gulf.of.Gdansk        : chr  "" "" "" "" ...
    ##  $ Gulf.of.Riga          : chr  "" "" "" "" ...
    ##  $ Warnow.Estuary        : chr  "" "" "" "" ...
    ##  $ Wismar.Bay            : chr  "" "" "" "" ...
    ##  $ Trave.Estuary         : chr  "" "" "" "" ...
    ##  $ Kiel.Fjord            : chr  "" "" "" "" ...
    ##  $ Eckernförde.Bay       : chr  "" "" "" "" ...
    ##  $ Schlei.Estuary        : chr  "" "" "" "" ...
    ##  $ Flensburg.Fjord       : chr  "" "" "" "" ...
    ##  $ Vistula.Lagoon        : chr  "" "" "" "" ...
    ##  $ Szczecin.Lagoon       : chr  "" "X" "" "" ...
    ##  $ Greifswald.Lagoon     : chr  "" "" "" "" ...
    ##  $ Rugia.Lagoons         : chr  "" "" "" "" ...
    ##  $ Darss.Zingst.Lagoon   : chr  "" "" "" "" ...
    ##  $ Curonian.Lagoon       : chr  "" "" "X" "" ...
    ##  $ common_name           : logi  NA NA NA NA NA NA ...

``` r
str(macrophytes)
```

    ## 'data.frame':    532 obs. of  19 variables:
    ##  $ latin_name              : chr  "Ranunculus trichophyllus subsp. Eradicatus" "Porphyridium aerugineum 3" "Rhynchostegium riparioides" "Potamogeton pectinatus agg." ...
    ##  $ Kattegat                : int  0 0 0 0 1 1 1 0 1 1 ...
    ##  $ Great.Belt...Little.Belt: int  0 0 0 0 1 1 1 0 1 0 ...
    ##  $ Kiel.Bay                : int  0 0 0 0 0 1 1 0 0 0 ...
    ##  $ Bay.of.Mecklenburg      : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ The.Sound               : int  0 0 0 0 1 1 1 0 1 0 ...
    ##  $ Arkona.Basin            : int  0 1 0 0 0 0 1 0 1 0 ...
    ##  $ Bornholm.Basin          : chr  "0" "0" "0" "0" ...
    ##  $ Western.Gotland.Basin   : int  0 0 0 0 0 0 1 0 0 0 ...
    ##  $ Eastern.Gotland.Basin   : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ Gulf.of.Gdansk          : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ Gulf.of.Riga            : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ Nothern.Baltic.Proper   : chr  "0" "0" "0" "0" ...
    ##  $ Gulf.of.Finland         : int  1 0 0 0 0 0 1 1 0 0 ...
    ##  $ Aland.Sea               : int  0 0 0 0 0 0 1 0 0 0 ...
    ##  $ Archipelago.Sea         : int  1 0 0 0 0 0 0 0 0 0 ...
    ##  $ Bothnian.Sea...The.Quark: int  1 0 0 1 0 1 1 0 0 0 ...
    ##  $ Bothnian.Bay            : int  1 0 1 1 0 0 0 0 0 0 ...
    ##  $ common_name             : logi  NA NA NA NA NA NA ...

``` r
str(mammals)
```

    ## 'data.frame':    5 obs. of  21 variables:
    ##  $ latin_name                : chr  "Halichoerus grypus" "Phoca vitulina vitulina" "Pusa hispida" "Phocoena phocoena" ...
    ##  $ Kattegatt                 : chr  "x" "x" "" "x" ...
    ##  $ Great.Belt                : chr  "" "x" "" "x" ...
    ##  $ Little.Belt               : chr  "" "x" "" "x" ...
    ##  $ Kiel.Bay                  : chr  "x" "x" "" "x" ...
    ##  $ The.Bay.of.Mecklenburg    : chr  "x" "x" "" "x" ...
    ##  $ The.Sound                 : chr  "x" "x" "" "x" ...
    ##  $ Arkona.Basin              : chr  "x" "x" "" "x" ...
    ##  $ Bornholm.Basin            : chr  "x" "x" "" "x" ...
    ##  $ The.Eastern.Gotland.Basin : chr  "x" "" "" "x" ...
    ##  $ The.Western.Gotland.Basin : chr  "x" "" "" "x" ...
    ##  $ The.Northern.Baltic.Proper: chr  "x" "" "x" "x" ...
    ##  $ The.Gulf.of.Gda.sk        : chr  "x" "x" "" "x" ...
    ##  $ Gulf.of.Riga              : chr  "x" "" "x" "x" ...
    ##  $ Gulf.of.Finland           : chr  "x" "" "x" "x" ...
    ##  $ Archipelago.Sea           : chr  "x" "" "x" "x" ...
    ##  $ Aland.Sea                 : chr  "x" "" "x" "x" ...
    ##  $ The.Bothnian.Sea          : chr  "x" "" "x" "x" ...
    ##  $ The.Quark                 : chr  "x" "" "x" "" ...
    ##  $ Bothnian.Bay              : chr  "x" "" "x" "" ...
    ##  $ common_name               : chr  "grey seal / gray seal" "harbour seal / common seal" "ringed seal " "harbour porpoise" ...

``` r
str(redlist)
```

    ## 'data.frame':    2809 obs. of  5 variables:
    ##  $ latin_name     : chr  "Aglaothamnion bipinnatum Feldmann-Mazoyer 1941" "Actitis hypoleucos (Linnaeus, 1758)" "Nephasoma (Nephasoma) abyssorum abyssorum" "Ranunculus trichophyllus subsp. eradicatus" ...
    ##  $ assessment_unit: chr  "Species" "Breeding" "Species" "Species" ...
    ##  $ helcom_category: chr  "LC" "NT" "LC" "LC" ...
    ##  $ iucn_criteria  : chr  "" "A2ab" "" "" ...
    ##  $ taxa_group     : chr  "macrophytes" "breeding birds" "invert" "macrophytes" ...

#### 5.1.3 Translate code to presence/absence

Objective is to get a data layer of current species occurence.

Each taxa group has a different code for noting distribution in different regions. Translate to a 1 or 0 for presence absence then gather to long format

##### 5.1.3.1 Breeding birds

X = breeding
(X) = sporadic breeding (only occasional breeding records)
0 = extinct (breeding in the past, but no actual breeding records)
0 = sporadic breeder in the past, no breeding records during the last 3 generations or 10 years
0(X) = extinct as a regular breeder, but sporadic breeding records during the last 3 generations or 10 years
- = no breeding birds

**For BHI:** *X = 1* and *all others = 0*

``` r
## gather birds to long format
bbirds_long = bbirds %>%
              gather(location,presence,-latin_name,-common_name)%>%
              mutate(presence = ifelse(presence == "X", 1, 0))%>% ##change X to present (1) all else absent (0)
              mutate(taxa_group = "breeding birds")
```

##### 5.1.3.2 Fish and Lamprey

R = regular reproduction
X = regular occurrrence, no reproduction
T = temporary occurrence
? = occurrance uncertain

**For BHI:** *R or X = 1* and *T or ? = 0*

``` r
## clean up fish data (had ? not removed), gather to long format
fish_long = fish %>%
            mutate(latin_name =str_replace(latin_name,"\\*",""))%>% ## remove * at end of latin name
            gather(location,presence,-latin_name,-common_name)%>%
            mutate(presence = ifelse(presence == "R", 1, 
                              ifelse(presence == "X", 1, 0)))%>%
            mutate(taxa_group = "fish")
```

##### 5.1.3.3 Invertebrates

X = ocurrance
'blank' = no occurance

**For BHI:** *X = 1* and *blank = 0*

``` r
## gather invert  to long format
invert_long = invert %>%
              gather(location,presence,-latin_name,-common_name)%>%
              mutate(presence = ifelse(presence == "X", 1, 0))%>% 
              mutate(taxa_group = "invert")
```

##### 5.1.3.4 Macrophytes

1 = occurance 0 = no occurance uncertain = had a note in checklist about checking the distribution
**For BHI:** *X = 1* and *0 and uncertain = 0*

``` r
##gather macrophytes to long format
macrophytes_long = macrophytes %>%
                    gather(location,presence,-latin_name,-common_name)%>%
                    mutate(presence = ifelse(presence == "uncertain", 0, presence),
                           presence = as.numeric(presence))%>% 
                    mutate(taxa_group = "macrophytes")
```

##### 5.1.3.5 Mammals

X = ocurrance
'blank' = no occurance

**For BHI:** *X = 1* and *blank = 0*

``` r
##gather mammals to long format
mammals_long = mammals %>%
               gather(location,presence,-latin_name,-common_name)%>%
               mutate(presence = ifelse(presence == "x", 1, 0))%>% 
               mutate(taxa_group = "mammals")
```

### 5.2 Data attributes

#### 5.2.1 Get number of species by taxa group

2731 total unique latin names

``` r
species_checklist = bind_rows(select(bbirds_long,latin_name,taxa_group),
                         select(fish_long,latin_name,taxa_group),
                         select(invert_long,latin_name,taxa_group),
                         select(macrophytes_long,latin_name,taxa_group),
                         select(mammals_long,latin_name,taxa_group))%>%
                         distinct()

species_checklist_n = species_checklist %>%
                      count(taxa_group)

ggplot(species_checklist, aes(x=taxa_group))+
   geom_bar(stat="count")+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("Number of species in the checklist")
```

![](spp_prep_files/figure-markdown_github/species%20and%20taxa%20group%20checklist-1.png)<!-- -->

``` r
## number of unique latin names
species_checklist %>% select(latin_name)%>%distinct()%>%nrow() #2731
```

    ## [1] 2731

``` r
##add list_type
species_checklist = species_checklist%>%
                    mutate(list_type = "checklist")
```

#### 5.2.2 Get number of species by taxa group on the red list

2772 on redlist
Need to see how many are assessed.

``` r
str(redlist)
```

    ## 'data.frame':    2809 obs. of  5 variables:
    ##  $ latin_name     : chr  "Aglaothamnion bipinnatum Feldmann-Mazoyer 1941" "Actitis hypoleucos (Linnaeus, 1758)" "Nephasoma (Nephasoma) abyssorum abyssorum" "Ranunculus trichophyllus subsp. eradicatus" ...
    ##  $ assessment_unit: chr  "Species" "Breeding" "Species" "Species" ...
    ##  $ helcom_category: chr  "LC" "NT" "LC" "LC" ...
    ##  $ iucn_criteria  : chr  "" "A2ab" "" "" ...
    ##  $ taxa_group     : chr  "macrophytes" "breeding birds" "invert" "macrophytes" ...

``` r
ggplot(redlist, aes(x=taxa_group))+
   geom_bar(stat="count")+
   theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("Number of species in the redlist")
```

![](spp_prep_files/figure-markdown_github/number%20species%20redlist-1.png)<!-- -->

``` r
## number of unique latin names
redlist %>% select(latin_name)%>%distinct()%>%nrow() #2772
```

    ## [1] 2772

``` r
## add list_type column

redlist = redlist %>%
          mutate(list_type = "redlist")
```

#### 5.2.3 Get a species list that is all those present on the red list and check list

1.  First join and retain all species to see if spelling causes any mismatches.
2.  Retain only species on both lists, join by taxa group and latin name.

**What is not present** *Not on Redlist* 343 species on checklist not on redlist.
1. No wintering birds in the checklist.

##### 5.2.3.1 Full species list

``` r
full_species = full_join(species_checklist,redlist, by=c("latin_name","taxa_group"))%>%
                  select(-iucn_criteria)%>%
                  mutate(helcom_category = as.character(helcom_category))
dim(full_species) #3152   6
```

    ## [1] 3152    6

``` r
##which species are not on both lists?

  #          
```

##### 5.2.3.2 on checklist not redlist

Ringed seal latin name differs - correct in redlist to *Pusa hispida*
4 breeding birds not on redlist --spelling differences, correct on redlist
310 macrophytes not on redlist
28 invertebreates not on redlist

``` r
# which are in checklist but not redlist
      full_species %>% filter(is.na(list_type.y)) %>%nrow()  ##343
```

    ## [1] 343

``` r
      full_species %>% filter(is.na(list_type.y)) %>%select(taxa_group)%>%distinct()  ## breeding birds, invert, macrophytes mammals
```

    ## Source: local data frame [4 x 1]
    ## 
    ##       taxa_group
    ##            (chr)
    ## 1 breeding birds
    ## 2         invert
    ## 3    macrophytes
    ## 4        mammals

``` r
## check mammals
   full_species %>% filter(is.na(list_type.y)) %>% filter(taxa_group =="mammals") #Pusa hispida  
```

    ## Source: local data frame [1 x 6]
    ## 
    ##     latin_name taxa_group list_type.x assessment_unit helcom_category
    ##          (chr)      (chr)       (chr)           (chr)           (chr)
    ## 1 Pusa hispida    mammals   checklist              NA              NA
    ## Variables not shown: list_type.y (chr)

``` r
   redlist %>% filter(taxa_group == "mammals") ##Phoca hispida botnica 
```

    ##                latin_name                  assessment_unit helcom_category
    ## 1   Phoca hispida botnica                          Species              VU
    ## 2 Phoca vitulina vitulina    Southern Baltic subpopulation              LC
    ## 3 Phoca vitulina vitulina          Kalmarsun subpopulation              VU
    ## 4      Halichoerus grypus                          Species              LC
    ## 5             Lutra lutra                          Species              NT
    ## 6       Phocoena phocoena        Baltic Sea Sub-population              CR
    ## 7       Phocoena phocoena Western Baltic Sea subpopulation              VU
    ##   iucn_criteria taxa_group list_type
    ## 1           A3c    mammals   redlist
    ## 2                  mammals   redlist
    ## 3            D1    mammals   redlist
    ## 4                  mammals   redlist
    ## 5            D1    mammals   redlist
    ## 6     C1,2a(ii)    mammals   redlist
    ## 7           A2a    mammals   redlist

``` r
   mammals %>% select(latin_name,common_name)
```

    ##                latin_name                     common_name
    ## 1      Halichoerus grypus           grey seal / gray seal
    ## 2 Phoca vitulina vitulina      harbour seal / common seal
    ## 3            Pusa hispida                    ringed seal 
    ## 4       Phocoena phocoena                harbour porpoise
    ## 5             Lutra lutra European otter / Euraisan otter

``` r
## check breeding birds
   full_species %>% filter(is.na(list_type.y)) %>% filter(taxa_group =="breeding birds")
```

    ## Source: local data frame [4 x 6]
    ## 
    ##                                      latin_name     taxa_group list_type.x
    ##                                           (chr)          (chr)       (chr)
    ## 1                            Actitis hypoleucos breeding birds   checklist
    ## 2          Larus minutus (Hydrocoloeus minutus) breeding birds   checklist
    ## 3 Larus ridibundus (Chroicocephalus ridibundus) breeding birds   checklist
    ## 4          Mergus albellus (Mergellus albellus) breeding birds   checklist
    ## Variables not shown: assessment_unit (chr), helcom_category (chr),
    ##   list_type.y (chr)

``` r
    redlist %>% filter(grepl("Actitis", latin_name)) ## look for Actitis hypoleucos 
```

    ##                            latin_name assessment_unit helcom_category
    ## 1 Actitis hypoleucos (Linnaeus, 1758)        Breeding              NT
    ##   iucn_criteria     taxa_group list_type
    ## 1          A2ab breeding birds   redlist

``` r
    redlist %>% filter(grepl("Larus",latin_name))#Larus minutus (Hydrocoloeus minutus) ##Larus ridibundus (Chroicocephalus ridibundus) 
```

    ##                  latin_name assessment_unit helcom_category iucn_criteria
    ## 1       Larus fuscus fuscus        Breeding              VU        A2abce
    ## 2  Larus fuscus intermedius        Breeding              LC              
    ## 3          Larus argentatus        Breeding              LC              
    ## 4          Larus argentatus       Wintering              LC              
    ## 5          Larus cachinnans       Wintering            <NA>              
    ## 6               Larus canus        Breeding              LC              
    ## 7               Larus canus       Wintering              LC              
    ## 8             Larus marinus        Breeding              LC              
    ## 9             Larus marinus       Wintering              LC              
    ## 10     Larus melanocephalus        Breeding              EN            D1
    ## 11            Larus minutus        Breeding              LC              
    ## 12         Larus ridibundus        Breeding              LC              
    ## 13         Larus ridibundus       Wintering              LC              
    ##         taxa_group list_type
    ## 1   breeding birds   redlist
    ## 2   breeding birds   redlist
    ## 3   breeding birds   redlist
    ## 4  wintering birds   redlist
    ## 5  wintering birds   redlist
    ## 6   breeding birds   redlist
    ## 7  wintering birds   redlist
    ## 8   breeding birds   redlist
    ## 9  wintering birds   redlist
    ## 10  breeding birds   redlist
    ## 11  breeding birds   redlist
    ## 12  breeding birds   redlist
    ## 13 wintering birds   redlist

``` r
    redlist %>% filter(grepl("Mergus",latin_name)) ##Mergus albellus (Mergellus albellus) 
```

    ##         latin_name assessment_unit helcom_category iucn_criteria
    ## 1 Mergus merganser        Breeding              LC              
    ## 2 Mergus merganser       Wintering              LC              
    ## 3  Mergus serrator        Breeding              LC              
    ## 4  Mergus serrator       Wintering              VU           A2b
    ##        taxa_group list_type
    ## 1  breeding birds   redlist
    ## 2 wintering birds   redlist
    ## 3  breeding birds   redlist
    ## 4 wintering birds   redlist

``` r
## Check macrophytes
           full_species %>% filter(is.na(list_type.y)) %>% filter(taxa_group =="macrophytes") ##310 species
```

    ## Source: local data frame [310 x 6]
    ## 
    ##                                    latin_name  taxa_group list_type.x
    ##                                         (chr)       (chr)       (chr)
    ## 1  Ranunculus trichophyllus subsp. Eradicatus macrophytes   checklist
    ## 2                   Porphyridium aerugineum 3 macrophytes   checklist
    ## 3                          Polygonum foliosum macrophytes   checklist
    ## 4                      Acinetospora crinita   macrophytes   checklist
    ## 5                    Acrochaete cladophorae   macrophytes   checklist
    ## 6                       Acrochaete flustrae   macrophytes   checklist
    ## 7                    Acrochaete heteroclada   macrophytes   checklist
    ## 8                        Acrochaete inflata   macrophytes   checklist
    ## 9                    Acrochaete leptochaete   macrophytes   checklist
    ## 10                    Acrochaete operculata   macrophytes   checklist
    ## ..                                        ...         ...         ...
    ## Variables not shown: assessment_unit (chr), helcom_category (chr),
    ##   list_type.y (chr)

``` r
## check inverts
            full_species %>% filter(is.na(list_type.y)) %>% filter(taxa_group =="invert") ##28 species
```

    ## Source: local data frame [28 x 6]
    ## 
    ##                                 latin_name taxa_group list_type.x
    ##                                      (chr)      (chr)       (chr)
    ## 1                    Botrylloides leachii      invert   checklist
    ## 2                    Botryllus schlosseri      invert   checklist
    ## 3                   Corophium acherusicum      invert   checklist
    ## 4                  Cricotopus albiforceps      invert   checklist
    ## 5           Cryptochironomus tshernovskii      invert   checklist
    ## 6                   Ephemerella mucronata      invert   checklist
    ## 7                           Ephoron virgo      invert   checklist
    ## 8                           Eteone lactea      invert   checklist
    ## 9                          Euspira pallida     invert   checklist
    ## 10 Halichondria (Halichondria) bowerbanki      invert   checklist
    ## ..                                     ...        ...         ...
    ## Variables not shown: assessment_unit (chr), helcom_category (chr),
    ##   list_type.y (chr)

``` r
#### UPDATE NAMES ON REDLIST
redlist = redlist %>%
      mutate(latin_name = ifelse(latin_name=="Phoca hispida botnica","Pusa hispida",latin_name),
      latin_name = ifelse(latin_name== "Actitis hypoleucos (Linnaeus, 1758)","Actitis hypoleucos",latin_name),
       latin_name = ifelse(latin_name == "Larus minutus", "Larus minutus (Hydrocoloeus minutus)", latin_name),
             latin_name = ifelse(latin_name == "Larus ridibundus","Larus ridibundus (Chroicocephalus ridibundus)",latin_name),
             latin_name = ifelse(latin_name =="Mergellus albellus" ,"Mergus albellus (Mergellus albellus)",latin_name))


  
### REJOIN objects
            
full_species = full_join(species_checklist,redlist, by=c("latin_name","taxa_group"))%>%
                  select(-iucn_criteria)%>%
                  mutate(helcom_category = as.character(helcom_category))
dim(full_species) #3147   6
```

    ## [1] 3147    6

##### 5.2.3.3 on redlist not on checklist

**410 species on redlist not on checklist ** 1. 63 species of wintering birds. There is no wintering birds checklist so just use breeding birds and the threat level assigned to species in breeding birds (even if a species is listed on redlist in both breeding and wintering)
2. 9 species of fish. Not found - but perhaps smelt is simply incorrect on redlist (*Osmerus eperlanomarinus*) and should be changed to *Osmerus eperlanus* which is on the checklist?

``` r
## Species on redlist not on checklist
         full_species %>% filter(is.na(list_type.x)) %>%nrow()  ##   410
```

    ## [1] 410

``` r
         full_species %>% filter(is.na(list_type.x)) %>%select(taxa_group)%>%distinct()  ## macrophytes, invert, wintering birds, fish
```

    ## Source: local data frame [4 x 1]
    ## 
    ##        taxa_group
    ##             (chr)
    ## 1     macrophytes
    ## 2          invert
    ## 3 wintering birds
    ## 4            fish

``` r
## check wintering birds - 63 wintering birds.  There is no checklist for wintering birs. Will use the breeding birds and their associated threat level.
   full_species %>% filter(is.na(list_type.x)) %>% filter(taxa_group =="wintering birds")
```

    ## Source: local data frame [63 x 6]
    ## 
    ##                              latin_name      taxa_group list_type.x
    ##                                   (chr)           (chr)       (chr)
    ## 1                 Branta bernicla hrota wintering birds          NA
    ## 2                            Uria aalge wintering birds          NA
    ## 3                            Uria aalge wintering birds          NA
    ## 4                            Anas acuta wintering birds          NA
    ## 5                         Gavia adamsii wintering birds          NA
    ## 6  Mergus albellus (Mergellus albellus) wintering birds          NA
    ## 7                  Haliaeetus albicilla wintering birds          NA
    ## 8                       Anser albifrons wintering birds          NA
    ## 9                             Alle alle wintering birds          NA
    ## 10                 Eremophila alpestris wintering birds          NA
    ## ..                                  ...             ...         ...
    ## Variables not shown: assessment_unit (chr), helcom_category (chr),
    ##   list_type.y (chr)

``` r
##check fish 
    full_species %>% filter(is.na(list_type.x)) %>% filter(taxa_group =="fish") ## 9 spp
```

    ## Source: local data frame [9 x 6]
    ## 
    ##                latin_name taxa_group list_type.x assessment_unit
    ##                     (chr)      (chr)       (chr)           (chr)
    ## 1      Coregonus balticus       fish          NA         Species
    ## 2       Lophius budegassa       fish          NA         Species
    ## 3 Osmerus eperlanomarinus       fish          NA         Species
    ## 4       Hexanchus griseus       fish          NA         Species
    ## 5           Raja montagui       fish          NA         Species
    ## 6      Coregonus pallasii       fish          NA         Species
    ## 7        Acipenser sturio       fish          NA         Species
    ## 8     Orcynopsis unicolor       fish          NA         Species
    ## 9         Sphyrna zygaena       fish          NA         Species
    ## Variables not shown: helcom_category (chr), list_type.y (chr)

``` r
    ##search checklist
    species_checklist %>% filter(grepl("Coregonus", latin_name)) ##look for  Coregonus balticus & Coregonus pallasii 
```

    ## Source: local data frame [3 x 3]
    ## 
    ##               latin_name taxa_group list_type
    ##                    (chr)      (chr)     (chr)
    ## 1       Coregonus albula       fish checklist
    ## 2 Coregonus maraena s.l.       fish checklist
    ## 3        Coregonus peled       fish checklist

``` r
            ##fishbase.org say C. pallasii is found in large lakes
   species_checklist %>% filter(grepl("Lophius", latin_name)) ## Lophius budegassa
```

    ## Source: local data frame [1 x 3]
    ## 
    ##            latin_name taxa_group list_type
    ##                 (chr)      (chr)     (chr)
    ## 1 Lophius piscatorius       fish checklist

``` r
   species_checklist %>% filter(grepl("Osmerus", latin_name)) ## Osmerus eperlanomarinus
```

    ## Source: local data frame [1 x 3]
    ## 
    ##          latin_name taxa_group list_type
    ##               (chr)      (chr)     (chr)
    ## 1 Osmerus eperlanus       fish checklist

``` r
              ##equivalent (smelt)? - search fishbase.org for Osmerus eperlanomarinus and returns Osmerus eperlanus
   species_checklist %>% filter(grepl("Hexanchus", latin_name)) ## Hexanchus griseus  
```

    ## Source: local data frame [0 x 3]
    ## 
    ## Variables not shown: latin_name (chr), taxa_group (chr), list_type (chr)

``` r
   species_checklist %>% filter(grepl("Raja", latin_name)) ## Raja montagui (Spotted ray )
```

    ## Source: local data frame [1 x 3]
    ## 
    ##     latin_name taxa_group list_type
    ##          (chr)      (chr)     (chr)
    ## 1 Raja clavata       fish checklist

``` r
   species_checklist %>% filter(grepl("Acipenser", latin_name)) ## Acipenser sturio
```

    ## Source: local data frame [5 x 3]
    ## 
    ##                  latin_name taxa_group list_type
    ##                       (chr)      (chr)     (chr)
    ## 1           Acipenser baeri       fish checklist
    ## 2 Acipenser gueldenstaedtii       fish checklist
    ## 3      Acipenser oxyrinchus       fish checklist
    ## 4        Acipenser ruthenus       fish checklist
    ## 5       Acipenser stellatus       fish checklist

``` r
   species_checklist %>% filter(grepl("Orcynopsis", latin_name)) ## Orcynopsis unicolor
```

    ## Source: local data frame [0 x 3]
    ## 
    ## Variables not shown: latin_name (chr), taxa_group (chr), list_type (chr)

``` r
   species_checklist %>% filter(grepl("Sphyrna", latin_name)) ## Sphyrna zygaena 
```

    ## Source: local data frame [0 x 3]
    ## 
    ## Variables not shown: latin_name (chr), taxa_group (chr), list_type (chr)

#### 5.2.4 shared species object

2393 unique species shared between the species checklist and the red list

``` r
#
## object of only species shared betweent the lists  
shared_species = full_species %>%
                  filter(!is.na(list_type.x) & !is.na(list_type.y))
dim(shared_species)
```

    ## [1] 2399    6

``` r
shared_species %>% select(latin_name)%>%distinct() %>% nrow()##2393
```

    ## [1] 2393

##### 5.2.4.1 Duplicates in shared\_species

Cod are assessed at the species level, and by subpopulation. Harbor porpoise and Harbor seal also have assessments by subpopulation. Invert Malacoceros fuliginosus has 2 threat assessments at the species level.

\*\* For Cod - there is a species level assessment and so use this - VU** **For *Malacoceros fuliginosus* there are two species level assessments, one LC, one NE - select LC** **For *Phoca vitulina vitulina* and *Phocoena phocoena* select highest threat for each, VU and CR respectively\*\*

``` r
## are there species with more than one helcom_cateogry threat?
shared_species %>% select(latin_name,helcom_category)%>%distinct()%>%nrow()
```

    ## [1] 2398

``` r
##[1] 2298
shared_species %>% select(latin_name)%>%distinct()%>%nrow()
```

    ## [1] 2393

``` r
##2393

##YES

##which are duplicated
shared_species %>% select(latin_name)%>% filter(duplicated(.)==TRUE)
```

    ## Source: local data frame [6 x 1]
    ## 
    ##                latin_name
    ##                     (chr)
    ## 1            Gadus morhua
    ## 2            Gadus morhua
    ## 3            Gadus morhua
    ## 4 Malacoceros fuliginosus
    ## 5 Phoca vitulina vitulina
    ## 6       Phocoena phocoena

``` r
shared_species %>% filter(latin_name== "Gadus morhua" | latin_name== "Malacoceros fuliginosus" | latin_name=="Phoca vitulina vitulina" | latin_name=="Phocoena phocoena") 
```

    ## Source: local data frame [10 x 6]
    ## 
    ##                 latin_name taxa_group list_type.x
    ##                      (chr)      (chr)       (chr)
    ## 1             Gadus morhua       fish   checklist
    ## 2             Gadus morhua       fish   checklist
    ## 3             Gadus morhua       fish   checklist
    ## 4             Gadus morhua       fish   checklist
    ## 5  Malacoceros fuliginosus     invert   checklist
    ## 6  Malacoceros fuliginosus     invert   checklist
    ## 7  Phoca vitulina vitulina    mammals   checklist
    ## 8  Phoca vitulina vitulina    mammals   checklist
    ## 9        Phocoena phocoena    mammals   checklist
    ## 10       Phocoena phocoena    mammals   checklist
    ## Variables not shown: assessment_unit (chr), helcom_category (chr),
    ##   list_type.y (chr)

``` r
## select the species assessment

shared_species = shared_species%>%
                 mutate(helcom_category = ifelse(latin_name == "Gadus morhua", "VU",
                                           ifelse(latin_name == "Malacoceros fuliginosus", "LC",
                                           ifelse(latin_name == "Phoca vitulina vitulina" ,"VU",
                                           ifelse(latin_name == "Phocoena phocoena","CR",helcom_category)))))%>%
                 select(-assessment_unit)%>%
                 distinct()
## check for duplicates
shared_species %>% select(latin_name,helcom_category)%>%distinct()%>%nrow();shared_species %>% select(latin_name)%>%distinct()%>%nrow()
```

    ## [1] 2393

    ## [1] 2393

#### 5.2.5 Plot the shared\_species list by threat category

``` r
shared_species_threat_n = shared_species %>%
                       count(taxa_group,helcom_category)

ggplot(shared_species_threat_n, aes(x=taxa_group, y=n, fill=helcom_category))+
  geom_bar(stat="identity")+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("Count of species in each IUCN category")
```

![](spp_prep_files/figure-markdown_github/plot%20shared_species%20by%20threat-1.png)<!-- -->

### 5.3 Select data for analysis

#### 5.3.1 Exclude taxa that are:

1.  Data decificient (DD)
2.  Not Evaluated (NE)

``` r
## save excluded species in separate object
shared_species_dd_ne = bind_rows(filter(shared_species,helcom_category == 'DD'),
                                 filter(shared_species,helcom_category == 'NE'))
str(shared_species_dd_ne)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    729 obs. of  5 variables:
    ##  $ latin_name     : chr  "Lycodes gracilis" "Lebetus guilleti" "Lebetus scorpioides" "Lesueurigobius friesii" ...
    ##  $ taxa_group     : chr  "fish" "fish" "fish" "fish" ...
    ##  $ list_type.x    : chr  "checklist" "checklist" "checklist" "checklist" ...
    ##  $ helcom_category: chr  "DD" "DD" "DD" "DD" ...
    ##  $ list_type.y    : chr  "redlist" "redlist" "redlist" "redlist" ...

``` r
dim(shared_species_dd_ne)# 729 5
```

    ## [1] 729   5

``` r
## plot excluded
shared_species_dd_ne_threat_n = shared_species_dd_ne %>%
                       count(taxa_group,helcom_category)

ggplot(shared_species_dd_ne_threat_n, aes(x=taxa_group, y=n, fill=helcom_category))+
  geom_bar(stat="identity")+
  ggtitle("Count of excluded species ")
```

![](spp_prep_files/figure-markdown_github/exclude%20DD%20and%20NE%20from%20shared_species-1.png)<!-- -->

``` r
##object excluding DD and NE
shared_species2 = bind_rows(filter(shared_species,helcom_category == 'NT'),
                            filter(shared_species,helcom_category == 'LC'),
                            filter(shared_species,helcom_category == 'VU'),
                            filter(shared_species,helcom_category == 'EN'),
                            filter(shared_species,helcom_category == 'CR'),
                            filter(shared_species,helcom_category == 'RE'),
                            filter(shared_species,helcom_category == 'NA'))
                            
                                 
dim(shared_species2); dim(shared_species) # 1474,2393 
```

    ## [1] 1474    5

    ## [1] 2393    5

``` r
## recreate object without DD and NE
shared_species_threat_n = shared_species2 %>%
                       count(taxa_group,helcom_category)

ggplot(shared_species_threat_n, aes(x=taxa_group, y=n, fill=helcom_category))+
  geom_bar(stat="identity")+
   theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("Count of species in each IUCN category")
```

![](spp_prep_files/figure-markdown_github/exclude%20DD%20and%20NE%20from%20shared_species-2.png)<!-- -->

### 5.4 Score threat level

#### 5.4.1 Repeat making the vuln\_lookup

Add category Regionally Extinct, and score same as Extinct

``` r
## repeat code from section 4, vulnerability lookup table


vuln_lookup = shared_species2 %>%
              select(helcom_category)%>%
              distinct(.) %>% ## unique vulnerability codes
              mutate(helcom_category_numeric = ifelse(helcom_category == 'EX',1,
                                    ifelse(helcom_category == 'RE',1,
                                    ifelse(helcom_category == 'CR',0.8,
                                    ifelse(helcom_category == 'EN', 0.6,
                                    ifelse(helcom_category == 'VU', 0.4,
                                    ifelse(helcom_category == 'NT', 0.2,
                                    ifelse(helcom_category == 'LC',0,NA)))))))) ## 


vuln_lookup ## note, no species with EX
```

    ## Source: local data frame [6 x 2]
    ## 
    ##   helcom_category helcom_category_numeric
    ##             (chr)                   (dbl)
    ## 1              NT                     0.2
    ## 2              LC                     0.0
    ## 3              VU                     0.4
    ## 4              EN                     0.6
    ## 5              CR                     0.8
    ## 6              RE                     1.0

#### 5.4.2 Join the vulnerability score to the shared species list

``` r
shared_species3 = shared_species2 %>%
                  left_join(., vuln_lookup, by="helcom_category")
```

### 5.5 Species distributions

#### 5.5.1 Basin names used for distribution

Major basin are the same but smaller regions also included, these differ in number

``` r
fish_loc = fish_long %>% select(location)%>%arrange()%>%distinct() %>%
  mutate(location = ifelse(location == "Åland.Sea", "Aland.Sea",location))##21
invert_loc = invert_long %>% select(location)%>%arrange()%>%distinct() ##32
macrophytes_loc = macrophytes_long %>% select(location)%>%arrange()%>%distinct() ##17
mammals_loc = mammals_long %>% select(location)%>%arrange()%>%distinct()%>%
              mutate(location = ifelse(location == "Åland.Sea", "Aland.Sea",location))##19
```

#### 5.5.2 Location name object

``` r
dist_loc = bind_rows(fish_loc,invert_loc,macrophytes_loc,mammals_loc)%>%
            arrange()%>%
            distinct()
## Export location object, clean in excel and reimport
#write.csv(dist_loc, file.path(dir_spp,'distribution_locations.csv'), row.names=FALSE)

## Read in csv with HOLAS basin names added to the distribution locations
dist_loc = read.csv(file.path(dir_spp,'distribution_locations.csv'),sep=";")

##number of basin
dist_loc %>% select(basin)%>%distinct()%>%nrow() #17 ## These match HOLAS basins
```

    ## [1] 17

#### 5.5.3 Join dist\_loct to taxa checklists

This excludes birds because distribution given by country.

``` r
species_dist = bind_rows(fish_long,
                         invert_long,
                         macrophytes_long,
                         mammals_long)%>%
              full_join(., dist_loc, by="location")
```

    ## Warning in outer_join_impl(x, y, by$x, by$y): joining factor and character
    ## vector, coercing into character vector

``` r
str(species_dist)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    75447 obs. of  6 variables:
    ##  $ latin_name : chr  "Myxine glutinosa" "Lampetra fluviatilis" "Petromyzon marinus" "Lamna nasus" ...
    ##  $ common_name: chr  "Hagfish" "River lamprey" "Sea lamprey" "Porbeagle" ...
    ##  $ location   : chr  "Kattegat" "Kattegat" "Kattegat" "Kattegat" ...
    ##  $ presence   : num  1 1 1 0 0 0 0 1 0 1 ...
    ##  $ taxa_group : chr  "fish" "fish" "fish" "fish" ...
    ##  $ basin      : Factor w/ 17 levels "Aland Sea","Arkona Basin",..: 12 12 12 12 12 12 12 12 12 12 ...

### 5.6 Species distributions + Threat score

``` r
## number of species that should be on final list is
shared_species3 %>% nrow() ## 1474 species should be on the final list
```

    ## [1] 1474

``` r
## join shared_species3 to species_dist
shared_species_dist = left_join(shared_species3, species_dist, 
                                by=c("latin_name","taxa_group")) %>%
                      select(-list_type.x, -list_type.y,-location)%>%  ## exclude location because may have more than one location per basin
                      select(taxa_group,latin_name,common_name,helcom_category,helcom_category_numeric,basin,presence) %>%
                      distinct()%>%
                      arrange(taxa_group, latin_name)


dim(shared_species_dist)
```

    ## [1] 25771     7

``` r
shared_species_dist %>% select(latin_name)%>% distinct() %>% nrow() #1474
```

    ## [1] 1474

### 5.6.1 Plot IUCN category by taxa and basin

Breeding birds were distributed by country so no basin assignment currently.

``` r
## recreate object without DD and NE
shared_species_dist_n = shared_species_dist %>%
                       count(basin,taxa_group,helcom_category)

ggplot(shared_species_dist_n, aes(x=taxa_group, y=n, fill=helcom_category))+
  geom_bar(stat="identity")+
  facet_wrap(~basin, scales="free_y")+
   theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("Count of species in each IUCN category")
```

![](spp_prep_files/figure-markdown_github/unnamed-chunk-1-1.png)<!-- -->

### 5.7 Status calculation by basin

Data are on the HOLAS basin scale. Calculate biodiversity status by basin and then apply to BHI regions.
*Note, this will mean that the data layer sent to layers and what is registered in layers.csv is very different than what is done if use the spatial data layers from HELCOM where status is directly calculated for BHI regions and this is done formally in functions.r*

### 5.7.1 Calulate SPP status using checklist and redlist data with all species weighted equally

**Exclude birds for now**
Do a single calculation including all species. Will compare this result to doing this calculation first for each taxa group and then taking the geometric mean (See Section 6.7.2)

##### 5.7.1.1 Calculate status

``` r
##sum the threat weights for each basin
sum_wi_basin =shared_species_dist %>%
              filter(taxa_group != "breeding birds")%>% ## remove birds
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
sum_spp_basin = shared_species_dist %>%
                filter(taxa_group != "breeding birds")%>% ## remove birds
                filter(presence != 0) %>% # select only present taxa
                select(basin, latin_name)%>%
                dplyr::count(basin)
dim(sum_spp_basin) #17 2
```

    ## [1] 17  2

``` r
shared_species_dist%>% filter(basin== "Aland Sea") %>% nrow() ## check to make sure works
```

    ## [1] 1486

``` r
head(sum_spp_basin)
```

    ## Source: local data frame [6 x 2]
    ## 
    ##                basin     n
    ##               (fctr) (int)
    ## 1          Aland Sea   203
    ## 2       Arkona Basin   386
    ## 3 Bay of Mecklenburg   502
    ## 4     Bornholm Basin   345
    ## 5       Bothnian Bay   191
    ## 6       Bothnian Sea   236

``` r
spp_status_basin = full_join(sum_wi_basin,sum_spp_basin, by="basin") %>%
             mutate(wi_spp = sum_wi/n,
                    status = 1 - wi_spp)
```

##### 5.7.1.2 Scale lower end to zero if 75% extinct

Currently, species are labled regionally extinct

``` r
## calculate percent extinct in each region
spp_ex_basin = shared_species_dist %>%
              filter(taxa_group != "breeding birds")%>% 
              filter(presence != 0) %>% # select only present taxa
              dplyr::rename(weights=helcom_category_numeric)%>%## remove birds
              filter(weights == 1)
spp_ex_basin
```

    ## Source: local data frame [2 x 7]
    ## 
    ##   taxa_group           latin_name                common_name
    ##        (chr)                (chr)                      (chr)
    ## 1       fish Acipenser oxyrinchus American atlantic sturgeon
    ## 2       fish Acipenser oxyrinchus American atlantic sturgeon
    ## Variables not shown: helcom_category (chr), weights (dbl), basin (fctr),
    ##   presence (dbl)

``` r
## which are RE (regionally extinct)
spp_ex_basin %>% select(latin_name,common_name)%>%distinct() ##2 
```

    ## Source: local data frame [1 x 2]
    ## 
    ##             latin_name                common_name
    ##                  (chr)                      (chr)
    ## 1 Acipenser oxyrinchus American atlantic sturgeon

``` r
##total extinct per basin

spp_ex_basin_n = spp_ex_basin %>%
                  select(basin,latin_name)%>%
                  dplyr::count(basin)%>%
                  dplyr::rename(n_extinct = n)


## join to basin status
spp_status_basin = spp_status_basin %>%
                   full_join(.,spp_ex_basin_n, by="basin") %>%
                   mutate(n_extinct = ifelse(is.na(n_extinct),0,n_extinct))

## calculated the % extinct in each basin. if >75% then status score is 0
spp_status_basin = spp_status_basin %>%
                  mutate(prop_extinct = n_extinct / n,
                         status = ifelse(prop_extinct>=0.75, 0, status))
```

##### 5.7.1.3 Plot status by basin

``` r
## Plot status
ggplot(spp_status_basin)+
  geom_point(aes(basin,round(status*100)),size=3)+
  ylim(0,100)+
  ylab("Status") + 
  xlab("Basin")+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("SPP status by Basin")
```

![](spp_prep_files/figure-markdown_github/plot%20basin%20status-1.png)<!-- -->

``` r
## Size points to number of species in a region
ggplot(spp_status_basin)+
  geom_point(aes(basin,round(status*100), size=n))+
  ylim(0,100)+
  ylab("Status") + 
  xlab("Basin")+
  scale_size(breaks =c(1200,1400,1600,1800), labels=c("1200","1400","1600","1800"))+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y =  element_text(colour="grey20",size=6))+
  ggtitle("SPP status by Basin, n= species richness")
```

![](spp_prep_files/figure-markdown_github/plot%20basin%20status-2.png)<!-- -->

### 5.7.2 Calulate SPP status using checklist and redlist data by taxa group and geometric mean

**Exclude birds for now**
Calculation status by taxa group by basin and then taking the geometric mean for each basin.

##### 5.7.2.1 Calculate status by taxa group

``` r
##sum the threat weights for each basin by taxa group
sum_wi_basin_taxa_group =shared_species_dist %>%
              filter(taxa_group != "breeding birds")%>% ## remove birds
              select(basin,taxa_group,helcom_category_numeric)%>%
              dplyr::rename(weights=helcom_category_numeric)%>%
              group_by(basin, taxa_group)%>%
              summarise(sum_wi =sum(weights))%>%
              ungroup()
dim(sum_wi_basin_taxa_group) #68  3
```

    ## [1] 68  3

``` r
## count the number of species in each BHI region by taxa group
sum_spp_basin_taxa_group = shared_species_dist %>%
                filter(taxa_group != "breeding birds")%>% ## remove birds
                filter(presence !=0) %>% ## filter out species not present
                select(basin, taxa_group,latin_name)%>%
                dplyr::count(basin, taxa_group)
dim(sum_spp_basin_taxa_group) #68 3
```

    ## [1] 68  3

``` r
spp_status_basin_taxa_group = full_join(sum_wi_basin_taxa_group,
                                        sum_spp_basin_taxa_group, by=c("basin","taxa_group")) %>%
             mutate(wi_spp_taxa = sum_wi/n,
                    status_taxa = 1 - wi_spp_taxa)
```

##### 5.7.2.2 Plot status by taxa group

``` r
ggplot(spp_status_basin_taxa_group)+
  geom_point(aes(taxa_group,status_taxa,size=n))+
  facet_wrap(~basin) +
  ylim(0,1.5)+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y =  element_text(colour="grey20",size=6))+
  ggtitle("Taxa group Status by Basin, n= species richness")
```

![](spp_prep_files/figure-markdown_github/plot%20taxa_group%20Status-1.png)<!-- -->

##### 5.7.2.3 For each taxa group - Scale lower end to zero if 75% extinct

Currently, species are labled regionally extinct

``` r
## calculate percent extinct in each region
spp_ex_basin_taxa_group = shared_species_dist %>%
              filter(taxa_group != "breeding birds")%>% 
              filter(presence != 0) %>% # select only present taxa
              dplyr::rename(weights=helcom_category_numeric)%>%## remove birds
              group_by(taxa_group)%>%
              filter(weights == 1)%>%
              ungroup()
spp_ex_basin_taxa_group
```

    ## Source: local data frame [2 x 7]
    ## 
    ##   taxa_group           latin_name                common_name
    ##        (chr)                (chr)                      (chr)
    ## 1       fish Acipenser oxyrinchus American atlantic sturgeon
    ## 2       fish Acipenser oxyrinchus American atlantic sturgeon
    ## Variables not shown: helcom_category (chr), weights (dbl), basin (fctr),
    ##   presence (dbl)

``` r
## which are RE (regionally extinct)
spp_ex_basin_taxa_group %>% select(latin_name,common_name)%>%distinct() ##2 
```

    ## Source: local data frame [1 x 2]
    ## 
    ##             latin_name                common_name
    ##                  (chr)                      (chr)
    ## 1 Acipenser oxyrinchus American atlantic sturgeon

``` r
##total extinct per basin

spp_ex_basin_n_taxa_group = spp_ex_basin_taxa_group %>%
                  select(basin, taxa_group,latin_name)%>%
                  dplyr::count(basin,taxa_group)%>%
                  dplyr::rename(n_extinct = n)


## join to basin status
spp_status_basin_taxa_group = spp_status_basin_taxa_group %>%
                   full_join(.,spp_ex_basin_n_taxa_group, by=c("basin", "taxa_group")) %>%
                   mutate(n_extinct = ifelse(is.na(n_extinct),0,n_extinct))

## calculated the % extinct in each basin. if >75% then status score is 0
spp_status_basin_taxa_group  = spp_status_basin_taxa_group  %>%
                  mutate(prop_extinct = n_extinct / n,
                         status_taxa = ifelse(prop_extinct>=0.75, 0, status_taxa))
```

##### 5.7.2.4 Plot again status by taxa group

``` r
ggplot(spp_status_basin_taxa_group)+
  geom_point(aes(taxa_group,status_taxa,size=n))+
  facet_wrap(~basin) +
  ylim(0,1.5)+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y =  element_text(colour="grey20",size=6))+
  ggtitle("Taxa group Status by Basin, n= species richness")
```

![](spp_prep_files/figure-markdown_github/plot%20taxa_group%20Status%20again-1.png)<!-- -->

##### 5.7.2.5 Calculate Geometric Mean for Basin status

``` r
spp_status_basin_geo = spp_status_basin_taxa_group %>%
                        select(basin, status_taxa) %>%
                       group_by(basin)%>%
                       summarise(status_basin =exp(mean(log(status_taxa))))%>%
                        ungroup()
```

##### 5.7.2.4 Plot Geometric Mean for Basin status

``` r
ggplot(spp_status_basin_geo)+
  geom_point(aes(basin, status_basin),size=2)+
  ylim(0,1)+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y =  element_text(colour="grey20",size=6))+
  ggtitle("SPP Basin status from geometric mean of taxa group status")
```

![](spp_prep_files/figure-markdown_github/plot%20basin%20Status%20from%20geometric%20mean-1.png)<!-- -->

#### 5.7.3 Compare alternative approaches to Basin level SPP status calculation

``` r
spp_status_basin = spp_status_basin %>%
                    select(basin,status)%>%
                    mutate(status_type = "all species")
spp_status_basin_geo = spp_status_basin_geo %>%
                        dplyr::rename(status=status_basin)%>%
                        mutate(status_type = "taxa group geometric mean")

basin_status_compare = bind_rows(spp_status_basin,spp_status_basin_geo)


ggplot(basin_status_compare)+
  geom_point(aes(basin, status, colour=status_type,shape=status_type),size=2)+
  ylim(0,1)+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y =  element_text(colour="grey20",size=6))+
  ggtitle("SPP Basin status method comparision")
```

![](spp_prep_files/figure-markdown_github/comparsion%20of%20basin%20level%20spp%20status-1.png)<!-- -->

TO DO
-----

1.  Apply basin scores to BHI regions
2.  Send data layer to layers
3.  Update functions.r if using the checklist and redlist data
4.  Decide how to deal with birds that have spatial dist by country (not basin)
5.  Decide if it is a problem that status is dominated by inverts with LC
6.  check to see if any invasives included in the species list
7.  How to calculate a trend?
