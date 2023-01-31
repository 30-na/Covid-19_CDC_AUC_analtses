# load library
library(dplyr)
library(tidyr)
library(usdata)
library(data.table)
library(pROC)
library(ggplot2)
library(plotROC)

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

i = 1
weekdays = sort(unique(community_lvl_data$date_updated))

target_counties_list = unique(dplyr::filter(community_lvl_data, date_updated == weekdays[i])$stateFips)

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
predict_data = data.frame(matrix(nrow = 0, ncol=length(columnNames)))
colnames(predict_data) = columnNames

names(community_lvl_data)
for(j in 1:length(target_counties_list)){
    target_county = community_lvl_data %>%
        filter(date_updated == weekdays[i],
               stateFips == target_counties_list[j]) %>%
        select(target_stateFips = stateFips,
               target_community_level = community_level,
               target_covid_inpatient_bed_utilization = covid_inpatient_bed_utilization,
               target_covid_hospital_admissions_per_100k = covid_hospital_admissions_per_100k,
               target_covid_cases_per_100k = covid_cases_per_100k,
               target_next_3week_hospital_admission = next_3week_hospital_admission,
               target_next_3week_inpatient_bed = next_3week_inpatient_bed)
    
    
    compared_counties = community_lvl_data %>%
        filter(date_updated == weekdays[i],
               community_level != target_county$target_community_level) %>%
        select(compared_stateFips = stateFips,
               compared_community_level = community_level,
               #compared_covid_inpatient_bed_utilization = covid_inpatient_bed_utilization,
               #compared_covid_hospital_admissions_per_100k = covid_hospital_admissions_per_100k,
               compared_next_3week_hospital_admission = next_3week_hospital_admission,
               compared_next_3week_inpatient_bed = next_3week_inpatient_bed)
    
    data = target_county %>%
        cbind(compared_counties) %>%
        mutate(predict_severe_outcome = ifelse(target_community_level > compared_community_level, 1, 0),
               actual_severe_hospital_admission = ifelse(target_next_3week_hospital_admission > compared_next_3week_hospital_admission, 1, 0),
               actual_severe_inpatient_bed = ifelse(target_next_3week_inpatient_bed > compared_next_3week_inpatient_bed, 1, 0))
    predict_data = rbind(predict_data, data)
    print(j)
    
}
save(predict_data, file="ProcessedData/predict_data.RDA")
library(pROC)
par(pty = "s")
roc(predict_data$predict_severe_outcome,
    predict_data$actual_severe_hospital_admission,
    plot=TRUE,
    legacy.axes=TRUE,
    percent=TRUE,
    #xlab="False Positive Percentage",
    #ylab="True Postive Percentage",
    col="#377eb8",
    lwd=4,
    print.auc=TRUE)


roc(predict_data$predict_severe_outcome,
         predict_data$actual_severe_inpatient_bed,
         plot=TRUE,
         col="#4daf4a",
         lwd=4,
         print.auc=TRUE)
legend("bottomright", legend=c("Hospital Admission", "Impatient Bed"), col=c("#377eb8", "#4daf4a"), lwd=4)

a = predict_data %>%
    mutate(community_level_threshold = case_when())
mean(a$check, na.rm = T)
?roc
