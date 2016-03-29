# Prep mariculture production data for MAR goal

`mar_prep.rmd` prepares data; will require access to BHI database when data are uploaded there.  

Connecting to the database causes problems kniting the .rmd file, will have to adapt when data is in the database


## Data

Rainbow trout production

### Data sources
Data from country databases or reports  
Sweden
[Jorbruksverket] (http://www.scb.se/sv_/Hitta-statistik/Statistik-efter-amne/Jord--och-skogsbruk-fiske/Vattenbruk/Vattenbruk/)  

Denmark
[Danish Agrifish Agency (Ministry of Environment and Food of Denmark)]( http://agrifish.dk/fisheries/fishery-statistics/aquaculture-statistics/#c32851)  

Finland
[Natural Resources Institute](http://statdb.luke.fi/PXWeb/pxweb/fi/LUKE/LUKE__06%20Kala%20ja%20riista__02%20Rakenne%20ja%20tuotanto__10%20Vesiviljely/?tablelist=true&rxid=5211d344-451e-490d-8651-adb38df626e1)  

- Data were available as total marine production by region.  Data were also available as total production per fish species.  Rainbow trout dominated the total fish production.  Ginnette converted the total production by region to rainbow trout production by region by using the country wide percent rainbow trout of the marine production in each year.  (The other minor contributions to total production were European whitefish, Trout, other species, Roe of rainbow trout, roe of european whitefish).  

Sustainability Coefficient 
The SMI is the average of the three subindices traditionally used in the OHI framework. Trujillo's study included 13 subindices in total but only 3 of them are relevant for assessing the sustainability of mariculture : waster water treatment, usage of fishmeal and hatchery vs wild origin of seeds. Since Rainbow trout SMI is only included for Sweden. The mean value 5.3 was rescaled between 0-1 to 0.53. This value is then applied to Denmark and Finland.


## Goal Model

Xmar =  Current_value /ref_point

- Data are allocated to BHI region by taking the production from a country production region and dividing it equally among associated BHI regions.  
- OHI code has a spatial reference point and data first used to calculate a 4 year running mean and then are standardized by population density - considering removing for BHI?


