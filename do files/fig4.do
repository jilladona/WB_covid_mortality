********************************************************************************
* ABOUT THIS .DO FILE: This do produces charts of overall and covid mortality.
* BY: Ann Jillian Adona (aadona@worldbank.org)		
* DATE: May 22, 2020 	
* DATA SOURCE: "norm and raw covid_mr.dta"
* Data file names have not been changed. 
********************************************************************************
disp "$S_TIME  $S_DATE"

* Set scheme:
set scheme s2color
grstyle init
grstyle set plain

* Set wd:
global dir "WB_covid_mortality"
cd "$dir"

use "norm and raw covid_mr.dta", clear

* Figure 4a. Normalized (2) COVID-19 death rates
gsort -agex -norm_covid_mr

tw 	(line norm_covid_mr agex if country==1) (line norm_covid_mr agex if country==2) ///
	(line norm_covid_mr agex if country==3) (line norm_covid_mr agex if country==4) ///
	(line norm_covid_mr agex if country==5) (line norm_covid_mr agex if country==6) ///
	(line norm_covid_mr agex if country==7) (line norm_covid_mr agex if country==8) ///
	(line norm_covid_mr agex if country==9) (line norm_covid_mr agex if country==10) ///
	(line norm_covid_mr agex if country==11) (line norm_covid_mr agex if country==12) ///
	(line norm_covid_mr agex if country==13) (line norm_covid_mr agex if country==14) ///
	(line norm_covid_mr agex if country==15) (line norm_covid_mr agex if country==16) ///
	(line norm_covid_mr agex if country==17) (line norm_covid_mr agex if country==18) ///
	(line norm_covid_mr agex if country==19) (line norm_covid_mr agex if country==20) ///
	(line norm_covid_mr agex if country==21) (line norm_covid_mr agex if country==22) ///
	(line norm_covid_mr agex if country==23) (line norm_covid_mr agex if country==24) ///
	(line norm_covid_mr agex if country==25) (line norm_covid_mr agex if country==26) ///
	if agex>=30 & norm_covid_mr!=0 ///
	, xsc(extend) xlabel(30 "30-39" 40 "40-49" 50 "50-59" 60 "60-69" 70 "70-79" 80 "80+", labsize(small)) xtitle("Age group", size(medium) margin(top)) ///
	ylabel(.1 .2 .3 .4 .5 .6 .7 .8, labsize(small)) ytitle("Normalized COVID-19 mortality rate") ///
	plotregion(lcolor(black)) ///
	legend(all order(5 "Canada" 25 "Sweden" 17 "Norway" 26 "Switzerland" 8 "Denmark" 21 "Portugal" 16 "Netherlands" 10 "Germany" 11 "Hungary" 24 "Spain" 9 "France" 3 "Australia" 12 "Italy" 22 "Republic of Korea" 2 "Argentina" 1 "Afghanistan" 13 "Japan" 23 "South Africa" 6 "Chile" 4 "Brazil" 7 "Colombia" 14 "Malaysia" 20 "Philippines" 19 "Peru" 18 "Pakistan" 15 "Mexico") size(small) symxsize(1pt) symysize(1pt) symplacement(9) cols(1) pos(3)) ///
	title("Normalized COVID-19 Mortality Rates" "by Age Group and Country", span)
graph export "fig4a.emf", as(emf) replace

* Figure 4b. Normalized (2) COVID-19 death rates (log)
tw 	(line norm_covid_mr agex if country==1) (line norm_covid_mr agex if country==2) ///
	(line norm_covid_mr agex if country==3) (line norm_covid_mr agex if country==4) ///
	(line norm_covid_mr agex if country==5) (line norm_covid_mr agex if country==6) ///
	(line norm_covid_mr agex if country==7) (line norm_covid_mr agex if country==8) ///
	(line norm_covid_mr agex if country==9) (line norm_covid_mr agex if country==10) ///
	(line norm_covid_mr agex if country==11) (line norm_covid_mr agex if country==12) ///
	(line norm_covid_mr agex if country==13) (line norm_covid_mr agex if country==14) ///
	(line norm_covid_mr agex if country==15) (line norm_covid_mr agex if country==16) ///
	(line norm_covid_mr agex if country==17) (line norm_covid_mr agex if country==18) ///
	(line norm_covid_mr agex if country==19) (line norm_covid_mr agex if country==20) ///
	(line norm_covid_mr agex if country==21) (line norm_covid_mr agex if country==22) ///
	(line norm_covid_mr agex if country==23) (line norm_covid_mr agex if country==24) ///
	(line norm_covid_mr agex if country==25) (line norm_covid_mr agex if country==26) ///
	if agex>=30 & norm_covid_mr!=0 ///
	, xsc(extend) xlabel(30 "30-39" 40 "40-49" 50 "50-59" 60 "60-69" 70 "70-79" 80 "80+", labsize(small)) xtitle("Age group", size(medium) margin(top)) ///
	ylabel(0.001 0.01 0.1 1, labsize(small)) ytitle("Normalized COVID-19 mortality rate") ysc(log) ///
	plotregion(lcolor(black)) ///
	legend(all order(5 "Canada" 25 "Sweden" 17 "Norway" 26 "Switzerland" 8 "Denmark" 21 "Portugal" 16 "Netherlands" 10 "Germany" 11 "Hungary" 24 "Spain" 9 "France" 3 "Australia" 12 "Italy" 22 "Republic of Korea" 2 "Argentina" 1 "Afghanistan" 13 "Japan" 23 "South Africa" 6 "Chile" 4 "Brazil" 7 "Colombia" 14 "Malaysia" 20 "Philippines" 19 "Peru" 18 "Pakistan" 15 "Mexico") size(small) symxsize(1pt) symysize(1pt) symplacement(9) cols(1) pos(3)) ///
	title("Normalized COVID-19 Mortality Rates" "by Age Group and Country", span)
graph export "fig4b.emf", as(emf) replace

********************************************************************************
********************************** END OF FILE *********************************