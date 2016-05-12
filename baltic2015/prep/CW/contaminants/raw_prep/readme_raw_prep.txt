## README RAW PREP


## The files in this folder contained the original downloaded herring data a series of csv file documenting stages in data harmonization, and the final cleaned data.


##-------------------##
## ICES PCB ##
##-------------------##

## ICES data redownloaded by Jennifer on 22 April 2016. In excel downloaded data were cleaned to removed symbols and other formatting that would cause problem in R. No data manipulation was done

#File names and descriptions

###ICES_herring_pcb_dowload_22april2016_cleaned  = original download, previously fixed in excel to remove non-English letters, etc.

##ices_lookup_unique_measurements  = lookup table that contains all the ID information (country, station etc) and specific details by unique measurement (eg. QFLAG)

##ices_congener_unit_conversion = a transition file showing the conversion of data into the same units (ug/kg), data are still in original basis form (wet or lipid weight). Only has congener variables (not length, weight etc)

##ices_congener_biodata_weight_basis_unconverted = this is the congener variables joined to the biological variables (length, weight), still in original basis form (wet or lipid weight).

##ices_herring_pcb_cleaned.csv  == this has all data converted to a wet weight basis.  Data are rejoined to the lookup information so that the Qflags are associated with the congener measurements



##-------------------##
## ICES Dioxin ##
##-------------------##

## ICES dioxin data redownloaded by Jennifer on 11 May 2016. In excel downloaded data were cleaned to removed symbols and other formatting that would cause problem in R. No data manipulation was done

#File names and descriptions

###ICES_herring_dioxin_dowload_11may2016_cleaned  = original download, previously fixed in excel to remove non-English letters, etc.




##-------------------##
## IVL PCB##
##-------------------##


## IVL data were redownloaded by Jennifer on 21 April 2016.  In excel, downloaded data were cleaned to removed symbols and other formatting that would cause problem in R. No data manipulation was done  -- These data are currently not used, ICES data are updated so do not need IVL data


## IVL_herring_pcb_download_21april2016_cleaned == original IVL file
