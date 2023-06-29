* IV


* c)

clear 
use "data1940.dta"

*First Stages	

replace newbasesample=0 if country=="AUSTRIA" | country=="BANGLADESH" | country=="MALAYSIA" | country=="RUSSIAN FEDERATION" // Same sample as the second stage in the long differences. 
reg changelogpopulation changemortality if newbasesample==1  ,  cluster(ctrycluster)
eststo
reg changelogpopulation changemortality if newbasesample==1 & startrich~=1 ,  cluster(ctrycluster)
eststo

*Reduced form
use "data1940", clear

reg changepconflictCOW2 changemortality if newbasesample==1  ,  cluster(ctrycluster)
eststo
reg changepconflictCOW2 changemortality if newbasesample==1 & startrich~=1 ,  cluster(ctrycluster)
eststo

*Falsification
reg changepconflictCOW2_1900_40 changemortality if newbasesample==1 ,   cluster(ctrycluster)
eststo
reg changepconflictCOW2_1900_40 changemortality if  newbasesample==1 & startrich~=1 ,   cluster(ctrycluster)
eststo
reg changelogpopulation_1900_40 changemortality if newbasesample==1 ,   cluster(ctrycluster)
eststo
reg changelogpopulation_1900_40 changemortality if  newbasesample==1 & startrich~=1 ,   cluster(ctrycluster)
eststo

* d)

clear
use "data with conflict.dta"

* Panel A
xtivreg2 propconflictCOW2 yr1940- yr1980 (logmaddpop=compsjmhatit) if newsample40_COW==1 & (year==1940 | year==1980) ,   fe cluster(ctrycluster)
xtivreg propconflictCOW2 yr1940- yr1980 (logmaddpop=compsjmhatit) if newsample40_COW==1 & (year==1940 | year==1980) ,   fe

* Hausman
quietly xtreg logmaddpop compsjmhatit yr1940- yr1980 if newsample40_COW==1 & (year==1940 | year==1980), fe cluster(ctrycluster)
predict resid, e
xtreg propconflictCOW2 logmaddpop yr1940- yr1980 resid if newsample40_COW==1 & (year==1940 | year==1980), fe cluster(ctrycluster)
test resid
drop resid

foreach dep_var of varlist propconflictCOW2 propconflictU propconflictFL logdeathpop40U {
xtivreg2 `dep_var' yr1940- yr1980 (logmaddpop=compsjmhatit) if  newsample40==1 & (year==1940 | year==1980),   fe cluster(ctrycluster)

* Hausman
quietly xtreg logmaddpop compsjmhatit yr1940- yr1980 if newsample40_COW==1 & (year==1940 | year==1980), fe cluster(ctrycluster)
predict resid, ue
xtreg `dep_var' logmaddpop yr1940- yr1980 resid if newsample40_COW==1 & (year==1940 | year==1980), fe cluster(ctrycluster)
test resid
drop resid
}

* Panel B

foreach dep_var of varlist propconflictCOW2 propconflictU propconflictFL  logdeathpop40U {
xtivreg2 `dep_var' yr1940- yr1980 (logmaddpop=compsjmhatit) if  year>1930 & year<1990,   fe cluster(ctrycluster)

* Hausman
quietly xtreg logmaddpop compsjmhatit yr1940- yr1980 if newsample40_COW==1 & (year==1940 | year==1980), fe cluster(ctrycluster)
predict resid, ue
xtreg `dep_var' logmaddpop yr1940- yr1980 resid if newsample40_COW==1 & (year==1940 | year==1980), fe cluster(ctrycluster)
test resid
drop resid
}

* e)

*Panel A
clear
use "XTMexico.dta"
global geo "yr1960xCapital40 yr1960xCiudad40 yr1960xlandquality40"
global controls "yr1960xCapital40 yr1960xCiudad40 yr1960xlandquality40 yr1960xcorr_logpop40 yr1960xprimary_schooling40 yr1960xuniversity40 yr1960xbattles_centroid40 yr1960xshare_basin40 yr1960xshare_ind40"

xtivreg2 totalpcviolencia (corr_logpop=index_mean) dummy1-dummy32, fe first
gen sample1 = e(sample) 
eststo

xtivreg2 totalpcviolencia (corr_logpop=index_mean) dummy1-dummy32 $geo, fe
gen sample2 = e(sample)
eststo

xtivreg2 totalpcviolencia (corr_logpop=index_mean) dummy1-dummy32 $geo yr1960xcorr_logpop40, fe
gen sample3 = e(sample)
eststo

xtivreg2 totalpcviolencia (corr_logpop=index_mean) dummy1-dummy32 $geo yr1960xprimary_schooling40, fe
gen sample4 = e(sample)
eststo

xtivreg2 totalpcviolencia (corr_logpop=index_mean) dummy1-dummy32 $geo yr1960xuniversity40, fe
gen sample5 = e(sample)
eststo

xtivreg2 totalpcviolencia (corr_logpop=index_mean) dummy1-dummy32 $geo yr1960xbattles_centroid40, fe 
gen sample6 = e(sample)
eststo

xtivreg2 totalpcviolencia (corr_logpop=index_mean) dummy1-dummy32 $geo yr1960xshare_basin40, fe
gen sample7 = e(sample)
eststo

xtivreg2 totalpcviolencia (corr_logpop=index_mean) dummy1-dummy32 $geo yr1960xshare_ind40, fe
gen sample8 = e(sample)
eststo

xtivreg2 totalpcviolencia (corr_logpop=index_mean) dummy1-dummy32 $geo $controls, fe
gen sample9 = e(sample)
eststo

*Panel B
preserve
keep if sample1==1
acreg corr_logpop index_mean dummy1-dummy32, id(muncluster)  latitude(lat) spatial longitude(lon) dist(35.9512) time(year) pfe1(muncluster) 
restore
eststo

preserve
keep if sample2==1
acreg corr_logpop index_mean dummy1-dummy32 $geo, id(muncluster)  latitude(lat) spatial longitude(lon) dist(35.9512) time(year) pfe1(muncluster) 
restore
eststo

preserve
keep if sample3==1
acreg corr_logpop index_mean dummy1-dummy32 $geo yr1960xcorr_logpop40, id(muncluster)  latitude(lat) spatial longitude(lon) dist(35.9512) time(year) pfe1(muncluster) 
restore
eststo

preserve
keep if sample4==1
acreg corr_logpop index_mean dummy1-dummy32 $geo yr1960xprimary_schooling40, id(muncluster)  latitude(lat) spatial longitude(lon) dist(35.9512) time(year) pfe1(muncluster) 
restore
eststo

preserve
keep if sample5==1
acreg corr_logpop index_mean dummy1-dummy32 $geo yr1960xuniversity40, id(muncluster)  latitude(lat) spatial longitude(lon) dist(35.9512) time(year) pfe1(muncluster) 
restore
eststo

preserve
keep if sample6==1
acreg corr_logpop index_mean dummy1-dummy32 $geo yr1960xbattles_centroid40, id(muncluster)  latitude(lat) spatial longitude(lon) dist(35.9512) time(year) pfe1(muncluster) 
restore
eststo

preserve
keep if sample7==1
acreg corr_logpop index_mean dummy1-dummy32 $geo yr1960xshare_basin40, id(muncluster)  latitude(lat) spatial longitude(lon) dist(35.9512) time(year) pfe1(muncluster) 
restore
eststo

preserve
keep if sample8==1
acreg corr_logpop index_mean dummy1-dummy32 $geo yr1960xshare_ind40, id(muncluster)  latitude(lat) spatial longitude(lon) dist(35.9512) time(year) pfe1(muncluster) 
restore
eststo

preserve
keep if sample9==1
acreg corr_logpop index_mean dummy1-dummy32 $controls, id(muncluster)  latitude(lat) spatial longitude(lon) dist(35.9512) time(year) pfe1(muncluster) 
restore
eststo


*Panel C
preserve
keep if sample1==1
acreg totalpcviolencia corr_logpop dummy1-dummy32, id(muncluster)  latitude(lat) spatial longitude(lon) dist(35.9512) time(year) pfe1(muncluster) 
restore
eststo

preserve
keep if sample2==1
acreg totalpcviolencia corr_logpop dummy1-dummy32 $geo, id(muncluster)  latitude(lat) spatial longitude(lon) dist(35.9512) time(year) pfe1(muncluster) 
restore
eststo

preserve
keep if sample3==1
acreg totalpcviolencia corr_logpop dummy1-dummy32 $geo yr1960xcorr_logpop40, id(muncluster)  latitude(lat) spatial longitude(lon) dist(35.9512) time(year) pfe1(muncluster) 
restore
eststo

preserve
keep if sample4==1
acreg totalpcviolencia corr_logpop dummy1-dummy32 $geo yr1960xprimary_schooling40, id(muncluster)  latitude(lat) spatial longitude(lon) dist(35.9512) time(year) pfe1(muncluster) 
restore
eststo

preserve
keep if sample5==1
acreg totalpcviolencia corr_logpop dummy1-dummy32 $geo yr1960xuniversity40, id(muncluster)  latitude(lat) spatial longitude(lon) dist(35.9512) time(year) pfe1(muncluster) 
restore
eststo

preserve
keep if sample6==1
acreg totalpcviolencia corr_logpop dummy1-dummy32 $geo yr1960xbattles_centroid40, id(muncluster)  latitude(lat) spatial longitude(lon) dist(35.9512) time(year) pfe1(muncluster) 
restore
eststo

preserve
keep if sample7==1
acreg totalpcviolencia corr_logpop dummy1-dummy32 $geo yr1960xshare_basin40, id(muncluster)  latitude(lat) spatial longitude(lon) dist(35.9512) time(year) pfe1(muncluster) 
restore
eststo

preserve
keep if sample8==1
acreg totalpcviolencia corr_logpop dummy1-dummy32 $geo yr1960xshare_ind40, id(muncluster)  latitude(lat) spatial longitude(lon) dist(35.9512) time(year) pfe1(muncluster) 
restore
eststo

preserve
keep if sample9==1
acreg totalpcviolencia corr_logpop dummy1-dummy32 $controls, id(muncluster)  latitude(lat) spatial longitude(lon) dist(35.9512) time(year) pfe1(muncluster) 
restore
eststo
