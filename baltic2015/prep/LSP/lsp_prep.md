lsp\_prep
================

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    ## Loading required package: DBI

1. Background on MPA data
-------------------------

### 1.1 Why MPAs?

2. MPA data
-----------

### 2.1 Data source

#### 2.1.1 Shapefiles of MPA area

Shapefiles of current MPA areas were downloaded from [HELCOM MPAs Map Service](http://mpas.helcom.fi/apex/f?p=103:17::::::).
 - Need to confirm date downloaded and date these data were last updated.

#### 2.1.2 Management plan status csv

The status of the management plans associated with each MPA were downloaded from HELCOM's \[MPA database\] (<http://mpas.helcom.fi/apex/f?p=103:40>::::::) under the *Management Plans* tab. Data were downloaded on 15 April 2016.
 - Key columns in this csv file are "Site name" (MPA name) and "Management Plan status"

There are three levels of management plan status that can be assigned to each MPA: *No plan*, *In development*, *Implemented*.

A challenge is that each MPA can have multiple management plans associated with it. There is no limit to the number of plans not an ability to assess their relative importance. Different management plans for the same MPA can have different levels of implementation.

\*\*How to use this information*?*

3. LSP goal model overview
--------------------------

### 3.1 Status

Xlsp\_country = sum(w\_i \* MPA area)\_m / Reference\_pt\_country
 - Numerator is the sum over all MPAs within a country's EEZ of the MPA area weighted by the management status.
 - w\_i = value between 0 -1
 - Need to assign weights to levels of management status.
 - **One option**: *No plan* = 0.3, *In development* = .6, *Implemented* = 1.0. **NEED FEEDBACK** - Each country's status is applied to all BHI regions associated with that country.

Reference\_pt\_country = 10% of the area in a country's EEZ is designated as an MPA and is 100% managed = 10% area country's EEZ
 - This is based on the Convention on Biodiversity [target](https://www.cbd.int/sp/targets/rationale/target-11/)

### 3.2 Trend

##### 3.2.1 Alternative 1

MPA dbf contains the date the MPA was established. Therefore, we can calculate the cumulative area over time that are MPAs. We can fit a cum. area ~ year. Calculate cumulative area from ealiest year of MPA established (1976) but for trend use the most recent 10 year period (2004 - 2013)? It appears that countries mostly designate MPAs in chunks.

Only allow a positive slope since countries are not removing mpas? This would be automatic since regressing cumulative area on year (and have no info on areas removed). Also, if country reaches 10% goal, then the rate at which new area is added should go to zero. Then it is okay to have zero slope because the status will not decline in future - the required area has been allocated and status can only improve if all areas are managed. Then score of 100 is achieved.

Cum\_area\_y = sum of all MPA areas established from year 1 to year y

Cum\_area\_y = m\*year\_y + b; m = slope

Trend = Future\_year \* m ; future\_year = 5

How to rescale trend? If all values are between 0-1, do we need to rescale?

#### 3.2.2 Alterative 2

There is limited information on MPA area from previous assessments. Need to read historic overview provided in [Baltic Sea Environment Proceedings NO. 124B Towards an ecologically coherent network of well-managed Marine Protected Areas](http://www.helcom.fi/lists/publications/bsep124b.pdf). Use this for the trend? If area increasing, get positive trend?

4. MPA data prep
----------------

Prep data layer

Read in MPA and BHI regions shapefiles
--------------------------------------

Also, get them in the same coordinate reference system for the Baltic.

The MPA file is in the [LAEA coordinate reference system](http://spatialreference.org/ref/epsg/etrs89-etrs-laea/).

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "/home/shares/ohi/git-annex/Baltic/BHI_MCG_shapefile", layer: "BHI_MCG_11052016"
    ## with 42 features
    ## It has 6 fields

![](lsp_prep_files/figure-markdown_github/read%20in%20shapefiles-1.png)

    ## OGR data source with driver: ESRI Shapefile 
    ## Source: "/home/shares/ohi/git-annex/Baltic/bhi_MPA", layer: "HELCOM_MPAs"
    ## with 163 features
    ## It has 14 fields

![](lsp_prep_files/figure-markdown_github/read%20in%20shapefiles-2.png)

Intersect BHI and HELCOM\_MPA polygons
--------------------------------------

MPA regions were divided by with BHI region shape file, and thus we were able to calculate the total MPA area within each BHI region. MPA area per region is saved in the prep folder (\`mpa\_area\_per\_rgn.csv).

The csv. file includes information: Area per MPA, Date established, MPA status, total MPA area per region.

![](lsp_prep_files/figure-markdown_github/intersect%20BHI%20adn%20MPA-1.png)

    ## Warning in RGEOSUnaryPredFunc(spgeom, byid, "rgeos_isvalid"): Ring Self-
    ## intersection at or near point 4785962.2438000003 4180281.4374000002

    ##     user   system  elapsed 
    ## 2215.780    0.972 2217.037

![](lsp_prep_files/figure-markdown_github/intersect%20BHI%20adn%20MPA-2.png)

I did not read the read in MPA management plan status file from "~/github/bhi/baltic2015/prep/LSP/mpa\_data\_database/MPA\_management\_plans\_20160415.csv"
