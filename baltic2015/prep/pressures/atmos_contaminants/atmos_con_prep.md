atmos\_con\_prep.rmd
================

-   [Preparation of the Atmospheric Contaminants pressure data layer](#preparation-of-the-atmospheric-contaminants-pressure-data-layer)
    -   [1. Background](#background)
    -   [2. Data](#data)
        -   [2.1 Atmospheric deposition of PCB-153 on the Baltic Sea](#atmospheric-deposition-of-pcb-153-on-the-baltic-sea)
        -   [2.2 Atmospheric deposition of PCDD/Fs on the Baltic Sea](#atmospheric-deposition-of-pcddfs-on-the-baltic-sea)
    -   [3. Pressure Model](#pressure-model)
        -   [3.1 Current conditions](#current-conditions)
        -   [3.2 Rescaling](#rescaling)
    -   [4. Data layer preparation](#data-layer-preparation)
        -   [4.1 Read in and organize data](#read-in-and-organize-data)
        -   [4.2 Current value](#current-value)
        -   [4.3 Rescale data](#rescale-data)
        -   [4.4 Pressure layer for BHI regions](#pressure-layer-for-bhi-regions)
        -   [4.5 Prepare and save object for layers](#prepare-and-save-object-for-layers)

Preparation of the Atmospheric Contaminants pressure data layer
===============================================================

1. Background
-------------

2. Data
-------

### 2.1 Atmospheric deposition of PCB-153 on the Baltic Sea

Data are provided for nine major Baltic Sea basins: Archipelago Sea, Baltic Proper, Bothnian Bay, Bothnian Sea, Gulf of Finland, Gulf of Riga, Kattegat, The Sound, Western Baltic.

[Data downloaded from the HELCOM website](http://www.helcom.fi/baltic-sea-trends/environment-fact-sheets/hazardous-substances/atmospheric-deposition-of-pcb-153-on-the-baltic-sea/) on 23 June 2016. File name 'PCB-153\_deposition\_data.xls' Data are provided on the basin level.

#### 2.1.1 Additional reference information as provided on the HELCOM website

**Data Source: EMEP/MSC**

1.  Description of data: Annual atmospheric deposition fluxes of PCB-153 were obtained using the latest version of MSCE-POP model developed at EMEP/MSC-E (Gusev et al., 2005). Assessment of global scale transport and fate of PCBs was made on the basis of the inventory of global PCB emissions \[Breivik et al., 2007\] and emissions officially reported by the EMEP countries. The inventory of Breivik et al. \[2007\] provided consistent set of historical and future emissions of 22 individual PCB congeners from 1930 up to 2100. Model simulations for the period 1990 and 2013 were carried out for indicator congener PCB-153. The spatial distribution of PCB-153 emissions within the EMEP region was prepared using gridded PCB emissions officially submitted by 19 EMEP countries, including all HELCOM countries except Russia, and the emission expert estimates worked out by TNO \[Denier van der Gon et al., 2005\].

2.  Geographical coverage:
    Annual atmospheric deposition fluxes of PCB-153 were obtained for the EMEP region.

3.  Temporal coverage:
    Timeseries of annual atmospheric deposition are available for the period 1990 – 2013.

4.  Methodology and frequency of data collection:
    Atmospheric input and source allocation budgets of PCB-153 to the Baltic Sea and its catchment area were computed using the latest version of MSCE-POP model. MSCE-POP is the regional-scale model operating within the EMEP region. This is a three-dimensional Eulerian model which includes processes of emission, advection, turbulent diffusion, wet and dry deposition, degradation, gaseous exchange with underlying surface, and inflow of pollutant into the model domain. Horizontal grid of the model is defined using stereographic projection with spatial resolution 50 km at 60º latitude. The description of EMEP horizontal grid system can be found in the internet (<http://www.emep.int/grid/index.html>). Vertical structure of the model consists of 15 non-uniform layers defined in the terrain-following s-coordinates and covers almost the whole troposphere. Detailed description of the model can be found in EMEP reports (Gusev et al., 2005) and in the Internet on EMEP web page (<http://www.emep.int/>) under the link to information on Persistent Organic Pollutants. Meteorological data used in the calculations for 1990-2013 were obtained using MM5 meteorological data preprocessor on the basis of meteorological analysis of European Centre for Medium-Range Weather Forecasts (ECMWF).

Results of model simulation of atmospheric transport and annual deposition of PCB-153 are provided on the regular basis annually two years in arrears on the basis of emission data officially submitted by Parties to CLRTAP Convention and available expert estimates of emission.

Quality information
Strength: annually updated information on atmospheric input of PCB-153 to the Baltic Sea and its sub-basins.
Weakness: uncertainties in emissions of PCBs.

1.  Uncertainty:
    The MSCE-POP model results were compared with measurements of EMEP monitoring network \[Gusev et al., 2006, Shatalov et al., 2005\]. The model was evaluated through the comparison with available measurements during EMEP TFMM meetings held in 2005. It was concluded that the MSCE-POP model is suitable for the evaluation of the long range transboundary transport and deposition of POPs in Europe.

References

Breivik K., Sweetman A., Pacyna J.M., Jones K.C. \[2007\] Towards a global historical emission inventory for selected PCB congeners - A mass balance approach-3. An update. Science of the Total Environment, vol. 377, pp. 296-307.

Denier van der Gon H.A.C., van het Bolscher M., Visschedijk A.J.H. and P.Y.J.Zandveld \[2005\]. Study to the effectiveness of the UNECE Persistent Organic Pollutants Protocol and costs of possible additional measures. Phase I: Estimation of emission reduction resulting from the implementation of the POP Protocol. TNO-report B&O-A R 2005/194.

Gusev A., I. Ilyin, L.Mantseva, O.Rozovskaya, V. Shatalov, O. Travnikov \[2006\] Progress in further development of MSCE-HM and MSCE-POP models (implementation of the model review recommendations. EMEP/MSC-E Technical Report 4/2006. (<http://www.msceast.org/reps/4_2006.zip>)

Gusev A., E. Mantseva, V. Shatalov, B.Strukov \[2005\] Regional multicompartment model MSCE-POP EMEP/MSC-E Technical Report 5/2005. (<http://www.msceast.org/events/review/pop_description.html>)

Shatalov V., Gusev A., Dutchak S., Holoubek I., Mantseva E., Rozovskaya O., Sweetman A., Strukov B. and N.Vulykh \[2005\] Modelling of POP Contamination in European Region: Evaluation of the Model Performance. Technical Report 7/2005. (<http://www.msceast.org/reps/7_2005.zip>)"

### 2.2 Atmospheric deposition of PCDD/Fs on the Baltic Sea

[Data downloaded from the HELCOM website](http://www.helcom.fi/baltic-sea-trends/environment-fact-sheets/hazardous-substances/atmospheric-deposition-of-pcdd-fs-on-the-baltic-sea/) on 23 June 2016. File name 'PCDDF\_deposition\_data\_BSEFS2014.xls' Data are provided on the basin level.

**We will use the Computed annual atmospheric deposition of PCDD/Fs obtained using scenario with adjusted emissions.** (see Table 2 below in 2.2.1)

#### 2.2.1 Additional information as provided on the HELCOM website

Data Numerical data on computed PCDD/F depositions to the Baltic Sea are given in the following tables and can be found in the attached Microsoft Excel file (PCDDF\_deposition\_data.xls).

Table 1. Computed annual atmospheric deposition of PCDD/Fs over the six Baltic Sea sub-basins, the whole Baltic Sea (BAS) and normalized deposition to the Baltic Sea (Norm) for period 1990-2012 obtained using official data on emissions.

Table 2. Computed annual atmospheric deposition of PCDD/Fs over the six Baltic Sea sub-basins, the whole Baltic Sea (BAS) and normalized deposition to the Baltic Sea (Norm) for period 1990-2012 obtained using scenario with adjusted emissions.

Table 3. Computed contributions by country to annual total deposition of PCDD/Fs to nine Baltic Sea sub-basins for the year 2012 obtained using official data on emissions.

Table 4. Computed contributions by country to annual total deposition of PCDD/Fs to nine Baltic Sea sub-basins for the year 2012 obtained using scenario with adjusted emissions.
 Metadata 1. **Source: EMEP/MSC-E**

1.  Description of data:
    Annual atmospheric deposition fluxes of PCDD/Fs were obtained using the latest version of MSCE-POP model developed at EMEP/MSC-E (Gusev et al., 2005). The latest available official emission data for the HELCOM countries have been used in the model computations. Emissions of PCDD/Fs for each year of this period were officially reported to the UN ECE Secretariat by most of the HELCOM countries. These data are available from the EMEP Centre on Emission Inventories and Projections (CEIP) (<http://www.ceip.at/>).

2.  Geographical coverage: Annual atmospheric deposition fluxes of PCDD/Fs were obtained for the European region.

3.  Temporal coverage:
    Timeseries of annual atmospheric deposition are available for the period 1990 – 2012.

4.  Methodology and frequency of data collection:
    Atmospheric input and source allocation budgets of PCDD/Fs to the Baltic Sea and its catchment area were computed using the latest version of MSCE-POP model. MSCE-POP is the regional-scale model operating within the EMEP region. This is a three-dimensional Eulerian model which includes processes of emission, advection, turbulent diffusion, wet and dry deposition, degradation, gaseous exchange with underlying surface, and inflow of pollutant into the model domain. Horizontal grid of the model is defined using stereographic projection with spatial resolution 50 km at 60º latitude. The description of EMEP horizontal grid system can be found in the internet (<http://www.emep.int/grid/index.html>). Vertical structure of the model consists of 15 non-uniform layers defined in the terrain-following s-coordinates and covers almost the whole troposphere. Detailed description of the model can be found in EMEP reports (Gusev et al., 2005) and in the Internet on EMEP web page (<http://www.emep.int/>) under the link to information on Persistent Organic Pollutants. Meteorological data used in the calculations for 1990-2012 were obtained using MM5 meteorological data preprocessor on the basis of meteorological analysis of European Centre for Medium-Range Weather Forecasts (ECMWF).

Results of model simulation of atmospheric transport and annual deposition of PCDD/Fs are provided on the regular basis annually two years in arrears on the basis of emission data officially submitted by Parties to CLRTAP Convention.

Quality information:
Strength: annually updated information on atmospheric input of PCDD/Fs to the Baltic Sea and its sub-basins.
Weakness: uncertainties in officially submitted data on emissions of PCDD/Fs.

Uncertainty:
The MSCE-POP model results were compared with measurements of EMEP monitoring network \[Gusev et al., 2006, Shatalov et al., 2005\]. The model was evaluated through the comparison with available measurements during EMEP TFMM meetings held in 2005. It was concluded that the MSCE-POP model is suitable for the evaluation of the long range transboundary transport and deposition of POPs in Europe.

References

Gusev A., I. Ilyin, L.Mantseva, O.Rozovskaya, V. Shatalov, O. Travnikov \[2006\] Progress in further development of MSCE-HM and MSCE-POP models (implementation of the model review recommendations. EMEP/MSC-E Technical Report 4/2006. (<http://www.msceast.org/reps/4_2006.zip>)

Gusev A., E. Mantseva, V. Shatalov, B.Strukov \[2005\] Regional multicompartment model MSCE-POP EMEP/MSC-E Technical Report 5/2005. (<http://www.msceast.org/events/review/pop_description.html>)

Shatalov V., Gusev A., Dutchak S., Holoubek I., Mantseva E., Rozovskaya O., Sweetman A., Strukov B. and N.Vulykh \[2005\] Modelling of POP Contamination in European Region: Evaluation of the Model Performance. Technical Report 7/2005. (<http://www.msceast.org/reps/7_2005.zip>)

3. Pressure Model
-----------------

Will create two separate pressure layers (PCB 153 and PCDDF) which can either be combined into a single pressure layer or only one can be used.

### 3.1 Current conditions

Value in most recent year. PCDDF = 2012
PCB 153 = 2013

### 3.2 Rescaling

Min value = 0

Max value = maximum value across all basin 1990 - max year

4. Data layer preparation
-------------------------

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



dir_atmos_con    = file.path(dir_prep,'pressures/atmos_contaminants')


## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_atmos_con, 'atmos_con_prep.rmd') 
```

### 4.1 Read in and organize data

#### 4.1.1 Read in data

``` r
pcb153 = read.csv(file.path( dir_atmos_con, "data_database/pcb153.csv"), stringsAsFactors = FALSE)
str(pcb153)
```

    ## 'data.frame':    9 obs. of  29 variables:
    ##  $ basin_loading: chr  "Archipelago Sea" "Bothnian Bay" "Bothnian Sea" "Baltic Proper" ...
    ##  $ basin_abb    : chr  "ARC" "BOB" "BOS" "BAP" ...
    ##  $ data_type    : logi  NA NA NA NA NA NA ...
    ##  $ substance    : chr  "PCB 153" "PCB 153" "PCB 153" "PCB 153" ...
    ##  $ unit         : chr  "kg/year" "kg/year" "kg/year" "kg/year" ...
    ##  $ X1990        : num  1.6 3 3.6 21.1 5.7 3.9 3.3 1.4 7.1
    ##  $ X1991        : num  1.7 3.1 3.9 19.8 5.8 4.1 3.1 1.3 6.6
    ##  $ X1992        : num  1.7 3.2 4 20.1 5.8 4.1 3.1 1.3 7
    ##  $ X1993        : num  1.6 3 3.8 19 5.4 3.8 3 1.2 6.5
    ##  $ X1994        : num  1.5 2.9 3.6 18.8 5.4 3.7 3 1.2 6.8
    ##  $ X1995        : num  1.5 3 3.7 18.1 5.4 3.8 3 1.1 6.2
    ##  $ X1996        : num  1.4 2.6 3.2 15.6 5 3.3 2.5 1 5.4
    ##  $ X1997        : num  1.2 2.4 3.1 15.9 4.5 3.2 2.6 1 5.6
    ##  $ X1998        : num  1.2 2.3 3 15.7 4.5 3.2 2.4 1 5.6
    ##  $ X1999        : num  1.3 2.4 3.1 15.7 4.5 3.3 2.5 1 5.4
    ##  $ X2000        : num  1.2 2.2 2.8 14.4 4.1 3 2.4 0.9 5.2
    ##  $ X2001        : num  1 1.9 2.5 12.4 3.8 2.7 1.9 0.7 4.2
    ##  $ X2002        : num  0.8 1.7 2.1 10.7 3.1 2.2 1.6 0.6 3.7
    ##  $ X2003        : num  0.7 1.7 2 9.6 3 2.1 1.5 0.5 3.2
    ##  $ X2004        : num  0.7 1.4 1.8 8.8 2.9 2 1.3 0.5 2.9
    ##  $ X2005        : num  0.7 1.5 1.8 8.1 2.8 1.9 1.2 0.4 2.7
    ##  $ X2006        : num  0.7 1.4 1.8 8.7 2.8 1.9 1.3 0.5 3
    ##  $ X2007        : num  0.6 1.2 1.5 7.5 2.5 1.8 1 0.4 2.4
    ##  $ X2008        : num  0.5 1.1 1.4 7.2 2.4 1.7 1 0.4 2.4
    ##  $ X2009        : num  0.5 1.1 1.3 6.5 2.2 1.5 1 0.4 2.2
    ##  $ X2010        : num  0.5 1.1 1.2 6.2 2.3 1.6 0.9 0.3 1.9
    ##  $ X2011        : num  0.5 1.1 1.3 6.7 2.2 1.5 1 0.4 2.1
    ##  $ X2012        : num  0.5 1 1.2 6.4 2.1 1.5 0.9 0.4 2.1
    ##  $ X2013        : num  0.4 1 1.2 5.8 2 1.3 0.8 0.3 1.9

``` r
pcddf = read.csv(file.path( dir_atmos_con, "data_database/pcddf.csv"), stringsAsFactors = FALSE)
str(pcddf)
```

    ## 'data.frame':    18 obs. of  28 variables:
    ##  $ basin_loading: chr  "Archipelago Sea" "Bothnian Bay" "Bothnian Sea" "Baltic Proper" ...
    ##  $ basin_abb    : chr  "ARC" "BOB" "BOS" "BAP" ...
    ##  $ data_type    : chr  "official data on emissions" "official data on emissions" "official data on emissions" "official data on emissions" ...
    ##  $ substance    : chr  "PCDD/F" "PCDD/F" "PCDD/F" "PCDD/F" ...
    ##  $ unit         : chr  "g TEQ / year" "g TEQ / year" "g TEQ / year" "g TEQ / year" ...
    ##  $ X1990        : num  4.1 8.3 10 59.4 10.2 9.8 10.2 5.1 21.8 22 ...
    ##  $ X1991        : num  3.6 6.1 6.8 49.7 8.8 8.4 8.3 4.4 18.3 19 ...
    ##  $ X1992        : num  3.1 5.7 6.4 48.2 8.5 8.5 8.3 4.1 18.8 17 ...
    ##  $ X1993        : num  3.5 6.4 7.2 43.7 8 7.9 7.4 3.4 14.7 19 ...
    ##  $ X1994        : num  3.2 5.8 6.5 43.9 8.1 8 7.2 3.5 15.3 17 ...
    ##  $ X1995        : num  3.2 5.9 7.5 38.7 7.8 7.8 5.9 3 12.3 17 ...
    ##  $ X1996        : num  2.6 4.7 5.2 38.3 7.2 7.2 5.6 2.7 11.4 14 ...
    ##  $ X1997        : num  2.3 4.5 5 31.7 6.2 6.1 5.3 2.6 10.6 12 ...
    ##  $ X1998        : num  2.6 4.6 5.3 30.8 6.6 6.4 4.6 2.3 9.8 14 ...
    ##  $ X1999        : num  2.4 4.7 5.4 28.8 6.9 6.3 4.2 2.1 8.8 13 ...
    ##  $ X2000        : num  2.1 4.1 4.6 27.2 6 5.5 4.4 2.1 8.9 11 ...
    ##  $ X2001        : num  2.3 4 5.1 28.7 6.1 5.7 4.3 2 7.7 13 ...
    ##  $ X2002        : num  1.7 3 3.8 24.1 5.4 4.9 3.7 1.8 8.4 9 ...
    ##  $ X2003        : num  1.6 3 3.5 22.4 5.5 4.8 3.5 1.8 7.5 9 ...
    ##  $ X2004        : num  1.9 3.4 4.4 22.1 5.8 5 3.4 1.6 6.4 10 ...
    ##  $ X2005        : num  2 3.2 4.5 23.8 6 5.6 3.2 1.5 6.3 11 ...
    ##  $ X2006        : num  1.7 2.8 4.2 22.6 5.5 4.9 3.8 1.6 6.5 9 ...
    ##  $ X2007        : num  1.5 2.6 3.7 21.3 5.9 5 3.5 1.6 6.8 8 ...
    ##  $ X2008        : num  1.8 3.3 4.6 22.9 7 5.5 3.6 1.6 6.9 10 ...
    ##  $ X2009        : num  1.8 2.9 4.5 23.1 6.5 5.3 3.5 1.6 6.4 9 ...
    ##  $ X2010        : num  1.9 3.2 4.5 26.4 7.1 5.6 3.7 1.6 6.2 10 ...
    ##  $ X2011        : num  1.5 2.8 3.7 20.9 6.5 5 3.3 1.5 5.9 8 ...
    ##  $ X2012        : num  2.1 3.8 5.4 22.5 7.3 5.4 3 1.3 5.1 11 ...

``` r
atmos_basin_lookup = read.csv(file.path( dir_atmos_con, "data_database/atmos_loading_basin_lookup.csv"), stringsAsFactors = FALSE)
str(atmos_basin_lookup)
```

    ## 'data.frame':    17 obs. of  2 variables:
    ##  $ holas_basin  : chr  "Kattegat" "Great Belt" "The Sound" "Kiel Bay" ...
    ##  $ basin_loading: chr  "Kattegat" "Western Baltic" "The Sound" "Western Baltic" ...

``` r
bhi_lookup = read.csv(file.path( dir_atmos_con, "bhi_basin_country_lookup.csv"),sep=";", stringsAsFactors = FALSE) %>%
              select(BHI_ID, Subbasin)%>%
              dplyr::rename(rgn_id = BHI_ID,
                            holas_basin = Subbasin)
str(bhi_lookup)
```

    ## 'data.frame':    42 obs. of  2 variables:
    ##  $ rgn_id     : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ holas_basin: chr  "Kattegat" "Kattegat" "Great Belt" "Great Belt" ...

#### 4.1.2 Transform data to long format

``` r
pcb153_long = pcb153 %>%
              gather(year, value, -basin_loading,-basin_abb,-data_type,-substance,-unit) %>%
              mutate(year = substr(year,2,5),
                     year = as.numeric(year),
                     value = as.numeric(value))
              

pcddf_long = pcddf %>%
              gather(year, value, -basin_loading,-basin_abb,-data_type,-substance,-unit) %>%
              mutate(year = substr(year,2,5),
                     year = as.numeric(year),
                     value = as.numeric(value))
```

#### 4.1.3 Join to HOLAS basin names

Data are joined to HOLAS basin names because these are what are associated with BHI regions. This is a slightly indirect approach, could have made a look up table to associated the major basins from the deposition data directly with the BHI regions, but this should have the same result.

``` r
pcb153_long1 = pcb153_long %>%
               full_join(., atmos_basin_lookup,by="basin_loading")

pcddf_long1 = pcddf_long %>%
               full_join(., atmos_basin_lookup,by="basin_loading")
```

#### 4.1.4 Plot data by Major basin provided

``` r
ggplot(pcb153_long1)+
  geom_point(aes(year,value))+
  facet_wrap(~basin_loading)+
  ylab("PCB 153 kg/year")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                  hjust=.5, vjust=.5, face = "plain"),
          strip.text.x = element_text(size = 6))+
  ggtitle("PCB153 Atmospheric Deposition by Major Basin")
```

![](atmos_con_prep_files/figure-markdown_github/plot%20raw%20data%20by%20major%20basin%20provided-1.png)

``` r
ggplot(pcddf_long1)+
  geom_point(aes(year,value,colour=data_type))+
  facet_wrap(~basin_loading)+
  ylab("PCDD/F g TEQ / year")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                  hjust=.5, vjust=.5, face = "plain"),
          strip.text.x = element_text(size = 6))+
  ggtitle("PCDD/F Atmospheric Deposition by Major Basin")
```

![](atmos_con_prep_files/figure-markdown_github/plot%20raw%20data%20by%20major%20basin%20provided-2.png)

#### 4.1.5 Plot data by HOLAS basin

``` r
ggplot(pcb153_long1)+
  geom_point(aes(year,value))+
  facet_wrap(~holas_basin)+
  ylab("PCB 153 kg/year")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                  hjust=.5, vjust=.5, face = "plain"),
          strip.text.x = element_text(size = 6))+
  ggtitle("PCB153 Atmospheric Deposition by HOLAS Basin")
```

![](atmos_con_prep_files/figure-markdown_github/plot%20raw%20data%20by%20holas%20basin-1.png)

``` r
ggplot(pcddf_long1)+
  geom_point(aes(year,value,colour=data_type))+
  facet_wrap(~holas_basin)+
  ylab("PCDD/F g TEQ / year")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                  hjust=.5, vjust=.5, face = "plain"),
          strip.text.x = element_text(size = 6))+
  ggtitle("PCDD/F Atmospheric Deposition HOLAS Basin")
```

![](atmos_con_prep_files/figure-markdown_github/plot%20raw%20data%20by%20holas%20basin-2.png)

#### 4.1.6 Select PCDFF scenario data

``` r
pcddf_long2 = pcddf_long1 %>%
              filter(data_type == "scenario with adjusted emissions")
dim(pcddf_long1); dim(pcddf_long2)
```

    ## [1] 782   8

    ## [1] 391   8

### 4.2 Current value

#### 4.2.1 Get most recent year for current value

``` r
max_yr_pcb153 = pcb153_long1 %>%
                select(year)%>%
                max()%>%
                as.numeric()



max_yr_pcddf = pcddf_long2 %>%
                select(year)%>%
                max()%>%
                as.numeric()
```

#### 4.2.2 Get current pressure data

``` r
current_pcb153 = pcb153_long1 %>%
                 filter(year == max_yr_pcb153) %>%
                 select(holas_basin, value, unit, year)



current_pcddf =  pcddf_long2%>%
                 filter(year == max_yr_pcddf) %>%
                 select(holas_basin, value, unit, year)
```

#### 4.2.3 Plot current year data

``` r
ggplot(current_pcb153)+
  geom_point(aes(holas_basin, value), size = 2.5)+
  ylab("PCB 153 kg/year")+
  ylim(0,8)+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                  hjust=.5, vjust=.5, face = "plain"),
          strip.text.x = element_text(size = 6))+
  ggtitle("PCB 153 Atmospheric Deposition in 2013")
```

![](atmos_con_prep_files/figure-markdown_github/plot%20current%20year%20data-1.png)

``` r
ggplot(current_pcddf)+
geom_point(aes(holas_basin, value), size = 2.5)+
ylab("PCDD/F g TEQ / year")+
ylim(0,150)+
 theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                hjust=.5, vjust=.5, face = "plain"),
        strip.text.x = element_text(size = 6))+
ggtitle("PCDD/F Atmospheric Deposition in 2012")
```

![](atmos_con_prep_files/figure-markdown_github/plot%20current%20year%20data-2.png)

### 4.3 Rescale data

#### 4.3.1 Maximum value

Select maximum value across all basins within each time series. PCB 153: Baltic Proper in 1990, 21.1 kg/year
PCDD/F: Baltic Proper in 1990, 320 g TEQ / year

``` r
max_pcb153 = pcb153_long1 %>%
             select(value)%>%
             max()%>%
             as.numeric()
max_pcb153
```

    ## [1] 21.1

``` r
## which year and basin 
pcb153_long1 %>% filter(value == max_pcb153) %>% select(basin_loading, year, unit,value)%>% distinct()
```

    ##   basin_loading year    unit value
    ## 1 Baltic Proper 1990 kg/year  21.1

``` r
max_pcddf = pcddf_long2 %>%
             select(value)%>%
             max()%>%
             as.numeric()
max_pcddf
```

    ## [1] 320

``` r
## which year and basin 
pcddf_long2 %>% filter(value == max_pcddf) %>% select(basin_loading, year, unit,value)%>% distinct()
```

    ##   basin_loading year         unit value
    ## 1 Baltic Proper 1990 g TEQ / year   320

#### 4.3.2 Minimum value

Minimum value is 0, the value at which there is no pressure

``` r
min_pcb153 =0

min_pcddf = 0
```

#### 4.3.3 Join current, max, and min values

``` r
pcb153_rescale = current_pcb153%>%
                 mutate(min = min_pcb153, 
                        max= max_pcb153) %>% 
                 dplyr:: rename(current = value)

pcddf_rescale = current_pcddf%>%
                 mutate(min = min_pcddf, 
                        max= max_pcddf)%>%
                  dplyr:: rename(current = value)
```

#### 4.3.4 Plot current, max and min

``` r
ggplot(gather(pcb153_rescale, type, concentration, -holas_basin,-unit,-year))+
  geom_point(aes(holas_basin, concentration, colour = type, shape=type), size= 2.5)+
  ylab("PCB 153 kg/year")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("PCB 153 minimum, maximum, and current pressure value")
```

![](atmos_con_prep_files/figure-markdown_github/plot%20current%20max%20and%20min-1.png)

``` r
ggplot(gather(pcddf_rescale, type, concentration, -holas_basin,-unit,-year))+
  geom_point(aes(holas_basin, concentration, colour = type, shape=type), size= 2.5)+
  ylab("PCDD/F g TEQ / year")+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("PCDD/F minimum, maximum, and current pressure value")
```

![](atmos_con_prep_files/figure-markdown_github/plot%20current%20max%20and%20min-2.png)

#### 4.3.5 Rescale data

``` r
pcb153_rescale1 = pcb153_rescale %>%
                  mutate(pcb153_normalize = (current - min)/(max - min))



pcddf_rescale1 = pcddf_rescale %>%
                  mutate(pcddf_normalize = (current - min)/(max - min))
```

#### 4.3.6 Plot rescaled pressure layer

``` r
ggplot(pcb153_rescale1)+
  geom_point(aes(holas_basin,pcb153_normalize), size= 2.5)+
  ylab("Pressure Value")+
  ylim(0,1)+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("PCB 153 pressure value")
```

![](atmos_con_prep_files/figure-markdown_github/plot%20rescales%20pressure%20layer-1.png)

``` r
ggplot(pcddf_rescale1)+
  geom_point(aes(holas_basin, pcddf_normalize), size= 2.5) +
 ylab("Pressure Value")+
  ylim(0,1)+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("PCDD/F Pressure value")
```

![](atmos_con_prep_files/figure-markdown_github/plot%20rescales%20pressure%20layer-2.png)

#### 4.3.7 Plot and compare two contaminants rescaled pressure layers

**PCB153 is in the open red dots, and PCDDF is in the filled black dots**
Higher pressure from PCDDF, but magnitude of difference varies among basins

``` r
plot_compare = full_join(
                select(pcb153_rescale1, holas_basin, pcb153_normalize),
                select(pcddf_rescale1, holas_basin, pcddf_normalize),
                by = "holas_basin")

ggplot(plot_compare)+
  geom_point(aes(holas_basin,pcb153_normalize), size= 2.5, colour = "red", shape = 1)+
  geom_point(aes(holas_basin, pcddf_normalize), size= 2.5, colour = "black") +
  ylab("Pressure Value")+
  ylim(0,1)+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Compare PCB153 and PCDD/F Pressure values")
```

![](atmos_con_prep_files/figure-markdown_github/plot%20and%20compare%20pcb153%20and%20pcddf-1.png)

### 4.4 Pressure layer for BHI regions

#### 4.4.1 Apply basin values to BHI regions

``` r
pcb153_rgn = pcb153_rescale1 %>%
            full_join(., bhi_lookup, by = "holas_basin") %>%
            select(rgn_id, pcb153_normalize)%>%
            arrange(rgn_id)

pcddf_rgn = pcddf_rescale1 %>%
            full_join(., bhi_lookup, by = "holas_basin") %>%
            select(rgn_id, pcddf_normalize)%>%
            arrange(rgn_id)
```

#### 4.4.2 Plot Pressure layer by BHI regions

``` r
ggplot(pcb153_rgn)+
  geom_point(aes(rgn_id,pcb153_normalize), size= 2.5)+
  ylab("Pressure Value")+
  ylim(0,1)+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("PCB 153 pressure value by BHI regions")
```

![](atmos_con_prep_files/figure-markdown_github/Plot%20Pressure%20layer%20by%20BHI%20regions-1.png)

``` r
ggplot(pcddf_rgn)+
  geom_point(aes(rgn_id, pcddf_normalize), size= 2.5) +
 ylab("Pressure Value")+
  ylim(0,1)+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("PCDD/F Pressure value by BHI regions")
```

![](atmos_con_prep_files/figure-markdown_github/Plot%20Pressure%20layer%20by%20BHI%20regions-2.png)

### 4.5 Prepare and save object for layers

#### 4.5.1 Prepare objects

``` r
po_atmos_pcb153 = pcb153_rgn %>%
                  dplyr::rename(pressure_score = pcb153_normalize)


po_atmos_pcddf = pcddf_rgn %>%
                  dplyr::rename(pressure_score = pcddf_normalize)
```

#### 4.5.2 Save objects to layers

``` r
write.csv(po_atmos_pcb153,file.path(dir_layers,"po_atmos_pcb153_bhi2015.csv"), row.names = FALSE)

write.csv(po_atmos_pcddf,file.path(dir_layers,"po_atmos_pcddf_bhi2015.csv"), row.names = FALSE)
```
