********************************************************************************
* ABOUT THIS .DO FILE: This do file takes the UN's abridged life tables to generate non-covid (overall) mortality rates by age groups for several countries and produces charts.
* BY: Ann Jillian Adona (aadona@worldbank.org)		
* DATE: May 14, 2020 	
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

********************************************************************************
********* Figure 8: All-Cause Mortality Rates by Age Group and Country *********
gsort -Agex -Probabilityofdyingqxn

tw ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Afghanistan") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="South Africa") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Pakistan") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Philippines") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Malaysia") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Hungary") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Argentina") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Mexico") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Peru") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Brazil") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Denmark") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Colombia") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Germany") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Chile") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Netherlands") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Portugal") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Norway") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Republic of Korea") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Sweden") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Italy") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Canada") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Spain") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Australia") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Switzerland") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="France") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Japan") ///
	if Agex>=30 & Agex<=80 ///
	, xsc(range(30 80)) xlabel(, labsize(small)) xtitle("Age group", size(small) margin(top)) ///
	ylabel(, labsize(small)) ytitle("COVID-19 mortality rate") ///
	plotregion(lcolor(black)) ///
	legend(all order(1 "Afghanistan" 2 "South Africa" 3 "Pakistan" 4 "Philippines" 5 "Malaysia" 6 "Hungary" 7 "Argentina" 8 "Mexico" 9 "Peru" 10 "Brazil" 11 "Denmark" 12 "Colombia" 13 "Germany" 14 "Chile" 15 "Netherlands" 16 "Portugal" 17 "Norway" 18 "Republic of Korea" 19 "Sweden" 20 "Italy" 21 "Canada" 22 "Spain" 23 "Australia" 24 "Switzerland" 25 "France" 26 "Japan") size(small) symxsize(1pt) symysize(1pt) symplacement(9) cols(1) pos(3)) ///
	title("Overall Mortality Rates by Age Group and Country", size(mediumlarge) span)
graph export "$dir\analysis\graphs\UN_figa.emf", as(emf) replace

niceloglabels Probabilityofdyingqxn, local(yla) style(1)
tw ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Afghanistan") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="South Africa") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Pakistan") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Philippines") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Malaysia") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Hungary") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Argentina") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Mexico") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Peru") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Brazil") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Denmark") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Colombia") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Germany") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Chile") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Netherlands") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Portugal") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Norway") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Republic of Korea") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Sweden") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Italy") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Canada") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Spain") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Australia") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Switzerland") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="France") ///
	(line Probabilityofdyingqxn Agex if Regionsubregioncountryorar=="Japan") ///
	if Agex>=30 & Agex<=80 ///
	, xsc(range(30 80)) xlabel(, labsize(small)) xtitle("Age group", size(small) margin(top)) ///
	ylabel(`yla', labsize(small)) ytitle("COVID-19 mortality rate") ysc(log) ///
	plotregion(lcolor(black)) ///
	legend(all order(1 "Afghanistan" 2 "South Africa" 3 "Pakistan" 4 "Philippines" 5 "Malaysia" 6 "Hungary" 7 "Argentina" 8 "Mexico" 9 "Peru" 10 "Brazil" 11 "Denmark" 12 "Colombia" 13 "Germany" 14 "Chile" 15 "Netherlands" 16 "Portugal" 17 "Norway" 18 "Republic of Korea" 19 "Sweden" 20 "Italy" 21 "Canada" 22 "Spain" 23 "Australia" 24 "Switzerland" 25 "France" 26 "Japan") size(small) symxsize(1pt) symysize(1pt) symplacement(9) cols(1) pos(3)) ///
	title("Overall Mortality Rates by Age Group and Country", size(mediumlarge) span)
graph export "$dir\analysis\graphs\UN_figb.emf", as(emf) replace

********************************************************************************
********************************** END OF FILE *********************************