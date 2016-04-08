contaminants\_prep
================

``` r
## source common libraries, directories, functions, etc
source('~/github/bhi/baltic2015/prep/common.r')
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    ## Warning: package 'ggplot2' was built under R version 3.2.4

    ## Loading required package: DBI

``` r
dir_cw    = file.path(dir_prep, 'CW')
dir_con    = file.path(dir_prep, 'CW/contaminants')

## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_con, 'contaminants_prep.rmd')
```

Contaminant Data Prep
=====================

Indicators
----------

3 indicators are proposed which would then be combined to give an overall comtanimant sub-component status.

(1) 6 PCB concentration indicator
---------------------------------

**ICES-6** Sum of PCB28, PCB52, PCB101, PCB138, PCB153 and PCB180.

This is similar to the ICES-7 except that PCB 118 is excluded (since it is metabolized by mammals).

75 ng/g wet weight is the [EU threshold for fish muscle. See Section 5 Annex, 5.3](http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=OJ:L:2011:320:0018:0023:EN:PDF)

**Additional information from HELCOM on the Core Indicators**
[HELCOM Core Indicator of Hazardous Substances Polychlorinated biphenyls (PCB) and dioxins and furans 2013](http://www.helcom.fi/Core%20Indicators/HELCOM-CoreIndicator_Polychlorinated_biphenyls_and_dioxins_and_furans.pdf)

*Relevant text from the HELCOM core indicator report*
"The PCBs included in this core indicator report are the 7 PCB congeners that have been monitored since the beginning of the HELCOM and OSPARCOM monitoring programmes, carefully selected mainly by ICES working groups due to their relatively uncomplicated identification and quantification in gas chromatograms and as they usually contribute a very high proportion of the total PCB content in environmental samples. These are the ‘ICES 7’: CB-28, CB-52, CB-101, CB-118, CB-138, CB-153 and CB-180."

*Determination of GES boundary* The CORESET expert group decided that, due to uncertainties in the target setting on the OSPAR and EU working groups, the seven PCBs should be monitored and concentrations analysed but the core indicator assesses primarily two congeners only: CB-118 (dioxin like) and 153 (non-dioxin like). Tentatively the OSPAR EACs for these two congeners are suggested to be used.

(2) TEQ value for PCBs and Dioxins
----------------------------------

[HELCOM Core Indicator of Hazardous Substances Polychlorinated biphenyls (PCB) and dioxins and furans](http://www.helcom.fi/Core%20Indicators/HELCOM-CoreIndicator_Polychlorinated_biphenyls_and_dioxins_and_furans.pdf)

Dioxins are included in several international agreements, of which the Stockholm Convention and the Convention on Long Range Transboundary Air are among the most important for the control and reduction of sources to the environment. WHO and FAO have jointly established a maximum tolerable human intake level of dioxins via food, and within the EU there are limit values for dioxins in food and feed stuff (EC 2006). Several other EU legislations regulate dioxins, e.g. the plan for integrated pollution prevention and control (IPPC) and directives on waste incineration (EC, 2000, 2008). The EU has also adopted a Community Strategy for dioxins, furans and PCBs (EC 2001).

**Determination of GES boundary** For dioxins, it was decided to use the GES boundary of 4.0 ng kg-1 ww WHO-TEQ for dioxins and 8.0 ng kg-1 ww WHO-TEQ for dioxins and dl-PCBs.

(3) PFOS indicator
------------------

[HElCOM PFOS core indicator document](http://www.helcom.fi/Core%20Indicators/PFOS_HELCOM%20core%20indicator%202016_web%20version.pdf)

Additional references
---------------------

[Faxneld et al. 2014](http://www.diva-portal.org/smash/record.jsf?pid=diva2%3A728508&dswid=1554) Biological effects and environmental contaminants in herring and Baltic Sea top predators

Data
====

Data sources
------------

ICES
[ICES database](http://dome.ices.dk/views/ContaminantsBiota.aspx)
Downloaded 20 October 2015 by Cornelia Ludwig

IVL (Svenska Miljönstitutet / Swedish Environmental Research Institute)
[IVL database](http://dvsb.ivl.se/)
Downloaded 2 December 2015 by Cornelia Ludwig
[IVL detection limit information](http://www.ivl.se/sidor/lab--analys/miljo/biota.html)

Data prep prior to database
---------------------------

Data were cleaned and harmonized by Cornelia Ludwig prior to being put into the BHI database.
**PCBs**
(1) Swedish data were given in lipid weight and were converted to wet weight. Not all samples had a Extrlip (fat) percentage and therefore could not be converted. These samples were not included in the database
(2) Data were in different units and were standardized to mg/kg (however the values listed for the detection limit and the quantification limit were not updated to reflect the value unit change)

Other Info
==========

........

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
pcb_data = readr::read_csv(file.path(dir_con, 'contaminants_data_database/pcb_data.csv'),
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

![](contaminants_prep_files/figure-markdown_github/congener%20count-1.png)

``` r
  #ggsave(file="baltic2015/prep/CW/contaminants/pcb7prepplot_congener_count.png")
##
ggplot(congener_count%>% left_join(.,id_lookup), by="new_id")+geom_point(aes(new_id,congener_count))+
  facet_wrap(~country)+
  xlab("Unique Sample ID")+
  ylab("Number Congeners Measured")
```

    ## Joining by: "new_id"

![](contaminants_prep_files/figure-markdown_github/congener%20count-2.png)

``` r
  #ggsave(file="baltic2015/prep/CW/contaminants/pcb7prepplot_congener_count_country.png")

ggplot(congener_count%>%left_join(.,id_lookup, by="new_id")%>%left_join(.,select(data4,new_id,date),by="new_id"))+geom_point(aes(date,congener_count))+
  facet_wrap(~country)+
  xlab("Unique Sample ID")+
  ylab("Number Congeners Measured")
```

    ## Warning: Removed 12 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/congener%20count-3.png)

``` r
  #ggsave(file="baltic2015/prep/CW/contaminants/pcb7prepplot_congener_count_country_bydate.png")


ggplot(congener_freq_date)+geom_point(aes(date,congener_freq))+
  facet_wrap(~variable)+
  xlab("Date")+
  ylab("Numer Samples with Congener measured")
```

    ## Warning: Removed 6 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/congener%20count-4.png)

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

![](contaminants_prep_files/figure-markdown_github/overview%20plots-1.png)

``` r
##join data4 with country data and explore conger measurements by country
data5 = data4 %>% full_join(.,id_lookup, by="new_id")

## at ID, By Country
ggplot(data5) + geom_point(aes(new_id, value, colour=variable))+
  facet_wrap(~country)
```

    ## Warning: Removed 1138 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/overview%20plots-2.png)

``` r
## At Date, By Country
ggplot(data5) + geom_point(aes(date, value, colour=variable))+
  facet_wrap(~country)+
  scale_x_date(name= "Month-Year",date_breaks="1 year", date_labels = "%m-%y")
```

    ## Warning: Removed 1146 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/overview%20plots-3.png)

``` r
## At Date, By BHI ID
ggplot(data5) + geom_point(aes(date, value, colour = country))+
  facet_wrap(~bhi_id)+
  scale_x_date(date_breaks="1 year", date_labels = "%m-%y")
```

    ## Warning: Removed 1146 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/overview%20plots-4.png)

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

![](contaminants_prep_files/figure-markdown_github/overview%20plots-5.png)

``` r
## at ID, By variable & country
ggplot(data5) + geom_point(aes(new_id, value))+
  facet_wrap(~variable+country)
```

    ## Warning: Removed 1138 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/overview%20plots-6.png)

``` r
    ## German values very high for a few congeners (CB138, CB153)
    ## need to check closer to see if multiple measurement for the same sample ID


ggplot(filter(data5, country=="Germany" & new_id < 200)) + geom_point(aes(new_id, value))+
  facet_wrap(~variable)
```

    ## Warning: Removed 93 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/overview%20plots-7.png)

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

![](contaminants_prep_files/figure-markdown_github/sample%20comp-1.png)

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

![](contaminants_prep_files/figure-markdown_github/plot%206%20congener%20data%20coverage-1.png)

``` r
ggplot(data8) + geom_point(aes(date,value, colour=variable))+
facet_wrap(~bhi_id, scales="free_y")
```

![](contaminants_prep_files/figure-markdown_github/plot%206%20congener%20data%20coverage-2.png)

``` r
ggplot(data8) + geom_point(aes(date,value, colour=variable,shape=factor(qflag)))+
facet_wrap(~bhi_id, scales="free_y")
```

    ## Warning: Removed 2787 rows containing missing values (geom_point).

![](contaminants_prep_files/figure-markdown_github/plot%206%20congener%20data%20coverage-3.png)

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

![](contaminants_prep_files/figure-markdown_github/no%20qflag%20and%20all%20congener%20plot-1.png)

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

![](contaminants_prep_files/figure-markdown_github/plot%20samples%20and%20threshold-1.png) \#\#\# Mean total concentration value by station and date

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

![](contaminants_prep_files/figure-markdown_github/mean%20value%20loc%20and%20date-1.png)

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

![](contaminants_prep_files/figure-markdown_github/plot%20total%20conc%20including%20qflagged%20samples-1.png)

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

![](contaminants_prep_files/figure-markdown_github/average%20station%20date%20with%20qflagged%20data-1.png)

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
    ##  $ pcb6_sd_sample_ng_g  : num  0.843 0.998 NA 1.508 5.428 ...
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

![](contaminants_prep_files/figure-markdown_github/samples%20on%20map-1.png)

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
