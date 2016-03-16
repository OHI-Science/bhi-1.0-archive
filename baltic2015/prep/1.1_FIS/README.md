### Fisheries

#### Relevant data files:
* B/Bmsy and F/Fmsy scores are found [here](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/1.1_FIS/data/FIS_scores.csv)
* Landings are found [here](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/1.1_FIS/data/FIS_landings.csv)
* [Status scores](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/1.1_FIS/data/FIS_status.csv) for each region  
* [Trend scores](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/1.1_FIS/data/FIS_trend.csv)
* [R script](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/1.1_FIS/FIS.R) used to convert the B/Bmsy_F/Fmsy and Landings data are converted to Status/Trend data
* raw data 

B/Bmsy and F/Fmsy data are converted to scores between 0 and 1 using this [general relationship](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/1.1_FIS/ffms%3By_bbmsy_2_score.png).

These parameters can be changed in this [part](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/1.1_FIS/FIS.R#L11-L27) of the code

