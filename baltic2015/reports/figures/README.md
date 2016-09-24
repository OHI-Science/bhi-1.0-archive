# README

These figures represent Baltic Health Index (BHI) scores as reported for different regions. 

Scores were calculated for 42 BHI regions and aggregated (using a weighted average) to create an overall score for the Baltic. Additionally, there are 9 EEZ aggregated regions and 17 SUBBASIN aggregated regions. 

Figures are within the [`BHI_regions`](https://github.com/OHI-Science/bhi/tree/draft/baltic2015/reports/figures/BHI_regions), [`EEZ`](https://github.com/OHI-Science/bhi/tree/draft/baltic2015/reports/figures/EEZ) and [`SUBBASIN`](https://github.com/OHI-Science/bhi/tree/draft/baltic2015/reports/figures/SUBBASIN) folders, respectively.

All figures are created by `baltic2015/calculate_scores.r`


| region_id|label                        |type     |
|---------:|:----------------------------|:--------|
|         0|Baltic                       |GLOBAL   |
|         1|Swe - Kattegat               |bhi      |
|         2|Den - Kattegat               |bhi      |
|         3|Den - Great Belt             |bhi      |
|         4|Ger - Great Belt             |bhi      |
|         5|Swe - The Sound              |bhi      |
|         6|Den - The Sound              |bhi      |
|         7|Den - Kiel Bay               |bhi      |
|         8|Ger - Kiel Bay               |bhi      |
|         9|Den - Bay of Mecklenburg     |bhi      |
|        10|Ger - Bay of Mecklenburg     |bhi      |
|        11|Swe - Arkona Basin           |bhi      |
|        12|Den - Arkona Basin           |bhi      |
|        13|Ger - Arkona Basin           |bhi      |
|        14|Swe - Bornholm Basin         |bhi      |
|        15|Den - Bornholm Basin         |bhi      |
|        16|Ger - Bornholm Basin         |bhi      |
|        17|Pol - Bornholm Basin         |bhi      |
|        18|Pol - Gdansk Basin           |bhi      |
|        19|Rus - Gdansk Basin           |bhi      |
|        20|Swe - Eastern Gotland Basin  |bhi      |
|        21|Pol - Eastern Gotland Basin  |bhi      |
|        22|Rus - Eastern Gotland Basin  |bhi      |
|        23|Lit - Eastern Gotland Basin  |bhi      |
|        24|Lat - Eastern Gotland Basin  |bhi      |
|        25|Est - Eastern Gotland Basin  |bhi      |
|        26|Swe - Western Gotland Basin  |bhi      |
|        27|Lat - Gulf of Riga           |bhi      |
|        28|Est - Gulf of Riga           |bhi      |
|        29|Swe - Northern Baltic Proper |bhi      |
|        30|Fin - Northern Baltic Proper |bhi      |
|        31|Est - Northern Baltic Proper |bhi      |
|        32|Fin - Gulf of Finland        |bhi      |
|        33|Rus - Gulf of Finland        |bhi      |
|        34|Est - Gulf of Finland        |bhi      |
|        35|Swe - Aland Sea              |bhi      |
|        36|Fin - Aland Sea              |bhi      |
|        37|Swe - Bothnian Sea           |bhi      |
|        38|Fin - Bothnian Sea           |bhi      |
|        39|Swe - The Quark              |bhi      |
|        40|Fin - The Quark              |bhi      |
|        41|Swe - Bothnian Bay           |bhi      |
|        42|Fin - Bothnian Bay           |bhi      |
|       301|Sweden                       |eez      |
|       302|Denmark                      |eez      |
|       303|Germany                      |eez      |
|       304|Poland                       |eez      |
|       305|Russia                       |eez      |
|       306|Lithuania                    |eez      |
|       307|Latvia                       |eez      |
|       308|Estonia                      |eez      |
|       309|Finland                      |eez      |
|       501|Kattegat                     |subbasin |
|       502|Great Belt                   |subbasin |
|       503|The Sound                    |subbasin |
|       504|Kiel Bay                     |subbasin |
|       505|Bay of Mecklenburg           |subbasin |
|       506|Arkona Basin                 |subbasin |
|       507|Bornholm Basin               |subbasin |
|       508|Gdansk Basin                 |subbasin |
|       509|Eastern Gotland Basin        |subbasin |
|       510|Western Gotland Basin        |subbasin |
|       511|Gulf of Riga                 |subbasin |
|       512|Northern Baltic Proper       |subbasin |
|       513|Gulf of Finland              |subbasin |
|       514|Aland Sea                    |subbasin |
|       515|Bothnian Sea                 |subbasin |
|       516|The Quark                    |subbasin |
|       517|Bothnian Bay                 |subbasin |

(table created by running `knitr::kable(rgns_complete)`)