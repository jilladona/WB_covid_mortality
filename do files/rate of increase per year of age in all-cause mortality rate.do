********************************************************************************
* ABOUT THIS .DO FILE: This do file takes the UN's abridged life tables to generate all-cause mortality rates by age groups for several countries, and computes the rate of increase per year of age in all-cause mortality.
* BY: Ann Jillian Adona (aadona@worldbank.org)		
* DATE: June 14, 2020 	
* DATA SOURCE: https://population.un.org/wpp/Download/Files/1_Indicators%20(Standard)/EXCEL_FILES/3_Mortality/WPP2019_MORT_F17_1_ABRIDGED_LIFE_TABLE_BOTH_SEXES.xlsx
* Data file names have not been changed. 
********************************************************************************

disp "$S_TIME  $S_DATE"

global dir "WB_covid_mortality"
cd "$dir"

* Set scheme:
set scheme s2color
grstyle init
grstyle set plain

* Import data:
import excel "WPP2019_MORT_F17_1_ABRIDGED_LIFE_TABLE_BOTH_SEXES.xlsx", sheet("MEDIUM 2020-2050") cellrange(A17:T33173) firstrow clear

keep if Type=="Country/Area"
keep if Period=="2020-2025"

local vars "Centraldeathratemxn Probabilityofdyingqxn Probabilityofsurvivingpxn Numberofsurvivorslx Numberofdeathsdxn NumberofpersonyearslivedLx SurvivalratioSxn PersonyearslivedTx Expectationoflifeex Averagenumberofyearsliveda"
foreach v of local vars {
	destring `v', replace force
}

* Tag countries in our sample:
g tag=0
local countries "Afghanistan Argentina Australia Brazil Canada Chile Colombia Denmark France Germany Hungary Italy Japan Malaysia Mexico Netherlands Norway Pakistan Peru Philippines Portugal Spain Sweden Switzerland"
foreach c of local countries {
	replace tag=1 if Regionsubregioncountryorar=="`c'"
}
replace tag=1 if Regionsubregioncountryorar=="Republic of Korea"
replace tag=1 if Regionsubregioncountryorar=="South Africa"

* Drop countries not in our sample: 
drop if tag!=1

ren Regionsubregioncountryorar CountryName
encode CountryName, gen(countryid)

g ln_overall_mr=ln(Probabilityofdyingqxn)

drop if Agex<40 
drop if Agex>90

levelsof countryid
foreach l in `r(levels)' {
	reg ln_overall_mr Agex if countryid==`l'
	mat overall_beta_`l'=e(b)
	svmat double overall_beta_`l', names(matcol)
}

forval l=1/26 {
	carryforward overall_beta_`l'Agex, replace
	carryforward overall_beta_`l'_cons, replace
}

g overall_beta=.
g overall_cons=.

forval l=1/26 {
	replace overall_beta=overall_beta_`l'Agex if countryid==`l'
	replace overall_cons= overall_beta_`l'_cons if countryid==`l'
}

drop overall_beta_*

collapse (mean) overall_beta overall_cons, by(CountryName)

********************************************************************************

* Save data file (as long):
save "overall_mr_betas.dta", replace

********************************************************************************
********************************** END OF FILE *********************************