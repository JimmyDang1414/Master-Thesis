* Part 0 - Import Data
clear
set more off
cd "C:/Users/jimmy/Desktop/Survey Data/Data prepared for interaction terms"
*starlevels(* 0.1 ** 0.05 *** 0.01)
*ssc install estout
*ssc install mdesc 
*ssc install outreg2, replace
*ssc install rdrobust
*ssc install asdoc
*import delimited using SurveyData_clean_MERGED, numericcols(_all)
import excel SurveyData_clean_MERGED_int, firstrow case(lower)

mdesc // to assess percentage of missing value for each variable
***********************************************************************
global dep_variables "quality_learning quality_teaching wellbeing"

*hs_ag dropped because around 15% missing values
global limited_variables "third_year bad_internet separate_room more_anxiety zoom_anxiety attendance_freq recording_freq"

global variables "third_year hs_pref college_pref average_grade bad_internet separate_room more_anxiety zoom_anxiety attendance_freq recording_freq  study_more study_less"

global limited_interactions "c.partial_lockdown##c.third_year c.partial_lockdown##c.bad_internet c.partial_lockdown##c.separate_room c.partial_lockdown##c.more_anxiety c.partial_lockdown##c.zoom_anxiety"

global limited_interactions2 "c.partial_lockdown##c.third_year c.partial_lockdown##c.average_grade c.partial_lockdown##c.attendance_freq c.partial_lockdown##c.recording_freq  c.partial_lockdown##c.study_more c.partial_lockdown##c.study_less"

global all_interactions "c.partial_lockdown##c.third_year c.partial_lockdown##c.hs_pref c.partial_lockdown##c.college_pref c.partial_lockdown##c.average_grade c.partial_lockdown##c.bad_internet c.partial_lockdown##c.separate_room c.partial_lockdown##c.more_anxiety c.partial_lockdown##c.zoom_anxiety c.partial_lockdown##c.attendance_freq c.partial_lockdown##c.recording_freq  c.partial_lockdown##c.study_more c.partial_lockdown##c.study_less"

global all_interactionsexceptgrade "c.partial_lockdown##c.third_year c.partial_lockdown##c.hs_pref c.partial_lockdown##c.college_pref  c.partial_lockdown##c.bad_internet c.partial_lockdown##c.separate_room c.partial_lockdown##c.more_anxiety c.partial_lockdown##c.zoom_anxiety c.partial_lockdown##c.attendance_freq c.partial_lockdown##c.recording_freq  c.partial_lockdown##c.study_more c.partial_lockdown##c.study_less"

global sumstat " wellbeing quality_teaching quality_learning average_grade third_year hs_pref college_pref bad_internet separate_room more_anxiety zoom_anxiety attendance_freq recording_freq  study_more study_less"

***********************************************************************
*************************************************************************
*table 1 : summary stats 
gen provid1 = 0 if partial_lockdown == 0 & third_year == 0
replace provid1 = 1 if partial_lockdown == 1 & third_year == 0
gen provid2 = 0 if partial_lockdown == 0 & third_year == 1
replace provid2 = 1 if partial_lockdown == 1 & third_year == 1

eststo lockdown1: quietly estpost summarize ///
    $sumstat if partial_lockdown == 0
eststo plockdown1: quietly estpost summarize ///
    $sumstat if partial_lockdown == 1
gen partial_lockdown2 = !partial_lockdown
eststo diff1: quietly estpost ttest ///
    $sumstat, by(partial_lockdown2) unequal
eststo qlearningld: quietly reg quality_learning if partial_lockdown == 0
eststo qlearningpld: quietly reg quality_learning if partial_lockdown == 1
eststo qteachingld: quietly reg quality_teaching if partial_lockdown == 0
eststo qteachingpld: quietly reg quality_teaching if partial_lockdown == 1
eststo wellbeingld: quietly reg wellbeing if partial_lockdown == 0
eststo wellbeingpld: quietly reg wellbeing if partial_lockdown == 1
	
estout lockdown1 plockdown1 diff1 wellbeingld wellbeingpld qteachingld qteachingpld  qlearningld qlearningpld , ///
cells("mean(pattern(1 1 0 1 1 1 1 1 1) fmt(2)) b(star pattern(0 0 1 1 1 1 1 1 1) fmt(2))") starlevels(* 0.1 ** 0.05 *** 0.01) stats(N) title(Summary statistics) replace ///
label

esttab lockdown1 plockdown1 diff1 wellbeingld wellbeingpld qteachingld qteachingpld  qlearningld qlearningpld using table1.tex, ///
cells("mean(pattern(1 1 0 1 1 1 1 1 1) fmt(2)) b(star pattern(0 0 1 1 1 1 1 1 1) fmt(2))") starlevels(* 0.1 ** 0.05 *** 0.01) stats(N) title(Summary statistics) replace ///
label


*********************************************************
* figure : Histograms
label define partial_lockdown 1 "Partial lockdown" 0 "Lockdown"
label values partial_lockdown partial_lockdown

histogram quality_learning, percent ytitle(Percentage) xtitle(Ratings) discrete by(partial_lockdown, title(Quality of learning) col(2) note("")) 
graph export "C:/Users/jimmy/Desktop/Survey Data/Data prepared for interaction terms/histogram_ql.png", replace
histogram quality_teaching, percent ytitle(Percentage) xtitle(Ratings) discrete by(partial_lockdown, title(Quality of teaching) col(2) note("")) 
graph export "C:/Users/jimmy/Desktop/Survey Data/Data prepared for interaction terms/histogram_qt.png", replace
histogram wellbeing, percent ytitle(Percentage) xtitle(Ratings) discrete by(partial_lockdown, title(Well-being) col(2) note(""))
graph export "C:/Users/jimmy/Desktop/Survey Data/Data prepared for interaction terms/histogram_wb.png", replace 
histogram average_grade, percent ytitle(Percentage) xtitle("") xlabel(0(1)4) discrete by(partial_lockdown, title(Average grade) col(2) note(""))
graph export "C:/Users/jimmy/Desktop/Survey Data/Data prepared for interaction terms/histogram_ag.png", replace


*************************************************************************
*table 2 : effect of anxiety 
reg average_grade more_anxiety, robust 
eststo m1
reg average_grade  c.partial_lockdown##c.more_anxiety, robust 
eststo m2
reg wellbeing  more_anxiety, robust 
eststo m3
reg wellbeing  c.partial_lockdown##c.more_anxiety, robust 
eststo m4
reg quality_teaching  more_anxiety, robust 
eststo m5
reg quality_teaching  c.partial_lockdown##c.more_anxiety, robust 
eststo m6
reg quality_learning  more_anxiety, robust 
eststo m7
reg quality_learning  c.partial_lockdown##c.more_anxiety, robust 
eststo m8
estout m1 m2 m3 m4 m5 m6 m7 m8, cells(b(star fmt(3)) se(par fmt(3))) keep() stat(r2 N) starlevels(* 0.1 ** 0.05 *** 0.01) title(Effect of anxiety and both lockdowns on variables)
esttab m1 m2 m3 m4 m5 m6 m7 m8 using Table2.tex, cells(b(star fmt(3)) se(par fmt(3))) keep() stat(r2 N) starlevels(* 0.1 ** 0.05 *** 0.01) title(Effect of anxiety and both lockdowns on variables) replace 

**************************************************************
*table 3 : linear probability model for anxiety 
global almost_interactions "c.partial_lockdown##c.third_year c.partial_lockdown##c.hs_pref c.partial_lockdown##c.college_pref c.partial_lockdown##c.average_grade c.partial_lockdown##c.bad_internet c.partial_lockdown##c.separate_room  c.partial_lockdown##c.zoom_anxiety c.partial_lockdown##c.attendance_freq c.partial_lockdown##c.recording_freq  c.partial_lockdown##c.study_more c.partial_lockdown##c.study_less"
global almost_interactions2 "c.partial_lockdown##c.third_year c.partial_lockdown##c.hs_pref c.partial_lockdown##c.college_pref c.partial_lockdown##c.average_grade c.partial_lockdown##c.bad_internet c.partial_lockdown##c.separate_room  c.partial_lockdown##c.zoom_anxiety c.partial_lockdown##c.attendance_freq c.partial_lockdown##c.recording_freq  c.partial_lockdown##c.more_anxiety"
global almost_interactions3 "c.partial_lockdown##c.third_year c.partial_lockdown##c.hs_pref c.partial_lockdown##c.college_pref c.partial_lockdown##c.average_grade c.partial_lockdown##c.bad_internet c.partial_lockdown##c.separate_room  c.partial_lockdown##c.zoom_anxiety c.partial_lockdown##c.recording_freq  c.partial_lockdown##c.study_more c.partial_lockdown##c.study_less c.partial_lockdown##c.more_anxiety "
gen pos_academia = 0 
replace pos_academia = 1 if (quality_learning + quality_teaching >= 1)

reg more_anxiety $almost_interactions, robust
eststo m1
reg more_anxiety c.partial_lockdown##c.pos_academia, robust
eststo m2
reg more_anxiety $almost_interactions c.partial_lockdown##c.pos_academia, robust
eststo m3
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(3))) keep() stat(r2 N) starlevels(* 0.1 ** 0.05 *** 0.01) title(impact of variables on probability of anxiety)
esttab m1 m2 m3 using table3.tex, cells(b(star fmt(3)) se(par fmt(3))) keep() stat(r2 N) starlevels(* 0.1 ** 0.05 *** 0.01) title(impact of variables on probability of anxiety) replace 
*************************************************************************
 
*appendix 1 : one large table. Can't use fixed effect because interested in time-invariant variables (individual fixed effects) 

reg average_grade c.partial_lockdown##c.more_anxiety, robust 
eststo m1
reg average_grade $all_interactionsexceptgrade c.partial_lockdown##c.pos_academia, robust 
eststo m2
reg wellbeing  c.partial_lockdown##c.more_anxiety, robust 
eststo m3
reg wellbeing $all_interactions c.partial_lockdown##c.pos_academia, robust 
eststo m4
reg quality_teaching  c.partial_lockdown##c.more_anxiety, robust 
eststo m5
reg quality_teaching $all_interactions, robust 
eststo m6
reg quality_learning  c.partial_lockdown##c.more_anxiety, robust 
eststo m7
reg quality_learning $all_interactions, robust 
eststo m8

estout m1 m2 m3 m4 m5 m6 m7 m8, cells(b(star fmt(3)) se(par fmt(3))) keep() stat(r2 N) starlevels(* 0.1 ** 0.05 *** 0.01) title(Effect of anxiety and several variables on variables of interest)
esttab m1 m2 m3 m4 m5 m6 m7 m8 using appendix1.tex, cells(b(star fmt(3)) se(par fmt(3))) keep() stat(r2 N) starlevels(* 0.1 ** 0.05 *** 0.01) title(Effect of anxiety and several variables on variables of interest) replace 

************************************************************
*appendix 2 : fixed effect regression 


xtset id
reg average_grade  c.partial_lockdown##c.more_anxiety, robust
eststo m1
xtreg average_grade  c.partial_lockdown##c.more_anxiety, fe
eststo m2
reg wellbeing  c.partial_lockdown##c.more_anxiety, robust
eststo m3
xtreg wellbeing  c.partial_lockdown##c.more_anxiety, fe
eststo m4
reg quality_teaching  c.partial_lockdown##c.more_anxiety, robust
eststo m5
xtreg quality_teaching  c.partial_lockdown##c.more_anxiety, fe
eststo m6
reg quality_learning  c.partial_lockdown##c.more_anxiety, robust
eststo m7
xtreg quality_learning  c.partial_lockdown##c.more_anxiety, fe
eststo m8
estout m1 m2 m3 m4 m5 m6 m7 m8, cells(b(star fmt(3)) se(par fmt(3))) keep() stat(r2 N) starlevels(* 0.1 ** 0.05 *** 0.01) title(Effect of anxiety and both lockdowns on variables : fixed-effect)
esttab m1 m2 m3 m4 m5 m6 m7 m8 using appendix2.tex, cells(b(star fmt(3)) se(par fmt(3))) keep() stat(r2 N) starlevels(* 0.1 ** 0.05 *** 0.01) title(Effect of anxiety and both lockdowns on variables : fixed-effect) replace 
