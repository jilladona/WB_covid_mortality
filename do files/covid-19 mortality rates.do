********************************************************************************
* ABOUT THIS .DO FILE: This do file compiles COVID-19 and non-covid mortality rates by age for several countries.
* BY: Ann Jillian Adona (aadona@worldbank.org)		
* DATE: May 21, 2020 	
* DATA SOURCE: "Covid deaths by age.xlsx"
* Data file names have not been changed. 
* This do file takes off from the worksheet "Covid deaths by age and sex_06162020.xlsx" which contains countries' data on COVID-19 deaths by age, collected from various sources. The worksheet already applies the adjustment factor for ages 80 plus.
********************************************************************************
disp "$S_TIME  $S_DATE"

* Set wd:
global dir "WB_covid_mortality"
cd "$dir"

* Import (normalized) COVID-19 death rates by age:
import excel "Covid death rates by age and sex_06162020.xlsx", sheet("COVID death by age ALL (norm)") cellrange(A26:AD36) firstrow clear

* Housekeeping:
drop A
ren C agex

qui {
	ren D mr_1
	ren E mr_2
	ren F mr_3
	ren G mr_4
	ren H mr_5
	ren I mr_6
	ren J mr_7
	ren K mr_8
	ren L mr_9
	ren M mr_10
	ren N mr_11
	ren O mr_12
	ren P mr_13
	ren Q mr_14
	ren R mr_15
	ren S mr_16
	ren T mr_17
	ren U mr_18
	ren V mr_19
	ren W mr_20
	ren X mr_21
	ren Y mr_22
	ren Z mr_23
	ren AA mr_24
	ren AB mr_25
	ren AC mr_26
	ren AD mr_27
}


* Reshape data to long:
reshape long mr_, i(agex) j(cty)
ren mr_ norm_covid_mr
tostring cty, gen(countryname)

qui {
	replace countryname="Spain" if cty==1
	replace countryname="France" if cty==2
	replace countryname="Italy" if cty==3
	replace countryname="Republic of Korea" if cty==4
	replace countryname="Philippines" if cty==5
	replace countryname="Pakistan" if cty==6
	replace countryname="Peru" if cty==7
	replace countryname="Brazil" if cty==8
	replace countryname="Mexico" if cty==9
	replace countryname="Argentina" if cty==10
	replace countryname="Colombia" if cty==11
	replace countryname="South Africa" if cty==12
	replace countryname="Malaysia" if cty==13
	replace countryname="Portugal" if cty==14
	replace countryname="Norway" if cty==15
	replace countryname="Denmark" if cty==16
	replace countryname="Japan" if cty==17
	replace countryname="Ukraine" if cty==18
	replace countryname="Chile" if cty==19
	replace countryname="Netherlands" if cty==20
	replace countryname="Germany" if cty==21
	replace countryname="Sweden" if cty==22
	replace countryname="Australia" if cty==23
	replace countryname="Hungary" if cty==24
	replace countryname="Switzerland" if cty==25
	replace countryname="Canada" if cty==26
	replace countryname="Afghanistan" if cty==27
}

destring agex, replace force
drop if agex==.
ren All agegroup
destring norm_covid_mr, replace force

replace agex=1 if agex==0

encode countryname, gen(country)

* Save data file (as long):
save "covid_mr.dta", replace

* Add raw mortality rates:
* Import (raw) COVID-19 death rates by age:
import excel "Covid death rates by age and sex_06162020.xlsx", sheet("COVID death by age ALL (raw)") cellrange(A26:AD36) firstrow clear

* Housekeeping:
drop A
ren C agex

qui {
	ren D mr_1
	ren E mr_2
	ren F mr_3
	ren G mr_4
	ren H mr_5
	ren I mr_6
	ren J mr_7
	ren K mr_8
	ren L mr_9
	ren M mr_10
	ren N mr_11
	ren O mr_12
	ren P mr_13
	ren Q mr_14
	ren R mr_15
	ren S mr_16
	ren T mr_17
	ren U mr_18
	ren V mr_19
	ren W mr_20
	ren X mr_21
	ren Y mr_22
	ren Z mr_23
	ren AA mr_24
	ren AB mr_25
	ren AC mr_26
	ren AD mr_27
}

* Reshape data to long:
reshape long mr_, i(agex) j(cty)
ren mr_ raw_covid_mr
tostring cty, gen(countryname)

qui {
	replace countryname="Spain" if cty==1
	replace countryname="France" if cty==2
	replace countryname="Italy" if cty==3
	replace countryname="Republic of Korea" if cty==4
	replace countryname="Philippines" if cty==5
	replace countryname="Pakistan" if cty==6
	replace countryname="Peru" if cty==7
	replace countryname="Brazil" if cty==8
	replace countryname="Mexico" if cty==9
	replace countryname="Argentina" if cty==10
	replace countryname="Colombia" if cty==11
	replace countryname="South Africa" if cty==12
	replace countryname="Malaysia" if cty==13
	replace countryname="Portugal" if cty==14
	replace countryname="Norway" if cty==15
	replace countryname="Denmark" if cty==16
	replace countryname="Japan" if cty==17
	replace countryname="Ukraine" if cty==18
	replace countryname="Chile" if cty==19
	replace countryname="Netherlands" if cty==20
	replace countryname="Germany" if cty==21
	replace countryname="Sweden" if cty==22
	replace countryname="Australia" if cty==23
	replace countryname="Hungary" if cty==24
	replace countryname="Switzerland" if cty==25
	replace countryname="Canada" if cty==26
	replace countryname="Afghanistan" if cty==27
}

destring agex, replace force
drop if agex==.
ren All agegroup
destring raw_covid_mr, replace force

replace agex=1 if agex==0

encode countryname, gen(country)

* Merge with previous dataset:
merge 1:1 countryname agex using "covid_mr.dta", gen(_merge1)

drop if countryname=="Ukraine"

keep agegroup agex country cty raw_covid_mr norm_covid_mr
order agegroup agex country cty raw_covid_mr norm_covid_mr

label var country "Country"
label var agegroup "Age group"
label var norm_covid_mr "Normalized COVID-19 mortality rate"
label var raw_covid_mr "COVID-19 mortality rate"

* Save data file (as long):
save "norm and raw covid_mr.dta", replace

********************************************************************************
********************************** END OF FILE *********************************