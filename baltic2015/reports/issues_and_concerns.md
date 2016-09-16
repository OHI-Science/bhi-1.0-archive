Ongoing Issues and Concerns
================

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