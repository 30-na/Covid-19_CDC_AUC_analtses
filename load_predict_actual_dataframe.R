# load library
library(dplyr)
library(tidyr)
library(usdata)
library(data.table)


# load CDC community level by county
community.level.county.file = fread("rawData/United_States_COVID-19_Community_Levels_by_County.csv")
names(community.level.county.file)
    
community.lvl = community.level.county.file %>%
    rename("community_level" = "covid-19_community_level") %>%
    mutate(community_level = tolower(community_level),
           date_updated = as.Date(date_updated, format="%Y/%m/%d"),
           stateFips = paste(state, county_fips, sep = ",")) %>%
    group_by(stateFips) %>%
    arrange(state,
            county) %>%
    mutate(next_3week_hospital_admission = lead(x = covid_hospital_admissions_per_100k, n = 3L),
           next_3week_inpatient_bed = lead(x = covid_inpatient_bed_utilization, n = 3L))
    

names(community.lvl)    
# compare each county with others in different community level

i = 1
j = 1
weekdays = sort(unique(community.lvl$date_updated))

counties.list = unique(dplyr::filter(community.lvl, date_updated == weekdays[i])$stateFips)

target.CL = dplyr::filter(community.lvl, date_updated == weekdays[i] &
                              stateFips == counties.list[j])$community_level

target.hospital.admission = dplyr::filter(community.lvl, date_updated == weekdays[i] &
                              stateFips == counties.list[j])$covid_hospital_admissions_per_100k

target.inpatient.bed = dplyr::filter(community.lvl, date_updated == weekdays[i] &
                              stateFips == counties.list[j])$covid_inpatient_bed_utilization

target.next3week.hospital.admission = dplyr::filter(community.lvl, date_updated == weekdays[i] &
                              stateFips == counties.list[j])$next_3week_hospital_admission

target.next3week.inpatient.bed = dplyr::filter(community.lvl, date_updated == weekdays[i] &
                              stateFips == counties.list[j])$next_3week_inpatient_bed

camparable.counties.list = unique(dplyr::filter(community.lvl, date_updated == weekdays[i] &
                                                    community_level != target.CL)$stateFips)
    

data = data.frame(date = weekdays[i],
                  county = counties.list[j],
                  community.level = target.CL,
                  hospital.admission = target.hospital.admission,
                  inpatient.bed = target.inpatient.bed,
                  next3week.hospital.admission = target.next3week.hospital.admission,
                  next3week.inpatient.bed = target.next3week.inpatient.bed)






  
#weekdays = unique(community.lvl$date_updated)  
weekdays = c("2022-08-11")

# date loop
for(i in 1:length(weekdays)){
}

CL.week = community.lvl %>%
    filter(date_updated == "2022-08-11")


# get the list of all counties with different community level that should be compared
getComparableCountiesList = function(data, target.county){
    # get the target county community level
    county.CL = dplyr::filter(data = data, stateFips == target.county)$community_level
        
    # filter the counties that have different comunity level
    df = df %>%
        filter(community_level != county.CL)
    
    comparable.counties.list = unique(df$stateFips)
    return(comparable.counties.list)
}




target.county = CL.week$stateFips[1]

comparable.counties.list = getComparableCountiesList(CL.target.week = CL.week,
                                                     target.county = target.county)

CL.week = community.lvl %>%
    filter(date_updated == weekdays[i])


community_level_stateFips = community_level_LMH %>%
    mutate(stateFips = paste(state, fips_code, sep = ","))

stateFips.list = unique(CL.week$stateFips)
stateFips.list = unique(CL.week$stateFips)

# full list of counties and dates
full_county_date = data.frame(stateFips = rep(stateFips_list, each = length(days)),
                              date = rep(days, times = length(stateFips_list)))

    
