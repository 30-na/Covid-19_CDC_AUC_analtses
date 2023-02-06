library(pROC)
library(ggplot2)
library(data.table)
library(dplyr)
library(tidyr)

# list of files for each week
files_list = list.files("ProcessedData", pattern = "rbind_data_week.*.RDA")
# make empty data frame
colNames = c("week", "hospital_admission", "inpatient_bed", "comparison")
auc_data = data.frame(matrix(nrow=0, ncol=length(colNames)))
colnames(auc_data) = colNames

# load CDC community level by county
community_level_county_file = fread("rawData/United_States_COVID-19_Community_Levels_by_County.csv")
community_lvl_data = community_level_county_file %>%
    mutate(date_updated = as.Date(date_updated, format="%Y/%m/%d"))


weekdays = sort(unique(community_lvl_data$date_updated))
weekIndex = seq(1, length(weekdays)-3, by=3)
weekDates = weekdays[weekIndex]

for(i in 1:length(files_list)){
    load(paste("ProcessedData/", files_list[i], sep=""))
    
    # add expected values and actual hospitalization and inpatient bed
    predict_data = rbind_data_week %>%
        mutate(predict_severe_outcome = ifelse(target_community_level > compared_community_level, 1, 0),
               actual_severe_hospital_admission = ifelse(target_next_3week_hospital_admission > compared_next_3week_hospital_admission, 1, 0),
               actual_severe_inpatient_bed = ifelse(target_next_3week_inpatient_bed > compared_next_3week_inpatient_bed, 1, 0))
    
    # calculate AUC for hospitalization
    
    #open jpg file
    jpeg(paste("Figures/auc_", weekDates[i] , ".jpg", sep=""), width = 1000, height = 1000, res=180)
    par(pty = "s")
    AUC_hospital = roc(predict_data$predict_severe_outcome,
                       predict_data$actual_severe_hospital_admission,
                       plot=TRUE,
                       legacy.axes=TRUE,
                       percent=TRUE,
                       #xlab="False Positive Percentage",
                       #ylab="True Positive Percentage",
                       col="#377eb8",
                       lwd=4,
                       print.auc=TRUE,
                       main=paste("ROC Curves Week ", i, sep=""))
    
    # calculate AUC for inpatient bed
    AUC_inpatient = roc(predict_data$predict_severe_outcome,
                        predict_data$actual_severe_inpatient_bed,
                        plot=TRUE,
                        legacy.axes=TRUE,
                        percent=TRUE,
                        col="#4daf4a",
                        lwd=4,
                        print.auc=TRUE,
                        print.auc.y=41,
                        add=TRUE)
    
    # add Auc to dataFrame
    auc_data[nrow(auc_data) + 1, ] = c(i,
                                       as.numeric(AUC_hospital$auc),
                                       as.numeric(AUC_inpatient$auc),
                                       nrow(predict_data))
    
    
    # save figures
    legend("bottomright",legend=c("Hospital Admissions","Inpatient Bed"),col=c("#377eb8", "#4daf4a"),lwd=4)
    # 3. Close the file
    dev.off()
    
}



auc_ggplot_data = auc_data %>%
    mutate(date = weekDates) %>%
    select(date,
           inpatient_bed,
           hospital_admission) %>%
    tidyr::pivot_longer(cols = c(hospital_admission, inpatient_bed),
                        names_to = "predictor",
                        values_to = "AUROC")
    


# plot to show AUC performance in time
fig_auc_performance = ggplot(data = auc_ggplot_data,
                                    aes(x = date,
                                        y = AUROC,
                                        col = predictor,
                                        group_by = F)) + 
    geom_point() +
    labs(title = "AUROC analyses for CDC Community level in 3 weeks later",
         x = "Date",
         y = "AUROC") +
    theme_classic() +
    geom_line(alpha = .5)+
    scale_x_date(date_breaks = "6 week")

ggsave("Figures/fig_auc_performance.jpg",
       fig_auc_performance, 
       height=4,width=8,scale=1.65)


# # County-level Area Under Receiver Operating Characteristic (AUROC) analyses
# # for predictors in columns and outcomes in rows 3 weeks later 
# table2 = data.frame("Community Level Threshold" = c("Low admissions, low inpatient beds, cases 200/100K",
#                                                     "Low admissions, low inpatient beds, cases 500/100K",
#                                                     "Low admissions, high inpatient beds, cases 200/100K",
#                                                     "High admissions, high inpatient beds, cases 200/100K",
#                                                     "High admissions, high inpatient beds, cases 500/100K",
#                                                     "High admissions, high inpatient beds, no cases"),
#                     "Hospital Admissions" = c(1,1,1,1,1,1),
#                     "Inpatient Beds" = c(0,0,0,0,0,0))
# 
# flextable::flextable(table2, cwidth = c(2,0.5,0.5))
