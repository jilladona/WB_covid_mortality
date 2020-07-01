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
global dir "WB_covid_mortality"
cd "$dir"

use "norm and raw covid_mr.dta", clear

g income=""
replace income="HIC" if inlist(country, 5, 25, 17, 26, 8, 16, 10, 21, 11, 24, 9, 3, 12, 22, 6, 13, 26)
replace income="U/LMIC" if inlist(country, 1, 2, 4, 7, 14, 20, 19, 18, 15, 23)

collapse(mean) norm_covid_mr, by(income agex)

tw 	(line norm_covid_mr agex if income=="HIC", lcolor(navy)) ///
	(line norm_covid_mr agex if income=="U/LMIC", lcolor(maroon)) ///
	if agex>=30 ///
	, xsc(extend) xlabel(30 "30-39" 40 "40-49" 50 "50-59" 60 "60-69" 70 "70-79" 80 "80+", labsize(small)) xtitle("Age group", size(medium) margin(top)) ///
	ylabel(0 .1 .2 .3 .4 .5 .6 .7 .8, labsize(small)) ytitle("Normalized COVID-19 mortality rate") ///
	plotregion(lcolor(black)) ///
	legend(order(1 "High income" 2 "Low and middle income") size(small) symxsize(1pt) rows(1) pos(6)) /// 
	title("Average COVID-19 Mortality Rates" "by Age Group and Country Income Level", size(mediumlarge) span)
graph export "fig5a.emf", as(emf) replace

* Figure 3b (log)
tw 	(line norm_covid_mr agex if income=="HIC", lcolor(navy)) ///
	(line norm_covid_mr agex if income=="U/LMIC", lcolor(maroon)) ///
	if agex>=30 ///
	, xlabel(30 "30-39" 40 "40-49" 50 "50-59" 60 "60-69" 70 "70-79" 80 "80+", labsize(small)) xtitle("Age group", size(medium) margin(top)) ///
	ylabel(.01 .1, labsize(small)) ytitle("Normalized COVID-19 mortality rate") ysc(log) ///
	plotregion(lcolor(black)) ///
	legend(order(1 "High income" 2 "Low and middle income") size(small) symxsize(1pt) rows(1) pos(6)) /// 
	title("Average COVID-19 Mortality Rates" "by Age Group and Country Income Level", size(mediumlarge) span)
graph export "fig5b.emf", as(emf) replace

********************************************************************************
********************************** END OF FILE *********************************