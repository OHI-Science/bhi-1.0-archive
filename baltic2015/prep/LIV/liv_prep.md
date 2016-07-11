liv\_prep
================

-   [LIV subgoal data preparation](#liv-subgoal-data-preparation)
    -   [1. Background](#background)
    -   [2. Data](#data)
        -   [2.1 NUTS0 (country) and NUTS2 region Employment rate](#nuts0-country-and-nuts2-region-employment-rate)
        -   [2.2 Russian data](#russian-data)
        -   [2.3 Population density data](#population-density-data)
        -   [2.4 Aligning BHI regions with NUTS3 regions and population density](#aligning-bhi-regions-with-nuts3-regions-and-population-density)
    -   [3. Goal model](#goal-model)
    -   [4. Other](#other)
    -   [5. Regional data prep](#regional-data-prep)
        -   [5.1 Data organization](#data-organization)
        -   [5.2 Join datasets](#join-datasets)
        -   [5.3 Are BHI regions missing?](#are-bhi-regions-missing)
        -   [5.4 Calculate number of employed people and allocation to BHI regions](#calculate-number-of-employed-people-and-allocation-to-bhi-regions)
        -   [5.5 Data layer for layers](#data-layer-for-layers)
        -   [6. Country data prep](#country-data-prep)
        -   [6.1 Organize data](#organize-data)
        -   [6.2 Transform EU data in number of people employed](#transform-eu-data-in-number-of-people-employed)
        -   [6.3 Join EU and Russian data](#join-eu-and-russian-data)
        -   [6.3.1 Join EU and Russian data](#join-eu-and-russian-data-1)
        -   [6.3.3. Restrict to Final year 2014](#restrict-to-final-year-2014)
        -   [6.4 National data by BHI regions](#national-data-by-bhi-regions)
        -   [6.5 Prepare national data layer for layer](#prepare-national-data-layer-for-layer)
    -   [7. Status and Trend calculation exploration](#status-and-trend-calculation-exploration)
        -   [7.1 Assign data layer](#assign-data-layer)
        -   [7.2 Set parameters](#set-parameters)
        -   [7.3 Status calculation](#status-calculation)
        -   [7.3.4 Which BHI regions have no status](#which-bhi-regions-have-no-status)
        -   [7.3.1 Plot status](#plot-status)
        -   [7.4 Trend calculation](#trend-calculation)
    -   [8. Data issues and concerns](#data-issues-and-concerns)
        -   [8.1 Shapefile incorrect assignments](#shapefile-incorrect-assignments)
        -   [8.2 Finnish NUTS2 name discrepancies](#finnish-nuts2-name-discrepancies)
        -   [8.3 No Russian regional data](#no-russian-regional-data)
        -   [8.4 Employment data for EU transformed from percent to number of people using 2005 population data for all years](#employment-data-for-eu-transformed-from-percent-to-number-of-people-using-2005-population-data-for-all-years)
        -   [8.5 Short Danish timeseries](#short-danish-timeseries)

LIV subgoal data preparation
============================

1. Background
-------------

"This sub-goal describes livelihood quantity and quality for people living on the coast.
Ideally, this sub-goal would speak to the quality and quantity of marine jobs in an area. It would encompass all the marine sectors that supply jobs and wages to coastal communities, incorporating information on the sustainability of different sectors while also telling about the working conditions and job satisfaction. "

[Reference](http://ohi-science.org/goals/#livelihoods-and-economies)

2. Data
-------

#### 2.1 NUTS0 (country) and NUTS2 region Employment rate

Data downloaded on 31 March 2016 from Eurostat database [lfst\_r\_lfe2emprt](http://ec.europa.eu/eurostat/data/database?p_auth=BgwyNWIM&p_p_id=estatsearchportlet_WAR_estatsearchportlet&p_p_lifecycle=1&p_p_state=maximized&p_p_mode=view&_estatsearchportlet_WAR_estatsearchportlet_action=search&text=lfst_r_lfe2emprt)

Data information: Available for Country Level (NUTS0), NUTS1, and NUTS2; ages 15-64; All sexes; years 1999-2014

[Metadata link](http://ec.europa.eu/eurostat/cache/metadata/en/reg_lmk_esms.htm)
**Metadata overview**
The source for the regional labour market information down to NUTS level 2 is the EU Labour Force Survey (EU-LFS). This is a quarterly household sample survey conducted in all Member States of the EU and in EFTA and Candidate countries.

The EU-LFS survey follows the definitions and recommendations of the International Labour Organisation (ILO). To achieve further harmonisation, the Member States also adhere to common principles when formulating questionnaires. The LFS' target population is made up of all persons in private households aged 15 and over. For more information see the EU Labour Force Survey (lfsi\_esms, see paragraph 21.1.).

The EU-LFS is designed to give accurate quarterly information at national level as well as annual information at NUTS 2 regional level and the compilation of these figures is well specified in the regulation. Microdata including the NUTS 2 level codes are provided by all the participating countries with a good degree of geographical comparability, which allows the production and dissemination of a complete set of comparable indicators for this territorial level.

**Data flags** b break in time series
c confidential
d definition differs, see metadata
e estimated
f forecast
i see metadata (phased out)
n not significant
p provisional
r revised
s Eurostat estimate (phased out)
u low reliability
z not applicable

### 2.2 Russian data

#### 2.2.1 Regional data

HAVE NOT OBTAINED

#### 2.2.2 Country level data

### 2.3 Population density data

#### 2.3.1 Fine scale population data

Population density data obtained from the [HYDE database](http://themasites.pbl.nl/tridion/en/themasites/hyde/download/index-2.html)

Year of data = 2005. Data were a 5' resolution. Erik Smedberg with the Baltic Sea Center re-gridded to a 10 x 10 km grid.

Population density within a 25km buffer from the coast will be used.

References: Klein Goldewijk, K. , A. Beusen, M. de Vos and G. van Drecht (2011). The HYDE 3.1 spatially explicit database of human induced land use change over the past 12,000 years, Global Ecology and Biogeography20(1): 73-86. DOI: 10.1111/j.1466-8238.2010.00587.x.

Klein Goldewijk, K. , A. Beusen, and P. Janssen (2010). Long term dynamic modeling of global population and built-up area in a spatially explicit way, HYDE 3 .1. The Holocene20(4):565-573. <http://dx.doi.org/10.1177/0959683609356587>

#### 2.3.2 National

**EU countries**
Downloaded on March 31 2016 from Eurostat database [demo\_gind](http://ec.europa.eu/eurostat/data/database?p_auth=whAQQAX7&p_p_id=estatsearchportlet_WAR_estatsearchportlet&p_p_lifecycle=1&p_p_state=maximized&p_p_mode=view&_estatsearchportlet_WAR_estatsearchportlet_action=search&text=demo_gind)

Variables:
1990-2015 Population on Jan1

[Metadata Link](http://ec.europa.eu/eurostat/cache/metadata/en/demo_gind_esms.htm)

*Population on 1 January:*
Eurostat aims at collecting from the EU-28's Member States' data on population on 31st December, which is further published as 1 January of the following year. The recommended definition is the 'usual resident population' and represents the number of inhabitants of a given area on 31st December . However, the population transmitted by the countries can also be either based on data from the most recent census adjusted by the components of population change produced since the last census, either based on population registers.

**Russia**
Downloaded on 10 June 2016 from Eurostat database: [naida\_10\_pe](http://ec.europa.eu/eurostat/web/products-datasets/-/naida_10_pe)
population (thousands of people)
employment (thousands of people) *need to exclude this*

### 2.4 Aligning BHI regions with NUTS3 regions and population density

UPDATE with Marc's methods or link

3. Goal model
-------------

Xliv = (Employment\_Region\_c/Employment\_Region\_r)/(Employment\_Country\_c/Employment\_Country\_r)
\* c = current year, r=reference year
\* reference point is a moving window (single year value)
\* Region is the BHI region - number of employed persons associated in the BHI region
\* Each BHI region is composed by one or more NUTS2 regions.
 \* NUTS2 employment percentage multipled by the by population in the 25km inland buffer associated with a BHI region. Sum across all associated with a BHI region to get the total employed people in the BHI region. \* For Country data, need to also get population size so can have total number of people employed, not percent employed

4. Other
--------

``` r
## Libraries
library(readr)
```

    ## Warning: package 'readr' was built under R version 3.2.4

``` r
library(dplyr)
```

    ## Warning: package 'dplyr' was built under R version 3.2.5

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
```

    ## Warning: package 'tidyr' was built under R version 3.2.5

``` r
library(ggplot2)
```

    ## Warning: package 'ggplot2' was built under R version 3.2.4

``` r
library(RMySQL)
```

    ## Warning: package 'RMySQL' was built under R version 3.2.5

    ## Loading required package: DBI

    ## Warning: package 'DBI' was built under R version 3.2.5

``` r
library(stringr)
library(tools)
library(rprojroot) # install.packages('rprojroot')
```

    ## Warning: package 'rprojroot' was built under R version 3.2.4

``` r
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


dir_liv    = file.path(dir_prep, 'LIV')

## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_liv, 'liv_prep.rmd')
```

5. Regional data prep
---------------------

### 5.1 Data organization

#### 5.1.1 read in data

``` r
## read in
regional_employ = read.csv(file.path(dir_liv, 'liv_data_database/nuts2_employ.csv'), stringsAsFactors = FALSE)

dim(regional_employ) #[1] 5344    9
```

    ## [1] 5344    9

``` r
str(regional_employ)
```

    ## 'data.frame':    5344 obs. of  9 variables:
    ##  $ TIME              : int  1999 1999 1999 1999 1999 1999 1999 1999 1999 1999 ...
    ##  $ TIME_LABEL        : int  1999 1999 1999 1999 1999 1999 1999 1999 1999 1999 ...
    ##  $ GEO               : chr  "BE10" "BE21" "BE22" "BE23" ...
    ##  $ GEO_LABEL         : chr  "Région de Bruxelles-Capitale / Brussels Hoofdstedelijk Gewest" "Prov. Antwerpen" "Prov. Limburg (BE)" "Prov. Oost-Vlaanderen" ...
    ##  $ SEX               : chr  "Total" "Total" "Total" "Total" ...
    ##  $ AGE               : chr  "From 15 to 64 years" "From 15 to 64 years" "From 15 to 64 years" "From 15 to 64 years" ...
    ##  $ UNIT              : chr  "Percentage" "Percentage" "Percentage" "Percentage" ...
    ##  $ Value             : num  53.6 59.9 57.9 62.4 65.9 63.8 60 50.5 56.6 60.3 ...
    ##  $ Flag.and.Footnotes: chr  "b" "b" "b" "b" ...

``` r
nuts2_pop_area = read.csv(file.path(dir_liv, 'liv_data_database/nuts2_pop_area.csv'), stringsAsFactors = FALSE)
dim(nuts2_pop_area)
```

    ## [1] 72 13

``` r
str(nuts2_pop_area)
```

    ## 'data.frame':    72 obs. of  13 variables:
    ##  $ BHI_ID                          : int  1 1 2 2 2 2 3 3 3 4 ...
    ##  $ NUTS_ID                         : chr  "SE22" "SE23" "DK01" "DK02" ...
    ##  $ PopTot                          : int  116851 702394 266145 355373 175718 270701 413955 962944 605097 226701 ...
    ##  $ PopUrb                          : int  90965 657250 205041 275556 119983 225142 355931 856951 555111 150569 ...
    ##  $ PopRur                          : int  25886 45142 61102 79811 55739 45557 58027 105995 49991 76131 ...
    ##  $ PopTot_density_in_buffer_per_km2: num  10.04 2.42 18.31 10.96 4.3 ...
    ##  $ PopUrb_density_in_buffer_per_km2: num  7.82 2.26 14.1 8.5 2.94 ...
    ##  $ PopRur_density_in_buffer_per_km2: num  2.225 0.155 4.203 2.461 1.364 ...
    ##  $ CNTR_CODE                       : chr  "SE" "SE" "DK" "DK" ...
    ##  $ rgn_nam                         : chr  "Sweden" "Sweden" "Denmark" "Denmark" ...
    ##  $ Subbasin                        : chr  "Kattegat" "Kattegat" "Kattegat" "Kattegat" ...
    ##  $ HELCOM_ID                       : chr  "SEA-001" "SEA-001" "SEA-001" "SEA-001" ...
    ##  $ NUTS3_area_in_BHI_buffer_km2    : num  11636 290554 14538 32425 40858 ...

#### 5.1.2 Clean Regional employment data object

``` r
regional_employ1 = regional_employ %>%
                  select(-TIME_LABEL,-SEX,-AGE) %>%
                  dplyr::rename(year = TIME, nuts2 = GEO, nuts2_name = GEO_LABEL,
                                unit=UNIT, value = Value, flag_notes = Flag.and.Footnotes)%>%
                  mutate(nuts2 = as.character(nuts2),
                         nuts2_name = as.character(nuts2_name),
                         unit = as.character(unit),
                         flag_notes = ifelse(flag_notes== "b", "break in timeseries",
                                      ifelse(flag_notes== "u", "low reliability",
                                      ifelse(flag_notes== "bu", "break in timeseries and low reliability",""))))
                  

str(regional_employ1)
```

    ## 'data.frame':    5344 obs. of  6 variables:
    ##  $ year      : int  1999 1999 1999 1999 1999 1999 1999 1999 1999 1999 ...
    ##  $ nuts2     : chr  "BE10" "BE21" "BE22" "BE23" ...
    ##  $ nuts2_name: chr  "Région de Bruxelles-Capitale / Brussels Hoofdstedelijk Gewest" "Prov. Antwerpen" "Prov. Limburg (BE)" "Prov. Oost-Vlaanderen" ...
    ##  $ unit      : chr  "Percentage" "Percentage" "Percentage" "Percentage" ...
    ##  $ value     : num  53.6 59.9 57.9 62.4 65.9 63.8 60 50.5 56.6 60.3 ...
    ##  $ flag_notes: chr  "break in timeseries" "break in timeseries" "break in timeseries" "break in timeseries" ...

``` r
## check dataflags
regional_employ1 %>% select(flag_notes)%>% distinct()
```

    ##                                flag_notes
    ## 1                     break in timeseries
    ## 2                                        
    ## 3 break in timeseries and low reliability
    ## 4                         low reliability

``` r
regional_employ1 %>% filter(flag_notes =="low reliability" ) #not Baltic country
```

    ##   year nuts2 nuts2_name       unit value      flag_notes
    ## 1 2004  FR83      Corse Percentage  51.1 low reliability

``` r
regional_employ1 %>% filter(flag_notes =="break in timeseries and low reliability" ) #not Baltic country
```

    ##   year nuts2 nuts2_name       unit value
    ## 1 2003  FR83      Corse Percentage  50.7
    ##                                flag_notes
    ## 1 break in timeseries and low reliability

``` r
regional_employ1 %>% filter(flag_notes =="break in timeseries") ## this is not such a concern
```

    ##     year  nuts2
    ## 1   1999   BE10
    ## 2   1999   BE21
    ## 3   1999   BE22
    ## 4   1999   BE23
    ## 5   1999   BE24
    ## 6   1999   BE25
    ## 7   1999   BE31
    ## 8   1999   BE32
    ## 9   1999   BE33
    ## 10  1999   BE34
    ## 11  1999   BE35
    ## 12  1999   SK01
    ## 13  1999   SK02
    ## 14  1999   SK03
    ## 15  1999   SK04
    ## 16  1999   UKC1
    ## 17  1999   UKC2
    ## 18  1999   UKD1
    ## 19  1999   UKD3
    ## 20  1999   UKD4
    ## 21  1999   UKE1
    ## 22  1999   UKE2
    ## 23  1999   UKE3
    ## 24  1999   UKE4
    ## 25  1999   UKF1
    ## 26  1999   UKF2
    ## 27  1999   UKF3
    ## 28  1999   UKG1
    ## 29  1999   UKG2
    ## 30  1999   UKG3
    ## 31  1999   UKH1
    ## 32  1999   UKH2
    ## 33  1999   UKH3
    ## 34  1999   UKI1
    ## 35  1999   UKI2
    ## 36  1999   UKJ1
    ## 37  1999   UKJ2
    ## 38  1999   UKJ3
    ## 39  1999   UKJ4
    ## 40  1999   UKK1
    ## 41  1999   UKK2
    ## 42  1999   UKK3
    ## 43  1999   UKK4
    ## 44  1999   UKL1
    ## 45  1999   UKL2
    ## 46  1999   UKM2
    ## 47  1999   UKM3
    ## 48  1999   UKN0
    ## 49  2000   EE00
    ## 50  2000   PL11
    ## 51  2000   PL12
    ## 52  2000   PL21
    ## 53  2000   PL22
    ## 54  2000   PL31
    ## 55  2000   PL32
    ## 56  2000   PL33
    ## 57  2000   PL34
    ## 58  2000   PL41
    ## 59  2000   PL42
    ## 60  2000   PL43
    ## 61  2000   PL51
    ## 62  2000   PL52
    ## 63  2000   PL61
    ## 64  2000   PL62
    ## 65  2000   PL63
    ## 66  2000   FI19
    ## 67  2000   FI20
    ## 68  2001   BE10
    ## 69  2001   BE21
    ## 70  2001   BE22
    ## 71  2001   BE23
    ## 72  2001   BE24
    ## 73  2001   BE25
    ## 74  2001   BE31
    ## 75  2001   BE32
    ## 76  2001   BE33
    ## 77  2001   BE34
    ## 78  2001   BE35
    ## 79  2001   BG41
    ## 80  2001   EL11
    ## 81  2001   EL12
    ## 82  2001   EL13
    ## 83  2001   EL14
    ## 84  2001   EL21
    ## 85  2001   EL22
    ## 86  2001   EL23
    ## 87  2001   EL24
    ## 88  2001   EL25
    ## 89  2001   EL30
    ## 90  2001   EL41
    ## 91  2001   EL42
    ## 92  2001   EL43
    ## 93  2001   ES11
    ## 94  2001   ES12
    ## 95  2001   ES13
    ## 96  2001   ES21
    ## 97  2001   ES22
    ## 98  2001   ES23
    ## 99  2001   ES24
    ## 100 2001   ES30
    ## 101 2001   ES41
    ## 102 2001   ES42
    ## 103 2001   ES43
    ## 104 2001   ES51
    ## 105 2001   ES52
    ## 106 2001   ES53
    ## 107 2001   ES61
    ## 108 2001   ES62
    ## 109 2001   ES63
    ## 110 2001   ES64
    ## 111 2001   ES70
    ## 112 2001   HU10
    ## 113 2001   HU21
    ## 114 2001   HU22
    ## 115 2001   HU23
    ## 116 2001   HU31
    ## 117 2001   HU32
    ## 118 2001   HU33
    ## 119 2001   PL11
    ## 120 2001   PL12
    ## 121 2001   PL21
    ## 122 2001   PL22
    ## 123 2001   PL31
    ## 124 2001   PL32
    ## 125 2001   PL33
    ## 126 2001   PL34
    ## 127 2001   PL41
    ## 128 2001   PL42
    ## 129 2001   PL43
    ## 130 2001   PL51
    ## 131 2001   PL52
    ## 132 2001   PL61
    ## 133 2001   PL62
    ## 134 2001   PL63
    ## 135 2001   SE11
    ## 136 2001   SE12
    ## 137 2001   SE21
    ## 138 2001   SE22
    ## 139 2001   SE23
    ## 140 2001   SE31
    ## 141 2001   SE32
    ## 142 2001   SE33
    ## 143 2002   LV00
    ## 144 2002   LT00
    ## 145 2002   PT11
    ## 146 2002   PT15
    ## 147 2002   PT16
    ## 148 2002   PT17
    ## 149 2002   PT18
    ## 150 2002   PT20
    ## 151 2002   PT30
    ## 152 2002   RO11
    ## 153 2002   RO12
    ## 154 2002   RO21
    ## 155 2002   RO22
    ## 156 2002   RO31
    ## 157 2002   RO32
    ## 158 2002   RO41
    ## 159 2002   RO42
    ## 160 2003   BG31
    ## 161 2003   BG32
    ## 162 2003   BG33
    ## 163 2003   BG34
    ## 164 2003   BG41
    ## 165 2003   BG42
    ## 166 2003   FR10
    ## 167 2003   FR21
    ## 168 2003   FR22
    ## 169 2003   FR23
    ## 170 2003   FR24
    ## 171 2003   FR25
    ## 172 2003   FR26
    ## 173 2003   FR30
    ## 174 2003   FR41
    ## 175 2003   FR42
    ## 176 2003   FR43
    ## 177 2003   FR51
    ## 178 2003   FR52
    ## 179 2003   FR53
    ## 180 2003   FR61
    ## 181 2003   FR62
    ## 182 2003   FR63
    ## 183 2003   FR71
    ## 184 2003   FR72
    ## 185 2003   FR81
    ## 186 2003   FR82
    ## 187 2003   FR91
    ## 188 2003   FR92
    ## 189 2003   FR93
    ## 190 2003   FR94
    ## 191 2003   LU00
    ## 192 2003   PL11
    ## 193 2003   PL12
    ## 194 2003   PL21
    ## 195 2003   PL22
    ## 196 2003   PL31
    ## 197 2003   PL32
    ## 198 2003   PL33
    ## 199 2003   PL34
    ## 200 2003   PL41
    ## 201 2003   PL42
    ## 202 2003   PL43
    ## 203 2003   PL51
    ## 204 2003   PL52
    ## 205 2003   PL61
    ## 206 2003   PL62
    ## 207 2003   PL63
    ## 208 2003   RO11
    ## 209 2003   RO12
    ## 210 2003   RO21
    ## 211 2003   RO22
    ## 212 2003   RO31
    ## 213 2003   RO32
    ## 214 2003   RO41
    ## 215 2003   RO42
    ## 216 2003   SK01
    ## 217 2003   SK02
    ## 218 2003   SK03
    ## 219 2003   SK04
    ## 220 2003   IS00
    ## 221 2004   EL11
    ## 222 2004   EL12
    ## 223 2004   EL13
    ## 224 2004   EL14
    ## 225 2004   EL21
    ## 226 2004   EL22
    ## 227 2004   EL23
    ## 228 2004   EL24
    ## 229 2004   EL25
    ## 230 2004   EL30
    ## 231 2004   EL41
    ## 232 2004   EL42
    ## 233 2004   EL43
    ## 234 2004   ITC1
    ## 235 2004   ITC2
    ## 236 2004   ITC3
    ## 237 2004   ITC4
    ## 238 2004   ITH1
    ## 239 2004   ITH2
    ## 240 2004   ITH3
    ## 241 2004   ITH4
    ## 242 2004   ITI1
    ## 243 2004   ITI2
    ## 244 2004   ITI4
    ## 245 2004   ITF1
    ## 246 2004   ITF2
    ## 247 2004   ITF3
    ## 248 2004   ITF4
    ## 249 2004   ITF5
    ## 250 2004   ITF6
    ## 251 2004   ITG1
    ## 252 2004   ITG2
    ## 253 2004   MT00
    ## 254 2004   AT11
    ## 255 2004   AT12
    ## 256 2004   AT13
    ## 257 2004   AT21
    ## 258 2004   AT22
    ## 259 2004   AT31
    ## 260 2004   AT32
    ## 261 2004   AT33
    ## 262 2004   AT34
    ## 263 2004   PL11
    ## 264 2004   PL12
    ## 265 2004   PL21
    ## 266 2004   PL22
    ## 267 2004   PL31
    ## 268 2004   PL32
    ## 269 2004   PL33
    ## 270 2004   PL34
    ## 271 2004   PL41
    ## 272 2004   PL42
    ## 273 2004   PL43
    ## 274 2004   PL51
    ## 275 2004   PL52
    ## 276 2004   PL61
    ## 277 2004   PL62
    ## 278 2004   PL63
    ## 279 2004   UKC1
    ## 280 2004   UKC2
    ## 281 2004   UKD1
    ## 282 2004   UKD3
    ## 283 2004   UKD4
    ## 284 2004   UKE1
    ## 285 2004   UKE2
    ## 286 2004   UKE3
    ## 287 2004   UKE4
    ## 288 2004   UKF1
    ## 289 2004   UKF2
    ## 290 2004   UKF3
    ## 291 2004   UKG1
    ## 292 2004   UKG2
    ## 293 2004   UKG3
    ## 294 2004   UKH1
    ## 295 2004   UKH2
    ## 296 2004   UKH3
    ## 297 2004   UKI1
    ## 298 2004   UKI2
    ## 299 2004   UKJ1
    ## 300 2004   UKJ2
    ## 301 2004   UKJ3
    ## 302 2004   UKJ4
    ## 303 2004   UKK1
    ## 304 2004   UKK2
    ## 305 2004   UKK3
    ## 306 2004   UKK4
    ## 307 2004   UKL1
    ## 308 2004   UKL2
    ## 309 2004   UKM2
    ## 310 2004   UKM3
    ## 311 2004   UKM5
    ## 312 2004   UKM6
    ## 313 2004   UKN0
    ## 314 2005   BE10
    ## 315 2005   BE21
    ## 316 2005   BE22
    ## 317 2005   BE23
    ## 318 2005   BE24
    ## 319 2005   BE25
    ## 320 2005   BE31
    ## 321 2005   BE32
    ## 322 2005   BE33
    ## 323 2005   BE34
    ## 324 2005   BE35
    ## 325 2005   BG31
    ## 326 2005   BG32
    ## 327 2005   BG33
    ## 328 2005   BG34
    ## 329 2005   BG41
    ## 330 2005   BG42
    ## 331 2005   CZ01
    ## 332 2005   CZ02
    ## 333 2005   CZ03
    ## 334 2005   CZ04
    ## 335 2005   CZ05
    ## 336 2005   CZ06
    ## 337 2005   CZ07
    ## 338 2005   CZ08
    ## 339 2005   DE11
    ## 340 2005   DE12
    ## 341 2005   DE13
    ## 342 2005   DE14
    ## 343 2005   DE21
    ## 344 2005   DE22
    ## 345 2005   DE23
    ## 346 2005   DE24
    ## 347 2005   DE25
    ## 348 2005   DE26
    ## 349 2005   DE27
    ## 350 2005   DE30
    ## 351 2005   DE40
    ## 352 2005   DE50
    ## 353 2005   DE60
    ## 354 2005   DE71
    ## 355 2005   DE72
    ## 356 2005   DE73
    ## 357 2005   DE80
    ## 358 2005   DE91
    ## 359 2005   DE92
    ## 360 2005   DE93
    ## 361 2005   DE94
    ## 362 2005   DEA1
    ## 363 2005   DEA2
    ## 364 2005   DEA3
    ## 365 2005   DEA4
    ## 366 2005   DEA5
    ## 367 2005   DEB1
    ## 368 2005   DEB2
    ## 369 2005   DEB3
    ## 370 2005 dec-00
    ## 371 2005   DED2
    ## 372 2005   DED4
    ## 373 2005   DED5
    ## 374 2005   DEE0
    ## 375 2005   DEF0
    ## 376 2005   DEG0
    ## 377 2005   EE00
    ## 378 2005   IE01
    ## 379 2005   IE02
    ## 380 2005   EL11
    ## 381 2005   EL12
    ## 382 2005   EL13
    ## 383 2005   EL14
    ## 384 2005   EL21
    ## 385 2005   EL22
    ## 386 2005   EL23
    ## 387 2005   EL24
    ## 388 2005   EL25
    ## 389 2005   EL30
    ## 390 2005   EL41
    ## 391 2005   EL42
    ## 392 2005   EL43
    ## 393 2005   ES11
    ## 394 2005   ES12
    ## 395 2005   ES13
    ## 396 2005   ES21
    ## 397 2005   ES22
    ## 398 2005   ES23
    ## 399 2005   ES24
    ## 400 2005   ES30
    ## 401 2005   ES41
    ## 402 2005   ES42
    ## 403 2005   ES43
    ## 404 2005   ES51
    ## 405 2005   ES52
    ## 406 2005   ES53
    ## 407 2005   ES61
    ## 408 2005   ES62
    ## 409 2005   ES63
    ## 410 2005   ES64
    ## 411 2005   ES70
    ## 412 2005   FR10
    ## 413 2005   FR21
    ## 414 2005   FR22
    ## 415 2005   FR23
    ## 416 2005   FR24
    ## 417 2005   FR25
    ## 418 2005   FR26
    ## 419 2005   FR30
    ## 420 2005   FR41
    ## 421 2005   FR42
    ## 422 2005   FR43
    ## 423 2005   FR51
    ## 424 2005   FR52
    ## 425 2005   FR53
    ## 426 2005   FR61
    ## 427 2005   FR62
    ## 428 2005   FR63
    ## 429 2005   FR71
    ## 430 2005   FR72
    ## 431 2005   FR81
    ## 432 2005   FR82
    ## 433 2005   FR83
    ## 434 2005   FR91
    ## 435 2005   FR92
    ## 436 2005   FR93
    ## 437 2005   FR94
    ## 438 2005   ITC1
    ## 439 2005   ITC2
    ## 440 2005   ITC3
    ## 441 2005   ITC4
    ## 442 2005   ITH1
    ## 443 2005   ITH2
    ## 444 2005   ITH3
    ## 445 2005   ITH4
    ## 446 2005   ITH5
    ## 447 2005   ITI1
    ## 448 2005   ITI2
    ## 449 2005   ITI3
    ## 450 2005   ITI4
    ## 451 2005   ITF1
    ## 452 2005   ITF2
    ## 453 2005   ITF3
    ## 454 2005   ITF4
    ## 455 2005   ITF5
    ## 456 2005   ITF6
    ## 457 2005   ITG1
    ## 458 2005   ITG2
    ## 459 2005   CY00
    ## 460 2005   LV00
    ## 461 2005   LT00
    ## 462 2005   LU00
    ## 463 2005   HU10
    ## 464 2005   HU21
    ## 465 2005   HU22
    ## 466 2005   HU23
    ## 467 2005   HU31
    ## 468 2005   HU32
    ## 469 2005   HU33
    ## 470 2005   MT00
    ## 471 2005   NL11
    ## 472 2005   NL12
    ## 473 2005   NL13
    ## 474 2005   NL21
    ## 475 2005   NL22
    ## 476 2005   NL23
    ## 477 2005   NL31
    ## 478 2005   NL32
    ## 479 2005   NL33
    ## 480 2005   NL34
    ## 481 2005   NL41
    ## 482 2005   NL42
    ## 483 2005   AT11
    ## 484 2005   AT12
    ## 485 2005   AT13
    ## 486 2005   AT21
    ## 487 2005   AT22
    ## 488 2005   AT31
    ## 489 2005   AT32
    ## 490 2005   AT33
    ## 491 2005   AT34
    ## 492 2005   PL11
    ## 493 2005   PL12
    ## 494 2005   PL21
    ## 495 2005   PL22
    ## 496 2005   PL31
    ## 497 2005   PL32
    ## 498 2005   PL33
    ## 499 2005   PL34
    ## 500 2005   PL41
    ## 501 2005   PL42
    ## 502 2005   PL43
    ## 503 2005   PL51
    ## 504 2005   PL52
    ## 505 2005   PL61
    ## 506 2005   PL62
    ## 507 2005   PL63
    ## 508 2005   PT11
    ## 509 2005   PT15
    ## 510 2005   PT16
    ## 511 2005   PT17
    ## 512 2005   PT18
    ## 513 2005   PT20
    ## 514 2005   PT30
    ## 515 2005   RO11
    ## 516 2005   RO12
    ## 517 2005   RO21
    ## 518 2005   RO22
    ## 519 2005   RO31
    ## 520 2005   RO32
    ## 521 2005   RO41
    ## 522 2005   RO42
    ## 523 2005   SI01
    ## 524 2005   SI02
    ## 525 2005   SK01
    ## 526 2005   SK02
    ## 527 2005   SK03
    ## 528 2005   SK04
    ## 529 2005   FI19
    ## 530 2005   FI1B
    ## 531 2005   FI1C
    ## 532 2005   FI1D
    ## 533 2005   FI20
    ## 534 2005   SE11
    ## 535 2005   SE12
    ## 536 2005   SE21
    ## 537 2005   SE22
    ## 538 2005   SE23
    ## 539 2005   SE31
    ## 540 2005   SE32
    ## 541 2005   SE33
    ## 542 2005   UKC1
    ## 543 2005   UKC2
    ## 544 2005   UKD1
    ## 545 2005   UKD3
    ## 546 2005   UKD4
    ## 547 2005   UKD6
    ## 548 2005   UKD7
    ## 549 2005   UKE1
    ## 550 2005   UKE2
    ## 551 2005   UKE3
    ## 552 2005   UKE4
    ## 553 2005   UKF1
    ## 554 2005   UKF2
    ## 555 2005   UKF3
    ## 556 2005   UKG1
    ## 557 2005   UKG2
    ## 558 2005   UKG3
    ## 559 2005   UKH1
    ## 560 2005   UKH2
    ## 561 2005   UKH3
    ## 562 2005   UKI1
    ## 563 2005   UKI2
    ## 564 2005   UKJ1
    ## 565 2005   UKJ2
    ## 566 2005   UKJ3
    ## 567 2005   UKJ4
    ## 568 2005   UKK1
    ## 569 2005   UKK2
    ## 570 2005   UKK3
    ## 571 2005   UKK4
    ## 572 2005   UKL1
    ## 573 2005   UKL2
    ## 574 2005   UKM2
    ## 575 2005   UKM3
    ## 576 2005   UKM5
    ## 577 2005   UKM6
    ## 578 2005   UKN0
    ## 579 2005   IS00
    ## 580 2005   NO01
    ## 581 2005   NO02
    ## 582 2005   NO03
    ## 583 2005   NO04
    ## 584 2005   NO05
    ## 585 2005   NO06
    ## 586 2005   NO07
    ## 587 2005   CH01
    ## 588 2005   CH02
    ## 589 2005   CH03
    ## 590 2005   CH04
    ## 591 2005   CH05
    ## 592 2005   CH06
    ## 593 2005   CH07
    ## 594 2006   NO01
    ## 595 2006   NO02
    ## 596 2006   NO03
    ## 597 2006   NO04
    ## 598 2006   NO05
    ## 599 2006   NO06
    ## 600 2006   NO07
    ## 601 2007   IE01
    ## 602 2007   IE02
    ## 603 2007   LU00
    ## 604 2007   AT11
    ## 605 2007   AT12
    ## 606 2007   AT13
    ## 607 2007   AT21
    ## 608 2007   AT22
    ## 609 2007   AT31
    ## 610 2007   AT32
    ## 611 2007   AT33
    ## 612 2007   AT34
    ## 613 2007   UKC1
    ## 614 2007   UKC2
    ## 615 2007   UKD1
    ## 616 2007   UKD3
    ## 617 2007   UKD4
    ## 618 2007   UKD6
    ## 619 2007   UKD7
    ## 620 2007   UKE1
    ## 621 2007   UKE2
    ## 622 2007   UKE3
    ## 623 2007   UKE4
    ## 624 2007   UKF1
    ## 625 2007   UKF2
    ## 626 2007   UKF3
    ## 627 2007   UKG1
    ## 628 2007   UKG2
    ## 629 2007   UKG3
    ## 630 2007   UKH1
    ## 631 2007   UKH2
    ## 632 2007   UKH3
    ## 633 2007   UKI1
    ## 634 2007   UKI2
    ## 635 2007   UKJ1
    ## 636 2007   UKJ2
    ## 637 2007   UKJ3
    ## 638 2007   UKJ4
    ## 639 2007   UKK1
    ## 640 2007   UKK2
    ## 641 2007   UKK3
    ## 642 2007   UKK4
    ## 643 2007   UKL1
    ## 644 2007   UKL2
    ## 645 2007   UKM2
    ## 646 2007   UKM3
    ## 647 2007   UKM5
    ## 648 2007   UKM6
    ## 649 2007   UKN0
    ## 650 2008   BG31
    ## 651 2008   BG32
    ## 652 2008   BG33
    ## 653 2008   BG34
    ## 654 2008   BG41
    ## 655 2008   BG42
    ## 656 2008   FI19
    ## 657 2008   FI1B
    ## 658 2008   FI1C
    ## 659 2008   FI1D
    ## 660 2008   FI20
    ## 661 2008   UKC1
    ## 662 2008   UKC2
    ## 663 2008   UKD1
    ## 664 2008   UKD3
    ## 665 2008   UKD4
    ## 666 2008   UKD6
    ## 667 2008   UKD7
    ## 668 2008   UKE1
    ## 669 2008   UKE2
    ## 670 2008   UKE3
    ## 671 2008   UKE4
    ## 672 2008   UKF1
    ## 673 2008   UKF2
    ## 674 2008   UKF3
    ## 675 2008   UKG1
    ## 676 2008   UKG2
    ## 677 2008   UKG3
    ## 678 2008   UKH1
    ## 679 2008   UKH2
    ## 680 2008   UKH3
    ## 681 2008   UKI1
    ## 682 2008   UKI2
    ## 683 2008   UKJ1
    ## 684 2008   UKJ2
    ## 685 2008   UKJ3
    ## 686 2008   UKJ4
    ## 687 2008   UKK1
    ## 688 2008   UKK2
    ## 689 2008   UKK3
    ## 690 2008   UKK4
    ## 691 2008   UKL1
    ## 692 2008   UKL2
    ## 693 2008   UKM2
    ## 694 2008   UKM3
    ## 695 2008   UKM5
    ## 696 2008   UKM6
    ## 697 2008   UKN0
    ## 698 2009   IE01
    ## 699 2009   IE02
    ## 700 2009   EL11
    ## 701 2009   EL12
    ## 702 2009   EL13
    ## 703 2009   EL14
    ## 704 2009   EL21
    ## 705 2009   EL22
    ## 706 2009   EL23
    ## 707 2009   EL24
    ## 708 2009   EL25
    ## 709 2009   EL30
    ## 710 2009   EL41
    ## 711 2009   EL42
    ## 712 2009   EL43
    ## 713 2009   CY00
    ## 714 2009   LU00
    ## 715 2010   BG31
    ## 716 2010   BG32
    ## 717 2010   BG33
    ## 718 2010   BG34
    ## 719 2010   BG41
    ## 720 2010   BG42
    ## 721 2010   DE11
    ## 722 2010   DE12
    ## 723 2010   DE13
    ## 724 2010   DE14
    ## 725 2010   DE21
    ## 726 2010   DE22
    ## 727 2010   DE23
    ## 728 2010   DE24
    ## 729 2010   DE25
    ## 730 2010   DE26
    ## 731 2010   DE27
    ## 732 2010   DE30
    ## 733 2010   DE40
    ## 734 2010   DE50
    ## 735 2010   DE60
    ## 736 2010   DE71
    ## 737 2010   DE72
    ## 738 2010   DE73
    ## 739 2010   DE80
    ## 740 2010   DE91
    ## 741 2010   DE92
    ## 742 2010   DE93
    ## 743 2010   DE94
    ## 744 2010   DEA1
    ## 745 2010   DEA2
    ## 746 2010   DEA3
    ## 747 2010   DEA4
    ## 748 2010   DEA5
    ## 749 2010   DEB1
    ## 750 2010   DEB2
    ## 751 2010   DEB3
    ## 752 2010 dec-00
    ## 753 2010   DED2
    ## 754 2010   DED4
    ## 755 2010   DED5
    ## 756 2010   DEE0
    ## 757 2010   DEF0
    ## 758 2010   DEG0
    ## 759 2010   NL11
    ## 760 2010   NL12
    ## 761 2010   NL13
    ## 762 2010   NL21
    ## 763 2010   NL22
    ## 764 2010   NL23
    ## 765 2010   NL31
    ## 766 2010   NL32
    ## 767 2010   NL33
    ## 768 2010   NL34
    ## 769 2010   NL41
    ## 770 2010   NL42
    ## 771 2010   PL11
    ## 772 2010   PL12
    ## 773 2010   PL21
    ## 774 2010   PL22
    ## 775 2010   PL31
    ## 776 2010   PL32
    ## 777 2010   PL33
    ## 778 2010   PL34
    ## 779 2010   PL41
    ## 780 2010   PL42
    ## 781 2010   PL43
    ## 782 2010   PL51
    ## 783 2010   PL52
    ## 784 2010   PL61
    ## 785 2010   PL62
    ## 786 2010   PL63
    ## 787 2010   RO11
    ## 788 2010   RO12
    ## 789 2010   RO21
    ## 790 2010   RO22
    ## 791 2010   RO31
    ## 792 2010   RO32
    ## 793 2010   RO41
    ## 794 2010   RO42
    ## 795 2011   BE10
    ## 796 2011   BE21
    ## 797 2011   BE22
    ## 798 2011   BE23
    ## 799 2011   BE24
    ## 800 2011   BE25
    ## 801 2011   BE31
    ## 802 2011   BE32
    ## 803 2011   BE33
    ## 804 2011   BE34
    ## 805 2011   BE35
    ## 806 2011   BG31
    ## 807 2011   BG32
    ## 808 2011   BG33
    ## 809 2011   BG34
    ## 810 2011   BG41
    ## 811 2011   BG42
    ## 812 2011   CZ01
    ## 813 2011   CZ02
    ## 814 2011   CZ03
    ## 815 2011   CZ04
    ## 816 2011   CZ05
    ## 817 2011   CZ06
    ## 818 2011   CZ07
    ## 819 2011   CZ08
    ## 820 2011   DE11
    ## 821 2011   DE12
    ## 822 2011   DE13
    ## 823 2011   DE14
    ## 824 2011   DE21
    ## 825 2011   DE22
    ## 826 2011   DE23
    ## 827 2011   DE24
    ## 828 2011   DE25
    ## 829 2011   DE26
    ## 830 2011   DE27
    ## 831 2011   DE30
    ## 832 2011   DE40
    ## 833 2011   DE50
    ## 834 2011   DE60
    ## 835 2011   DE71
    ## 836 2011   DE72
    ## 837 2011   DE73
    ## 838 2011   DE80
    ## 839 2011   DE91
    ## 840 2011   DE92
    ## 841 2011   DE93
    ## 842 2011   DE94
    ## 843 2011   DEA1
    ## 844 2011   DEA2
    ## 845 2011   DEA3
    ## 846 2011   DEA4
    ## 847 2011   DEA5
    ## 848 2011   DEB1
    ## 849 2011   DEB2
    ## 850 2011   DEB3
    ## 851 2011 dec-00
    ## 852 2011   DED2
    ## 853 2011   DED4
    ## 854 2011   DED5
    ## 855 2011   DEE0
    ## 856 2011   DEF0
    ## 857 2011   DEG0
    ## 858 2011   NL11
    ## 859 2011   NL12
    ## 860 2011   NL13
    ## 861 2011   NL21
    ## 862 2011   NL22
    ## 863 2011   NL23
    ## 864 2011   NL31
    ## 865 2011   NL32
    ## 866 2011   NL33
    ## 867 2011   NL34
    ## 868 2011   NL41
    ## 869 2011   NL42
    ## 870 2011   PT11
    ## 871 2011   PT15
    ## 872 2011   PT16
    ## 873 2011   PT17
    ## 874 2011   PT18
    ## 875 2011   PT20
    ## 876 2011   PT30
    ## 877 2011   SK01
    ## 878 2011   SK02
    ## 879 2011   SK03
    ## 880 2011   SK04
    ## 881 2014   TR10
    ## 882 2014   TR21
    ## 883 2014   TR22
    ## 884 2014   TR31
    ## 885 2014   TR32
    ## 886 2014   TR33
    ## 887 2014   TR41
    ## 888 2014   TR42
    ## 889 2014   TR51
    ## 890 2014   TR52
    ## 891 2014   TR61
    ## 892 2014   TR62
    ## 893 2014   TR63
    ## 894 2014   TR71
    ## 895 2014   TR72
    ## 896 2014   TR81
    ## 897 2014   TR82
    ## 898 2014   TR83
    ## 899 2014   TR90
    ## 900 2014   TRA1
    ## 901 2014   TRA2
    ## 902 2014   TRB1
    ## 903 2014   TRB2
    ## 904 2014   TRC1
    ## 905 2014   TRC2
    ## 906 2014   TRC3
    ##                                                        nuts2_name
    ## 1   Région de Bruxelles-Capitale / Brussels Hoofdstedelijk Gewest
    ## 2                                                 Prov. Antwerpen
    ## 3                                              Prov. Limburg (BE)
    ## 4                                           Prov. Oost-Vlaanderen
    ## 5                                            Prov. Vlaams-Brabant
    ## 6                                           Prov. West-Vlaanderen
    ## 7                                            Prov. Brabant Wallon
    ## 8                                                   Prov. Hainaut
    ## 9                                                     Prov. Liège
    ## 10                                          Prov. Luxembourg (BE)
    ## 11                                                    Prov. Namur
    ## 12                                              Bratislavský kraj
    ## 13                                              Západné Slovensko
    ## 14                                              Stredné Slovensko
    ## 15                                             Východné Slovensko
    ## 16                                         Tees Valley and Durham
    ## 17                               Northumberland and Tyne and Wear
    ## 18                                                        Cumbria
    ## 19                                             Greater Manchester
    ## 20                                                     Lancashire
    ## 21                       East Yorkshire and Northern Lincolnshire
    ## 22                                                North Yorkshire
    ## 23                                                South Yorkshire
    ## 24                                                 West Yorkshire
    ## 25                                 Derbyshire and Nottinghamshire
    ## 26                   Leicestershire, Rutland and Northamptonshire
    ## 27                                                   Lincolnshire
    ## 28                 Herefordshire, Worcestershire and Warwickshire
    ## 29                                   Shropshire and Staffordshire
    ## 30                                                  West Midlands
    ## 31                                                    East Anglia
    ## 32                                 Bedfordshire and Hertfordshire
    ## 33                                                          Essex
    ## 34                                       Inner London (NUTS 2010)
    ## 35                                       Outer London (NUTS 2010)
    ## 36                     Berkshire, Buckinghamshire and Oxfordshire
    ## 37                                   Surrey, East and West Sussex
    ## 38                                    Hampshire and Isle of Wight
    ## 39                                                           Kent
    ## 40               Gloucestershire, Wiltshire and Bristol/Bath area
    ## 41                                            Dorset and Somerset
    ## 42                                   Cornwall and Isles of Scilly
    ## 43                                                          Devon
    ## 44                                     West Wales and The Valleys
    ## 45                                                     East Wales
    ## 46                                               Eastern Scotland
    ## 47                                         South Western Scotland
    ## 48                                          Northern Ireland (UK)
    ## 49                                                          Eesti
    ## 50                                                        Lódzkie
    ## 51                                                    Mazowieckie
    ## 52                                                    Malopolskie
    ## 53                                                        Slaskie
    ## 54                                                      Lubelskie
    ## 55                                                   Podkarpackie
    ## 56                                                 Swietokrzyskie
    ## 57                                                      Podlaskie
    ## 58                                                  Wielkopolskie
    ## 59                                             Zachodniopomorskie
    ## 60                                                       Lubuskie
    ## 61                                                   Dolnoslaskie
    ## 62                                                       Opolskie
    ## 63                                             Kujawsko-Pomorskie
    ## 64                                            Warminsko-Mazurskie
    ## 65                                                      Pomorskie
    ## 66                                                    Länsi-Suomi
    ## 67                                                          Åland
    ## 68  Région de Bruxelles-Capitale / Brussels Hoofdstedelijk Gewest
    ## 69                                                Prov. Antwerpen
    ## 70                                             Prov. Limburg (BE)
    ## 71                                          Prov. Oost-Vlaanderen
    ## 72                                           Prov. Vlaams-Brabant
    ## 73                                          Prov. West-Vlaanderen
    ## 74                                           Prov. Brabant Wallon
    ## 75                                                  Prov. Hainaut
    ## 76                                                    Prov. Liège
    ## 77                                          Prov. Luxembourg (BE)
    ## 78                                                    Prov. Namur
    ## 79                                                    Yugozapaden
    ## 80                        Anatoliki Makedonia, Thraki (NUTS 2010)
    ## 81                                 Kentriki Makedonia (NUTS 2010)
    ## 82                                   Dytiki Makedonia (NUTS 2010)
    ## 83                                          Thessalia (NUTS 2010)
    ## 84                                            Ipeiros (NUTS 2010)
    ## 85                                        Ionia Nisia (NUTS 2010)
    ## 86                                      Dytiki Ellada (NUTS 2010)
    ## 87                                      Sterea Ellada (NUTS 2010)
    ## 88                                       Peloponnisos (NUTS 2010)
    ## 89                                                         Attiki
    ## 90                                                  Voreio Aigaio
    ## 91                                                   Notio Aigaio
    ## 92                                                          Kriti
    ## 93                                                        Galicia
    ## 94                                         Principado de Asturias
    ## 95                                                      Cantabria
    ## 96                                                     País Vasco
    ## 97                                     Comunidad Foral de Navarra
    ## 98                                                       La Rioja
    ## 99                                                         Aragón
    ## 100                                           Comunidad de Madrid
    ## 101                                               Castilla y León
    ## 102                                            Castilla-la Mancha
    ## 103                                                   Extremadura
    ## 104                                                      Cataluña
    ## 105                                          Comunidad Valenciana
    ## 106                                                 Illes Balears
    ## 107                                                     Andalucía
    ## 108                                              Región de Murcia
    ## 109                                 Ciudad Autónoma de Ceuta (ES)
    ## 110                               Ciudad Autónoma de Melilla (ES)
    ## 111                                                 Canarias (ES)
    ## 112                                            Közép-Magyarország
    ## 113                                                Közép-Dunántúl
    ## 114                                               Nyugat-Dunántúl
    ## 115                                                  Dél-Dunántúl
    ## 116                                            Észak-Magyarország
    ## 117                                                  Észak-Alföld
    ## 118                                                    Dél-Alföld
    ## 119                                                       Lódzkie
    ## 120                                                   Mazowieckie
    ## 121                                                   Malopolskie
    ## 122                                                       Slaskie
    ## 123                                                     Lubelskie
    ## 124                                                  Podkarpackie
    ## 125                                                Swietokrzyskie
    ## 126                                                     Podlaskie
    ## 127                                                 Wielkopolskie
    ## 128                                            Zachodniopomorskie
    ## 129                                                      Lubuskie
    ## 130                                                  Dolnoslaskie
    ## 131                                                      Opolskie
    ## 132                                            Kujawsko-Pomorskie
    ## 133                                           Warminsko-Mazurskie
    ## 134                                                     Pomorskie
    ## 135                                                     Stockholm
    ## 136                                           Östra Mellansverige
    ## 137                                             Småland med öarna
    ## 138                                                    Sydsverige
    ## 139                                                   Västsverige
    ## 140                                           Norra Mellansverige
    ## 141                                            Mellersta Norrland
    ## 142                                                 Övre Norrland
    ## 143                                                       Latvija
    ## 144                                                       Lietuva
    ## 145                                                         Norte
    ## 146                                                       Algarve
    ## 147                                                   Centro (PT)
    ## 148                                  Área Metropolitana de Lisboa
    ## 149                                                      Alentejo
    ## 150                               Região Autónoma dos Açores (PT)
    ## 151                               Região Autónoma da Madeira (PT)
    ## 152                                                     Nord-Vest
    ## 153                                                        Centru
    ## 154                                                      Nord-Est
    ## 155                                                       Sud-Est
    ## 156                                                Sud - Muntenia
    ## 157                                             Bucuresti - Ilfov
    ## 158                                              Sud-Vest Oltenia
    ## 159                                                          Vest
    ## 160                                                 Severozapaden
    ## 161                                            Severen tsentralen
    ## 162                                                Severoiztochen
    ## 163                                                  Yugoiztochen
    ## 164                                                   Yugozapaden
    ## 165                                             Yuzhen tsentralen
    ## 166                                                 Île de France
    ## 167                                             Champagne-Ardenne
    ## 168                                                      Picardie
    ## 169                                               Haute-Normandie
    ## 170                                                   Centre (FR)
    ## 171                                               Basse-Normandie
    ## 172                                                     Bourgogne
    ## 173                                          Nord - Pas-de-Calais
    ## 174                                                      Lorraine
    ## 175                                                        Alsace
    ## 176                                                 Franche-Comté
    ## 177                                              Pays de la Loire
    ## 178                                                      Bretagne
    ## 179                                              Poitou-Charentes
    ## 180                                                     Aquitaine
    ## 181                                                 Midi-Pyrénées
    ## 182                                                      Limousin
    ## 183                                                   Rhône-Alpes
    ## 184                                                      Auvergne
    ## 185                                          Languedoc-Roussillon
    ## 186                                    Provence-Alpes-Côte d'Azur
    ## 187                                        Guadeloupe (NUTS 2010)
    ## 188                                        Martinique (NUTS 2010)
    ## 189                                            Guyane (NUTS 2010)
    ## 190                                           Réunion (NUTS 2010)
    ## 191                                                    Luxembourg
    ## 192                                                       Lódzkie
    ## 193                                                   Mazowieckie
    ## 194                                                   Malopolskie
    ## 195                                                       Slaskie
    ## 196                                                     Lubelskie
    ## 197                                                  Podkarpackie
    ## 198                                                Swietokrzyskie
    ## 199                                                     Podlaskie
    ## 200                                                 Wielkopolskie
    ## 201                                            Zachodniopomorskie
    ## 202                                                      Lubuskie
    ## 203                                                  Dolnoslaskie
    ## 204                                                      Opolskie
    ## 205                                            Kujawsko-Pomorskie
    ## 206                                           Warminsko-Mazurskie
    ## 207                                                     Pomorskie
    ## 208                                                     Nord-Vest
    ## 209                                                        Centru
    ## 210                                                      Nord-Est
    ## 211                                                       Sud-Est
    ## 212                                                Sud - Muntenia
    ## 213                                             Bucuresti - Ilfov
    ## 214                                              Sud-Vest Oltenia
    ## 215                                                          Vest
    ## 216                                             Bratislavský kraj
    ## 217                                             Západné Slovensko
    ## 218                                             Stredné Slovensko
    ## 219                                            Východné Slovensko
    ## 220                                                        Ísland
    ## 221                       Anatoliki Makedonia, Thraki (NUTS 2010)
    ## 222                                Kentriki Makedonia (NUTS 2010)
    ## 223                                  Dytiki Makedonia (NUTS 2010)
    ## 224                                         Thessalia (NUTS 2010)
    ## 225                                           Ipeiros (NUTS 2010)
    ## 226                                       Ionia Nisia (NUTS 2010)
    ## 227                                     Dytiki Ellada (NUTS 2010)
    ## 228                                     Sterea Ellada (NUTS 2010)
    ## 229                                      Peloponnisos (NUTS 2010)
    ## 230                                                        Attiki
    ## 231                                                 Voreio Aigaio
    ## 232                                                  Notio Aigaio
    ## 233                                                         Kriti
    ## 234                                                      Piemonte
    ## 235                                  Valle d'Aosta/Vallée d'Aoste
    ## 236                                                       Liguria
    ## 237                                                     Lombardia
    ## 238                           Provincia Autonoma di Bolzano/Bozen
    ## 239                                  Provincia Autonoma di Trento
    ## 240                                                        Veneto
    ## 241                                         Friuli-Venezia Giulia
    ## 242                                                       Toscana
    ## 243                                                        Umbria
    ## 244                                                         Lazio
    ## 245                                                       Abruzzo
    ## 246                                                        Molise
    ## 247                                                      Campania
    ## 248                                                        Puglia
    ## 249                                                    Basilicata
    ## 250                                                      Calabria
    ## 251                                                       Sicilia
    ## 252                                                      Sardegna
    ## 253                                                         Malta
    ## 254                                               Burgenland (AT)
    ## 255                                              Niederösterreich
    ## 256                                                          Wien
    ## 257                                                       Kärnten
    ## 258                                                    Steiermark
    ## 259                                                Oberösterreich
    ## 260                                                      Salzburg
    ## 261                                                         Tirol
    ## 262                                                    Vorarlberg
    ## 263                                                       Lódzkie
    ## 264                                                   Mazowieckie
    ## 265                                                   Malopolskie
    ## 266                                                       Slaskie
    ## 267                                                     Lubelskie
    ## 268                                                  Podkarpackie
    ## 269                                                Swietokrzyskie
    ## 270                                                     Podlaskie
    ## 271                                                 Wielkopolskie
    ## 272                                            Zachodniopomorskie
    ## 273                                                      Lubuskie
    ## 274                                                  Dolnoslaskie
    ## 275                                                      Opolskie
    ## 276                                            Kujawsko-Pomorskie
    ## 277                                           Warminsko-Mazurskie
    ## 278                                                     Pomorskie
    ## 279                                        Tees Valley and Durham
    ## 280                              Northumberland and Tyne and Wear
    ## 281                                                       Cumbria
    ## 282                                            Greater Manchester
    ## 283                                                    Lancashire
    ## 284                      East Yorkshire and Northern Lincolnshire
    ## 285                                               North Yorkshire
    ## 286                                               South Yorkshire
    ## 287                                                West Yorkshire
    ## 288                                Derbyshire and Nottinghamshire
    ## 289                  Leicestershire, Rutland and Northamptonshire
    ## 290                                                  Lincolnshire
    ## 291                Herefordshire, Worcestershire and Warwickshire
    ## 292                                  Shropshire and Staffordshire
    ## 293                                                 West Midlands
    ## 294                                                   East Anglia
    ## 295                                Bedfordshire and Hertfordshire
    ## 296                                                         Essex
    ## 297                                      Inner London (NUTS 2010)
    ## 298                                      Outer London (NUTS 2010)
    ## 299                    Berkshire, Buckinghamshire and Oxfordshire
    ## 300                                  Surrey, East and West Sussex
    ## 301                                   Hampshire and Isle of Wight
    ## 302                                                          Kent
    ## 303              Gloucestershire, Wiltshire and Bristol/Bath area
    ## 304                                           Dorset and Somerset
    ## 305                                  Cornwall and Isles of Scilly
    ## 306                                                         Devon
    ## 307                                    West Wales and The Valleys
    ## 308                                                    East Wales
    ## 309                                              Eastern Scotland
    ## 310                                        South Western Scotland
    ## 311                                        North Eastern Scotland
    ## 312                                         Highlands and Islands
    ## 313                                         Northern Ireland (UK)
    ## 314 Région de Bruxelles-Capitale / Brussels Hoofdstedelijk Gewest
    ## 315                                               Prov. Antwerpen
    ## 316                                            Prov. Limburg (BE)
    ## 317                                         Prov. Oost-Vlaanderen
    ## 318                                          Prov. Vlaams-Brabant
    ## 319                                         Prov. West-Vlaanderen
    ## 320                                          Prov. Brabant Wallon
    ## 321                                                 Prov. Hainaut
    ## 322                                                   Prov. Liège
    ## 323                                         Prov. Luxembourg (BE)
    ## 324                                                   Prov. Namur
    ## 325                                                 Severozapaden
    ## 326                                            Severen tsentralen
    ## 327                                                Severoiztochen
    ## 328                                                  Yugoiztochen
    ## 329                                                   Yugozapaden
    ## 330                                             Yuzhen tsentralen
    ## 331                                                         Praha
    ## 332                                                 Strední Cechy
    ## 333                                                     Jihozápad
    ## 334                                                   Severozápad
    ## 335                                                  Severovýchod
    ## 336                                                    Jihovýchod
    ## 337                                                Strední Morava
    ## 338                                               Moravskoslezsko
    ## 339                                                     Stuttgart
    ## 340                                                     Karlsruhe
    ## 341                                                      Freiburg
    ## 342                                                      Tübingen
    ## 343                                                    Oberbayern
    ## 344                                                  Niederbayern
    ## 345                                                     Oberpfalz
    ## 346                                                   Oberfranken
    ## 347                                                 Mittelfranken
    ## 348                                                  Unterfranken
    ## 349                                                      Schwaben
    ## 350                                                        Berlin
    ## 351                                                   Brandenburg
    ## 352                                                        Bremen
    ## 353                                                       Hamburg
    ## 354                                                     Darmstadt
    ## 355                                                        Gießen
    ## 356                                                        Kassel
    ## 357                                        Mecklenburg-Vorpommern
    ## 358                                                  Braunschweig
    ## 359                                                      Hannover
    ## 360                                                      Lüneburg
    ## 361                                                     Weser-Ems
    ## 362                                                    Düsseldorf
    ## 363                                                          Köln
    ## 364                                                       Münster
    ## 365                                                       Detmold
    ## 366                                                      Arnsberg
    ## 367                                                       Koblenz
    ## 368                                                         Trier
    ## 369                                             Rheinhessen-Pfalz
    ## 370                                                      Saarland
    ## 371                                                       Dresden
    ## 372                                                      Chemnitz
    ## 373                                                       Leipzig
    ## 374                                                Sachsen-Anhalt
    ## 375                                            Schleswig-Holstein
    ## 376                                                     Thüringen
    ## 377                                                         Eesti
    ## 378                                   Border, Midland and Western
    ## 379                                          Southern and Eastern
    ## 380                       Anatoliki Makedonia, Thraki (NUTS 2010)
    ## 381                                Kentriki Makedonia (NUTS 2010)
    ## 382                                  Dytiki Makedonia (NUTS 2010)
    ## 383                                         Thessalia (NUTS 2010)
    ## 384                                           Ipeiros (NUTS 2010)
    ## 385                                       Ionia Nisia (NUTS 2010)
    ## 386                                     Dytiki Ellada (NUTS 2010)
    ## 387                                     Sterea Ellada (NUTS 2010)
    ## 388                                      Peloponnisos (NUTS 2010)
    ## 389                                                        Attiki
    ## 390                                                 Voreio Aigaio
    ## 391                                                  Notio Aigaio
    ## 392                                                         Kriti
    ## 393                                                       Galicia
    ## 394                                        Principado de Asturias
    ## 395                                                     Cantabria
    ## 396                                                    País Vasco
    ## 397                                    Comunidad Foral de Navarra
    ## 398                                                      La Rioja
    ## 399                                                        Aragón
    ## 400                                           Comunidad de Madrid
    ## 401                                               Castilla y León
    ## 402                                            Castilla-la Mancha
    ## 403                                                   Extremadura
    ## 404                                                      Cataluña
    ## 405                                          Comunidad Valenciana
    ## 406                                                 Illes Balears
    ## 407                                                     Andalucía
    ## 408                                              Región de Murcia
    ## 409                                 Ciudad Autónoma de Ceuta (ES)
    ## 410                               Ciudad Autónoma de Melilla (ES)
    ## 411                                                 Canarias (ES)
    ## 412                                                 Île de France
    ## 413                                             Champagne-Ardenne
    ## 414                                                      Picardie
    ## 415                                               Haute-Normandie
    ## 416                                                   Centre (FR)
    ## 417                                               Basse-Normandie
    ## 418                                                     Bourgogne
    ## 419                                          Nord - Pas-de-Calais
    ## 420                                                      Lorraine
    ## 421                                                        Alsace
    ## 422                                                 Franche-Comté
    ## 423                                              Pays de la Loire
    ## 424                                                      Bretagne
    ## 425                                              Poitou-Charentes
    ## 426                                                     Aquitaine
    ## 427                                                 Midi-Pyrénées
    ## 428                                                      Limousin
    ## 429                                                   Rhône-Alpes
    ## 430                                                      Auvergne
    ## 431                                          Languedoc-Roussillon
    ## 432                                    Provence-Alpes-Côte d'Azur
    ## 433                                                         Corse
    ## 434                                        Guadeloupe (NUTS 2010)
    ## 435                                        Martinique (NUTS 2010)
    ## 436                                            Guyane (NUTS 2010)
    ## 437                                           Réunion (NUTS 2010)
    ## 438                                                      Piemonte
    ## 439                                  Valle d'Aosta/Vallée d'Aoste
    ## 440                                                       Liguria
    ## 441                                                     Lombardia
    ## 442                           Provincia Autonoma di Bolzano/Bozen
    ## 443                                  Provincia Autonoma di Trento
    ## 444                                                        Veneto
    ## 445                                         Friuli-Venezia Giulia
    ## 446                                                Emilia-Romagna
    ## 447                                                       Toscana
    ## 448                                                        Umbria
    ## 449                                                        Marche
    ## 450                                                         Lazio
    ## 451                                                       Abruzzo
    ## 452                                                        Molise
    ## 453                                                      Campania
    ## 454                                                        Puglia
    ## 455                                                    Basilicata
    ## 456                                                      Calabria
    ## 457                                                       Sicilia
    ## 458                                                      Sardegna
    ## 459                                                        Kypros
    ## 460                                                       Latvija
    ## 461                                                       Lietuva
    ## 462                                                    Luxembourg
    ## 463                                            Közép-Magyarország
    ## 464                                                Közép-Dunántúl
    ## 465                                               Nyugat-Dunántúl
    ## 466                                                  Dél-Dunántúl
    ## 467                                            Észak-Magyarország
    ## 468                                                  Észak-Alföld
    ## 469                                                    Dél-Alföld
    ## 470                                                         Malta
    ## 471                                                     Groningen
    ## 472                                                Friesland (NL)
    ## 473                                                       Drenthe
    ## 474                                                    Overijssel
    ## 475                                                    Gelderland
    ## 476                                                     Flevoland
    ## 477                                                       Utrecht
    ## 478                                                 Noord-Holland
    ## 479                                                  Zuid-Holland
    ## 480                                                       Zeeland
    ## 481                                                 Noord-Brabant
    ## 482                                                  Limburg (NL)
    ## 483                                               Burgenland (AT)
    ## 484                                              Niederösterreich
    ## 485                                                          Wien
    ## 486                                                       Kärnten
    ## 487                                                    Steiermark
    ## 488                                                Oberösterreich
    ## 489                                                      Salzburg
    ## 490                                                         Tirol
    ## 491                                                    Vorarlberg
    ## 492                                                       Lódzkie
    ## 493                                                   Mazowieckie
    ## 494                                                   Malopolskie
    ## 495                                                       Slaskie
    ## 496                                                     Lubelskie
    ## 497                                                  Podkarpackie
    ## 498                                                Swietokrzyskie
    ## 499                                                     Podlaskie
    ## 500                                                 Wielkopolskie
    ## 501                                            Zachodniopomorskie
    ## 502                                                      Lubuskie
    ## 503                                                  Dolnoslaskie
    ## 504                                                      Opolskie
    ## 505                                            Kujawsko-Pomorskie
    ## 506                                           Warminsko-Mazurskie
    ## 507                                                     Pomorskie
    ## 508                                                         Norte
    ## 509                                                       Algarve
    ## 510                                                   Centro (PT)
    ## 511                                  Área Metropolitana de Lisboa
    ## 512                                                      Alentejo
    ## 513                               Região Autónoma dos Açores (PT)
    ## 514                               Região Autónoma da Madeira (PT)
    ## 515                                                     Nord-Vest
    ## 516                                                        Centru
    ## 517                                                      Nord-Est
    ## 518                                                       Sud-Est
    ## 519                                                Sud - Muntenia
    ## 520                                             Bucuresti - Ilfov
    ## 521                                              Sud-Vest Oltenia
    ## 522                                                          Vest
    ## 523                                 Vzhodna Slovenija (NUTS 2010)
    ## 524                                 Zahodna Slovenija (NUTS 2010)
    ## 525                                             Bratislavský kraj
    ## 526                                             Západné Slovensko
    ## 527                                             Stredné Slovensko
    ## 528                                            Východné Slovensko
    ## 529                                                   Länsi-Suomi
    ## 530                                              Helsinki-Uusimaa
    ## 531                                                   Etelä-Suomi
    ## 532                                         Pohjois- ja Itä-Suomi
    ## 533                                                         Åland
    ## 534                                                     Stockholm
    ## 535                                           Östra Mellansverige
    ## 536                                             Småland med öarna
    ## 537                                                    Sydsverige
    ## 538                                                   Västsverige
    ## 539                                           Norra Mellansverige
    ## 540                                            Mellersta Norrland
    ## 541                                                 Övre Norrland
    ## 542                                        Tees Valley and Durham
    ## 543                              Northumberland and Tyne and Wear
    ## 544                                                       Cumbria
    ## 545                                            Greater Manchester
    ## 546                                                    Lancashire
    ## 547                                                      Cheshire
    ## 548                                                    Merseyside
    ## 549                      East Yorkshire and Northern Lincolnshire
    ## 550                                               North Yorkshire
    ## 551                                               South Yorkshire
    ## 552                                                West Yorkshire
    ## 553                                Derbyshire and Nottinghamshire
    ## 554                  Leicestershire, Rutland and Northamptonshire
    ## 555                                                  Lincolnshire
    ## 556                Herefordshire, Worcestershire and Warwickshire
    ## 557                                  Shropshire and Staffordshire
    ## 558                                                 West Midlands
    ## 559                                                   East Anglia
    ## 560                                Bedfordshire and Hertfordshire
    ## 561                                                         Essex
    ## 562                                      Inner London (NUTS 2010)
    ## 563                                      Outer London (NUTS 2010)
    ## 564                    Berkshire, Buckinghamshire and Oxfordshire
    ## 565                                  Surrey, East and West Sussex
    ## 566                                   Hampshire and Isle of Wight
    ## 567                                                          Kent
    ## 568              Gloucestershire, Wiltshire and Bristol/Bath area
    ## 569                                           Dorset and Somerset
    ## 570                                  Cornwall and Isles of Scilly
    ## 571                                                         Devon
    ## 572                                    West Wales and The Valleys
    ## 573                                                    East Wales
    ## 574                                              Eastern Scotland
    ## 575                                        South Western Scotland
    ## 576                                        North Eastern Scotland
    ## 577                                         Highlands and Islands
    ## 578                                         Northern Ireland (UK)
    ## 579                                                        Ísland
    ## 580                                              Oslo og Akershus
    ## 581                                            Hedmark og Oppland
    ## 582                                                 Sør-Østlandet
    ## 583                                             Agder og Rogaland
    ## 584                                                    Vestlandet
    ## 585                                                     Trøndelag
    ## 586                                                    Nord-Norge
    ## 587                                              Région lémanique
    ## 588                                             Espace Mittelland
    ## 589                                               Nordwestschweiz
    ## 590                                                        Zürich
    ## 591                                                    Ostschweiz
    ## 592                                                Zentralschweiz
    ## 593                                                        Ticino
    ## 594                                              Oslo og Akershus
    ## 595                                            Hedmark og Oppland
    ## 596                                                 Sør-Østlandet
    ## 597                                             Agder og Rogaland
    ## 598                                                    Vestlandet
    ## 599                                                     Trøndelag
    ## 600                                                    Nord-Norge
    ## 601                                   Border, Midland and Western
    ## 602                                          Southern and Eastern
    ## 603                                                    Luxembourg
    ## 604                                               Burgenland (AT)
    ## 605                                              Niederösterreich
    ## 606                                                          Wien
    ## 607                                                       Kärnten
    ## 608                                                    Steiermark
    ## 609                                                Oberösterreich
    ## 610                                                      Salzburg
    ## 611                                                         Tirol
    ## 612                                                    Vorarlberg
    ## 613                                        Tees Valley and Durham
    ## 614                              Northumberland and Tyne and Wear
    ## 615                                                       Cumbria
    ## 616                                            Greater Manchester
    ## 617                                                    Lancashire
    ## 618                                                      Cheshire
    ## 619                                                    Merseyside
    ## 620                      East Yorkshire and Northern Lincolnshire
    ## 621                                               North Yorkshire
    ## 622                                               South Yorkshire
    ## 623                                                West Yorkshire
    ## 624                                Derbyshire and Nottinghamshire
    ## 625                  Leicestershire, Rutland and Northamptonshire
    ## 626                                                  Lincolnshire
    ## 627                Herefordshire, Worcestershire and Warwickshire
    ## 628                                  Shropshire and Staffordshire
    ## 629                                                 West Midlands
    ## 630                                                   East Anglia
    ## 631                                Bedfordshire and Hertfordshire
    ## 632                                                         Essex
    ## 633                                      Inner London (NUTS 2010)
    ## 634                                      Outer London (NUTS 2010)
    ## 635                    Berkshire, Buckinghamshire and Oxfordshire
    ## 636                                  Surrey, East and West Sussex
    ## 637                                   Hampshire and Isle of Wight
    ## 638                                                          Kent
    ## 639              Gloucestershire, Wiltshire and Bristol/Bath area
    ## 640                                           Dorset and Somerset
    ## 641                                  Cornwall and Isles of Scilly
    ## 642                                                         Devon
    ## 643                                    West Wales and The Valleys
    ## 644                                                    East Wales
    ## 645                                              Eastern Scotland
    ## 646                                        South Western Scotland
    ## 647                                        North Eastern Scotland
    ## 648                                         Highlands and Islands
    ## 649                                         Northern Ireland (UK)
    ## 650                                                 Severozapaden
    ## 651                                            Severen tsentralen
    ## 652                                                Severoiztochen
    ## 653                                                  Yugoiztochen
    ## 654                                                   Yugozapaden
    ## 655                                             Yuzhen tsentralen
    ## 656                                                   Länsi-Suomi
    ## 657                                              Helsinki-Uusimaa
    ## 658                                                   Etelä-Suomi
    ## 659                                         Pohjois- ja Itä-Suomi
    ## 660                                                         Åland
    ## 661                                        Tees Valley and Durham
    ## 662                              Northumberland and Tyne and Wear
    ## 663                                                       Cumbria
    ## 664                                            Greater Manchester
    ## 665                                                    Lancashire
    ## 666                                                      Cheshire
    ## 667                                                    Merseyside
    ## 668                      East Yorkshire and Northern Lincolnshire
    ## 669                                               North Yorkshire
    ## 670                                               South Yorkshire
    ## 671                                                West Yorkshire
    ## 672                                Derbyshire and Nottinghamshire
    ## 673                  Leicestershire, Rutland and Northamptonshire
    ## 674                                                  Lincolnshire
    ## 675                Herefordshire, Worcestershire and Warwickshire
    ## 676                                  Shropshire and Staffordshire
    ## 677                                                 West Midlands
    ## 678                                                   East Anglia
    ## 679                                Bedfordshire and Hertfordshire
    ## 680                                                         Essex
    ## 681                                      Inner London (NUTS 2010)
    ## 682                                      Outer London (NUTS 2010)
    ## 683                    Berkshire, Buckinghamshire and Oxfordshire
    ## 684                                  Surrey, East and West Sussex
    ## 685                                   Hampshire and Isle of Wight
    ## 686                                                          Kent
    ## 687              Gloucestershire, Wiltshire and Bristol/Bath area
    ## 688                                           Dorset and Somerset
    ## 689                                  Cornwall and Isles of Scilly
    ## 690                                                         Devon
    ## 691                                    West Wales and The Valleys
    ## 692                                                    East Wales
    ## 693                                              Eastern Scotland
    ## 694                                        South Western Scotland
    ## 695                                        North Eastern Scotland
    ## 696                                         Highlands and Islands
    ## 697                                         Northern Ireland (UK)
    ## 698                                   Border, Midland and Western
    ## 699                                          Southern and Eastern
    ## 700                       Anatoliki Makedonia, Thraki (NUTS 2010)
    ## 701                                Kentriki Makedonia (NUTS 2010)
    ## 702                                  Dytiki Makedonia (NUTS 2010)
    ## 703                                         Thessalia (NUTS 2010)
    ## 704                                           Ipeiros (NUTS 2010)
    ## 705                                       Ionia Nisia (NUTS 2010)
    ## 706                                     Dytiki Ellada (NUTS 2010)
    ## 707                                     Sterea Ellada (NUTS 2010)
    ## 708                                      Peloponnisos (NUTS 2010)
    ## 709                                                        Attiki
    ## 710                                                 Voreio Aigaio
    ## 711                                                  Notio Aigaio
    ## 712                                                         Kriti
    ## 713                                                        Kypros
    ## 714                                                    Luxembourg
    ## 715                                                 Severozapaden
    ## 716                                            Severen tsentralen
    ## 717                                                Severoiztochen
    ## 718                                                  Yugoiztochen
    ## 719                                                   Yugozapaden
    ## 720                                             Yuzhen tsentralen
    ## 721                                                     Stuttgart
    ## 722                                                     Karlsruhe
    ## 723                                                      Freiburg
    ## 724                                                      Tübingen
    ## 725                                                    Oberbayern
    ## 726                                                  Niederbayern
    ## 727                                                     Oberpfalz
    ## 728                                                   Oberfranken
    ## 729                                                 Mittelfranken
    ## 730                                                  Unterfranken
    ## 731                                                      Schwaben
    ## 732                                                        Berlin
    ## 733                                                   Brandenburg
    ## 734                                                        Bremen
    ## 735                                                       Hamburg
    ## 736                                                     Darmstadt
    ## 737                                                        Gießen
    ## 738                                                        Kassel
    ## 739                                        Mecklenburg-Vorpommern
    ## 740                                                  Braunschweig
    ## 741                                                      Hannover
    ## 742                                                      Lüneburg
    ## 743                                                     Weser-Ems
    ## 744                                                    Düsseldorf
    ## 745                                                          Köln
    ## 746                                                       Münster
    ## 747                                                       Detmold
    ## 748                                                      Arnsberg
    ## 749                                                       Koblenz
    ## 750                                                         Trier
    ## 751                                             Rheinhessen-Pfalz
    ## 752                                                      Saarland
    ## 753                                                       Dresden
    ## 754                                                      Chemnitz
    ## 755                                                       Leipzig
    ## 756                                                Sachsen-Anhalt
    ## 757                                            Schleswig-Holstein
    ## 758                                                     Thüringen
    ## 759                                                     Groningen
    ## 760                                                Friesland (NL)
    ## 761                                                       Drenthe
    ## 762                                                    Overijssel
    ## 763                                                    Gelderland
    ## 764                                                     Flevoland
    ## 765                                                       Utrecht
    ## 766                                                 Noord-Holland
    ## 767                                                  Zuid-Holland
    ## 768                                                       Zeeland
    ## 769                                                 Noord-Brabant
    ## 770                                                  Limburg (NL)
    ## 771                                                       Lódzkie
    ## 772                                                   Mazowieckie
    ## 773                                                   Malopolskie
    ## 774                                                       Slaskie
    ## 775                                                     Lubelskie
    ## 776                                                  Podkarpackie
    ## 777                                                Swietokrzyskie
    ## 778                                                     Podlaskie
    ## 779                                                 Wielkopolskie
    ## 780                                            Zachodniopomorskie
    ## 781                                                      Lubuskie
    ## 782                                                  Dolnoslaskie
    ## 783                                                      Opolskie
    ## 784                                            Kujawsko-Pomorskie
    ## 785                                           Warminsko-Mazurskie
    ## 786                                                     Pomorskie
    ## 787                                                     Nord-Vest
    ## 788                                                        Centru
    ## 789                                                      Nord-Est
    ## 790                                                       Sud-Est
    ## 791                                                Sud - Muntenia
    ## 792                                             Bucuresti - Ilfov
    ## 793                                              Sud-Vest Oltenia
    ## 794                                                          Vest
    ## 795 Région de Bruxelles-Capitale / Brussels Hoofdstedelijk Gewest
    ## 796                                               Prov. Antwerpen
    ## 797                                            Prov. Limburg (BE)
    ## 798                                         Prov. Oost-Vlaanderen
    ## 799                                          Prov. Vlaams-Brabant
    ## 800                                         Prov. West-Vlaanderen
    ## 801                                          Prov. Brabant Wallon
    ## 802                                                 Prov. Hainaut
    ## 803                                                   Prov. Liège
    ## 804                                         Prov. Luxembourg (BE)
    ## 805                                                   Prov. Namur
    ## 806                                                 Severozapaden
    ## 807                                            Severen tsentralen
    ## 808                                                Severoiztochen
    ## 809                                                  Yugoiztochen
    ## 810                                                   Yugozapaden
    ## 811                                             Yuzhen tsentralen
    ## 812                                                         Praha
    ## 813                                                 Strední Cechy
    ## 814                                                     Jihozápad
    ## 815                                                   Severozápad
    ## 816                                                  Severovýchod
    ## 817                                                    Jihovýchod
    ## 818                                                Strední Morava
    ## 819                                               Moravskoslezsko
    ## 820                                                     Stuttgart
    ## 821                                                     Karlsruhe
    ## 822                                                      Freiburg
    ## 823                                                      Tübingen
    ## 824                                                    Oberbayern
    ## 825                                                  Niederbayern
    ## 826                                                     Oberpfalz
    ## 827                                                   Oberfranken
    ## 828                                                 Mittelfranken
    ## 829                                                  Unterfranken
    ## 830                                                      Schwaben
    ## 831                                                        Berlin
    ## 832                                                   Brandenburg
    ## 833                                                        Bremen
    ## 834                                                       Hamburg
    ## 835                                                     Darmstadt
    ## 836                                                        Gießen
    ## 837                                                        Kassel
    ## 838                                        Mecklenburg-Vorpommern
    ## 839                                                  Braunschweig
    ## 840                                                      Hannover
    ## 841                                                      Lüneburg
    ## 842                                                     Weser-Ems
    ## 843                                                    Düsseldorf
    ## 844                                                          Köln
    ## 845                                                       Münster
    ## 846                                                       Detmold
    ## 847                                                      Arnsberg
    ## 848                                                       Koblenz
    ## 849                                                         Trier
    ## 850                                             Rheinhessen-Pfalz
    ## 851                                                      Saarland
    ## 852                                                       Dresden
    ## 853                                                      Chemnitz
    ## 854                                                       Leipzig
    ## 855                                                Sachsen-Anhalt
    ## 856                                            Schleswig-Holstein
    ## 857                                                     Thüringen
    ## 858                                                     Groningen
    ## 859                                                Friesland (NL)
    ## 860                                                       Drenthe
    ## 861                                                    Overijssel
    ## 862                                                    Gelderland
    ## 863                                                     Flevoland
    ## 864                                                       Utrecht
    ## 865                                                 Noord-Holland
    ## 866                                                  Zuid-Holland
    ## 867                                                       Zeeland
    ## 868                                                 Noord-Brabant
    ## 869                                                  Limburg (NL)
    ## 870                                                         Norte
    ## 871                                                       Algarve
    ## 872                                                   Centro (PT)
    ## 873                                  Área Metropolitana de Lisboa
    ## 874                                                      Alentejo
    ## 875                               Região Autónoma dos Açores (PT)
    ## 876                               Região Autónoma da Madeira (PT)
    ## 877                                             Bratislavský kraj
    ## 878                                             Západné Slovensko
    ## 879                                             Stredné Slovensko
    ## 880                                            Východné Slovensko
    ## 881                                                      Istanbul
    ## 882                                  Tekirdag, Edirne, Kirklareli
    ## 883                                          Balikesir, Çanakkale
    ## 884                                                         Izmir
    ## 885                                         Aydin, Denizli, Mugla
    ## 886                         Manisa, Afyonkarahisar, Kütahya, Usak
    ## 887                                     Bursa, Eskisehir, Bilecik
    ## 888                         Kocaeli, Sakarya, Düzce, Bolu, Yalova
    ## 889                                                        Ankara
    ## 890                                                Konya, Karaman
    ## 891                                      Antalya, Isparta, Burdur
    ## 892                                                 Adana, Mersin
    ## 893                                Hatay, Kahramanmaras, Osmaniye
    ## 894                 Kirikkale, Aksaray, Nigde, Nevsehir, Kirsehir
    ## 895                                        Kayseri, Sivas, Yozgat
    ## 896                                    Zonguldak, Karabük, Bartin
    ## 897                                     Kastamonu, Çankiri, Sinop
    ## 898                                  Samsun, Tokat, Çorum, Amasya
    ## 899               Trabzon, Ordu, Giresun, Rize, Artvin, Gümüshane
    ## 900                                    Erzurum, Erzincan, Bayburt
    ## 901                                    Agri, Kars, Igdir, Ardahan
    ## 902                              Malatya, Elazig, Bingöl, Tunceli
    ## 903                                     Van, Mus, Bitlis, Hakkari
    ## 904                                    Gaziantep, Adiyaman, Kilis
    ## 905                                         Sanliurfa, Diyarbakir
    ## 906                                 Mardin, Batman, Sirnak, Siirt
    ##           unit value          flag_notes
    ## 1   Percentage  53.6 break in timeseries
    ## 2   Percentage  59.9 break in timeseries
    ## 3   Percentage  57.9 break in timeseries
    ## 4   Percentage  62.4 break in timeseries
    ## 5   Percentage  65.9 break in timeseries
    ## 6   Percentage  63.8 break in timeseries
    ## 7   Percentage  60.0 break in timeseries
    ## 8   Percentage  50.5 break in timeseries
    ## 9   Percentage  56.6 break in timeseries
    ## 10  Percentage  60.3 break in timeseries
    ## 11  Percentage  57.4 break in timeseries
    ## 12  Percentage  70.4 break in timeseries
    ## 13  Percentage  57.9 break in timeseries
    ## 14  Percentage  56.8 break in timeseries
    ## 15  Percentage  53.9 break in timeseries
    ## 16  Percentage  62.0 break in timeseries
    ## 17  Percentage  61.2 break in timeseries
    ## 18  Percentage  69.0 break in timeseries
    ## 19  Percentage  67.9 break in timeseries
    ## 20  Percentage  71.2 break in timeseries
    ## 21  Percentage  66.3 break in timeseries
    ## 22  Percentage  74.6 break in timeseries
    ## 23  Percentage  65.9 break in timeseries
    ## 24  Percentage  69.4 break in timeseries
    ## 25  Percentage  70.4 break in timeseries
    ## 26  Percentage  75.5 break in timeseries
    ## 27  Percentage  71.4 break in timeseries
    ## 28  Percentage  75.5 break in timeseries
    ## 29  Percentage  73.1 break in timeseries
    ## 30  Percentage  66.4 break in timeseries
    ## 31  Percentage  74.5 break in timeseries
    ## 32  Percentage  75.6 break in timeseries
    ## 33  Percentage  74.1 break in timeseries
    ## 34  Percentage  64.6 break in timeseries
    ## 35  Percentage  72.1 break in timeseries
    ## 36  Percentage  78.9 break in timeseries
    ## 37  Percentage  77.0 break in timeseries
    ## 38  Percentage  75.7 break in timeseries
    ## 39  Percentage  73.8 break in timeseries
    ## 40  Percentage  77.5 break in timeseries
    ## 41  Percentage  74.6 break in timeseries
    ## 42  Percentage  67.3 break in timeseries
    ## 43  Percentage  72.6 break in timeseries
    ## 44  Percentage  62.9 break in timeseries
    ## 45  Percentage  68.9 break in timeseries
    ## 46  Percentage  70.5 break in timeseries
    ## 47  Percentage  62.3 break in timeseries
    ## 48  Percentage  63.1 break in timeseries
    ## 49  Percentage  60.9 break in timeseries
    ## 50  Percentage  56.0 break in timeseries
    ## 51  Percentage  61.2 break in timeseries
    ## 52  Percentage  59.0 break in timeseries
    ## 53  Percentage  48.7 break in timeseries
    ## 54  Percentage  60.2 break in timeseries
    ## 55  Percentage  56.3 break in timeseries
    ## 56  Percentage  53.4 break in timeseries
    ## 57  Percentage  58.4 break in timeseries
    ## 58  Percentage  56.7 break in timeseries
    ## 59  Percentage  51.7 break in timeseries
    ## 60  Percentage  49.6 break in timeseries
    ## 61  Percentage  50.7 break in timeseries
    ## 62  Percentage  55.9 break in timeseries
    ## 63  Percentage  52.5 break in timeseries
    ## 64  Percentage  50.5 break in timeseries
    ## 65  Percentage  53.0 break in timeseries
    ## 66  Percentage  67.2 break in timeseries
    ## 67  Percentage  79.0 break in timeseries
    ## 68  Percentage  53.9 break in timeseries
    ## 69  Percentage  60.0 break in timeseries
    ## 70  Percentage  60.0 break in timeseries
    ## 71  Percentage  64.9 break in timeseries
    ## 72  Percentage  65.7 break in timeseries
    ## 73  Percentage  64.6 break in timeseries
    ## 74  Percentage  59.1 break in timeseries
    ## 75  Percentage  52.3 break in timeseries
    ## 76  Percentage  56.0 break in timeseries
    ## 77  Percentage  61.4 break in timeseries
    ## 78  Percentage  57.1 break in timeseries
    ## 79  Percentage  55.5 break in timeseries
    ## 80  Percentage  59.5 break in timeseries
    ## 81  Percentage  55.6 break in timeseries
    ## 82  Percentage  54.1 break in timeseries
    ## 83  Percentage  55.4 break in timeseries
    ## 84  Percentage  53.7 break in timeseries
    ## 85  Percentage  62.6 break in timeseries
    ## 86  Percentage  55.1 break in timeseries
    ## 87  Percentage  53.2 break in timeseries
    ## 88  Percentage  60.9 break in timeseries
    ## 89  Percentage  55.8 break in timeseries
    ## 90  Percentage  53.4 break in timeseries
    ## 91  Percentage  59.1 break in timeseries
    ## 92  Percentage  64.8 break in timeseries
    ## 93  Percentage  56.0 break in timeseries
    ## 94  Percentage  50.0 break in timeseries
    ## 95  Percentage  56.2 break in timeseries
    ## 96  Percentage  59.8 break in timeseries
    ## 97  Percentage  64.4 break in timeseries
    ## 98  Percentage  60.3 break in timeseries
    ## 99  Percentage  61.5 break in timeseries
    ## 100 Percentage  62.0 break in timeseries
    ## 101 Percentage  56.1 break in timeseries
    ## 102 Percentage  55.6 break in timeseries
    ## 103 Percentage  50.6 break in timeseries
    ## 104 Percentage  65.3 break in timeseries
    ## 105 Percentage  60.0 break in timeseries
    ## 106 Percentage  67.0 break in timeseries
    ## 107 Percentage  48.0 break in timeseries
    ## 108 Percentage  57.5 break in timeseries
    ## 109 Percentage  47.9 break in timeseries
    ## 110 Percentage  48.8 break in timeseries
    ## 111 Percentage  55.4 break in timeseries
    ## 112 Percentage  60.4 break in timeseries
    ## 113 Percentage  59.5 break in timeseries
    ## 114 Percentage  62.7 break in timeseries
    ## 115 Percentage  52.6 break in timeseries
    ## 116 Percentage  49.7 break in timeseries
    ## 117 Percentage  49.2 break in timeseries
    ## 118 Percentage  55.6 break in timeseries
    ## 119 Percentage  53.7 break in timeseries
    ## 120 Percentage  59.0 break in timeseries
    ## 121 Percentage  59.9 break in timeseries
    ## 122 Percentage  48.5 break in timeseries
    ## 123 Percentage  57.7 break in timeseries
    ## 124 Percentage  55.2 break in timeseries
    ## 125 Percentage  49.8 break in timeseries
    ## 126 Percentage  58.4 break in timeseries
    ## 127 Percentage  53.7 break in timeseries
    ## 128 Percentage  50.4 break in timeseries
    ## 129 Percentage  49.8 break in timeseries
    ## 130 Percentage  48.1 break in timeseries
    ## 131 Percentage  52.8 break in timeseries
    ## 132 Percentage  51.8 break in timeseries
    ## 133 Percentage  49.3 break in timeseries
    ## 134 Percentage  53.3 break in timeseries
    ## 135 Percentage  79.3 break in timeseries
    ## 136 Percentage  73.0 break in timeseries
    ## 137 Percentage  75.8 break in timeseries
    ## 138 Percentage  71.3 break in timeseries
    ## 139 Percentage  75.2 break in timeseries
    ## 140 Percentage  71.4 break in timeseries
    ## 141 Percentage  70.5 break in timeseries
    ## 142 Percentage  71.0 break in timeseries
    ## 143 Percentage  59.6 break in timeseries
    ## 144 Percentage  60.6 break in timeseries
    ## 145 Percentage  68.8 break in timeseries
    ## 146 Percentage  69.5 break in timeseries
    ## 147 Percentage  73.2 break in timeseries
    ## 148 Percentage  68.0 break in timeseries
    ## 149 Percentage  65.4 break in timeseries
    ## 150 Percentage  62.4 break in timeseries
    ## 151 Percentage  66.9 break in timeseries
    ## 152 Percentage  58.1 break in timeseries
    ## 153 Percentage  58.0 break in timeseries
    ## 154 Percentage  60.9 break in timeseries
    ## 155 Percentage  56.0 break in timeseries
    ## 156 Percentage  58.4 break in timeseries
    ## 157 Percentage  56.6 break in timeseries
    ## 158 Percentage  62.4 break in timeseries
    ## 159 Percentage  57.8 break in timeseries
    ## 160 Percentage  48.4 break in timeseries
    ## 161 Percentage  50.5 break in timeseries
    ## 162 Percentage  50.9 break in timeseries
    ## 163 Percentage  52.7 break in timeseries
    ## 164 Percentage  58.1 break in timeseries
    ## 165 Percentage  52.4 break in timeseries
    ## 166 Percentage  66.3 break in timeseries
    ## 167 Percentage  65.0 break in timeseries
    ## 168 Percentage  63.7 break in timeseries
    ## 169 Percentage  61.0 break in timeseries
    ## 170 Percentage  67.8 break in timeseries
    ## 171 Percentage  64.2 break in timeseries
    ## 172 Percentage  68.4 break in timeseries
    ## 173 Percentage  58.0 break in timeseries
    ## 174 Percentage  60.7 break in timeseries
    ## 175 Percentage  66.4 break in timeseries
    ## 176 Percentage  67.5 break in timeseries
    ## 177 Percentage  65.9 break in timeseries
    ## 178 Percentage  65.9 break in timeseries
    ## 179 Percentage  62.5 break in timeseries
    ## 180 Percentage  64.2 break in timeseries
    ## 181 Percentage  64.3 break in timeseries
    ## 182 Percentage  68.4 break in timeseries
    ## 183 Percentage  65.2 break in timeseries
    ## 184 Percentage  64.8 break in timeseries
    ## 185 Percentage  56.8 break in timeseries
    ## 186 Percentage  59.7 break in timeseries
    ## 187 Percentage  45.4 break in timeseries
    ## 188 Percentage  48.6 break in timeseries
    ## 189 Percentage  43.5 break in timeseries
    ## 190 Percentage  40.1 break in timeseries
    ## 191 Percentage  62.2 break in timeseries
    ## 192 Percentage  53.3 break in timeseries
    ## 193 Percentage  55.9 break in timeseries
    ## 194 Percentage  53.8 break in timeseries
    ## 195 Percentage  47.3 break in timeseries
    ## 196 Percentage  55.8 break in timeseries
    ## 197 Percentage  51.1 break in timeseries
    ## 198 Percentage  51.0 break in timeseries
    ## 199 Percentage  54.1 break in timeseries
    ## 200 Percentage  54.7 break in timeseries
    ## 201 Percentage  46.4 break in timeseries
    ## 202 Percentage  46.2 break in timeseries
    ## 203 Percentage  47.2 break in timeseries
    ## 204 Percentage  48.1 break in timeseries
    ## 205 Percentage  51.9 break in timeseries
    ## 206 Percentage  46.0 break in timeseries
    ## 207 Percentage  49.4 break in timeseries
    ## 208 Percentage  56.8 break in timeseries
    ## 209 Percentage  56.1 break in timeseries
    ## 210 Percentage  62.7 break in timeseries
    ## 211 Percentage  57.2 break in timeseries
    ## 212 Percentage  59.8 break in timeseries
    ## 213 Percentage  56.2 break in timeseries
    ## 214 Percentage  62.3 break in timeseries
    ## 215 Percentage  56.7 break in timeseries
    ## 216 Percentage  68.8 break in timeseries
    ## 217 Percentage  58.7 break in timeseries
    ## 218 Percentage  55.4 break in timeseries
    ## 219 Percentage  54.4 break in timeseries
    ## 220 Percentage  84.3 break in timeseries
    ## 221 Percentage  59.3 break in timeseries
    ## 222 Percentage  56.6 break in timeseries
    ## 223 Percentage  54.1 break in timeseries
    ## 224 Percentage  61.7 break in timeseries
    ## 225 Percentage  58.2 break in timeseries
    ## 226 Percentage  61.6 break in timeseries
    ## 227 Percentage  54.8 break in timeseries
    ## 228 Percentage  56.5 break in timeseries
    ## 229 Percentage  62.8 break in timeseries
    ## 230 Percentage  60.4 break in timeseries
    ## 231 Percentage  55.5 break in timeseries
    ## 232 Percentage  61.5 break in timeseries
    ## 233 Percentage  64.7 break in timeseries
    ## 234 Percentage  63.5 break in timeseries
    ## 235 Percentage  68.1 break in timeseries
    ## 236 Percentage  60.7 break in timeseries
    ## 237 Percentage  65.4 break in timeseries
    ## 238 Percentage  69.5 break in timeseries
    ## 239 Percentage  65.3 break in timeseries
    ## 240 Percentage  64.2 break in timeseries
    ## 241 Percentage  63.0 break in timeseries
    ## 242 Percentage  63.2 break in timeseries
    ## 243 Percentage  62.3 break in timeseries
    ## 244 Percentage  59.5 break in timeseries
    ## 245 Percentage  55.7 break in timeseries
    ## 246 Percentage  53.1 break in timeseries
    ## 247 Percentage  45.8 break in timeseries
    ## 248 Percentage  45.5 break in timeseries
    ## 249 Percentage  49.1 break in timeseries
    ## 250 Percentage  45.3 break in timeseries
    ## 251 Percentage  44.0 break in timeseries
    ## 252 Percentage  52.4 break in timeseries
    ## 253 Percentage  53.4 break in timeseries
    ## 254 Percentage  64.9 break in timeseries
    ## 255 Percentage  67.2 break in timeseries
    ## 256 Percentage  61.7 break in timeseries
    ## 257 Percentage  61.7 break in timeseries
    ## 258 Percentage  64.4 break in timeseries
    ## 259 Percentage  67.2 break in timeseries
    ## 260 Percentage  67.3 break in timeseries
    ## 261 Percentage  67.2 break in timeseries
    ## 262 Percentage  69.5 break in timeseries
    ## 263 Percentage  52.9 break in timeseries
    ## 264 Percentage  55.4 break in timeseries
    ## 265 Percentage  55.0 break in timeseries
    ## 266 Percentage  48.4 break in timeseries
    ## 267 Percentage  53.5 break in timeseries
    ## 268 Percentage  51.0 break in timeseries
    ## 269 Percentage  49.3 break in timeseries
    ## 270 Percentage  57.0 break in timeseries
    ## 271 Percentage  54.1 break in timeseries
    ## 272 Percentage  48.9 break in timeseries
    ## 273 Percentage  46.9 break in timeseries
    ## 274 Percentage  46.1 break in timeseries
    ## 275 Percentage  49.4 break in timeseries
    ## 276 Percentage  51.9 break in timeseries
    ## 277 Percentage  45.9 break in timeseries
    ## 278 Percentage  49.2 break in timeseries
    ## 279 Percentage  65.9 break in timeseries
    ## 280 Percentage  65.7 break in timeseries
    ## 281 Percentage  74.2 break in timeseries
    ## 282 Percentage  69.0 break in timeseries
    ## 283 Percentage  71.4 break in timeseries
    ## 284 Percentage  72.2 break in timeseries
    ## 285 Percentage  77.1 break in timeseries
    ## 286 Percentage  68.0 break in timeseries
    ## 287 Percentage  70.7 break in timeseries
    ## 288 Percentage  71.0 break in timeseries
    ## 289 Percentage  75.9 break in timeseries
    ## 290 Percentage  74.7 break in timeseries
    ## 291 Percentage  74.2 break in timeseries
    ## 292 Percentage  73.5 break in timeseries
    ## 293 Percentage  67.4 break in timeseries
    ## 294 Percentage  75.7 break in timeseries
    ## 295 Percentage  78.3 break in timeseries
    ## 296 Percentage  73.9 break in timeseries
    ## 297 Percentage  63.8 break in timeseries
    ## 298 Percentage  71.6 break in timeseries
    ## 299 Percentage  76.3 break in timeseries
    ## 300 Percentage  76.3 break in timeseries
    ## 301 Percentage  76.1 break in timeseries
    ## 302 Percentage  72.0 break in timeseries
    ## 303 Percentage  75.0 break in timeseries
    ## 304 Percentage  77.2 break in timeseries
    ## 305 Percentage  73.8 break in timeseries
    ## 306 Percentage  73.2 break in timeseries
    ## 307 Percentage  66.6 break in timeseries
    ## 308 Percentage  73.7 break in timeseries
    ## 309 Percentage  74.5 break in timeseries
    ## 310 Percentage  66.7 break in timeseries
    ## 311 Percentage  75.9 break in timeseries
    ## 312 Percentage  72.2 break in timeseries
    ## 313 Percentage  63.8 break in timeseries
    ## 314 Percentage  54.8 break in timeseries
    ## 315 Percentage  63.5 break in timeseries
    ## 316 Percentage  60.5 break in timeseries
    ## 317 Percentage  66.7 break in timeseries
    ## 318 Percentage  67.5 break in timeseries
    ## 319 Percentage  65.7 break in timeseries
    ## 320 Percentage  60.0 break in timeseries
    ## 321 Percentage  52.9 break in timeseries
    ## 322 Percentage  56.1 break in timeseries
    ## 323 Percentage  61.1 break in timeseries
    ## 324 Percentage  59.1 break in timeseries
    ## 325 Percentage  49.4 break in timeseries
    ## 326 Percentage  52.5 break in timeseries
    ## 327 Percentage  55.6 break in timeseries
    ## 328 Percentage  55.3 break in timeseries
    ## 329 Percentage  61.5 break in timeseries
    ## 330 Percentage  54.0 break in timeseries
    ## 331 Percentage  71.3 break in timeseries
    ## 332 Percentage  67.0 break in timeseries
    ## 333 Percentage  67.8 break in timeseries
    ## 334 Percentage  61.5 break in timeseries
    ## 335 Percentage  65.7 break in timeseries
    ## 336 Percentage  64.1 break in timeseries
    ## 337 Percentage  62.1 break in timeseries
    ## 338 Percentage  59.3 break in timeseries
    ## 339 Percentage  70.1 break in timeseries
    ## 340 Percentage  69.0 break in timeseries
    ## 341 Percentage  71.1 break in timeseries
    ## 342 Percentage  70.2 break in timeseries
    ## 343 Percentage  71.2 break in timeseries
    ## 344 Percentage  71.6 break in timeseries
    ## 345 Percentage  70.4 break in timeseries
    ## 346 Percentage  68.4 break in timeseries
    ## 347 Percentage  68.7 break in timeseries
    ## 348 Percentage  69.0 break in timeseries
    ## 349 Percentage  70.0 break in timeseries
    ## 350 Percentage  58.6 break in timeseries
    ## 351 Percentage  62.7 break in timeseries
    ## 352 Percentage  59.2 break in timeseries
    ## 353 Percentage  66.5 break in timeseries
    ## 354 Percentage  67.2 break in timeseries
    ## 355 Percentage  66.9 break in timeseries
    ## 356 Percentage  65.9 break in timeseries
    ## 357 Percentage  60.8 break in timeseries
    ## 358 Percentage  62.4 break in timeseries
    ## 359 Percentage  64.8 break in timeseries
    ## 360 Percentage  65.3 break in timeseries
    ## 361 Percentage  64.8 break in timeseries
    ## 362 Percentage  63.0 break in timeseries
    ## 363 Percentage  63.6 break in timeseries
    ## 364 Percentage  63.1 break in timeseries
    ## 365 Percentage  66.7 break in timeseries
    ## 366 Percentage  61.5 break in timeseries
    ## 367 Percentage  68.0 break in timeseries
    ## 368 Percentage  67.7 break in timeseries
    ## 369 Percentage  66.0 break in timeseries
    ## 370 Percentage  62.3 break in timeseries
    ## 371 Percentage  62.9 break in timeseries
    ## 372 Percentage  64.0 break in timeseries
    ## 373 Percentage  60.9 break in timeseries
    ## 374 Percentage  60.4 break in timeseries
    ## 375 Percentage  66.4 break in timeseries
    ## 376 Percentage  62.4 break in timeseries
    ## 377 Percentage  64.8 break in timeseries
    ## 378 Percentage  66.1 break in timeseries
    ## 379 Percentage  68.2 break in timeseries
    ## 380 Percentage  59.4 break in timeseries
    ## 381 Percentage  57.3 break in timeseries
    ## 382 Percentage  52.1 break in timeseries
    ## 383 Percentage  60.7 break in timeseries
    ## 384 Percentage  56.7 break in timeseries
    ## 385 Percentage  64.0 break in timeseries
    ## 386 Percentage  55.9 break in timeseries
    ## 387 Percentage  59.8 break in timeseries
    ## 388 Percentage  63.9 break in timeseries
    ## 389 Percentage  60.6 break in timeseries
    ## 390 Percentage  56.2 break in timeseries
    ## 391 Percentage  60.2 break in timeseries
    ## 392 Percentage  64.1 break in timeseries
    ## 393 Percentage  61.2 break in timeseries
    ## 394 Percentage  56.0 break in timeseries
    ## 395 Percentage  62.2 break in timeseries
    ## 396 Percentage  65.7 break in timeseries
    ## 397 Percentage  69.4 break in timeseries
    ## 398 Percentage  69.4 break in timeseries
    ## 399 Percentage  68.6 break in timeseries
    ## 400 Percentage  69.1 break in timeseries
    ## 401 Percentage  62.7 break in timeseries
    ## 402 Percentage  61.7 break in timeseries
    ## 403 Percentage  54.4 break in timeseries
    ## 404 Percentage  69.8 break in timeseries
    ## 405 Percentage  64.4 break in timeseries
    ## 406 Percentage  68.3 break in timeseries
    ## 407 Percentage  55.7 break in timeseries
    ## 408 Percentage  63.0 break in timeseries
    ## 409 Percentage  53.7 break in timeseries
    ## 410 Percentage  52.0 break in timeseries
    ## 411 Percentage  59.9 break in timeseries
    ## 412 Percentage  65.6 break in timeseries
    ## 413 Percentage  62.2 break in timeseries
    ## 414 Percentage  61.9 break in timeseries
    ## 415 Percentage  65.0 break in timeseries
    ## 416 Percentage  67.3 break in timeseries
    ## 417 Percentage  63.4 break in timeseries
    ## 418 Percentage  64.9 break in timeseries
    ## 419 Percentage  58.2 break in timeseries
    ## 420 Percentage  62.8 break in timeseries
    ## 421 Percentage  67.8 break in timeseries
    ## 422 Percentage  63.9 break in timeseries
    ## 423 Percentage  65.9 break in timeseries
    ## 424 Percentage  63.6 break in timeseries
    ## 425 Percentage  65.0 break in timeseries
    ## 426 Percentage  63.2 break in timeseries
    ## 427 Percentage  66.9 break in timeseries
    ## 428 Percentage  67.5 break in timeseries
    ## 429 Percentage  65.5 break in timeseries
    ## 430 Percentage  66.6 break in timeseries
    ## 431 Percentage  56.8 break in timeseries
    ## 432 Percentage  58.5 break in timeseries
    ## 433 Percentage  53.9 break in timeseries
    ## 434 Percentage  45.0 break in timeseries
    ## 435 Percentage  47.7 break in timeseries
    ## 436 Percentage  42.7 break in timeseries
    ## 437 Percentage  40.9 break in timeseries
    ## 438 Percentage  64.0 break in timeseries
    ## 439 Percentage  66.5 break in timeseries
    ## 440 Percentage  61.0 break in timeseries
    ## 441 Percentage  65.5 break in timeseries
    ## 442 Percentage  69.1 break in timeseries
    ## 443 Percentage  65.1 break in timeseries
    ## 444 Percentage  64.7 break in timeseries
    ## 445 Percentage  63.2 break in timeseries
    ## 446 Percentage  68.5 break in timeseries
    ## 447 Percentage  63.8 break in timeseries
    ## 448 Percentage  61.7 break in timeseries
    ## 449 Percentage  63.5 break in timeseries
    ## 450 Percentage  58.6 break in timeseries
    ## 451 Percentage  57.1 break in timeseries
    ## 452 Percentage  51.3 break in timeseries
    ## 453 Percentage  44.2 break in timeseries
    ## 454 Percentage  44.5 break in timeseries
    ## 455 Percentage  49.3 break in timeseries
    ## 456 Percentage  44.6 break in timeseries
    ## 457 Percentage  44.2 break in timeseries
    ## 458 Percentage  51.5 break in timeseries
    ## 459 Percentage  68.5 break in timeseries
    ## 460 Percentage  62.1 break in timeseries
    ## 461 Percentage  62.9 break in timeseries
    ## 462 Percentage  63.6 break in timeseries
    ## 463 Percentage  63.3 break in timeseries
    ## 464 Percentage  60.2 break in timeseries
    ## 465 Percentage  62.1 break in timeseries
    ## 466 Percentage  53.4 break in timeseries
    ## 467 Percentage  49.5 break in timeseries
    ## 468 Percentage  50.2 break in timeseries
    ## 469 Percentage  53.8 break in timeseries
    ## 470 Percentage  53.6 break in timeseries
    ## 471 Percentage  69.4 break in timeseries
    ## 472 Percentage  71.9 break in timeseries
    ## 473 Percentage  72.2 break in timeseries
    ## 474 Percentage  72.9 break in timeseries
    ## 475 Percentage  73.7 break in timeseries
    ## 476 Percentage  73.5 break in timeseries
    ## 477 Percentage  75.9 break in timeseries
    ## 478 Percentage  73.7 break in timeseries
    ## 479 Percentage  73.0 break in timeseries
    ## 480 Percentage  73.1 break in timeseries
    ## 481 Percentage  74.3 break in timeseries
    ## 482 Percentage  70.1 break in timeseries
    ## 483 Percentage  68.4 break in timeseries
    ## 484 Percentage  68.7 break in timeseries
    ## 485 Percentage  62.3 break in timeseries
    ## 486 Percentage  64.9 break in timeseries
    ## 487 Percentage  67.7 break in timeseries
    ## 488 Percentage  69.7 break in timeseries
    ## 489 Percentage  70.5 break in timeseries
    ## 490 Percentage  69.4 break in timeseries
    ## 491 Percentage  70.1 break in timeseries
    ## 492 Percentage  54.1 break in timeseries
    ## 493 Percentage  57.6 break in timeseries
    ## 494 Percentage  55.0 break in timeseries
    ## 495 Percentage  49.5 break in timeseries
    ## 496 Percentage  56.0 break in timeseries
    ## 497 Percentage  52.3 break in timeseries
    ## 498 Percentage  51.6 break in timeseries
    ## 499 Percentage  56.9 break in timeseries
    ## 500 Percentage  54.0 break in timeseries
    ## 501 Percentage  48.3 break in timeseries
    ## 502 Percentage  51.1 break in timeseries
    ## 503 Percentage  49.3 break in timeseries
    ## 504 Percentage  52.5 break in timeseries
    ## 505 Percentage  51.5 break in timeseries
    ## 506 Percentage  48.7 break in timeseries
    ## 507 Percentage  51.0 break in timeseries
    ## 508 Percentage  65.8 break in timeseries
    ## 509 Percentage  68.0 break in timeseries
    ## 510 Percentage  71.4 break in timeseries
    ## 511 Percentage  66.4 break in timeseries
    ## 512 Percentage  66.9 break in timeseries
    ## 513 Percentage  63.0 break in timeseries
    ## 514 Percentage  67.4 break in timeseries
    ## 515 Percentage  55.9 break in timeseries
    ## 516 Percentage  54.1 break in timeseries
    ## 517 Percentage  61.4 break in timeseries
    ## 518 Percentage  54.6 break in timeseries
    ## 519 Percentage  57.9 break in timeseries
    ## 520 Percentage  59.3 break in timeseries
    ## 521 Percentage  60.1 break in timeseries
    ## 522 Percentage  56.5 break in timeseries
    ## 523 Percentage  64.4 break in timeseries
    ## 524 Percentage  67.8 break in timeseries
    ## 525 Percentage  69.6 break in timeseries
    ## 526 Percentage  60.6 break in timeseries
    ## 527 Percentage  55.2 break in timeseries
    ## 528 Percentage  51.5 break in timeseries
    ## 529 Percentage  67.0 break in timeseries
    ## 530 Percentage  74.3 break in timeseries
    ## 531 Percentage  68.3 break in timeseries
    ## 532 Percentage  62.8 break in timeseries
    ## 533 Percentage  77.2 break in timeseries
    ## 534 Percentage  75.1 break in timeseries
    ## 535 Percentage  71.0 break in timeseries
    ## 536 Percentage  75.2 break in timeseries
    ## 537 Percentage  69.8 break in timeseries
    ## 538 Percentage  73.1 break in timeseries
    ## 539 Percentage  70.3 break in timeseries
    ## 540 Percentage  72.3 break in timeseries
    ## 541 Percentage  70.8 break in timeseries
    ## 542 Percentage  66.8 break in timeseries
    ## 543 Percentage  67.3 break in timeseries
    ## 544 Percentage  76.8 break in timeseries
    ## 545 Percentage  69.7 break in timeseries
    ## 546 Percentage  70.6 break in timeseries
    ## 547 Percentage  74.2 break in timeseries
    ## 548 Percentage  66.4 break in timeseries
    ## 549 Percentage  68.2 break in timeseries
    ## 550 Percentage  76.5 break in timeseries
    ## 551 Percentage  68.4 break in timeseries
    ## 552 Percentage  72.0 break in timeseries
    ## 553 Percentage  72.6 break in timeseries
    ## 554 Percentage  74.9 break in timeseries
    ## 555 Percentage  73.3 break in timeseries
    ## 556 Percentage  76.7 break in timeseries
    ## 557 Percentage  73.6 break in timeseries
    ## 558 Percentage  67.2 break in timeseries
    ## 559 Percentage  75.1 break in timeseries
    ## 560 Percentage  76.3 break in timeseries
    ## 561 Percentage  75.0 break in timeseries
    ## 562 Percentage  63.2 break in timeseries
    ## 563 Percentage  70.3 break in timeseries
    ## 564 Percentage  78.2 break in timeseries
    ## 565 Percentage  75.6 break in timeseries
    ## 566 Percentage  75.0 break in timeseries
    ## 567 Percentage  74.5 break in timeseries
    ## 568 Percentage  78.0 break in timeseries
    ## 569 Percentage  74.7 break in timeseries
    ## 570 Percentage  72.4 break in timeseries
    ## 571 Percentage  73.3 break in timeseries
    ## 572 Percentage  66.6 break in timeseries
    ## 573 Percentage  71.6 break in timeseries
    ## 574 Percentage  73.6 break in timeseries
    ## 575 Percentage  69.3 break in timeseries
    ## 576 Percentage  77.1 break in timeseries
    ## 577 Percentage  75.6 break in timeseries
    ## 578 Percentage  66.2 break in timeseries
    ## 579 Percentage  83.8 break in timeseries
    ## 580 Percentage  76.0 break in timeseries
    ## 581 Percentage  73.8 break in timeseries
    ## 582 Percentage  74.1 break in timeseries
    ## 583 Percentage  74.8 break in timeseries
    ## 584 Percentage  75.7 break in timeseries
    ## 585 Percentage  74.1 break in timeseries
    ## 586 Percentage  73.5 break in timeseries
    ## 587 Percentage  72.8 break in timeseries
    ## 588 Percentage  78.6 break in timeseries
    ## 589 Percentage  77.2 break in timeseries
    ## 590 Percentage  79.0 break in timeseries
    ## 591 Percentage  79.0 break in timeseries
    ## 592 Percentage  80.5 break in timeseries
    ## 593 Percentage  68.2 break in timeseries
    ## 594 Percentage  76.9 break in timeseries
    ## 595 Percentage  73.1 break in timeseries
    ## 596 Percentage  73.4 break in timeseries
    ## 597 Percentage  75.6 break in timeseries
    ## 598 Percentage  77.7 break in timeseries
    ## 599 Percentage  74.5 break in timeseries
    ## 600 Percentage  73.6 break in timeseries
    ## 601 Percentage  67.7 break in timeseries
    ## 602 Percentage  69.7 break in timeseries
    ## 603 Percentage  64.2 break in timeseries
    ## 604 Percentage  71.2 break in timeseries
    ## 605 Percentage  71.5 break in timeseries
    ## 606 Percentage  64.5 break in timeseries
    ## 607 Percentage  67.4 break in timeseries
    ## 608 Percentage  70.0 break in timeseries
    ## 609 Percentage  72.8 break in timeseries
    ## 610 Percentage  72.4 break in timeseries
    ## 611 Percentage  72.0 break in timeseries
    ## 612 Percentage  71.8 break in timeseries
    ## 613 Percentage  68.1 break in timeseries
    ## 614 Percentage  68.2 break in timeseries
    ## 615 Percentage  74.3 break in timeseries
    ## 616 Percentage  68.9 break in timeseries
    ## 617 Percentage  70.6 break in timeseries
    ## 618 Percentage  74.9 break in timeseries
    ## 619 Percentage  64.3 break in timeseries
    ## 620 Percentage  72.0 break in timeseries
    ## 621 Percentage  74.1 break in timeseries
    ## 622 Percentage  66.9 break in timeseries
    ## 623 Percentage  70.1 break in timeseries
    ## 624 Percentage  70.1 break in timeseries
    ## 625 Percentage  74.8 break in timeseries
    ## 626 Percentage  72.2 break in timeseries
    ## 627 Percentage  76.0 break in timeseries
    ## 628 Percentage  72.3 break in timeseries
    ## 629 Percentage  65.6 break in timeseries
    ## 630 Percentage  74.7 break in timeseries
    ## 631 Percentage  73.5 break in timeseries
    ## 632 Percentage  74.3 break in timeseries
    ## 633 Percentage  65.1 break in timeseries
    ## 634 Percentage  70.1 break in timeseries
    ## 635 Percentage  77.6 break in timeseries
    ## 636 Percentage  76.1 break in timeseries
    ## 637 Percentage  75.4 break in timeseries
    ## 638 Percentage  73.3 break in timeseries
    ## 639 Percentage  77.6 break in timeseries
    ## 640 Percentage  75.4 break in timeseries
    ## 641 Percentage  69.3 break in timeseries
    ## 642 Percentage  72.5 break in timeseries
    ## 643 Percentage  67.1 break in timeseries
    ## 644 Percentage  71.2 break in timeseries
    ## 645 Percentage  74.2 break in timeseries
    ## 646 Percentage  70.7 break in timeseries
    ## 647 Percentage  77.4 break in timeseries
    ## 648 Percentage  78.9 break in timeseries
    ## 649 Percentage  67.0 break in timeseries
    ## 650 Percentage  59.3 break in timeseries
    ## 651 Percentage  58.6 break in timeseries
    ## 652 Percentage  62.0 break in timeseries
    ## 653 Percentage  62.3 break in timeseries
    ## 654 Percentage  71.0 break in timeseries
    ## 655 Percentage  62.4 break in timeseries
    ## 656 Percentage  70.3 break in timeseries
    ## 657 Percentage  76.5 break in timeseries
    ## 658 Percentage  70.7 break in timeseries
    ## 659 Percentage  65.4 break in timeseries
    ## 660 Percentage  82.5 break in timeseries
    ## 661 Percentage  66.4 break in timeseries
    ## 662 Percentage  67.6 break in timeseries
    ## 663 Percentage  75.1 break in timeseries
    ## 664 Percentage  68.0 break in timeseries
    ## 665 Percentage  70.2 break in timeseries
    ## 666 Percentage  73.5 break in timeseries
    ## 667 Percentage  63.5 break in timeseries
    ## 668 Percentage  71.0 break in timeseries
    ## 669 Percentage  77.0 break in timeseries
    ## 670 Percentage  66.1 break in timeseries
    ## 671 Percentage  69.9 break in timeseries
    ## 672 Percentage  72.1 break in timeseries
    ## 673 Percentage  72.9 break in timeseries
    ## 674 Percentage  73.8 break in timeseries
    ## 675 Percentage  75.8 break in timeseries
    ## 676 Percentage  73.6 break in timeseries
    ## 677 Percentage  63.8 break in timeseries
    ## 678 Percentage  75.0 break in timeseries
    ## 679 Percentage  75.0 break in timeseries
    ## 680 Percentage  72.9 break in timeseries
    ## 681 Percentage  67.6 break in timeseries
    ## 682 Percentage  70.4 break in timeseries
    ## 683 Percentage  78.0 break in timeseries
    ## 684 Percentage  75.7 break in timeseries
    ## 685 Percentage  76.7 break in timeseries
    ## 686 Percentage  73.4 break in timeseries
    ## 687 Percentage  76.0 break in timeseries
    ## 688 Percentage  76.2 break in timeseries
    ## 689 Percentage  70.3 break in timeseries
    ## 690 Percentage  75.2 break in timeseries
    ## 691 Percentage  66.2 break in timeseries
    ## 692 Percentage  72.4 break in timeseries
    ## 693 Percentage  74.6 break in timeseries
    ## 694 Percentage  69.1 break in timeseries
    ## 695 Percentage  77.9 break in timeseries
    ## 696 Percentage  78.2 break in timeseries
    ## 697 Percentage  66.6 break in timeseries
    ## 698 Percentage  59.3 break in timeseries
    ## 699 Percentage  62.9 break in timeseries
    ## 700 Percentage  59.6 break in timeseries
    ## 701 Percentage  58.1 break in timeseries
    ## 702 Percentage  57.7 break in timeseries
    ## 703 Percentage  61.5 break in timeseries
    ## 704 Percentage  59.7 break in timeseries
    ## 705 Percentage  65.4 break in timeseries
    ## 706 Percentage  57.6 break in timeseries
    ## 707 Percentage  59.1 break in timeseries
    ## 708 Percentage  66.3 break in timeseries
    ## 709 Percentage  62.1 break in timeseries
    ## 710 Percentage  56.6 break in timeseries
    ## 711 Percentage  60.8 break in timeseries
    ## 712 Percentage  63.5 break in timeseries
    ## 713 Percentage  69.0 break in timeseries
    ## 714 Percentage  65.2 break in timeseries
    ## 715 Percentage  54.9 break in timeseries
    ## 716 Percentage  55.3 break in timeseries
    ## 717 Percentage  56.8 break in timeseries
    ## 718 Percentage  59.1 break in timeseries
    ## 719 Percentage  66.7 break in timeseries
    ## 720 Percentage  57.4 break in timeseries
    ## 721 Percentage  73.8 break in timeseries
    ## 722 Percentage  72.4 break in timeseries
    ## 723 Percentage  75.9 break in timeseries
    ## 724 Percentage  74.9 break in timeseries
    ## 725 Percentage  75.7 break in timeseries
    ## 726 Percentage  75.5 break in timeseries
    ## 727 Percentage  73.7 break in timeseries
    ## 728 Percentage  72.1 break in timeseries
    ## 729 Percentage  73.8 break in timeseries
    ## 730 Percentage  73.6 break in timeseries
    ## 731 Percentage  75.8 break in timeseries
    ## 732 Percentage  66.1 break in timeseries
    ## 733 Percentage  73.2 break in timeseries
    ## 734 Percentage  66.1 break in timeseries
    ## 735 Percentage  71.7 break in timeseries
    ## 736 Percentage  71.9 break in timeseries
    ## 737 Percentage  69.9 break in timeseries
    ## 738 Percentage  70.7 break in timeseries
    ## 739 Percentage  70.7 break in timeseries
    ## 740 Percentage  68.7 break in timeseries
    ## 741 Percentage  69.3 break in timeseries
    ## 742 Percentage  72.7 break in timeseries
    ## 743 Percentage  71.0 break in timeseries
    ## 744 Percentage  67.6 break in timeseries
    ## 745 Percentage  68.2 break in timeseries
    ## 746 Percentage  68.6 break in timeseries
    ## 747 Percentage  69.4 break in timeseries
    ## 748 Percentage  66.5 break in timeseries
    ## 749 Percentage  72.9 break in timeseries
    ## 750 Percentage  75.6 break in timeseries
    ## 751 Percentage  70.8 break in timeseries
    ## 752 Percentage  67.4 break in timeseries
    ## 753 Percentage  72.9 break in timeseries
    ## 754 Percentage  71.8 break in timeseries
    ## 755 Percentage  71.0 break in timeseries
    ## 756 Percentage  71.3 break in timeseries
    ## 757 Percentage  71.3 break in timeseries
    ## 758 Percentage  73.6 break in timeseries
    ## 759 Percentage  71.6 break in timeseries
    ## 760 Percentage  73.5 break in timeseries
    ## 761 Percentage  72.8 break in timeseries
    ## 762 Percentage  75.8 break in timeseries
    ## 763 Percentage  75.4 break in timeseries
    ## 764 Percentage  74.7 break in timeseries
    ## 765 Percentage  77.7 break in timeseries
    ## 766 Percentage  75.6 break in timeseries
    ## 767 Percentage  73.5 break in timeseries
    ## 768 Percentage  74.7 break in timeseries
    ## 769 Percentage  75.9 break in timeseries
    ## 770 Percentage  70.7 break in timeseries
    ## 771 Percentage  61.0 break in timeseries
    ## 772 Percentage  64.0 break in timeseries
    ## 773 Percentage  59.3 break in timeseries
    ## 774 Percentage  56.8 break in timeseries
    ## 775 Percentage  59.0 break in timeseries
    ## 776 Percentage  57.4 break in timeseries
    ## 777 Percentage  58.8 break in timeseries
    ## 778 Percentage  58.9 break in timeseries
    ## 779 Percentage  60.5 break in timeseries
    ## 780 Percentage  53.4 break in timeseries
    ## 781 Percentage  56.9 break in timeseries
    ## 782 Percentage  57.5 break in timeseries
    ## 783 Percentage  58.3 break in timeseries
    ## 784 Percentage  56.6 break in timeseries
    ## 785 Percentage  55.6 break in timeseries
    ## 786 Percentage  58.8 break in timeseries
    ## 787 Percentage  59.8 break in timeseries
    ## 788 Percentage  54.1 break in timeseries
    ## 789 Percentage  64.6 break in timeseries
    ## 790 Percentage  57.1 break in timeseries
    ## 791 Percentage  61.0 break in timeseries
    ## 792 Percentage  64.1 break in timeseries
    ## 793 Percentage  60.8 break in timeseries
    ## 794 Percentage  58.3 break in timeseries
    ## 795 Percentage  53.8 break in timeseries
    ## 796 Percentage  63.8 break in timeseries
    ## 797 Percentage  65.1 break in timeseries
    ## 798 Percentage  67.4 break in timeseries
    ## 799 Percentage  68.0 break in timeseries
    ## 800 Percentage  67.4 break in timeseries
    ## 801 Percentage  62.0 break in timeseries
    ## 802 Percentage  53.8 break in timeseries
    ## 803 Percentage  57.0 break in timeseries
    ## 804 Percentage  62.1 break in timeseries
    ## 805 Percentage  58.7 break in timeseries
    ## 806 Percentage  53.6 break in timeseries
    ## 807 Percentage  54.9 break in timeseries
    ## 808 Percentage  55.8 break in timeseries
    ## 809 Percentage  57.7 break in timeseries
    ## 810 Percentage  65.0 break in timeseries
    ## 811 Percentage  55.5 break in timeseries
    ## 812 Percentage  71.5 break in timeseries
    ## 813 Percentage  68.1 break in timeseries
    ## 814 Percentage  67.8 break in timeseries
    ## 815 Percentage  62.8 break in timeseries
    ## 816 Percentage  65.1 break in timeseries
    ## 817 Percentage  64.9 break in timeseries
    ## 818 Percentage  63.7 break in timeseries
    ## 819 Percentage  62.2 break in timeseries
    ## 820 Percentage  75.4 break in timeseries
    ## 821 Percentage  73.8 break in timeseries
    ## 822 Percentage  77.5 break in timeseries
    ## 823 Percentage  76.7 break in timeseries
    ## 824 Percentage  77.1 break in timeseries
    ## 825 Percentage  76.4 break in timeseries
    ## 826 Percentage  75.1 break in timeseries
    ## 827 Percentage  75.0 break in timeseries
    ## 828 Percentage  75.9 break in timeseries
    ## 829 Percentage  75.1 break in timeseries
    ## 830 Percentage  76.1 break in timeseries
    ## 831 Percentage  67.3 break in timeseries
    ## 832 Percentage  74.3 break in timeseries
    ## 833 Percentage  67.1 break in timeseries
    ## 834 Percentage  73.5 break in timeseries
    ## 835 Percentage  73.4 break in timeseries
    ## 836 Percentage  71.9 break in timeseries
    ## 837 Percentage  73.3 break in timeseries
    ## 838 Percentage  71.4 break in timeseries
    ## 839 Percentage  70.7 break in timeseries
    ## 840 Percentage  70.5 break in timeseries
    ## 841 Percentage  74.2 break in timeseries
    ## 842 Percentage  72.9 break in timeseries
    ## 843 Percentage  69.2 break in timeseries
    ## 844 Percentage  69.3 break in timeseries
    ## 845 Percentage  70.3 break in timeseries
    ## 846 Percentage  71.3 break in timeseries
    ## 847 Percentage  68.6 break in timeseries
    ## 848 Percentage  73.8 break in timeseries
    ## 849 Percentage  74.8 break in timeseries
    ## 850 Percentage  71.6 break in timeseries
    ## 851 Percentage  68.4 break in timeseries
    ## 852 Percentage  74.6 break in timeseries
    ## 853 Percentage  73.6 break in timeseries
    ## 854 Percentage  72.2 break in timeseries
    ## 855 Percentage  72.9 break in timeseries
    ## 856 Percentage  72.7 break in timeseries
    ## 857 Percentage  74.9 break in timeseries
    ## 858 Percentage  70.5 break in timeseries
    ## 859 Percentage  73.0 break in timeseries
    ## 860 Percentage  71.8 break in timeseries
    ## 861 Percentage  75.4 break in timeseries
    ## 862 Percentage  74.9 break in timeseries
    ## 863 Percentage  74.2 break in timeseries
    ## 864 Percentage  77.1 break in timeseries
    ## 865 Percentage  75.0 break in timeseries
    ## 866 Percentage  72.9 break in timeseries
    ## 867 Percentage  73.9 break in timeseries
    ## 868 Percentage  75.3 break in timeseries
    ## 869 Percentage  71.0 break in timeseries
    ## 870 Percentage  62.9 break in timeseries
    ## 871 Percentage  64.2 break in timeseries
    ## 872 Percentage  65.7 break in timeseries
    ## 873 Percentage  63.8 break in timeseries
    ## 874 Percentage  64.2 break in timeseries
    ## 875 Percentage  60.6 break in timeseries
    ## 876 Percentage  61.7 break in timeseries
    ## 877 Percentage  70.3 break in timeseries
    ## 878 Percentage  61.8 break in timeseries
    ## 879 Percentage  57.6 break in timeseries
    ## 880 Percentage  53.7 break in timeseries
    ## 881 Percentage  49.7 break in timeseries
    ## 882 Percentage  57.5 break in timeseries
    ## 883 Percentage  52.4 break in timeseries
    ## 884 Percentage  51.3 break in timeseries
    ## 885 Percentage  56.5 break in timeseries
    ## 886 Percentage  56.4 break in timeseries
    ## 887 Percentage  50.6 break in timeseries
    ## 888 Percentage  52.9 break in timeseries
    ## 889 Percentage  49.6 break in timeseries
    ## 890 Percentage  50.6 break in timeseries
    ## 891 Percentage  56.5 break in timeseries
    ## 892 Percentage  47.5 break in timeseries
    ## 893 Percentage  40.3 break in timeseries
    ## 894 Percentage  49.0 break in timeseries
    ## 895 Percentage  47.5 break in timeseries
    ## 896 Percentage  53.4 break in timeseries
    ## 897 Percentage  57.1 break in timeseries
    ## 898 Percentage  51.5 break in timeseries
    ## 899 Percentage  54.8 break in timeseries
    ## 900 Percentage  51.3 break in timeseries
    ## 901 Percentage  55.9 break in timeseries
    ## 902 Percentage  46.5 break in timeseries
    ## 903 Percentage  44.0 break in timeseries
    ## 904 Percentage  42.7 break in timeseries
    ## 905 Percentage  36.9 break in timeseries
    ## 906 Percentage  30.4 break in timeseries

``` r
## remove flags_notes
regional_employ1 = regional_employ1 %>%
                   select(-flag_notes)
```

#### 5.1.3 Clean nuts2\_pop\_area

``` r
## nuts2 population data
str(nuts2_pop_area)
```

    ## 'data.frame':    72 obs. of  13 variables:
    ##  $ BHI_ID                          : int  1 1 2 2 2 2 3 3 3 4 ...
    ##  $ NUTS_ID                         : chr  "SE22" "SE23" "DK01" "DK02" ...
    ##  $ PopTot                          : int  116851 702394 266145 355373 175718 270701 413955 962944 605097 226701 ...
    ##  $ PopUrb                          : int  90965 657250 205041 275556 119983 225142 355931 856951 555111 150569 ...
    ##  $ PopRur                          : int  25886 45142 61102 79811 55739 45557 58027 105995 49991 76131 ...
    ##  $ PopTot_density_in_buffer_per_km2: num  10.04 2.42 18.31 10.96 4.3 ...
    ##  $ PopUrb_density_in_buffer_per_km2: num  7.82 2.26 14.1 8.5 2.94 ...
    ##  $ PopRur_density_in_buffer_per_km2: num  2.225 0.155 4.203 2.461 1.364 ...
    ##  $ CNTR_CODE                       : chr  "SE" "SE" "DK" "DK" ...
    ##  $ rgn_nam                         : chr  "Sweden" "Sweden" "Denmark" "Denmark" ...
    ##  $ Subbasin                        : chr  "Kattegat" "Kattegat" "Kattegat" "Kattegat" ...
    ##  $ HELCOM_ID                       : chr  "SEA-001" "SEA-001" "SEA-001" "SEA-001" ...
    ##  $ NUTS3_area_in_BHI_buffer_km2    : num  11636 290554 14538 32425 40858 ...

``` r
nuts2_pop_area1 = nuts2_pop_area %>%
                  select(-PopUrb,-PopRur,-PopUrb_density_in_buffer_per_km2,-PopRur_density_in_buffer_per_km2, -HELCOM_ID) %>%
                  dplyr::rename(rgn_id = BHI_ID,
                                nuts2 = NUTS_ID,
                                pop = PopTot,
                                pop_km2 = PopTot_density_in_buffer_per_km2,
                                country_abb= CNTR_CODE,
                                country = rgn_nam,
                                basin = Subbasin,
                                area = NUTS3_area_in_BHI_buffer_km2) ## this last column has NUTS3 in name, but is for NUTS2 data

str(nuts2_pop_area1)
```

    ## 'data.frame':    72 obs. of  8 variables:
    ##  $ rgn_id     : int  1 1 2 2 2 2 3 3 3 4 ...
    ##  $ nuts2      : chr  "SE22" "SE23" "DK01" "DK02" ...
    ##  $ pop        : int  116851 702394 266145 355373 175718 270701 413955 962944 605097 226701 ...
    ##  $ pop_km2    : num  10.04 2.42 18.31 10.96 4.3 ...
    ##  $ country_abb: chr  "SE" "SE" "DK" "DK" ...
    ##  $ country    : chr  "Sweden" "Sweden" "Denmark" "Denmark" ...
    ##  $ basin      : chr  "Kattegat" "Kattegat" "Kattegat" "Kattegat" ...
    ##  $ area       : num  11636 290554 14538 32425 40858 ...

#### 4.1.3 Check NUTS2 names from Finland

Shapefiles have names from 2006, check accom1 and accom\_coast1 to see if the names have been updated, will need to fix. ![Map of old NUTS2 names for GUlf of Finland](BHI_regions_NUTS2_plot.png?raw=true)
![Map of new NUTS2 names for GUlf of Finland](new_FI_nuts2.png?raw=true)

``` r
regional_employ1%>% filter(grepl("FI",nuts2))%>% select(nuts2, nuts2_name)%>% distinct()
```

    ##   nuts2            nuts2_name
    ## 1  FI19           Länsi-Suomi
    ## 2  FI1B      Helsinki-Uusimaa
    ## 3  FI1C           Etelä-Suomi
    ## 4  FI1D Pohjois- ja Itä-Suomi
    ## 5  FI20                 Åland

``` r
## These are the newer region names : FI1B, FI1C, FI1D


nuts2_pop_area1 %>% filter(grepl("FI",nuts2))%>% select(nuts2)%>% distinct()
```

    ##   nuts2
    ## 1  FI18
    ## 2  FI20
    ## 3  FI19
    ## 4  FI1A

``` r
## These are the older region names: FI18, FI1A

## Challenge because of coasts
## FI1C is associated with both the Gulf of Finland and the Aland Sea. FI1B has a small fraction associated with Aland Sea, the rest is Gulf of Finland

## Old FI18, contains both FI1C and FI1B.  May need to combine data from the new regions, and apply fraction from the older region.  Helsinki is in FI1B, which would assign almost entirely to BHI 32 and whereas FI1C would divide more equally btween BHI 36 and BHI 32. Therefore, combining these regions in order to apply the division generated from the old region may have a different result.

## old FI1A seems to be the same along the coast as the new FI1D but new FI1D covers inland areas previously in FI13

## Do this after joining accom and accom_coast with the nuts2_pop_area data, will have to add these regions back in.
```

#### 4.1.4 Check for incorrectly assigned NUTS2 regions to BHI regions and fix

Note - (as in NUTS3 assignment issues see ECO), BHI region 21 not assigned to any NUTS2 regions - despite clear association with PL63. PL63 split only between BHI 17 and BHI 18

``` r
## write to csv, fix manually, re-import csv
misassigned_nuts2 = nuts2_pop_area1 %>% select(nuts2,country,rgn_id)

## write.csv(misassigned_nuts2 , file.path(dir_liv, "misassigned_nuts2.csv"), row.names=FALSE)

## read in corrected assignments - same file as used for TR

corrected_nuts2 = read.csv(file.path(dir_liv,"misassigned_nuts2_manually_corrected.csv"),sep=";",stringsAsFactors = FALSE)


## join nuts2_pop_area1 with corrected data and fix

nuts2_pop_area2 = nuts2_pop_area1 %>%
                  full_join(., corrected_nuts2,
                            by=c("rgn_id","nuts2","country"))%>%
                 select(-country,-rgn_id,-incorrect,-BHI_ID_manual, -X.country_manual)%>%
                 dplyr::rename(country =X.correct_country,
                               rgn_id = X.correct_BH_ID)%>%
                  select(rgn_id,nuts2,country,country_abb,basin,pop,pop_km2,area) %>%
                  group_by(rgn_id, nuts2, country,country_abb,basin)%>%
                  summarise(pop =sum(pop),
                            pop_km2 = sum(pop_km2),
                            area = sum(area)) %>% ## some regions occurr twice because of correcting the assignment, sum to get single value for each region
                  ungroup()


str(nuts2_pop_area2)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    59 obs. of  8 variables:
    ##  $ rgn_id     : int  1 1 2 2 2 2 3 3 3 4 ...
    ##  $ nuts2      : chr  "SE22" "SE23" "DK01" "DK02" ...
    ##  $ country    : chr  "Sweden" "Sweden" "Denmark" "Denmark" ...
    ##  $ country_abb: chr  "SE" "SE" "DK" "DK" ...
    ##  $ basin      : chr  "Kattegat" "Kattegat" "Kattegat" "Kattegat" ...
    ##  $ pop        : int  116851 702394 266145 355373 175718 270701 413955 1000216 605097 226701 ...
    ##  $ pop_km2    : num  10.04 2.42 18.31 10.96 4.3 ...
    ##  $ area       : num  11636 290554 14538 32425 40858 ...

### 5.2 Join datasets

#### 5.2.1 Join accom times series with nuts pop and area

Join data with inner join, this will exclude Finland areas with name mismatches. Fix Finnish data and add back into the dataset

``` r
employ_nuts1 = inner_join(regional_employ1, nuts2_pop_area2,
                         by=c("nuts2"))

dim(regional_employ1)## 5344    5
```

    ## [1] 5344    5

``` r
dim(nuts2_pop_area2) ## 60 8
```

    ## [1] 59  8

``` r
dim(employ_nuts1) ##896  12
```

    ## [1] 880  12

``` r
str(employ_nuts1) ## this is now missing the Finnish data where there are name discrepancies
```

    ## 'data.frame':    880 obs. of  12 variables:
    ##  $ year       : int  1999 1999 1999 1999 1999 1999 1999 1999 1999 1999 ...
    ##  $ nuts2      : chr  "DK01" "DK01" "DK01" "DK01" ...
    ##  $ nuts2_name : chr  "Hovedstaden" "Hovedstaden" "Hovedstaden" "Hovedstaden" ...
    ##  $ unit       : chr  "Percentage" "Percentage" "Percentage" "Percentage" ...
    ##  $ value      : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ rgn_id     : int  2 6 12 15 2 3 7 9 12 3 ...
    ##  $ country    : chr  "Denmark" "Denmark" "Denmark" "Denmark" ...
    ##  $ country_abb: chr  "DK" "DK" "DK" "DK" ...
    ##  $ basin      : chr  "Kattegat" "The Sound" "Arkona Basin" "Bornholm Basin" ...
    ##  $ pop        : int  266145 1245898 1136201 44406 355373 413955 14518 24841 499769 1000216 ...
    ##  $ pop_km2    : num  18.31 106.16 201.2 5.91 10.96 ...
    ##  $ area       : num  14538 11736 5647 7517 32425 ...

#### 5.2.2 Get Finnish data that was excluded

One challenge is that the new regions are two regions (FI1B,FI1C) where the old region was one (FI18). FI1B includes Helsinki and plot below shows similar pattern but that FI1B is between 5.8 to 6.8 higher than FI1C.

Assume because FI1B is where Helsinki is located, this is the majority of the population, so apply the FI1B rate.

FI1D (new name) areas match old FIA1 areas - so this is a straight-forward fix.

![See Population density from Eurostat](pop_density_nuts2_FI.png?raw=TRUE) [Eurostat Population density image source](http://ec.europa.eu/eurostat/statistical-atlas/gis/viewer/#). Layer is under 'Background Maps'

``` r
## Get Finnish data renamed so that employmodating and population data match
fi_employ_newnuts = regional_employ1 %>%
                   filter(nuts2 %in% c("FI1C","FI1B", "FI1D"))
fi_employ_newnuts
```

    ##    year nuts2            nuts2_name       unit value
    ## 1  1999  FI1B      Helsinki-Uusimaa Percentage    NA
    ## 2  1999  FI1C           Etelä-Suomi Percentage    NA
    ## 3  1999  FI1D Pohjois- ja Itä-Suomi Percentage    NA
    ## 4  2000  FI1B      Helsinki-Uusimaa Percentage    NA
    ## 5  2000  FI1C           Etelä-Suomi Percentage    NA
    ## 6  2000  FI1D Pohjois- ja Itä-Suomi Percentage    NA
    ## 7  2001  FI1B      Helsinki-Uusimaa Percentage    NA
    ## 8  2001  FI1C           Etelä-Suomi Percentage    NA
    ## 9  2001  FI1D Pohjois- ja Itä-Suomi Percentage    NA
    ## 10 2002  FI1B      Helsinki-Uusimaa Percentage    NA
    ## 11 2002  FI1C           Etelä-Suomi Percentage    NA
    ## 12 2002  FI1D Pohjois- ja Itä-Suomi Percentage    NA
    ## 13 2003  FI1B      Helsinki-Uusimaa Percentage    NA
    ## 14 2003  FI1C           Etelä-Suomi Percentage    NA
    ## 15 2003  FI1D Pohjois- ja Itä-Suomi Percentage    NA
    ## 16 2004  FI1B      Helsinki-Uusimaa Percentage    NA
    ## 17 2004  FI1C           Etelä-Suomi Percentage    NA
    ## 18 2004  FI1D Pohjois- ja Itä-Suomi Percentage    NA
    ## 19 2005  FI1B      Helsinki-Uusimaa Percentage  74.3
    ## 20 2005  FI1C           Etelä-Suomi Percentage  68.3
    ## 21 2005  FI1D Pohjois- ja Itä-Suomi Percentage  62.8
    ## 22 2006  FI1B      Helsinki-Uusimaa Percentage  75.1
    ## 23 2006  FI1C           Etelä-Suomi Percentage  69.1
    ## 24 2006  FI1D Pohjois- ja Itä-Suomi Percentage  63.7
    ## 25 2007  FI1B      Helsinki-Uusimaa Percentage  75.7
    ## 26 2007  FI1C           Etelä-Suomi Percentage  69.9
    ## 27 2007  FI1D Pohjois- ja Itä-Suomi Percentage  63.9
    ## 28 2008  FI1B      Helsinki-Uusimaa Percentage  76.5
    ## 29 2008  FI1C           Etelä-Suomi Percentage  70.7
    ## 30 2008  FI1D Pohjois- ja Itä-Suomi Percentage  65.4
    ## 31 2009  FI1B      Helsinki-Uusimaa Percentage  74.3
    ## 32 2009  FI1C           Etelä-Suomi Percentage  68.0
    ## 33 2009  FI1D Pohjois- ja Itä-Suomi Percentage  63.1
    ## 34 2010  FI1B      Helsinki-Uusimaa Percentage  73.5
    ## 35 2010  FI1C           Etelä-Suomi Percentage  66.7
    ## 36 2010  FI1D Pohjois- ja Itä-Suomi Percentage  63.5
    ## 37 2011  FI1B      Helsinki-Uusimaa Percentage  74.3
    ## 38 2011  FI1C           Etelä-Suomi Percentage  67.4
    ## 39 2011  FI1D Pohjois- ja Itä-Suomi Percentage  64.5
    ## 40 2012  FI1B      Helsinki-Uusimaa Percentage  74.1
    ## 41 2012  FI1C           Etelä-Suomi Percentage  68.8
    ## 42 2012  FI1D Pohjois- ja Itä-Suomi Percentage  64.5
    ## 43 2013  FI1B      Helsinki-Uusimaa Percentage  73.4
    ## 44 2013  FI1C           Etelä-Suomi Percentage  67.0
    ## 45 2013  FI1D Pohjois- ja Itä-Suomi Percentage  65.3
    ## 46 2014  FI1B      Helsinki-Uusimaa Percentage  73.0
    ## 47 2014  FI1C           Etelä-Suomi Percentage  66.4
    ## 48 2014  FI1D Pohjois- ja Itä-Suomi Percentage  65.2

``` r
## compare the employment percentage between FI1C and FI1B which used to be one region
ggplot(fi_employ_newnuts)+
  geom_point(aes(year,value, colour=nuts2, shape=nuts2))+
  ggtitle("Comparison of Finnish Region NUTS2 Employment percentage")
```

    ## Warning: Removed 18 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/Get%20Finnish%20data%20that%20was%20excluded-1.png)

``` r
## difference between FI1B and FI1C
fi_employ_newnuts %>% 
  select(-nuts2_name)%>%
  spread(nuts2,value) %>%
  mutate(diff_1b_1c = FI1B - FI1C) %>%
  filter(!is.na(diff_1b_1c))
```

    ##    year       unit FI1B FI1C FI1D diff_1b_1c
    ## 1  2005 Percentage 74.3 68.3 62.8        6.0
    ## 2  2006 Percentage 75.1 69.1 63.7        6.0
    ## 3  2007 Percentage 75.7 69.9 63.9        5.8
    ## 4  2008 Percentage 76.5 70.7 65.4        5.8
    ## 5  2009 Percentage 74.3 68.0 63.1        6.3
    ## 6  2010 Percentage 73.5 66.7 63.5        6.8
    ## 7  2011 Percentage 74.3 67.4 64.5        6.9
    ## 8  2012 Percentage 74.1 68.8 64.5        5.3
    ## 9  2013 Percentage 73.4 67.0 65.3        6.4
    ## 10 2014 Percentage 73.0 66.4 65.2        6.6

``` r
##Assume because FI1B is where Helsinki is located, this is the majority of the population, so apply the FI1B rate. 
    ## Therefore, only retain data for FI1B (exclude FI1C)

fi_employ_newnuts1 = fi_employ_newnuts %>% 
                     filter(nuts2 != "FI1C")




## assign old nuts names to employ data
fi_employ_newnuts1 = fi_employ_newnuts1 %>%
                    mutate(nuts_old = ifelse(nuts2 == "FI1B", "FI18",
                                      ifelse(nuts2 == "FI1D", "FI1A","")),
                           nuts2_name_old= ifelse(nuts2 == "FI1B","old region",nuts2_name ))%>%
                    select(-nuts2, -nuts2_name)%>%
                    dplyr::rename(nuts2=nuts_old,
                                  nuts2_name = nuts2_name_old)
                        
head(fi_employ_newnuts1) ## there are NA but were NA for all regions in those years
```

    ##   year       unit value nuts2            nuts2_name
    ## 1 1999 Percentage    NA  FI18            old region
    ## 2 1999 Percentage    NA  FI1A Pohjois- ja Itä-Suomi
    ## 3 2000 Percentage    NA  FI18            old region
    ## 4 2000 Percentage    NA  FI1A Pohjois- ja Itä-Suomi
    ## 5 2001 Percentage    NA  FI18            old region
    ## 6 2001 Percentage    NA  FI1A Pohjois- ja Itä-Suomi

``` r
## Get population data associated with old nuts names
fi_nuts_oldnuts = nuts2_pop_area2 %>%
                  filter(nuts2 %in% c("FI18","FI1A"))

fi_nuts_oldnuts
```

    ## Source: local data frame [4 x 8]
    ## 
    ##   rgn_id nuts2 country country_abb           basin     pop     pop_km2
    ##    <int> <chr>   <chr>       <chr>           <chr>   <int>       <dbl>
    ## 1     32  FI18 Finland          FI Gulf of Finland 1421112  236.949480
    ## 2     36  FI18 Finland          FI       Aland Sea  410642    1.114912
    ## 3     38  FI18 Finland          FI    Bothnian Sea    6305    1.672771
    ## 4     42  FI1A Finland          FI    Bothnian Bay  367526 2839.664384
    ## Variables not shown: area <dbl>.

``` r
## join fi employ to fi pop and area

fi_employ_correct_nuts = full_join(fi_employ_newnuts1, fi_nuts_oldnuts,
                          by=c("nuts2"))%>%
                          select(year,nuts2,nuts2_name,unit,
                                 value,rgn_id,country,country_abb,basin, pop,
                                 pop_km2,area)


str(fi_employ_correct_nuts)
```

    ## 'data.frame':    64 obs. of  12 variables:
    ##  $ year       : int  1999 1999 1999 1999 2000 2000 2000 2000 2001 2001 ...
    ##  $ nuts2      : chr  "FI18" "FI18" "FI18" "FI1A" ...
    ##  $ nuts2_name : chr  "old region" "old region" "old region" "Pohjois- ja Itä-Suomi" ...
    ##  $ unit       : chr  "Percentage" "Percentage" "Percentage" "Percentage" ...
    ##  $ value      : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ rgn_id     : int  32 36 38 42 32 36 38 42 32 36 ...
    ##  $ country    : chr  "Finland" "Finland" "Finland" "Finland" ...
    ##  $ country_abb: chr  "FI" "FI" "FI" "FI" ...
    ##  $ basin      : chr  "Gulf of Finland" "Aland Sea" "Bothnian Sea" "Bothnian Bay" ...
    ##  $ pop        : int  1421112 410642 6305 367526 1421112 410642 6305 367526 1421112 410642 ...
    ##  $ pop_km2    : num  236.95 1.11 1.67 2839.66 236.95 ...
    ##  $ area       : num  1163861 368318 3769 837482 1163861 ...

#### 5.2.3 Join Finnish data to other regional data

``` r
### bind to rest of data
colnames(fi_employ_correct_nuts)
```

    ##  [1] "year"        "nuts2"       "nuts2_name"  "unit"        "value"      
    ##  [6] "rgn_id"      "country"     "country_abb" "basin"       "pop"        
    ## [11] "pop_km2"     "area"

``` r
colnames(employ_nuts1)
```

    ##  [1] "year"        "nuts2"       "nuts2_name"  "unit"        "value"      
    ##  [6] "rgn_id"      "country"     "country_abb" "basin"       "pop"        
    ## [11] "pop_km2"     "area"

``` r
employ_nuts2 = bind_rows(employ_nuts1, fi_employ_correct_nuts)%>%
              dplyr::rename(employ_rate =value)
```

#### 5.2.4 Plot and check regional employment time series

``` r
ggplot(employ_nuts2)+
  geom_point(aes(year,employ_rate, colour=nuts2))+
  geom_line(aes(year,employ_rate, colour=nuts2))+
  facet_wrap(~country, scale="free_y")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Time series Percent Employed NUTS2")
```

    ## Warning: Removed 128 rows containing missing values (geom_point).

    ## Warning: Removed 128 rows containing missing values (geom_path).

![](liv_prep_files/figure-markdown_github/Plot%20and%20check%20regional%20employment%20time%20series-1.png)

#### 5.2.5 Restrict dataset to year 2000 to 2014

``` r
employ_nuts3 = employ_nuts2 %>% 
              filter(year >=2000)
```

### 5.3 Are BHI regions missing?

``` r
employ_nuts3 %>% select(rgn_id)%>%distinct()%>%arrange(rgn_id)
```

    ##    rgn_id
    ## 1       1
    ## 2       2
    ## 3       3
    ## 4       4
    ## 5       5
    ## 6       6
    ## 7       7
    ## 8       8
    ## 9       9
    ## 10     10
    ## 11     11
    ## 12     12
    ## 13     13
    ## 14     14
    ## 15     15
    ## 16     16
    ## 17     17
    ## 18     18
    ## 19     20
    ## 20     23
    ## 21     24
    ## 22     25
    ## 23     26
    ## 24     27
    ## 25     28
    ## 26     29
    ## 27     31
    ## 28     32
    ## 29     34
    ## 30     35
    ## 31     36
    ## 32     37
    ## 33     38
    ## 34     39
    ## 35     40
    ## 36     41
    ## 37     42

``` r
## there are 37 regions

##missing: 19,21, 22,30,33

## expected missing - 19,22, and 33 from Russia
## 21 from Poland because not assigned
## 30 has no coastline
```

### 5.4 Calculate number of employed people and allocation to BHI regions

#### 5.4.1 Calculate the number of employed in BHI region with NUTS2 percentage

Use population within the 25km buffer and employment percentage to get the number of employed people. Population is constant at 2005 population size.

``` r
employ_nuts4 = employ_nuts3 %>%
               mutate(employ_pop = (employ_rate/100) * pop)
```

#### 5.4.2 Plot the number of people employed in each BHI region by NUTS2 region

``` r
ggplot(employ_nuts4)+
  geom_point(aes(year,employ_pop, colour=nuts2),size=.6)+
  facet_wrap(~rgn_id, scale="free_y")+
  guides(colour="none")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Time series Number of People Employed in NUTS2 (25km buffer) by BHI region")
```

    ## Warning: Removed 111 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/plot%20number%20of%20nuts3%20employed%20by%20bhi%20region-1.png)

#### 5.4.3 Calculate total employed by BHI region

``` r
employ_nuts5 = employ_nuts4 %>%
               select(country,country_abb,rgn_id,year,employ_pop)%>%
               group_by(country,country_abb,rgn_id,year)%>%
               summarise(employ_pop_bhi = sum(employ_pop)) %>%
               ungroup()
```

#### 5.4.4 Plot Number of BHI employed

``` r
ggplot(employ_nuts5)+
  geom_point(aes(year,employ_pop_bhi, colour=country),size=.6)+
  facet_wrap(~rgn_id, scale="free_y")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Time series Number of People Employed BHI region (25km buffer)")
```

    ## Warning: Removed 69 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/plot%20number%20of%20BHI%20employed-1.png)

### 5.5 Data layer for layers

#### 5.5.1 Prepare object for csv

``` r
liv_regional_employ = employ_nuts5 %>%
                     select(rgn_id, year, employ_pop_bhi)%>%
                     arrange(rgn_id, year)
```

#### 5.5.2 Write object to csv

``` r
write.csv(liv_regional_employ, file.path(dir_layers, 'liv_regional_employ_bhi2015.csv'),row.names =FALSE)
```

### 6. Country data prep

### 6.1 Organize data

#### 6.1.1 Read in data

``` r
## read in NUTS0 (national) employement from EU
nat_employ = read.csv(file.path(dir_liv, 'liv_data_database/nuts0_employ.csv'), stringsAsFactors = FALSE)

dim(nat_employ) #[1] 528    9
```

    ## [1] 528   9

``` r
str(nat_employ)
```

    ## 'data.frame':    528 obs. of  9 variables:
    ##  $ TIME              : int  1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 ...
    ##  $ TIME_LABEL        : int  1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 ...
    ##  $ GEO               : chr  "AT" "AT" "AT" "AT" ...
    ##  $ GEO_LABEL         : chr  "Austria" "Austria" "Austria" "Austria" ...
    ##  $ SEX               : chr  "Total" "Total" "Total" "Total" ...
    ##  $ AGE               : chr  "From 15 to 64 years" "From 15 to 64 years" "From 15 to 64 years" "From 15 to 64 years" ...
    ##  $ UNIT              : chr  "Percentage" "Percentage" "Percentage" "Percentage" ...
    ##  $ Value             : num  68.2 67.9 67.8 68.1 68.2 65.3 67.4 68.6 69.9 70.8 ...
    ##  $ Flag.and.Footnotes: chr  "" "" "" "" ...

``` r
## read in Russian national  pouplation and employment
ru_data = read.csv(file.path(dir_liv, 'liv_data_database/naida_10_pe_1_Data_cleaned.csv'), sep=";",stringsAsFactors = FALSE)
dim(ru_data)
```

    ## [1] 82  8

``` r
str(ru_data)
```

    ## 'data.frame':    82 obs. of  8 variables:
    ##  $ TIME              : int  1975 1975 1976 1976 1977 1977 1978 1978 1979 1979 ...
    ##  $ GEO               : chr  "RU" "RU" "RU" "RU" ...
    ##  $ GEO_LABEL         : chr  "Russia" "Russia" "Russia" "Russia" ...
    ##  $ UNIT              : chr  "THS_PER" "THS_PER" "THS_PER" "THS_PER" ...
    ##  $ UNIT_LABEL        : chr  "Thousand persons" "Thousand persons" "Thousand persons" "Thousand persons" ...
    ##  $ NA_ITEM           : chr  "Total population national concept" "Total employment domestic concept" "Total population national concept" "Total employment domestic concept" ...
    ##  $ Value             : num  133634 NA 134549 NA 135504 ...
    ##  $ Flag.and.Footnotes: chr  "" "" "" "" ...

``` r
## Read in EU population size
eu_pop = read.csv(file.path(dir_liv, 'liv_data_database/demo_gind_1_Data_cleaned.csv'), sep=";", stringsAsFactors = FALSE)

str(eu_pop)
```

    ## 'data.frame':    7020 obs. of  7 variables:
    ##  $ TIME              : int  1990 1990 1990 1990 1990 1990 1990 1990 1990 1990 ...
    ##  $ TIME_LABEL        : int  1990 1990 1990 1990 1990 1990 1990 1990 1990 1990 ...
    ##  $ GEO               : chr  "BE" "BE" "BE" "BE" ...
    ##  $ GEO_LABEL         : chr  "Belgium" "Belgium" "Belgium" "Belgium" ...
    ##  $ INDIC_DE          : chr  "Population on 1 January - total " "Population on 1 January - males" "Population on 1 January - females" "Average population - total" ...
    ##  $ Value             : chr  "9947782" "4860099" "5087683" "9967379" ...
    ##  $ Flag.and.Footnotes: chr  "" "" "" "" ...

``` r
dim(eu_pop)
```

    ## [1] 7020    7

``` r
# read in EU country abbreviations and names
eu_lookup = read.csv(file.path(dir_liv, 'EUcountrynames.csv'), sep=";")  
dim(eu_lookup)
```

    ## [1] 36  2

``` r
str(eu_lookup)
```

    ## 'data.frame':    36 obs. of  2 variables:
    ##  $ country_abb: Factor w/ 36 levels "AL","AT","BE",..: 3 4 7 9 8 10 17 11 12 14 ...
    ##  $ country    : Factor w/ 36 levels "Albania","Austria",..: 3 4 7 8 13 9 17 14 33 12 ...

``` r
## read in BHI look up table
bhi_lookup = read.csv(file.path(dir_liv, "bhi_basin_country_lookup.csv"), sep=";",stringsAsFactors = FALSE) %>%
            select(rgn_nam, BHI_ID)%>%
            dplyr::rename(country= rgn_nam,
                          rgn_id = BHI_ID)
```

#### 6.1.2 Clean National EU employment data object

``` r
nat_employ1 = nat_employ %>%
                  select(-TIME_LABEL,-SEX,-AGE) %>%
                  dplyr::rename(year = TIME, country_abb = GEO, country = GEO_LABEL,
                                unit=UNIT, value = Value, flag_notes = Flag.and.Footnotes)%>%
                  mutate(country_abb = as.character(country_abb),
                         country = as.character(country),
                         unit = as.character(unit),
                         flag_notes = ifelse(flag_notes== "b", "break in timeseries", ""))
                  
head(nat_employ1)
```

    ##   year country_abb country       unit value          flag_notes
    ## 1 1999          AT Austria Percentage  68.2                    
    ## 2 2000          AT Austria Percentage  67.9                    
    ## 3 2001          AT Austria Percentage  67.8                    
    ## 4 2002          AT Austria Percentage  68.1                    
    ## 5 2003          AT Austria Percentage  68.2                    
    ## 6 2004          AT Austria Percentage  65.3 break in timeseries

``` r
### check data flags
nat_employ1 %>% select(flag_notes)%>% distinct()
```

    ##            flag_notes
    ## 1                    
    ## 2 break in timeseries

``` r
nat_employ1 %>% filter(flag_notes == "break in timeseries") # not a major concern
```

    ##    year country_abb        country       unit value          flag_notes
    ## 1  2004          AT        Austria Percentage  65.3 break in timeseries
    ## 2  2005          AT        Austria Percentage  67.4 break in timeseries
    ## 3  2007          AT        Austria Percentage  69.9 break in timeseries
    ## 4  1999          BE        Belgium Percentage  58.9 break in timeseries
    ## 5  2001          BE        Belgium Percentage  59.7 break in timeseries
    ## 6  2005          BE        Belgium Percentage  61.1 break in timeseries
    ## 7  2011          BE        Belgium Percentage  61.9 break in timeseries
    ## 8  2001          BG       Bulgaria Percentage  50.7 break in timeseries
    ## 9  2003          BG       Bulgaria Percentage  53.1 break in timeseries
    ## 10 2005          BG       Bulgaria Percentage  55.8 break in timeseries
    ## 11 2008          BG       Bulgaria Percentage  64.0 break in timeseries
    ## 12 2010          BG       Bulgaria Percentage  59.8 break in timeseries
    ## 13 2011          BG       Bulgaria Percentage  58.4 break in timeseries
    ## 14 2003          HR        Croatia Percentage  53.4 break in timeseries
    ## 15 2005          HR        Croatia Percentage  55.0 break in timeseries
    ## 16 2006          HR        Croatia Percentage  55.6 break in timeseries
    ## 17 2005          CY         Cyprus Percentage  68.5 break in timeseries
    ## 18 2009          CY         Cyprus Percentage  69.0 break in timeseries
    ## 19 2005          CZ Czech Republic Percentage  64.8 break in timeseries
    ## 20 2011          CZ Czech Republic Percentage  65.7 break in timeseries
    ## 21 2005          DK        Denmark Percentage  75.9 break in timeseries
    ## 22 2000          EE        Estonia Percentage  60.9 break in timeseries
    ## 23 2005          EE        Estonia Percentage  64.8 break in timeseries
    ## 24 2000          FI        Finland Percentage  68.1 break in timeseries
    ## 25 2005          FI        Finland Percentage  68.4 break in timeseries
    ## 26 2008          FI        Finland Percentage  71.1 break in timeseries
    ## 27 2003          FR         France Percentage  63.4 break in timeseries
    ## 28 2005          FR         France Percentage  63.2 break in timeseries
    ## 29 2014          FR         France Percentage  63.8 break in timeseries
    ## 30 2005          DE        Germany Percentage  65.5 break in timeseries
    ## 31 2010          DE        Germany Percentage  71.3 break in timeseries
    ## 32 2011          DE        Germany Percentage  72.7 break in timeseries
    ## 33 2001          EL         Greece Percentage  56.5 break in timeseries
    ## 34 2004          EL         Greece Percentage  59.3 break in timeseries
    ## 35 2005          EL         Greece Percentage  59.6 break in timeseries
    ## 36 2009          EL         Greece Percentage  60.8 break in timeseries
    ## 37 2001          HU        Hungary Percentage  56.1 break in timeseries
    ## 38 2005          HU        Hungary Percentage  56.9 break in timeseries
    ## 39 2003          IS        Iceland Percentage  84.3 break in timeseries
    ## 40 2005          IS        Iceland Percentage  83.8 break in timeseries
    ## 41 2005          IE        Ireland Percentage  67.6 break in timeseries
    ## 42 2007          IE        Ireland Percentage  69.2 break in timeseries
    ## 43 2009          IE        Ireland Percentage  61.9 break in timeseries
    ## 44 2004          IT          Italy Percentage  57.8 break in timeseries
    ## 45 2005          IT          Italy Percentage  57.6 break in timeseries
    ## 46 2002          LV         Latvia Percentage  59.6 break in timeseries
    ## 47 2005          LV         Latvia Percentage  62.1 break in timeseries
    ## 48 2002          LT      Lithuania Percentage  60.6 break in timeseries
    ## 49 2005          LT      Lithuania Percentage  62.9 break in timeseries
    ## 50 2003          LU     Luxembourg Percentage  62.2 break in timeseries
    ## 51 2005          LU     Luxembourg Percentage  63.6 break in timeseries
    ## 52 2007          LU     Luxembourg Percentage  64.2 break in timeseries
    ## 53 2009          LU     Luxembourg Percentage  65.2 break in timeseries
    ## 54 2004          MT          Malta Percentage  53.4 break in timeseries
    ## 55 2005          MT          Malta Percentage  53.6 break in timeseries
    ## 56 2005          NL    Netherlands Percentage  73.2 break in timeseries
    ## 57 2010          NL    Netherlands Percentage  74.7 break in timeseries
    ## 58 2011          NL    Netherlands Percentage  74.2 break in timeseries
    ## 59 2005          NO         Norway Percentage  74.8 break in timeseries
    ## 60 2006          NO         Norway Percentage  75.4 break in timeseries
    ## 61 2000          PL         Poland Percentage  55.1 break in timeseries
    ## 62 2001          PL         Poland Percentage  53.7 break in timeseries
    ## 63 2003          PL         Poland Percentage  51.4 break in timeseries
    ## 64 2004          PL         Poland Percentage  51.4 break in timeseries
    ## 65 2005          PL         Poland Percentage  52.8 break in timeseries
    ## 66 2010          PL         Poland Percentage  58.9 break in timeseries
    ## 67 2002          PT       Portugal Percentage  69.1 break in timeseries
    ## 68 2005          PT       Portugal Percentage  67.3 break in timeseries
    ## 69 2011          PT       Portugal Percentage  63.8 break in timeseries
    ## 70 2002          RO        Romania Percentage  58.6 break in timeseries
    ## 71 2003          RO        Romania Percentage  58.7 break in timeseries
    ## 72 2005          RO        Romania Percentage  57.6 break in timeseries
    ## 73 2010          RO        Romania Percentage  60.2 break in timeseries
    ## 74 1999          SK       Slovakia Percentage  58.0 break in timeseries
    ## 75 2003          SK       Slovakia Percentage  57.9 break in timeseries
    ## 76 2005          SK       Slovakia Percentage  57.7 break in timeseries
    ## 77 2011          SK       Slovakia Percentage  59.3 break in timeseries
    ## 78 2005          SI       Slovenia Percentage  66.0 break in timeseries
    ## 79 2001          ES          Spain Percentage  57.7 break in timeseries
    ## 80 2005          ES          Spain Percentage  63.6 break in timeseries
    ## 81 2001          SE         Sweden Percentage  74.4 break in timeseries
    ## 82 2005          SE         Sweden Percentage  72.5 break in timeseries
    ## 83 2005          CH    Switzerland Percentage  77.2 break in timeseries
    ## 84 2014          TR         Turkey Percentage  49.5 break in timeseries
    ## 85 1999          UK United Kingdom Percentage  70.4 break in timeseries
    ## 86 2004          UK United Kingdom Percentage  71.6 break in timeseries
    ## 87 2005          UK United Kingdom Percentage  71.8 break in timeseries
    ## 88 2007          UK United Kingdom Percentage  71.5 break in timeseries
    ## 89 2008          UK United Kingdom Percentage  71.5 break in timeseries

``` r
### remove flag_notes

nat_employ1 = nat_employ1 %>%
              select(-flag_notes)

## Select only Baltic countries and data 2000 to end
nat_employ2 = nat_employ1 %>%
              filter(grepl("Denmark|Estonia|Finland|Germany|Latvia|Lithuania|Poland|Sweden",country)) %>%
          filter(year >=2000)

dim(nat_employ2)  
```

    ## [1] 120   5

``` r
nat_employ2 %>% select(country) %>% distinct()
```

    ##     country
    ## 1   Denmark
    ## 2   Estonia
    ## 3   Finland
    ## 4   Germany
    ## 5    Latvia
    ## 6 Lithuania
    ## 7    Poland
    ## 8    Sweden

``` r
### plot employment by country
ggplot(nat_employ2)+
  geom_point(aes(year, value))+
  facet_wrap(~country) +
  ggtitle("Percent employed ")
```

![](liv_prep_files/figure-markdown_github/clean%20country%20data%20object-1.png)

#### 6.1.3 Clean Russian data object

Russian employment and population is in "thousand persons", transform into total number of people

``` r
## divide population and employment into separate objects

ru_data = ru_data %>%
          select(-UNIT) %>%
          dplyr::rename(year = TIME, 
                        country_abb = GEO,
                        country = GEO_LABEL,
                        unit = UNIT_LABEL,
                        dat_descrip = NA_ITEM,
                        value = Value,
                         flag_notes = Flag.and.Footnotes)

ru_data %>% select(unit, dat_descrip)%>% distinct()
```

    ##               unit                       dat_descrip
    ## 1 Thousand persons Total population national concept
    ## 2 Thousand persons Total employment domestic concept

``` r
ru_pop = ru_data %>%
         filter(dat_descrip == "Total population national concept")%>%
         mutate(ru_pop = value *1000) %>% ##transform into total number of people from thousands of people
         select(-value)

ru_employ = ru_data %>%
         filter(dat_descrip == "Total employment domestic concept")%>%
          mutate(ru_employ = value *1000) %>% ##transform into total number of people from thousands of people
         select(-value)


## check flags

ru_pop %>% select(flag_notes)%>% distinct()
```

    ##   flag_notes
    ## 1           
    ## 2          b
    ## 3          e

``` r
ru_pop %>% filter(flag_notes == 'b' | flag_notes == 'e') ## estimated in 2012, 2013, 1989 break in time seires
```

    ##   year country_abb country             unit
    ## 1 1989          RU  Russia Thousand persons
    ## 2 2012          RU  Russia Thousand persons
    ## 3 2013          RU  Russia Thousand persons
    ##                         dat_descrip flag_notes    ru_pop
    ## 1 Total population national concept          b 146999100
    ## 2 Total population national concept          e 143170000
    ## 3 Total population national concept          e 142834000

``` r
ru_pop = ru_pop %>%
         select(-flag_notes)

ru_employ %>% select(flag_notes)%>% distinct() ## none flagged
```

    ##   flag_notes
    ## 1

``` r
ru_employ = ru_employ %>%
            select(-flag_notes)


## Select only data from 2000 to end
ru_pop = ru_pop %>%
         filter(year >=2000)

ru_employ= ru_employ %>%
         filter(year >=2000)


## Plot data
## plop Russia employment
ggplot(ru_employ) +
  geom_point(aes(year, ru_employ))+
  ylab("Number of people")+
  ggtitle("Number of People Employed - Russia")
```

    ## Warning: Removed 4 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/clean%20russian%20nat%20data%20object-1.png)

#### 6.1.4 Clean EU nat population data object

EU population size information:
Population on 1 January: Eurostat aims at collecting from the EU-28's Member States' data on population on 31st December, which is further published as 1 January of the following year. The recommended definition is the 'usual resident population' and represents the number of inhabitants of a given area on 31st December . However, the population transmitted by the countries can also be either based on data from the most recent census adjusted by the components of population change produced since the last census, either based on population registers.
[Source](http://ec.europa.eu/eurostat/cache/metadata/en/demo_gind_esms.htm)

``` r
## EU countries
eu_pop2 = eu_pop %>%
          select(-TIME_LABEL)%>%
          dplyr::rename(year = TIME,
                        country_abb = GEO,
                        country= GEO_LABEL,
                        unit = INDIC_DE,
                        value = Value,
                        flag_notes = Flag.and.Footnotes)%>%
          filter(unit == "Population on 1 January - total " )%>% # select this meauresure of population size
          mutate(value = ifelse(value== ":", NA, value),
                value= as.numeric(value))


## select only Baltic countries and data since 2000
eu_pop3 = eu_pop2 %>%
          mutate(country = ifelse(country =="Germany (until 1990 former territory of the FRG)","Germany",country),
                 country = ifelse(country =="Germany (including former GDR)","Germany",country),
                 country_abb = ifelse(country_abb == "DE_TOT","DE",country_abb))%>%
          filter(grepl("Denmark|Estonia|Finland|Germany|Latvia|Lithuania|Poland|Sweden",country)) %>%
          filter(year >=2000)

  dim(eu_pop3) ## Germany is duplicated because of GDR and FRG but in more recent years, value occurs twice ##144 6
```

    ## [1] 144   6

``` r
eu_pop3 = eu_pop3 %>%
          distinct()

dim(eu_pop3) ##129 6
```

    ## [1] 129   6

``` r
str(eu_pop3)           
```

    ## 'data.frame':    129 obs. of  6 variables:
    ##  $ year       : int  2000 2000 2000 2000 2000 2000 2000 2000 2001 2001 ...
    ##  $ country_abb: chr  "DK" "DE" "EE" "LV" ...
    ##  $ country    : chr  "Denmark" "Germany" "Estonia" "Latvia" ...
    ##  $ unit       : chr  "Population on 1 January - total " "Population on 1 January - total " "Population on 1 January - total " "Population on 1 January - total " ...
    ##  $ value      : num  5330020 82163475 1401250 2381715 3512074 ...
    ##  $ flag_notes : chr  "" "" "" "" ...

``` r
## check data flags
eu_pop3 %>% select(flag_notes)%>%distinct()
```

    ##   flag_notes
    ## 1           
    ## 2          b

``` r
eu_pop3 %>% filter(flag_notes == "b")  ## b = break in time series -- this should be fine
```

    ##   year country_abb country                             unit    value
    ## 1 2000          PL  Poland Population on 1 January - total  38263303
    ## 2 2010          PL  Poland Population on 1 January - total  38022869
    ## 3 2012          DE Germany Population on 1 January - total  80327900
    ## 4 2014          DE Germany Population on 1 January - total  80767463
    ##   flag_notes
    ## 1          b
    ## 2          b
    ## 3          b
    ## 4          b

``` r
eu_pop3 = eu_pop3 %>%
          select(-flag_notes)
```

### 6.2 Transform EU data in number of people employed

Use 2005 population size. This is to be consistent with only have 2005 population size for the regional data. The same approach is used for ECO national data layer preparation.

This will mean that the data differ slightly from the Russian employment which are provided as number of people and probably then reflect population size changes as well.

However, because there is no regional Russian data, there is no Russian status calculation.

#### 6.2.1 Join EU national employment percent to population size from 2005

``` r
nat_pop_2005 = eu_pop3 %>%
               filter(year==2005) %>%
               dplyr::rename(pop_2005 = value)%>%
               select(country, pop_2005)

nat_employ3 = full_join(nat_employ2,nat_pop_2005,
                        by="country")

## number employed
nat_employ3 = nat_employ3 %>%
              dplyr::rename(employ_rate = value) %>%
              mutate(employ_pop = (employ_rate/100) * pop_2005) %>%  ## make sure to convert percentage to proportion
              select(-employ_rate, -pop_2005,-unit)
```

### 6.3 Join EU and Russian data

### 6.3.1 Join EU and Russian data

``` r
colnames(ru_employ)
```

    ## [1] "year"        "country_abb" "country"     "unit"        "dat_descrip"
    ## [6] "ru_employ"

``` r
colnames(nat_employ3)
```

    ## [1] "year"        "country_abb" "country"     "employ_pop"

``` r
## modify ru object
ru_employ = ru_employ %>%
            select(-dat_descrip)%>%
            dplyr::rename(employ_pop = ru_employ)



## bind rows
nat_employ4 = bind_rows(nat_employ3, ru_employ)
```

#### 6.3.2 Plot joined EU and Russian employment data

``` r
ggplot(nat_employ4) +
  geom_point(aes(year, employ_pop, colour = country))+
  geom_line(aes(year, employ_pop, colour = country))+
  ylab("Number of people")+
  ggtitle("Number of People Employed")
```

    ## Warning: Removed 4 rows containing missing values (geom_point).

    ## Warning: Removed 4 rows containing missing values (geom_path).

![](liv_prep_files/figure-markdown_github/plot%20joined%20EU%20and%20russian%20employment%20data-1.png)

### 6.3.3. Restrict to Final year 2014

Same as the regional data

``` r
nat_employ4 = nat_employ4 %>%
              filter( year < 2015)
```

### 6.4 National data by BHI regions

#### 6.4.1 Join national data to BHI regions

``` r
rgn_nat_employ =  full_join(bhi_lookup,nat_employ4,
                        by="country")
```

#### 6.4.2 Plot national data by BHI region

``` r
ggplot(rgn_nat_employ)+
  geom_point(aes(year,employ_pop,colour=country),size=.7)+
  facet_wrap(~rgn_id, scales="free_y")+
  ggtitle("Number People Employed Nationally for each BHI region")
```

    ## Warning: Removed 9 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/plot%20national%20data%20by%20BHI%20region-1.png)

### 6.5 Prepare national data layer for layer

#### 6.5.1 Prepare Object

``` r
liv_national_employ = rgn_nat_employ %>%
                     select(rgn_id, year, employ_pop)%>%
                     arrange(rgn_id, year)
```

#### 6.5.2 Write to csv

``` r
write.csv(liv_national_employ, file.path(dir_layers,'liv_national_employ_bhi2015.csv'),row.names = FALSE)
```

7. Status and Trend calculation exploration
-------------------------------------------

Status and trend are calculated in functions.r but code is tested and explored here.

### 7.1 Assign data layer

``` r
  liv_regional_employ
```

    ## Source: local data frame [555 x 3]
    ## 
    ##    rgn_id  year employ_pop_bhi
    ##     <int> <int>          <dbl>
    ## 1       1  2000       589513.6
    ## 2       1  2001       611515.1
    ## 3       1  2002       615027.0
    ## 4       1  2003       613857.2
    ## 5       1  2004       606134.8
    ## 6       1  2005       595012.0
    ## 7       1  2006       604141.8
    ## 8       1  2007       609171.6
    ## 9       1  2008       608701.6
    ## 10      1  2009       586697.6
    ## ..    ...   ...            ...

``` r
  liv_national_employ 
```

    ##     rgn_id year employ_pop
    ## 1        1 2000  6407099.7
    ## 2        1 2001  6704475.6
    ## 3        1 2002  6668430.1
    ## 4        1 2003  6632384.5
    ## 5        1 2004  6524247.8
    ## 6        1 2005  6533259.2
    ## 7        1 2006  6587327.6
    ## 8        1 2007  6686452.9
    ## 9        1 2008  6695464.3
    ## 10       1 2009  6506225.0
    ## 11       1 2010  6497213.6
    ## 12       1 2011  6632384.5
    ## 13       1 2012  6650407.3
    ## 14       1 2013  6704475.6
    ## 15       1 2014  6749532.6
    ## 16       2 2000  4134313.4
    ## 17       2 2001  4107256.4
    ## 18       2 2002  4134313.4
    ## 19       2 2003  4063965.2
    ## 20       2 2004  4112667.8
    ## 21       2 2005  4107256.4
    ## 22       2 2006  4188427.5
    ## 23       2 2007  4166781.9
    ## 24       2 2008  4215484.5
    ## 25       2 2009  4074788.0
    ## 26       2 2010  3966559.9
    ## 27       2 2011  3955737.1
    ## 28       2 2012  3928680.0
    ## 29       2 2013  3923268.6
    ## 30       2 2014  3939502.8
    ## 31       3 2000  4134313.4
    ## 32       3 2001  4107256.4
    ## 33       3 2002  4134313.4
    ## 34       3 2003  4063965.2
    ## 35       3 2004  4112667.8
    ## 36       3 2005  4107256.4
    ## 37       3 2006  4188427.5
    ## 38       3 2007  4166781.9
    ## 39       3 2008  4215484.5
    ## 40       3 2009  4074788.0
    ## 41       3 2010  3966559.9
    ## 42       3 2011  3955737.1
    ## 43       3 2012  3928680.0
    ## 44       3 2013  3923268.6
    ## 45       3 2014  3939502.8
    ## 46       4 2000 53873054.4
    ## 47       4 2001 54203057.8
    ## 48       4 2002 53955555.2
    ## 49       4 2003 53543051.0
    ## 50       4 2004 53048045.9
    ## 51       4 2005 54038056.1
    ## 52       4 2006 55440570.5
    ## 53       4 2007 56925585.8
    ## 54       4 2008 57833095.1
    ## 55       4 2009 57998096.8
    ## 56       4 2010 58823105.3
    ## 57       4 2011 59978117.2
    ## 58       4 2012 60225619.8
    ## 59       4 2013 60638124.0
    ## 60       4 2014 60885626.6
    ## 61       5 2000  6407099.7
    ## 62       5 2001  6704475.6
    ## 63       5 2002  6668430.1
    ## 64       5 2003  6632384.5
    ## 65       5 2004  6524247.8
    ## 66       5 2005  6533259.2
    ## 67       5 2006  6587327.6
    ## 68       5 2007  6686452.9
    ## 69       5 2008  6695464.3
    ## 70       5 2009  6506225.0
    ## 71       5 2010  6497213.6
    ## 72       5 2011  6632384.5
    ## 73       5 2012  6650407.3
    ## 74       5 2013  6704475.6
    ## 75       5 2014  6749532.6
    ## 76       6 2000  4134313.4
    ## 77       6 2001  4107256.4
    ## 78       6 2002  4134313.4
    ## 79       6 2003  4063965.2
    ## 80       6 2004  4112667.8
    ## 81       6 2005  4107256.4
    ## 82       6 2006  4188427.5
    ## 83       6 2007  4166781.9
    ## 84       6 2008  4215484.5
    ## 85       6 2009  4074788.0
    ## 86       6 2010  3966559.9
    ## 87       6 2011  3955737.1
    ## 88       6 2012  3928680.0
    ## 89       6 2013  3923268.6
    ## 90       6 2014  3939502.8
    ## 91       7 2000  4134313.4
    ## 92       7 2001  4107256.4
    ## 93       7 2002  4134313.4
    ## 94       7 2003  4063965.2
    ## 95       7 2004  4112667.8
    ## 96       7 2005  4107256.4
    ## 97       7 2006  4188427.5
    ## 98       7 2007  4166781.9
    ## 99       7 2008  4215484.5
    ## 100      7 2009  4074788.0
    ## 101      7 2010  3966559.9
    ## 102      7 2011  3955737.1
    ## 103      7 2012  3928680.0
    ## 104      7 2013  3923268.6
    ## 105      7 2014  3939502.8
    ## 106      8 2000 53873054.4
    ## 107      8 2001 54203057.8
    ## 108      8 2002 53955555.2
    ## 109      8 2003 53543051.0
    ## 110      8 2004 53048045.9
    ## 111      8 2005 54038056.1
    ## 112      8 2006 55440570.5
    ## 113      8 2007 56925585.8
    ## 114      8 2008 57833095.1
    ## 115      8 2009 57998096.8
    ## 116      8 2010 58823105.3
    ## 117      8 2011 59978117.2
    ## 118      8 2012 60225619.8
    ## 119      8 2013 60638124.0
    ## 120      8 2014 60885626.6
    ## 121      9 2000  4134313.4
    ## 122      9 2001  4107256.4
    ## 123      9 2002  4134313.4
    ## 124      9 2003  4063965.2
    ## 125      9 2004  4112667.8
    ## 126      9 2005  4107256.4
    ## 127      9 2006  4188427.5
    ## 128      9 2007  4166781.9
    ## 129      9 2008  4215484.5
    ## 130      9 2009  4074788.0
    ## 131      9 2010  3966559.9
    ## 132      9 2011  3955737.1
    ## 133      9 2012  3928680.0
    ## 134      9 2013  3923268.6
    ## 135      9 2014  3939502.8
    ## 136     10 2000 53873054.4
    ## 137     10 2001 54203057.8
    ## 138     10 2002 53955555.2
    ## 139     10 2003 53543051.0
    ## 140     10 2004 53048045.9
    ## 141     10 2005 54038056.1
    ## 142     10 2006 55440570.5
    ## 143     10 2007 56925585.8
    ## 144     10 2008 57833095.1
    ## 145     10 2009 57998096.8
    ## 146     10 2010 58823105.3
    ## 147     10 2011 59978117.2
    ## 148     10 2012 60225619.8
    ## 149     10 2013 60638124.0
    ## 150     10 2014 60885626.6
    ## 151     11 2000  6407099.7
    ## 152     11 2001  6704475.6
    ## 153     11 2002  6668430.1
    ## 154     11 2003  6632384.5
    ## 155     11 2004  6524247.8
    ## 156     11 2005  6533259.2
    ## 157     11 2006  6587327.6
    ## 158     11 2007  6686452.9
    ## 159     11 2008  6695464.3
    ## 160     11 2009  6506225.0
    ## 161     11 2010  6497213.6
    ## 162     11 2011  6632384.5
    ## 163     11 2012  6650407.3
    ## 164     11 2013  6704475.6
    ## 165     11 2014  6749532.6
    ## 166     12 2000  4134313.4
    ## 167     12 2001  4107256.4
    ## 168     12 2002  4134313.4
    ## 169     12 2003  4063965.2
    ## 170     12 2004  4112667.8
    ## 171     12 2005  4107256.4
    ## 172     12 2006  4188427.5
    ## 173     12 2007  4166781.9
    ## 174     12 2008  4215484.5
    ## 175     12 2009  4074788.0
    ## 176     12 2010  3966559.9
    ## 177     12 2011  3955737.1
    ## 178     12 2012  3928680.0
    ## 179     12 2013  3923268.6
    ## 180     12 2014  3939502.8
    ## 181     13 2000 53873054.4
    ## 182     13 2001 54203057.8
    ## 183     13 2002 53955555.2
    ## 184     13 2003 53543051.0
    ## 185     13 2004 53048045.9
    ## 186     13 2005 54038056.1
    ## 187     13 2006 55440570.5
    ## 188     13 2007 56925585.8
    ## 189     13 2008 57833095.1
    ## 190     13 2009 57998096.8
    ## 191     13 2010 58823105.3
    ## 192     13 2011 59978117.2
    ## 193     13 2012 60225619.8
    ## 194     13 2013 60638124.0
    ## 195     13 2014 60885626.6
    ## 196     14 2000  6407099.7
    ## 197     14 2001  6704475.6
    ## 198     14 2002  6668430.1
    ## 199     14 2003  6632384.5
    ## 200     14 2004  6524247.8
    ## 201     14 2005  6533259.2
    ## 202     14 2006  6587327.6
    ## 203     14 2007  6686452.9
    ## 204     14 2008  6695464.3
    ## 205     14 2009  6506225.0
    ## 206     14 2010  6497213.6
    ## 207     14 2011  6632384.5
    ## 208     14 2012  6650407.3
    ## 209     14 2013  6704475.6
    ## 210     14 2014  6749532.6
    ## 211     15 2000  4134313.4
    ## 212     15 2001  4107256.4
    ## 213     15 2002  4134313.4
    ## 214     15 2003  4063965.2
    ## 215     15 2004  4112667.8
    ## 216     15 2005  4107256.4
    ## 217     15 2006  4188427.5
    ## 218     15 2007  4166781.9
    ## 219     15 2008  4215484.5
    ## 220     15 2009  4074788.0
    ## 221     15 2010  3966559.9
    ## 222     15 2011  3955737.1
    ## 223     15 2012  3928680.0
    ## 224     15 2013  3923268.6
    ## 225     15 2014  3939502.8
    ## 226     16 2000 53873054.4
    ## 227     16 2001 54203057.8
    ## 228     16 2002 53955555.2
    ## 229     16 2003 53543051.0
    ## 230     16 2004 53048045.9
    ## 231     16 2005 54038056.1
    ## 232     16 2006 55440570.5
    ## 233     16 2007 56925585.8
    ## 234     16 2008 57833095.1
    ## 235     16 2009 57998096.8
    ## 236     16 2010 58823105.3
    ## 237     16 2011 59978117.2
    ## 238     16 2012 60225619.8
    ## 239     16 2013 60638124.0
    ## 240     16 2014 60885626.6
    ## 241     17 2000 21033783.1
    ## 242     17 2001 20499349.4
    ## 243     17 2002 19735872.7
    ## 244     17 2003 19621351.2
    ## 245     17 2004 19621351.2
    ## 246     17 2005 20155784.9
    ## 247     17 2006 20804740.1
    ## 248     17 2007 21759085.9
    ## 249     17 2008 22598910.3
    ## 250     17 2009 22637084.2
    ## 251     17 2010 22484388.8
    ## 252     17 2011 22637084.2
    ## 253     17 2012 22789779.5
    ## 254     17 2013 22904301.0
    ## 255     17 2014 23553256.2
    ## 256     18 2000 21033783.1
    ## 257     18 2001 20499349.4
    ## 258     18 2002 19735872.7
    ## 259     18 2003 19621351.2
    ## 260     18 2004 19621351.2
    ## 261     18 2005 20155784.9
    ## 262     18 2006 20804740.1
    ## 263     18 2007 21759085.9
    ## 264     18 2008 22598910.3
    ## 265     18 2009 22637084.2
    ## 266     18 2010 22484388.8
    ## 267     18 2011 22637084.2
    ## 268     18 2012 22789779.5
    ## 269     18 2013 22904301.0
    ## 270     18 2014 23553256.2
    ## 271     19 2000 65070000.0
    ## 272     19 2001 65122900.0
    ## 273     19 2002 66658900.0
    ## 274     19 2003 66432200.0
    ## 275     19 2004 67274700.0
    ## 276     19 2005 68168900.0
    ## 277     19 2006 68854900.0
    ## 278     19 2007 70570000.0
    ## 279     19 2008 70965000.0
    ## 280     19 2009 69285000.0
    ## 281     19 2010 69804000.0
    ## 282     19 2011 70732000.0
    ## 283     19 2012         NA
    ## 284     19 2013         NA
    ## 285     19 2014         NA
    ## 286     20 2000  6407099.7
    ## 287     20 2001  6704475.6
    ## 288     20 2002  6668430.1
    ## 289     20 2003  6632384.5
    ## 290     20 2004  6524247.8
    ## 291     20 2005  6533259.2
    ## 292     20 2006  6587327.6
    ## 293     20 2007  6686452.9
    ## 294     20 2008  6695464.3
    ## 295     20 2009  6506225.0
    ## 296     20 2010  6497213.6
    ## 297     20 2011  6632384.5
    ## 298     20 2012  6650407.3
    ## 299     20 2013  6704475.6
    ## 300     20 2014  6749532.6
    ## 301     21 2000 21033783.1
    ## 302     21 2001 20499349.4
    ## 303     21 2002 19735872.7
    ## 304     21 2003 19621351.2
    ## 305     21 2004 19621351.2
    ## 306     21 2005 20155784.9
    ## 307     21 2006 20804740.1
    ## 308     21 2007 21759085.9
    ## 309     21 2008 22598910.3
    ## 310     21 2009 22637084.2
    ## 311     21 2010 22484388.8
    ## 312     21 2011 22637084.2
    ## 313     21 2012 22789779.5
    ## 314     21 2013 22904301.0
    ## 315     21 2014 23553256.2
    ## 316     22 2000 65070000.0
    ## 317     22 2001 65122900.0
    ## 318     22 2002 66658900.0
    ## 319     22 2003 66432200.0
    ## 320     22 2004 67274700.0
    ## 321     22 2005 68168900.0
    ## 322     22 2006 68854900.0
    ## 323     22 2007 70570000.0
    ## 324     22 2008 70965000.0
    ## 325     22 2009 69285000.0
    ## 326     22 2010 69804000.0
    ## 327     22 2011 70732000.0
    ## 328     22 2012         NA
    ## 329     22 2013         NA
    ## 330     22 2014         NA
    ## 331     23 2000  1999711.1
    ## 332     23 2001  1949382.8
    ## 333     23 2002  2033263.3
    ## 334     23 2003  2107078.2
    ## 335     23 2004  2073526.0
    ## 336     23 2005  2110433.4
    ## 337     23 2006  2133919.9
    ## 338     23 2007  2180893.0
    ## 339     23 2008  2160761.7
    ## 340     23 2009  2009776.8
    ## 341     23 2010  1932606.7
    ## 342     23 2011  2019842.4
    ## 343     23 2012  2080236.4
    ## 344     23 2013  2137275.1
    ## 345     23 2014  2204379.5
    ## 346     24 2000  1291341.6
    ## 347     24 2001  1307089.6
    ## 348     24 2002  1340835.5
    ## 349     24 2003  1356583.6
    ## 350     24 2004  1361083.0
    ## 351     24 2005  1397078.6
    ## 352     24 2006  1482568.1
    ## 353     24 2007  1532062.0
    ## 354     24 2008  1534311.8
    ## 355     24 2009  1356583.6
    ## 356     24 2010  1316088.5
    ## 357     24 2011  1367832.2
    ## 358     24 2012  1417326.1
    ## 359     24 2013  1462320.6
    ## 360     24 2014  1491567.0
    ## 361     25 2000   827539.7
    ## 362     25 2001   823463.1
    ## 363     25 2002   834333.9
    ## 364     25 2003   847922.4
    ## 365     25 2004   858793.2
    ## 366     25 2005   880534.8
    ## 367     25 2006   929453.4
    ## 368     25 2007   948477.3
    ## 369     25 2008   952553.8
    ## 370     25 2009   866946.3
    ## 371     25 2010   831616.2
    ## 372     25 2011   887329.1
    ## 373     25 2012   911788.3
    ## 374     25 2013   930812.3
    ## 375     25 2014   945759.6
    ## 376     26 2000  6407099.7
    ## 377     26 2001  6704475.6
    ## 378     26 2002  6668430.1
    ## 379     26 2003  6632384.5
    ## 380     26 2004  6524247.8
    ## 381     26 2005  6533259.2
    ## 382     26 2006  6587327.6
    ## 383     26 2007  6686452.9
    ## 384     26 2008  6695464.3
    ## 385     26 2009  6506225.0
    ## 386     26 2010  6497213.6
    ## 387     26 2011  6632384.5
    ## 388     26 2012  6650407.3
    ## 389     26 2013  6704475.6
    ## 390     26 2014  6749532.6
    ## 391     27 2000  1291341.6
    ## 392     27 2001  1307089.6
    ## 393     27 2002  1340835.5
    ## 394     27 2003  1356583.6
    ## 395     27 2004  1361083.0
    ## 396     27 2005  1397078.6
    ## 397     27 2006  1482568.1
    ## 398     27 2007  1532062.0
    ## 399     27 2008  1534311.8
    ## 400     27 2009  1356583.6
    ## 401     27 2010  1316088.5
    ## 402     27 2011  1367832.2
    ## 403     27 2012  1417326.1
    ## 404     27 2013  1462320.6
    ## 405     27 2014  1491567.0
    ## 406     28 2000   827539.7
    ## 407     28 2001   823463.1
    ## 408     28 2002   834333.9
    ## 409     28 2003   847922.4
    ## 410     28 2004   858793.2
    ## 411     28 2005   880534.8
    ## 412     28 2006   929453.4
    ## 413     28 2007   948477.3
    ## 414     28 2008   952553.8
    ## 415     28 2009   866946.3
    ## 416     28 2010   831616.2
    ## 417     28 2011   887329.1
    ## 418     28 2012   911788.3
    ## 419     28 2013   930812.3
    ## 420     28 2014   945759.6
    ## 421     29 2000  6407099.7
    ## 422     29 2001  6704475.6
    ## 423     29 2002  6668430.1
    ## 424     29 2003  6632384.5
    ## 425     29 2004  6524247.8
    ## 426     29 2005  6533259.2
    ## 427     29 2006  6587327.6
    ## 428     29 2007  6686452.9
    ## 429     29 2008  6695464.3
    ## 430     29 2009  6506225.0
    ## 431     29 2010  6497213.6
    ## 432     29 2011  6632384.5
    ## 433     29 2012  6650407.3
    ## 434     29 2013  6704475.6
    ## 435     29 2014  6749532.6
    ## 436     30 2000  3566132.1
    ## 437     30 2001  3618498.2
    ## 438     30 2002  3618498.2
    ## 439     30 2003  3597551.8
    ## 440     30 2004  3576605.3
    ## 441     30 2005  3581841.9
    ## 442     30 2006  3628971.4
    ## 443     30 2007  3681337.5
    ## 444     30 2008  3723230.4
    ## 445     30 2009  3597551.8
    ## 446     30 2010  3566132.1
    ## 447     30 2011  3613261.6
    ## 448     30 2012  3634208.0
    ## 449     30 2013  3608025.0
    ## 450     30 2014  3597551.8
    ## 451     31 2000   827539.7
    ## 452     31 2001   823463.1
    ## 453     31 2002   834333.9
    ## 454     31 2003   847922.4
    ## 455     31 2004   858793.2
    ## 456     31 2005   880534.8
    ## 457     31 2006   929453.4
    ## 458     31 2007   948477.3
    ## 459     31 2008   952553.8
    ## 460     31 2009   866946.3
    ## 461     31 2010   831616.2
    ## 462     31 2011   887329.1
    ## 463     31 2012   911788.3
    ## 464     31 2013   930812.3
    ## 465     31 2014   945759.6
    ## 466     32 2000  3566132.1
    ## 467     32 2001  3618498.2
    ## 468     32 2002  3618498.2
    ## 469     32 2003  3597551.8
    ## 470     32 2004  3576605.3
    ## 471     32 2005  3581841.9
    ## 472     32 2006  3628971.4
    ## 473     32 2007  3681337.5
    ## 474     32 2008  3723230.4
    ## 475     32 2009  3597551.8
    ## 476     32 2010  3566132.1
    ## 477     32 2011  3613261.6
    ## 478     32 2012  3634208.0
    ## 479     32 2013  3608025.0
    ## 480     32 2014  3597551.8
    ## 481     33 2000 65070000.0
    ## 482     33 2001 65122900.0
    ## 483     33 2002 66658900.0
    ## 484     33 2003 66432200.0
    ## 485     33 2004 67274700.0
    ## 486     33 2005 68168900.0
    ## 487     33 2006 68854900.0
    ## 488     33 2007 70570000.0
    ## 489     33 2008 70965000.0
    ## 490     33 2009 69285000.0
    ## 491     33 2010 69804000.0
    ## 492     33 2011 70732000.0
    ## 493     33 2012         NA
    ## 494     33 2013         NA
    ## 495     33 2014         NA
    ## 496     34 2000   827539.7
    ## 497     34 2001   823463.1
    ## 498     34 2002   834333.9
    ## 499     34 2003   847922.4
    ## 500     34 2004   858793.2
    ## 501     34 2005   880534.8
    ## 502     34 2006   929453.4
    ## 503     34 2007   948477.3
    ## 504     34 2008   952553.8
    ## 505     34 2009   866946.3
    ## 506     34 2010   831616.2
    ## 507     34 2011   887329.1
    ## 508     34 2012   911788.3
    ## 509     34 2013   930812.3
    ## 510     34 2014   945759.6
    ## 511     35 2000  6407099.7
    ## 512     35 2001  6704475.6
    ## 513     35 2002  6668430.1
    ## 514     35 2003  6632384.5
    ## 515     35 2004  6524247.8
    ## 516     35 2005  6533259.2
    ## 517     35 2006  6587327.6
    ## 518     35 2007  6686452.9
    ## 519     35 2008  6695464.3
    ## 520     35 2009  6506225.0
    ## 521     35 2010  6497213.6
    ## 522     35 2011  6632384.5
    ## 523     35 2012  6650407.3
    ## 524     35 2013  6704475.6
    ## 525     35 2014  6749532.6
    ## 526     36 2000  3566132.1
    ## 527     36 2001  3618498.2
    ## 528     36 2002  3618498.2
    ## 529     36 2003  3597551.8
    ## 530     36 2004  3576605.3
    ## 531     36 2005  3581841.9
    ## 532     36 2006  3628971.4
    ## 533     36 2007  3681337.5
    ## 534     36 2008  3723230.4
    ## 535     36 2009  3597551.8
    ## 536     36 2010  3566132.1
    ## 537     36 2011  3613261.6
    ## 538     36 2012  3634208.0
    ## 539     36 2013  3608025.0
    ## 540     36 2014  3597551.8
    ## 541     37 2000  6407099.7
    ## 542     37 2001  6704475.6
    ## 543     37 2002  6668430.1
    ## 544     37 2003  6632384.5
    ## 545     37 2004  6524247.8
    ## 546     37 2005  6533259.2
    ## 547     37 2006  6587327.6
    ## 548     37 2007  6686452.9
    ## 549     37 2008  6695464.3
    ## 550     37 2009  6506225.0
    ## 551     37 2010  6497213.6
    ## 552     37 2011  6632384.5
    ## 553     37 2012  6650407.3
    ## 554     37 2013  6704475.6
    ## 555     37 2014  6749532.6
    ## 556     38 2000  3566132.1
    ## 557     38 2001  3618498.2
    ## 558     38 2002  3618498.2
    ## 559     38 2003  3597551.8
    ## 560     38 2004  3576605.3
    ## 561     38 2005  3581841.9
    ## 562     38 2006  3628971.4
    ## 563     38 2007  3681337.5
    ## 564     38 2008  3723230.4
    ## 565     38 2009  3597551.8
    ## 566     38 2010  3566132.1
    ## 567     38 2011  3613261.6
    ## 568     38 2012  3634208.0
    ## 569     38 2013  3608025.0
    ## 570     38 2014  3597551.8
    ## 571     39 2000  6407099.7
    ## 572     39 2001  6704475.6
    ## 573     39 2002  6668430.1
    ## 574     39 2003  6632384.5
    ## 575     39 2004  6524247.8
    ## 576     39 2005  6533259.2
    ## 577     39 2006  6587327.6
    ## 578     39 2007  6686452.9
    ## 579     39 2008  6695464.3
    ## 580     39 2009  6506225.0
    ## 581     39 2010  6497213.6
    ## 582     39 2011  6632384.5
    ## 583     39 2012  6650407.3
    ## 584     39 2013  6704475.6
    ## 585     39 2014  6749532.6
    ## 586     40 2000  3566132.1
    ## 587     40 2001  3618498.2
    ## 588     40 2002  3618498.2
    ## 589     40 2003  3597551.8
    ## 590     40 2004  3576605.3
    ## 591     40 2005  3581841.9
    ## 592     40 2006  3628971.4
    ## 593     40 2007  3681337.5
    ## 594     40 2008  3723230.4
    ## 595     40 2009  3597551.8
    ## 596     40 2010  3566132.1
    ## 597     40 2011  3613261.6
    ## 598     40 2012  3634208.0
    ## 599     40 2013  3608025.0
    ## 600     40 2014  3597551.8
    ## 601     41 2000  6407099.7
    ## 602     41 2001  6704475.6
    ## 603     41 2002  6668430.1
    ## 604     41 2003  6632384.5
    ## 605     41 2004  6524247.8
    ## 606     41 2005  6533259.2
    ## 607     41 2006  6587327.6
    ## 608     41 2007  6686452.9
    ## 609     41 2008  6695464.3
    ## 610     41 2009  6506225.0
    ## 611     41 2010  6497213.6
    ## 612     41 2011  6632384.5
    ## 613     41 2012  6650407.3
    ## 614     41 2013  6704475.6
    ## 615     41 2014  6749532.6
    ## 616     42 2000  3566132.1
    ## 617     42 2001  3618498.2
    ## 618     42 2002  3618498.2
    ## 619     42 2003  3597551.8
    ## 620     42 2004  3576605.3
    ## 621     42 2005  3581841.9
    ## 622     42 2006  3628971.4
    ## 623     42 2007  3681337.5
    ## 624     42 2008  3723230.4
    ## 625     42 2009  3597551.8
    ## 626     42 2010  3566132.1
    ## 627     42 2011  3613261.6
    ## 628     42 2012  3634208.0
    ## 629     42 2013  3608025.0
    ## 630     42 2014  3597551.8

### 7.2 Set parameters

``` r
 ## set lag window for reference point calculations
  lag_win = 5  # 5 year lag
  trend_yr = 4 # to select the years for the trend calculation, select most recent year - 4 (to get 5 data points)
  bhi_rgn = data.frame(rgn_id = as.integer(seq(1,42,1))) #unique BHI region numbers to make sure all included with final score and trend
```

### 7.3 Status calculation

#### 7.3.1 prepare region and country layers

``` r
## LIV region: prepare for calculations with a lag
  liv_region = liv_regional_employ %>%
    dplyr::rename(employ = employ_pop_bhi) %>%
    filter(!is.na(employ)) %>%
    group_by(rgn_id)%>%
    mutate(year_ref = lag(year, lag_win, order_by=year),
           ref_val = lag(employ, lag_win, order_by=year)) %>% #create ref year and value which is value 5 years preceeding within a BHI region
    arrange(year)%>%
    filter(year>= max(year)- lag_win)%>% #select only the previous 5 years from the max year
    ungroup() %>%
    mutate(rgn_value = employ/ref_val) %>% #calculate rgn_value per year, numerator of score function
    select(rgn_id,year,rgn_value) %>%
   arrange(rgn_id,year)

head( liv_region)
```

    ## Source: local data frame [6 x 3]
    ## 
    ##   rgn_id  year rgn_value
    ##    <int> <int>     <dbl>
    ## 1      1  2009 0.9679326
    ## 2      1  2010 0.9940912
    ## 3      1  2011 1.0011584
    ## 4      1  2012 0.9971206
    ## 5      1  2013 1.0017341
    ## 6      1  2014 1.0524732

``` r
dim(liv_region) ##222 3
```

    ## [1] 222   3

``` r
## LIV country
  liv_country =   liv_national_employ %>%
    dplyr::rename(employ = employ_pop) %>%
    filter(!is.na(employ)) %>%
    group_by(rgn_id)%>%
    mutate(year_ref = lag(year, lag_win, order_by=year),
           ref_val = lag(employ, lag_win, order_by=year)) %>% #create ref year and value which is value 5 years preceeding within a BHI region
    arrange(year)%>%
    filter(year>= max(year)- lag_win)%>% #select only the previous 5 years from the max year
    ungroup() %>%
    mutate(cntry_value = employ/ref_val) %>% #calculate rgn_value per year, numerator of score function
    select(rgn_id,year,cntry_value) %>%
    arrange(rgn_id,year)

  head(liv_country)
```

    ## Source: local data frame [6 x 3]
    ## 
    ##   rgn_id  year cntry_value
    ##    <int> <int>       <dbl>
    ## 1      1  2009   0.9972376
    ## 2      1  2010   0.9944828
    ## 3      1  2011   1.0068399
    ## 4      1  2012   0.9946092
    ## 5      1  2013   1.0013459
    ## 6      1  2014   1.0373961

``` r
  dim(liv_country) ## 252  3
```

    ## [1] 252   3

#### 7.3.2 Calculate status time series

``` r
## calculate status
  liv_status_calc = inner_join(liv_region,liv_country, by=c("rgn_id","year"))%>% #join region and country current/ref ratios ## inner_join because need to have both region and country values to calculate
               mutate(Xliv = rgn_value/cntry_value)%>% #calculate status
               mutate(status = pmin(1, Xliv)) # status calculated cannot exceed 1

  head(liv_status_calc)
```

    ## Source: local data frame [6 x 6]
    ## 
    ##   rgn_id  year rgn_value cntry_value      Xliv    status
    ##    <int> <int>     <dbl>       <dbl>     <dbl>     <dbl>
    ## 1      1  2009 0.9679326   0.9972376 0.9706138 0.9706138
    ## 2      1  2010 0.9940912   0.9944828 0.9996062 0.9996062
    ## 3      1  2011 1.0011584   1.0068399 0.9943570 0.9943570
    ## 4      1  2012 0.9971206   0.9946092 1.0025250 1.0000000
    ## 5      1  2013 1.0017341   1.0013459 1.0003876 1.0000000
    ## 6      1  2014 1.0524732   1.0373961 1.0145336 1.0000000

``` r
  dim(liv_status_calc) ## 222 6
```

    ## [1] 222   6

#### 7.3.3 Extract most recent year status

``` r
liv_status = liv_status_calc%>%
              group_by(rgn_id)%>%
              filter(year== max(year))%>%       #select status as most recent year
              ungroup()%>%
              full_join(bhi_rgn, .,by="rgn_id")%>%  #all regions now listed, have NA for status, this should be 0 to indicate the measure is applicable, just no data
              mutate(score=round(status*100),   #scale to 0 to 100
                     dimension = 'status')%>%
              select(region_id = rgn_id,score, dimension) #%>%
              ##mutate(score= replace(score,is.na(score), 0)) #assign 0 to regions with no status calculated because insufficient or no data
                                    ##will this cause problems if there are regions that should be NA (because indicator is not applicable?)

head(liv_status)
```

    ##   region_id score dimension
    ## 1         1   100    status
    ## 2         2   100    status
    ## 3         3   100    status
    ## 4         4   100    status
    ## 5         5    98    status
    ## 6         6   100    status

``` r
## what is max year
max_year_status= liv_status_calc%>%
              group_by(rgn_id)%>%
              filter(year== max(year))%>%       #select status as most recent year
              ungroup()%>%
              select(rgn_id,year)
max_year_status %>% select(year)%>% distinct() ## all final years are 2014
```

    ## Source: local data frame [1 x 1]
    ## 
    ##    year
    ##   <int>
    ## 1  2014

### 7.3.4 Which BHI regions have no status

Regions 19,21,22,30,33 have NA status.

Russian regions have NA status because no regional data (19,22,33)

Regions with no coast line have no status because not joined to a NUTS reion (30)

Region with mis-assigned NUTS3 to BHI regions: 21 - See 4.2.2 about Polish NUTS3 regions

``` r
liv_status %>% filter(is.na(score)) #19,21,22,30,33
```

    ##   region_id score dimension
    ## 1        19    NA    status
    ## 2        21    NA    status
    ## 3        22    NA    status
    ## 4        30    NA    status
    ## 5        33    NA    status

### 7.3.1 Plot status

Status values in the time series are between 0 and 1.
There are no values for Russia because we do not have regional GDP data.
Status values for the most recent year (2014 for all regions) are transformed to value between 0 and 100

``` r
## plot liv status time series
ggplot(liv_status_calc)+
  geom_point(aes(year,status))+
  facet_wrap(~rgn_id)+
  ylim(0,1)+
  ylab("Status")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"),
        axis.text.y = element_text(size=6))+
  ggtitle("LIV status time series")
```

    ## Warning: Removed 25 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/plot%20liv%20status-1.png)

``` r
## plot liv status time series, less range on y-axis
ggplot(liv_status_calc)+
  geom_point(aes(year,status))+
  facet_wrap(~rgn_id)+
  ylim(.8,1)+
  ylab("Status")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90,
                                   hjust=.5, vjust=.5, face = "plain"),
        axis.text.y = element_text(size=6))+
  ggtitle("LIV status time series - different y-axis range")
```

    ## Warning: Removed 25 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/plot%20liv%20status-2.png)

``` r
## plot final year (2014) status

ggplot(liv_status)+
  geom_point(aes(region_id,score), size=2)+
  ylim(0,100)+
  ylab("Status score")+
  xlab("BHI region")+
  ggtitle("LIV status score in 2014")
```

    ## Warning: Removed 5 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/plot%20liv%20status-3.png)

### 7.4 Trend calculation

#### 7.4.1 Calculate Trend

``` r
  ## calculate trend for 5 years (5 data points)
  ## years are filtered in liv_region and liv_country, so not filtered for here
      liv_trend = liv_status_calc %>%
        filter(year >= max(year - trend_yr))%>%                #select five years of data for trend
        filter(!is.na(status)) %>%                              # filter for only no NA data because causes problems for lm if all data for a region are NA
        group_by(rgn_id) %>%
        mutate(regr_length = n())%>%                            #get the number of status years available for greggion
        filter(regr_length == (trend_yr + 1))%>%                   #only do the regression for regions that have 5 data points
          do(mdl = lm(status ~ year, data = .)) %>%             # regression model to get the trend
            summarize(rgn_id = rgn_id,
                      score = coef(mdl)['year'] * lag_win)%>%
        ungroup() %>%
        full_join(bhi_rgn, .,by="rgn_id")%>%  #all regions now listed, have NA for trend #should this stay NA?  because a 0 trend is meaningful for places with data
        mutate(score = round(score, 2),
               dimension = "trend") %>%
        select(region_id = rgn_id, dimension, score) %>%
        data.frame()
```

#### 7.4.2 Which regions have NA trend?

Same regions as NA status and also Danish regions because have a short time series.

Should the calculation be modifed so only 3 out of the last five years need for a trend?

``` r
liv_trend %>% filter(is.na(score)) ## 2,3,6,7,9,12,15,19,21,22,30,33
```

    ##    region_id dimension score
    ## 1          2     trend    NA
    ## 2          3     trend    NA
    ## 3          6     trend    NA
    ## 4          7     trend    NA
    ## 5          9     trend    NA
    ## 6         12     trend    NA
    ## 7         15     trend    NA
    ## 8         19     trend    NA
    ## 9         21     trend    NA
    ## 10        22     trend    NA
    ## 11        30     trend    NA
    ## 12        33     trend    NA

#### 7.4.3 Plot trend

``` r
ggplot(liv_trend)+
  geom_point(aes(region_id,score), size=2)+
  geom_hline(yintercept = 0)+
  ylim(-1,1)+
  ylab("Status score")+
  xlab("BHI region")+
  ggtitle("LIV 5 yr trend score")
```

    ## Warning: Removed 12 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/plot%20liv%20trend-1.png)

#### 7.5 Plot trend and status together

``` r
plot_liv = bind_rows(liv_status,liv_trend)

ggplot(plot_liv)+
  geom_point(aes(region_id,score),size=2.5)+
  facet_wrap(~dimension, scales = "free_y")+
  ylab("Score")+
  ggtitle("LIV Status and Trend")
```

    ## Warning: Removed 17 rows containing missing values (geom_point).

![](liv_prep_files/figure-markdown_github/plot%20liv%20trend%20and%20status%20together-1.png)

8. Data issues and concerns
---------------------------

### 8.1 Shapefile incorrect assignments

Some corrected in 4.1.4.

But, Note - (as in NUTS3 assignment issues see ECO), BHI region 21 not assigned to any NUTS2 regions - despite clear association with PL63. PL63 split only between BHI 17 and BHI 18. This could not be fixed manually

### 8.2 Finnish NUTS2 name discrepancies

See 5.2.2

One challenge is that the new regions are two regions (FI1B,FI1C) where the old region was one (FI18). FI1B includes Helsinki and plot below shows similar pattern but that FI1B is between 5.8 to 6.8 higher than FI1C.

Assume because FI1B is where Helsinki is located, this is the majority of the population, so apply the FI1B rate.

FI1D (new name) areas match old FIA1 areas - so this is a straight-forward fix.

![See Population density from Eurostat](pop_density_nuts2_FI.png?raw=TRUE) [Eurostat Population density image source](http://ec.europa.eu/eurostat/statistical-atlas/gis/viewer/#). Layer is under 'Background Maps'

### 8.3 No Russian regional data

No regional employment data for Russia (St. Petersburg and Kalingrad) so status cannot be calculated.

### 8.4 Employment data for EU transformed from percent to number of people using 2005 population data for all years

This is done for both the regional and the national datasets.

### 8.5 Short Danish timeseries

Danish regional time series are shorter. Data begin in 2007. Because data from 5 years prevous are need to calculated the regional/ref value, only three status years can be calculated. This also means that no trend is calculated because 5 years is required.
