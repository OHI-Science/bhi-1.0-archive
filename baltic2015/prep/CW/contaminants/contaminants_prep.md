contaminants\_prep
================

``` r
## source common libraries, directories, functions, etc
# Libraries
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
## rprojroot
root <- rprojroot::is_rstudio_project


## make_path() function to 
make_path <- function(...) rprojroot::find_root_file(..., criterion = is_rstudio_project)

dir_layers = make_path('baltic2015/layers') # replaces  file.path(dir_baltic, 'layers')

source('~/github/bhi/baltic2015/prep/common.r')
dir_cw    = file.path(dir_prep, 'CW')
dir_con    = file.path(dir_prep, 'CW/contaminants')

## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_con, 'contaminants_prep.rmd')
```

1. Contaminant Data Prep
========================

1.2 Indicators
--------------

3 indicators are proposed which would then be combined to give an overall comtanimant sub-component status.

### 1.2.1 (1) PCB concentration indicator

**CB-153 concentration** - Suggested by Anders Bignet and Elisabeth Nyberg.

This would be a good indicator because it is abundant (so almost always measured) and will have few detection / quantification limit problems.

Use the EU threshold for human health as the reference point.

#### 1.2.1a Original PCB indicator: ICES-6 PCB

Sum of PCB28, PCB52, PCB101, PCB138, PCB153 and PCB180.

This is similar to the ICES-7 except that PCB 118 is excluded (since it is metabolized by mammals).

75 ng/g wet weight is the [EU threshold for fish muscle. See Section 5 Annex, 5.3](http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=OJ:L:2011:320:0018:0023:EN:PDF)

**Additional information from HELCOM on the Core Indicators**
[HELCOM Core Indicator of Hazardous Substances Polychlorinated biphenyls (PCB) and dioxins and furans 2013](http://www.helcom.fi/Core%20Indicators/HELCOM-CoreIndicator_Polychlorinated_biphenyls_and_dioxins_and_furans.pdf)

*Relevant text from the HELCOM core indicator report*
"The PCBs included in this core indicator report are the 7 PCB congeners that have been monitored since the beginning of the HELCOM and OSPARCOM monitoring programmes, carefully selected mainly by ICES working groups due to their relatively uncomplicated identification and quantification in gas chromatograms and as they usually contribute a very high proportion of the total PCB content in environmental samples. These are the ‘ICES 7’: CB-28, CB-52, CB-101, CB-118, CB-138, CB-153 and CB-180."

*Determination of GES boundary* The CORESET expert group decided that, due to uncertainties in the target setting on the OSPAR and EU working groups, the seven PCBs should be monitored and concentrations analysed but the core indicator assesses primarily two congeners only: CB-118 (dioxin like) and 153 (non-dioxin like). Tentatively the OSPAR EACs for these two congeners are suggested to be used.

### 1.3 (2) TEQ value for PCBs and Dioxins

[HELCOM Core Indicator of Hazardous Substances Polychlorinated biphenyls (PCB) and dioxins and furans](http://www.helcom.fi/Core%20Indicators/HELCOM-CoreIndicator_Polychlorinated_biphenyls_and_dioxins_and_furans.pdf) *There should be a more recent document*

Dioxins are included in several international agreements, of which the Stockholm Convention and the Convention on Long Range Transboundary Air are among the most important for the control and reduction of sources to the environment. WHO and FAO have jointly established a maximum tolerable human intake level of dioxins via food, and within the EU there are limit values for dioxins in food and feed stuff (EC 2006). Several other EU legislations regulate dioxins, e.g. the plan for integrated pollution prevention and control (IPPC) and directives on waste incineration (EC, 2000, 2008). The EU has also adopted a Community Strategy for dioxins, furans and PCBs (EC 2001).

**Determination of GES boundary** For dioxins, it was decided to use the GES boundary of 4.0 ng kg-1 ww WHO-TEQ for dioxins and 8.0 ng kg-1 ww WHO-TEQ for dioxins and dl-PCBs.

### 1.4 (3) PFOS indicator

[HElCOM PFOS core indicator document](http://www.helcom.fi/Core%20Indicators/PFOS_HELCOM%20core%20indicator%202016_web%20version.pdf)

### 1.5 Additional references

[Faxneld et al. 2014](http://www.diva-portal.org/smash/record.jsf?pid=diva2%3A728508&dswid=1554) Biological effects and environmental contaminants in herring and Baltic Sea top predators

2. Data
=======

2.1 Data sources
----------------

ICES
[ICES database](http://dome.ices.dk/views/ContaminantsBiota.aspx)
Downloaded 20 October 2015 by Cornelia Ludwig

IVL (Svenska Miljönstitutet / Swedish Environmental Research Institute)
[IVL database](http://dvsb.ivl.se/)
Downloaded 2 December 2015 by Cornelia Ludwig
[IVL detection limit information](http://www.ivl.se/sidor/lab--analys/miljo/biota.html)

2.2 Data prep prior to database
-------------------------------

Data were cleaned and harmonized by Cornelia Ludwig prior to being put into the BHI database.
**PCBs**
(1) Swedish data were given in lipid weight and were converted to wet weight. Not all samples had a Extrlip (fat) percentage and therefore could not be converted. These samples were not included in the database
(2) Data were in different units and were standardized to mg/kg (however the values listed for the detection limit and the quantification limit were not updated to reflect the value unit change)

3. Other Info
=============

........

4. Data Prep - PCB Indicator
============================

4.1 Initial data prep
---------------------

### 4.1.1 Read in unfiltered data

    - Read in data exported from database.  
    - Read in unfiltered ICES and IVL data sources *there are duplicates*

``` r
## Unfiltered data
ices_unfilter =read.csv(file.path(dir_con, 'contaminants_data_database/ices_unfilter.csv'), stringsAsFactors = FALSE)

                           
dim(ices_unfilter) #[1] 18312    18
```

    ## [1] 18312    18

``` r
str(ices_unfilter)   ## date is as.character  
```

    ## 'data.frame':    18312 obs. of  18 variables:
    ##  $ source           : chr  "ICES" "ICES" "ICES" "ICES" ...
    ##  $ country          : chr  "Poland" "Poland" "Poland" "Poland" ...
    ##  $ station          : chr  "LWLA" "LWLA" "LWLA" "LWLA" ...
    ##  $ lat              : num  54.9 54.9 54.9 54.9 54.9 ...
    ##  $ lon              : num  18.7 18.7 18.7 18.7 18.7 ...
    ##  $ year             : int  2009 2009 2009 2009 2009 2009 2009 2009 2009 2009 ...
    ##  $ date             : chr  "01/09/09" "01/09/09" "01/09/09" "01/09/09" ...
    ##  $ variable         : chr  "CB101" "CB101" "CB101" "CB101" ...
    ##  $ qflag            : chr  "" "" "" "" ...
    ##  $ value            : num  0.00049 0.00048 0.00091 0.00078 0.00054 0.00046 0.0006 0.00067 0.00054 0.00043 ...
    ##  $ unit             : chr  "mg/kg" "mg/kg" "mg/kg" "mg/kg" ...
    ##  $ vflag            : chr  "A" "A" "A" "A" ...
    ##  $ detli            : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ lmqnt            : num  0.14 0.14 0.14 0.14 0.14 0.14 0.14 0.14 0.14 0.14 ...
    ##  $ sub_id           : chr  "19" "20" "13" "15" ...
    ##  $ bio_id           : int  2971439 2971440 2971433 2971435 2971434 2971436 2971438 2971437 2971423 2971422 ...
    ##  $ samp_id          : int  1109586 1109586 1109586 1109586 1109586 1109586 1109586 1109586 1109586 1109586 ...
    ##  $ num_indiv_subsamp: int  1 1 1 1 1 1 1 1 1 1 ...

``` r
head(ices_unfilter)
```

    ##   source country station      lat      lon year     date variable qflag
    ## 1   ICES  Poland    LWLA 54.91667 18.66667 2009 01/09/09    CB101      
    ## 2   ICES  Poland    LWLA 54.91667 18.66667 2009 01/09/09    CB101      
    ## 3   ICES  Poland    LWLA 54.91667 18.66667 2009 01/09/09    CB101      
    ## 4   ICES  Poland    LWLA 54.91667 18.66667 2009 01/09/09    CB101      
    ## 5   ICES  Poland    LWLA 54.91667 18.66667 2009 01/09/09    CB101      
    ## 6   ICES  Poland    LWLA 54.91667 18.66667 2009 01/09/09    CB101      
    ##     value  unit vflag detli lmqnt sub_id  bio_id samp_id num_indiv_subsamp
    ## 1 0.00049 mg/kg     A    NA  0.14     19 2971439 1109586                 1
    ## 2 0.00048 mg/kg     A    NA  0.14     20 2971440 1109586                 1
    ## 3 0.00091 mg/kg     A    NA  0.14     13 2971433 1109586                 1
    ## 4 0.00078 mg/kg     A    NA  0.14     15 2971435 1109586                 1
    ## 5 0.00054 mg/kg     A    NA  0.14     14 2971434 1109586                 1
    ## 6 0.00046 mg/kg     A    NA  0.14     16 2971436 1109586                 1

``` r
min(ices_unfilter$year); max(ices_unfilter$year)
```

    ## [1] 1978

    ## [1] 2013

``` r
ivl_unfilter = read.csv(file.path(dir_con, 'contaminants_data_database/ivl_unfilter.csv'),stringsAsFactors = FALSE)

                         
dim(ivl_unfilter)# 19716    18
```

    ## [1] 19716    18

``` r
str(ivl_unfilter) ## date is as.character  ## mix of just year, just month & year, just full date  
```

    ## 'data.frame':    19716 obs. of  18 variables:
    ##  $ source           : chr  "IVL" "IVL" "IVL" "IVL" ...
    ##  $ country          : chr  "Sweden" "Sweden" "Sweden" "Sweden" ...
    ##  $ station          : chr  "Utlaengan" "Utlaengan" "Utlaengan" "Utlaengan" ...
    ##  $ lat              : num  55.9 55.9 55.9 55.9 55.9 ...
    ##  $ lon              : num  15.8 15.8 15.8 15.8 15.8 ...
    ##  $ year             : int  2006 2006 2006 2006 2006 2006 2006 2006 2006 2006 ...
    ##  $ date             : chr  "2006" "2006" "2006" "2006" ...
    ##  $ variable         : chr  "CB101" "CB101" "CB101" "CB101" ...
    ##  $ qflag            : chr  "" "" "" "" ...
    ##  $ value            : num  0.00012 0.000244 0.000296 0.00035 0.000596 ...
    ##  $ unit             : chr  "mg/kg" "mg/kg" "mg/kg" "mg/kg" ...
    ##  $ vflag            : logi  NA NA NA NA NA NA ...
    ##  $ detli            : logi  NA NA NA NA NA NA ...
    ##  $ lmqnt            : logi  NA NA NA NA NA NA ...
    ##  $ sub_id           : logi  NA NA NA NA NA NA ...
    ##  $ bio_id           : chr  "P2006/06500" "P2006/06503" "P2006/06494" "P2006/06497" ...
    ##  $ samp_id          : logi  NA NA NA NA NA NA ...
    ##  $ num_indiv_subsamp: logi  NA NA NA NA NA NA ...

``` r
head(ivl_unfilter)
```

    ##   source country   station     lat    lon year date variable qflag
    ## 1    IVL  Sweden Utlaengan 55.9491 15.781 2006 2006    CB101      
    ## 2    IVL  Sweden Utlaengan 55.9491 15.781 2006 2006    CB101      
    ## 3    IVL  Sweden Utlaengan 55.9491 15.781 2006 2006    CB101      
    ## 4    IVL  Sweden Utlaengan 55.9491 15.781 2006 2006    CB101      
    ## 5    IVL  Sweden Utlaengan 55.9491 15.781 2006 2006    CB101      
    ## 6    IVL  Sweden Utlaengan 55.9491 15.781 2006 2006    CB101      
    ##       value  unit vflag detli lmqnt sub_id      bio_id samp_id
    ## 1 0.0001196 mg/kg    NA    NA    NA     NA P2006/06500      NA
    ## 2 0.0002444 mg/kg    NA    NA    NA     NA P2006/06503      NA
    ## 3 0.0002964 mg/kg    NA    NA    NA     NA P2006/06494      NA
    ## 4 0.0003502 mg/kg    NA    NA    NA     NA P2006/06497      NA
    ## 5 0.0005957 mg/kg    NA    NA    NA     NA P2006/06495      NA
    ## 6 0.0006020 mg/kg    NA    NA    NA     NA P2006/06493      NA
    ##   num_indiv_subsamp
    ## 1                NA
    ## 2                NA
    ## 3                NA
    ## 4                NA
    ## 5                NA
    ## 6                NA

``` r
min(ivl_unfilter$year); max(ivl_unfilter$year)
```

    ## [1] 1990

    ## [1] 2013

``` r
## These data do not have BHI IDS affiliated with them
```

### 4.1.2 Filter data to years 2009-2013

``` r
ices_unfilter = ices_unfilter %>% filter(year %in% 2009:2013)
dim(ices_unfilter) # 4691   18
```

    ## [1] 4691   18

``` r
ivl_unfilter = ivl_unfilter %>% filter(year %in% 2009:2013)
dim(ivl_unfilter) # 3556   18
```

    ## [1] 3556   18

### 4.1.3 Format columns

1.  date
    -   For these years, are full dates present (not just year or year and month)?

2.  Remove IVL columns
    -   Remove columns from IVL that were added to match ICES. These are all of type "logical" and will make joining dataframes difficult: *vflag,detli,lmqnt,sub\_id,samp\_id, num\_indiv\_subsamp*

3.  ICES bio\_id make character

``` r
ices_unfilter %>% select(date) %>% head(.)
```

    ##       date
    ## 1 01/09/09
    ## 2 01/09/09
    ## 3 01/09/09
    ## 4 01/09/09
    ## 5 01/09/09
    ## 6 01/09/09

``` r
    ## date format is dd/mm/yy

ices_unfilter = ices_unfilter  %>% 
                mutate(date = as.Date(as.character(date), "%d/%m/%y"))
                      

head(ices_unfilter);tail(ices_unfilter)
```

    ##   source country station      lat      lon year       date variable qflag
    ## 1   ICES  Poland    LWLA 54.91667 18.66667 2009 2009-09-01    CB101      
    ## 2   ICES  Poland    LWLA 54.91667 18.66667 2009 2009-09-01    CB101      
    ## 3   ICES  Poland    LWLA 54.91667 18.66667 2009 2009-09-01    CB101      
    ## 4   ICES  Poland    LWLA 54.91667 18.66667 2009 2009-09-01    CB101      
    ## 5   ICES  Poland    LWLA 54.91667 18.66667 2009 2009-09-01    CB101      
    ## 6   ICES  Poland    LWLA 54.91667 18.66667 2009 2009-09-01    CB101      
    ##     value  unit vflag detli lmqnt sub_id  bio_id samp_id num_indiv_subsamp
    ## 1 0.00049 mg/kg     A    NA  0.14     19 2971439 1109586                 1
    ## 2 0.00048 mg/kg     A    NA  0.14     20 2971440 1109586                 1
    ## 3 0.00091 mg/kg     A    NA  0.14     13 2971433 1109586                 1
    ## 4 0.00078 mg/kg     A    NA  0.14     15 2971435 1109586                 1
    ## 5 0.00054 mg/kg     A    NA  0.14     14 2971434 1109586                 1
    ## 6 0.00046 mg/kg     A    NA  0.14     16 2971436 1109586                 1

    ##      source country             station     lat     lon year       date
    ## 4686   ICES  Sweden Vaestra Hanoebukten 55.7507 14.2833 2009 2009-10-29
    ## 4687   ICES  Sweden           Byxelkrok 57.3167 17.5000 2011 2011-10-01
    ## 4688   ICES  Sweden            Landsort 58.6936 18.0043 2011 2011-10-25
    ## 4689   ICES  Sweden     Aengskaersklubb 60.5326 18.1624 2009 2009-05-11
    ## 4690   ICES  Sweden     Aengskaersklubb 60.5326 18.1624 2009 2009-05-11
    ## 4691   ICES  Sweden              Lagnoe 59.5652 18.8348 2009 2009-08-25
    ##      variable qflag      value  unit vflag detli lmqnt     sub_id  bio_id
    ## 4686     CB52       0.00069840 mg/kg       0.004    NA 1098710998 3403246
    ## 4687     CB52       0.00075294 mg/kg       0.004    NA  615806169 3402760
    ## 4688     CB52       0.00095520 mg/kg       0.004    NA       4139 3402744
    ## 4689     CB52       0.00103950 mg/kg       0.004    NA  411804129 3403096
    ## 4690     CB52       0.00119448 mg/kg       0.004    NA  413004141 3403097
    ## 4691     CB52       0.00127494 mg/kg       0.004    NA  288102892 3403252
    ##      samp_id num_indiv_subsamp
    ## 4686 1661096                12
    ## 4687 1660983                12
    ## 4688 1660980                 1
    ## 4689 1661053                12
    ## 4690 1661053                12
    ## 4691 1661099                12

``` r
ivl_unfilter %>% select(date) %>% head(.)
```

    ##         date
    ## 1       2010
    ## 2       2010
    ## 3 2009-05-11
    ## 4 2009-05-11
    ## 5 2009-05-11
    ## 6 2009-05-11

``` r
    ## date format is yyyy-mm-dd

ivl_unfilter = ivl_unfilter  %>% 
                mutate(date = as.Date(date,format="%Y-%m-%d"))%>%
                select(-vflag,-detli,-lmqnt,-sub_id,-samp_id, -num_indiv_subsamp)


head(ivl_unfilter);tail(ivl_unfilter)
```

    ##   source country         station     lat     lon year       date variable
    ## 1    IVL  Sweden  Gaviksfjaerden 62.8645 18.2412 2010       <NA>    CB101
    ## 2    IVL  Sweden  Gaviksfjaerden 62.8645 18.2412 2010       <NA>    CB101
    ## 3    IVL  Sweden       Utlaengan 55.9491 15.7810 2009 2009-05-11    CB101
    ## 4    IVL  Sweden       Utlaengan 55.9491 15.7810 2009 2009-05-11    CB101
    ## 5    IVL  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-05-11    CB101
    ## 6    IVL  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-05-11    CB101
    ##   qflag     value  unit            bio_id
    ## 1       0.0011508 mg/kg C2010/06042-06053
    ## 2       0.0013760 mg/kg C2010/06030-06041
    ## 3       0.0005891 mg/kg C2009/00146-00157
    ## 4       0.0009114 mg/kg C2009/00158-00169
    ## 5       0.0029260 mg/kg C2009/04118-04129
    ## 6       0.0035910 mg/kg C2009/04130-04141

    ##      source country      station     lat     lon year       date variable
    ## 3551    IVL  Sweden Vaederoearna 58.5156 10.9001 2013 2013-11-25     CB52
    ## 3552    IVL  Sweden Vaederoearna 58.5156 10.9001 2013 2013-11-25     CB52
    ## 3553    IVL  Sweden Vaederoearna 58.5156 10.9001 2013 2013-11-25     CB52
    ## 3554    IVL  Sweden Vaederoearna 58.5156 10.9001 2013 2013-11-25     CB52
    ## 3555    IVL  Sweden Vaederoearna 58.5156 10.9001 2013 2013-11-25     CB52
    ## 3556    IVL  Sweden Vaederoearna 58.5156 10.9001 2013 2013-11-25     CB52
    ##      qflag    value  unit      bio_id
    ## 3551       0.000462 mg/kg C2013/07222
    ## 3552       0.000486 mg/kg C2013/07215
    ## 3553       0.000496 mg/kg C2013/07221
    ## 3554       0.000536 mg/kg C2013/07223
    ## 3555       0.000549 mg/kg C2013/07217
    ## 3556       0.000567 mg/kg C2013/07214

### 4.1.4 Select only the CB153 congener

``` r
ices_unfilter = ices_unfilter %>% filter(variable == "CB153")
dim(ices_unfilter) #658  18
```

    ## [1] 658  18

``` r
ivl_unfilter = ivl_unfilter %>% filter(variable == "CB153")
dim(ivl_unfilter) #507  12
```

    ## [1] 507  12

### 4.1.5 Combine ICES & IVL data, remove duplicates

``` r
pcb_153 = full_join(ices_unfilter,select(ivl_unfilter,-bio_id), 
                    by=c("source","country","station","lat","lon", "year","date","variable","value","qflag","unit"))  # remove bio_id from IVL joined data, but retain in ivl_unfilter

dim(pcb_153) ##1165   19
```

    ## [1] 1165   18

``` r
##appears no data is discarded
pcb_153 %>% filter(station=="Aengskaersklubb") %>% arrange(date,value)
```

    ##     source country         station     lat     lon year       date
    ## 1     ICES  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-05-11
    ## 2      IVL  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-05-11
    ## 3      IVL  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-05-11
    ## 4     ICES  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-05-11
    ## 5      IVL  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 6     ICES  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 7      IVL  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 8     ICES  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 9     ICES  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 10     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 11     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 12    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 13     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 14    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 15     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 16    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 17    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 18     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 19    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 20     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 21    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 22     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 23    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 24     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 25     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 26    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 27    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 28     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2009 2009-10-22
    ## 29     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-06-11
    ## 30    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-06-11
    ## 31    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-06-11
    ## 32     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-06-11
    ## 33    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 34     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 35    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 36     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 37    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 38     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 39    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 40     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 41    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 42     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 43    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 44     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 45     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 46    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 47    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 48     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 49    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 50     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 51     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 52    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 53    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 54     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 55    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 56     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2010 2010-10-01
    ## 57    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-07-24
    ## 58     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-07-24
    ## 59     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-07-24
    ## 60    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-07-24
    ## 61     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 62    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 63    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 64     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 65    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 66     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 67     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 68    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 69    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 70     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 71    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 72     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 73     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 74    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 75    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 76     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 77     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 78    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 79     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 80    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 81     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 82    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 83     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 84    ICES  Sweden Aengskaersklubb 60.5326 18.1624 2011 2011-10-05
    ## 85     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2012 2012-06-11
    ## 86     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2012 2012-06-11
    ## 87     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2012 2012-10-01
    ## 88     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2012 2012-10-01
    ## 89     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2012 2012-10-01
    ## 90     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2012 2012-10-01
    ## 91     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2012 2012-10-01
    ## 92     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2012 2012-10-01
    ## 93     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2012 2012-10-01
    ## 94     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2012 2012-10-01
    ## 95     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2012 2012-10-01
    ## 96     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2012 2012-10-01
    ## 97     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2012 2012-10-01
    ## 98     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2012 2012-10-01
    ## 99     IVL  Sweden Aengskaersklubb 60.5326 18.1624 2013 2013-09-30
    ## 100    IVL  Sweden Aengskaersklubb 60.5326 18.1624 2013 2013-09-30
    ## 101    IVL  Sweden Aengskaersklubb 60.5326 18.1624 2013 2013-09-30
    ## 102    IVL  Sweden Aengskaersklubb 60.5326 18.1624 2013 2013-09-30
    ## 103    IVL  Sweden Aengskaersklubb 60.5326 18.1624 2013 2013-09-30
    ## 104    IVL  Sweden Aengskaersklubb 60.5326 18.1624 2013 2013-09-30
    ## 105    IVL  Sweden Aengskaersklubb 60.5326 18.1624 2013 2013-09-30
    ## 106    IVL  Sweden Aengskaersklubb 60.5326 18.1624 2013 2013-09-30
    ## 107    IVL  Sweden Aengskaersklubb 60.5326 18.1624 2013 2013-09-30
    ## 108    IVL  Sweden Aengskaersklubb 60.5326 18.1624 2013 2013-09-30
    ## 109    IVL  Sweden Aengskaersklubb 60.5326 18.1624 2013 2013-09-30
    ## 110    IVL  Sweden Aengskaersklubb 60.5326 18.1624 2013 2013-09-30
    ##     variable qflag      value  unit vflag detli lmqnt    sub_id  bio_id
    ## 1      CB153       0.00875490 mg/kg       0.005    NA 411804129 3403096
    ## 2      CB153       0.00885500 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 3      CB153       0.01020600 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 4      CB153       0.01034208 mg/kg       0.005    NA 413004141 3403097
    ## 5      CB153       0.00091960 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 6      CB153       0.00092378 mg/kg       0.005    NA     10711 3403101
    ## 7      CB153       0.00097680 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 8      CB153       0.00097828 mg/kg       0.005    NA     10715 3403105
    ## 9      CB153       0.00197145 mg/kg       0.005    NA     10713 3403103
    ## 10     CB153       0.00198830 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 11     CB153       0.00208800 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 12     CB153       0.00213498 mg/kg       0.005    NA     10709 3403099
    ## 13     CB153       0.00219600 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 14     CB153       0.00219960 mg/kg       0.005    NA     10708 3403098
    ## 15     CB153       0.00235400 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 16     CB153       0.00236778 mg/kg       0.005    NA     10712 3403102
    ## 17     CB153       0.00241178 mg/kg       0.005    NA     10710 3403100
    ## 18     CB153       0.00241800 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 19     CB153       0.00260406 mg/kg       0.005    NA     10719 3403109
    ## 20     CB153       0.00260820 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 21     CB153       0.00283257 mg/kg       0.005    NA     10717 3403107
    ## 22     CB153       0.00295900 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 23     CB153       0.00319704 mg/kg       0.005    NA     10714 3403104
    ## 24     CB153       0.00321780 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 25     CB153       0.00381000 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 26     CB153       0.00393954 mg/kg       0.005    NA     10718 3403108
    ## 27     CB153       0.00439850 mg/kg       0.005    NA     10716 3403106
    ## 28     CB153       0.00439850 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 29     CB153       0.00495000 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 30     CB153       0.00504240 mg/kg       0.005    NA  66100672 3402850
    ## 31     CB153       0.00615126 mg/kg       0.005    NA  67200684 3402851
    ## 32     CB153       0.00628000 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 33     CB153       0.00100076 mg/kg       0.005    NA     11631 3402864
    ## 34     CB153       0.00100470 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 35     CB153       0.00101840 mg/kg       0.005    NA     11629 3402862
    ## 36     CB153       0.00104000 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 37     CB153       0.00115824 mg/kg       0.005    NA     11628 3402861
    ## 38     CB153       0.00116280 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 39     CB153       0.00120175 mg/kg       0.005    NA     11621 3402854
    ## 40     CB153       0.00121220 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 41     CB153       0.00123420 mg/kg       0.005    NA     11623 3402856
    ## 42     CB153       0.00124100 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 43     CB153       0.00134895 mg/kg       0.005    NA     11630 3402863
    ## 44     CB153       0.00135150 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 45     CB153       0.00136320 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 46     CB153       0.00136746 mg/kg       0.005    NA     11627 3402860
    ## 47     CB153       0.00164322 mg/kg       0.005    NA     11626 3402859
    ## 48     CB153       0.00164680 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 49     CB153       0.00182790 mg/kg       0.005    NA     11632 3402865
    ## 50     CB153       0.00189000 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 51     CB153       0.00204600 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 52     CB153       0.00204930 mg/kg       0.005    NA     11624 3402857
    ## 53     CB153       0.00210578 mg/kg       0.005    NA     11622 3402855
    ## 54     CB153       0.00211000 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 55     CB153       0.00222768 mg/kg       0.005    NA     11625 3402858
    ## 56     CB153       0.00223380 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 57     CB153       0.00092484 mg/kg       0.005    NA 578705798 3402596
    ## 58     CB153       0.00093240 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 59     CB153       0.00095850 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 60     CB153       0.00114912 mg/kg       0.005    NA 579905810 3402597
    ## 61     CB153       0.00084000 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 62     CB153       0.00084840 mg/kg       0.005    NA      7373 3402606
    ## 63     CB153       0.00092964 mg/kg       0.005    NA      7375 3402608
    ## 64     CB153       0.00093980 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 65     CB153       0.00095370 mg/kg       0.005    NA      7368 3402601
    ## 66     CB153       0.00095370 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 67     CB153       0.00099000 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 68     CB153       0.00099990 mg/kg       0.005    NA      7377 3402610
    ## 69     CB153       0.00105651 mg/kg       0.005    NA      7374 3402607
    ## 70     CB153       0.00105780 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 71     CB153       0.00120400 mg/kg       0.005    NA      7369 3402602
    ## 72     CB153       0.00120400 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 73     CB153       0.00122500 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 74     CB153       0.00123480 mg/kg       0.005    NA      7366 3402599
    ## 75     CB153       0.00132924 mg/kg       0.005    NA      7371 3402604
    ## 76     CB153       0.00133760 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 77     CB153       0.00157440 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 78     CB153       0.00157768 mg/kg       0.005    NA      7376 3402609
    ## 79     CB153       0.00164640 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 80     CB153       0.00165984 mg/kg       0.005    NA      7370 3402603
    ## 81     CB153       0.00244140 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 82     CB153       0.00245079 mg/kg       0.005    NA      7367 3402600
    ## 83     CB153       0.00256300 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 84     CB153       0.00263057 mg/kg       0.005    NA      7372 3402605
    ## 85     CB153       0.00316200 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 86     CB153       0.00326700 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 87     CB153       0.00041800 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 88     CB153       0.00075000 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 89     CB153       0.00084000 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 90     CB153       0.00100300 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 91     CB153       0.00103500 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 92     CB153       0.00168000 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 93     CB153       0.00182400 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 94     CB153       0.00183600 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 95     CB153       0.00187000 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 96     CB153       0.00188000 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 97     CB153       0.00243000 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 98     CB153       0.00255000 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 99     CB153       0.00094500 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 100    CB153       0.00104400 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 101    CB153       0.00108000 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 102    CB153       0.00111000 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 103    CB153       0.00115200 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 104    CB153       0.00121500 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 105    CB153       0.00123200 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 106    CB153       0.00129500 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 107    CB153       0.00136900 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 108    CB153       0.00188700 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 109    CB153       0.00248400 mg/kg  <NA>    NA    NA      <NA>      NA
    ## 110    CB153       0.00256000 mg/kg  <NA>    NA    NA      <NA>      NA
    ##     samp_id num_indiv_subsamp
    ## 1   1661053                12
    ## 2        NA                NA
    ## 3        NA                NA
    ## 4   1661053                12
    ## 5        NA                NA
    ## 6   1661054                 1
    ## 7        NA                NA
    ## 8   1661054                 1
    ## 9   1661054                 1
    ## 10       NA                NA
    ## 11       NA                NA
    ## 12  1661054                 1
    ## 13       NA                NA
    ## 14  1661054                 1
    ## 15       NA                NA
    ## 16  1661054                 1
    ## 17  1661054                 1
    ## 18       NA                NA
    ## 19  1661054                 1
    ## 20       NA                NA
    ## 21  1661054                 1
    ## 22       NA                NA
    ## 23  1661054                 1
    ## 24       NA                NA
    ## 25       NA                NA
    ## 26  1661054                 1
    ## 27  1661054                 1
    ## 28       NA                NA
    ## 29       NA                NA
    ## 30  1660999                12
    ## 31  1660999                13
    ## 32       NA                NA
    ## 33  1661001                 1
    ## 34       NA                NA
    ## 35  1661001                 1
    ## 36       NA                NA
    ## 37  1661001                 1
    ## 38       NA                NA
    ## 39  1661001                 1
    ## 40       NA                NA
    ## 41  1661001                 1
    ## 42       NA                NA
    ## 43  1661001                 1
    ## 44       NA                NA
    ## 45       NA                NA
    ## 46  1661001                 1
    ## 47  1661001                 1
    ## 48       NA                NA
    ## 49  1661001                 1
    ## 50       NA                NA
    ## 51       NA                NA
    ## 52  1661001                 1
    ## 53  1661001                 1
    ## 54       NA                NA
    ## 55  1661001                 1
    ## 56       NA                NA
    ## 57  1660942                12
    ## 58       NA                NA
    ## 59       NA                NA
    ## 60  1660942                12
    ## 61       NA                NA
    ## 62  1660943                 1
    ## 63  1660943                 1
    ## 64       NA                NA
    ## 65  1660943                 1
    ## 66       NA                NA
    ## 67       NA                NA
    ## 68  1660943                 1
    ## 69  1660943                 1
    ## 70       NA                NA
    ## 71  1660943                 1
    ## 72       NA                NA
    ## 73       NA                NA
    ## 74  1660943                 1
    ## 75  1660943                 1
    ## 76       NA                NA
    ## 77       NA                NA
    ## 78  1660943                 1
    ## 79       NA                NA
    ## 80  1660943                 1
    ## 81       NA                NA
    ## 82  1660943                 1
    ## 83       NA                NA
    ## 84  1660943                 1
    ## 85       NA                NA
    ## 86       NA                NA
    ## 87       NA                NA
    ## 88       NA                NA
    ## 89       NA                NA
    ## 90       NA                NA
    ## 91       NA                NA
    ## 92       NA                NA
    ## 93       NA                NA
    ## 94       NA                NA
    ## 95       NA                NA
    ## 96       NA                NA
    ## 97       NA                NA
    ## 98       NA                NA
    ## 99       NA                NA
    ## 100      NA                NA
    ## 101      NA                NA
    ## 102      NA                NA
    ## 103      NA                NA
    ## 104      NA                NA
    ## 105      NA                NA
    ## 106      NA                NA
    ## 107      NA                NA
    ## 108      NA                NA
    ## 109      NA                NA
    ## 110      NA                NA

``` r
#### THERE are CLEARLY DUPLICATES BUT THE VALUES ARE A LITTLE DIFFERENT -- NOT SURE HOW CONVERSIONS COULD BE OFF

## ARE THERE ANY SAMPLE DATES & LOCATIONS ONLY IN IVL, NOT ICES???
find_unique = full_join(select(ices_unfilter,source, country,station,date),select(ivl_unfilter,source, country,station,date))
```

    ## Joining by: c("source", "country", "station", "date")

``` r
find_unique = find_unique %>% filter(country=="Sweden") %>% distinct(.)
dim(find_unique)
```

    ## [1] 157   4

``` r
find_unique %>% arrange(station,date)
```

    ##     source country                  station       date
    ## 1     ICES  Sweden                  Abbekas 2009-11-30
    ## 2      IVL  Sweden                  Abbekas 2009-11-30
    ## 3     ICES  Sweden                  Abbekas 2011-11-14
    ## 4      IVL  Sweden                  Abbekas 2011-11-14
    ## 5      IVL  Sweden                  Abbekas 2012-12-03
    ## 6      IVL  Sweden                  Abbekas 2013-11-05
    ## 7     ICES  Sweden          Aengskaersklubb 2009-05-11
    ## 8      IVL  Sweden          Aengskaersklubb 2009-05-11
    ## 9     ICES  Sweden          Aengskaersklubb 2009-10-22
    ## 10     IVL  Sweden          Aengskaersklubb 2009-10-22
    ## 11    ICES  Sweden          Aengskaersklubb 2010-06-11
    ## 12     IVL  Sweden          Aengskaersklubb 2010-06-11
    ## 13    ICES  Sweden          Aengskaersklubb 2010-10-01
    ## 14     IVL  Sweden          Aengskaersklubb 2010-10-01
    ## 15    ICES  Sweden          Aengskaersklubb 2011-07-24
    ## 16     IVL  Sweden          Aengskaersklubb 2011-07-24
    ## 17    ICES  Sweden          Aengskaersklubb 2011-10-05
    ## 18     IVL  Sweden          Aengskaersklubb 2011-10-05
    ## 19     IVL  Sweden          Aengskaersklubb 2012-06-11
    ## 20     IVL  Sweden          Aengskaersklubb 2012-10-01
    ## 21     IVL  Sweden          Aengskaersklubb 2013-09-30
    ## 22     IVL  Sweden Baltic Proper. Off shore 2009-10-19
    ## 23     IVL  Sweden Baltic Proper. Off shore 2010-10-12
    ## 24     IVL  Sweden Baltic Proper. Off shore 2011-10-09
    ## 25     IVL  Sweden Baltic Proper. Off shore 2012-10-07
    ## 26     IVL  Sweden Baltic Proper. Off shore 2013-10-08
    ## 27     IVL  Sweden  Bothnian Sea. Off shore 2009-09-29
    ## 28     IVL  Sweden  Bothnian Sea. Off shore 2010-09-29
    ## 29     IVL  Sweden  Bothnian Sea. Off shore 2011-09-30
    ## 30     IVL  Sweden  Bothnian Sea. Off shore 2012-10-12
    ## 31     IVL  Sweden  Bothnian Sea. Off shore 2013-10-03
    ## 32    ICES  Sweden                Byxelkrok 2009-09-20
    ## 33     IVL  Sweden                Byxelkrok 2009-09-20
    ## 34    ICES  Sweden                Byxelkrok 2010-09-30
    ## 35     IVL  Sweden                Byxelkrok 2010-09-30
    ## 36    ICES  Sweden                Byxelkrok 2011-10-01
    ## 37     IVL  Sweden                Byxelkrok 2011-10-01
    ## 38     IVL  Sweden                Byxelkrok 2012-10-01
    ## 39     IVL  Sweden                Byxelkrok 2013-10-28
    ## 40    ICES  Sweden               E/W FLADEN 2009-09-07
    ## 41    ICES  Sweden               E/W FLADEN 2010-09-06
    ## 42    ICES  Sweden               E/W FLADEN 2011-09-09
    ## 43     IVL  Sweden                   Fladen 2009-09-07
    ## 44     IVL  Sweden                   Fladen 2010-09-06
    ## 45     IVL  Sweden                   Fladen 2011-09-09
    ## 46     IVL  Sweden                   Fladen 2012-08-17
    ## 47     IVL  Sweden                   Fladen 2013-08-28
    ## 48    ICES  Sweden           Gaviksfjaerden 2009-08-07
    ## 49     IVL  Sweden           Gaviksfjaerden 2009-08-07
    ## 50    ICES  Sweden           Gaviksfjaerden 2011-08-03
    ## 51     IVL  Sweden           Gaviksfjaerden 2011-08-03
    ## 52     IVL  Sweden           Gaviksfjaerden 2012-08-13
    ## 53     IVL  Sweden           Gaviksfjaerden 2013-08-02
    ## 54     IVL  Sweden           Gaviksfjaerden       <NA>
    ## 55    ICES  Sweden             Harufjaerden 2009-09-28
    ## 56     IVL  Sweden             Harufjaerden 2009-09-28
    ## 57    ICES  Sweden             Harufjaerden 2010-09-20
    ## 58     IVL  Sweden             Harufjaerden 2010-09-20
    ## 59    ICES  Sweden             Harufjaerden 2011-10-02
    ## 60     IVL  Sweden             Harufjaerden 2011-10-02
    ## 61     IVL  Sweden             Harufjaerden 2012-09-23
    ## 62     IVL  Sweden             Harufjaerden 2013-09-22
    ## 63    ICES  Sweden               Holmoearna 2009-09-15
    ## 64     IVL  Sweden               Holmoearna 2009-09-15
    ## 65    ICES  Sweden               Holmoearna 2010-09-13
    ## 66     IVL  Sweden               Holmoearna 2010-09-13
    ## 67    ICES  Sweden               Holmoearna 2011-09-01
    ## 68     IVL  Sweden               Holmoearna 2011-09-01
    ## 69     IVL  Sweden               Holmoearna 2012-08-28
    ## 70     IVL  Sweden               Holmoearna 2013-09-02
    ## 71    ICES  Sweden       Kinnbaecksfjaerden 2009-10-12
    ## 72     IVL  Sweden       Kinnbaecksfjaerden 2009-10-12
    ## 73    ICES  Sweden       Kinnbaecksfjaerden 2010-10-11
    ## 74     IVL  Sweden       Kinnbaecksfjaerden 2010-10-11
    ## 75    ICES  Sweden       Kinnbaecksfjaerden 2011-10-10
    ## 76     IVL  Sweden       Kinnbaecksfjaerden 2011-10-10
    ## 77     IVL  Sweden       Kinnbaecksfjaerden 2012-10-01
    ## 78     IVL  Sweden       Kinnbaecksfjaerden 2013-09-30
    ## 79    ICES  Sweden                   Kullen 2009-10-12
    ## 80     IVL  Sweden                   Kullen 2009-10-12
    ## 81    ICES  Sweden                   Kullen 2010-09-29
    ## 82     IVL  Sweden                   Kullen 2010-09-29
    ## 83    ICES  Sweden                   Kullen 2011-10-06
    ## 84     IVL  Sweden                   Kullen 2011-10-06
    ## 85     IVL  Sweden                   Kullen 2012-09-20
    ## 86     IVL  Sweden                   Kullen 2013-09-25
    ## 87    ICES  Sweden                   Lagnoe 2009-08-25
    ## 88     IVL  Sweden                   Lagnoe 2009-08-25
    ## 89    ICES  Sweden                   Lagnoe 2010-08-25
    ## 90     IVL  Sweden                   Lagnoe 2010-08-25
    ## 91    ICES  Sweden                   Lagnoe 2011-08-23
    ## 92     IVL  Sweden                   Lagnoe 2011-08-23
    ## 93     IVL  Sweden                   Lagnoe 2012-08-21
    ## 94     IVL  Sweden                   Lagnoe 2013-08-22
    ## 95    ICES  Sweden                 Landsort 2009-11-12
    ## 96     IVL  Sweden                 Landsort 2009-11-12
    ## 97    ICES  Sweden                 Landsort 2010-10-12
    ## 98     IVL  Sweden                 Landsort 2010-10-12
    ## 99    ICES  Sweden                 Landsort 2011-10-25
    ## 100    IVL  Sweden                 Landsort 2011-10-25
    ## 101    IVL  Sweden                 Landsort 2012-12-20
    ## 102    IVL  Sweden                 Landsort 2013-10-06
    ## 103   ICES  Sweden        Langvindsfjaerden 2009-08-13
    ## 104    IVL  Sweden        Langvindsfjaerden 2009-08-13
    ## 105   ICES  Sweden        Langvindsfjaerden 2010-08-10
    ## 106    IVL  Sweden        Langvindsfjaerden 2010-08-10
    ## 107   ICES  Sweden        Langvindsfjaerden 2011-08-09
    ## 108    IVL  Sweden        Langvindsfjaerden 2011-08-09
    ## 109    IVL  Sweden        Langvindsfjaerden 2012-08-07
    ## 110    IVL  Sweden        Langvindsfjaerden 2013-08-14
    ## 111    IVL  Sweden            Lilla Vaertan 2011-08-09
    ## 112    IVL  Sweden  Oernskoeldsviksfjaerden 2011-08-16
    ## 113   ICES  Sweden             Ranefjaerden 2009-09-17
    ## 114    IVL  Sweden             Ranefjaerden 2009-09-17
    ## 115   ICES  Sweden             Ranefjaerden 2010-09-17
    ## 116    IVL  Sweden             Ranefjaerden 2010-09-17
    ## 117   ICES  Sweden             Ranefjaerden 2011-09-12
    ## 118    IVL  Sweden             Ranefjaerden 2011-09-12
    ## 119    IVL  Sweden             Ranefjaerden 2012-09-17
    ## 120    IVL  Sweden             Ranefjaerden 2013-09-09
    ## 121    IVL  Sweden         Seskaroefjaerden 2009-10-13
    ## 122    IVL  Sweden         Seskaroefjaerden 2011-09-27
    ## 123    IVL  Sweden         Seskaroefjaerden 2012-10-07
    ## 124    IVL  Sweden          Skelleftebukten 2011-08-24
    ## 125    IVL  Sweden             Storfjaerden 2009-10-18
    ## 126    IVL  Sweden             Storfjaerden 2012-10-19
    ## 127    IVL  Sweden                   Torsas 2011-08-15
    ## 128   ICES  Sweden                Utlaengan 2009-05-11
    ## 129    IVL  Sweden                Utlaengan 2009-05-11
    ## 130   ICES  Sweden                Utlaengan 2009-10-27
    ## 131    IVL  Sweden                Utlaengan 2009-10-27
    ## 132   ICES  Sweden                Utlaengan 2010-01-11
    ## 133    IVL  Sweden                Utlaengan 2010-01-11
    ## 134   ICES  Sweden                Utlaengan 2010-05-24
    ## 135    IVL  Sweden                Utlaengan 2010-05-24
    ## 136   ICES  Sweden                Utlaengan 2011-06-06
    ## 137    IVL  Sweden                Utlaengan 2011-06-06
    ## 138   ICES  Sweden                Utlaengan 2011-10-17
    ## 139    IVL  Sweden                Utlaengan 2011-10-17
    ## 140    IVL  Sweden                Utlaengan 2012-06-04
    ## 141    IVL  Sweden                Utlaengan 2012-11-26
    ## 142    IVL  Sweden                Utlaengan 2013-05-27
    ## 143    IVL  Sweden                Utlaengan 2013-11-11
    ## 144    IVL  Sweden             Vaederoearna 2009-09-02
    ## 145    IVL  Sweden             Vaederoearna 2010-09-20
    ## 146    IVL  Sweden             Vaederoearna 2011-11-29
    ## 147    IVL  Sweden             Vaederoearna 2012-10-16
    ## 148    IVL  Sweden             Vaederoearna 2013-11-25
    ## 149   ICES  Sweden      Vaestra Hanoebukten 2009-10-29
    ## 150    IVL  Sweden      Vaestra Hanoebukten 2009-10-29
    ## 151   ICES  Sweden      Vaestra Hanoebukten 2010-10-04
    ## 152    IVL  Sweden      Vaestra Hanoebukten 2010-10-04
    ## 153   ICES  Sweden      Vaestra Hanoebukten 2011-11-29
    ## 154    IVL  Sweden      Vaestra Hanoebukten 2011-11-29
    ## 155    IVL  Sweden      Vaestra Hanoebukten 2012-10-01
    ## 156    IVL  Sweden      Vaestra Hanoebukten 2013-10-23
    ## 157    IVL  Sweden           Yttre fjaerden 2011-08-12

``` r
## ICES data from Sweden stops atfter 2011.  IVL has unique dates after.
## unique IVL stations Baltic Proper. Off shore,Bothnian Sea. Off shore, Lilla Vaertan (1yr),  Oernskoeldsviksfjaerden (1yr), Seskaroefjaerden,Skelleftebukten,Storfjaerden ,  Torsas,Yttre fjaerden, Vaederoearna (this is west coast will be excluded)
##unique ICES station  E/W FLADEN  but probably matches IVL's Fladen

## NEED to check IVL unique sites against sweden national monitoring program list to see if these are there??  
    ### unique IVL sites not national monitoring:  Lilla Vaertan,Oernskoeldsviksfjaerden, Seskaroefjaerden,Skelleftebukten,Storfjaerden,Torsas,Yttre fjaerden
  ## all except Baltic proper off shore, and bothnian sea offshore are not national monitoring sites
```

OLD PREP FOR 6-PCB
==================

**PROBLEMS WITH DUPLICATES!!!** **NOT USING 6 PCB anymore**

Data Prep 6-PCB indicator
=========================

### Initial prep and notes

``` r
## Values for the detection limit (DETLI) and quantification limit (LMQNT) are in the original units provided by each country.
## Measured values however, have been standardized to mg/kg.  This will make it challenging to check whether
## values provided are given as simply the detection limit or the quantification limit

## Manually reviewing original data for units and detection limit levels by country

## looking in file "ICES sill original data 2015112.csc"
## LMQNT is rarely reported
## DETLI is more often reported but not always reported
## summary csv in contaminants prep folder "pcb_country_units_detli.csv"
    ## Some countries use multiple reporting units: Some countries have multiple detection limits reported for a single congener (must vary by machine by year)
    ## this csv has all congeners, units, and detli/lmqnt unique by monitoring year
## "unit_conversion_lookup.csv" created to help with different unit conversions

## Checked years 2009-2013 in original data (use this file "raw_ICESdat_quant_detect_check.csv")
    ## Did check in excel
    ## Filtered by 2009 -2013
    ## Looked for values with QFLAG entry
    ## Looked to see if the value matched the DETLI or LMQNT value
    ## For these years, if QFLAG == '<'or 'Q' then what is entered in the value column is equal to the value
    ## given in LMQNT. if QFLAG == 'D' then the value is equal to what is entered for DETLI.
    ## This might not be true for earlier years (either detection limit not given, or value not replaced)


## Check years 2009-2013 for IVL data flags
    ## Used file "raw_IVLdat_quant_detect_check.csv"
    ## 3 congeners receive data flags ("b") for detection limit (CB28,CB52,CB180)
    ## these data are  mg/kg lipid weight
    ## Values are given as a less than symbol and number (eg. <0.004)
    ## These values vary for the same congener in samples taken on the same day. These values are 
        ## are likely not then the detection limit value entered but rather the raw machine values
        ## How to deal with this?  Divide these values (eg value/2 like LOD/2) or need to replace
          ## machine value with the LOD value then calculate LOD/2


##------------------------#
## INITIAL DATA SELECTION
##------------------------#

## Read in data from csv
pcb_data = readr::read_csv(file.path(dir_con, 'contaminants_data_database/pcb_data_filter.csv'),
                           col_types = cols(sub_id= "c",
                                            bio_id= "c") )#make sure these columns are read in as character
   

##filter for years 2009-2013
data2 = pcb_data %>%filter(year %in% c(2009:2013))

head(data2)
```

    ## Source: local data frame [6 x 19]
    ## 
    ##   source country station bhi_id      lat     lon  year       date variable
    ##    (chr)   (chr)   (chr)  (int)    (dbl)   (dbl) (int)     (date)    (chr)
    ## 1   ICES Finland      NA     38 61.71083 20.7075  2009 2009-09-14    CB101
    ## 2   ICES Finland      NA     38 61.71083 20.7075  2009 2009-09-14    CB101
    ## 3   ICES Finland      NA     38 61.71083 20.7075  2009 2009-09-14    CB101
    ## 4   ICES Finland      NA     38 61.71083 20.7075  2009 2009-09-14    CB101
    ## 5   ICES Finland      NA     38 61.71083 20.7075  2009 2009-09-14    CB101
    ## 6   ICES Finland      NA     38 61.71083 20.7075  2009 2009-09-14    CB101
    ## Variables not shown: qflag (chr), value (dbl), unit (chr), vflag (chr),
    ##   detli (dbl), lmqnt (dbl), sub_id (chr), bio_id (chr), samp_id (int),
    ##   num_indiv_subsamp (int)

``` r
dim(data2) #[1] 6873   19
```

    ## [1] 6873   19

``` r
##------------------------#
## Station names
    ##Finnish data in ICES does not have a station name. Create a station name with Lat-Lon if Station is NA

data2 = data2 %>% mutate(station2= paste("lat",round(lat,2),"lon",round(lon,2),sep="")) %>% #create new station column
        mutate(station = ifelse(is.na(station), station2, station))%>% #replace station if NA with station2
        select(-station2) #remove station2 column

head(data2)
```

    ## Source: local data frame [6 x 19]
    ## 
    ##   source country          station bhi_id      lat     lon  year       date
    ##    (chr)   (chr)            (chr)  (int)    (dbl)   (dbl) (int)     (date)
    ## 1   ICES Finland lat61.71lon20.71     38 61.71083 20.7075  2009 2009-09-14
    ## 2   ICES Finland lat61.71lon20.71     38 61.71083 20.7075  2009 2009-09-14
    ## 3   ICES Finland lat61.71lon20.71     38 61.71083 20.7075  2009 2009-09-14
    ## 4   ICES Finland lat61.71lon20.71     38 61.71083 20.7075  2009 2009-09-14
    ## 5   ICES Finland lat61.71lon20.71     38 61.71083 20.7075  2009 2009-09-14
    ## 6   ICES Finland lat61.71lon20.71     38 61.71083 20.7075  2009 2009-09-14
    ## Variables not shown: variable (chr), qflag (chr), value (dbl), unit (chr),
    ##   vflag (chr), detli (dbl), lmqnt (dbl), sub_id (chr), bio_id (chr),
    ##   samp_id (int), num_indiv_subsamp (int)

``` r
##------------------------#
##unique variables
unique(data2$variable) #"CB101" "CB118" "CB138" "CB153" "CB180" "CB28"  "CB52"  "CB105"
```

    ## [1] "CB101" "CB118" "CB138" "CB153" "CB180" "CB28"  "CB52"  "CB105"

``` r
##CB105 is not one of the ICES 7 variables, remove
##CB118 is not in the ICES 6, remove

data3 = data2 %>% filter(variable != "CB105") %>%
                  filter(variable != "CB118") ;dim(data3) #5816   19
```

    ## [1] 5816   19

``` r
##remove location :Vaederoearna 58.51560 10.90010 -- this is on the west coast

data3 = data3 %>% filter(station!= "Vaederoearna")
dim(data3) #5462   19
```

    ## [1] 5462   19

``` r
##------------------------#
##unique identifiers
##number of unique bio_id
data3%>% select(bio_id)%>%distinct(bio_id)%>% nrow(.) #1100
```

    ## [1] 1100

``` r
length(unique(data3$bio_id)) #1100
```

    ## [1] 1100

``` r
    ##any NA bio_id?
    data3 %>% filter(is.na(bio_id)) %>% nrow(.)  #0 rows with NA in bio_id
```

    ## [1] 0

``` r
##number unique samp_id
data3%>% select(samp_id)%>%distinct(samp_id)%>% nrow(.) #219
```

    ## [1] 219

``` r
##number unique sub_id
data3%>% select(sub_id)%>%distinct(sub_id)%>% nrow(.) #495
```

    ## [1] 495

### Location & ID Lookup tables

``` r
##------------------------#
## LOOKUP TABLES - LOCATION & ID
##------------------------#
##location lookup
loc_lookup = data3 %>% select(country,bhi_id,station,lat,lon)%>%
  distinct(.)
print(loc_lookup,n=nrow(loc_lookup))
```

    ## Source: local data frame [34 x 5]
    ## 
    ##    country bhi_id                  station      lat      lon
    ##      (chr)  (int)                    (chr)    (dbl)    (dbl)
    ## 1  Finland     38         lat61.71lon20.71 61.71083 20.70750
    ## 2  Finland     30         lat59.55lon22.61 59.54750 22.60533
    ## 3  Finland     42         lat64.18lon23.33 64.17917 23.32650
    ## 4  Germany     13                  FOE-B10 54.84183 14.04083
    ## 5  Germany     17                  FOE-B11 55.00733 17.43333
    ## 6  Germany     13                  FOE-BMP 54.74400 13.92583
    ## 7  Germany     13                  FOE-BMP 54.68467 13.94917
    ## 8   Poland     17                     LKOL 54.91667 16.66667
    ## 9   Poland     21                     LWLA 54.91667 18.66667
    ## 10  Sweden     11                  Abbekas 55.31630 13.61100
    ## 11  Sweden     37          Aengskaersklubb 60.53260 18.16240
    ## 12  Sweden     26                Byxelkrok 57.31670 17.50000
    ## 13  Sweden      1               E/W FLADEN 57.22470 11.82800
    ## 14  Sweden     NA           Gaviksfjaerden 62.86450 18.24120
    ## 15  Sweden     41             Harufjaerden 65.58250 22.87910
    ## 16  Sweden     39               Holmoearna 63.68080 20.87680
    ## 17  Sweden     NA       Kinnbaecksfjaerden 65.05680 21.47500
    ## 18  Sweden      1                   Kullen 56.32510 12.38110
    ## 19  Sweden     35                   Lagnoe 59.56520 18.83480
    ## 20  Sweden     29                 Landsort 58.69360 18.00430
    ## 21  Sweden     NA        Langvindsfjaerden 61.45540 17.16220
    ## 22  Sweden     41             Ranefjaerden 65.75550 22.41810
    ## 23  Sweden     14                Utlaengan 55.94910 15.78100
    ## 24  Sweden     14      Vaestra Hanoebukten 55.75070 14.28330
    ## 25  Sweden     29 Baltic Proper. Off shore 58.99820 19.87130
    ## 26  Sweden     37  Bothnian Sea. Off shore 61.38140 19.27510
    ## 27  Sweden      1                   Fladen 57.22470 11.82800
    ## 28  Sweden     29            Lilla Vaertan 59.33330 18.16670
    ## 29  Sweden     NA  Oernskoeldsviksfjaerden 62.88330 18.28330
    ## 30  Sweden     41         Seskaroefjaerden 65.78333 23.70000
    ## 31  Sweden     41          Skelleftebukten 64.65000 21.35000
    ## 32  Sweden     NA             Storfjaerden       NA       NA
    ## 33  Sweden     26                   Torsas 56.41670 16.13330
    ## 34  Sweden     37           Yttre fjaerden 60.70000 17.30000

``` r
## Swedish sites without a BHI ID
  loc_lookup%>%filter(is.na(bhi_id))
```

    ## Source: local data frame [5 x 5]
    ## 
    ##   country bhi_id                 station     lat     lon
    ##     (chr)  (int)                   (chr)   (dbl)   (dbl)
    ## 1  Sweden     NA          Gaviksfjaerden 62.8645 18.2412
    ## 2  Sweden     NA      Kinnbaecksfjaerden 65.0568 21.4750
    ## 3  Sweden     NA       Langvindsfjaerden 61.4554 17.1622
    ## 4  Sweden     NA Oernskoeldsviksfjaerden 62.8833 18.2833
    ## 5  Sweden     NA            Storfjaerden      NA      NA

``` r
    ## Vaederoearna 58.51560 10.90010 -- this is on the west coast, this has now been removed above, so does not appear in the list
    ## Storfjaerden       NA       NA  -- quick IVL search indicates is near Piteå -- Have email the IVL database manager for lat-lon
        ##is sampled on 2 dates (between 2009-2013)
  
  ##the other stations have lat-lon , all are Bothian Sea / Bothnian Bay, not sure why these were not assigned to a BHI ID 
  station_missing = loc_lookup%>%filter(is.na(bhi_id))%>% filter(!is.na(lat))%>%select(station)%>%
                    as.matrix(.,1, nrow(station_missing ))
  station_missing
```

    ##   station                  
    ## 1 "Gaviksfjaerden"         
    ## 2 "Kinnbaecksfjaerden"     
    ## 3 "Langvindsfjaerden"      
    ## 4 "Oernskoeldsviksfjaerden"

``` r
  data3 %>% filter(station %in% station_missing) %>% select(bio_id)%>%distinct()%>%nrow() #47 unique samples from these stations not assigned to a BHI_ID
```

    ## [1] 47

``` r
##country/bhi_id/bio_id/lat/long/station
id_lookup = data3 %>% select(country,bhi_id,station,bio_id)%>%
            distinct(.)%>%
            arrange(bio_id) %>%
            mutate(new_id = seq(1,length(bio_id))) #create new ID value that is numeric is paired with ICES/IVL bio_id. This should make is easier to work id columns
head(id_lookup)
```

    ## Source: local data frame [6 x 5]
    ## 
    ##   country bhi_id station  bio_id new_id
    ##     (chr)  (int)   (chr)   (chr)  (int)
    ## 1  Poland     21    LWLA 2971421      1
    ## 2  Poland     21    LWLA 2971422      2
    ## 3  Poland     21    LWLA 2971423      3
    ## 4  Poland     21    LWLA 2971424      4
    ## 5  Poland     21    LWLA 2971425      5
    ## 6  Poland     21    LWLA 2971426      6

### Data exploration

Want to make sure have an entry for all congeners for all unique samples. Need to assess for each unique sample, which congeners are not measured.

``` r
## spread data - so congeners across columns
data4 = data3 %>% right_join(.,id_lookup, by="bio_id")%>% #join with bio_id
  select(new_id,date,variable,value)%>%
        spread(.,variable, value )%>%
        arrange(new_id)
head(data4)  #not all congeners measured for each bio_id
```

    ## Source: local data frame [6 x 8]
    ## 
    ##   new_id       date   CB101   CB138   CB153 CB180    CB28    CB52
    ##    (int)     (date)   (dbl)   (dbl)   (dbl) (dbl)   (dbl)   (dbl)
    ## 1      1 2009-09-01 0.00031 0.00092 0.00092    NA      NA 0.00022
    ## 2      2 2009-09-01 0.00043 0.00080 0.00067    NA      NA 0.00012
    ## 3      3 2009-09-01      NA 0.00079 0.00067    NA      NA 0.00030
    ## 4      4 2009-09-01 0.00017      NA 0.00027    NA 0.00039 0.00007
    ## 5      5 2009-09-01 0.00067 0.00117      NA    NA      NA 0.00036
    ## 6      6 2009-09-01 0.00050 0.00088      NA    NA 0.00082 0.00025

``` r
nrow(data4) #1100
```

    ## [1] 1100

``` r
##gather data again to long format for plotting, now have NA where congeners not measured
data4=data4 %>% gather(key= variable, value = value ,CB101,CB138,CB153,CB180,CB28,CB52, na.rm=FALSE )%>%
      arrange(new_id,variable)
head(data4)
```

    ## Source: local data frame [6 x 4]
    ## 
    ##   new_id       date variable   value
    ##    (int)     (date)    (chr)   (dbl)
    ## 1      1 2009-09-01    CB101 0.00031
    ## 2      1 2009-09-01    CB138 0.00092
    ## 3      1 2009-09-01    CB153 0.00092
    ## 4      1 2009-09-01    CB180      NA
    ## 5      1 2009-09-01     CB28      NA
    ## 6      1 2009-09-01     CB52 0.00022

### Explore how often different congeners are measured

``` r
## summerise congeners per new_ID
congener_count = data4 %>% group_by (new_id) %>%
                summarise(congener_count = sum(!is.na(value)))%>%
                ungroup()
congener_count
```

    ## Source: local data frame [1,100 x 2]
    ## 
    ##    new_id congener_count
    ##     (int)          (int)
    ## 1       1              4
    ## 2       2              4
    ## 3       3              3
    ## 4       4              4
    ## 5       5              3
    ## 6       6              4
    ## 7       7              3
    ## 8       8              4
    ## 9       9              4
    ## 10     10              5
    ## ..    ...            ...

``` r
#how many time is each congener measured
congener_freq = data4%>%group_by(variable)%>%
                summarise(congener_freq = sum(!is.na(value)))%>%
                ungroup()
congener_freq
```

    ## Source: local data frame [6 x 2]
    ## 
    ##   variable congener_freq
    ##      (chr)         (int)
    ## 1    CB101           883
    ## 2    CB138           896
    ## 3    CB153           930
    ## 4    CB180           920
    ## 5     CB28           926
    ## 6     CB52           907

``` r
#how many times was each congener counted by date
congener_freq_date = data4%>%group_by(variable,date)%>%
                summarise(congener_freq = sum(!is.na(value)))%>%
                ungroup()
congener_freq_date
```

    ## Source: local data frame [678 x 3]
    ## 
    ##    variable       date congener_freq
    ##       (chr)     (date)         (int)
    ## 1     CB101 2009-05-11             6
    ## 2     CB101 2009-07-28            11
    ## 3     CB101 2009-08-07             2
    ## 4     CB101 2009-08-13             4
    ## 5     CB101 2009-08-25             4
    ## 6     CB101 2009-09-01            21
    ## 7     CB101 2009-09-07            18
    ## 8     CB101 2009-09-10            19
    ## 9     CB101 2009-09-14             7
    ## 10    CB101 2009-09-15            10
    ## ..      ...        ...           ...

``` r
##PLOT
ggplot(congener_count)+geom_point(aes(new_id,congener_count))+
  xlab("Unique Sample ID")+
  ylab("Number Congeners Measured")
```

![](contaminants_prep_files/figure-markdown_github/congener%20count-1.png)<!-- -->

``` r
  #ggsave(file="baltic2015/prep/CW/contaminants/pcb7prepplot_congener_count.png")
##
ggplot(congener_count%>% left_join(.,id_lookup), by="new_id")+geom_point(aes(new_id,congener_count))+
  facet_wrap(~country)+
  xlab("Unique Sample ID")+
  ylab("Number Congeners Measured")
```

    ## Joining by: "new_id"

![](contaminants_prep_files/figure-markdown_github/congener%20count-2.png)<!-- -->

``` r
  #ggsave(file="baltic2015/prep/CW/contaminants/pcb7prepplot_congener_count_country.png")

ggplot(congener_count%>%left_join(.,id_lookup, by="new_id")%>%left_join(.,select(data4,new_id,date),by="new_id"))+geom_point(aes(date,congener_count))+
  facet_wrap(~country)+
  xlab("Unique Sample ID")+
  ylab("Number Congeners Measured")
```

    ## Warning: Removed 12 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/congener%20count-3.png)<!-- -->

``` r
  #ggsave(file="baltic2015/prep/CW/contaminants/pcb7prepplot_congener_count_country_bydate.png")


ggplot(congener_freq_date)+geom_point(aes(date,congener_freq))+
  facet_wrap(~variable)+
  xlab("Date")+
  ylab("Numer Samples with Congener measured")
```

    ## Warning: Removed 6 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/congener%20count-4.png)<!-- -->

### Overview plots

Overview plots of data distribution by country conducting the sampling, samples by date by BHI-ID

``` r
##------------------------#
## EXPLORATION PLOTS
##------------------------#

## plot by bio_id
ggplot(data4) + geom_point(aes(new_id, value,colour=variable))
```

    ## Warning: Removed 1138 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/overview%20plots-1.png)<!-- -->

``` r
##join data4 with country data and explore conger measurements by country
data5 = data4 %>% full_join(.,id_lookup, by="new_id")

## at ID, By Country
ggplot(data5) + geom_point(aes(new_id, value, colour=variable))+
  facet_wrap(~country)
```

    ## Warning: Removed 1138 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/overview%20plots-2.png)<!-- -->

``` r
## At Date, By Country
ggplot(data5) + geom_point(aes(date, value, colour=variable))+
  facet_wrap(~country)+
  scale_x_date(name= "Month-Year",date_breaks="1 year", date_labels = "%m-%y")
```

    ## Warning: Removed 1146 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/overview%20plots-3.png)<!-- -->

``` r
## At Date, By BHI ID
ggplot(data5) + geom_point(aes(date, value, colour = country))+
  facet_wrap(~bhi_id)+
  scale_x_date(date_breaks="1 year", date_labels = "%m-%y")
```

    ## Warning: Removed 1146 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/overview%20plots-4.png)<!-- -->

``` r
    ## German data assigned to 17 (Poland BHI region)
    data5 %>% filter(bhi_id==17 & country == "Germany") %>%
      select(station)%>%
      distinct(.)  #FOE-B11
```

    ## Source: local data frame [1 x 1]
    ## 
    ##   station
    ##     (chr)
    ## 1 FOE-B11

``` r
      loc_lookup %>% filter(station =="FOE-B11")
```

    ## Source: local data frame [1 x 5]
    ## 
    ##   country bhi_id station      lat      lon
    ##     (chr)  (int)   (chr)    (dbl)    (dbl)
    ## 1 Germany     17 FOE-B11 55.00733 17.43333

``` r
      ## is a station off poland

## At Date, By BHI ID
ggplot(data5) + geom_point(aes(date, value, color=station))+
  facet_wrap(~bhi_id)+
  scale_x_date(name= "Month-Year",date_breaks="1 year", date_labels = "%m-%y")+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"))
```

    ## Warning: Removed 1146 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/overview%20plots-5.png)<!-- -->

``` r
## at ID, By variable & country
ggplot(data5) + geom_point(aes(new_id, value))+
  facet_wrap(~variable+country)
```

    ## Warning: Removed 1138 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/overview%20plots-6.png)<!-- -->

``` r
    ## German values very high for a few congeners (CB138, CB153)
    ## need to check closer to see if multiple measurement for the same sample ID


ggplot(filter(data5, country=="Germany" & new_id < 200)) + geom_point(aes(new_id, value))+
  facet_wrap(~variable)
```

    ## Warning: Removed 93 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/overview%20plots-7.png)<!-- -->

``` r
data5 %>% filter(country=="Germany" & new_id < 200)%>%
    spread(variable, value)
```

    ## Source: local data frame [44 x 12]
    ## 
    ##    new_id       date country bhi_id station  bio_id    CB101    CB138
    ##     (int)     (date)   (chr)  (int)   (chr)   (chr)    (dbl)    (dbl)
    ## 1      81 2010-08-26 Germany     13 FOE-BMP 3119750       NA       NA
    ## 2      82 2010-08-26 Germany     13 FOE-BMP 3119751 0.000782 0.001529
    ## 3      83 2010-08-26 Germany     13 FOE-BMP 3119752       NA 0.003895
    ## 4      84 2010-08-26 Germany     13 FOE-BMP 3119753 0.000481 0.001351
    ## 5      85 2010-08-26 Germany     13 FOE-BMP 3119754       NA       NA
    ## 6      86 2010-08-26 Germany     13 FOE-BMP 3119755 0.001000 0.001432
    ## 7      87 2010-08-26 Germany     13 FOE-BMP 3119756       NA       NA
    ## 8      88 2010-08-26 Germany     13 FOE-BMP 3119757 0.001430 0.002137
    ## 9      89 2010-08-26 Germany     13 FOE-BMP 3119758       NA 0.003676
    ## 10     90 2010-08-26 Germany     13 FOE-BMP 3119759       NA       NA
    ## ..    ...        ...     ...    ...     ...     ...      ...      ...
    ## Variables not shown: CB153 (dbl), CB180 (dbl), CB28 (dbl), CB52 (dbl)

``` r
    ## data are multiple new_id/bio_id but many samples per station & data - as would expect
    ##  different combos of congeners measured for different bio_ids at the same station and date
```

### Country and Congener measured

``` r
data5 %>% select(variable,country) %>% distinct(.)%>% print (n=25)
```

    ## Source: local data frame [24 x 2]
    ## 
    ##    variable country
    ##       (chr)   (chr)
    ## 1     CB101  Poland
    ## 2     CB138  Poland
    ## 3     CB153  Poland
    ## 4     CB180  Poland
    ## 5      CB28  Poland
    ## 6      CB52  Poland
    ## 7     CB101 Germany
    ## 8     CB138 Germany
    ## 9     CB153 Germany
    ## 10    CB180 Germany
    ## 11     CB28 Germany
    ## 12     CB52 Germany
    ## 13    CB101 Finland
    ## 14    CB138 Finland
    ## 15    CB153 Finland
    ## 16    CB180 Finland
    ## 17     CB28 Finland
    ## 18     CB52 Finland
    ## 19    CB101  Sweden
    ## 20    CB138  Sweden
    ## 21    CB153  Sweden
    ## 22    CB180  Sweden
    ## 23     CB28  Sweden
    ## 24     CB52  Sweden

### Assess sample composition

How many individuals sampled in different samples?

``` r
##------------------------#
## ASSESS SAMPLE COMPOSITION - NUM INDIV FISH INCLUDED
##------------------------#
## join data to get source # num_indiv_subsamp
data6 = data5 %>% left_join(.,select(data3,bio_id,source, num_indiv_subsamp), by="bio_id")
head(data6) 
```

    ## Source: local data frame [6 x 10]
    ## 
    ##   new_id       date variable   value country bhi_id station  bio_id source
    ##    (int)     (date)    (chr)   (dbl)   (chr)  (int)   (chr)   (chr)  (chr)
    ## 1      1 2009-09-01    CB101 0.00031  Poland     21    LWLA 2971421   ICES
    ## 2      1 2009-09-01    CB101 0.00031  Poland     21    LWLA 2971421   ICES
    ## 3      1 2009-09-01    CB101 0.00031  Poland     21    LWLA 2971421   ICES
    ## 4      1 2009-09-01    CB101 0.00031  Poland     21    LWLA 2971421   ICES
    ## 5      1 2009-09-01    CB138 0.00092  Poland     21    LWLA 2971421   ICES
    ## 6      1 2009-09-01    CB138 0.00092  Poland     21    LWLA 2971421   ICES
    ## Variables not shown: num_indiv_subsamp (int)

``` r
ggplot(distinct(data6,new_id)) + geom_point(aes(new_id, num_indiv_subsamp))+
  facet_wrap(~country)
```

    ## Warning: Removed 446 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/sample%20comp-1.png)<!-- -->

``` r
    ##need to investigate Swedish data - some id's with many individuals pooled

  data6 %>% filter(country=="Sweden" & num_indiv_subsamp > 1)
```

    ## Source: local data frame [2,124 x 10]
    ## 
    ##    new_id       date variable      value country bhi_id   station  bio_id
    ##     (int)     (date)    (chr)      (dbl)   (chr)  (int)     (chr)   (chr)
    ## 1     345 2011-06-06    CB101 0.00041832  Sweden     14 Utlaengan 3402542
    ## 2     345 2011-06-06    CB101 0.00041832  Sweden     14 Utlaengan 3402542
    ## 3     345 2011-06-06    CB101 0.00041832  Sweden     14 Utlaengan 3402542
    ## 4     345 2011-06-06    CB101 0.00041832  Sweden     14 Utlaengan 3402542
    ## 5     345 2011-06-06    CB101 0.00041832  Sweden     14 Utlaengan 3402542
    ## 6     345 2011-06-06    CB101 0.00041832  Sweden     14 Utlaengan 3402542
    ## 7     345 2011-06-06    CB138 0.00081672  Sweden     14 Utlaengan 3402542
    ## 8     345 2011-06-06    CB138 0.00081672  Sweden     14 Utlaengan 3402542
    ## 9     345 2011-06-06    CB138 0.00081672  Sweden     14 Utlaengan 3402542
    ## 10    345 2011-06-06    CB138 0.00081672  Sweden     14 Utlaengan 3402542
    ## ..    ...        ...      ...        ...     ...    ...       ...     ...
    ## Variables not shown: source (chr), num_indiv_subsamp (int)

``` r
  #count samples with >1 indiv in sample
  data6 %>% select(country, num_indiv_subsamp)%>%
    group_by(country,num_indiv_subsamp) %>% summarise(count = n())
```

    ## Source: local data frame [8 x 3]
    ## Groups: country [?]
    ## 
    ##   country num_indiv_subsamp count
    ##     (chr)             (int) (int)
    ## 1 Finland                 1  4128
    ## 2 Germany                 1  1938
    ## 3  Poland                 1  5376
    ## 4  Sweden                 1  4962
    ## 5  Sweden                11    36
    ## 6  Sweden                12  2040
    ## 7  Sweden                13    48
    ## 8  Sweden                NA 14244

``` r
  ##This has a large number of samples because each congener a separate "sample" here

  # country num_indiv_subsamp count
  # (chr)             (dbl) (int)
  # 1 Finland                 1  5600
  # 2 Germany                 1  2674
  # 3  Poland                 1  7252
  # 4  Sweden                 1  6818
  # 5  Sweden                10     7
  # 6  Sweden                11    49
  # 7  Sweden                12  2891
  # 8  Sweden                13    70
  # 9  Sweden                NA 19439

  ## Which data sources are NA?
  data6 %>% select(country, num_indiv_subsamp, source,station)%>%
    filter(is.na(num_indiv_subsamp))%>%
    distinct(.)
```

    ## Source: local data frame [24 x 4]
    ## 
    ##    country num_indiv_subsamp source           station
    ##      (chr)             (int)  (chr)             (chr)
    ## 1   Sweden                NA    IVL  Seskaroefjaerden
    ## 2   Sweden                NA    IVL      Storfjaerden
    ## 3   Sweden                NA    IVL         Utlaengan
    ## 4   Sweden                NA    IVL    Gaviksfjaerden
    ## 5   Sweden                NA    IVL Langvindsfjaerden
    ## 6   Sweden                NA    IVL            Lagnoe
    ## 7   Sweden                NA    IVL            Fladen
    ## 8   Sweden                NA    IVL      Harufjaerden
    ## 9   Sweden                NA    IVL   Aengskaersklubb
    ## 10  Sweden                NA    IVL        Holmoearna
    ## ..     ...               ...    ...               ...

``` r
    ## IVL data (at least some) do not have number of individuals in subsample entered
```

### Assess data flagged

What data are qflagged (detection or quantifcation limit)?

``` r
data7 = data5 %>% left_join(.,select(data3,source,bio_id,variable,date,value, source,qflag,detli,lmqnt), by=c("bio_id","variable","date","value"))
head(data7)
```

    ## Source: local data frame [6 x 12]
    ## 
    ##   new_id       date variable   value country bhi_id station  bio_id source
    ##    (int)     (date)    (chr)   (dbl)   (chr)  (int)   (chr)   (chr)  (chr)
    ## 1      1 2009-09-01    CB101 0.00031  Poland     21    LWLA 2971421   ICES
    ## 2      1 2009-09-01    CB138 0.00092  Poland     21    LWLA 2971421   ICES
    ## 3      1 2009-09-01    CB153 0.00092  Poland     21    LWLA 2971421   ICES
    ## 4      1 2009-09-01    CB180      NA  Poland     21    LWLA 2971421     NA
    ## 5      1 2009-09-01     CB28      NA  Poland     21    LWLA 2971421     NA
    ## 6      1 2009-09-01     CB52 0.00022  Poland     21    LWLA 2971421   ICES
    ## Variables not shown: qflag (chr), detli (dbl), lmqnt (dbl)

``` r
dim(data7); dim(data5) #should have same number of rows
```

    ## [1] 6600   12

    ## [1] 6600    8

### Number of samples with all 6 congeners

534 samples 2009-2013 with all 6 congeners measured (this is not unique dates)

``` r
congener_count # number of congeners per new_id
```

    ## Source: local data frame [1,100 x 2]
    ## 
    ##    new_id congener_count
    ##     (int)          (int)
    ## 1       1              4
    ## 2       2              4
    ## 3       3              3
    ## 4       4              4
    ## 5       5              3
    ## 6       6              4
    ## 7       7              3
    ## 8       8              4
    ## 9       9              4
    ## 10     10              5
    ## ..    ...            ...

``` r
congener_count6 = congener_count %>% filter(congener_count == 6) #new_id with all six congeners
congener_count6 %>% summarise(count=n()) #534 samples
```

    ## Source: local data frame [1 x 1]
    ## 
    ##   count
    ##   (int)
    ## 1   534

``` r
#select data for only samples with all 6 congeners
data8 = data7 %>% right_join(congener_count6, by="new_id") %>% arrange(new_id)
dim(data8)
```

    ## [1] 3204   13

### Plots of data with all 6 congeners measured

Second two plots show qflags

``` r
ggplot(data8) + geom_point(aes(date,value, colour=variable))+
facet_wrap(~station)
```

![](contaminants_prep_files/figure-markdown_github/plot%206%20congener%20data%20coverage-1.png)<!-- -->

``` r
ggplot(data8) + geom_point(aes(date,value, colour=variable))+
facet_wrap(~bhi_id, scales="free_y")
```

![](contaminants_prep_files/figure-markdown_github/plot%206%20congener%20data%20coverage-2.png)<!-- -->

``` r
ggplot(data8) + geom_point(aes(date,value, colour=variable,shape=factor(qflag)))+
facet_wrap(~bhi_id, scales="free_y")
```

    ## Warning: Removed 2787 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/plot%206%20congener%20data%20coverage-3.png)<!-- -->

### Plot data filtering for no qflags and all congeners measured

Plot of just one congener to show sampling coverage
*limited data coverage over time and BHI region*

``` r
## how many of the samples with all 6 congeners do not have any qflag?
data8_no_q_id= data8 %>% group_by(new_id) %>% 
          summarise(congener_no_q = sum(is.na(qflag)) )%>%
          ungroup()%>%
          filter(congener_no_q==6)

          nrow(data8_no_q_id)  #214 samples with all 6 congeners and no qflags
```

    ## [1] 214

``` r
data8_no_q =data8 %>% right_join(data8_no_q_id, by=c("new_id"))

##These are the samples over time avaiable with no qflags and all congeners measured
ggplot(filter(data8_no_q, variable=="CB28")) + geom_point(aes(date,value))+
  facet_wrap(~bhi_id)
```

![](contaminants_prep_files/figure-markdown_github/no%20qflag%20and%20all%20congener%20plot-1.png)<!-- -->

### Take 6 PCB total concentration for samples with no qflag

``` r
data8_no_q
```

    ## Source: local data frame [1,284 x 14]
    ## 
    ##    new_id       date variable   value country bhi_id station  bio_id
    ##     (int)     (date)    (chr)   (dbl)   (chr)  (int)   (chr)   (chr)
    ## 1      21 2009-09-10    CB101 0.00180  Poland     17    LKOL 2971441
    ## 2      21 2009-09-10    CB138 0.00156  Poland     17    LKOL 2971441
    ## 3      21 2009-09-10    CB153 0.00194  Poland     17    LKOL 2971441
    ## 4      21 2009-09-10    CB180 0.00048  Poland     17    LKOL 2971441
    ## 5      21 2009-09-10     CB28 0.00013  Poland     17    LKOL 2971441
    ## 6      21 2009-09-10     CB52 0.00023  Poland     17    LKOL 2971441
    ## 7      25 2009-09-10    CB101 0.00153  Poland     17    LKOL 2971445
    ## 8      25 2009-09-10    CB138 0.00107  Poland     17    LKOL 2971445
    ## 9      25 2009-09-10    CB153 0.00110  Poland     17    LKOL 2971445
    ## 10     25 2009-09-10    CB180 0.00014  Poland     17    LKOL 2971445
    ## ..    ...        ...      ...     ...     ...    ...     ...     ...
    ## Variables not shown: source (chr), qflag (chr), detli (dbl), lmqnt (dbl),
    ##   congener_count (int), congener_no_q (int)

``` r
data8_no_q_total = data8_no_q %>% select(new_id, date, variable,value,country, station, bhi_id) %>%
                  group_by(new_id,date,country,station,bhi_id)%>%
                  summarise( pcb6_conc = sum(value))%>%
                  ungroup()

data8_no_q_total
```

    ## Source: local data frame [214 x 6]
    ## 
    ##    new_id       date country station bhi_id pcb6_conc
    ##     (int)     (date)   (chr)   (chr)  (int)     (dbl)
    ## 1      21 2009-09-10  Poland    LKOL     17   0.00614
    ## 2      25 2009-09-10  Poland    LKOL     17   0.00417
    ## 3      26 2009-09-10  Poland    LKOL     17   0.00395
    ## 4      29 2009-09-10  Poland    LKOL     17   0.00675
    ## 5      30 2009-09-10  Poland    LKOL     17   0.00462
    ## 6      31 2009-09-10  Poland    LKOL     17   0.00391
    ## 7      32 2009-09-10  Poland    LKOL     17   0.00307
    ## 8      33 2009-09-10  Poland    LKOL     17   0.00295
    ## 9      34 2009-09-10  Poland    LKOL     17   0.00325
    ## 10     35 2009-09-10  Poland    LKOL     17   0.00345
    ## ..    ...        ...     ...     ...    ...       ...

### Convert units to ng/g to match EU threshold value units

``` r
## Read in unit conversion table
unit_lookup= readr::read_csv2(file.path(dir_con, 'unit_conversion_lookup.csv'))
unit_lookup
```

    ## Source: local data frame [3 x 4]
    ## 
    ##   OriginalUnit ConvertFactor_mg_kg ConvertFactor_ug_kg ConvertFactor_ng_g
    ##          (chr)               (chr)               (int)              (int)
    ## 1        ug/kg               0.001                   1                  1
    ## 2        mg/kg                   1                1000               1000
    ## 3         ng/g               0.001                   1                  1

``` r
convert_ng_g = unit_lookup %>% filter(OriginalUnit == "mg/kg") %>% select(ConvertFactor_ng_g)%>% as.numeric()

data8_no_q_total = data8_no_q_total %>%
                    mutate(pcb6_conc_ng_g = pcb6_conc * convert_ng_g,
                           pcb6_threshold = 75)

#how many greater than the threshold?
data8_no_q_total %>% filter(pcb6_conc_ng_g > pcb6_threshold) #one sample
```

    ## Source: local data frame [1 x 8]
    ## 
    ##   new_id       date country station bhi_id pcb6_conc pcb6_conc_ng_g
    ##    (int)     (date)   (chr)   (chr)  (int)     (dbl)          (dbl)
    ## 1     96 2010-08-26 Germany FOE-BMP     13  0.159078        159.078
    ## Variables not shown: pcb6_threshold (dbl)

### Plot samples relative to threshold

1 sample exceeds the threshold (when restricted to samples with no qflags)

``` r
ggplot(data8_no_q_total) + geom_point(aes(date,pcb6_conc_ng_g))+
  geom_line(aes(date,pcb6_threshold)) +
  facet_wrap(~bhi_id, scales="free_y")+
  ylab("6 PCB total concentration ng/g")
```

![](contaminants_prep_files/figure-markdown_github/plot%20samples%20and%20threshold-1.png)<!-- --> \#\#\# Mean total concentration value by station and date

``` r
data8_no_q_total_sample_mean = data8_no_q_total %>% 
                              group_by(date,country,station,bhi_id, pcb6_threshold)%>%
                              summarise(pcb6_mean_sample_ng_g = mean(pcb6_conc_ng_g),
                                        pcb6_sd_sample_ng_g= sd(pcb6_conc_ng_g))%>%
                              ungroup()
data8_no_q_total_sample_mean
```

    ## Source: local data frame [50 x 7]
    ## 
    ##          date country                 station bhi_id pcb6_threshold
    ##        (date)   (chr)                   (chr)  (int)          (dbl)
    ## 1  2009-05-11  Sweden               Utlaengan     14             75
    ## 2  2009-08-07  Sweden          Gaviksfjaerden     NA             75
    ## 3  2009-08-25  Sweden                  Lagnoe     35             75
    ## 4  2009-09-10  Poland                    LKOL     17             75
    ## 5  2009-09-15 Finland        lat59.55lon22.61     30             75
    ## 6  2009-09-28  Sweden            Harufjaerden     41             75
    ## 7  2009-09-29  Sweden Bothnian Sea. Off shore     37             75
    ## 8  2009-10-27  Sweden               Utlaengan     14             75
    ## 9  2009-10-29  Sweden     Vaestra Hanoebukten     14             75
    ## 10 2009-11-12  Sweden                Landsort     29             75
    ## ..        ...     ...                     ...    ...            ...
    ## Variables not shown: pcb6_mean_sample_ng_g (dbl), pcb6_sd_sample_ng_g
    ##   (dbl)

``` r
dim(data8_no_q_total_sample_mean) #50 unique dates x station
```

    ## [1] 50  7

``` r
ggplot(data8_no_q_total_sample_mean) + geom_point(aes(date,pcb6_mean_sample_ng_g))+
  geom_line(aes(date,pcb6_threshold)) +
  facet_wrap(~bhi_id, scales="free_y")+
  ylab("Date Sample Mean 6 PCB total concentration ng/g")
```

    ## geom_path: Each group consists of only one observation. Do you need to
    ## adjust the group aesthetic?
    ## geom_path: Each group consists of only one observation. Do you need to
    ## adjust the group aesthetic?

![](contaminants_prep_files/figure-markdown_github/mean%20value%20loc%20and%20date-1.png)<!-- -->

### Incorporate data qflagged 2009-2013

Convert flagged congener values to LOD/2 or LOQ/sqrt(2)
Then sum to get a total sample concentration

``` r
## Adjust value of those data with qflag
data8_q_adj = data8 %>%
              mutate(value_adj = ifelse(!is.na(qflag) & !is.na(detli) & source=="ICES",value/2,  
                                 ifelse(!is.na(qflag) & !is.na(lmqnt) & source =="ICES", value/sqrt(2),
                                 ifelse(!is.na(qflag)& source=="IVL",value / 2, value))))  #if ICES data, know that value is either detli or lmqnt if flagged, if is IVL data, do not have detli value if flagged, instead is raw data, but convert this to anyways to value /2 for now. May need to go back at replace with detect limit value but is not clear how to get the correct detection limit values from IVL website

head(data8_q_adj)
```

    ## Source: local data frame [6 x 14]
    ## 
    ##   new_id       date variable   value country bhi_id station  bio_id source
    ##    (int)     (date)    (chr)   (dbl)   (chr)  (int)   (chr)   (chr)  (chr)
    ## 1     21 2009-09-10    CB101 0.00180  Poland     17    LKOL 2971441   ICES
    ## 2     21 2009-09-10    CB138 0.00156  Poland     17    LKOL 2971441   ICES
    ## 3     21 2009-09-10    CB153 0.00194  Poland     17    LKOL 2971441   ICES
    ## 4     21 2009-09-10    CB180 0.00048  Poland     17    LKOL 2971441   ICES
    ## 5     21 2009-09-10     CB28 0.00013  Poland     17    LKOL 2971441   ICES
    ## 6     21 2009-09-10     CB52 0.00023  Poland     17    LKOL 2971441   ICES
    ## Variables not shown: qflag (chr), detli (dbl), lmqnt (dbl), congener_count
    ##   (int), value_adj (dbl)

``` r
data8_q_adj %>% arrange(qflag) %>% print(n=100)
```

    ## Source: local data frame [3,204 x 14]
    ## 
    ##     new_id       date variable     value country bhi_id            station
    ##      (int)     (date)    (chr)     (dbl)   (chr)  (int)              (chr)
    ## 1       41 2010-09-06     CB52 0.0000200  Poland     21               LWLA
    ## 2       54 2010-09-06     CB28 0.0001200  Poland     21               LWLA
    ## 3       58 2010-09-06     CB28 0.0001200  Poland     21               LWLA
    ## 4       59 2010-09-06     CB28 0.0001200  Poland     21               LWLA
    ## 5      142 2011-09-12     CB28 0.0000200  Poland     21               LWLA
    ## 6      165 2009-07-28     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 7      165 2009-07-28     CB52 0.0000400 Finland     42   lat64.18lon23.33
    ## 8      176 2009-07-28     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 9      178 2009-09-15    CB180 0.0000600 Finland     30   lat59.55lon22.61
    ## 10     184 2009-09-15    CB180 0.0000600 Finland     30   lat59.55lon22.61
    ## 11     184 2009-09-15     CB28 0.0000400 Finland     30   lat59.55lon22.61
    ## 12     184 2009-09-15     CB52 0.0000400 Finland     30   lat59.55lon22.61
    ## 13     188 2009-09-15    CB180 0.0000600 Finland     30   lat59.55lon22.61
    ## 14     188 2009-09-15     CB52 0.0000400 Finland     30   lat59.55lon22.61
    ## 15     189 2009-09-14    CB101 0.0000400 Finland     38   lat61.71lon20.71
    ## 16     189 2009-09-14    CB180 0.0000600 Finland     38   lat61.71lon20.71
    ## 17     189 2009-09-14     CB28 0.0000400 Finland     38   lat61.71lon20.71
    ## 18     190 2009-09-14     CB28 0.0000400 Finland     38   lat61.71lon20.71
    ## 19     190 2009-09-14     CB52 0.0000400 Finland     38   lat61.71lon20.71
    ## 20     203 2010-09-23     CB28 0.0000400 Finland     38   lat61.71lon20.71
    ## 21     203 2010-09-23     CB52 0.0000400 Finland     38   lat61.71lon20.71
    ## 22     204 2010-09-23     CB28 0.0000400 Finland     38   lat61.71lon20.71
    ## 23     204 2010-09-23     CB52 0.0000400 Finland     38   lat61.71lon20.71
    ## 24     207 2010-09-23     CB52 0.0000400 Finland     38   lat61.71lon20.71
    ## 25     212 2010-09-23     CB28 0.0000400 Finland     38   lat61.71lon20.71
    ## 26     212 2010-09-23     CB52 0.0000400 Finland     38   lat61.71lon20.71
    ## 27     227 2011-05-30    CB180 0.0000600 Finland     30   lat59.55lon22.61
    ## 28     230 2011-05-30    CB180 0.0000600 Finland     30   lat59.55lon22.61
    ## 29     231 2011-05-30    CB180 0.0000600 Finland     30   lat59.55lon22.61
    ## 30     232 2011-05-30    CB180 0.0000600 Finland     30   lat59.55lon22.61
    ## 31     235 2011-05-25     CB28 0.0000400 Finland     38   lat61.71lon20.71
    ## 32     244 2011-05-25    CB180 0.0000600 Finland     38   lat61.71lon20.71
    ## 33     244 2011-05-25     CB28 0.0000400 Finland     38   lat61.71lon20.71
    ## 34     251 2011-05-18     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 35     252 2011-05-18     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 36     252 2011-05-18     CB52 0.0000400 Finland     42   lat64.18lon23.33
    ## 37     253 2011-05-18     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 38     253 2011-05-18     CB52 0.0000400 Finland     42   lat64.18lon23.33
    ## 39     254 2011-05-18     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 40     254 2011-05-18     CB52 0.0000400 Finland     42   lat64.18lon23.33
    ## 41     255 2011-05-18     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 42     256 2011-05-18     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 43     257 2011-05-18     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 44     258 2011-05-18     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 45     262 2011-05-18     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 46     265 2011-05-18     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 47     286 2012-05-21     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 48     287 2012-05-21     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 49     287 2012-05-21     CB52 0.0000400 Finland     42   lat64.18lon23.33
    ## 50     288 2012-05-21    CB138 0.0000600 Finland     42   lat64.18lon23.33
    ## 51     288 2012-05-21     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 52     288 2012-05-21     CB52 0.0000400 Finland     42   lat64.18lon23.33
    ## 53     289 2012-05-21     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 54     290 2012-05-21     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 55     291 2012-05-21     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 56     292 2012-05-21     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 57     293 2012-05-21     CB28 0.0000400 Finland     42   lat64.18lon23.33
    ## 58     303 2012-11-09    CB101 0.0000400 Finland     30   lat59.55lon22.61
    ## 59     661 2009-08-13     CB28 0.0001400  Sweden     NA  Langvindsfjaerden
    ## 60     662 2009-08-13     CB28 0.0001210  Sweden     NA  Langvindsfjaerden
    ## 61     664 2009-08-25     CB28 0.0000704  Sweden     35             Lagnoe
    ## 62     665 2009-09-07    CB180 0.0002004  Sweden      1             Fladen
    ## 63     665 2009-09-07     CB28 0.0001002  Sweden      1             Fladen
    ## 64     667 2009-09-07    CB180 0.0001143  Sweden      1             Fladen
    ## 65     667 2009-09-07     CB28 0.0001143  Sweden      1             Fladen
    ## 66     675 2009-09-07     CB28 0.0000651  Sweden      1             Fladen
    ## 67     677 2009-09-28     CB28 0.0000816  Sweden     41       Harufjaerden
    ## 68     679 2009-09-28     CB28 0.0001180  Sweden     41       Harufjaerden
    ## 69     680 2009-09-28     CB28 0.0000668  Sweden     41       Harufjaerden
    ## 70     682 2009-09-28     CB28 0.0000760  Sweden     41       Harufjaerden
    ## 71     683 2009-09-28     CB28 0.0000690  Sweden     41       Harufjaerden
    ## 72     684 2009-09-28     CB28 0.0000723  Sweden     41       Harufjaerden
    ## 73     685 2009-09-28     CB28 0.0001088  Sweden     41       Harufjaerden
    ## 74     686 2009-09-28     CB28 0.0000810  Sweden     41       Harufjaerden
    ## 75     687 2009-09-28     CB28 0.0000639  Sweden     41       Harufjaerden
    ## 76     688 2009-09-28     CB28 0.0000375  Sweden     41       Harufjaerden
    ## 77     692 2009-09-15     CB28 0.0001076  Sweden     39         Holmoearna
    ## 78     695 2009-10-12     CB28 0.0001480  Sweden     NA Kinnbaecksfjaerden
    ## 79     696 2009-10-12     CB28 0.0001560  Sweden     NA Kinnbaecksfjaerden
    ## 80     703 2009-11-12     CB28 0.0001344  Sweden     29           Landsort
    ## 81     704 2009-11-12     CB28 0.0000388  Sweden     29           Landsort
    ## 82     711 2009-11-12     CB28 0.0001120  Sweden     29           Landsort
    ## 83     717 2009-10-27     CB28 0.0000772  Sweden     14          Utlaengan
    ## 84     719 2009-10-27     CB28 0.0000425  Sweden     14          Utlaengan
    ## 85     723 2009-10-27     CB28 0.0000657  Sweden     14          Utlaengan
    ## 86     727 2009-11-30     CB28 0.0004965  Sweden     11            Abbekas
    ## 87     728 2009-11-30     CB28 0.0002724  Sweden     11            Abbekas
    ## 88     729 2009-09-17     CB28 0.0001180  Sweden     41       Ranefjaerden
    ## 89     730 2009-09-17     CB28 0.0001185  Sweden     41       Ranefjaerden
    ## 90     731 2009-10-22     CB28 0.0001440  Sweden     37    Aengskaersklubb
    ## 91     738 2009-10-22     CB28 0.0000444  Sweden     37    Aengskaersklubb
    ## 92     746 2010-06-11     CB28 0.0001570  Sweden     37    Aengskaersklubb
    ## 93     748 2010-05-24     CB28 0.0000360  Sweden     14          Utlaengan
    ## 94     749 2010-09-20     CB28 0.0000736  Sweden     41       Harufjaerden
    ## 95     749 2010-09-20     CB52 0.0000736  Sweden     41       Harufjaerden
    ## 96     750 2010-09-20     CB28 0.0000615  Sweden     41       Harufjaerden
    ## 97     751 2010-09-20     CB28 0.0000804  Sweden     41       Harufjaerden
    ## 98     752 2010-09-20     CB28 0.0000684  Sweden     41       Harufjaerden
    ## 99     753 2010-09-20     CB28 0.0000471  Sweden     41       Harufjaerden
    ## 100    754 2010-09-20     CB28 0.0000592  Sweden     41       Harufjaerden
    ## ..     ...        ...      ...       ...     ...    ...                ...
    ## Variables not shown: bio_id (chr), source (chr), qflag (chr), detli (dbl),
    ##   lmqnt (dbl), congener_count (int), value_adj (dbl)

``` r
## Get total concentration per sample
data8_q_adj_total = data8_q_adj %>% select(new_id, date, variable,value_adj,country, station, bhi_id) %>%
                  group_by(new_id,date,country,station,bhi_id)%>%
                  summarise(pcb6_conc = sum(value_adj))%>%
                  ungroup()
data8_q_adj_total
```

    ## Source: local data frame [534 x 6]
    ## 
    ##    new_id       date country station bhi_id pcb6_conc
    ##     (int)     (date)   (chr)   (chr)  (int)     (dbl)
    ## 1      21 2009-09-10  Poland    LKOL     17   0.00614
    ## 2      25 2009-09-10  Poland    LKOL     17   0.00417
    ## 3      26 2009-09-10  Poland    LKOL     17   0.00395
    ## 4      29 2009-09-10  Poland    LKOL     17   0.00675
    ## 5      30 2009-09-10  Poland    LKOL     17   0.00462
    ## 6      31 2009-09-10  Poland    LKOL     17   0.00391
    ## 7      32 2009-09-10  Poland    LKOL     17   0.00307
    ## 8      33 2009-09-10  Poland    LKOL     17   0.00295
    ## 9      34 2009-09-10  Poland    LKOL     17   0.00325
    ## 10     35 2009-09-10  Poland    LKOL     17   0.00345
    ## ..    ...        ...     ...     ...    ...       ...

``` r
## convert data to ng/g using convert_ng_g
data8_q_adj_total = data8_q_adj_total %>%
                    mutate(pcb6_conc_ng_g = pcb6_conc * convert_ng_g,
                           pcb6_threshold = 75)

data8_q_adj_total
```

    ## Source: local data frame [534 x 8]
    ## 
    ##    new_id       date country station bhi_id pcb6_conc pcb6_conc_ng_g
    ##     (int)     (date)   (chr)   (chr)  (int)     (dbl)          (dbl)
    ## 1      21 2009-09-10  Poland    LKOL     17   0.00614           6.14
    ## 2      25 2009-09-10  Poland    LKOL     17   0.00417           4.17
    ## 3      26 2009-09-10  Poland    LKOL     17   0.00395           3.95
    ## 4      29 2009-09-10  Poland    LKOL     17   0.00675           6.75
    ## 5      30 2009-09-10  Poland    LKOL     17   0.00462           4.62
    ## 6      31 2009-09-10  Poland    LKOL     17   0.00391           3.91
    ## 7      32 2009-09-10  Poland    LKOL     17   0.00307           3.07
    ## 8      33 2009-09-10  Poland    LKOL     17   0.00295           2.95
    ## 9      34 2009-09-10  Poland    LKOL     17   0.00325           3.25
    ## 10     35 2009-09-10  Poland    LKOL     17   0.00345           3.45
    ## ..    ...        ...     ...     ...    ...       ...            ...
    ## Variables not shown: pcb6_threshold (dbl)

``` r
dim(data8_q_adj_total)
```

    ## [1] 534   8

### Plot 6-PCB total conc included samples with qflagged data relative to threshold

``` r
ggplot(data8_q_adj_total) + geom_point(aes(date,pcb6_conc_ng_g))+
  geom_line(aes(date,pcb6_threshold)) +
  facet_wrap(~bhi_id, scales="free_y")+
  ylab("6 PCB total concentration ng/g")
```

![](contaminants_prep_files/figure-markdown_github/plot%20total%20conc%20including%20qflagged%20samples-1.png)<!-- -->

### Mean total concentration value by station and date w/qflagged data

``` r
data8_q_adj_sample_mean = data8_q_adj_total %>% 
                              group_by(date,country,station,bhi_id, pcb6_threshold)%>%
                              summarise(pcb6_mean_sample_ng_g = mean(pcb6_conc_ng_g),
                                        pcb6_sd_sample_ng_g= sd(pcb6_conc_ng_g))%>%
                              ungroup()
data8_q_adj_sample_mean
```

    ## Source: local data frame [109 x 7]
    ## 
    ##          date country           station bhi_id pcb6_threshold
    ##        (date)   (chr)             (chr)  (int)          (dbl)
    ## 1  2009-05-11  Sweden         Utlaengan     14             75
    ## 2  2009-07-28 Finland  lat64.18lon23.33     42             75
    ## 3  2009-08-07  Sweden    Gaviksfjaerden     NA             75
    ## 4  2009-08-13  Sweden Langvindsfjaerden     NA             75
    ## 5  2009-08-25  Sweden            Lagnoe     35             75
    ## 6  2009-09-07  Sweden        E/W FLADEN      1             75
    ## 7  2009-09-07  Sweden            Fladen      1             75
    ## 8  2009-09-10  Poland              LKOL     17             75
    ## 9  2009-09-14 Finland  lat61.71lon20.71     38             75
    ## 10 2009-09-15 Finland  lat59.55lon22.61     30             75
    ## ..        ...     ...               ...    ...            ...
    ## Variables not shown: pcb6_mean_sample_ng_g (dbl), pcb6_sd_sample_ng_g
    ##   (dbl)

``` r
ggplot(data8_q_adj_sample_mean) + geom_point(aes(date,pcb6_mean_sample_ng_g))+
  geom_line(aes(date,pcb6_threshold)) +
  facet_wrap(~bhi_id, scales="free_y")+
  ylab("Date Sample Mean 6 PCB total concentration ng/g")
```

![](contaminants_prep_files/figure-markdown_github/average%20station%20date%20with%20qflagged%20data-1.png)<!-- -->

Visualize mean sample points on a BHI region map
------------------------------------------------

``` r
# plot data in map
library('ggmap')
map = get_map(location = c(8.5, 53, 32, 67.5))
```

    ## Warning: bounding box given to google - spatial extent only approximate.

    ## converting bounding box to center/zoom specification. (experimental)

    ## Map from URL : http://maps.googleapis.com/maps/api/staticmap?center=60.25,20.25&zoom=5&size=640x640&scale=2&maptype=terrain&language=en-EN&sensor=false

``` r
map_data = data8_q_adj_sample_mean %>% left_join(.,loc_lookup, by=c("station","bhi_id","country"))
str(map_data)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    111 obs. of  9 variables:
    ##  $ date                 : Date, format: "2009-05-11" "2009-07-28" ...
    ##  $ country              : chr  "Sweden" "Finland" "Sweden" "Sweden" ...
    ##  $ station              : chr  "Utlaengan" "lat64.18lon23.33" "Gaviksfjaerden" "Langvindsfjaerden" ...
    ##  $ bhi_id               : int  14 42 NA NA 35 1 1 17 38 30 ...
    ##  $ pcb6_threshold       : num  75 75 75 75 75 75 75 75 75 75 ...
    ##  $ pcb6_mean_sample_ng_g: num  4.98 1.28 13.81 7.47 12.7 ...
    ##  $ pcb6_sd_sample_ng_g  : num  0.843 0.998 NaN 1.508 5.428 ...
    ##  $ lat                  : num  55.9 64.2 62.9 61.5 59.6 ...
    ##  $ lon                  : num  15.8 23.3 18.2 17.2 18.8 ...

``` r
#add year to map data
map_data = map_data %>% mutate(year =as.numeric(format(date,"%Y")))


#set up the plot
plot_map = ggmap(map) +
  geom_point(aes(x=lon, y=lat,colour=pcb6_mean_sample_ng_g, shape=factor(year)), data=map_data,size = 2) 

#plot the map
plot_map + scale_color_gradientn(colours=rainbow(5))+
  ggtitle('6 PCB Mean Total Concentration, Dates 2009-2013') +
  theme(title = element_text(size = 12)) 
```

    ## Warning: Removed 1 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/samples%20on%20map-1.png)<!-- -->

Next steps
----------

### Data steps

**Make sure check with Marc on IVL stations with no BHI ID**
1. How many samples have all 6 congeners measured? Sufficient for status?
 - 534 samples 2009-2013 with all 6 congeners measured (this is not unique dates)
 - Only 214 samples when exclude a sample that has any qflags associated with.

1.  Need a final concentration value for each congener.
    -   How to calculate final concentration
        -   if congener was at the detection or quantification limit, need to adjust value
        -   if value given is detli, recommendation is adj\_value = detect lim value / 2
        -   if value given is lmqnt,recommendation is adj\_value = quant lim value / sqrt(2)
    -   Have done this adjustment (object: data8\_q\_adj)
        -   If data source is IVL, value is not the detection limit itself but appears to be the raw machine value. I have preliminarily divided this value by 2 as well.

2.  Need to sum 6 PCB congeners within in a fish
    -   Have summed 6 PCB concentrations within a unique sample (sometimes represents 1 fish, other many fish (some Swedish data))
    -   Two datasets (if include qflagged samples or not)

3.  Mean total concentration by station and sample date
    -   Average the samples taken on the same date and station (w/ and w/o qflagged samples)

4.  Inspect data variation within a BHI region and data coverage for the mean total concentration by date and station. Need to work at basin scale instead?
    -   Data coverage poor in time and also in space without qflagged samples included.
    -   109 unique date x station (2009-2013) if include the qflagged samples

5.  average/median value of samples taken within a BHI region.

6.  gap-filling or data smoothing decisions
