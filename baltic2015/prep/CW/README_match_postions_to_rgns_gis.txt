GIS
Adding data layer with point data
	from R, create txt file with maximum 8 character filename using e.g.
	write.table(pcb, "~/github/BHI-issues/raw_data/pcb_dist.txt", sep = " ", row.names = F)
		Open file in excel and save again as txt
		In ArcMap
			Add data layer
			Display XY data
			x = longitude
			y = latitude
			edit
				select -> Geogr Coord. -> World -> WGS1984 -> Add
			Export data or join to let go of connection to original file.
				Export data from "pcb.txt Events" so an new .shp file is created

To relate each data point to the corresponding region use spatial join

Spatial join
	target <- the data shape file with the points for each station (created as per above)
	join features <- the basin shapefile 
	one-to-one
	keep all ticked
	WITHIN

Then export the data to and open the dbf file in excel, save as a csv and import to R with e.g.
	read.table(file = '~/github/BHI-issues/raw_data/Contaminants/pcb_spatialjoin.csv', header = TRUE, sep = ",")

	