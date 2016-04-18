####  SPP data

For groups on the HELCOM grid (benthos): there is a key (prep/spatial/helcom_to_rgn_bhi_sea.csv) that translates the grid cells into
baltic regions. The key was created using this script: prep/spatial/HELCOM_2_baltic.R.

For groups associated to HELCOM subbasin: this key was used to translate subbasins into baltic regions: prep/baltic_rgns_to_bhi_rgns_lookup_holas.csv

Helcom species data downloaded from here: http://maps.helcom.fi/website/Biodiversity/index.html
I added some subbasins to these data based on emails from Mar 21 email from Marc and Lena 
The data I added is incomplete.

The taxa_combine.R combines the 5 taxonomic groups: benthos, birds, fish, mammals, macrophytes into a single data frame.

To calculate the SPP score, the IUCN codes will be converted to numeric scores and then averaged within each region.

To calculate the ICO score, the species will be subset based on what is considered an iconic species and then the IUCN codes will be 
converted to numeric scores, and than averaged within each region.

##### Benthic data

Weird thing: you can download a map for each species, but all the species are included in each file.  The
only difference is that there is a unique html downloaded from IUCN for the species in question.

These data are in the format of polygons that are functionally rasters.

The corresponding benthic dbf file is saved as csv: benthos_spatial_data.csv 

Painstakingly made a file to match the names in .shp file with the species names and vulnerability: benthic_species.csv

##### Bird data 
There was no combined Helcom spatial file for birds (like there was for the benthic data).  

One complication was that some species had data in the format of the "raster-style" polygons.  While others were actual range polygons.

Given this, each bird spatial file was opened and then the range polygons were overlapped with the bhi regions.  

NOTE: one bird species fell out of the bhi polygon areas and was excluded. I would probably ignore....but it might be worth figuring out.

The spatial files downloaded from Helcom are located here: /var/data/ohi/git-annex/Baltic/spp/Birds

The script used to open each bird file and associate the polygons with BHI regions is: bird_data_extract.R

The extracted bird data is here: intermediate/birds.csv

##### Mammal data
There is a combined file for mammals.  The ranges are described using polygons that relate to subbasins.

Some species have multiple IUCN categories (probably due to subspecies)
It would be ideal if we know which categories correspond to which regions, 
but these data are not available. 
two possible options are:
   1. average them
   2. use the most conservative option
I am going with #2 for now, but this would be easy to change (code in mammal_extract.R).
   
The script used to extract the data was: mammal_extract.R
The extracted mammal data are here: intermediate/mammals.R


##### Fish data
There is a combined file for fish.  The range data are polygons that correspond to subbasins.


##### Macrophyte data
N=17 datapoints fell outside the water.  This could probably be corrected by extracting the CELLCODES that land inland with some buffer.  
Don't know if this is worth the effort...

