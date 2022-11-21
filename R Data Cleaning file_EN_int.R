rm(list=ls())
#install.packages("openxlsx", dependencies = TRUE)
#install.packages('Rcpp')
library(Rcpp)
library(dplyr)
library(openxlsx)
setwd("C:/Users/jimmy/Desktop/Survey Data/Data prepared for interaction terms")
data = read.csv("results-survey259534-EN-true.csv", header = TRUE, sep = ",", quote = "\"",
         dec = ".", fill = TRUE, comment.char = "")
data = as_tibble(data)
data[data == "I don't remember"] <- NA
data[data == "I don't know"] <- NA
data <- data %>% mutate_all(na_if,"")

# Rename column 
names(data)[names(data) == "ï..ID.de.la.rÃ.ponse"] <- "id"
names(data)[names(data) == "What.is.your.current.year.of.study.Â."] <- "year"
names(data)[names(data) == "Do.you.prefer.college.or.high.school.."] <- "school_pref"
names(data)[names(data) == "In.which.country.did.you.complete.high.school.."] <- "hs_country"
names(data)[names(data) == "What.was.your.average.grade.upon.Switzerland.high.school.completion..Â...Average.grade."] <- "hs_ch_ag"
names(data)[names(data) == "What.was.your.average.grade.upon.France.high.school.completion..Â...Average.grade."] <- "hs_fr_ag"
names(data)[names(data) == "What.was.your.average.grade.upon.high.school.completion...Please.write.it.with.the.highest.possible.grade..e.g..3.4.4.or.7.2.10.etc.Â.Â...If.you.don.t.know.or.don.t.remember..please.write.it.in.the.box.."] <- "hs_country_ag"
names(data)[names(data) == "What.was.your.average.grade.for.the.first.year.at.the.University....Â...Â....Average.grade.for.first.year."] <- "first_year_ag"
names(data)[names(data) == "What.was.your.average.grade.for.the.mandatory.common.courses.of.second.year....Mandatory.common.courses.of.second.year.are.Statistics..Business.and.Society..Corporate.Finance..Introduction.au.Marketing.andÂ.Introduction.to.Econometrics...If.you.re.a.second.year.student..please.ignore.Introduction.to.Econometrics.for.the.average.grade..as.it.is.a.course.you.haven.t.passed.yet...Â...Â....Average.grade.of.mandatory.common.classes.in.second.year."] <- "second_year_ag"
names(data)[names(data) == "What.was.the.average.grade.of.the.exams.you.just.passed..Â...Â....Average.grade.of.the.classes.you.ve.taken.that.semester."] <- "third_year_ag"
names(data)[names(data) == "How.would.you.estimate.the.quality.of.learning..quality.of.teaching.and.your.personal.well.being.during.that.period.....Quality.of.learningÂ.."] <- "FLD_quality_learning"
names(data)[names(data) == "How.would.you.estimate.the.quality.of.learning..quality.of.teaching.and.your.personal.well.being.during.that.period.....Quality.of.teachingÂ.."] <- "FLD_quality_teaching"
names(data)[names(data) == "How.would.you.estimate.the.quality.of.learning..quality.of.teaching.and.your.personal.well.being.during.that.period.....Well.being."] <- "FLD_wellbeing"
names(data)[names(data) == "How.would.you.estimate.the.time.you.spent.studying.compared.to.a.normal.situation.."] <- "FLD_study_time"
names(data)[names(data) == "How.was.your.Internet.connection.for.attending.Zoom.classes..watching.recordings..working.as.a.group.for.projects.through.Zoom.etc.....Â.."] <- "FLD_internet"
names(data)[names(data) == "Did.you.have.a.separate.room.for.studying.."] <- "FLD_separate_room"
names(data)[names(data) == "Did.you.feel.more.anxiety.during.the.full.lockdown.compared.to.a.normal.situation.."] <- "FLD_more_anxiety"
names(data)[names(data) == "Did.you.feel.specific.anxiety.regarding.using.Zoom.."] <- "FLD_zoom_anxiety"
names(data)[names(data) == "During.that.period..what.would.be.your.frequency.of.attendance.to.lectures.and.seminars.held.on.Zoom.."] <- "FLD_zoom_attendance_freq"
names(data)[names(data) == "During.that.period..what.would.be.your.frequency.of.watching.recordings.of.lectures.and.seminars.....Here.100..would.mean.that.for.each.lecture.and.seminar..you.would.always.watch.the.corresponding.recording.when.available.."] <- "FLD_recording_freq"
names(data)[names(data) == "How.would.you.estimate.the.quality.of.learning..quality.of.teaching.and.your.personal.well.being.during.that.period.....Quality.of.learningÂ...1"] <- "PLD_quality_learning"
names(data)[names(data) == "How.would.you.estimate.the.quality.of.learning..quality.of.teaching.and.your.personal.well.being.during.that.period.....Quality.of.teachingÂ...1"] <- "PLD_quality_teaching"
names(data)[names(data) == "How.would.you.estimate.the.quality.of.learning..quality.of.teaching.and.your.personal.well.being.during.that.period.....Well.being..1"] <- "PLD_wellbeing"
names(data)[names(data) == "How.would.you.estimate.the.time.you.spent.studying.compared.to.a.normal.situation...1"] <- "PLD_study_time"
names(data)[names(data) == "Did.you.feel.more.anxiety.during.the.partial.lockdown.compared.to.a.normal.situation.."] <- "PLD_more_anxiety"
names(data)[names(data) == "During.that.period..what.would.be.your.frequency.of.attendance.to.lectures.and.seminars.."] <- "PLD_attendance_freq"
names(data)[names(data) == "During.that.period..what.would.be.your.frequency.of.watching.recordings.of.lectures.and.seminars.....Here.100..would.mean.that.for.each.lecture.and.seminar..you.would.always.watch.the.corresponding.recording.when.available...1"] <- "PLD_recording_freq"

#Replace variables with appropriate numbers
#data$year <-  as.character(data$year)
#data$year[data$year == "Third year"] <- "3"

#Create third year dummy. = 0 if second year. 
data$third_year <- "0" #add column and create values 0 
data$third_year <-  as.character(data$third_year)
data$third_year[data$year == "Third year"] <- "1"
data <- subset(data, select=-c(year)) #delete the column year, no longer relevant as we have dummies now.

#College pref dummy and HS pref dummy.
data$college_pref <- "0" 
data$college_pref <-  as.character(data$college_pref)
data$college_pref[data$school_pref == "College"] <- "1"

data$hs_pref <- "0" 
data$hs_pref <-  as.character(data$hs_pref)
data$hs_pref[data$school_pref == "High school"] <- "1"
data <- subset(data, select=-c(school_pref))

#Create a single variable for Hs average grade. Transform interval of HS grades into plain numbers (10- 11.99 becomes 1, 12-13.99 becomes 2 etc.)
data$hs_ag <- NA 
data$hs_ag <-  as.character(data$hs_ag)
data$hs_ag[data$hs_ch_ag == "4 - 4.49"] <- "1"
data$hs_ag[data$hs_ch_ag == "4.5 - 4.99"] <- "2"
data$hs_ag[data$hs_ch_ag == "5 - 5.49"] <- "3"
data$hs_ag[data$hs_ch_ag == "5.5 - 6"] <- "4"
data$hs_ag[data$hs_fr_ag == "10 - 11.99"] <- "1"
data$hs_ag[data$hs_fr_ag == "12 - 13.99"] <- "2"
data$hs_ag[data$hs_fr_ag == "14 - 15.99"] <- "3"
data$hs_ag[data$hs_fr_ag == "16 - 20"] <- "4"
data <- subset(data, select=-c(hs_ch_ag, hs_fr_ag, hs_country_ag))

#Convert values for university average grades (interval -> numbers) 
data$first_year_ag <-  as.character(data$first_year_ag)
data$second_year_ag <-  as.character(data$second_year_ag)
data$third_year_ag <-  as.character(data$third_year_ag)
data$first_year_ag[data$first_year_ag == "4 - 4.49"] <- "1"
data$first_year_ag[data$first_year_ag == "4.5 - 4.99"] <- "2"
data$first_year_ag[data$first_year_ag == "5 - 5.49"] <- "3"
data$first_year_ag[data$first_year_ag == "5.5 - 6"] <- "4"

data$second_year_ag[data$second_year_ag == "< 4"] <- "0"
data$second_year_ag[data$second_year_ag == "4 - 4.49"] <- "1"
data$second_year_ag[data$second_year_ag == "4.5 - 4.99"] <- "2"
data$second_year_ag[data$second_year_ag == "5 - 5.49"] <- "3"
data$second_year_ag[data$second_year_ag == "5.5 - 6"] <- "4"

data$third_year_ag[data$third_year_ag == "< 4"] <- "0"
data$third_year_ag[data$third_year_ag == "4 - 4.49"] <- "1"
data$third_year_ag[data$third_year_ag == "4.5 - 4.99"] <- "2"
data$third_year_ag[data$third_year_ag == "5 - 5.49"] <- "3"
data$third_year_ag[data$third_year_ag == "5.5 - 6"] <- "4"

#Create FLD_ag and PLD_ag...
data$FLD_ag <- NA
data$PLD_ag <- NA
data$FLD_ag <- ifelse(is.na(data$FLD_ag) & data$third_year == 0, data$first_year_ag, data$FLD_ag)
data$PLD_ag <- ifelse(is.na(data$PLD_ag) & data$third_year == 0, data$second_year_ag, data$PLD_ag)

data$FLD_ag <- ifelse(is.na(data$FLD_ag) & data$third_year == 1, data$second_year_ag, data$FLD_ag)
data$PLD_ag <- ifelse(is.na(data$PLD_ag) & data$third_year == 1, data$third_year_ag, data$PLD_ag)
data <- subset(data, select=-c(first_year_ag, second_year_ag, third_year_ag))

#Remove the parenthesis details for quality_learning, quality_teaching_ wellbeing.
data$FLD_quality_learning <-  as.character(data$FLD_quality_learning)
data$FLD_quality_teaching <-  as.character(data$FLD_quality_teaching)
data$FLD_wellbeing <-  as.character(data$FLD_wellbeing)

data$FLD_quality_learning[data$FLD_quality_learning == "0 (No difference compared to normal)"] <- "0"
data$FLD_quality_learning[data$FLD_quality_learning == "-5 (Way worse than normal)"] <- "-5"
data$FLD_quality_learning[data$FLD_quality_learning == "5 (Way better than normal)"] <- "5"

data$FLD_quality_teaching[data$FLD_quality_teaching == "0 (No difference compared to normal)"] <- "0"
data$FLD_quality_teaching[data$FLD_quality_teaching == "-5 (Way worse than normal)"] <- "-5"
data$FLD_quality_teaching[data$FLD_quality_teaching == "5 (Way better than normal)"] <- "5"

data$FLD_wellbeing[data$FLD_wellbeing == "0 (No difference compared to normal)"] <- "0"
data$FLD_wellbeing[data$FLD_wellbeing == "-5 (Way worse than normal)"] <- "-5"
data$FLD_wellbeing[data$FLD_wellbeing == "5 (Way better than normal)"] <- "5"

#change FLD study time into 2 dummies.
data$FLD_study_more <- "0" 
data$FLD_study_less <- "0" 

data$FLD_study_more[data$FLD_study_time == "More time studying"] <- "1"
data$FLD_study_less[data$FLD_study_time == "Less time studying"] <- "1"
data <- subset(data, select=-c(FLD_study_time))

#change internet into 1 dummy (either internet is good or not ; in-between makes less sense)
data$FLD_bad_internet <- "0" 

data$FLD_bad_internet[data$FLD_internet == "Bad and unstable internet"] <- "1"
data <- subset(data, select=-c(FLD_internet))

#conversion
data$FLD_separate_room[data$FLD_separate_room == "Yes"] <- "1"
data$FLD_separate_room[data$FLD_separate_room == "No"] <- "0"

data$FLD_more_anxiety[data$FLD_more_anxiety == "Yes"] <- "1"
data$FLD_more_anxiety[data$FLD_more_anxiety == "No"] <- "0"

data$FLD_zoom_anxiety[data$FLD_zoom_anxiety == "Yes"] <- "1"
data$FLD_zoom_anxiety[data$FLD_zoom_anxiety == "No"] <- "0"

#fld frequency
data$FLD_zoom_attendance_freq[data$FLD_zoom_attendance_freq == "0-25%"] <- "1"
data$FLD_zoom_attendance_freq[data$FLD_zoom_attendance_freq == "26-50%"] <- "2"
data$FLD_zoom_attendance_freq[data$FLD_zoom_attendance_freq == "51-75%"] <- "3"
data$FLD_zoom_attendance_freq[data$FLD_zoom_attendance_freq == "76-100%"] <- "4"

data$FLD_recording_freq[data$FLD_recording_freq == "0-25%"] <- "1"
data$FLD_recording_freq[data$FLD_recording_freq == "26-50%"] <- "2"
data$FLD_recording_freq[data$FLD_recording_freq == "51-75%"] <- "3"
data$FLD_recording_freq[data$FLD_recording_freq == "76-100%"] <- "4"

#you know the gist
data$PLD_quality_learning[data$PLD_quality_learning == "0 (No difference compared to normal)"] <- "0"
data$PLD_quality_learning[data$PLD_quality_learning == "-5 (Way worse than normal)"] <- "-5"
data$PLD_quality_learning[data$PLD_quality_learning == "5 (Way better than normal)"] <- "5"

data$PLD_quality_teaching[data$PLD_quality_teaching == "0 (No difference compared to normal)"] <- "0"
data$PLD_quality_teaching[data$PLD_quality_teaching == "-5 (Way worse than normal)"] <- "-5"
data$PLD_quality_teaching[data$PLD_quality_teaching == "5 (Way better than normal)"] <- "5"

data$PLD_wellbeing[data$PLD_wellbeing == "0 (No difference compared to normal)"] <- "0"
data$PLD_wellbeing[data$PLD_wellbeing == "-5 (Way worse than normal)"] <- "-5"
data$PLD_wellbeing[data$PLD_wellbeing == "5 (Way better than normal)"] <- "5"

data$PLD_study_more <- "0" 
data$PLD_study_less <- "0" 

data$PLD_study_more[data$PLD_study_time == "More time studying"] <- "1"
data$PLD_study_less[data$PLD_study_time == "Less time studying"] <- "1"
data <- subset(data, select=-c(PLD_study_time))

data$PLD_more_anxiety[data$PLD_more_anxiety == "Yes"] <- "1"
data$PLD_more_anxiety[data$PLD_more_anxiety == "No"] <- "0"

data$PLD_attendance_freq[data$PLD_attendance_freq == "0-25%"] <- "1"
data$PLD_attendance_freq[data$PLD_attendance_freq == "26-50%"] <- "2"
data$PLD_attendance_freq[data$PLD_attendance_freq == "51-75%"] <- "3"
data$PLD_attendance_freq[data$PLD_attendance_freq == "76-100%"] <- "4"

data$PLD_recording_freq[data$PLD_recording_freq == "0-25%"] <- "1"
data$PLD_recording_freq[data$PLD_recording_freq == "26-50%"] <- "2"
data$PLD_recording_freq[data$PLD_recording_freq == "51-75%"] <- "3"
data$PLD_recording_freq[data$PLD_recording_freq == "76-100%"] <- "4"

#reorder columns alphabetically. 
data <- data %>% select(order(colnames(.)))

###CREATE SECOND DATASET FOR PARTIAL LOCKDOWN = 1###################################
data2 <- data

#Work on dataset with partial lockdown = 0
data$got_anxiety <- NA
data$lost_anxiety <- NA
data$still_anxiety <- NA
data$no_anxiety <- NA
data$got_anxiety <- ifelse(data$FLD_more_anxiety == 0 & data$PLD_more_anxiety == 1, 1,0)
data$lost_anxiety <- ifelse(data$FLD_more_anxiety == 1 & data$PLD_more_anxiety == 0, 1,0)
data$still_anxiety <- ifelse(data$FLD_more_anxiety == 1 & data$PLD_more_anxiety == 1, 1,0)
data$no_anxiety <- ifelse(data$FLD_more_anxiety == 0 & data$PLD_more_anxiety == 0, 1,0)

data <- subset(data, select=-c(PLD_ag, PLD_attendance_freq  , PLD_more_anxiety  , PLD_quality_learning,    
                               PLD_quality_teaching, PLD_recording_freq  , PLD_study_less,          
                               PLD_study_more   ,  PLD_wellbeing))
names(data)[names(data) == "FLD_ag"] <- "average_grade"
names(data)[names(data) == "FLD_bad_internet"] <- "bad_internet"
names(data)[names(data) == "FLD_more_anxiety"] <- "more_anxiety"
names(data)[names(data) == "FLD_quality_learning"] <- "quality_learning"
names(data)[names(data) == "FLD_quality_teaching"] <- "quality_teaching"
names(data)[names(data) == "FLD_recording_freq"] <- "recording_freq"
names(data)[names(data) == "FLD_separate_room"] <- "separate_room"
names(data)[names(data) == "FLD_study_less"] <- "study_less"
names(data)[names(data) == "FLD_study_more"] <- "study_more"
names(data)[names(data) == "FLD_wellbeing"] <- "wellbeing"
names(data)[names(data) == "FLD_zoom_anxiety"] <- "zoom_anxiety"
names(data)[names(data) == "FLD_zoom_attendance_freq"] <- "attendance_freq"
data$partial_lockdown <- "0"
#Work on dataset with partial lockdown = 1
data2$got_anxiety <- NA
data2$lost_anxiety <- NA
data2$still_anxiety <- NA
data2$no_anxiety <- NA
data2$got_anxiety <- ifelse(data2$FLD_more_anxiety == 0 & data2$PLD_more_anxiety == 1, 1,0)
data2$lost_anxiety <- ifelse(data2$FLD_more_anxiety == 1 & data2$PLD_more_anxiety == 0, 1,0)
data2$still_anxiety <- ifelse(data2$FLD_more_anxiety == 1 & data2$PLD_more_anxiety == 1, 1,0)
data2$no_anxiety <- ifelse(data2$FLD_more_anxiety == 0 & data2$PLD_more_anxiety == 0, 1,0)

data2 <- subset(data2, select=-c(FLD_ag,FLD_zoom_attendance_freq,FLD_more_anxiety,FLD_quality_learning,
                                 FLD_quality_teaching,FLD_recording_freq,FLD_study_less,
                                 FLD_study_more,FLD_wellbeing
))
names(data2)[names(data2) == "FLD_bad_internet"] <- "bad_internet"
names(data2)[names(data2) == "FLD_separate_room"] <- "separate_room"
names(data2)[names(data2) == "FLD_zoom_anxiety"] <- "zoom_anxiety"
names(data2)[names(data2) == "PLD_ag"] <- "average_grade"
names(data2)[names(data2) == "PLD_attendance_freq"] <- "attendance_freq"
names(data2)[names(data2) == "PLD_more_anxiety"] <- "more_anxiety"
names(data2)[names(data2) == "PLD_quality_learning"] <- "quality_learning"
names(data2)[names(data2) == "PLD_quality_teaching"] <- "quality_teaching"
names(data2)[names(data2) == "PLD_recording_freq"] <- "recording_freq"
names(data2)[names(data2) == "PLD_study_less"] <- "study_less"
names(data2)[names(data2) == "PLD_study_more"] <- "study_more"
names(data2)[names(data2) == "PLD_wellbeing"] <- "wellbeing"
data2$partial_lockdown <- "1"

data3 <- bind_rows(data,data2)


#Create csv
write.csv(data3,"C:/Users/jimmy/Desktop/Survey Data/Data prepared for interaction terms/SurveyData clean EN_int.csv", row.names = FALSE)

#Merge FR and EN data
df1 = read.csv("SurveyData clean EN_int.csv", header = TRUE, sep = ",", quote = "\"",
                dec = ".", fill = TRUE, comment.char = "")
df2 = read.csv("SurveyData clean FR_int.csv", header = TRUE, sep = ",", quote = "\"",
               dec = ".", fill = TRUE, comment.char = "")
df3 <- bind_rows(df1,df2)
#write.xlsx(df3,"C:/Users/jimmy/Desktop/Survey Data/SurveyData_clean_MERGED.xlsx")
write.xlsx(df3, file = "SurveyData_clean_MERGED_int.xlsx")