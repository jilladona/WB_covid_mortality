********************************************************************************
* ABOUT THIS .DO FILE: This do file takes the UN's population tables to generate standard mortality rates by the age group 80+.
* BY: Ann Jillian Adona (aadona@worldbank.org)		
* DATE: May 29, 2020 	
* DATA SOURCES:  https://population.un.org/wpp/Download/Files/1_Indicators%20(Standard)/EXCEL_FILES/3_Mortality/WPP2019_MORT_F17_1_ABRIDGED_LIFE_TABLE_BOTH_SEXES.xlsx https://population.un.org/wpp/Download/Files/1_Indicators%20(Standard)/EXCEL_FILES/1_Population/WPP2019_POP_F07_1_POPULATION_BY_AGE_BOTH_SEXES.xlsx
* Data file names have not been changed. 
********************************************************************************

disp "$S_TIME  $S_DATE"

global dir "WB_covid_mortality"
cd "$dir"

* Import data:
import excel "WPP2019_MORT_F17_1_ABRIDGED_LIFE_TABLE_BOTH_SEXES.xlsx", sheet("MEDIUM 2020-2050") cellrange(A17:T33173) firstrow clear

keep if Type=="Country/Area"
keep if Period=="2020-2025"

destring Probabilityofdyingqxn, replace force

ren Regionsubregioncountryorar countryname
ren Probabilityofdyingqxn sM
keep countryname Agex sM

reshape wide sM, i(countryname) j(Agex)

drop sM0 sM100
ren sM1 sM0

* Save data file (as wide):
save "sM.dta", replace
********************************************************************************
* Import data:
import excel "WPP2019_POP_F07_1_POPULATION_BY_AGE_BOTH_SEXES.xlsx", sheet("ESTIMATES") cellrange(A17:AC3842) firstrow clear

keep if Type=="Country/Area"
keep if Referencedateasof1July==2020

ren I agegrp0
ren J agegrp5
ren K agegrp10
ren L agegrp15
ren M agegrp20
ren N agegrp25
ren O agegrp30
ren P agegrp35
ren Q agegrp40
ren R agegrp45
ren S agegrp50
ren T agegrp55
ren U agegrp60
ren V agegrp65
ren W agegrp70
ren X agegrp75
ren Y agegrp80
ren Z agegrp85
ren AA agegrp90
ren AB agegrp95
ren AC agegrp100

local vars "agegrp0 agegrp5 agegrp10 agegrp15 agegrp20 agegrp25 agegrp30 agegrp35 agegrp40 agegrp45 agegrp50 agegrp55 agegrp60 agegrp65 agegrp70 agegrp75 agegrp80 agegrp85 agegrp90 agegrp95 agegrp100"
foreach v of local vars {
	destring `v', replace force
}

g countryname=Regionsubregioncountryorar

* Merge with population data:
merge 1:1 countryname using "sM.dta"
drop _merge

* sM(80+, j) = sum( sM(x) * N(x, j) ) / sum( N(x, j) )
* sM(80+, j) = a/b
* a = sum( sM(x) * agegrp )
* b = sum( N(x, j) )

forval i = 80(5)95 {
	g a_`i' = agegrp`i' * sM`i'
}

egen a=rowtotal(a_*)
egen b=rowtotal(agegrp80 agegrp85 agegrp90 agegrp95)

g standard_sM80plus = a/b
g US_sM80plus=standard_sM80plus if countryname=="United States of America"

carryforward US_sM80plus, replace
gsort US_sM80plus
carryforward US_sM80plus, replace

* theta(j) =  sM(80+, USA) / sM(80+, j)
g theta=standard_sM80plus/US_sM80plus

keep countryname standard_sM80plus theta

* Save data file:
save "sM_theta.dta", replace

********************************************************************************
********************************** END OF FILE *********************************