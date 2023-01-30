# Compute the community risk level base on CDC indicator and Thresholds



CalculateCommunityLevel = function(covid_cases_per_100k,
                                      covid_hospital_admissions_per_100k,
                                      covid_inpatient_bed_utilization){

low_index = 
    (covid_cases_per_100k < 200 & 
         covid_hospital_admissions_per_100k < 10) | 
    
    (covid_cases_per_100k < 200 &
         covid_inpatient_bed_utilization < 10)


medium_index = 
    (covid_cases_per_100k < 200 &
         (covid_hospital_admissions_per_100k >= 10 &
              covid_hospital_admissions_per_100k < 20)) |
    
    (covid_cases_per_100k < 200 &
         (covid_inpatient_bed_utilization >= 10 &
              covid_inpatient_bed_utilization < 15)) |
    
    (covid_cases_per_100k >= 200 &
         covid_hospital_admissions_per_100k < 10) |
    
    (covid_cases_per_100k >= 200 &
         covid_inpatient_bed_utilization < 10)

high_index = 
    (covid_cases_per_100k < 200 & 
         covid_hospital_admissions_per_100k >= 20) | 
    
    (covid_cases_per_100k < 200 & 
         covid_inpatient_bed_utilization >= 15) |
    
    (covid_cases_per_100k >= 200 & 
         covid_hospital_admissions_per_100k >= 10) | 
    
    (covid_cases_per_100k >= 200 & 
         covid_inpatient_bed_utilization >= 10) 
#print(low_index)
#print(medium_index)
#print(high_index)

community_level = NA
community_level[low_index] = "low"
community_level[medium_index] = "medium"
community_level[high_index] = "high"

return(community_level)
}
