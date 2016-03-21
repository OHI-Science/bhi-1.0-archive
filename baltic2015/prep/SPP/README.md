####  SPP data

For groups on the HELCOM grid (birds and benthos and ???): there is a key (helcom_to_rgn.csv) that translates the grid cells into
baltic regions. The key was created using this script: prep/spatial/HELCOM_2_baltic.R.

The script to calculate vulnerability is: spp.R

Data downloaded from here: http://maps.helcom.fi/website/Biodiversity/index.html

##### Benthic data

Weird thing: you can download a map for each species, but all the species are included in each file.  The
only difference is that there is a unique html downloaded from IUCN for the species in question.

These data are in the format of polygons that are functionally rasters.

The corresponding benthic dbf file is saved as csv: benthos_spatial_data.csv 

Painstakingly made a file to match the names in .shp file with the species names and vulnerability: benthic_species.csv

##### Bird data 
Weird thing: there is no combined file for birds.  Consequently, the dbf files were individually opened and saved in a single csv file:

These data are in the format of polygons that are functionally rasters.

##### Mammal data
There is a combined file for mammals.  These data are in polygons.  Will have to have a different approach to compiling these data.

##### Fish data
There is a combined file for fish.  These data are in polygons.  Will have to have a different approach to compiling these data. 
