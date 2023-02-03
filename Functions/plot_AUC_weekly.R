library(pROC)
library(ggplot2)
library(plotROC)
library(flextable)
library(usdata)


predict_data = rbind_data_week %>%
    mutate(predict_severe_outcome = ifelse(target_community_level > compared_community_level, 1, 0),
           actual_severe_hospital_admission = ifelse(target_next_3week_hospital_admission > compared_next_3week_hospital_admission, 1, 0),
           actual_severe_inpatient_bed = ifelse(target_next_3week_inpatient_bed > compared_next_3week_inpatient_bed, 1, 0))


load(file="ProcessedData/predict_data_week1.RDA")
save(rbind_data, file="ProcessedData/rbind_data.RDA")


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
    legacy.axes=TRUE,
    percent=TRUE,
    #xlab="False Positive Percentage",
    #ylab="True Postive Percentage",
    col="#4daf4a",
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




# County-level Area Under Receiver Operating Characteristic (AUROC) analyses
# for predictors in columns and outcomes in rows 3 weeks later 
table2 = data.frame("Community Level Threshold" = c("Low admissions, low inpatient beds, cases 200/100K",
                                                    "Low admissions, low inpatient beds, cases 500/100K",
                                                    "Low admissions, high inpatient beds, cases 200/100K",
                                                    "High admissions, high inpatient beds, cases 200/100K",
                                                    "High admissions, high inpatient beds, cases 500/100K",
                                                    "High admissions, high inpatient beds, no cases"),
                    "Hospital Admissions" = c(1,1,1,1,1,1),
                    "Inpatient Beds" = c(0,0,0,0,0,0))

flextable::flextable(table2, cwidth = c(2,0.5,0.5))


a = rbind_data_week %>%
    group_by_all() %>%
    filter(n()>1) %>%
    ungroup()
