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


## Goal Model

Xmar =  

-Data are allocated to BHI region by taking the production from a country production region and dividing it equally among associated BHI regions.  
-OHI code has a spatial reference point and data are standardized by population density - considering removing for BHI


