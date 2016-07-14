resilience\_prep
================

-   [Preparation of Resilience Data Layers](#preparation-of-resilience-data-layers)
    -   [1. Ecological](#ecological)
    -   [1.1 Biological Integrity](#biological-integrity)
    -   [1.2 Goal-specific Regulations](#goal-specific-regulations)
        -   [1.2.1 Background](#background)
        -   [1.2.2 Scoring](#scoring)
        -   [1.2.3 Goal Weighting & Mapping](#goal-weighting-mapping)
        -   [1.2.4 Resilience Data Layer](#resilience-data-layer)
        -   [1.2.5 Goal-specific data layer preparation](#goal-specific-data-layer-preparation)
        -   [1.2.6 Exploring alternative mapping and weighting outcomes](#exploring-alternative-mapping-and-weighting-outcomes)
        -   [1.2.7 Resilience data score for layers](#resilience-data-score-for-layers)
    -   [TO DO](#to-do)
    -   [2. Social](#social)
        -   [2.1 Data](#data)
        -   [2.2 Resilience layer](#resilience-layer)
        -   [2.3 Prepare Data layer](#prepare-data-layer)

Preparation of Resilience Data Layers
=====================================

``` r
## Libraries
library(readr)
```

    ## Warning: package 'readr' was built under R version 3.2.4

``` r
library(dplyr)
```

    ## Warning: package 'dplyr' was built under R version 3.2.5

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(tidyr)
```

    ## Warning: package 'tidyr' was built under R version 3.2.5

``` r
library(ggplot2)
```

    ## Warning: package 'ggplot2' was built under R version 3.2.4

``` r
library(RMySQL)
```

    ## Warning: package 'RMySQL' was built under R version 3.2.5

    ## Loading required package: DBI

    ## Warning: package 'DBI' was built under R version 3.2.5

``` r
library(stringr)
library(tools)
library(rprojroot) # install.packages('rprojroot')
```

    ## Warning: package 'rprojroot' was built under R version 3.2.4

``` r
## rprojroot
root <- rprojroot::is_rstudio_project

## make_path() function to 
make_path <- function(...) rprojroot::find_root_file(..., criterion = is_rstudio_project)


dir_layers = make_path('baltic2015/layers') # replaces  file.path(dir_baltic, 'layers')


# root$find_file("README.md")
# 
# root$find_file("ao_need_gl2014.csv")
# 
# root <- find_root_file("install_ohicore.r", 
# 
# withr::with_dir(
#   root_file("DESCRIPTION"))

source('~/github/bhi/baltic2015/prep/common.r')
dir_res    = file.path(dir_prep, 'resilience')

dir_wgi    = file.path(dir_prep,'pressures/wgi_social') ## to source wgi data

## add a README.md to the prep directory with the rawgit.com url for viewing on GitHub
create_readme(dir_res, 'resilience_prep.rmd') 
```

1. Ecological
-------------

1.1 Biological Integrity
------------------------

The biodiversity data layer will be used to represent biological integrity.

1.2 Goal-specific Regulations
-----------------------------

### 1.2.1 Background

This component of resilience captures the capacity of pressures to be offset by regulations/laws.

There are three components to goal-specific regulation resilience: *(1) existence, (2) compliance, (3) enforcement*

Two international treaties are assessed for all BHI countries for *existence* only.These agreements are:
[Convention on Biodiversity (CBD)](https://www.cbd.int)
[Paris Climate Agreement (COP21)](https://treaties.un.org/pages/ViewDetails.aspx?src=TREATY&mtdsg_no=XXVII-7-d&chapter=27&lang=en)

The international agreement, [Convention on International Trade in Endangered Species of Wild Fauna and Flora (CITES)](https://www.cites.org), is also enacted to EU law, therefore it can be assessed for compliance although Russia will only have an existance componenent.

Two Baltic Region agreements will be assessed for *existence* and *compliance* for all countries. These are: Baltic Sea Action Plan (BSAP); Helsinki Convention (HELCOM).

13 EU directives will be assessed for *existence* and *compliance* for BHI countries that are EU member states. These are: Water Framework Directive (WFD), Marine Spatial Planning Directive (MSPD), Marine Strategy Framework Directive (MSFD), Habitat Directive (HD), Common Fisheries Policy (CFP), National Emmissions Ceilings (NEC), Industrial Emissions Directive (IED), Urban Waste Water Treatment Directive (UWWTD), Bathing Water Directive (BWD), Conservation of Wild Birds (BIRDS), Registration, Evaluation, Authorisation and Restriction of Chemicals (REACH), Peristent Organic Pollutants (POP), Nitrates Directive (ND).

*Note* IED and MSPD, while having compliance components can not currently have compliances assessed as the deadlines for compliance and reporting have only just recently occurred or have not occurred yet (are 2016 dates).

### 1.2.2 Scoring

By country for each level assessed for each regulation

#### 1.2.2.1 Existence

Scored as yes (1) or no (0)
Score\_Existence = Score / Max Max = 1

#### 1.2.2.2 Compliance

Fail (0), Partial (1), Full (3)
Not equal increments because Full compliance rewarded more here.

Country\_compliance\_directive = Mean (compliance score)\_all\_compliance\_components

#### 1.2.2.3 Total regulation score

Score\_Existence + Country\_compliance\_directive / (Possible\_Existence + Possible\_Compliance)

Compliance is weighted more heavily than existence when both are scored.

### 1.2.3 Goal Weighting & Mapping

Each regulation will be weighted (1 or 2) for each goal to which is it applied. Regulations are mapped to all the goals to which they directly influence/combat pressures.

### 1.2.4 Resilience Data Layer

Country-specific resilience score (G) for each goal is assigned to each BHI region associated with that country.

G = sum(w\_i \* G\_i) / sum(wi\_i) ; G\_i = specific regulatory dataset total regulation score, w\_i = weight for each i dataset used to assess G

### 1.2.5 Goal-specific data layer preparation

#### 1.2.5.1 Read in data

``` r
## read in data

eu_baltic_scores = read.csv(file.path(dir_res, 'eu_regs_resilience_data.csv'), sep=";")

international_scores = read.csv(file.path(dir_res, 'international_agreements_resilience_data.csv'), sep=";")


## 
str(eu_baltic_scores)
```

    ## 'data.frame':    879 obs. of  13 variables:
    ##  $ DirectiveName                     : Factor w/ 18 levels "Commission Implementing Regulation 792/2012 of 23 August 2012 laying down rules for the design of permits, certificates and oth"| __truncated__,..: 12 12 12 12 12 12 12 12 12 12 ...
    ##  $ DirectiveAbbreviation             : Factor w/ 16 levels "BIRDS","BSAP",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ ReportYear                        : int  2014 2014 2014 2014 2014 2014 2014 2014 2014 2014 ...
    ##  $ CountryName                       : Factor w/ 9 levels "Denmark","Estonia",..: 1 1 1 1 1 1 1 1 2 2 ...
    ##  $ IsCountryAssessed                 : Factor w/ 3 levels "","No","Yes": 3 3 3 3 3 3 3 3 3 3 ...
    ##  $ ComplianceComponent               : Factor w/ 109 levels ""," Combat marine pollution",..: 96 30 103 50 82 95 31 29 97 30 ...
    ##  $ ComplianceComponentScore          : Factor w/ 3 levels "fail","full",..: 2 2 2 2 2 2 3 2 2 2 ...
    ##  $ NAexplanation                     : Factor w/ 8 levels "","Difficult to assess",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ ComplianceText                    : Factor w/ 77 levels "","\" As the balance is done in accordance with WFD requirements, it is clear how much less water needs to be abstracted.\"",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ ComplianceTextReference           : Factor w/ 193 levels "","Art. 10","Art. 11 (Annexes IV and VII)",..: 129 135 186 130 131 171 174 178 129 135 ...
    ##  $ Notes_UncertainitiesInECreport    : Factor w/ 10 levels ""," ","German plans to reduce this pressure showed a list of links to legislation and did not introduced the measures (unknown).",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ Notes_AreasForFurtherInvestigation: Factor w/ 28 levels "","\"Finland has an extensive hydrological monitoring network in place, providing daily information about the water levels and rat"| __truncated__,..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ Comments                          : Factor w/ 75 levels "","11 threats or pressures were considered: i) Agriculture, ii) Sylviculture, foresty, iii) Mining, extraction of materials and en"| __truncated__,..: 1 1 1 1 7 73 28 1 1 1 ...

``` r
dim(eu_baltic_scores)
```

    ## [1] 879  13

``` r
str(international_scores)
```

    ## 'data.frame':    19 obs. of  14 variables:
    ##  $ DirectiveName                     : Factor w/ 3 levels "Convention on Biodiversity",..: 1 1 1 1 1 1 1 1 1 2 ...
    ##  $ DirectiveAbbreviation             : Factor w/ 3 levels "CBD","CITES",..: 1 1 1 1 1 1 1 1 1 2 ...
    ##  $ DataLink                          : Factor w/ 3 levels "https://treaties.un.org/pages/ViewDetails.aspx?src=TREATY&mtdsg_no=XXVII-7-d&chapter=27&lang=en",..: 2 2 2 2 2 2 2 2 2 3 ...
    ##  $ ReportYear                        : logi  NA NA NA NA NA NA ...
    ##  $ CountryName                       : Factor w/ 9 levels "Denmark","Estonia",..: 1 2 3 4 5 6 7 9 8 8 ...
    ##  $ Existence                         : Factor w/ 1 level "Yes": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ ExistenceLevel                    : Factor w/ 4 levels "Acceptance","Continuation",..: 3 3 1 3 3 3 3 3 3 2 ...
    ##  $ ExistenceNotes                    : Factor w/ 2 levels "All terms, \"ratification\" (rtf), \"accession\" (acs), \"approval\" (apv) and \"acceptance\" (acp), signify the consent of a S"| __truncated__,..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ ComplianceComponent               : logi  NA NA NA NA NA NA ...
    ##  $ ComplianceComponentScore          : logi  NA NA NA NA NA NA ...
    ##  $ NAexplanation                     : Factor w/ 1 level "Currently will not assess for compliance": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ Notes_UncertainitiesInECreport    : logi  NA NA NA NA NA NA ...
    ##  $ Notes_AreasForFurtherInvestigation: logi  NA NA NA NA NA NA ...
    ##  $ Comments                          : logi  NA NA NA NA NA NA ...

``` r
dim(international_scores)
```

    ## [1] 19 14

#### 1.2.5.2 simply data objectives, combine into single object

``` r
eu_baltic_lookup = eu_baltic_scores ## keep the info of text references in case needed
internat_lookup = international_scores


eu_baltic_scores = eu_baltic_scores %>%
                  mutate(Existence = "Yes",
                         ExistenceLevel = "EU_Law",
                         ExistenceNotes = "")%>% ## add existence so that compatible with international ## all EU and Baltic directives / agreements exist (if at EU level are at country level)
                  select(-DirectiveName,-ComplianceText,-ComplianceTextReference,-Notes_UncertainitiesInECreport,-Notes_AreasForFurtherInvestigation)%>%
                  select(DirectiveAbbreviation,ReportYear,CountryName,Existence,ExistenceLevel,ExistenceNotes,IsCountryAssessed,ComplianceComponent, ComplianceComponentScore,NAexplanation,Comments) %>% ## reorder
                      dplyr::rename(NAexplanationCompliance = NAexplanation,
                                    IsCountryComplianceAssessed = IsCountryAssessed)

colnames(eu_baltic_scores)
```

    ##  [1] "DirectiveAbbreviation"       "ReportYear"                 
    ##  [3] "CountryName"                 "Existence"                  
    ##  [5] "ExistenceLevel"              "ExistenceNotes"             
    ##  [7] "IsCountryComplianceAssessed" "ComplianceComponent"        
    ##  [9] "ComplianceComponentScore"    "NAexplanationCompliance"    
    ## [11] "Comments"

``` r
international_scores = international_scores %>%
                      mutate(IsCountryAssessed = "No")  %>% ## this is for compliance
                        select(-DirectiveName,-DataLink,-Notes_UncertainitiesInECreport,-Notes_AreasForFurtherInvestigation) %>%
                  select(DirectiveAbbreviation,ReportYear,CountryName,Existence,ExistenceLevel,ExistenceNotes,IsCountryAssessed,ComplianceComponent, ComplianceComponentScore,NAexplanation,Comments) %>%## reorder
                      dplyr::rename(NAexplanationCompliance = NAexplanation,
                                    IsCountryComplianceAssessed = IsCountryAssessed)

colnames(international_scores)
```

    ##  [1] "DirectiveAbbreviation"       "ReportYear"                 
    ##  [3] "CountryName"                 "Existence"                  
    ##  [5] "ExistenceLevel"              "ExistenceNotes"             
    ##  [7] "IsCountryComplianceAssessed" "ComplianceComponent"        
    ##  [9] "ComplianceComponentScore"    "NAexplanationCompliance"    
    ## [11] "Comments"

``` r
goal_spec = rbind(eu_baltic_scores, international_scores) %>%
            arrange(DirectiveAbbreviation, CountryName)
```

#### 1.2.5.3 assign numeric score

``` r
goal_spec = goal_spec %>% 
            mutate(exist_numeric = ifelse(Existence == "Yes",1,0),
                   compli_numeric = ifelse(is.na(ComplianceComponentScore),NA,
                                    ifelse(ComplianceComponentScore == "fail",0,
                                    ifelse(ComplianceComponentScore == "partial",1,
                                    ifelse(ComplianceComponentScore == "full",3,NA)))))
```

#### 1.2.5.4 Plot numeric score

With the numeric score for Compliance Components, can not see overlapping scores for different components

``` r
ggplot(goal_spec) + 
  geom_point(aes(CountryName,exist_numeric))+
  facet_wrap(~DirectiveAbbreviation)+
  ylim(0,1)+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Existence Score")
```

![](resilience_prep_files/figure-markdown_github/plot%20raw%20score-1.png)

``` r
ggplot(goal_spec) + 
  geom_point(aes(CountryName,compli_numeric))+
  facet_wrap(~DirectiveAbbreviation)+
  ylim(0,3)+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Compliance Score")
```

    ## Warning: Removed 284 rows containing missing values (geom_point).

![](resilience_prep_files/figure-markdown_github/plot%20raw%20score-2.png)

#### 1.2.5.5 Separate Existance and Compliance

``` r
goal_spec_exist = goal_spec %>%
                  select(DirectiveAbbreviation:ExistenceNotes, exist_numeric)

goal_spec_compli = goal_spec %>%
                  select(DirectiveAbbreviation:CountryName, IsCountryComplianceAssessed:Comments, compli_numeric)
```

#### 1.2.5.6 How many compliance components assessed?

Some directives have no components assessed. Others have a subset that could not be assessed - these might differ by country. Minimal differences by country. WDF not assessed for Denmark. Germany assessed for one more POP component. Poland asssesse for one fewer UWWTD component.
**Gray bars are components not assessed**

``` r
goal_spec_compli_n1 = goal_spec_compli %>%
                      count(DirectiveAbbreviation, CountryName,compli_numeric)

ggplot(goal_spec_compli, aes(CountryName,fill=as.character(compli_numeric)))+ 
  geom_bar(position="stack")+
  facet_wrap(~DirectiveAbbreviation)+
  ylab("Count of Compliance Componenets")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Compliance Components Assessed by Country & Directive")
```

![](resilience_prep_files/figure-markdown_github/unnamed-chunk-1-1.png)

#### 1.2.5.7 Mean Compliance score

``` r
## calculate the mean value for all scored compliance by directive and country
goal_spec_compli_mean = goal_spec_compli%>%
            select(DirectiveAbbreviation,CountryName,compli_numeric) %>%
            group_by(DirectiveAbbreviation,CountryName)%>%          
            summarise(compli_mean = mean(compli_numeric, na.rm=TRUE)) %>%
            ungroup()

                      
## get the number of components assessed
goal_spec_compli_n2 = goal_spec_compli%>%
                      select(DirectiveAbbreviation,CountryName,compli_numeric) %>%
                      filter(!is.na(compli_numeric))%>%
                      count(DirectiveAbbreviation,CountryName)

## merge the mean score and the count of components
goal_spec_compli_mean = goal_spec_compli_mean %>%
                        left_join(., goal_spec_compli_n2, 
                                  by= c("DirectiveAbbreviation","CountryName"))
               

dim(goal_spec_compli_mean)
```

    ## [1] 149   4

#### 1.2.5.8 Plot Mean Compliance score

**Max compliance score can be 3**

``` r
ggplot(goal_spec_compli_mean)+
  geom_point(aes(CountryName,compli_mean,size=n))+
  facet_wrap(~DirectiveAbbreviation)+
  ylim(0,4)+
  ylab("Mean compliance score")+
  theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Mean Compliance Score")
```

    ## Warning: Removed 37 rows containing missing values (geom_point).

![](resilience_prep_files/figure-markdown_github/plot%20mean%20compliance%20score-1.png)

#### 1.2.5.9 Existence score

``` r
dim(goal_spec_exist)#898   7
```

    ## [1] 898   7

``` r
goal_spec_exist = goal_spec_exist %>%
                  select(DirectiveAbbreviation,CountryName,exist_numeric,ExistenceLevel) %>%
                  distinct(.)
                  
dim(goal_spec_exist)#149   4
```

    ## [1] 149   4

``` r
head(goal_spec_exist)
```

    ##   DirectiveAbbreviation CountryName exist_numeric ExistenceLevel
    ## 1                 BIRDS     Denmark             1         EU_Law
    ## 2                 BIRDS     Estonia             1         EU_Law
    ## 3                 BIRDS     Finland             1         EU_Law
    ## 4                 BIRDS     Germany             1         EU_Law
    ## 5                 BIRDS      Latvia             1         EU_Law
    ## 6                 BIRDS   Lithuania             1         EU_Law

#### 1.2.5.10 Overall score

Max score is 4 (1 for existence, 3 for compliance).

All directives are evaluated based on a maximum score of 4. Therefore, for directives where only existence can be measured (no compliance metrics), the maximum score possible is 1/4. These directives are: *IED, MSPD, CBD, CITES, COP21*. Directives that are scored on both existence and compliance are: *BIRDS, BSAP, BWD, CFP, HD, HELCOM, MSFD, ND, NEC, POP, REACH, UWWTD, WFD*.

In two directives scored for compliance, there was a country where compliance could not be scored. For UWWTD, no compliance report was available for Poland. For WFD, no compliance report was available for Denmark. However, these two countries are still evaluated on both existence and compliance so that their score is comparable to other countries for these directives.

``` r
## merge existence and compliance
goal_spec_overall = full_join(goal_spec_exist, goal_spec_compli_mean,
                              by=c("DirectiveAbbreviation","CountryName")) %>%
                    mutate(compli_mean2 = ifelse(is.na(compli_mean),0,compli_mean)) %>% ## make a column where NA are zero so that it does not screw up the total score
                    mutate(total = exist_numeric + compli_mean2, 
                           max_score =4)

## This code not necessary if all directives get a max score of 4. 
# ## for UWWTD, Poland and WFD, Denmark, change max score to 4 so that are comparable
# goal_spec_overall = goal_spec_overall %>%
#                     mutate(max_score = ifelse(CountryName=="Poland" & DirectiveAbbreviation =="UWWTD",4,max_score),
#                            max_score = ifelse(CountryName=="Denmark" & DirectiveAbbreviation =="WFD",4,max_score))
# 


## calculate overall score
goal_spec_overall = goal_spec_overall %>%
                    mutate(overall_score = total/max_score) %>% 
                    mutate(score_level = ifelse(DirectiveAbbreviation %in% c("IED","MSPD","CBD","COP21"), "existence", "existence and compliance")) %>% ## score level defined by directives scored only for existence or for both
  select(DirectiveAbbreviation, CountryName,overall_score, score_level)
```

#### 1.2.5.11 Plot Overall score

Although, note for CITES that Russia only has existence component but all other countries receive compliance score because EU regulation.

``` r
ggplot(goal_spec_overall)+
  geom_point(aes(CountryName,overall_score, colour=score_level))+
  facet_wrap(~DirectiveAbbreviation)+
  ylim(0,1)+
   theme(axis.text.x = element_text(colour="grey20", size=8, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Overall Score per Regulation")
```

![](resilience_prep_files/figure-markdown_github/plot%20overall%20score-1.png)

#### 1.2.5.12 Plot Overall score by country across all directives

``` r
ggplot(goal_spec_overall)+
  geom_point(aes(DirectiveAbbreviation,overall_score, colour=score_level))+
  facet_wrap(~CountryName)+
  ylim(0,1)+
   theme(axis.text.x = element_text(colour="grey20", size=6, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Overall Score per Regulation")
```

![](resilience_prep_files/figure-markdown_github/plot%20overall%20score%20by%20country-1.png)

### 1.2.6 Exploring alternative mapping and weighting outcomes

**Mapping**
Mapping the directives to goals can be done with different criteria. We explore 2 alternative mapping critera.
(1) Direct effect of directive on goal status - expert opinion
(2) Direct or indirect effect directive on goal status - expert opinion and key word search of the directives

*Note* for this exploration this is done at the subgoal level. NUT, CON, TRA are treated as subgoals (not subcomponents) here.

**Weights**
Weights among different directives can be set using different criteria. We calculate *G* in the resilience equation for two different mapping criteria.

G = sum(w\_i \* G\_i) / sum(wi\_i) ; G\_i = specific regulatory dataset, w\_i = weight for each i dataset used to assess G

Two weighting alternatives are assess: "importance": this is assessment of the relative importance and policy focus among the different directives. More important directives receiving a value of 2, less important a value of 1.

"reporting quality and ability to assess compliance": EU regulations were assess by Joana for the quality of their compliance reporting and ability to make a compliance assessment. Easier to asssess and better reporting received a value of 2 while poorer quality reporting and difficulty in assessment received a value of 1. International regulations (CBD, COP21) were the assigned weight of 1.

#### 1.2.6.1 Load mapping and weighting layers

``` r
map_direct = read.csv(file.path(dir_res, 'resilience_matrix_direct.csv'),
                      stringsAsFactors = FALSE)

map_indirect_direct = read.csv(file.path(dir_res, 'resilience_matrix_indirect_direct.csv'), stringsAsFactors = FALSE)


weights_importance = read.csv(file.path(dir_res, 'resilience_weights_directive_importance.csv'))

weights_quality = read.csv(file.path(dir_res, 'resilience_weights_quality.csv'))
```

#### 1.2.6.2 Calculate *G* for each country for direct mapping

``` r
## vector of unique regulations
unique_regs = map_direct %>%
              select(WFD:IED)%>%
              colnames()
unique_regs
```

    ##  [1] "WFD"    "HD"     "MSFD"   "HELCOM" "BSAP"   "REACH"  "POP"   
    ##  [8] "CBD"    "CITES"  "CFP"    "COP21"  "MSPD"   "BWD"    "BIRDS" 
    ## [15] "ND"     "UWWTD"  "NEC"    "IED"

``` r
## long data format for mapping with columns goal, regulation, map
map_direct_long = map_direct %>%
                  select(-component,-spp_status,-wgi_all)%>% ## remove component column, remove environment and social resilience
                  gather(regulation,map, -goal) %>%
                  filter(map %in% unique_regs) %>%
                  arrange(goal)
  
                  
head(map_direct_long)
```

    ##   goal regulation    map
    ## 1   AO       MSFD   MSFD
    ## 2   AO        CFP    CFP
    ## 3  CON       MSFD   MSFD
    ## 4  CON     HELCOM HELCOM
    ## 5  CON       BSAP   BSAP
    ## 6  CON      REACH  REACH

``` r
## clean weights_importance object
weights_importance = weights_importance %>%
                      filter(layer != 'spp_status')%>%
                      filter(layer != 'wgi_all' )

## clean weights_joana object
weights_quality = weights_quality %>%
                      filter(layer != 'spp_status')%>%
                      filter(layer != 'wgi_all' )

##--------------------------------------------##
## CALCULATION for direct mapping and weights by importance

## join mapping to weights
map_direct_wi_importance = left_join(map_direct_long, weights_importance,
                        by=c("regulation"="layer"))
```

    ## Warning in left_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## factor and character vector, coercing into character vector

``` r
## join country scoring to mapping and weights
map_direct_wi_importance_score = inner_join(goal_spec_overall, map_direct_wi_importance,
                                     by=c("DirectiveAbbreviation"="regulation"))%>%
                           dplyr::rename(regulation = DirectiveAbbreviation,
                                         country= CountryName)%>%
                           select(-score_level) %>%
                           arrange(country,goal)
```

    ## Warning in inner_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## factor and character vector, coercing into character vector

``` r
## calculate country G

country_G_direct_wi_importance = map_direct_wi_importance_score %>%
                   select(-map,-type)%>%
                   mutate(wi_Gi = weight*overall_score)%>%
                   group_by(country,goal)%>%
                   summarise(G = sum(wi_Gi)/sum(weight))%>%
                   ungroup()
              
## plot country G direct 
ggplot(country_G_direct_wi_importance)+
  geom_point(aes(goal,G))+
  facet_wrap(~country)+
  ylim(0,1)+
  theme(axis.text.x = element_text(colour="grey20", size=6, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"),
        title = element_text(size=8))+
  ggtitle("Country G value (overall resilience) per Goal with direct mapping, weights by importance")
```

![](resilience_prep_files/figure-markdown_github/direct%20mapping%20G-1.png)

``` r
ggplot(country_G_direct_wi_importance)+
  geom_point(aes(country,G))+
  facet_wrap(~goal)+
  ylim(0,1)+
  theme(axis.text.x = element_text(colour="grey20", size=6, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"),
        title = element_text(size=8))+
  ggtitle("Country G value (overall resilience) per Goal with direct mapping, weights by importance")
```

![](resilience_prep_files/figure-markdown_github/direct%20mapping%20G-2.png)

``` r
##--------------------------------------------##
## CALCULATION for direct mapping and weights by Joana's quality assessment

## join mapping to weights
map_direct_wi_quality = left_join(map_direct_long, weights_quality,
                        by=c("regulation"="layer"))
```

    ## Warning in left_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## factor and character vector, coercing into character vector

``` r
## join country scoring to mapping and weights
map_direct_wi_quality_score = inner_join(goal_spec_overall, map_direct_wi_quality,
                                     by=c("DirectiveAbbreviation"="regulation"))%>%
                           dplyr::rename(regulation = DirectiveAbbreviation,
                                         country= CountryName)%>%
                           select(-score_level) %>%
                           arrange(country,goal)
```

    ## Warning in inner_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## factor and character vector, coercing into character vector

``` r
## calculate country G

country_G_direct_wi_quality = map_direct_wi_quality_score %>%
                   select(-map,-type)%>%
                   mutate(wi_Gi = weight*overall_score)%>%
                   group_by(country,goal)%>%
                   summarise(G = sum(wi_Gi)/sum(weight))%>%
                   ungroup()
              
## plot country G direct 
ggplot(country_G_direct_wi_quality)+
  geom_point(aes(goal,G))+
  facet_wrap(~country)+
  ylim(0,1)+
  theme(axis.text.x = element_text(colour="grey20", size=6, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"),
        title = element_text(size=8))+
  ggtitle("Country G value (overall resilience) per Goal with direct mapping, weights by quality")
```

![](resilience_prep_files/figure-markdown_github/direct%20mapping%20G-3.png)

``` r
ggplot(country_G_direct_wi_quality)+
  geom_point(aes(country,G))+
  facet_wrap(~goal)+
  ylim(0,1)+
  theme(axis.text.x = element_text(colour="grey20", size=6, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"),
        title = element_text(size=8))+
  ggtitle("Country G value (overall resilience) per Goal with direct mapping, weights by quality")
```

![](resilience_prep_files/figure-markdown_github/direct%20mapping%20G-4.png)

#### 1.2.6.3 Calculate *G* for each country for direct and indirect mapping

For both weighting alternatives.

``` r
## vector of unique regulations
unique_regs = map_indirect_direct %>%
              select(WFD:IED)%>%
              colnames()
unique_regs
```

    ##  [1] "WFD"    "HD"     "MSFD"   "HELCOM" "BSAP"   "REACH"  "POP"   
    ##  [8] "CBD"    "CITES"  "CFP"    "COP21"  "MSPD"   "BWD"    "BIRDS" 
    ## [15] "ND"     "UWWTD"  "NEC"    "IED"

``` r
## long data format for mapping with columns goal, regulation, map
map_indirect_direct_long = map_indirect_direct %>%
                  select(-component,-spp_status,-wgi_all)%>% ## remove component column, remove environment and social resilience
                  gather(regulation,map, -goal) %>%
                  filter(map %in% unique_regs) %>%
                  arrange(goal)
  
                  
head(map_indirect_direct_long)
```

    ##   goal regulation  map
    ## 1   AO        WFD  WFD
    ## 2   AO       MSFD MSFD
    ## 3   AO       BSAP BSAP
    ## 4   AO        CFP  CFP
    ## 5  CON        WFD  WFD
    ## 6  CON       MSFD MSFD

``` r
## clean weights_importance object
weights_importance = weights_importance %>%
                      filter(layer != 'spp_status')%>%
                      filter(layer != 'wgi_all' )

## clean weights_joana object
weights_quality = weights_quality %>%
                      filter(layer != 'spp_status')%>%
                      filter(layer != 'wgi_all' )


##--------------------------------------------##
## CALCULATION for direct mapping and weights by importance

## join mapping to weights
map_indirect_direct_wi_importance = left_join(map_indirect_direct_long, weights_importance,
                        by=c("regulation"="layer"))
```

    ## Warning in left_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## factor and character vector, coercing into character vector

``` r
## join country scoring to mapping and weights
map_indirect_direct_wi_importance_score = inner_join(goal_spec_overall,
                                                     map_indirect_direct_wi_importance,
                                     by=c("DirectiveAbbreviation"="regulation"))%>%
                           dplyr::rename(regulation = DirectiveAbbreviation,
                                         country= CountryName)%>%
                           select(-score_level) %>%
                           arrange(country,goal)
```

    ## Warning in inner_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## factor and character vector, coercing into character vector

``` r
## calculate country G

country_G_indirect_direct_wi_importance = map_indirect_direct_wi_importance_score %>%
                   select(-map,-type)%>%
                   mutate(wi_Gi = weight*overall_score)%>%
                   group_by(country,goal)%>%
                   summarise(G = sum(wi_Gi)/sum(weight))%>%
                   ungroup()
              
## plot country G direct 
ggplot(country_G_indirect_direct_wi_importance)+
  geom_point(aes(goal,G))+
  facet_wrap(~country)+
  ylim(0,1)+
  theme(axis.text.x = element_text(colour="grey20", size=6, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"),
        title = element_text(size=8))+
  ggtitle("Country G value (overall resilience) per Goal w/ indirect + direct mapping, weights by importance")
```

![](resilience_prep_files/figure-markdown_github/calcuate%20G%20indirect%20and%20direct-1.png)

``` r
ggplot(country_G_indirect_direct_wi_importance)+
  geom_point(aes(country,G))+
  facet_wrap(~goal)+
  ylim(0,1)+
  theme(axis.text.x = element_text(colour="grey20", size=6, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"),
        title = element_text(size=8))+
  ggtitle("Country G value (overall resilience) per Goal w/ indirect +direct mapping, weights by importance")
```

![](resilience_prep_files/figure-markdown_github/calcuate%20G%20indirect%20and%20direct-2.png)

``` r
##--------------------------------------------##
## CALCULATION for direct mapping and weights by Joana's quality assessment

## join mapping to weights
map_indirect_direct_wi_quality = left_join(map_indirect_direct_long, weights_quality,
                        by=c("regulation"="layer"))
```

    ## Warning in left_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## factor and character vector, coercing into character vector

``` r
## join country scoring to mapping and weights
map_indirect_direct_wi_quality_score = inner_join(goal_spec_overall,
                                                     map_indirect_direct_wi_quality,
                                     by=c("DirectiveAbbreviation"="regulation"))%>%
                           dplyr::rename(regulation = DirectiveAbbreviation,
                                         country= CountryName)%>%
                           select(-score_level) %>%
                           arrange(country,goal)
```

    ## Warning in inner_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## factor and character vector, coercing into character vector

``` r
## calculate country G

country_G_indirect_direct_wi_quality = map_indirect_direct_wi_quality_score %>%
                   select(-map,-type)%>%
                   mutate(wi_Gi = weight*overall_score)%>%
                   group_by(country,goal)%>%
                   summarise(G = sum(wi_Gi)/sum(weight))%>%
                   ungroup()
              
## plot country G direct 
ggplot(country_G_indirect_direct_wi_quality)+
  geom_point(aes(goal,G))+
  facet_wrap(~country)+
  ylim(0,1)+
  theme(axis.text.x = element_text(colour="grey20", size=6, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"),
        title = element_text(size=8))+
  ggtitle("Country G value (overall resilience) per Goal w/ indirect + direct mapping, weights by quality")
```

![](resilience_prep_files/figure-markdown_github/calcuate%20G%20indirect%20and%20direct-3.png)

``` r
ggplot(country_G_indirect_direct_wi_quality)+
  geom_point(aes(country,G))+
  facet_wrap(~goal)+
  ylim(0,1)+
  theme(axis.text.x = element_text(colour="grey20", size=6, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"),
        title = element_text(size=8))+
  ggtitle("Country G value (overall resilience) per Goal w/ indirect +direct mapping, weights by quality")
```

![](resilience_prep_files/figure-markdown_github/calcuate%20G%20indirect%20and%20direct-4.png)

#### 1.2.6.4 Plot comparison of *G* by mapping approach

``` r
country_G_compare = bind_rows(
                          mutate(country_G_direct_wi_importance,
                                 mapping_weighting="direct, importance"),
                          mutate(country_G_direct_wi_quality,
                                 mapping_weighting="direct, quality"),
                          mutate(country_G_indirect_direct_wi_importance,
                                 mapping_weighting= "indirect and direct, importance"),
                          mutate(country_G_indirect_direct_wi_quality,
                                 mapping_weighting= "indirect and direct, quality"))

## plot country G comparison 
ggplot(country_G_compare)+
  geom_point(aes(goal,G, color=mapping_weighting, shape=mapping_weighting))+
  facet_wrap(~country)+
  ylim(0,1)+
  scale_shape_manual(values=c(16,16,6,6))+
  theme(axis.text.x = element_text(colour="grey20", size=6, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Country G Mapping and Weighting Comparison")
```

![](resilience_prep_files/figure-markdown_github/G%20comparison-1.png)

``` r
## plot country G direct 
ggplot(country_G_compare)+
  geom_point(aes(country,G, colour=mapping_weighting,shape=mapping_weighting))+
  facet_wrap(~goal)+
  ylim(0,1)+
   scale_shape_manual(values=c(16,16,6,6))+
  theme(axis.text.x = element_text(colour="grey20", size=6, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"))+
  ggtitle("Country G Mapping Comparison")
```

![](resilience_prep_files/figure-markdown_github/G%20comparison-2.png)

### 1.2.7 Resilience data score for layers

Join by country to BHI regions, separate each regulation into separate data layer, save layers

#### 1.2.7.1 Select and clean goal specific regulations resilience data object

``` r
head(goal_spec_overall)
```

    ##   DirectiveAbbreviation CountryName overall_score              score_level
    ## 1                 BIRDS     Denmark        0.9375 existence and compliance
    ## 2                 BIRDS     Estonia        1.0000 existence and compliance
    ## 3                 BIRDS     Finland        0.9375 existence and compliance
    ## 4                 BIRDS     Germany        0.9375 existence and compliance
    ## 5                 BIRDS      Latvia        0.9375 existence and compliance
    ## 6                 BIRDS   Lithuania        0.9375 existence and compliance

``` r
goal_spec_overall1 = goal_spec_overall %>%
                       select(DirectiveAbbreviation, CountryName,overall_score)
```

#### 1.2.7.2 Read in BHi regions

``` r
bhi_lookup = read.csv(file.path(dir_res, 'bhi_basin_country_lookup.csv'), 
                                sep=";", stringsAsFactors=FALSE) %>%
                      select(rgn_id = BHI_ID, country= rgn_nam)
```

#### 1.2.7.3 Join BHI regions and country goal specific regulation data

``` r
goal_spec_overall1 = goal_spec_overall1  %>%
                      full_join(., bhi_lookup, by= c("CountryName"="country"))
```

    ## Warning in full_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
    ## character vector and factor, coercing into character vector

``` r
dim(goal_spec_overall1)
```

    ## [1] 717   4

#### 1.2.7.4 Plot by BHI region

``` r
ggplot(goal_spec_overall1)+
  geom_point(aes(DirectiveAbbreviation,overall_score))+
  facet_wrap(~rgn_id)+
  ylim(0,1)+
  xlab("BHI region")+
   theme(axis.text.x = element_text(colour="grey20", size=5, angle=90, 
                                    hjust=.5, vjust=.5, face = "plain"),
         axis.text.y = element_text(size=6))+
  ggtitle("Overall Score per Regulation")
```

![](resilience_prep_files/figure-markdown_github/plots%20scores%20for%20all%20goal%20regs%20by%20bhi%20region-1.png)

#### 1.2.7.5 Create separate objects

``` r
### first spread and gather so that there are NAs for all regions if there is no regulation (eg Russia for EU regs)

goal_spec_overall2 = goal_spec_overall1 %>%
                     select(-CountryName)%>%
                     spread(DirectiveAbbreviation,overall_score) %>%
                     gather(DirectiveAbbreviation, overall_score, -rgn_id)



res_reg_birds = goal_spec_overall2 %>%
                filter(DirectiveAbbreviation == "BIRDS") %>%
                select(rgn_id,resilience_score = overall_score) %>%
                arrange(rgn_id)


res_reg_bsap = goal_spec_overall2 %>%
                filter(DirectiveAbbreviation == "BSAP") %>%
                select(rgn_id,resilience_score = overall_score) %>%
                arrange(rgn_id)

res_reg_bwd = goal_spec_overall2 %>%
                filter(DirectiveAbbreviation == "BWD") %>%
                select(rgn_id,resilience_score = overall_score) %>%
                arrange(rgn_id)

res_reg_cfp = goal_spec_overall2 %>%
                filter(DirectiveAbbreviation == "CFP") %>%
                select(rgn_id,resilience_score = overall_score) %>%
                arrange(rgn_id)

res_reg_cites = goal_spec_overall2 %>%
                filter(DirectiveAbbreviation == "CITES") %>%
                select(rgn_id,resilience_score = overall_score) %>%
                arrange(rgn_id)

res_reg_hd = goal_spec_overall2 %>%
                filter(DirectiveAbbreviation == "HD") %>%
                select(rgn_id,resilience_score = overall_score) %>%
                arrange(rgn_id)

res_reg_helcom = goal_spec_overall2 %>%
                filter(DirectiveAbbreviation == "HELCOM") %>%
                select(rgn_id,resilience_score = overall_score) %>%
                arrange(rgn_id)

res_reg_ied = goal_spec_overall2 %>%
                filter(DirectiveAbbreviation == "IED") %>%
                select(rgn_id,resilience_score = overall_score) %>%
                arrange(rgn_id)

res_reg_msfd = goal_spec_overall2 %>%
                filter(DirectiveAbbreviation == "MSFD") %>%
                select(rgn_id,resilience_score = overall_score) %>%
                arrange(rgn_id)

res_reg_mspd = goal_spec_overall2 %>%
                filter(DirectiveAbbreviation == "MSPD") %>%
                select(rgn_id,resilience_score = overall_score) %>%
                arrange(rgn_id)

res_reg_nd = goal_spec_overall2 %>%
                filter(DirectiveAbbreviation == "ND") %>%
                select(rgn_id,resilience_score = overall_score) %>%
                arrange(rgn_id)

res_reg_nec = goal_spec_overall2 %>%
                filter(DirectiveAbbreviation == "NEC") %>%
                select(rgn_id,resilience_score = overall_score) %>%
                arrange(rgn_id)

res_reg_pop = goal_spec_overall2 %>%
                filter(DirectiveAbbreviation == "POP") %>%
                select(rgn_id,resilience_score = overall_score) %>%
                arrange(rgn_id)

res_reg_reach = goal_spec_overall2 %>%
                filter(DirectiveAbbreviation == "REACH") %>%
                select(rgn_id,resilience_score = overall_score) %>%
                arrange(rgn_id)

res_reg_uwwtd = goal_spec_overall2 %>%
                filter(DirectiveAbbreviation == "UWWTD") %>%
                select(rgn_id,resilience_score = overall_score) %>%
                arrange(rgn_id)

res_reg_wfd = goal_spec_overall2 %>%
                filter(DirectiveAbbreviation == "WFD") %>%
                select(rgn_id,resilience_score = overall_score) %>%
                arrange(rgn_id)

res_reg_cbd = goal_spec_overall2 %>%
                filter(DirectiveAbbreviation == "CBD") %>%
                select(rgn_id,resilience_score = overall_score) %>%
                arrange(rgn_id)

res_reg_cop21 = goal_spec_overall2 %>%
                filter(DirectiveAbbreviation == "COP21") %>%
                select(rgn_id,resilience_score = overall_score) %>%
                arrange(rgn_id)
```

#### 1.2.7.6 Save goal specific regulation resilience layers

``` r
write.csv(res_reg_birds , file.path(dir_layers,'res_reg_birds_bhi2015.csv'),row.names = FALSE)
write.csv(res_reg_bsap , file.path(dir_layers,'res_reg_bsap_bhi2015.csv'),row.names = FALSE)
write.csv(res_reg_bwd , file.path(dir_layers,'res_reg_bwd_bhi2015.csv'),row.names = FALSE)
write.csv(res_reg_cfp , file.path(dir_layers,'res_reg_cfp_bhi2015.csv'),row.names = FALSE)
write.csv(res_reg_cites , file.path(dir_layers,'res_reg_cites_bhi2015.csv'),row.names = FALSE)
write.csv(res_reg_hd , file.path(dir_layers,'res_reg_hd_bhi2015.csv'),row.names = FALSE)
write.csv(res_reg_helcom , file.path(dir_layers,'res_reg_helcom_bhi2015.csv'),row.names = FALSE)
write.csv(res_reg_ied , file.path(dir_layers,'res_reg_ied_bhi2015.csv'),row.names = FALSE)
write.csv(res_reg_msfd , file.path(dir_layers,'res_reg_msfd_bhi2015.csv'),row.names = FALSE)
write.csv(res_reg_mspd , file.path(dir_layers,'res_reg_mspd_bhi2015.csv'),row.names = FALSE)
write.csv(res_reg_nd , file.path(dir_layers,'res_reg_nd_bhi2015.csv'),row.names = FALSE)
write.csv(res_reg_nec , file.path(dir_layers,'res_reg_nec_bhi2015.csv'),row.names = FALSE)
write.csv(res_reg_pop , file.path(dir_layers,'res_reg_pop_bhi2015.csv'),row.names = FALSE)
write.csv(res_reg_reach , file.path(dir_layers,'res_reg_reach_bhi2015.csv'),row.names = FALSE)
write.csv(res_reg_uwwtd , file.path(dir_layers,'res_reg_uwwtd_bhi2015.csv'),row.names = FALSE)
write.csv(res_reg_wfd , file.path(dir_layers,'res_reg_wfd_bhi2015.csv'),row.names = FALSE)
write.csv(res_reg_cbd, file.path(dir_layers,'res_reg_cbd_bhi2015.csv'),row.names = FALSE)
write.csv(res_reg_cop21 , file.path(dir_layers,'res_reg_cop21_bhi2015.csv'),row.names = FALSE)
```

TO DO
-----

1.  Decide on weight and mapping
2.  Prepare final data layers (scores for country applied to BHI regions)

2. Social
---------

The [Worldwide Governance Indicators (WGI) project](http://info.worldbank.org/governance/wgi/index.aspx#home) reports aggregate and individual governance indicators for 215 economies over the period 1996–2014, for six dimensions of governance:

Voice and Accountability
Political Stability and Absence of Violence/Terrorism
Government Effectiveness
Regulatory Quality
Rule of Law
Control of Corruption

### 2.1 Data

OHI has already extracted these data by country. For BHI, we obtained these data on 13 July 2016 from [the file 'wgi\_combined\_scores\_by\_country.csv' on the OHI github site](https://github.com/OHI-Science/ohiprep/tree/master/globalprep/worldbank_wgi/intermediate).

#### 2.1.1 Data attributes

Colname names in 'wgi\_combined\_scores\_by\_country.csv' "country": reporting country "year": reporting year "score\_wgi\_scale": mean score of six indicators: Voice and Accountability Political Stability and Absence of Violence/Terrorism Government Effectiveness Regulatory Quality Rule of Law Control of Corruption "score\_ohi\_scale": score\_wgi\_scale rescaled between 0 and 1 (score\_wgi\_scale range was - 2.5 and 2.5)

### 2.2 Resilience layer

The rescaled value of the WGI score is a resilience data layer (eg. higher WGI, greater resilience).

#### 2.2.1 Current value

The value for each country in 2013

#### 2.2.2 Rescaling

The WGI scores have a range -2.5 to 2.5. They need to be rescaled to between 0 and 1. Use minimum and maximum value in the dataset. We compare the pressure layer difference if all countries are included in the dataset when selecting min and max to rescale or if only Baltic region values are used obtain min and max values to rescale.

### 2.3 Prepare Data layer

#### 2.3.1 Read in and organize data

##### 2.3.1.1 Read in data

Data are in the folder 'pressures' under 'wgi\_social/data\_database'

``` r
## read in data
wgi_global = read.csv(file.path(dir_wgi, 'data_database/wgi_combined_scores_by_country.csv'), sep=";", stringsAsFactors = FALSE)
str(wgi_global)
```

    ## 'data.frame':    3210 obs. of  4 variables:
    ##  $ country        : chr  "Afghanistan" "Afghanistan" "Afghanistan" "Afghanistan" ...
    ##  $ year           : int  1996 1998 2000 2002 2003 2004 2005 2006 2007 2008 ...
    ##  $ score_wgi_scale: num  -2.07 -2.1 -2.12 -1.75 -1.57 ...
    ##  $ score_ohi_scale: num  0.0859 0.0808 0.0753 0.1503 0.1858 ...

``` r
bhi_lookup = read.csv(file.path(dir_wgi, 'bhi_basin_country_lookup.csv'), sep=";", stringsAsFactors = FALSE) %>%
            select(BHI_ID, rgn_nam) %>%
            dplyr::rename(rgn_id=BHI_ID,
                          country=rgn_nam)
```

##### 2.3.1.2 Select Baltic Sea countries

``` r
wgi_baltic = wgi_global %>%
            filter(grepl("Denmark|Estonia|Finland|Germany|Latvia|Lithuania|Poland|Sweden|Russia",country))

wgi_baltic %>% select(country) %>% distinct()
```

    ##              country
    ## 1            Denmark
    ## 2            Estonia
    ## 3            Finland
    ## 4            Germany
    ## 5             Latvia
    ## 6          Lithuania
    ## 7             Poland
    ## 8 Russian Federation
    ## 9             Sweden

#### 2.3.2 Plot WGI scores

##### 2.3.2.1 Plot WGI scores (WGI scale)

``` r
ggplot(wgi_baltic) + 
  geom_point(aes(year, score_wgi_scale, colour = country ))+
   geom_line(aes(year, score_wgi_scale, colour = country ))+
  ylab("WGI Score")+
  ylim(-2.5,2.5)+
  ggtitle("WGI Scores (WGI scale")
```

![](resilience_prep_files/figure-markdown_github/Plot%20raw%20Baltic%20WGI%20scores-1.png)

##### 2.3.2.2 Plot WGI scores - OHI global rescale

``` r
ggplot(wgi_baltic) + 
  geom_point(aes(year, score_ohi_scale, colour = country ))+
   geom_line(aes(year, score_ohi_scale, colour = country ))+
  ylab("Score")+
  ylim(0,1)+
  ggtitle("WGI Scores (OHI global rescale")
```

![](resilience_prep_files/figure-markdown_github/Plot%20Baltic%20WGI%20ohi%20global%20rescale%20scores-1.png)

#### 2.3.3 Rescale to the Baltic region

##### 2.3.3.1 Select Min and Max

``` r
## min
baltic_min = wgi_baltic %>%
             select(score_wgi_scale)%>%
             min()%>%
             as.numeric()
baltic_min
```

    ## [1] -0.8633578

``` r
## country and year of min
filter(wgi_baltic, score_wgi_scale == baltic_min)
```

    ##              country year score_wgi_scale score_ohi_scale
    ## 1 Russian Federation 2000      -0.8633578       0.3273284

``` r
#         country year score_wgi_scale score_ohi_scale
# Russian Federation 2000      -0.8633578       0.3273284


##max
baltic_max = wgi_baltic %>%
             select(score_wgi_scale)%>%
             max()%>%
             as.numeric()

## country and year of max
filter(wgi_baltic, score_wgi_scale == baltic_max)
```

    ##   country year score_wgi_scale score_ohi_scale
    ## 1 Finland 2004        1.985394       0.8970788

``` r
# country year score_wgi_scale score_ohi_scale
#Finland 2004        1.985394       0.8970788
```

##### 2.3.3.2 Rescale Baltic

``` r
wgi_baltic = wgi_baltic %>%
             mutate(min = baltic_min,
                    max=baltic_max,
             score_bhi_scale = (score_wgi_scale - baltic_min)/(baltic_max - baltic_min))%>%
             select(-min,-max)
```

##### 2.3.3.3 Plot rescaled to Baltic Region

``` r
ggplot(wgi_baltic) + 
  geom_point(aes(year, score_bhi_scale, colour = country ))+
   geom_line(aes(year, score_bhi_scale, colour = country ))+
  ylab("Score")+
  ylim(0,1)+
  ggtitle("WGI Scores (BHI region rescale")
```

![](resilience_prep_files/figure-markdown_github/plot%20rescaled%20to%20baltic-1.png)

##### 2.3.3.4 Plot and Compare Rescaling options

Using the BHI region rescaling penalizes Russia. Does also spread the scores somewhat.

``` r
ggplot(gather(wgi_baltic, score_type, score, -country,-year) %>% filter(score_type != "score_wgi_scale")) + 
  geom_point(aes(year, score, colour = country ))+
   geom_line(aes(year, score, colour = country ))+
  facet_wrap(~score_type)+
  ylab("Score")+
  ylim(0,1)+
  ggtitle("Rescale comparison WGI Scores")
```

![](resilience_prep_files/figure-markdown_github/Plot%20and%20Compare%20Rescaling%20options-1.png)

#### 2.3.4 Assign country scores to BHI regions

##### 2.3.4.1 Join BHI region lookup to country scores

``` r
wgi_rgn = wgi_baltic %>%
          select(-score_wgi_scale)%>%
          gather(., score_type, resilience_score, -country,-year)%>%
          mutate(country = ifelse(country == "Russian Federation", "Russia", country))%>%
          full_join(., bhi_lookup, by = "country")
```

#### 2.3.5 Prepare and save Objects

Select global rescaling so that Russia is not so heavily penalized.

##### 2.3.5.1 Prepare object

``` r
wgi_all = wgi_rgn %>%
         filter(score_type == "score_ohi_scale")%>%
         select(-score_type, -country)%>%
         group_by(rgn_id) %>%
         filter(year == max(year))%>%
         ungroup() %>%
         select(rgn_id, year, resilience_score) %>%
         arrange(rgn_id)

wgi_all = wgi_all %>%
        select(-year)
```

#### 5.2 Save object

``` r
write.csv(wgi_all, file.path(dir_layers, 'wgi_all_bhi2015.csv'), row.names=FALSE)
```
