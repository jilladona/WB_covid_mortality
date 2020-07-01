********************************************************************************
* ABOUT THIS .DO FILE: This do file takes the UN's population tables to generate standard mortality rates by the age group 80+.
* BY: Ann Jillian Adona (aadona@worldbank.org)		
* DATE: June 7, 2020	
* DATA SOURCES: https://population.un.org/wpp/Download/Files/1_Indicators%20(Standard)/EXCEL_FILES/3_Mortality/WPP2019_MORT_F17_2_ABRIDGED_LIFE_TABLE_MALE.xlsx https://population.un.org/wpp/Download/Files/1_Indicators%20(Standard)/EXCEL_FILES/3_Mortality/WPP2019_MORT_F17_3_ABRIDGED_LIFE_TABLE_FEMALE.xlsx https://population.un.org/wpp/Download/Files/1_Indicators%20(Standard)/EXCEL_FILES/1_Population/WPP2019_POP_F07_2_POPULATION_BY_AGE_MALE.xlsx https://population.un.org/wpp/Download/Files/1_Indicators%20(Standard)/EXCEL_FILES/1_Population/WPP2019_POP_F07_3_POPULATION_BY_AGE_FEMALE.xlsx
* Data file names have not been changed. 
********************************************************************************

disp "$S_TIME  $S_DATE"

global dir "WB_covid_mortality"
cd "$dir"

*** These work on the mortality data ***
tempfile sM_males sM_females

* Import data for males:
import excel "WPP2019_MORT_F17_2_ABRIDGED_LIFE_TABLE_MALE.xlsx", sheet("MEDIUM 2020-2050") cellrange(A17:T33173) firstrow clear

keep if Type=="Country/Area"
keep if Period=="2020-2025"

destring Probabilityofdyingqxn, replace force

ren Regionsubregioncountryorar countryname
ren Probabilityofdyingqxn sM_males
keep countryname Agex sM_males

reshape wide sM_males, i(countryname) j(Agex)

drop sM_males0 sM_males100
ren sM_males1 sM_males0

* Save temporary data file (as wide):
save `sM_males.dta', replace

* Import data for females:
import excel "WPP2019_MORT_F17_3_ABRIDGED_LIFE_TABLE_FEMALE.xlsx ", sheet("MEDIUM 2020-2050") cellrange(A17:T33173) firstrow clear

keep if Type=="Country/Area"
keep if Period=="2020-2025"

destring Probabilityofdyingqxn, replace force

ren Regionsubregioncountryorar countryname
ren Probabilityofdyingqxn sM_females
keep countryname Agex sM_females

reshape wide sM_females, i(countryname) j(Agex)

drop sM_females0 sM_females100
ren sM_females1 sM_females0

* Save temporary data file (as wide):
save `sM_females', replace

merge 1:1 countryname using `sM_males'
drop _merge

* Save data file (as wide):
save "sM_mf.dta", replace
********************************************************************************
*** These work on the population data ***
tempfile popn_males popn_females

* Import data:
import excel "WPP2019_POP_F07_2_POPULATION_BY_AGE_MALE.xlsx", sheet("ESTIMATES") cellrange(A17:AC3842) firstrow clear

keep if Type=="Country/Area"
keep if Referencedateasof1July==2020

ren I males_agegrp0
ren J males_agegrp5
ren K males_agegrp10
ren L males_agegrp15
ren M males_agegrp20
ren N males_agegrp25
ren O males_agegrp30
ren P males_agegrp35
ren Q males_agegrp40
ren R males_agegrp45
ren S males_agegrp50
ren T males_agegrp55
ren U males_agegrp60
ren V males_agegrp65
ren W males_agegrp70
ren X males_agegrp75
ren Y males_agegrp80
ren Z males_agegrp85
ren AA males_agegrp90
ren AB males_agegrp95
ren AC males_agegrp100

local vars "males_agegrp0 males_agegrp5 males_agegrp10 males_agegrp15 males_agegrp20 males_agegrp25 males_agegrp30 males_agegrp35 males_agegrp40 males_agegrp45 males_agegrp50 males_agegrp55 males_agegrp60 males_agegrp65 males_agegrp70 males_agegrp75 males_agegrp80 males_agegrp85 males_agegrp90 males_agegrp95 males_agegrp100"
foreach v of local vars {
	destring `v', replace force
}

g countryname=Regionsubregioncountryorar

save `popn_males', replace

* Import data:
import excel "WPP2019_POP_F07_3_POPULATION_BY_AGE_FEMALE.xlsx", sheet("ESTIMATES") cellrange(A17:AC3842) firstrow clear

keep if Type=="Country/Area"
keep if Referencedateasof1July==2020

ren I females_agegrp0
ren J females_agegrp5
ren K females_agegrp10
ren L females_agegrp15
ren M females_agegrp20
ren N females_agegrp25
ren O females_agegrp30
ren P females_agegrp35
ren Q females_agegrp40
ren R females_agegrp45
ren S females_agegrp50
ren T females_agegrp55
ren U females_agegrp60
ren V females_agegrp65
ren W females_agegrp70
ren X females_agegrp75
ren Y females_agegrp80
ren Z females_agegrp85
ren AA females_agegrp90
ren AB females_agegrp95
ren AC females_agegrp100

local vars "females_agegrp0 females_agegrp5 females_agegrp10 females_agegrp15 females_agegrp20 females_agegrp25 females_agegrp30 females_agegrp35 females_agegrp40 females_agegrp45 females_agegrp50 females_agegrp55 females_agegrp60 females_agegrp65 females_agegrp70 females_agegrp75 females_agegrp80 females_agegrp85 females_agegrp90 females_agegrp95 females_agegrp100"
foreach v of local vars {
	destring `v', replace force
}

g countryname=Regionsubregioncountryorar

save `popn_females', replace

merge 1:1 countryname using `popn_males'
drop _merge

* Merge with population data:
merge 1:1 countryname using "sM_mf.dta"
drop _merge

* sM(80+, j) = sum( sM(x) * N(x, j) ) / sum( N(x, j) )
* sM(80+, j) = a/b
* a = sum( sM(x) * agegrp )
* b = sum( N(x, j) )

forval i = 80(5)95 {
	g males_a_`i' = males_agegrp`i' * sM_males`i'
	g females_a_`i' = females_agegrp`i' * sM_females`i'
}

egen males_a=rowtotal(males_a_*)
egen females_a=rowtotal(females_a_*)
egen males_b=rowtotal(males_agegrp80 males_agegrp85 males_agegrp90 males_agegrp95)
egen females_b=rowtotal(females_agegrp80 females_agegrp85 females_agegrp90 females_agegrp95)

g males_standard_sM80plus = males_a/males_b
g females_standard_sM80plus = females_a/females_b
g males_US_sM80plus=males_standard_sM80plus if countryname=="United States of America"
g females_US_sM80plus=females_standard_sM80plus if countryname=="United States of America"

carryforward males_US_sM80plus, replace
gsort males_US_sM80plus
carryforward males_US_sM80plus, replace

carryforward females_US_sM80plus, replace
gsort females_US_sM80plus
carryforward females_US_sM80plus, replace

* theta(j) =  sM(80+, USA) / sM(80+, j)
g males_theta=males_standard_sM80plus/males_US_sM80plus
g females_theta=females_standard_sM80plus/females_US_sM80plus

keep countryname males_standard_sM80plus males_theta females_standard_sM80plus females_theta

* Save data file:
save "sM_theta_mf.dta", replace

********************************************************************************
********************************** END OF FILE *********************************