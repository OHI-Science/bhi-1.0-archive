MAR data layer prep
================

Data
----

Rainbow trout production
Date were compiled by Ginnette Flores Carmenate

### Data sources

Data from country databases or reports
Sweden \[Jorbruksverket\] (<http://www.scb.se/sv_/Hitta-statistik/Statistik-efter-amne/Jord--och-skogsbruk-fiske/Vattenbruk/Vattenbruk/>)

Denmark [Danish Agrifish Agency (Ministry of Environment and Food of Denmark)](http://agrifish.dk/fisheries/fishery-statistics/aquaculture-statistics/#c32851)

**On locations from NaturErhvervstyrelsen** The North Sea is very rough, hence there is no sea farms located in the North Sea side of Denmark, and the data on our home page only includes farms placed in the waters you are interested in. There is a map in this [report](http://www.akvakultur.dk/akvakultur%20i%20DK.htm) showing sea farms in Denmark. It’s a bit old (2003), but area wise it haven’t changed much.

Finland [Natural Resources Institute](http://statdb.luke.fi/PXWeb/pxweb/fi/LUKE/LUKE__06%20Kala%20ja%20riista__02%20Rakenne%20ja%20tuotanto__10%20Vesiviljely/?tablelist=true&rxid=5211d344-451e-490d-8651-adb38df626e1)

--Data were available as total marine production by region. Data were also available as total production per fish species. Rainbow trout dominated the total fish production. Ginnette converted the total production by region to rainbow trout production by region by using the country wide percent rainbow trout of the marine production in each year. (The other minor contributions to total production were European whitefish, Trout, other species, Roe of rainbow trout, roe of european whitefish).

Sustainability Coefficient The SMI is the average of the three subindices traditionally used in the OHI framework. Trujillo's study included 13 subindices in total but only 3 of them are relevant for assessing the sustainability of mariculture : waster water treatment, usage of fishmeal and hatchery vs wild origin of seeds. Since Rainbow trout SMI is only included for Sweden. The mean value 5.3 was rescaled between 0-1 to 0.53. This value is then applied to Denmark and Finland.

### Production regions and BHI assignments

BHI regions were assigned to the country production reporting regions by Ginnette visually linking the two

### Data setup and load

Data are stored in the BHI database
`mar_prep_database_call.r` extracts data files from the database and stores data as csv files in folder mar\_data\_database
**Need to make sure csv files are rewritten if database updated!!**

``` r
## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')

## set additional directories
dir_mar    = file.path(dir_prep, 'MAR')

## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_mar, 'mar_prep.rmd')

##-------------------------##
## Read in data

lookup =  readr::read_csv(file.path(dir_mar, 'mar_data_database/mar_data_lookuptable.csv'))
head(lookup)
```

    ## Source: local data frame [6 x 4]
    ## 
    ##         country      mar_region   BHI
    ##   (int)   (chr)           (chr) (int)
    ## 1     1  Sweden Norra ostkusten    41
    ## 2     2  Sweden Norra ostkusten    39
    ## 3     3  Sweden Norra ostkusten    37
    ## 4     4  Sweden Sodra ostkusten    35
    ## 5     5  Sweden Sodra ostkusten    29
    ## 6     6  Sweden Sodra ostkusten    26

``` r
production = readr::read_csv(file.path(dir_mar,'mar_data_database/mar_data_production.csv'))
# head(production)
```

### Plot the data by country's mar\_region

This is the scale of data reported

``` r
ggplot(production)+geom_point(aes(year, production)) +
facet_wrap(~mar_region, scales="free_y")
```

    ## Warning: Removed 15 rows containing missing values (geom_point).

![](mar_prep_files/figure-markdown_github/plot%20raw%20data-1.png)

### Use mar\_lookup to allocate production among BHI regions

Allocate data equally from mar\_region to all associated BHI region.
Do not have any additional information that would allow us to make this allocation based on known production distribution.

``` r
## create a conversion factor for each mar_region
lookup = lookup%>%
         group_by(mar_region)%>%
         mutate(rgn_factor = round((1/n_distinct(BHI)),2))%>%
         ungroup()


## join lookup to production

prod_allot = full_join(lookup, production, by=c("country","mar_region"))%>%
            select(mar_region,BHI, year, production, rgn_factor,common_name,ISSCAAP_FAO,Sust_coeff)%>%
            mutate(prod_allot = production*rgn_factor)%>%  #get production fraction for each BHI region
            select(-mar_region)%>%
            group_by(BHI,year,common_name,ISSCAAP_FAO, Sust_coeff)%>%
            summarise(prod_tot = sum(prod_allot,na.rm=TRUE))%>%  #get production per BHI region - more than one
            ungroup()
```

### Plot production per BHI region

``` r
ggplot(prod_allot)+geom_point(aes(year, prod_tot)) +
  facet_wrap(~BHI, scales="free_y")
```

![](mar_prep_files/figure-markdown_github/plot%20production%20by%20bhi%20region-1.png)

### Create objects to save to put in layers, save a csv

3 layers: mar\_harvest\_tonnes, mar\_harvest\_species,mar\_sustainability\_score

Regions with no data - BHI regions not associated with Sweden, Finland, and Denmark have no data. This is because there is no production. These regions should ultimately get a value of zero for their score to indicate there is no production but that the indicator is applicable.

``` r
## mar_harvest_tonnes
mar_harvest_tonnes= prod_allot %>% select(BHI,ISSCAAP_FAO,year,prod_tot)%>%
                    dplyr::rename(rgn_id=BHI,species_code=ISSCAAP_FAO, year=year,tonnes=prod_tot)
head(mar_harvest_tonnes)
```

    ## Source: local data frame [6 x 4]
    ## 
    ##   rgn_id species_code  year tonnes
    ##    (int)        (int) (int)  (dbl)
    ## 1      1           23  2005  74.75
    ## 2      1           23  2006  55.00
    ## 3      1           23  2007  65.25
    ## 4      1           23  2008  62.50
    ## 5      1           23  2009  59.25
    ## 6      1           23  2010  39.00

``` r
is.na(mar_harvest_tonnes$tonnes)
```

    ##   [1] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ##  [12] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ##  [23] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ##  [34] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ##  [45] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ##  [56] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ##  [67] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ##  [78] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ##  [89] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [100] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [111] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [122] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [133] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [144] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [155] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [166] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [177] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [188] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [199] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
    ## [210] FALSE FALSE FALSE FALSE

``` r
readr::write_csv(mar_harvest_tonnes, 
                 file.path(dir_layers, "mar_harvest_tonnes_bhi2015.csv"))



## mar_harvest_species
mar_harvest_species= prod_allot %>%select(ISSCAAP_FAO,common_name)%>%
                    distinct(ISSCAAP_FAO,common_name)%>%
                    mutate(common_name=as.character(common_name))%>%
                    dplyr::rename(species_code=ISSCAAP_FAO, species=common_name)

readr::write_csv(mar_harvest_species, 
                 file.path(dir_layers, "mar_harvest_species_bhi2015.csv"))



## mar_sustainability_score
mar_sustainability_score = prod_allot %>% select(BHI,common_name,Sust_coeff)%>%
                          mutate(common_name=as.character(common_name))%>%
                          distinct(.)%>%
                          dplyr::rename(rgn_id=BHI,species=common_name, sust_coeff=Sust_coeff)

readr::write_csv(mar_sustainability_score,
                 file.path(dir_layers, "mar_sustainability_score_bhi2015.csv"))
```

### Population density data

MAR code from OHI uses production/per capita
This code creates a csv of the population density data (2005) from 25km inland buffer.
Code in functions.r is where the decision is made whether or not to use it.

``` r
bhi_pop = readr::read_csv(file.path(dir_mar,'mar_data_database/pop_density.csv'))
# head(bhi_pop)

  
## clean up and save layer
bhi_pop =bhi_pop %>%
  dplyr::select(rgn_id = BHI_ID, 
                popsum = `Total Population in 25km Buffer`)
bhi_pop
```

    ## Source: local data frame [42 x 2]
    ## 
    ##    rgn_id  popsum
    ##     (int)   (int)
    ## 1       1  852713
    ## 2       2 1754535
    ## 3       3 1971018
    ## 4       4  191278
    ## 5       5  801791
    ## 6       6 1381111
    ## 7       7   24035
    ## 8       8  654326
    ## 9       9   33074
    ## 10     10 1239349
    ## ..    ...     ...

``` r
## write to layers folder to use in the function
readr::write_csv(bhi_pop, 
                 file.path(dir_layers, "mar_coastalpopn2005_inland25km_bhi2015.csv"))
```

Goal Model
----------

Xmar = Current\_value /ref\_point

-   Data are allocated to BHI region by taking the production from a country production region and dividing it equally among associated BHI regions.
-   In goal calculation, data are taken as 4 year running mean
-   Data unit is tons of production
-   Reference point is temporal, 5 year moving window
