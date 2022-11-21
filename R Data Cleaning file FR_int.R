rm(list=ls())
library(dplyr)
setwd("C:/Users/jimmy/Desktop/Survey Data/Data prepared for interaction terms")
data = read.csv("results-survey123762-FR-true.csv", header = TRUE, sep = ",", quote = "\"",
         dec = ".", fill = TRUE, comment.char = "")
data = as_tibble(data)
data[data == "Je ne sais pas"] <- NA
data[data == "Suisse"] <- "Switzerland"
data[data == "Autre"] <- "Other"
data <- data %>% mutate_all(na_if,"")

# Rename column 
names(data)[names(data) == "ï..ID.de.la.rÃ.ponse"] <- "id"
names(data)[names(data) == "Quelle.est.actuellement.votre.annÃ.e.d.Ã.tude..Â."] <- "year"
names(data)[names(data) == "PrÃ.fÃ.rez.vous.l.universitÃ..ou.le.collÃ.ge.suisse..lycÃ.e.franÃ.ais..."] <- "school_pref"
names(data)[names(data) == "Dans.quel.pays.avez.vous.terminÃ..le.collÃ.ge.lycÃ.e.."] <- "hs_country"
names(data)[names(data) == "Quelle.Ã.tait.votre.note.moyenne.Ã..la.fin.du.collÃ.ge..Â...Moyenne."] <- "hs_ch_ag"
names(data)[names(data) == "Quelle.Ã.tait.votre.note.moyenne.Ã..la.fin.du.lycÃ.e..Â...Moyenne."] <- "hs_fr_ag"
names(data)[names(data) == "Quelle.Ã.tait.votre.note.moyenne.Ã..la.fin.du.collÃ.ge.lycÃ.e.high.school.de.votre.pays...Veuillez.l.Ã.crire.avec.la.note.maximale..e.g..3.4.4.or.7.2.10.etc.Â.Â...Si.vous.ne.vous.en.souvenez.plus..veuillez.l.indiquer.dans.la.boÃ.te.."] <- "hs_country_ag"
names(data)[names(data) == "Quelle.Ã.tait.votre.note.moyenne.pour.la.premiÃ.re.annÃ.e.Ã..l.universitÃ.....Â...Â....Moyenne.de.premiÃ.re.annÃ.e."] <- "first_year_ag"
names(data)[names(data) == "Quelle.Ã.tait.votre.note.moyenne.pour.les.cours.communs.obligatoires.de.deuxiÃ.me.annÃ.e....Les.cours.communs.obligatoires.de.deuxiÃ.me.annÃ.e.sont.Statistics..Business.and.Society..Corporate.Finance..Introduction.au.Marketing.et.Introduction.to.Econometrics...Si.vous.Ãªtes.en.deuxiÃ.me.annÃ.e..veuillez.ignorer.Introduction.to.Econometrics.pour.la.note.moyenne..puisque.c.est.un.cours.que.vous.n.avez.pas.encore.passÃ....Â...Â....Moyenne.des.cours.obligatoires.de.deuxiÃ.me.annÃ.e."] <- "second_year_ag"
names(data)[names(data) == "Quelle.est.la.note.moyenne.des.cours.dont.vous.venez.de.passer.les.examens.il.n.y.a.pas.longtemps..Â...Â....Moyenne.des.cours.du.semestre.se.terminant."] <- "third_year_ag"
names(data)[names(data) == "Comment.estimeriez.vous.la.qualitÃ..d.apprentissage..la.qualitÃ..d.enseignement.et.votre.bien.Ãªtre.personnel.durant.cette.pÃ.riode.....QualitÃ...d.apprentissageÂ.."] <- "FLD_quality_learning"
names(data)[names(data) == "Comment.estimeriez.vous.la.qualitÃ..d.apprentissage..la.qualitÃ..d.enseignement.et.votre.bien.Ãªtre.personnel.durant.cette.pÃ.riode.....QualitÃ...d.enseignementÂ.."] <- "FLD_quality_teaching"
names(data)[names(data) == "Comment.estimeriez.vous.la.qualitÃ..d.apprentissage..la.qualitÃ..d.enseignement.et.votre.bien.Ãªtre.personnel.durant.cette.pÃ.riode.....Bien.Ãªtre."] <- "FLD_wellbeing"
names(data)[names(data) == "Comment.estimeriez.vous.le.temps.passÃ..Ã..Ã.tudier.comparÃ..Ã..une.situation.normale..."] <- "FLD_study_time"
names(data)[names(data) == "Comment.Ã.tait.votre.connection.Internet.pour.les.cours.sur.Zoom..regarder.les.enregistrements..travailler.en.groupe.via.Zoom.etc.....Â.."] <- "FLD_internet"
names(data)[names(data) == "Aviez.vous.une.piÃ.ce.sÃ.parÃ.e.Ã..la.maison.pour.Ã.tudier.."] <- "FLD_separate_room"
names(data)[names(data) == "Ressentiez.vous.plus.d.anxiÃ.tÃ..durant.le.confinement.comparÃ..Ã..la.normale.."] <- "FLD_more_anxiety"
names(data)[names(data) == "Ressentiez.vous.une.anxiÃ.tÃ..particuliÃ.re.en.utilisant.Zoom.."] <- "FLD_zoom_anxiety"
names(data)[names(data) == "Durant.cette.pÃ.riode..quelle.serait.votre.taux.de.prÃ.sence.aux.cours.et.sÃ.minaires.tenus.sur.Zoom.."] <- "FLD_zoom_attendance_freq"
names(data)[names(data) == "Durant.cette.pÃ.riode..quelle.serait.votre.taux.de.consultation.d.enregistrements.des.cours.et.sÃ.minaires.....100..signifie.que.pour.chaque.cours.et.sÃ.minaire..vous.regardez.systÃ.matiquement.l.enregistrement.pour.peu.qu.il.soit.disponible.."] <- "FLD_recording_freq"
names(data)[names(data) == "Comment.estimeriez.vous.la.qualitÃ..d.apprentissage..la.qualitÃ..d.enseignement.et.votre.bien.Ãªtre.personnel.durant.cette.pÃ.riode.....QualitÃ...d.apprentissageÂ...1"] <- "PLD_quality_learning"
names(data)[names(data) == "Comment.estimeriez.vous.la.qualitÃ..d.apprentissage..la.qualitÃ..d.enseignement.et.votre.bien.Ãªtre.personnel.durant.cette.pÃ.riode.....QualitÃ...d.enseignementÂ...1"] <- "PLD_quality_teaching"
names(data)[names(data) == "Comment.estimeriez.vous.la.qualitÃ..d.apprentissage..la.qualitÃ..d.enseignement.et.votre.bien.Ãªtre.personnel.durant.cette.pÃ.riode.....Bien.Ãªtre..1"] <- "PLD_wellbeing"
names(data)[names(data) == "Comment.estimeriez.vous.le.temps.passÃ..Ã..Ã.tudier.comparÃ..Ã..une.situation.normale....1"] <- "PLD_study_time"
names(data)[names(data) == "Ressentiez.vous.plus.d.anxiÃ.tÃ..durant.le.semi.confinement.comparÃ..Ã..la.normale.."] <- "PLD_more_anxiety"
names(data)[names(data) == "Durant.cette.pÃ.riode..quelle.serait.votre.taux.de.prÃ.sence.aux.cours.et.sÃ.minaires.en.prÃ.sentiel.."] <- "PLD_attendance_freq"
names(data)[names(data) == "Durant.cette.pÃ.riode..quelle.serait.votre.taux.de.consultation.d.enregistrements.des.cours.et.sÃ.minaires.....100..signifie.que.pour.chaque.cours.et.sÃ.minaire..vous.regardez.systÃ.matiquement.l.enregistrement.pour.peu.qu.il.soit.disponible...1"] <- "PLD_recording_freq"

#Replace variables with appropriate numbers
#data$year <-  as.character(data$year)
#data$year[data$year == "Third year"] <- "3"

#Create third year dummy. = 0 if second year. 
data$third_year <- "0" #add column and create values 0
data$third_year <-  as.character(data$third_year)
data$third_year[data$year == "TroisiÃ¨me annÃ©e"] <- "1"
data <- subset(data, select=-c(year)) #delete the column year, no longer relevant as we have dummies now.

#College pref dummy and HS pref dummy.
data$college_pref <- "0" 
data$college_pref <-  as.character(data$college_pref)
data$college_pref[data$school_pref == "UniversitÃ©"] <- "1"

data$hs_pref <- "0" 
data$hs_pref <-  as.character(data$hs_pref)
data$hs_pref[data$school_pref == "CollÃ¨ge/LycÃ©e"] <- "1"
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

data$FLD_quality_learning[data$FLD_quality_learning == "0 (Pas de diffÃ©rence)"] <- "0"
data$FLD_quality_learning[data$FLD_quality_learning == "-5 (Beaucoup moins bien que la normale)"] <- "-5"
data$FLD_quality_learning[data$FLD_quality_learning == "5 (Beaucoup mieux que la normale)"] <- "5"

data$FLD_quality_teaching[data$FLD_quality_teaching == "0 (Pas de diffÃ©rence)"] <- "0"
data$FLD_quality_teaching[data$FLD_quality_teaching == "-5 (Beaucoup moins bien que la normale)"] <- "-5"
data$FLD_quality_teaching[data$FLD_quality_teaching == "5 (Beaucoup mieux que la normale)"] <- "5"

data$FLD_wellbeing[data$FLD_wellbeing == "0 (Pas de diffÃ©rence)"] <- "0"
data$FLD_wellbeing[data$FLD_wellbeing == "-5 (Beaucoup moins bien que la normale)"] <- "-5"
data$FLD_wellbeing[data$FLD_wellbeing == "5 (Beaucoup mieux que la normale)"] <- "5"

#change FLD study time into 2 dummies.
data$FLD_study_more <- "0" 
data$FLD_study_less <- "0" 

data$FLD_study_more[data$FLD_study_time == "Plus"] <- "1"
data$FLD_study_less[data$FLD_study_time == "Moins"] <- "1"
data <- subset(data, select=-c(FLD_study_time))

#change internet into 1 dummy (either internet is good or not ; in-between makes less sense)
data$FLD_bad_internet <- "0" 

data$FLD_bad_internet[data$FLD_internet == "Mauvais et instable"] <- "1"
data <- subset(data, select=-c(FLD_internet))

#conversion
data$FLD_separate_room[data$FLD_separate_room == "Oui"] <- "1"
data$FLD_separate_room[data$FLD_separate_room == "Non"] <- "0"

data$FLD_more_anxiety[data$FLD_more_anxiety == "Oui"] <- "1"
data$FLD_more_anxiety[data$FLD_more_anxiety == "Non"] <- "0"

data$FLD_zoom_anxiety[data$FLD_zoom_anxiety == "Oui"] <- "1"
data$FLD_zoom_anxiety[data$FLD_zoom_anxiety == "Non"] <- "0"

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
data$PLD_quality_learning[data$PLD_quality_learning == "0 (Pas de diffÃ©rence)"] <- "0"
data$PLD_quality_learning[data$PLD_quality_learning == "-5 (Beaucoup moins bien que la normale)"] <- "-5"
data$PLD_quality_learning[data$PLD_quality_learning == "5 (Beaucoup mieux que la normale)"] <- "5"

data$PLD_quality_teaching[data$PLD_quality_teaching == "0 (Pas de diffÃ©rence)"] <- "0"
data$PLD_quality_teaching[data$PLD_quality_teaching == "-5 (Beaucoup moins bien que la normale)"] <- "-5"
data$PLD_quality_teaching[data$PLD_quality_teaching == "5 (Beaucoup mieux que la normale)"] <- "5"

data$PLD_wellbeing[data$PLD_wellbeing == "0 (Pas de diffÃ©rence)"] <- "0"
data$PLD_wellbeing[data$PLD_wellbeing == "-5 (Beaucoup moins bien que la normale)"] <- "-5"
data$PLD_wellbeing[data$PLD_wellbeing == "5 (Beaucoup mieux que la normale)"] <- "5"

data$PLD_study_more <- "0" 
data$PLD_study_less <- "0" 

data$PLD_study_more[data$PLD_study_time == "Plus"] <- "1"
data$PLD_study_less[data$PLD_study_time == "Moins"] <- "1"
data <- subset(data, select=-c(PLD_study_time))

data$PLD_more_anxiety[data$PLD_more_anxiety == "Oui"] <- "1"
data$PLD_more_anxiety[data$PLD_more_anxiety == "Non"] <- "0"

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

data <- subset(data, select=-c(first_year_ag, second_year_ag, third_year_ag))

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
write.csv(data3,"C:/Users/jimmy/Desktop/Survey Data/Data prepared for interaction terms/SurveyData clean FR_int.csv", row.names = FALSE)