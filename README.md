# Covid-19_CDC_AUC_analyses

## COVID-19 community transmission  
Community Transmission refers to measures of the presence and spread of SARS-CoV-2, the virus that causes COVID-19.

### COVID-19 transmission levels Indicators:    
1. New cases per 100,000 persons in the past 7 days.   
2. Percentage of positive NAATs tests during the past 7 days.  

### COVID-19 transmission Levels:
* low 
* Moderate
* Substantial
* high


## COVID-19 Community Levels  
Measures of the impact of COVID-19 in terms of hospitalizations and healthcare system strain  
### COVID-19 Community Level Indicators:
1. New COVID-19 hospital admissions per 100,000 population in the last 7 days.  
* *Numerator:* the total number of patients admitted with laboratory-confirmed COVID-19 to an adult or pediatric inpatient bed each day during the previous 7 days for the specified geographic locality.
* *Denominator:* total U.S. Census population for the specified geographic locality (based on 2019 Census population estimates).
* *Missing data:* if there are no data reported for a locality for the given 7-day window, the indicator reported is “N/A.”
2. Percent of staffed inpatient beds occupied by patients with confirmed COVID-19 (7-day average).   
* *Numerator:* the average number of adult and pediatric patients hospitalized with laboratory-confirmed COVID-19 each day during the previous 7 days for the specified geographic locality, calculated as the average of valid values within the 7-day period (e.g., if only three valid values, the average of those three is taken).
* *Denominator:* the average number of staffed inpatient beds during the previous 7 days for the specified geographic locality, calculated as the average of valid values within the 7-day period (e.g., if only three valid values, the average of those three is taken). Per UHDSS reporting guidance, staffed inpatient beds in a facility are defined as those that are currently set up, staffed, and able to be used for a patient within the reporting period. This includes all overflow, observation, and active surge/expansion beds used for inpatients, ICU beds, surge/hallway/overflow beds that are open for use for a patient, regardless of whether they are occupied or available.
* *Missing data:* if there are no data in the locality for the given 7-day window, the indicator reported is “N/A.”
3. new COVID-19 cases per 100,000 population in the last 7 days.

#### Other potential Indicators:
* death rates
* Syndromic surveillance, based on the percent of emergency department visits due to COVID-19
* Wastewater surveillance
* Percent of ICU beds occupied with COVID-19 patients
* New COVID-19 hospital admissions with confirmed COVID-19 per 100 staffed beds
* Test positivity
* new hospital admissions

### COVID-19 Community Levels:
* low 
* medium 
* high


### Performance of community transmission levels and COVID-19 Community Levels
* (AUROC) analyses: Area Under Receiver Operating Characteristic.  
the probability that given two randomly selected observations from different levels, the one with the more severe outcome comes from a higher transmission or higher COVID-19 Community Level. A score of 0.50 would correspond to random chance and a score of 1 would indicate that worse outcomes always correspond to a higher transmission or higher COVID-19 Community Level. AUROC values reflect the likelihood that for two counties with different levels, the county with the higher severity has the most severe outcome 3 weeks later.
* 
-----------------------

Datasets:  
1. [United States COVID-19 Community Levels by County](https://data.cdc.gov/Public-Health-Surveillance/United-States-COVID-19-Community-Levels-by-County/3nnm-4jni)


-----------------------

Sources:  

1. [Science Brief: Indicators for Monitoring COVID-19 Community Levels and Making Public Health Recommendations](https://www.cdc.gov/coronavirus/2019-ncov/science/science-briefs/indicators-monitoring-community-levels.html)  

2. [National and Subnational estimates for the United States of America](https://epiforecasts.io/covid/posts/national/united-states/)
  

