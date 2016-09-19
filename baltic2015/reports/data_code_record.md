Data and Code Record
================

BHI data and code – server, database, github
============================================

-   BHI data are saved on the BHI server under ‘Input Data.’ Each data folder has three sub-folders: source, metadata, data.

-   The source folder is for the data as formatted directly from the data source. These data
-   may be transformed to remove non-English letters but should in most cases be relatively un-modified.

-   The metadata contains information on the data source, date data were downloaded or received, any data selections made during the download process, and variable code information or other useful background information.

-   The data folder contains data that have be cleaned and updated from the source version. This maybe simply renaming columns or changing the file type, other times it is re-organizing an excel file or cleaning and transforming the data in R.

-   BHI database data
-   Data files are stored in the database (with the exception of spatial files).

-   Database Level 0 is the data in its most raw state. These data could come from either the “source” or “data” folders for any given data.

-   Database Level 1 contains data from the “data” folder if these are modified from “source” folder files that are included at Level 0. Level 1 may also included datasets from “source” folders entered at Level 0 then join to a second dataset.

-   Database Metadata contains code or lookup information that may come from either files in the “metadata” folder or the “data” folder.

-   BHI github data

-   Data used in csv file format in github are whenever possible read in from the database. This occurs in a script in each prep folder called “mygoal\_prep\_database\_call.r”. This script requires running your personal access to the database. Then it extracts data from the database and saves in a folder in the same prep folder titled “mygoal\_data\_database”

-   Data are then read into the .rmd prep file from this “mygoal\_data\_database” folder for data layer preparation.

-   This does not occur if data files are not yet included in the database. In most cases, the folder “mygoal\_data\_database” has been created for the goal but files are manually copied in rather than sourced from the database by the script. If this is later updated, users should check columns and column names carefully to see if the .rmd script needs to be modified.

-   This may also not happen for a few goals that were prepped early on and prep scripts are not fully updated (eg. TRA, FIS) – it was simpler to leave their file structure as is.

-   Spatial datafile source locations may need to be updated depending on who is running the script. Scripts set up by NCEAS currently source the NCEAS server, while those set up by Jennifer source her desktop location.

\# Ongoing Issues and Concerns for BHI

Here is a list of ongoing issues regarding data, coding, things to think about:

1.  Goals without status layers

-   CS

1.  Goals/subgoals without trend layers – decide if keep NA or need to have proxy

-   BD
-   ICO
-   TRA
-   CS – because no status method, but NUT trend suggested to be used if data for status are available

1.  Goals where gapfilling versus NA use is an ongoing discussion

-   **AO**: Values calculated at the basin level (means that the major of regions would get scores) but then Jens Olsson suggested any BHI region without any monitoring samples should not receive the basin score – this substantially increases BHI regions with NA for score

-   **CON** (and 1 area for NUT):

-   Spatial coverage for the 3 CON indicators varies.
-   Values are calculated by HOLAS basin so this increases score coverage but still there are many NA areas.
-   If include fish other than herring, could have greater spatial coverage. These data are downloaded but there has been no basic excel clean up, they are not in the database, and they would have to be first cleaned by the basic R script and then prepared for the status in the prep file.
-   For NUT, The Sound has no offshore data and so the status is NA.

-   **MAR** perhaps: If there is no time series production, these regions receive NA.

-   **ECO,LIV,TR**: NA for offshore region with no coast (BHI region 30). Also NA for Russia see below.

1.  Goals where Russia not included:

-   ECO – no regional level data
-   LIV – no regional level data
-   TR – no regional level data
-   AO

1.  Resilience layers and Russia

-   Because most of the goal-specific regulation considered is for the EU, Russia is left out of having these resilience layers- can this be overcome with information on Russian equivalents? Even if only at the existence level?

1.  Shapefiles

-   BHI 21 (associated with Poland) is not assigned NUTS2 or NUTS3 data – unclear why. This means that is NA for LIV, ECO, TR. If this is fixed, need to think carefully about re-running the prep files for LIV, ECO, and TR because many shapefile assignment errors are fixed manually in the code and need to make sure these still work properly.
-   See BHI Issue \#[91](https://github.com/tblen/BHI-issues/issues/91)

1.  Reviewing data layers

-   While the plots in the PDFs in the folder ‘Output\_pdfs’ are useful – all goals and pressures/resilience layers should be thoroughly reviewed both by BHI/OHI team and the outside experts. Reviewing the prep files on github is the best way to do so.

1.  Which atmospheric contaminants pressure layer?

-   We had discussed using PCB 153 and not PCDD/F but I think we should check with Anna Sobek first.
-   Currently both layers are implemented, after talking with Anna, the pressure\_matrix.csv file in the github ‘conf’ folder will need to be updated.
