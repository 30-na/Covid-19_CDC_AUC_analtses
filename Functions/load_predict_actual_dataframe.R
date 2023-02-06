# load library
library(dplyr)
library(tidyr)
library(data.table)


# load CDC community level by county
community_level_county_file = fread("rawData/United_States_COVID-19_Community_Levels_by_County.csv")
    
community_lvl_data = community_level_county_file %>%
    rename("community_level" = "covid-19_community_level") %>%
    mutate(community_level = tolower(community_level),
           community_level = case_when(community_level == "low"  ~ 1,
                                       community_level == "medium"  ~ 2,
                                       community_level == "high"  ~ 3),
           date_updated = as.Date(date_updated, format="%Y/%m/%d"),
           stateFips = paste(state, county_fips, sep = ",")) %>%
    group_by(stateFips) %>%
    arrange(state,
            county) %>%
    mutate(next_3week_hospital_admission = lead(x = covid_hospital_admissions_per_100k, n = 3L),
           next_3week_inpatient_bed = lead(x = covid_inpatient_bed_utilization, n = 3L))
    


# compare each county with others in different community level

# make and empty data Frame
columnNames = c("target_stateFips",
                "target_community_level",
                "target_covid_inpatient_bed_utilization",  
                "target_covid_hospital_admissions_per_100k",
                "target_covid_cases_per_100k",
                "target_next_3week_hospital_admission",
                "target_next_3week_inpatient_bed",
                "compared_stateFips",
                "compared_community_level",              
                "compared_next_3week_hospital_admission",
                "compared_next_3week_inpatient_bed",
                "predict_severe_outcome",                
                "actual_severe_hospital_admission",
                "actual_severe_inpatient_bed")


rbind_data = data.frame(matrix(nrow = 0, ncol=length(columnNames)))
colnames(rbind_data) = columnNames 

weekdays = sort(unique(community_lvl_data$date_updated))
weekIndex = seq(1, length(weekdays)-3, by=3)
for(i in weekIndex){
    
    week_i_Data = dplyr::filter(community_lvl_data,
                                date_updated == weekdays[i])
    
    rbind_data_week = data.frame(matrix(nrow = 0, ncol=length(columnNames)))
    colnames(rbind_data_week) = columnNames
    
    target_counties_list = week_i_Data$stateFips
    target_counties_size = length(target_counties_list)
    
    for(j in 1:target_counties_size){
        target_county = week_i_Data %>%
            dplyr::filter(stateFips == target_counties_list[j]) %>%
            select(date = date_updated,
                   target_stateFips = stateFips,
                   target_community_level = community_level,
                   target_covid_inpatient_bed_utilization = covid_inpatient_bed_utilization,
                   target_covid_hospital_admissions_per_100k = covid_hospital_admissions_per_100k,
                   target_covid_cases_per_100k = covid_cases_per_100k,
                   target_next_3week_hospital_admission = next_3week_hospital_admission,
                   target_next_3week_inpatient_bed = next_3week_inpatient_bed)
       
        
        compared_counties = week_i_Data[j:target_counties_size,] %>%
            dplyr::filter(community_level != target_county$target_community_level) %>%
            select(compared_stateFips = stateFips,
                   compared_community_level = community_level,
                   #compared_covid_inpatient_bed_utilization = covid_inpatient_bed_utilization,
                   #compared_covid_hospital_admissions_per_100k = covid_hospital_admissions_per_100k,
                   compared_next_3week_hospital_admission = next_3week_hospital_admission,
                   compared_next_3week_inpatient_bed = next_3week_inpatient_bed)
        
        cbind_data = cbind(target_county, compared_counties)
        
        
        rbind_data_week = rbind(rbind_data_week, cbind_data)
        print(paste(i, j, sep=", "))

                     
    }
    
    save(rbind_data_week, file=paste("ProcessedData/rbind_data_week", i, ".RDA", sep=""))
    print(paste("file week" , i,  " saved !!!"))
}
