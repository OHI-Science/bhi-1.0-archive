### Fisheries

#### Relevant files:
* B/Bmsy and F/Fmsy scores are found [here](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/1.1_FIS/data/FIS_scores.csv)
* Landings are found [here](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/1.1_FIS/data/FIS_landings.csv)
* Catch and stock status are reported at the ICES spatial scale.  These were translated into the Baltic regions using: raw/ICES_2_BHI.csv
* [Status scores](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/1.1_FIS/data/FIS_status.csv) for each region  
* [Trend scores](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/1.1_FIS/data/FIS_trend.csv)
* [R script](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/1.1_FIS/FIS.R) converts the B/Bmsy_F/Fmsy + Landings to Status/Trend data.  Ultimately the content of this script will need to be migrated to function.R (FIS function).
* original data files are in the "raw" folder (also includes a script I used to prepare some of the data)
* I'm not sure what the files in the "archive" folder are.  They were there when I started and I moved them in there in case they are important.  Otherwise they should be deleted.

#### B/Bmsy and F/msy to score
B/Bmsy and F/Fmsy data are converted to scores between 0 and 1 using this [general relationship](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/1.1_FIS/ffms%3By_bbmsy_2_score.png).

These parameters can be changed in this [part](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/1.1_FIS/FIS.R#L11-L27) of the code

##### Changing the landings data
The landing data can probably be fine-tuned for the Baltic regions based on best expert opinion.  This is the [file](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/1.1_FIS/data/FIS_landings.csv) where changes should be made.  Note that each stock/region combination gets the same value across all years (this reflects the mean landings across the most recent 10 years of data).

The above data set was created using these [raw data](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/1.1_FIS/raw/BalticLandings.csv) and this [script](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/1.1_FIS/raw/DataOrganization.R).

#### ICES vs Baltic regions
Catch and stock status are reported at the ICES spatial scale.  These were translated into the Baltic regions using: raw/ICES_2_BHI.csv.  There are no data for regions 1 and 2 - may want to check on this.

