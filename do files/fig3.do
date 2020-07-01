********************************************************************************
* ABOUT THIS .DO FILE: This do produces charts of overall and covid mortality.
* BY: Ann Jillian Adona (aadona@worldbank.org)		
* DATE: May 22, 2020 	
* DATA SOURCE: "covid_mr and overall_mr.dta"
* Data file names have not been changed. 
********************************************************************************
disp "$S_TIME  $S_DATE"

* Set scheme:
set scheme s2color
grstyle init
grstyle set plain

* Set wd:
global dir "C:\Users\WB563338\OneDrive - WBG\Covid_DOH\Covid death rates by age"
cd "$dir"

use "$dir\analysis\dta\norm and raw covid_mr.dta", clear

gsort -agex -raw_covid_mr

replace raw_covid_mr=raw_covid_mr*1000

* Create graphs:
* Figure 3a. COVID-19 death rates by age group
tw 	(line raw_covid_mr agex if country==1) (line raw_covid_mr agex if country==2) ///
	(line raw_covid_mr agex if country==3) (line raw_covid_mr agex if country==4) ///
	(line raw_covid_mr agex if country==5) (line raw_covid_mr agex if country==6) ///
	(line raw_covid_mr agex if country==7) (line raw_covid_mr agex if country==8) ///
	(line raw_covid_mr agex if country==9) (line raw_covid_mr agex if country==10) ///
	(line raw_covid_mr agex if country==11) (line raw_covid_mr agex if country==12) ///
	(line raw_covid_mr agex if country==13) (line raw_covid_mr agex if country==14) ///
	(line raw_covid_mr agex if country==15) (line raw_covid_mr agex if country==16) ///
	(line raw_covid_mr agex if country==17) (line raw_covid_mr agex if country==18) ///
	(line raw_covid_mr agex if country==19) (line raw_covid_mr agex if country==20) ///
	(line raw_covid_mr agex if country==21) (line raw_covid_mr agex if country==22) ///
	(line raw_covid_mr agex if country==23) (line raw_covid_mr agex if country==24) ///
	(line raw_covid_mr agex if country==25) (line raw_covid_mr agex if country==26) ///
	if agex>=30 ///
	, xsc(extend) xlabel(30 "30-39" 40 "40-49" 50 "50-59" 60 "60-69" 70 "70-79" 80 "80+", labsize(small)) xtitle("Age group", size(medium) margin(top)) ///
	ylabel(, labsize(small)) ytitle("COVID-19 mortality rate") ///
	plotregion(lcolor(black)) ///
	legend(all order(25 "Sweden" 16 "Netherlands" 24 "Spain" 12 "Italy" 5 "Canada" 9 "France" 4 "Brazil" 6 "Chile" 26 "Switzerland" 19 "Peru" 21 "Portugal" 8 "Denmark" 10 "Germany" 15 "Mexico" 17 "Norway" 11 "Hungary" 7 "Colombia" 23 "South Africa" 1 "Afghanistan" 2 "Argentina" 20 "Philippines" 18 "Pakistan" 22 "Republic of Korea" 3 "Australia" 14 "Malaysia" 13 "Japan") size(small) symxsize(1pt) symysize(1pt) symplacement(9) cols(1) pos(3)) ///
	title("COVID-19 Mortality Rates (Deaths/Population)" "by Age Group and Country", size(mediumlarge) span)
graph export "$dir\analysis\graphs\git\fig3a.emf", as(emf) replace

* Figure 3b. COVID-19 death rates by age group (log)
tw 	(line raw_covid_mr agex if country==1) (line raw_covid_mr agex if country==2) ///
	(line raw_covid_mr agex if country==3) (line raw_covid_mr agex if country==4) ///
	(line raw_covid_mr agex if country==5) (line raw_covid_mr agex if country==6) ///
	(line raw_covid_mr agex if country==7) (line raw_covid_mr agex if country==8) ///
	(line raw_covid_mr agex if country==9) (line raw_covid_mr agex if country==10) ///
	(line raw_covid_mr agex if country==11) (line raw_covid_mr agex if country==12) ///
	(line raw_covid_mr agex if country==13) (line raw_covid_mr agex if country==14) ///
	(line raw_covid_mr agex if country==15) (line raw_covid_mr agex if country==16) ///
	(line raw_covid_mr agex if country==17) (line raw_covid_mr agex if country==18) ///
	(line raw_covid_mr agex if country==19) (line raw_covid_mr agex if country==20) ///
	(line raw_covid_mr agex if country==21) (line raw_covid_mr agex if country==22) ///
	(line raw_covid_mr agex if country==23) (line raw_covid_mr agex if country==24) ///
	(line raw_covid_mr agex if country==25) (line raw_covid_mr agex if country==26) ///
	if agex>=30 & raw_covid_mr!=0 ///
	, xsc(extend) xlabel(30 "30-39" 40 "40-49" 50 "50-59" 60 "60-69" 70 "70-79" 80 "80+", labsize(small)) xtitle("Age group", size(medium) margin(top)) ///
	ylabel(0.001 0.01 0.1 1, labsize(small)) ytitle("COVID-19 mortality rate") ysc(log) ///
	plotregion(lcolor(black)) ///
	legend(all order(25 "Sweden" 16 "Netherlands" 24 "Spain" 12 "Italy" 5 "Canada" 9 "France" 4 "Brazil" 6 "Chile" 26 "Switzerland" 19 "Peru" 21 "Portugal" 8 "Denmark" 10 "Germany" 15 "Mexico" 17 "Norway" 11 "Hungary" 7 "Colombia" 23 "South Africa" 1 "Afghanistan" 2 "Argentina" 20 "Philippines" 18 "Pakistan" 22 "Republic of Korea" 3 "Australia" 14 "Malaysia" 13 "Japan") size(small) symxsize(1pt) symysize(1pt) symplacement(9) cols(1) pos(3)) ///
	title("COVID-19 Mortality Rates (Deaths/Population)" "by Age Group and Country", size(mediumlarge) span)
graph export "$dir\analysis\graphs\git\fig3b.emf", as(emf) replace

********************************************************************************
********************************** END OF FILE *********************************