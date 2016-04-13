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

![](mar_prep_files/figure-markdown_github/plot%20raw%20data-1.png)<!-- -->

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

![](mar_prep_files/figure-markdown_github/plot%20production%20by%20bhi%20region-1.png)<!-- -->

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

MAR Goal Model
--------------

Xmar = Current\_value /ref\_point

-   Data are allocated to BHI region by taking the production from a country production region and dividing it equally among associated BHI regions.
-   In goal calculation, data are taken as 4 year running mean
-   Data unit is tons of production
-   Reference point is temporal, 5 year moving window

Calculate MAR status and trend
------------------------------

Calculate MAR status and trend to get feedback. Code here is copied from functions.r

``` r
##data
  harvest_tonnes = mar_harvest_tonnes
  harvest_species = mar_harvest_species
  sustainability_score = mar_sustainability_score

  # SETTING CONSTANTS
  rm_year = 4     #number of years to use when calculating the running mean smoother
  regr_length =5   # number of years to use for regression for trend.  Use this to replace reading in the csv file "mar_trend_years_gl2014"
  future_year = 5    # the year at which we want the likely future status
  min_regr_length = 4      # min actual number of years with data to use for regression. !! SHORTER THAN regr_length !!  4 is the value in the old code
  status_years = 2010:2014 #this was originally set in goals.csv
  lag_win = 5        # if use a 5 year moving window reference point (instead of spatial, use this lag)

  #####----------------------######
  #harvest_tonnes has years without data but those years not present with NAs
  #spread and gather data again which will result in all years present for all regions
  harvest_tonnes=harvest_tonnes%>%spread(key=year,value=tonnes)%>%
    gather(year, tonnes, -rgn_id,-species_code)%>%
    mutate(year=as.numeric(year))%>%  #make sure year is not a character
    arrange(rgn_id,year)

  # Merge harvest (production) data with sustainability score
  #calculate 4 year running mean
  #this code updated by Lena to use dplyr functions not reshape2
  temp = left_join(harvest_tonnes, harvest_species, by = 'species_code') %>%
    left_join(., sustainability_score, by = c('rgn_id', 'species')) %>%
    arrange(rgn_id, species) %>%
    group_by(rgn_id, species_code) %>%    # doing the 4 year running mean in the same chain
    mutate(rm = zoo::rollapply(data=tonnes, width=rm_year,FUN= mean, na.rm = TRUE, partial=TRUE),    #rm = running mean  #rm_year defined with constants (4 is value from original code)     # better done with zoo::rollmean? how to treat Na with that?
           sust_tonnes = rm * sust_coeff)

  # now calculate total sust_tonnes per year  #only matters if multiple species
  ## remove code that made the data unit per capita

  temp2 = temp %>%    # temp2 is ry in the original version
    group_by(rgn_id, year) %>%
    summarise(sust_tonnes_sum = sum(sust_tonnes)) #this sums the harvest(production) across all species in a given region if multiple spp are present
    ## left_join(., popn_inland25km, by=c('rgn_id')) %>%  #apply 2005 pop data to all years
    ##mutate(mar_prod = sust_tonnes_sum) #tonnes per capita


  ###----------------------------###
  ##Calculate status using temporal reference point
  ## 5 year moving window (temporal ref by region)
  ## Xmar = Mar_current / Mar_ref
  ## if use this, need to decide if the production should be scaled per capita

  ##for complete region ID list
  bhi_rgn = data.frame(rgn_id = as.integer(seq(1,42,1)),year=unique(last(temp2$year)))

  ## Calculate status
  mar_status_score = temp2 %>% group_by(rgn_id)%>%
                mutate(year_ref= lag(year, lag_win, order_by=year),
                       ref_val = lag(sust_tonnes_sum, lag_win, order_by=year))%>% #create ref year and value which is value 5 years preceeding within a BHI region
                arrange(year)%>%
                ungroup()%>%
                filter(year %in% status_years) %>% #select status years
                mutate(status = pmin(1,sust_tonnes_sum/ref_val))%>% #calculate status per year
                select(rgn_id, year, status)%>%
                full_join(.,bhi_rgn,by=c("rgn_id","year"))%>%  #join with complete rgn_id list
                arrange(rgn_id,year)%>%
                mutate(status, status = replace(status, is.na(status), 0))  #give NA value a 0

  #Calculate score
  mar_status = mar_status_score%>%
    group_by(rgn_id) %>%
    summarise_each(funs(last), rgn_id,status) %>% #select last year of status for the score
    mutate(score = round(status*100,2))%>% #status is between 0-100
    ungroup()%>%
    select(rgn_id,score)

  ###----------------------------###
  ## Calulate trend
      ##regr_length = 5; there are 5 data points used to calculate the trend
  mar_trend= mar_status_score%>%group_by(rgn_id)%>%
    do(tail(. , n = regr_length)) %>% #select the years for trend calculate (regr_length # years from the end of the time series)
    #regr_length replaces the need to read in the trend_yrs from the csv file
    do({if(sum(!is.na(.$status)) >= min_regr_length)      #calculate trend only if X years of data (min_regr_length) in the last Y years of time serie (regr_length)
      data.frame(trend_score = max(-1, min(1, coef(lm(status ~ year, .))['year'] * future_year))) #future_year set in contants, this is the value 5 in the old code
      else data.frame(trend_score = NA)}) %>%
    ungroup()%>%
    mutate(trend_score=round(trend_score,2))

  #####----------------------######
  # return MAR scores
  scores = mar_status %>%
    select(region_id = rgn_id,
           score     = score) %>%
    mutate(dimension='status') %>%
    rbind(
      mar_trend %>%
        select(region_id = rgn_id,
               score     = trend_score) %>%
        mutate(dimension = 'trend')) %>%
    mutate(goal='MAR')
  scores
```

    ## Source: local data frame [84 x 4]
    ## 
    ##    region_id  score dimension  goal
    ##        (int)  (dbl)     (chr) (chr)
    ## 1          1  56.12    status   MAR
    ## 2          2  94.73    status   MAR
    ## 3          3 100.00    status   MAR
    ## 4          4   0.00    status   MAR
    ## 5          5  56.12    status   MAR
    ## 6          6   6.99    status   MAR
    ## 7          7 100.00    status   MAR
    ## 8          8   0.00    status   MAR
    ## 9          9 100.00    status   MAR
    ## 10        10   0.00    status   MAR
    ## ..       ...    ...       ...   ...

Plot status and trend as a figure
---------------------------------

**Status** is a value between 0 and 100.
**Trend** is a value between -1 and 1.

``` r
par(mfrow=c(1,2), mar=c(1,2.5,1,1), oma=c(2,2,2,2), mgp=c(1.5,.5,0))
plot(score~rgn_id, data=mar_status,cex=1, pch=19,
     xlim=c(0,43), ylim=c(0,102),
     xlab="", ylab= "Current Status", 
     cex.axis=.7, cex.lab=0.8)

plot(trend_score~rgn_id, data=mar_trend,cex=1,pch=19,
     xlim=c(0,43), ylim=c(-1,1),
     xlab="", ylab= "Trend", 
     cex.axis=.7, cex.lab=0.8)
  abline(h=0)
mtext("BHI Region", side=1, line=.5, outer=TRUE, cex=.8)
mtext("MAR Status and Trend", side=3, line=.5, outer=TRUE, cex=1.2)
```

![](mar_prep_files/figure-markdown_github/plot%20status,%20trend-1.png)<!-- -->

Plot MAR status time series
---------------------------

This is the time series use to calculate the trend.
Each years status is based on a 4 year running mean of production and a reference point five years before.

``` r
# Plot MAR status over time

ggplot(mar_status_score) + 
  geom_point(aes(year,status*100))+
  facet_wrap(~rgn_id)+
  theme(axis.text.x = element_text(colour="grey20",size=8,angle=90,hjust=.5,vjust=.5,face="plain"),
        strip.background = 
          element_rect(colour = "black", fill="white", size = 1))+
  ggtitle("MAR Status 5 Years by BHI region")
```

![](mar_prep_files/figure-markdown_github/plot%20status%20time%20series-1.png)<!-- -->

Plot status as a map
--------------------

    ## Loading required package: sp

    ## rgdal: version: 1.1-3, (SVN revision 594)
    ##  Geospatial Data Abstraction Library extensions to R successfully loaded
    ##  Loaded GDAL runtime: GDAL 2.0.1, released 2015/09/15
    ##  Path to GDAL shared files: C:/R-3.2.3/library/rgdal/gdal
    ##  GDAL does not use iconv for recoding strings.
    ##  Loaded PROJ.4 runtime: Rel. 4.9.1, 04 March 2015, [PJ_VERSION: 491]
    ##  Path to PROJ.4 shared files: C:/R-3.2.3/library/rgdal/proj
    ##  Linking to sp version: 1.2-2

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "C:/Users/jgrif/Documents/StockholmUnivPostDoc/BalticHealthIndex/BHI_r/March2016WkshpPlots/shapefiles", layer: "BHI_regions_plus_buffer_25km"
    ## with 42 features
    ## It has 1 fields

    ## Warning in readOGR("C:/Users/jgrif/Documents/StockholmUnivPostDoc/
    ## BalticHealthIndex/BHI_r/March2016WkshpPlots/shapefiles", : Z-dimension
    ## discarded

    ## [1] "+proj=longlat +init=epsg:4326 +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"

**Note that areas recieve a score of zero where there is no production**

``` r
## Assign colors to BHI ID based on score - these bins are not even, not sure how to do a gradient
## 0 - 24
## 25 - 49
## 50 - 74
## 75 - 100

mar_status_colors = mar_status %>% 
                        mutate(cols = ifelse(is.na(score) == TRUE, "grey",
                                      ifelse(score == 0, "red",
                                      ifelse(score > 0 & score < 25, "orange1",
                                      ifelse(score >= 25 & score < 50, "yellow2",
                                      ifelse(score >= 50 & score < 75, "light blue",
                                      ifelse(score >= 75 & score <=100, "blue", "grey")))))))




BHIshp2@data = BHIshp2@data %>% full_join(.,mar_status_colors, by=c("BHI_ID"= "rgn_id"))
head(BHIshp2@data)
```

    ##   BHI_ID  score       cols
    ## 1      1  56.12 light blue
    ## 2      2  94.73       blue
    ## 3      3 100.00       blue
    ## 4      4   0.00        red
    ## 5      5  56.12 light blue
    ## 6      6   6.99    orange1

``` r
## PLOT

par(mfrow=c(1,2), mar=c(.5,.2,.5,.2), oma=c(0,0,4,0))
  
plot(BHIshp2, col=BHIshp2@data$cols, main = "score 1")
 plot(c(1,2,3),c(1,2,3), type='n', fg="white",bg="white", xaxt='n',yaxt='n')
  legend("center", 
         legend=c("0", "1 - 24", "25 - 49", "50 - 74", "75 -100"), 
         fill=c("red","orange1","yellow2","light blue", "blue"), bty='n', cex=1.5)

    mtext("MAR Current Status", side = 3, outer=TRUE, line=1.5)
```

![](mar_prep_files/figure-markdown_github/Current%20status%20map-1.png)<!-- -->
