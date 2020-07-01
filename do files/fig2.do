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

* Retrieve tables containing Share of COVID-19 deaths by age and Share of population by age:
tempfile covid popn

import excel "Tables.xlsx", sheet("Share of COVID-19 deaths by age") firstrow clear
save "`covid'", replace

import excel "Tables.xlsx", sheet("Share of population by age") firstrow clear
save "`popn'", replace

* Merge into one dataset:
clear
append using "`covid'"
merge 1:1 countryid CountryCode using "`popn'"
drop _merge

drop if CountryCode==""

encode countryid, gen(country)
g income=""
replace income="HIC" if inlist(country, 5, 25, 17, 26, 8, 16, 10, 21, 11, 24, 9, 3, 12, 22, 6, 13, 26)
replace income="U/LMIC" if inlist(country, 1, 2, 4, 7, 14, 20, 19, 18, 15, 23)

* Generate base variables containing average age structure for high-income countries
local vars "frac_Populationunderage50 frac_Populationaged5059 frac_Populationaged6069 frac_Populationaged7079 frac_Populationaged80"
foreach v of local vars {
	egen ave_`v' =mean(`v') if income=="HIC"
	gsort income
	carryforward ave_`v', replace
}

sort countryid

* Generate each country's mortality rates by age:
g mr_under50=COVID19deathsforagesunder5/Populationunderage50
g mr_5059=COVID19deathsforages5059/Populationaged5059
g mr_6069=COVID19deathsforages6069/Populationaged6069
g mr_7079=COVID19deathsforages7079/Populationaged7079
g mr_80=COVID19deathsforages80/Populationaged80

local vars "ave_frac_Populationunderage50 ave_frac_Populationaged5059 ave_frac_Populationaged6069 ave_frac_Populationaged7079 ave_frac_Populationaged80"
foreach v of local vars {
	g b_`v'=`v'*100000000
}

***************
* Apply each country's COVID-19 mortality rates by age to base population
g covidmr_basepop_under50= mr_under50 * b_ave_frac_Populationunderage50
g covidmr_basepop_5059= mr_5059 * b_ave_frac_Populationaged5059
g covidmr_basepop_6069= mr_6069 * b_ave_frac_Populationaged6069
g covidmr_basepop_7079= mr_7079 * b_ave_frac_Populationaged7079
g covidmr_basepop_80= mr_80 * b_ave_frac_Populationaged80

* Given new deaths by age, generate new total deaths per country:
egen totalnewdeaths=rowtotal(covidmr_basepop_under50 covidmr_basepop_5059 covidmr_basepop_6069 covidmr_basepop_7079 covidmr_basepop_80)

* Generate new shares of death by age:
g newfrac_covid_under50	=covidmr_basepop_under50 / totalnewdeaths
g newfrac_covid_5059 =covidmr_basepop_5059 / totalnewdeaths
g newfrac_covid_6069 =covidmr_basepop_6069 / totalnewdeaths
g newfrac_covid_7079 =covidmr_basepop_7079 / totalnewdeaths 
g newfrac_covid_80 =covidmr_basepop_80 / totalnewdeaths 

drop if CountryCode==""
ren countryid CountryName
merge 1:1 CountryCode using "rates of increase in norm_covid_mr and overall_mr and gdp.dta", force

graph hbar (asis) newfrac_covid_under50 newfrac_covid_5059 newfrac_covid_6069 newfrac_covid_7079 newfrac_covid_80 ///
	, over(country, label(labsize(small)) sort(YR2018)) stack ///
	plotregion(lcolor(none)) ///
	nofill ///
	scheme(burd4) ///
	ytitle("") ytick(, grid glpattern(solid) glwidth(vvthin)) ///
	ylabel(0 "0" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%" .6 "60%" .7 "70%" .8 "80%" .9 "90%" 1 "100%", labsize(small)) ///
	legend(order (1 "Under 50" 2 "50-59" 3 "60-69" 4 "70-79" 5 "80+") rows(1) pos(6) size(small)) ///
	title("Share of COVID deaths by age, base country: HICs", size(medium) pos(12) span) 
graph export "fig2.emf", as(emf) replace

********************************************************************************
********************************** END OF FILE *********************************