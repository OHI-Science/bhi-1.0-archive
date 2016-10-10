# Fisheries

#### Relevant files:
* B/Bmsy and F/Fmsy scores are found [here](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/FIS/data/FIS_scores.csv)
* Landings are found [here](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/FIS/data/FIS_landings.csv)
* Catch and stock status are reported at the ICES spatial scale.  These were translated into the Baltic regions using: raw/ICES_2_BHI.csv
* [Status scores](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/FIS/data/FIS_status.csv) for each region  
* [Trend scores](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/FIS/data/FIS_trend.csv)
* [R script](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/FIS/FIS.R) converts the B/Bmsy_F/Fmsy + Landings to Status/Trend data.  Ultimately the content of this script will need to be migrated to function.R (FIS function).
* original data files are in the "raw" folder (also includes a script I used to prepare some of the data)
* I'm not sure what the files in the "archive" folder are.  They were there when I started and I moved them in there in case they are important.  Otherwise they should be deleted.

#### B/Bmsy and F/msy to score
B/Bmsy and F/Fmsy data are converted to scores between 0 and 1 using this [general relationship](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/FIS/ffms%3By_bbmsy_2_score.png).

These parameters can be changed in this [part](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/FIS/FIS.R#L11-L27) of the code

Here is some more information about these scores:

Equation    |   Over/under fished    |  Fishing related mortality    |  resulting F' score
------------ | ---------------------------- | ------------------| --------------------
a       | overfished (B/Bmsy < 0.8)  | high                |  all 0s (lowest possible score)
b       |                                            | low                  | penalty applied
c       |                                            | med/high         | penalty applied
d       |                                            | med/low          | all 1s (best possible score)
e       | not overfished (B/Bmsy > 0.8) | low             | penalty applied
f        |                                            | medium          | all 1s (best possible score)
g       |                                            | high                | penalty applied

Here are the specific equations:
![image](https://cloud.githubusercontent.com/assets/5685517/11152185/5291d988-89ee-11e5-839a-0b1b162832f3.png)

And a description:
This equation simply converts the F/FMSY value to an F' score that will fall between 0-1 (this function applies a penalty when b/bmsy scores indicate good/underfishing, i.e., >= 0.8, but f/fmsy scores indicate high fisheries related mortality, i.e., > 1.2).  The 2.5 and 1.3 values were chosen to scale the F/FMSY values, so that F' scores would be between 0-1.  I am fairly sure that the 2.5 value was chosen because it was the highest F/FMSY value in the dataset, and (2.5-2.5)/1.3 = 0, establishing the low score of 0.  The 1.3 value was chosen because the lowest possible value for ffmsy (for equation 'g') is 1.2 (ffmsy>=1.2), and (2.5 - 1.2)/1.3 = 1, establishing the high score of 1.





##### Changing the landings data
The landing data can probably be fine-tuned for the Baltic regions based on best expert opinion.  This is the [file](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/FIS/data/FIS_landings.csv) where changes should be made.  Note that each stock/region combination gets the same value across all years (this reflects the mean landings across the most recent 10 years of data).

The above data set was created using these [raw data](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/FIS/raw/BalticLandings.csv) and this [script](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/FIS/raw/DataOrganization.R).

#### ICES vs Baltic regions
Catch and stock status are reported at the ICES spatial scale.  These were translated into the Baltic regions using: raw/ICES_2_BHI.csv.  There are no data for regions 1 and 2 - may want to check on this.

