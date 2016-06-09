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

2. Data Extraction and prep
---------------------------

Data extraction and prep was done by Melanie Frazer

### 2.1 Data Sources

Species coverage and threat level data were obtained from the [HELCOM Biodiversity Map Service](http://maps.helcom.fi/website/Biodiversity/index.html) under 'Biodiversity' and then under 'Red List'.

Data were download in March 2016.

### 2.2 Data extraction

Different taxa groups have different file types (grid files, polygons). Each species has a threat level assigned. Melanie worked to align taxa and species to BHI regions and assign the vulnerability code.

Melanie's notes on the data extraction process are below.

#### 2.2.1 General Notes

**SPP data** For groups on the HELCOM grid (benthos): there is a key (prep/spatial/helcom\_to\_rgn\_bhi\_sea.csv) that translates the grid cells into baltic regions. The key was created using this script: prep/spatial/HELCOM\_2\_baltic.R.

For groups associated to HELCOM subbasin: this key was used to translate subbasins into baltic regions: prep/baltic\_rgns\_to\_bhi\_rgns\_lookup\_holas.csv

Helcom species data downloaded from here: <http://maps.helcom.fi/website/Biodiversity/index.html> I added some subbasins to these data based on emails from Mar 21 email from Marc and Lena The data I added is incomplete.

The taxa\_combine.R combines the 5 taxonomic groups: benthos, birds, fish, mammals, macrophytes into a single data frame.

To calculate the SPP score, the IUCN codes will be converted to numeric scores and then averaged within each region.

To calculate the ICO score, the species will be subset based on what is considered an iconic species and then the IUCN codes will be converted to numeric scores, and than averaged within each region.

##### 2.2.2 Benthic data

Weird thing: you can download a map for each species, but all the species are included in each file. The only difference is that there is a unique html downloaded from IUCN for the species in question.

These data are in the format of polygons that are functionally rasters.

The corresponding benthic dbf file is saved as csv: benthos\_spatial\_data.csv

Painstakingly made a file to match the names in .shp file with the species names and vulnerability: benthic\_species.csv

##### 2.2.3 Bird data

There was no combined Helcom spatial file for birds (like there was for the benthic data).

One complication was that some species had data in the format of the "raster-style" polygons. While others were actual range polygons.

Given this, each bird spatial file was opened and then the range polygons were overlapped with the bhi regions.

NOTE: one bird species fell out of the bhi polygon areas and was excluded. I would probably ignore....but it might be worth figuring out.

The spatial files downloaded from Helcom are located here: /var/data/ohi/git-annex/Baltic/spp/Birds

The script used to open each bird file and associate the polygons with BHI regions is: bird\_data\_extract.R

The extracted bird data is here: intermediate/birds.csv

##### 2.2.4 Mammal data

There is a combined file for mammals. The ranges are described using polygons that relate to subbasins.

Some species have multiple IUCN categories (probably due to subspecies) It would be ideal if we know which categories correspond to which regions, but these data are not available. two possible options are: 1. average them 2. use the most conservative option I am going with \#2 for now, but this would be easy to change (code in mammal\_extract.R).

The script used to extract the data was: mammal\_extract.R The extracted mammal data are here: intermediate/mammals.R

##### 2.2.5 Fish data

There is a combined file for fish. The range data are polygons that correspond to subbasins.

##### 2.2.6 Macrophyte data

N=17 datapoints fell outside the water. This could probably be corrected by extracting the CELLCODES that land inland with some buffer.
Don't know if this is worth the effort...

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

### 3.2 Goal trend

4. Data layer preparation
-------------------------

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

TO DO
-----

1.  Check species that are included- are these only native species or both native and non-native? - for example have checked and Marenzelleria spp not included.
2.  Are the species included sufficient? What species are missing?
3.  How to calculate trend?
