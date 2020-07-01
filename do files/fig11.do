********************************************************************************
* ABOUT THIS .DO FILE: This do file produces figure 11.
* BY: Ann Jillian Adona (aadona@worldbank.org)		
* DATE: June 27, 2020 	
* DATA SOURCE: "Tables.xlsx"
* Data file names have not been changed. 
********************************************************************************
import excel "Tables.xlsx", sheet("Sheet2") cellrange(A1:F29) firstrow clear

drop if CountryCode==""

format Dateof100thdeath %td

ren countryid Country
encode Country, gen(countryid)

separate Rateofincreasebyageofcovid, by(income)

xtset countryid Dateof100thdeath, daily

tw 	(scatter Rateofincreasebyageofcovid1 Dateof100thdeath, mlabel(CountryCode) mlabpos(9)) ///
	(scatter Rateofincreasebyageofcovid2 Dateof100thdeath, mlabel(CountryCode) mlabpos(9)) ///
	, xlabel(21975 22006 22036 22067, format(%tdmd) labsize(small)) xtitle("Date of 100th death", size(small)) xsc(extend) ylabel(, labsize(small)) ytitle("Rate of increase in COVID-19 mortality rate", size(small)) plotregion(lcolor(black)) title("Rates of Increase per Year of Age in COVID-19 Mortality" "vs. Timing of COVID-19", size(medium) span) ///
	legend(off)
graph export "fig11.emf", as(emf) replace

********************************************************************************
********************************** END OF FILE *********************************