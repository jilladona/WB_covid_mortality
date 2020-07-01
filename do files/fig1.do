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

import excel "Tables.xlsx", sheet("Sheet3") firstrow clear

egen COVIDdeathsforagesunder50=rowtotal(COVID19deathsforages09 COVID19deathsforages1019 COVID19deathsforages2029 COVID19deathsforages3039 COVID19deathsforages4049)

local vars "COVID19deathsforages09 COVID19deathsforages1019 COVID19deathsforages2029 COVID19deathsforages3039 COVID19deathsforages4049 COVID19deathsforages5059 COVID19deathsforages6069 COVID19deathsforages7079 COVID19deathsforages80 COVIDdeathsforagesunder50"
foreach v of local vars {
	g frac_`v'=`v'/TotalCOVID19deaths
}


drop if CountryCode==""
ren countryid CountryName
merge 1:1 CountryCode using "$dir\analysis\dta\new rates of increase in norm_covid_mr and overall_mr and gdp.dta"

graph hbar (asis) frac_COVIDdeathsforagesunder50 frac_COVID19deathsforages5059 frac_COVID19deathsforages6069 frac_COVID19deathsforages7079 frac_COVID19deathsforages80 ///
	, over(country, label(labsize(small)) sort(YR2018)) stack ///
	plotregion(lcolor(none)) ///
	nofill ///
	scheme(burd4) ///
	ytitle("") ytick(, grid glpattern(solid) glwidth(vvthin)) ///
	ylabel(0 "0" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%" .6 "60%" .7 "70%" .8 "80%" .9 "90%" 1 "100%") ///
	legend(order (1 "Under 50" 2 "50-59" 3 "60-69" 4 "70-79" 5 "80+") rows(1) pos(6) size(small)) ///
	title("Share of COVID deaths by age", size(medium) pos(12) span) 
graph export "fig1.emf", as(emf) replace

********************************************************************************
********************************** END OF FILE *********************************