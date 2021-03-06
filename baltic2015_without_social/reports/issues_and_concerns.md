Ongoing Issues and Concerns
================

Here is a list of ongoing issues regarding data, coding, things to think about:

1.  Goals without status layers

-   CS
    -   TB: TB will try to fix this with sediment data

    -   Julie's TODO: look through what Global has done Ning: wait until Thorsten talks to carbon sediment guys and author (Leite) about how to set ref point. Put Global as placeholder

1.  Goals/subgoals without trend layers – decide if keep NA or need to have proxy

-   BD -&gt; use global
-   ICO -&gt; use global
-   TRA -&gt; need to calculate from [prep file](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/CW/trash/tra_prep.md#modeled-mismanaged-plastic-waste-2025); and relook at the reference point to see if it's too high--there is trash in the baltic, these scores are too high...Look at ohi-global approach. TB: will look to see if there is a way to use the EU framework directive ref point
-   CS – because no status method, but NUT trend suggested to be used if data for status are available

-   TB: What about ECO, LIV and TR goals – very high – unrealistic scores?

    -   TB will ask Martin, Wilfried re ECO, LIV reference point to think about how to change. Ning can reassign TR ref point. Problem politically if EU sees that OHI scores are already perfect.

-   JSL/NJ: directly borrow from OHI-Global's trend scores

1.  Goals where gapfilling versus NA use is an ongoing discussion

-   **AO**: Values calculated at the basin level (means that the major of regions would get scores) but then Jens Olsson suggested any BHI region without any monitoring samples should not receive the basin score – this substantially increases BHI regions with NA for score

-   **CON** (and 1 area for NUT): -&gt; there aren't enough measurements for contaminants. Maybe here could use a penalty HELCOM is doing chemical assessments for HOLAS basins--ususally more negative because using all info available. Didn't use it originally because accumulating 100s of contaminants, published. Partly criticized because lumping other CON together.

-&gt; Thorsten asks about gapfilling: NA? Penalty? HELCOM HOLAS assessments.

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
-   AO -&gt; JSL/NJ: give scores of NA

1.  Resilience layers and Russia

-   Because most of the goal-specific regulation considered is for the EU, Russia is left out of having these resilience layers- can this be overcome with information on Russian equivalents? Even if only at the existence level? Maybe just use WGI for Russia.

1.  Shapefiles

-   BHI 21 (associated with Poland) is not assigned NUTS2 or NUTS3 data – unclear why. This means that is NA for LIV, ECO, TR. If this is fixed, need to think carefully about re-running the prep files for LIV, ECO, and TR because many shapefile assignment errors are fixed manually in the code and need to make sure these still work properly.
-   See BHI Issue \#[91](https://github.com/tblen/BHI-issues/issues/91)

1.  Reviewing data layers

-   While the plots in the PDFs in the folder ‘Output\_pdfs’ are useful – all goals and pressures/resilience layers should be thoroughly reviewed both by BHI/OHI team and the outside experts. Reviewing the prep files on github is the best way to do so.

1.  Which atmospheric contaminants pressure layer?

-   We had discussed using PCB 153 and not PCDD/F but I think we should check with Anna Sobek first.
-   Currently both layers are implemented, after talking with Anna, the pressure\_matrix.csv file in the github ‘conf’ folder will need to be updated.
