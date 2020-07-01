********************************************************************************
* ABOUT THIS .DO FILE: This do file regresses the normalized COVID-19 mortality rate against ages to get the rate of increase by age of COVID-19.
* BY: Ann Jillian Adona (aadona@worldbank.org)		
* DATE: May 22, 2020 	
* DATA SOURCES: "norm and raw covid_mr.dta"
* API_NY.GDP.PCAP.CD_DS2_en_csv_v2_1210407.csv from https://data.worldbank.org/indicator/NY.GDP.PCAP.CD
* Data file names have not been changed. 
********************************************************************************
disp "$S_TIME  $S_DATE"

* Set scheme:
set scheme s2color
grstyle init
grstyle set plain

* Set wd:
cd "$dir"

use "norm and raw covid_mr.dta", clear

drop if agex<40

* Best-of-fit lines for each country:
g ln_norm_covid_mr=ln(norm_covid_mr)

levelsof country
foreach l in `r(levels)' {
	reg ln_norm_covid_mr agex if country==`l'
	mat covid_beta_`l'=e(b)
	svmat double covid_beta_`l', names(matcol)
}

forval l=1/26 {
	carryforward covid_beta_`l'agex, replace
	carryforward covid_beta_`l'_cons, replace
}

g covid_beta=.
g covid_cons=.

forval l=1/26 {
	replace covid_beta=covid_beta_`l'agex if country==`l'
	replace covid_cons= covid_beta_`l'_cons if country==`l'
}

drop covid_beta_*

decode country, gen(CountryName)

collapse (mean) covid_beta covid_cons, by(CountryName)

label var covid_beta "covid_beta"
label var covid_cons "covid_cons"

* Merge with all-cause mortality betas:
merge 1:1 CountryName using "overall_mr_betas.dta"

label var overall_beta "overall_beta"
label var overall_cons "overall_cons"

drop _merge
g country=CountryName

* Save collapsed data (country beta cons)
save "norm_covid_mr and overall_mr betas.dta", replace

********************************************************************************
clear

import delimited "API_NY.GDP.PCAP.CD_DS2_en_csv_v2_1210407.csv", varnames(1) encoding(UTF-8) rowrange(5) clear

ren v63 YR2018
ren datasource CountryName
ren worlddevelopmentindicators CountryCode
drop if v3=="Indicator Name"

keep CountryName CountryCode YR2018

g country=CountryName
replace country="Republic of Korea" if CountryName=="Korea, Rep."

merge 1:1 country using "norm_covid_mr and overall_mr betas.dta"
keep if _merge==3
drop _merge

drop country
encode CountryName, gen(country)

g income=""
replace income="HIC" if inlist(country, 5, 25, 17, 26, 8, 10, 11, 24, 9, 3, 12, 22, 13, 26, 14, 18, 6)
replace income="U/LMIC" if inlist(country, 1, 2, 4, 7, 20, 19, 15, 23, 21, 16)

separate covid_beta, by(income)

* Save data file (as long):
save "rates of increase in norm_covid_mr and overall_mr and gdp.dta", replace

********************************************************************************
********************************** END OF FILE *********************************