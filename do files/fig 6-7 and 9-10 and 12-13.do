********************************************************************************
* ABOUT THIS .DO FILE: This do file contains codes to run figures 6-7, 9-10, 12-13.
* BY: Ann Jillian Adona (aadona@worldbank.org)		
* DATE: June 22, 2020 	
* DATA SOURCES: "rates of increase in norm_covid_mr and overall_mr and gdp.dta"
* Data file names have not been changed. 
********************************************************************************

use "rates of increase in norm_covid_mr and overall_mr and gdp.dta", clear

* Figure 6. Rate of Increase per Year of Age in COVID-19 Mortality Rate
graph hbar (asis) covid_beta1 covid_beta2 ///
	, over(country, label(labsize(small)) sort(YR2018)) ///
	plotregion(lcolor(black)) ///
	nofill ///
	ytitle("") ///
	title("Percent Rate of Increase per Year of Age in COVID-19 Mortality Rate", size(medium) pos(12) span) ///
	bar(1, bfcolor(navy)) ///
	legend(off)
graph export "fig6.emf", as(emf) replace

* Figure 7: Rates of Increase per Year of Age in COVID-19 Mortality vs. GDP per Capita
tw 	(scatter covid_beta1 YR2018 if YR2018>=4000, mlabel(CountryCode)) ///
	(scatter covid_beta2 YR2018 if YR2018>=4000, mlabel(CountryCode)) ///
	, ylabel(, labsize(small)) ytitle("Rate of increase in COVID-19 mortality rate", size(small)) ///
	xscale(log) xtitle("GDP per capita, 2018", size(small)) xlabel(5000 10000 50000 100000, labsize(vsmall)) ///
	plotregion(lcolor(black)) ///
	title("Rates of Increase per Year of Age in COVID-19 Mortality" "vs. GDP per Capita", size(medium) span) ///
	legend(off)
graph export "fig7.emf", as(emf) replace

* Figure 9: Rates of Increase per Year of Age in COVID-19 Mortality vs. Rate of Increase per Year of Age in All-Cause Mortality by Country
tw 	(scatter covid_beta1 overall_beta, mlabel(CountryCode) mlabpos(9) ytitle("Rate of increase in COVID-19 mortality rate", size(small)) ylabel(, labsize(small))) ///
	(scatter covid_beta2 overall_beta, mlabel(CountryCode) mlabpos(9) ytitle("Rate of increase in COVID-19 mortality rate", size(small)) ylabel(, labsize(small))) ///
	, xtitle("Rate of increase in all-cause mortality rate", size(small)) xlabel(, labsize(small)) ///
	plotregion(lcolor(black)) ///
	title("Rates of Increase per Year of Age in COVID-19 Mortality" "vs. All Mortality by Country", size(medium) span) ///
	legend(off)
graph export "fig9.emf", as(emf) replace

********************************************************************************
* Add hospital beds per country:
import excel "WDI_hospital beds.xlsx", sheet("Data") firstrow clear

drop if CountryCode==""
reshape long YR, i(SeriesName SeriesCode CountryName CountryCode) j(year)
ren YR med_beds

destring med_beds, force replace
bysort CountryCode (year): carryforward med_beds, gen(med_beds1) cfindic(tag)

by CountryCode: egen lastdata = max(cond(med_beds!=., year, .))

keep if year==2019 & med_beds1!=.

order CountryCode CountryName lastdata med_beds1
keep CountryName med_beds1
label var med_beds1 "Hospital beds per 1,000 people"

g med_beds=med_beds1/1000
label var med_beds "Hospital beds per capita"

merge 1:1 CountryName using "rates of increase in norm_covid_mr and overall_mr and gdp.dta", gen(merge_hosp)

keep if merge_hosp==3
drop merge_hosp 

* Figure 12: Rates of Increase per Year of Age in COVID-19 Mortality vs. Hospital Beds per 1000 People by Country
tw 	(scatter covid_beta1 med_beds1, ///
	mlabel(CountryCode)) ///
	(scatter covid_beta2 med_beds1, ///
	mlabel(CountryCode)) ///
	, ylabel(, labsize(small)) ytitle("Rate of increase in COVID-19 mortality rate", size(small)) ///
	xlabel(`xla', labsize(small)) xtitle(, size(small)) ///
	plotregion(lcolor(black)) ///
	title("Rates of Increase per Year of Age in COVID-19 Mortality" "vs. Hospital Beds per 1,000 people", size(medium) span) ///
	legend(off)
graph export "$dir\analysis\graphs\git\fig12.emf", as(emf) replace

save "$dir\analysis\dta\rates of increase in norm_covid_mr and overall_mr and gdp and hosp.dta", replace

********************************************************************************
* Import Vital Statistics Performance Index data from worksheet:
import excel "Vital statistics performance index.xlsx", sheet("Sheet1") firstrow clear

clonevar CountryName=Country
replace CountryName="Korea, Rep." if Country=="South Korea"
drop Country

merge 1:1 CountryName using "$dir\analysis\dta\new rates of increase in norm_covid_mr and overall_mr and gdp.dta", gen(_mergevspi)
keep if _mergevspi==3

replace VSperformanceindex="0.1" if CountryName=="Pakistan"
destring VSperformanceindex, replace

* Figure 10: Rates of Increase per Year of Age in COVID-19 Mortality vs. Vital Statistics Performance Index by Country
tw 	(scatter covid_beta1 VSperformanceindex, mlabel(CountryCode) mlabpos(3)) ///
	(scatter covid_beta2 VSperformanceindex, mlabel(CountryCode) mlabpos(3)) ///
	, ylabel(, labsize(small)) ///
	ytitle("COVID-19 mortality rate") ylabel(, labsize(small)) ytitle("Rate of increase in COVID-19 mortality rate", size(small)) ///
	xtitle("VItal Statistics Performance Index", size(small)) xlabel(, labsize(small)) ///
	plotregion(lcolor(black)) ///
	title("Rates of Increase per Year of Age in COVID-19 Mortality" "vs. Vital Statistics Performance Index by Country", size(medium) span) ///
	legend(off)
graph export "fig10.emf", as(emf) replace

********************************************************************************
* Add medical doctors per country:
import delimited using "HWF_0001,HWF_0002,HWF_0003,HWF_0004,HWF_0005.csv", clear

g doctorspercapita=medicaldoctorsper10000population/10000
g doctorsper000popn=doctorspercapita*1000

bysort country: egen lastdata = max(cond(doctorsper000popn!=., year, .))

keep if year==lastdata

clonevar CountryName=country
replace CountryName="Korea, Rep." if country=="Republic of Korea"
drop country

merge 1:1 CountryName using "rates of increase in norm_covid_mr and overall_mr and gdp.dta"
keep if _merge==3

* Figure 13: Rates of Increase per Year of Age in COVID-19 Mortality vs. Doctors per 1000 People by Country
tw 	(scatter covid_beta1 doctorsper000popn, mlabel(CountryCode) mlabpos(9)) ///
	(scatter covid_beta2 doctorsper000popn, mlabel(CountryCode) mlabpos(9)) ///
	, ytitle("Rate of increase in COVID-19 mortality rate", size(small)) ylabel(, labsize(small)) ///
	xlabel(, labsize(small)) xtitle("Medical doctors per 1,000 people", size(small)) ///
	plotregion(lcolor(black)) ///
	title("Rates of Increase per Year of Age in COVID-19 Mortality" "vs. Doctors per 1,000 People", size(medium) span) ///
	legend(off)
graph export "fig13.emf", as(emf) replace

********************************************************************************
********************************** END OF FILE *********************************