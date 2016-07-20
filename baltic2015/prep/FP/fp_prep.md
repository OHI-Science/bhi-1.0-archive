fp\_prep.rmd
================

-   [File to set up layers for the overall Food Provisioning (FP) Goal](#file-to-set-up-layers-for-the-overall-food-provisioning-fp-goal)
    -   [1. Layer prep for FIS & MAR weight](#layer-prep-for-fis-mar-weight)
        -   [1.1 Read in data](#read-in-data)
        -   [1.2 Organize data to total tonnes by subgoal per year](#organize-data-to-total-tonnes-by-subgoal-per-year)
        -   [1.3 Join MAR and FIS data](#join-mar-and-fis-data)
        -   [1.4 Spread FP data and Get total tonnes and Fraction from FIS](#spread-fp-data-and-get-total-tonnes-and-fraction-from-fis)
        -   [1.4 Plot totals and proportion FIS](#plot-totals-and-proportion-fis)
        -   [1.5 Take FIS prop mean across years by BHI region](#take-fis-prop-mean-across-years-by-bhi-region)
        -   [1.6 Plot mean FIS prop 2003-2014](#plot-mean-fis-prop-2003-2014)
        -   [1.7 Prepare data layer](#prepare-data-layer)
        -   [1.8 Save layer](#save-layer)

File to set up layers for the overall Food Provisioning (FP) Goal
=================================================================

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



dir_fp   = file.path(dir_prep,'FP')




## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_fp, 'fp_prep.rmd') 
```

1. Layer prep for FIS & MAR weight
----------------------------------

### 1.1 Read in data

#### 1.1.1 MAR data

Read in the tonnes of MAR production per BHI area from the layers file.

``` r
## read in data
mar_data = read.csv(file.path(dir_layers, "mar_harvest_tonnes_bhi2015.csv"))
str(mar_data)
```

    ## 'data.frame':    263 obs. of  4 variables:
    ##  $ rgn_id      : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ species_code: int  23 23 23 23 23 23 23 23 23 23 ...
    ##  $ year        : int  2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 ...
    ##  $ tonnes      : num  74.8 55 65.2 62.5 59.2 ...

#### 1.1.2 FIS data

``` r
fis_data = read.csv(file.path(dir_layers,'fis_landings_bhi2015.csv'),stringsAsFactors = FALSE)
str(fis_data)
```

    ## 'data.frame':    2499 obs. of  4 variables:
    ##  $ rgn_id  : int  3 4 5 6 7 8 9 10 11 12 ...
    ##  $ stock   : chr  "cod_2224" "cod_2224" "cod_2224" "cod_2224" ...
    ##  $ year    : int  1994 1994 1994 1994 1994 1994 1994 1994 1994 1994 ...
    ##  $ landings: num  21409 21409 21409 21409 21409 ...

### 1.2 Organize data to total tonnes by subgoal per year

``` r
mar_data = mar_data %>%
           select(rgn_id,year, tonnes) %>%
           arrange(rgn_id,year) %>%
           mutate(subgoal= 'MAR')


fis_data = fis_data %>%
           select(rgn_id, year, landings)%>%
           group_by(rgn_id,year) %>%
           summarise(tonnes = sum(landings, na.rm=TRUE))%>%
           ungroup()%>%
           arrange(rgn_id,year) %>%
           mutate(subgoal = 'FIS')

str(fis_data)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    840 obs. of  4 variables:
    ##  $ rgn_id : int  3 3 3 3 3 3 3 3 3 3 ...
    ##  $ year   : int  1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 ...
    ##  $ tonnes : num  482848 493674 600595 681594 607661 ...
    ##  $ subgoal: chr  "FIS" "FIS" "FIS" "FIS" ...

### 1.3 Join MAR and FIS data

``` r
fp_data = bind_rows(mar_data,fis_data)

str(fp_data)
```

    ## 'data.frame':    1103 obs. of  4 variables:
    ##  $ rgn_id : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ year   : int  2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 ...
    ##  $ tonnes : num  74.8 55 65.2 62.5 59.2 ...
    ##  $ subgoal: chr  "MAR" "MAR" "MAR" "MAR" ...

``` r
head(fp_data)
```

    ##   rgn_id year tonnes subgoal
    ## 1      1 2005  74.75     MAR
    ## 2      1 2006  55.00     MAR
    ## 3      1 2007  65.25     MAR
    ## 4      1 2008  62.50     MAR
    ## 5      1 2009  59.25     MAR
    ## 6      1 2010  39.00     MAR

``` r
tail(fp_data)
```

    ##      rgn_id year   tonnes subgoal
    ## 1098     42 2009 589566.4     FIS
    ## 1099     42 2010 528982.6     FIS
    ## 1100     42 2011 435153.0     FIS
    ## 1101     42 2012 382865.4     FIS
    ## 1102     42 2013 404128.7     FIS
    ## 1103     42 2014 405608.0     FIS

### 1.4 Spread FP data and Get total tonnes and Fraction from FIS

``` r
fp_data = fp_data %>%
          spread(subgoal, tonnes) %>%
          mutate(FIS = ifelse(is.na(FIS),0,FIS),
                 MAR = ifelse(is.na(MAR),0,MAR))%>%  ## replace NA with zero, no production from that subgoal
          mutate(tot_tonnes = FIS + MAR,
                 fis_prop = FIS / tot_tonnes)
```

### 1.4 Plot totals and proportion FIS

``` r
ggplot(fp_data)+
    geom_point(aes(year,MAR), colour="green",size=1)+
    geom_point(aes(year,FIS), colour="blue", size=1)+
  facet_wrap(~rgn_id)+
  ylab("tonnes")+
  theme(axis.text.x = element_text(colour="grey20", size=6, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"),
        axis.text.y = element_text(size=6))+
  ggtitle("Mariculture Production (green) and Fishery Landings(blue)")
```

![](fp_prep_files/figure-markdown_github/plot%20tonnes%20and%20proportion%20FIS-1.png)

``` r
ggplot(fp_data)+
    geom_point(aes(year,fis_prop), colour="black",size=1)+
    facet_wrap(~rgn_id)+
    ylab("proportion tonnes")+
  theme(axis.text.x = element_text(colour="grey20", size=6, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
    ggtitle("Proportion of Total Fishery Harvest from wild-capture fisheries (FIS)")
```

![](fp_prep_files/figure-markdown_github/plot%20tonnes%20and%20proportion%20FIS-2.png)

### 1.5 Take FIS prop mean across years by BHI region

Only take mean for the most recent 10 years (not MAR data prior and FIS has a very long time series). 2003-2014

``` r
fp_data1 = fp_data %>%
           select(rgn_id, year, fis_prop) %>%
           filter(year>2002 & year < 2015) %>%
           group_by(rgn_id) %>%
           summarise(mean_fis_prop = mean(fis_prop))%>%
           ungroup()
```

### 1.6 Plot mean FIS prop 2003-2014

``` r
ggplot(fp_data1)+
    geom_point(aes(rgn_id,mean_fis_prop), colour="black",size=2.5)+
    ylab("proportion tonnes")+
  theme(axis.text.x = element_text(colour="grey20", size=6, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
    ggtitle("Mean Proportion of Total Fishery Harvest from wild-capture fisheries (FIS) 2003-2014")
```

![](fp_prep_files/figure-markdown_github/Plot%20mean%20FIS%20prop%202003-2014-1.png)

### 1.7 Prepare data layer

``` r
fp_wildcaught_weight = fp_data1 %>%
                       select(rgn_id, mean_fis_prop)%>%
                       dplyr:: rename(w_fis = mean_fis_prop)%>%
                       arrange(rgn_id)
```

### 1.8 Save layer

``` r
write.csv(fp_wildcaught_weight, file.path(dir_layers, 'fp_wildcaught_weight_bhi2015.csv'), row.names = FALSE)
```
