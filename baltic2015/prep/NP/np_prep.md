Natural Products (NP) Goal & Food Provision (FP) - Fisheries (FIS) subgoal Data Prep
================

-   [1. Background](#background)
    -   [Goal Description](#goal-description)
    -   [Model & Data Overview](#model-data-overview)
    -   [Reference points](#reference-points)
    -   [Considerations for *BHI 2.0*](#considerations-for-bhi-2.0)
    -   [Other information](#other-information)
-   [2. Data and processing](#data-and-processing)

1. Background
-------------

### Goal Description

This goal measures how sustainably people harvest non-food products from the sea. From seashells and sponges to aquarium fish, natural products contribute to local economies and international trade. **For the BHI sprat was included as a natural product** because it often used for fish meal production or animal food.

### Model & Data Overview

The data used for this goal are composed of total sprat spawning biomass (SSB) and fishing mortality (F) data. The current status is calculated as a function of the ratio (B’) between the single species current biomass at sea (B) and the reference biomass at maximum sustainable yield (BMSY), as well as the ratio (F’) between the single species current fishing mortality (F) and the fishing mortality at maximum sustainable yield (FMSY). B/Bmsy and F/Fmsy data are converted to scores between 0 and 1 using this [general relationship](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/FIS/ffms%3By_bbmsy_2_score.png).

-   [Sprat data accessed from the ICES homepage](http://www.ices.dk/marine-data/tools/Pages/stock-assessment-graphs.aspx) &gt; search for 'sprat' &gt; specify the ecoregion as Baltic Sea &gt; search for the 2013 assessment.

### Reference points

The reference point used for the computation are based on the MSY principle and are described as a functional relationship. MSY means the highest theoretical equilibrium yield that can be continuously taken on average from a stock under existing average environmental conditions without significantly affecting the reproduction process *(European Union 2013, World Ocean Review 2013).*

### Considerations for *BHI 2.0*

### Other information

*External advisors/goalkeepers are Christian Möllmann & Stefan Neuenfeldt*

2. Data and processing
----------------------

The **Natural Products** goal describes the ability to maximize the sustainable yield of *non-food* natural products, while the **Fisheries** subgoal of Food Provision focuses on *wild-caught seafood for human consumption*.

The same model was used for both Fisheries and Natural Products, which compares landings with Maximum Sustainable Yield. A score of 100 means the country or region is harvesting seafood to the ecosystem’s production potential in an sustainable manner.

This document prepares data for both Natural Products (NP) and Fisheries (FIS). For Baltic regions, commercially fished stocks are used in these two goals, but different stocks were considered for each goal:

-   FIS stocks: Cod & Herring, mainly for human consumption
-   cod\_2224, cod\_2532, her\_3a22, her\_2532, her\_riga, her\_30
-   NP stocks: Sprat, not for human consumption
-   spr\_2232

Please see the [**fisheries preparation file**](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/FIS/fis_np_prep.md) for full details.
