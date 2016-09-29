# Interpreting Baltic Health Index goals and reference points

The **Ocean Health Index (OHI)** is a systematic approach for measuring overall condition of marine ecosystems that treats nature and people as integrated parts of a healthy system. Assessments using the OHI framework aim to transparently balance multiple competing and potentially conflicting public goals and connect human development with the ocean’s capacity to sustain progress. OHI assessments typically have ten goals (some with subgoals) that are important benefits delivered to humans, and each goal is modeled and scored on a scale from 0-100. While each goal individually is important, the OHI helps demonstrate how and where it fits into a broader context; this can help transform the dialogue on how we manage our interactions with the ocean to a more holistic approach.

The **Baltic Health Index (BHI)** assesses 9 goals: Food Provision (subgoals: Fisheries, Mariculture), Artisanal Fishing Opportunity, Natural Products, Carbon Storage, Tourism & Recreation, Coastal Livelihoods & Economies (subgoals: Livelihoods, Economies), Sense of Place (subgoals: Iconic Species, Lasting Special Places), Clean Waters (subgoals: Nutrients, Trash, Contaminants), and Biodiversity. 

**Reference points**, or targets, are required for each goal so that the data modeled to represent these diverse goals can be combined and compared. Reference points are informed by science when possible, but are ultimately a decision to be made. BHI reference points are set with existing targets and science when possible. When not possible, they are set with expert judgment using SMART principles^1^ (Specific to the management goal, Measurable, Ambitious, Realistic, and Time-bound). This is the first BHI assessment using these goals and reference points; it should be considered a starting point from which to improve in future years with additional knowledge and data availability. 


### Food Provision

Goal scores are calculated as a weighted average of the Fisheries and Mariculture goals based on their proporational contribution to tonnes of food production. 

#### Fisheries

Goal model uses commercial catch of cod and herring, as there are available data for these stocks, and they are harvested for human consumption. Landing catch and stock status (B/B~msy~ and F/F~msy~) are reported at the ICES spatial scale and translated to BHI regions. 

The reference point is the maximum sustainable yield for each stock, after penalty is applied if B/B~msy~ scores indicate underfishing, since this goal aims to maximize food available to humans as long as it is fished sustainably.

#### Mariculture  

Mariculture (farming fish and shellfish in the ocean) is not a huge industry in the Baltic, but it does provide some food production. The goal model is based on tonnes of production. Data were available for parts of Denmark, Sweden, Germany, and Finland. All other BHI regions are scored as NA, and thus MAR will not contribute to the overall FP goal score. 

The reference point is in progress: it will be set based on expert judgment and potentially MSC reports. Currently, as a placeholder, it is set as the highest value a 5-year window for each species.

**BHI 2.0 considerations**: obtain more complete data for mariculture production in the Baltic. Also, for regions without production (that receive an NA), a counter argument could be made that some of these regions have the capacity for production, therefore they should receive a score of zero when having no production.

([data preparation](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/MAR/mar_prep.md))

### Artisanal Fishing Opportunity

Goal model will be based on the stock status of species targeted at non-commercial scales using two HELCOM core indicators assessed for good environmental status (each scored between 0 and 1 by BHI).  

The reference point is set as the maximum possible good environmental status (GES); i.e. where GES = 1.

([data preparation](https://github.com/OHI-Science/bhi/blob/draft/baltic2015/prep/AO/ao_prep.md))

### Natural Products

Goal model uses commercial catch of sprat, as there are available data for these stocks, and they are harvested for mariculture, not human consumption. Landing catch and stock status (B/B~msy~ and F/F~msy~) are reported at the ICES spatial scale and translated to BHI regions. 

The reference point is the maximum sustainable yield for each stock, after penalty is applied if B/B~msy~ scores indicate underfishing, since this goal aims to maximize food available to humans as long as it is fished sustainably.

### Carbon Storage

In the Baltic area, carbon is stored in coastal seagrasses as well as sediments. However, data are not available at spatial and temporal scales to fully model this goal, therefore scores from the OHI Global assessment will be used as a placeholder. 

**BHI 2.0 considerations:** develop a BHI-specific goal model.

### Tourism & Recreation

Goal model uses nights spent at tourist accommodation establishments per capita; this is an indirect way to to represent how much people value and enjoy the coastal regions by assuming tourists enjoying the coast stay in hotels. These data are available for most BHI regions. 

The reference point is in progress: it will be set based on the EU's Blue Economy document. Currently, as a placeholder, it is set as the highest value a 5-year window; this low reference point resulted in high status scores across all countries. 

To set a more ambitious goal, we will use the 110% of the highest "coastal_stays_per_cap" within the past five years (ie. max(coastal_stays_per_cap)*110%) as the reference point.

**BHI 2.0 considerations:** Coastal tourism activies vary across the Baltic, as do data available to represent these activites. See if it is possible to combine these different data sets in a way similar to the way habitats are combined in Global assessments (i.e. there is a list of habitat types and each region score is calculated using only those types within the region)

### Coastal Livelihoods & Economies

#### Livelihoods

Goal model uses coastal employment rates (from NUTS2 level data within 25km to the coastline) to represent the quality and quantity of satisfaction in jobs. 

The reference point is set as a 5-year moving window; an increasing trend will result in a high score.

**BHI 2.0 considerations:** employment rates for only Baltic-related sectors would be preferred; see if possible to acquire better data for Russia.

#### Economies

Goal model uses coastal GDP per capita (from NUTS2 level data within 25km to the coastline) to represent the quality and quantity of satisfaction in jobs. 

The reference point is set as a 5-year moving window; an increasing trend will result in a high score.

**BHI 2.0 considerations:** employment rates for only Baltic-related sectors would be preferred; see if possible to acquire better data for Russia.

### Sense of Place

#### Iconic Species

#### Lasting Special Places

Goal model uses HELCOM's Marine Protected Area (MPA) Map Service for MPA boundaries and MPA management status. This model assumes that special places are represented by MPAs, and management status (designated, 
designated and partly managed, or designated and managed) for each MPA is assigned a numeric score.

The reference point is that 10% of the area in a country's EEZ is designated as an MPA and is 100% managed.

### Clean Waters
#### Nutrients
#### Trash
#### Contaminants
### Biodiversity




^1^ Samhouri

Samhouri, J. F., S. E. Lester, E. R. Selig, B. S. Halpern, M. J. Fogarty, C. Longo, and K. L. McLeod. 2012. Sea sick? Setting targets to assess ocean health and ecosystem services. Ecosphere 3(5):41. http://dx.doi.org/10.1890/ES11-00366.1
