********************************************************************************
* ABOUT THIS .DO FILE: This do file contains code to create appendix figure 1.
* BY: Ann Jillian Adona (aadona@worldbank.org)		
* DATE: June 25, 2020 	
* DATA SOURCE: "Tables.xlsx"
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

import excel "Tables.xlsx", sheet("Sheet2") cellrange(A1:G29) firstrow clear

drop if CountryCode==""
ren countryid CountryName
merge 1:1 CountryCode using "rates of increase in norm_covid_mr and overall_mr and gdp.dta"

separate RatioofCOVID19mortalityages, by(income)

* New Figure 
graph hbar (asis) RatioofCOVID19mortalityages1 RatioofCOVID19mortalityages2 ///
	, over(country, label(labsize(small)) sort(YR2018)) ///
	plotregion(lcolor(black)) ///
	nofill ///
	ytitle("") ///
	bar(1, bfcolor(navy)) ///
	title("Ratio of ages 70-79 to 50-59 COVID-19 Mortality Rates", size(medium) pos(12) span) ///
	legend(off)
graph export "figA1.emf", as(emf) replace

********************************************************************************
********************************** END OF FILE *********************************