Biodiversity (BD) Data Preparation
================

-   [1. Background](#background)
    -   [Goal Description](#goal-description)
    -   [Model & Data](#model-data)
    -   [Reference points](#reference-points)
    -   [Considerations for *BHI 2.0*](#considerations-for-bhi-2.0)
    -   [Other information](#other-information)
-   [2. Data](#data)
    -   [2.1 Data sources and information for checklist data](#data-sources-and-information-for-checklist-data)
    -   [2.2 Data sources and information for HELCOM spatial data](#data-sources-and-information-for-helcom-spatial-data)
-   [3. Goal model](#goal-model)
    -   [3.1 Goal status](#goal-status)
    -   [3.2 Goal trend](#goal-trend)
-   [Two alternative data sources and status calculations follow. Need to assess which is best.](#two-alternative-data-sources-and-status-calculations-follow.-need-to-assess-which-is-best.)
    -   [4. Data layer preparation with checklist distribution data](#data-layer-preparation-with-checklist-distribution-data)
        -   [4.1 Data organization](#data-organization)
        -   [4.2 Data attributes](#data-attributes)
    -   [only species from the checklist not on the redlist *Tribelos intextus* there is *Tribelos intextum* in redlist, not sure if this is a typo? Not including now](#only-species-from-the-checklist-not-on-the-redlist-tribelos-intextus-there-is-tribelos-intextum-in-redlist-not-sure-if-this-is-a-typo-not-including-now)
        -   [4.2.5.3 Select insecta species to include](#select-insecta-species-to-include)
        -   [4.2.5.4 Summarize to a family level](#summarize-to-a-family-level)
        -   [4.2.5.5 Plot Insecta family assigned threat](#plot-insecta-family-assigned-threat)
        -   [4.2.5.6 Join Insecta families to shared\_species list](#join-insecta-families-to-shared_species-list)
        -   [4.2.6 Plot the shared\_species list by threat category](#plot-the-shared_species-list-by-threat-category)
        -   [4.3 Select data for analysis](#select-data-for-analysis)
        -   [4.4 Score threat level](#score-threat-level)
        -   [4.5 Species distributions](#species-distributions)
        -   [4.6 Species distributions + Threat score](#species-distributions-threat-score)
        -   [4.6.1 Plot IUCN category by taxa and basin](#plot-iucn-category-by-taxa-and-basin)
        -   [4.6.2 Export shared\_species\_dist object](#export-shared_species_dist-object)
        -   [4.7 Status calculation by basin](#status-calculation-by-basin)
        -   [4.7.1 Calulate SPP status using checklist and redlist data with all species weighted equally](#calulate-spp-status-using-checklist-and-redlist-data-with-all-species-weighted-equally)
        -   [4.7.2 Calulate SPP status using checklist and redlist data by taxa group and geometric mean](#calulate-spp-status-using-checklist-and-redlist-data-by-taxa-group-and-geometric-mean)
        -   [4.8 Apply basin status to BHI regions](#apply-basin-status-to-bhi-regions)
    -   [5. Spatial data data layer preparation](#spatial-data-data-layer-preparation)
        -   [5.1 Data organization](#data-organization-1)
        -   [5.2 Data layer for functions.r](#data-layer-for-functions.r)
        -   [5.3 Status calcalculation](#status-calcalculation)
        -   [6. Send data layer to layers](#send-data-layer-to-layers)
    -   [7. Data layer considerations / concerns](#data-layer-considerations-concerns)
        -   [7.1 Aquatic insects](#aquatic-insects)
    -   [TO DO](#to-do)
    -   [Explore using Global Trend data](#explore-using-global-trend-data)

1. Background
-------------

### Goal Description

People value biodiversity in particular for its existence value. The risk of species extinction generates great emotional and moral concern for many people.

### Model & Data

HELCOM provides species checklists for the Baltic that include distribution and a complete list of all species assessed with IUCN criteria. Species were assigned a *threat category* (ranging from "extinct" to "least concern") and assigned a weight. The goal score is the average weight of all species assessed.

### Reference points

The target is for all species are in the "least concern" category; this will produce a score of 100. The lower cut-off point when 75% of species are extinct and score is 0.

### Considerations for *BHI 2.0*

### Other information

2. Data
-------

Two different data sources and goal calculation approaches are explored.

**Option 1** *See preparation in Section 4*

HELCOM provides species checklists for the Baltic that include distribution and a complete list of all species assessed with IUCN criteria.
*Pros for using these <data:*>
Much more representative set of species included for Baltic Sea biodiversity.
*Cons for using these <data:*>
Distribution is provided for most taxa groups at the basin scale - coaser resolution for calculation. Bird distribution is only by country (Germany has a couple of regions), therefore, will need additional expert information to allocate to basin or all bird species associated with a country will be allocated to all a country's BHI regions.

**Option 2** *See preparation in Section 5*

HELCOM has spatial occurrence data layers for species and species are given an IUCN threat category.
*Pros for using these <data:*>
Data are spatially explicit, can score presence absence for each BHI region.
*Cons for using these <data:*>
These represent a very limited number of species in the Baltic (125 total) with the selection criteria being those with a spatial data layer in HELCOM. Many more species have been assessed using the IUCN criteria by HELCOM.

\*\* General References \*\*

[Halpern et al. 2012. An index to assess the health and benefits of the global ocean. Nature 488: 615-620](http://www.nature.com/nature/journal/v488/n7413/full/nature11397.html)

[HELCOM Red List](http://www.helcom.fi/baltic-sea-trends/biodiversity/red-list-of-species) based on [IUCN criteria.](http://www.iucnredlist.org/technical-documents/categories-and-criteria).

**Threat categories**

*Evaluated species*

-   Extinct (EX)
-   Regionally Extinct (RE)
-   Extinct in the Wild (EW)
-   Critically Endangered (CR)
-   Endangered (EN)
-   Vulnerable (VU)
-   Near Threatened (NT)
-   Least Concern (LC)
-   Data Deficient (DD)
-   Not Applicable (NA)

*Not-evaluated species*

-   Not Evaluated (NE)

### 2.1 Data sources and information for checklist data

#### 2.1.1 Data sources

[HELCOM species checklists](http://helcom.fi/baltic-sea-trends/biodiversity/red-list-of-species) (see bottom right of page for links to excel sheets) were downloaded on 14 June 2016

Joni Kaitaranta (HELCOM) emailed the complete list of species assessed using IUCN red list criteria on 14 June 2016.

#### 2.1.2 Data folder

These data are in the folder 'SPP/data\_checklist\_redlist'

#### 2.1.3 Data treatment for presence/absence

Difference taxa groups had different levels and categorization of presence/absence. This is what is included as presence for BHI from the checklist.

-   *Breeding birds* presence = 'breeding'
-   *Fish* presence = 'regular reproduction' or 'regular occurence, no reproduction'
-   *Macrophyte* presence = 'X'
-   *Mammal* presence = 'X'
-   *Invert* presence = 'X'

#### 2.1.4 Other notes

-   Breeding birds list noted species that used to be present but are extinct in a separate category - identified as 0
-   Fish are all occurrences since 1800 - so could have many temporary or extinct sp, Extinction not noted, exclude those labeled temporary.
-   Macrophytes, Mammals, Inverts only have either X or blank.
-   Macrophytes spp have many synonym names, manually combined so only the main latin name has all presence/absence occurences for all synonyms.

### 2.2 Data sources and information for HELCOM spatial data

Data extraction and prep was done by Melanie Frazer

#### 2.2.1 Data Sources

Species coverage and threat level data were obtained from the [HELCOM Biodiversity Map Service](http://maps.helcom.fi/website/Biodiversity/index.html) under 'Biodiversity' and then under 'Red List'.

Data were download in March 2016.

#### 2.2.2 Data extraction

Different taxa groups have different file types (grid files, polygons). Each species has a threat level assigned. Melanie Frazier from OHI-science team worked to align taxa and species to BHI regions and assign the vulnerability code.

Folders associated with these data are:

-   data
-   intermediate
    \_ raw

Scripts associated with these data are:

-   benthic\_extract.R
-   bird\_data\_extract.R
-   fish\_extract.R
-   macrophyte\_extract.R
-   mammal\_extract.R
-   taxa\_combine.R

Melanie's notes on the data extraction process are below.

#### 2.2.3 Notes

##### 2.2.3.1 General Notes

**SPP data** For groups on the HELCOM grid (benthos): there is a key (prep/spatial/helcom\_to\_rgn\_bhi\_sea.csv) that translates the grid cells into baltic regions. The key was created using this script: prep/spatial/HELCOM\_2\_baltic.R.

For groups associated to HELCOM subbasin: this key was used to translate subbasins into baltic regions: prep/baltic\_rgns\_to\_bhi\_rgns\_lookup\_holas.csv

**If these data are used, need to translate to subbasins with the new shapefile matches, should be very similar**

Helcom species data downloaded from here: <http://maps.helcom.fi/website/Biodiversity/index.html> I added some subbasins to these data based on emails from Mar 21 email from Marc and Lena The data I added is incomplete.

The taxa\_combine.R combines the 5 taxonomic groups: benthos, birds, fish, mammals, macrophytes into a single data frame.

To calculate the SPP score, the IUCN codes will be converted to numeric scores and then averaged within each region.

To calculate the ICO score, the species will be subset based on what is considered an iconic species and then the IUCN codes will be converted to numeric scores, and than averaged within each region.

##### 2.2.3.2 Benthic data

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

##### 2.2.3.4 Mammal data

There is a combined file for mammals. The ranges are described using polygons that relate to subbasins.

Some species have multiple IUCN categories (probably due to subspecies). It would be ideal if we know which categories correspond to which regions, but these data are not available. Two possible options are:

1.  average them
2.  use the most conservative option

I am going with \#2 for now, but this would be easy to change (code in mammal\_extract.R).

The script used to extract the data was: mammal\_extract.R The extracted mammal data are here: intermediate/mammals.R

##### 2.2.3.5 Fish data

There is a combined file for fish. The range data are polygons that correspond to subbasins.

##### 2.2.3.6 Macrophyte data

N=17 datapoints fell outside the water. This could probably be corrected by extracting the CELLCODES that land inland with some buffer.
Don't know if this is worth the effort...

3. Goal model
-------------

BD goal will only be based on the SPP sub-component

### 3.1 Goal status

#### 3.1.1 Checklist/redlist data goal model

Xspp\_b = geometric\_mean (Xspp\_b,t)

Xpp\_b,t = 1- (sum\[wi\_t,b\]/R\_t,b)

-   *b* = basin
-   *t* = taxa group
-   *wi\_t,b* = *threat weights* for each species *i* in taxa group *t* in basin *b*
    R\_t,b = Ref point = Total number of species in basin *b* for taxa group *t* (eg. score equals 1 when all species i have wi of LC)

Scale min value = score is 0 when 75% of species are extinct.\*
\*From Halpern et al 2012, SI. "We scaled the lower end of the biodiversity goal to be 0 when 75% species are extinct, a level comparable to the five documented mass extinctions"

*wi* values come from Halpern et al 2012, Supplemental Information:

-   EX = 1.0
-   CR = 0.8
-   EN = 0.6
-   VU = 0.4
-   NT = 0.2
-   LC = 0
-   DD = not included, "We did not include the Data Deficient classification as assessed species following previously published guidelines for a mid-point approach"

#### 3.1.2 Spatial data goal model

Xspp\_r = 1- sum\[wi\]/R

wi = threat weights for each species i, R = total number of species in BHI region r
R = Ref point = Total number of species in region r (eg. score equals 1 when all species i have wi of LC)

Scale min value = score is 0 when 75% of species are extinct.\*
\*From Halpern et al 2012, SI. "We scaled the lower end of the biodiversity goal to be 0 when 75% species are extinct, a level comparable to the five documented mass extinctions"

wi from Halpern et al 2012, SI

-   EX = 1.0
-   CR = 0.8
-   EN = 0.6
-   VU = 0.4
-   NT = 0.2
-   LC = 0
-   DD = not included, "We did not include the Data Deficient classification as assessed species following previously published guidelines for a mid-point approach"

**Will do above calculation for basin, not BHI region if use checklist distributions**

### 3.2 Goal trend

TBD

Two alternative data sources and status calculations follow. Need to assess which is best.
==========================================================================================

``` r
knitr::opts_chunk$set(message = FALSE, warning = FALSE, results = "hide")

## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')
```

    ## Warning: package 'ggplot2' was built under R version 3.3.2

``` r
dir_spp    = file.path(dir_prep, 'SPP')

## add a README.md to the prep directory
create_readme(dir_spp, 'spp_prep.rmd')
```

4. Data layer preparation with checklist distribution data
----------------------------------------------------------

### 4.1 Data organization

#### 4.1.1 Read in data

``` r
bbirds = read.csv(file.path(dir_spp,'data_checklist_redlist/breedingbirds_dist_checklist.csv'), sep= ";", stringsAsFactors = FALSE)

fish = read.csv(file.path(dir_spp,'data_checklist_redlist/fish_dist_checklist.csv'), sep= ";", stringsAsFactors = FALSE)

invert = read.csv(file.path(dir_spp,'data_checklist_redlist/invert_dist_checklist.csv'), sep= ";", stringsAsFactors = FALSE)

invert_taxa_all = read.csv(file.path(dir_spp,'data_checklist_redlist/invert_dist_checklist_alltaxalevels.csv'), sep= ";", stringsAsFactors = FALSE) ## this is the same distribution data as in the "invert" object but all taxa levels are included in the csv so can be modified for insects

macrophytes = read.csv(file.path(dir_spp,'data_checklist_redlist/macrophytes_dist_checklist.csv'), sep= ";", stringsAsFactors = FALSE)

mammals = read.csv(file.path(dir_spp,'data_checklist_redlist/mammals_dist_checklist.csv'), sep= ";", stringsAsFactors = FALSE)


redlist = read.csv(file.path(dir_spp,'data_checklist_redlist/helcom_redlist_allspecies.csv'), sep= ";", stringsAsFactors = FALSE)
```

#### 4.1.2 Data structure

``` r
str(bbirds)
str(fish)
str(invert) 
str(invert_taxa_all)
str(macrophytes)
str(mammals)
str(redlist)
```

#### 4.1.3 Translate code to presence/absence

Objective is to get a data layer of current species occurence.

Each taxa group has a different code for noting distribution in different regions. Translate to a 1 or 0 for presence absence then gather to long format

##### 4.1.3.1 Breeding birds

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

##### 4.1.3.2 Fish and Lamprey

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

##### 4.1.3.3 Invertebrates

X = ocurrance
'blank' = no occurance

**For BHI:** *X = 1* and *blank = 0*

Invertebrates pose a problem that some Insecta are indentified to *Genus species* in some regions (eg Gulf of Finland) but likely not assessed by monitoring programs everywhere with such high spatial resolution.

Originally, we coded the status to use all species level data (eg. use the invert\_long object below). Now the code will be updated. Insecta will only be considered at the Family level. Because the redlist is only assessed at the species level, we will extract information for all Insecta species. The species with a the highest threat (most vulnerable species) in a family will be used as the threat level for the entire family.

``` r
## gather invert  to long format
invert_long = invert %>%
              gather(location,presence,-latin_name,-common_name)%>%
              mutate(presence = ifelse(presence == "X", 1, 0))%>% 
              mutate(taxa_group = "invert")


## clean invert taxa all
invert_taxa_all_long = invert_taxa_all %>%
                       select(-group,-kingdom,-phylum,-subgenus,-species,-subspecies)%>%
                       gather(location, presence, -class, -order,-family,-genus,-latin_name,-common_name)%>%
                       mutate(presence = ifelse(presence == "X", 1, 0))%>% 
                       mutate(taxa_group = "invert")

invert_taxa_all_long_noinsect = invert_taxa_all_long %>%
                                filter(class != "Insecta")%>%
                                select(latin_name,common_name,location,presence, taxa_group)
                        
dim(invert_taxa_all_long_noinsect);dim(invert_taxa_all_long)


invert_taxa_all_long_insect = invert_taxa_all_long %>%
                                filter(class == "Insecta")%>%
                                select(family,latin_name,common_name,location,presence, taxa_group)
```

##### 4.1.3.4 Macrophytes

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

##### 4.1.3.5 Mammals

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

### 4.2 Data attributes

#### 4.2.1 Get number of species by taxa group

2731 total unique latin names
Join the inverts excluding the class insecta

``` r
species_checklist = bind_rows(select(bbirds_long,latin_name,taxa_group),
                         select(fish_long,latin_name,taxa_group),
                         select(invert_taxa_all_long_noinsect,latin_name,taxa_group),
                         select(macrophytes_long,latin_name,taxa_group),
                         select(mammals_long,latin_name,taxa_group))%>%
                         distinct()

species_checklist_n = species_checklist %>%
                      count(taxa_group)

ggplot(species_checklist, aes(x=taxa_group))+
   geom_bar(stat="count")+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("Number of species in the checklist (excludes Insecta)")
```

![](spp_prep_files/figure-markdown_github/species%20and%20taxa%20group%20checklist-1.png)

``` r
## plot number of insect species and insect families
insecta_checklist_n = invert_taxa_all_long_insect %>%
                      select(family,latin_name)%>%
                      distinct()%>%
                      count(family)
ggplot(insecta_checklist_n, aes(family,n))+
  geom_bar(stat="identity")+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("Number of species per family in the checklist Insecta")
```

![](spp_prep_files/figure-markdown_github/species%20and%20taxa%20group%20checklist-2.png)

``` r
## number of unique latin names (does not include insect)
species_checklist %>% select(latin_name)%>%distinct()%>%nrow() #2363

##add list_type
species_checklist = species_checklist%>%
                    mutate(list_type = "checklist")
```

#### 4.2.2 Get number of species by taxa group on the red list

2772 on redlist. Need to see how many are assessed.

``` r
str(redlist)

ggplot(redlist, aes(x=taxa_group))+
   geom_bar(stat="count")+
   theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("Number of species in the redlist")
```

![](spp_prep_files/figure-markdown_github/number%20species%20redlist-1.png)

``` r
## number of unique latin names
redlist %>% select(latin_name)%>%distinct()%>%nrow() #2772

## add list_type column

redlist = redlist %>%
          mutate(list_type = "redlist")
```

#### 4.2.3 Get a species list that is all those present on the red list and check list

1.  First join and retain all species to see if spelling causes any mismatches.
2.  Retain only species on both lists, join by taxa group and latin name.
3.  Do this for Insecta separately

**What is not present** *Not on Redlist* 343 species on checklist not on redlist.
1. No wintering birds in the checklist.

##### 4.2.3.1 Full species list

``` r
full_species = full_join(species_checklist,redlist, by=c("latin_name","taxa_group"))%>%
                  select(-iucn_criteria)%>%
                  mutate(helcom_category = as.character(helcom_category))
dim(full_species) #2818   6
```

##### 4.2.3.2 Which species are on checklist not redlist

9 species not on redlist:

-   Ringed seal latin name differs - correct in redlist to *Pusa hispida*
-   4 breeding birds not on redlist --spelling differences, correct on redlist
-   3 macrophytes not on redlist (2 are spelling error, corrected)
-   1 invertebreate not on redlist (insecta not assessed here)

``` r
# which are in checklist but not redlist
      full_species %>% filter(is.na(list_type.y)) %>%nrow()  ##9
      full_species %>% filter(is.na(list_type.y)) %>%select(taxa_group)%>%distinct()  ## breeding birds, invert, macrophytes mammals

## check mammals
   full_species %>% filter(is.na(list_type.y)) %>% filter(taxa_group =="mammals") #Pusa hispida  
          
   redlist %>% filter(taxa_group == "mammals") ##Phoca hispida botnica 
    
   mammals %>% select(latin_name,common_name)
   
## check breeding birds
   full_species %>% filter(is.na(list_type.y)) %>% filter(taxa_group =="breeding birds")
  
    redlist %>% filter(grepl("Actitis", latin_name)) ## look for Actitis hypoleucos 
    
    redlist %>% filter(grepl("Larus",latin_name))#Larus minutus (Hydrocoloeus minutus) ##Larus ridibundus (Chroicocephalus ridibundus) 

    redlist %>% filter(grepl("Mergus",latin_name)) ##Mergus albellus (Mergellus albellus) 
          
          
## Check macrophytes
           full_species %>% filter(is.na(list_type.y)) %>% filter(taxa_group =="macrophytes") ##3 species
            
           #Ranunculus trichophyllus subsp. Eradicatus 
           redlist %>% filter(grepl("Ranunculus",latin_name)) #Ranunculus trichophyllus subsp. eradicatus
           
           #Porphyridium aerugineum 3
           redlist %>% filter(grepl("Porphyridium",latin_name))  #Porphyridium aerugineum
           
           #Polygonum foliosum
            redlist %>% filter(grepl("Polygonum",latin_name))  ## not on list
           
            
            
## check inverts
            full_species %>% filter(is.na(list_type.y)) %>% filter(taxa_group =="invert") ##1 species (excludes insects)
            redlist %>% filter(grepl("Euspira",latin_name)) # not there

            
#### UPDATE NAMES ON REDLIST
redlist = redlist %>%
      mutate(latin_name = ifelse(latin_name=="Phoca hispida botnica","Pusa hispida",latin_name),
             latin_name = ifelse(latin_name== "Actitis hypoleucos (Linnaeus, 1758)",
                                 "Actitis hypoleucos",latin_name),
             latin_name = ifelse(latin_name == "Larus minutus",
                                 "Larus minutus (Hydrocoloeus minutus)", latin_name),
             latin_name = ifelse(latin_name == "Larus ridibundus",
                                 "Larus ridibundus (Chroicocephalus ridibundus)",latin_name),
             latin_name = ifelse(latin_name =="Mergellus albellus" ,
                                 "Mergus albellus (Mergellus albellus)",latin_name),
             latin_name = ifelse(latin_name == "Ranunculus trichophyllus subsp. eradicatus",
                                 "Ranunculus trichophyllus subsp. Eradicatus",latin_name),
             latin_name = ifelse(latin_name == "Porphyridium aerugineum",
                                 "Porphyridium aerugineum 3",latin_name))


  
### REJOIN objects
            
full_species = full_join(species_checklist,redlist, by=c("latin_name","taxa_group"))%>%
                  select(-iucn_criteria)%>%
                  mutate(helcom_category = as.character(helcom_category))
dim(full_species) #2811   6
```

##### 4.2.3.3 on redlist not on checklist

**442 species on redlist not on checklist **: 1. 63 species of wintering birds. There is no wintering birds checklist so just use breeding birds and the threat level assigned to species in breeding birds (even if a species is listed on redlist in both breeding and wintering)
2. 9 species of fish. Not found - but perhaps smelt is simply incorrect on redlist (*Osmerus eperlanomarinus*) and should be changed to *Osmerus eperlanus* which is on the checklist?
3. 1 macrophyte not found
4. 369 are invertebrate species, but 367 are insecta and have not integrated insecta into the list yet. The two others were not found under genus on the species\_checklist

``` r
## Species on redlist not on checklist
         full_species %>% filter(is.na(list_type.x)) %>%nrow()  ##442
         full_species %>% filter(is.na(list_type.x)) %>%select(taxa_group)%>%distinct()  ## invert, macrophytes, wintering birds, fish

## check wintering birds - 63 wintering birds.  There is no checklist for wintering birs. Will use the breeding birds and their associated threat level.
   full_species %>% filter(is.na(list_type.x)) %>% filter(taxa_group =="wintering birds")

   
##check fish 
    full_species %>% filter(is.na(list_type.x)) %>% filter(taxa_group =="fish") ## 9 spp
    
    ##search checklist
    species_checklist %>% filter(grepl("Coregonus", latin_name)) ##look for  Coregonus balticus & Coregonus pallasii 
            ##fishbase.org say C. pallasii is found in large lakes
   species_checklist %>% filter(grepl("Lophius", latin_name)) ## Lophius budegassa
   species_checklist %>% filter(grepl("Osmerus", latin_name)) ## Osmerus eperlanomarinus
              ##equivalent (smelt)? - search fishbase.org for Osmerus eperlanomarinus and returns Osmerus eperlanus
   species_checklist %>% filter(grepl("Hexanchus", latin_name)) ## Hexanchus griseus  
   species_checklist %>% filter(grepl("Raja", latin_name)) ## Raja montagui (Spotted ray )
   species_checklist %>% filter(grepl("Acipenser", latin_name)) ## Acipenser sturio
   species_checklist %>% filter(grepl("Orcynopsis", latin_name)) ## Orcynopsis unicolor
   species_checklist %>% filter(grepl("Sphyrna", latin_name)) ## Sphyrna zygaena 
    
   
   ## check macrophytes
   full_species %>% filter(is.na(list_type.x)) %>% filter(taxa_group =="macrophytes") ## 1 species
      ##Persicaria foliosa macrophytes
      species_checklist %>% filter(grepl("Persicaria", latin_name)) ## not on list
   
   ## check invertebrates
   full_species %>% filter(is.na(list_type.x)) %>% filter(taxa_group =="invert") #369
    ## how many are from Insecta
    invert_not_checklist = full_species %>% filter(is.na(list_type.x)) %>% filter(taxa_group =="invert") 
   
   check_insect = invert_taxa_all_long_insect %>%
                  select(family,latin_name)%>%
                  distinct()%>%
                  inner_join(., invert_not_checklist,
                             by="latin_name") ## do inner join to see which are there
    
    dim(check_insect)   ## 367 of 369 found in insecta
    
    ## which are not in insect
    check_insect_spp = check_insect %>% select(latin_name)
    check_insect_spp = check_insect_spp[,1]
    invert_not_checklist %>% filter(!latin_name %in% check_insect_spp)
    
    # Tribelos intextum     invert        <NA>         Species              LC     redlist
     species_checklist %>% filter(grepl("Tribelos", latin_name)) ##not found
    
     # Lunatia pallida     invert        <NA>         Species              VU     redlist
    species_checklist %>% filter(grepl("Lunatia", latin_name)) #not found
```

#### 4.2.4 shared species object

2367 unique species shared between the species checklist and the red list Does not include insecta

``` r
#
## object of only species shared betweent the lists  
shared_species = full_species %>%
                  filter(!is.na(list_type.x) & !is.na(list_type.y))
dim(shared_species)

shared_species %>% select(latin_name)%>%distinct() %>% nrow()##2361
```

##### 4.2.4.1 Duplicates in shared\_species

Cod are assessed at the species level, and by subpopulation. Harbor porpoise and Harbor seal also have assessments by subpopulation. Invert Malacoceros fuliginosus has 2 threat assessments at the species level.

\*\* For Cod - there is a species level assessment and so use this - VU** **For *Malacoceros fuliginosus* there are two species level assessments, one LC, one NE - select LC** **For *Phoca vitulina vitulina* and *Phocoena phocoena* select highest threat for each, VU and CR respectively\*\*

``` r
## are there species with more than one helcom_cateogry threat?
shared_species %>% select(latin_name,helcom_category)%>%distinct()%>%nrow()
##[1] 2366
shared_species %>% select(latin_name)%>%distinct()%>%nrow()
##2361

##YES

##which are duplicated
shared_species %>% select(latin_name)%>% filter(duplicated(.)==TRUE)

shared_species %>% filter(latin_name== "Gadus morhua" | latin_name== "Malacoceros fuliginosus" | latin_name=="Phoca vitulina vitulina" | latin_name=="Phocoena phocoena") 

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

#### 4.2.5 Assess insecta by species and class, add into shared list

##### 4.2.5.1 Join Insecta checklist species to redlist

``` r
full_species_insects = invert_taxa_all_long_insect %>%
                  select(family,latin_name,taxa_group)%>%
                  distinct()%>%
                  mutate(list_type = "checklist") %>%
                  left_join(.,redlist,
                            by=c("latin_name","taxa_group")) ## do not do full join because don't want all redlist inverts

invert_taxa_all_long_insect %>% select(family,latin_name,taxa_group)%>% distinct()%>% dim() #368

dim(full_species_insects)   ## 368
```

##### 4.2.5.2 Which insect species not on redlist

only species from the checklist not on the redlist *Tribelos intextus* there is *Tribelos intextum* in redlist, not sure if this is a typo? Not including now
-------------------------------------------------------------------------------------------------------------------------------------------------------------

``` r
full_species_insects %>% filter(is.na(list_type.y)) ## 1

redlist %>% filter(grepl("Tribelos",latin_name))
```

##### 4.2.5.3 Select insecta species to include

``` r
shared_species_insects = full_species_insects %>%
                         filter(!is.na(list_type.x) & !is.na(list_type.y))
```

##### 4.2.5.4 Summarize to a family level

``` r
## unqiue threat levels 
shared_species_insects %>% select(helcom_category) %>% distinct()
##LC, NE, DD


shared_family_insects = shared_species_insects %>%
                        mutate(helcom_cat_fam_score = ifelse(is.na(helcom_category),0,
                                                   ifelse(helcom_category== "LC",3,
                                                   ifelse(helcom_category == "DD",2,
                                                   ifelse(helcom_category == "NE",1,NA)))))%>%
                        select(family,helcom_cat_fam_score)%>%
                        group_by(family) %>%
                        summarise(helcom_cat_fam_score = max(helcom_cat_fam_score)) %>%
                        ungroup()%>%
                        mutate(helcom_cat_fam = ifelse(helcom_cat_fam_score == 3, "LC",
                                                ifelse(helcom_cat_fam_score == 2, "DD",
                                                ifelse(helcom_cat_fam_score == 1, "NE",
                                                ifelse(helcom_cat_fam_score == 0, NA,"")))))
```

##### 4.2.5.5 Plot Insecta family assigned threat

``` r
shared_family_insects_n = shared_family_insects %>%
                         count(helcom_cat_fam)
          

ggplot(shared_family_insects_n, aes(x=as.factor(helcom_cat_fam), y=n))+
   geom_bar(stat="identity")+
   xlab("HELCOM threat level assigned to Family")+
  ylab("Count")+
  ggtitle("Insecta Families assigned to most vulnerable species category")
```

![](spp_prep_files/figure-markdown_github/Plot%20Insecta%20family%20assigned%20threat-1.png)

##### 4.2.5.6 Join Insecta families to shared\_species list

2421 unique species/families in shared species list

``` r
shared_family_insects1 = shared_family_insects  %>%
                         select(-helcom_cat_fam_score)%>%
                         dplyr::rename(latin_name = family,
                                        helcom_category = helcom_cat_fam) %>%
                         mutate(taxa_group = "invert",
                                list_type.x = "checklist",
                                list_type.y = "redlist")%>%
                         select(latin_name,taxa_group,list_type.x,helcom_category,list_type.y)

dim(shared_family_insects1) ## 60  5

dim(shared_species) #2361


## bind rows
shared_species = bind_rows(shared_species,
                           shared_family_insects1)

dim(shared_species) #2421
```

#### 4.2.6 Plot the shared\_species list by threat category

``` r
shared_species_threat_n = shared_species %>%
                       count(taxa_group,helcom_category)

ggplot(shared_species_threat_n, aes(x=taxa_group, y=n, fill=helcom_category)) +
  geom_bar(stat="identity") +
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, hjust=.5, vjust=.5, face="plain"), axis.text.y = element_text(colour="grey20", size=6)) +
  ggtitle("Count of species in each IUCN category")
```

![](spp_prep_files/figure-markdown_github/plot%20shared_species%20by%20threat-1.png)

### 4.3 Select data for analysis

#### 4.3.1 Exclude taxa that are:

1.  Data decificient (DD)
2.  Not Evaluated (NE)

``` r
## save excluded species in separate object
shared_species_dd_ne = bind_rows(filter(shared_species,helcom_category == 'DD'),
                                 filter(shared_species,helcom_category == 'NE'))
str(shared_species_dd_ne)
dim(shared_species_dd_ne)# 757 5

## plot excluded
shared_species_dd_ne_threat_n = shared_species_dd_ne %>%
                       count(taxa_group,helcom_category)

ggplot(shared_species_dd_ne_threat_n, aes(x=taxa_group, y=n, fill=helcom_category))+
  geom_bar(stat="identity")+
  ggtitle("Count of excluded species ")
```

![](spp_prep_files/figure-markdown_github/exclude%20DD%20and%20NE%20from%20shared_species-1.png)

``` r
##object excluding DD and NE
shared_species2 = bind_rows(filter(shared_species,helcom_category == 'NT'),
                            filter(shared_species,helcom_category == 'LC'),
                            filter(shared_species,helcom_category == 'VU'),
                            filter(shared_species,helcom_category == 'EN'),
                            filter(shared_species,helcom_category == 'CR'),
                            filter(shared_species,helcom_category == 'RE'),
                            filter(shared_species,helcom_category == 'NA'))
                            
                                 
dim(shared_species2); dim(shared_species) # 1456,2421 


## recreate object without DD and NE
shared_species_threat_n = shared_species2 %>%
                       count(taxa_group,helcom_category)

ggplot(shared_species_threat_n, aes(x=taxa_group, y=n, fill=helcom_category))+
  geom_bar(stat="identity")+
   theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("Count of species in each IUCN category")
```

![](spp_prep_files/figure-markdown_github/exclude%20DD%20and%20NE%20from%20shared_species-2.png)

### 4.4 Score threat level

#### 4.4.1 Repeat making the vuln\_lookup

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

#### 4.4.2 Join the vulnerability score to the shared species list

``` r
shared_species3 = shared_species2 %>%
                  left_join(., vuln_lookup, by="helcom_category")
```

### 4.5 Species distributions

#### 4.5.1 Basin names used for distribution

Major basin are the same but smaller regions also included, these differ in number

``` r
fish_loc = fish_long %>% select(location) %>% arrange() %>% distinct() %>%
  mutate(location = ifelse(location == "Åland.Sea", "Aland.Sea",location)) ##21
invert_loc = invert_taxa_all_long %>% select(location)%>%arrange()%>%distinct() ##32
macrophytes_loc = macrophytes_long %>% select(location)%>%arrange()%>%distinct() ##17
mammals_loc = mammals_long %>% select(location)%>%arrange()%>%distinct()%>%
              mutate(location = ifelse(location == "Åland.Sea", "Aland.Sea",location))##19
```

#### 4.5.2 Location name object

``` r
dist_loc = bind_rows(fish_loc,invert_loc,macrophytes_loc,mammals_loc)%>%
            arrange()%>%
            distinct()
## Export location object, clean in excel and reimport
#write.csv(dist_loc, file.path(dir_spp,'distribution_locations.csv'), row.names=FALSE)

## Read in csv with HOLAS basin names added to the distribution locations
dist_loc = read.csv(file.path(dir_spp,'distribution_locations.csv'),sep=";", stringsAsFactors = FALSE)

##number of basin
dist_loc %>% select(basin)%>%distinct()%>%nrow() #17 ## These match HOLAS basins
```

#### 4.5.3 Join dist\_loct to taxa checklists

This excludes birds because distribution given by country.
Do insecta separately

``` r
### species (not insected)
species_dist = bind_rows(fish_long,
                         invert_taxa_all_long_noinsect,
                         macrophytes_long,
                         mammals_long)
species_dist = species_dist%>%
              full_join(., dist_loc, by="location")

str(species_dist)


### species insecta to families

insect_sp_dist = invert_taxa_all_long_insect %>%
                 full_join(.,dist_loc, by="location")
        str(insect_sp_dist)

##inner join insect_sp_dit to shared_family_insects
insect_fam_dist = insect_sp_dist %>%
                  inner_join(., select(shared_family_insects1,latin_name),
                             by=c("family"="latin_name"))
  
dim(insect_fam_dist);dim(insect_sp_dist)    
insect_fam_dist %>% select(family) %>% distinct()

##prepare insect_fam_dist to join with species dies
insect_fam_dist = insect_fam_dist %>%
                  select(family,common_name,location,presence,taxa_group,basin)%>%
                  dplyr::rename(latin_name = family)


## JOIN the species dist with the insecta family dist
dim(species_dist) #63672     6
species_dist = bind_rows(species_dist,
                         insect_fam_dist)

dim(species_dist) #75448     6

## basins NA ?
species_dist %>% filter(is.na(basin)) %>% select(taxa_group,basin,location)%>% distinct() #  invert  <NA> Eckernförde.Bay

species_dist = species_dist %>%
               mutate(basin = ifelse(is.na(basin) & location == "Eckernförde.Bay", "Kiel Bay", basin))


species_dist %>% filter(is.na(basin)) 
```

### 4.6 Species distributions + Threat score

``` r
## number of species that should be on final list is
shared_species3 %>% nrow() ## 1456 species should be on the final list


## join shared_species3 to species_dist
shared_species_dist = left_join(shared_species3, species_dist, 
                                by=c("latin_name","taxa_group")) %>%
                      select(-list_type.x, -list_type.y,-location) %>%  ## exclude location because may have more than one location per basin
                      select(taxa_group,latin_name,common_name,helcom_category,helcom_category_numeric,basin,presence) %>%
                      distinct()%>%
                      arrange(taxa_group, latin_name)


dim(shared_species_dist) ##25467
shared_species_dist %>% select(latin_name)%>% distinct() %>% nrow() #1456
```

### 4.6.1 Plot IUCN category by taxa and basin

Breeding birds were distributed by country so no basin assignment currently.

``` r
## recreate object without DD and NE
shared_species_dist_n = shared_species_dist %>%
                       count(basin,taxa_group,helcom_category)%>%
                        ungroup()

ggplot(shared_species_dist_n, aes(x=taxa_group, y=n, fill=helcom_category))+
  geom_bar(stat="identity")+
  facet_wrap(~basin, scales="free_y")+
   theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("Count of species in each IUCN category")
```

![](spp_prep_files/figure-markdown_github/unnamed-chunk-2-1.png)

``` r
## Count of species not by category
shared_species_dist_n_no_category = shared_species_dist %>%
                       count(basin,taxa_group) %>% ungroup()

ggplot(shared_species_dist_n_no_category, aes(x=taxa_group, y=n))+
  geom_bar(stat="identity")+
  facet_wrap(~basin)+
  #facet_wrap(~basin, scales="free_y")+
   theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("Count of species by taxa group in each basin")
```

![](spp_prep_files/figure-markdown_github/unnamed-chunk-2-2.png)

``` r
## SAVE for visualize
spp_dist_value_data = shared_species_dist_n_no_category%>%
                      select(value =n,
                             location = basin,
                             variable=taxa_group)%>%
                     mutate(unit = "count",
                            data_descrip = "species presence/absence",
                            bhi_goal = "SPP")

write.csv(spp_dist_value_data, file.path(dir_baltic,'visualize/spp_dist_value_data.csv'),row.names = FALSE)

spp_dist_threat_value_data = shared_species_dist_n%>%
                             dplyr::rename(value=n,
                                           location = basin)%>%
                             mutate(variable = paste(taxa_group, "_",helcom_category,sep=""))%>%
                             select(-taxa_group, -helcom_category)%>%
                            mutate(unit = "count",
                            data_descrip = "species presence/absence",
                            bhi_goal = "SPP")


write.csv(spp_dist_threat_value_data, file.path(dir_baltic,'visualize/spp_dist_threat_value_data.csv'),row.names = FALSE)


# distribution without DD with each taxa group separately by basin & threat
#invert
##color to highlight Gulf of Finland
col_gof =rep(c(rep("black",9),"red",rep("black",7)),4)
ggplot(filter(shared_species_dist_n, taxa_group=="invert"))+
    # geom_point(aes(basin, n), size=2.5, colour=col_gof)+
  facet_wrap(~helcom_category, scales="free_y")+
  ylab("Count of species")+
   theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("Count of Invert species in each IUCN category by Basin")
```

![](spp_prep_files/figure-markdown_github/unnamed-chunk-2-3.png)

``` r
## limit the number of invert basins
data_filtered_plot = shared_species_dist_n %>% filter(taxa_group=="invert")%>% filter(basin %in% c("Bothnian Bay", "Bothnian Sea","Aland Sea","The Quark","Gulf of Finland"))
ggplot(data_filtered_plot)+
    geom_point(aes(basin,n), size=2.5)+
  facet_wrap(~helcom_category, scales="free_y")+
  ylab("Count of species")+
   theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("Count of Invert species in each IUCN category Northern basins")
```

![](spp_prep_files/figure-markdown_github/unnamed-chunk-2-4.png)

``` r
#macrophytes
ggplot(filter(shared_species_dist_n, taxa_group=="macrophytes"))+
    geom_point(aes(basin,n))+
  facet_wrap(~helcom_category, scales="free_y")+
   theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("Count of macrophytes species in each IUCN category by Basin")
```

![](spp_prep_files/figure-markdown_github/unnamed-chunk-2-5.png)

``` r
#fish
ggplot(filter(shared_species_dist_n, taxa_group=="fish"))+
    geom_point(aes(basin,n))+
  facet_wrap(~helcom_category, scales="free_y")+
   theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("Count of fish species in each IUCN category by Basin")
```

![](spp_prep_files/figure-markdown_github/unnamed-chunk-2-6.png)

``` r
#mammals
ggplot(filter(shared_species_dist_n, taxa_group=="mammals"))+
    geom_point(aes(basin,n))+
  facet_wrap(~helcom_category, scales="free_y")+
   theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y = element_text(colour="grey20",size=6))+
  ggtitle("Count of mammals species in each IUCN category by Basin")
```

![](spp_prep_files/figure-markdown_github/unnamed-chunk-2-7.png)

### 4.6.2 Export shared\_species\_dist object

For use in ICO status calculation

``` r
## write to two location - SPP folder and ICO folder
write.csv(shared_species_dist, file.path(dir_spp,'checklist_redlist_data_for_status.csv'),row.names=FALSE)  


write.csv(shared_species_dist, file.path(dir_prep,'ICO/data_database/checklist_redlist_data_for_status.csv'),row.names=FALSE)
```

### 4.7 Status calculation by basin

Data are on the HOLAS basin scale. Calculate biodiversity status by basin and then apply to BHI regions.
*Note, this will mean that the data layer sent to layers and what is registered in layers.csv is very different than what is done if use the spatial data layers from HELCOM where status is directly calculated for BHI regions and this is done formally in functions.r*

### 4.7.1 Calulate SPP status using checklist and redlist data with all species weighted equally

**Exclude birds for now**
Do a single calculation including all species. Will compare this result to doing this calculation first for each taxa group and then taking the geometric mean (See Section 5.7.2)

##### 4.7.1.1 Calculate status

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

## count the number of species in each BHI region
sum_spp_basin = shared_species_dist %>%
                filter(taxa_group != "breeding birds")%>% ## remove birds
                filter(presence != 0) %>% # select only present taxa
                select(basin, latin_name)%>%
                dplyr::count(basin)
dim(sum_spp_basin) #17 2


shared_species_dist%>% filter(basin== "Aland Sea") %>% nrow() ## check to make sure works
head(sum_spp_basin)

spp_status_basin = full_join(sum_wi_basin,sum_spp_basin, by="basin") %>%
             mutate(wi_spp = sum_wi/n,
                    status = 1 - wi_spp)
```

##### 4.7.1.2 Scale lower end to zero if 75% extinct

Currently, species are labled regionally extinct

``` r
## calculate percent extinct in each region
spp_ex_basin = shared_species_dist %>%
              filter(taxa_group != "breeding birds")%>% 
              filter(presence != 0) %>% # select only present taxa
              dplyr::rename(weights=helcom_category_numeric)%>%## remove birds
              filter(weights == 1)
spp_ex_basin

## which are RE (regionally extinct)
spp_ex_basin %>% select(latin_name,common_name)%>%distinct() ##2 


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

##### 4.7.1.3 Plot status by basin

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

![](spp_prep_files/figure-markdown_github/plot%20basin%20status-1.png)

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

![](spp_prep_files/figure-markdown_github/plot%20basin%20status-2.png)

### 4.7.2 Calulate SPP status using checklist and redlist data by taxa group and geometric mean

**Exclude birds for now**
Calculation status by taxa group by basin and then taking the geometric mean for each basin.

##### 4.7.2.1 Calculate status by taxa group

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

## count the number of species in each BHI region by taxa group
sum_spp_basin_taxa_group = shared_species_dist %>%
                filter(taxa_group != "breeding birds")%>% ## remove birds
                filter(presence !=0) %>% ## filter out species not present
                select(basin, taxa_group,latin_name)%>%
                dplyr::count(basin, taxa_group)
dim(sum_spp_basin_taxa_group) #68 3


spp_status_basin_taxa_group = full_join(sum_wi_basin_taxa_group,
                                        sum_spp_basin_taxa_group, by=c("basin","taxa_group")) %>%
             mutate(wi_spp_taxa = sum_wi/n,
                    status_taxa = 1 - wi_spp_taxa)
```

##### 4.7.2.2 Plot status by taxa group

``` r
ggplot(spp_status_basin_taxa_group)+
  geom_point(aes(taxa_group,status_taxa,size=n))+
  facet_wrap(~basin) +
  ylim(0,1.5)+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y =  element_text(colour="grey20",size=6))+
  ggtitle("Taxa group Status by Basin, n= species richness")
```

![](spp_prep_files/figure-markdown_github/plot%20taxa_group%20Status-1.png)

##### 4.7.2.3 For each taxa group - Scale lower end to zero if 75% extinct

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

## which are RE (regionally extinct)
spp_ex_basin_taxa_group %>% select(latin_name,common_name)%>%distinct() ##2 


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

##### 4.7.2.4 Plot again status by taxa group

``` r
ggplot(spp_status_basin_taxa_group)+
  geom_point(aes(taxa_group,status_taxa,size=n))+
  facet_wrap(~basin) +
  ylim(0,1.5)+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y =  element_text(colour="grey20",size=6))+
  ggtitle("Taxa group Status by Basin, n= species richness")
```

![](spp_prep_files/figure-markdown_github/plot%20taxa_group%20Status%20again-1.png)

##### 4.7.2.5 Calculate Geometric Mean for Basin status

``` r
spp_status_basin_geo = spp_status_basin_taxa_group %>%
                        select(basin, status_taxa) %>%
                       group_by(basin)%>%
                       summarise(status_basin =exp(mean(log(status_taxa))))%>%
                        ungroup()
```

##### 4.7.2.4 Plot Geometric Mean for Basin status

``` r
ggplot(spp_status_basin_geo)+
  geom_point(aes(basin, status_basin),size=2)+
  ylim(0,1)+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),axis.text.y =  element_text(colour="grey20",size=6))+
  ggtitle("SPP Basin status from geometric mean of taxa group status")
```

![](spp_prep_files/figure-markdown_github/plot%20basin%20Status%20from%20geometric%20mean-1.png)

#### 4.7.3 Compare alternative approaches to Basin level SPP status calculation

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

![](spp_prep_files/figure-markdown_github/comparsion%20of%20basin%20level%20spp%20status-1.png)

### 4.8 Apply basin status to BHI regions

#### 4.8.1 Read in basin to BHI ID lookup

``` r
basin_lookup = read.csv(
              file.path(dir_spp,'bhi_basin_country_lookup.csv'), sep=";", stringsAsFactors = FALSE) 
basin_lookup = basin_lookup %>%
               select(Subbasin, BHI_ID)%>%
               dplyr::rename(basin = Subbasin,
                             rgn_id = BHI_ID)
              
str(basin_lookup)
```

#### 4.8.2 Join basin lookup to spp\_status\_basin\_geo

``` r
spp_status_rgn_geo = full_join(spp_status_basin_geo, basin_lookup, by="basin") %>%
                      arrange(rgn_id)

str(spp_status_rgn_geo)
```

#### 4.8.3 Plot status (geometric taxa group mean) by BHI region

``` r
ggplot(spp_status_rgn_geo)+
  geom_point(aes(rgn_id, status),size=2.5)+
  ylim(0,1)+
  ggtitle("SPP status by BHI region (calculated from taxa group geometric mean)")
```

![](spp_prep_files/figure-markdown_github/plot%20status%20from%20geometric%20mean%20by%20bhi%20region-1.png)

#### 4.8.4 Prepare data for layers

Saved as csv in Section 6

``` r
spp_status_rgn_geo = spp_status_rgn_geo %>%
                     select(rgn_id,status) %>%
                     dplyr::rename(score=status)%>%
                     mutate(dimension = 'status')
head(spp_status_rgn_geo)
```

5. Spatial data data layer preparation
--------------------------------------

This is to show the outcome of using these data. These data are currently not saved as a layer and used for status calculations. The data prepared in section 4 is used.

### 5.1 Data organization

#### 5.1.1 Read in species data

``` r
## read in data...
data = read.csv(file.path(dir_spp, 'spatial_data_prep/data/species_IUCN.csv'))
dim(data)
str(data)
```

#### 5.1.2 Set up vulnerability code

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

#### 5.1.3 Join numeric vulnerability code to species

``` r
data2 = data %>%
        left_join(.,vuln_lookup, by= "IUCN")
head(data2)
```

#### 5.1.4 Plot by region

``` r
ggplot(data2)+
  geom_point(aes(rgn_id, species_name),size=1)+
  facet_wrap(~IUCN)+
  theme(axis.text.y = element_text(colour="grey20", size=2, angle=0, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle ("Species presence and vulnerability by region")
```

![](spp_prep_files/figure-markdown_github/plot%20raw%20by%20region-1.png)

``` r
ggplot(data2)+
  geom_point(aes(rgn_id, species_name, colour=taxa),size=1)+
  facet_wrap(~IUCN)+
  theme(axis.text.y = element_text(colour="grey20", size=2, angle=0, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle ("Species presence and vulnerability by region")
```

![](spp_prep_files/figure-markdown_github/plot%20raw%20by%20region-2.png)

#### 5.1.5 Distribution in IUCN categories

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

ggplot(percent_vuln, aes(x=taxa, y=percent, fill=IUCN))+
  geom_bar(stat="identity")+
  ggtitle("Percent of species in each IUCN category")
```

![](spp_prep_files/figure-markdown_github/distribution%20in%20IUCN%20categories-1.png)

#### 5.1.6 Total number of species in each taxa group by IUCN categroy

``` r
ggplot(percent_vuln, aes(x=taxa, y=n, fill=IUCN))+
  geom_bar(stat="identity")+
  ggtitle("Number of species in each IUCN category")
```

![](spp_prep_files/figure-markdown_github/number%20of%20species%20in%20each%20taxa%20group-1.png)

``` r
ggplot(filter(percent_vuln, IUCN != "DD"), aes(x=taxa, y=n, fill=IUCN))+
  geom_bar(stat="identity")+
  ggtitle("Number of species in each IUCN category without DD")
```

![](spp_prep_files/figure-markdown_github/number%20of%20species%20in%20each%20taxa%20group-2.png)

#### 5.1.7 Remove DD species

Species given DD are not included. See methods above and in Halpern et al. 2012

Benthos has a much larger number of species in DD category

``` r
data3 = data2 %>%
        filter(IUCN != "DD")
dim(data3);dim(data2)
```

#### 5.1.8 Check for duplicates

``` r
data3 %>% nrow() #2205
data3 %>% distinct() %>% nrow() #2096

## appears to be duplicates

##remove duplicates by selecting the distinct columns
data3 = data3 %>% 
        arrange(rgn_id,species_name) %>%
        distinct()
        
dim(data3) #2096
```

#### 5.1.7 Export Species list

Export species list to be check to see if sufficient coverage

``` r
species_list = data3 %>%
              select(species_name,taxa)%>%
              distinct(.)
dim(species_list) #125  1

write.csv(species_list, file.path(dir_spp,'species_list_included.csv'), row.names=FALSE)
```

### 5.2 Data layer for functions.r

If this data set is used, the data layer can be exported here.

``` r
data3 = data3 %>%
        select(rgn_id, species_name, IUCN_numeric) %>%
        dplyr::rename(weights = IUCN_numeric)
##write.csv(data3, file.path(dir_layers, 'spp_div_vuln_bhi2015.csv'), row.names=FALSE)
```

### 5.3 Status calcalculation

#### 5.3.1 Calculate status

``` r
##sum the weights for each BHI region
sum_wi = data3 %>%
         group_by(rgn_id)%>%
         summarise(sum_wi =sum(weights))%>%
         ungroup()
dim(sum_wi)

## count the number of species in each BHI region
sum_spp = data3 %>%
          select(rgn_id, species_name)%>%
          dplyr::count(rgn_id)
dim(sum_spp)


data3%>% filter(rgn_id== 1) %>% nrow() ## check to make sure works
head(sum_spp)

spp_status = full_join(sum_wi,sum_spp, by="rgn_id") %>%
             mutate(wi_spp = sum_wi/n,
                    status = 1 - wi_spp)
```

#### 5.3.2 Scale lower end to zero if 75% extinct

Currently, no species labeled extinct but will set up code in case used in the future

``` r
## calculate percent extinct in each region
spp_ex = data3 %>% 
         filter(weights == 1)
spp_ex
## No species extinct
## IF spp are extinct, find % extinct out of total number of species for each region; join to the status calculation; set regions with 75% or more extinct to a score of 0
```

#### 5.3.3 Plot status

``` r
## Plot status
ggplot(spp_status)+
  geom_point(aes(rgn_id,round(status*100)),size=3)+
  ylim(0,100)+
  ylab("Status") + 
  xlab("BHI region")+
  ggtitle("SPP status by BHI region")
```

![](spp_prep_files/figure-markdown_github/plot%20spp%20status-1.png)

``` r
## Size points to number of species in a region
ggplot(spp_status)+
  geom_point(aes(rgn_id,round(status*100), size=n))+
  ylim(0,100)+
  ylab("Status") + 
  xlab("BHI region")+
  ggtitle("SPP status by BHI region, n= species richness")
```

![](spp_prep_files/figure-markdown_github/plot%20spp%20status-2.png)

### 6. Send data layer to layers

Using calculations done in Section 4 (data from Checklists and Redlist). Status is the geometric mean of the taxa group status calculations.

#### 6.1 Write status layers

``` r
write.csv(spp_status_rgn_geo, file.path(dir_layers,'bd_spp_status_bhi2015.csv'), row.names = FALSE)
```

7. Data layer considerations / concerns
---------------------------------------

### 7.1 Aquatic insects

Aquatic insects included by species which results in a very high species richnessness in the Bothnian Bay, Sea, and Gulf of Finland. Jonne says that in some parts of the Baltic Sea insect larvae only indentified to family while others to species (we only have those identified to species in the checklist species distribtuion). **We have modified the approach so that the Class Insecta is only now identified to Family level. The family HELCOM Redlist category is assigned by the species in that category with the highest level of concern**

TO DO
-----

1.  Decide how to deal with birds that have spatial dist by country (not basin)
2.  Decide if it is a problem that status is dominated by inverts with LC
3.  check to see if any invasives included in the species list
4.  How to calculate a trend?

Explore using Global Trend data
-------------------------------

``` r
rgn_id_gl <- read_csv('https://raw.githubusercontent.com/OHI-Science/ohi-webapps/dev/custom/bhi/sc_studies_custom_bhi.csv')

### Global CS status and trend scores

bd_status_gl <- read_csv('https://rawgit.com/OHI-Science/ohi-global/draft/eez2016/scores.csv'); head(bd_status_gl)

bd_status_gl <- read_csv('https://raw.githubusercontent.com/OHI-Science/ohi-global/draft/eez2016/scores.csv'); head(bd_status_gl)


# filter BHI EEZs

bd_scores_bhi <- bd_status_gl %>% 
  filter(goal == 'BD', 
         dimension %in% 'trend') %>% 
  dplyr::rename(gl_rgn_id = region_id) %>%
  left_join(rgn_id_gl %>%
              select(gl_rgn_id,
                     gl_rgn_name), by = 'gl_rgn_id') %>%
  filter(gl_rgn_id %in% rgn_id_gl$gl_rgn_id) %>%
  arrange(gl_rgn_name) %>%
  select(country = gl_rgn_name, score)

as.data.frame(bd_scores_bhi)

#   gl_rgn_name gl_rgn_id dimension score
# 1     Denmark       175     trend -0.03
# 2     Estonia        70     trend -0.03
# 3     Finland       174     trend -0.12
# 4     Germany       176     trend  0.00
# 5      Latvia        69     trend -0.08
# 6   Lithuania       189     trend -0.19
# 7      Poland       178     trend -0.21
# 8      Russia        73     trend -0.07
# 9      Sweden       222     trend -0.05

# assign bhi id to country scores 
bhi_country_lookup <- read_csv2(file.path(dir_prep, "bhi_basin_country_lookup.csv")) %>% 
  dplyr::select(country = rgn_nam, rgn_id = BHI_ID)

bd_trend = full_join(bd_scores_bhi, bhi_country_lookup, by = "country") %>% 
  select(rgn_id, score) %>% 
  mutate(rgn_id = as.integer(rgn_id)) %>%
  complete(rgn_id = full_seq(c(1,42), 1))

write_csv(bd_trend, file.path(dir_layers, "bd_spp_trend_scores_bhi2015.csv"))
```