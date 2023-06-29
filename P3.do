*P3
clear
use "final.dta"

*Geo controls
global geog "pop_res dp* tar_eff_lav deficit deficit_miss"
global geog2 "pop_res dp* deficit deficit_miss"
*Time effects
global time " year2000 year2001 year2002 year2003 year2004"
global time2 "year2000 year2001 year2002 year2003 year2004 year2005 year2007 year2008 year2009 year2010 post"
*Auctions 
global auction "starting_value starting_value2 obj_work_road obj_work_school obj_work_build obj_work_house obj_work_art direct_nego_gr"
global auction2 "starting_value starting_value2 obj_work_const obj_work_renov obj_work_road obj_work_plumb obj_work_ground obj_work_elect obj_work_plant obj_work_env obj_work_secu obj_work_other open_part_gr"
global auction3 "                               obj_work_road obj_work_school obj_work_build obj_work_house obj_work_art direct_nego_gr"
global auction4 "starting_value starting_value2 																		 direct_nego_gr"
global auction5 "obj_work_road obj_work_school obj_work_build obj_work_house obj_work_art"
*Mayor
global mayor "gender age born_prov born_prov_miss office_before empl_not empl_not_miss empl_high empl_high_miss empl_low empl_low_miss secondary secondary_miss college college_miss"
*Political
global electoral "tt_party_cont last_year_off centerright_gr centerleft_gr "
*Pre-determined car.
global predeter "NW NE CE SOU IS pop_census1991 alt extension gender age born_reg secondary college empl_not empl_low empl_medium empl_high"



* b)

* sample selection
reg reb_final n_firms_bid max_wins_std tt_cont ty_del term_limit mv_t $geog $time $auction $mayor $electoral if open_race==0 & number_rivals>0 & number_rivals!=. 
gen sample1=e(sample)
keep if sample1==1

drop if mv_t==0 & tt_cont==1

gen above=mv_t>=0 

egen group=cut(mv_t),  at(-80(1)80)
egen mv_t_grp=mean(group),by(group)

foreach var of varlist n_firms_bid reb_final winner_in_reg max_wins_std {
egen `var'_mean = mean(`var'), by(mv_t_grp)
}

*For presentational purposes
keep if mv_t>=-10 & mv_t<=10
keep if n_firms_bid_mean<30
gen mv_tXabove=mv_t*above

local nino "n_firms_bid reb_final winner_in_reg max_wins_std"

local i=1
foreach var of local nino{

if `i'== 1 {
 local svar "N. of bidders"
 local ylabel "16(2)26"
 }

else if `i'==2 {
 local svar "Winning rebate (%)"
 local ylabel "10(2)18"
}

else if `i'==3 {
 local svar "Winner local"
 local ylabel "0(0.25)1"
 }

else if `i'==4 {
 local svar "Max % wins same firm"
 local ylabel "0(0.25)1"
}


qui lowess `var' mv_t if above==0, gen(ciccio) nograph mean
qui lowess `var' mv_t if above==1, gen(ciccia) nograph mean

qui reg `var' mv_t mv_t2 mv_t3 if above==0
predict ciccio2, xb, if e(sample)

qui reg `var' mv_t mv_t2 mv_t3 if above==1
predict ciccia2, xb, if e(sample)


twoway (line ciccio mv_t if above==0 & mv_t<0, sort lcolor(blue)) /*
*/	   (line ciccia mv_t if above==1 & mv_t>=0, sort lcolor(red) ) /*
*/	   (line ciccio2 mv_t if above==0 & mv_t<0, sort lcolor(blue) lp(dash)) /*
*/	   (line ciccia2 mv_t if above==1 & mv_t>=0, sort lcolor(red) lp(dash)) /*
*/     (scatter `var'_mean mv_t_grp , msize(small) mlwidth(vthin) msymbol(circle_hollow) mcolor(gray)), /*
*/     ylabel(`ylabel') ytitle(`svar', size(medlarge)) /* 
*/     xtitle(Margin of victory, size(medlarge)) xline(0, lwidth(0.2) lcolor(black)) xscale(range(-10 10)) xlabel(-10 -5 0 5 10) /*
*/	   legend(label(1 "First term") label(2 "Higher term")  label(5 "Observed values") colgap(*3) width(100) order(1 2 5)) /*
*/     saving(Fig1_`var'.gph, replace) nodraw
drop ciccio* ciccia*

local i=`i'+1
}

gr combine Fig1_max_wins_std.gph
gr combine Fig1_n_firms_bid.gph
gr combine Fig1_reb_final.gph
gr combine Fig1_winner_in_reg.gph

************ example ******************************************
reg reb_final n_firms_bid max_wins_std tt_cont ty_del term_limit mv_t $geog $time $auction $mayor $electoral if open_race==0 & number_rivals>0 & number_rivals!=. 
gen sample1=e(sample)
keep if sample1==1

drop if mv_t==0 & tt_cont==1

gen above=mv_t>=0 

egen group=cut(mv_t),  at(-80(1)80)
egen mv_t_grp=mean(group),by(group)

foreach var of varlist n_firms_bid reb_final winner_in_reg max_wins_std {
egen `var'_mean = mean(`var'), by(mv_t_grp)
}

*For presentational purposes
keep if mv_t>=-10 & mv_t<=10
keep if n_firms_bid_mean<30
gen mv_tXabove=mv_t*above

local svar "N. of bidders"
local ylabel "16(2)26"


qui lowess n_firms_bid mv_t if above==0, gen(ciccio) nograph mean
qui lowess n_firms_bid mv_t if above==1, gen(ciccia) nograph mean

qui reg n_firms_bid mv_t mv_t2 mv_t3 if above==0
predict ciccio2, xb, if e(sample)

qui reg n_firms_bid mv_t mv_t2 mv_t3 if above==1
predict ciccia2, xb, if e(sample)


twoway /*
*/     (scatter n_firms_bid_mean mv_t_grp , msize(small) mlwidth(vthin) msymbol(circle_hollow) mcolor(gray)), /*
*/     ylabel(`ylabel') ytitle(`svar', size(medlarge)) /* 
*/     xtitle(Margin of victory, size(medlarge)) xline(0, lwidth(0.2) lcolor(black)) xscale(range(-10 10)) xlabel(-10 -5 0 5 10) /*
*/	   legend(label(1 "First term") label(2 "Higher term")  label(5 "Observed values") colgap(*3) width(100) order(1 2 5)) /*
*/     saving(points_n_firms_bid.gph, replace) nodraw

twoway (line ciccio2 mv_t if above==0 & mv_t<0, sort lcolor(blue) lp(dash)) /*
*/	   (line ciccia2 mv_t if above==1 & mv_t>=0, sort lcolor(red) lp(dash)) /*
*/     (scatter n_firms_bid_mean mv_t_grp , msize(small) mlwidth(vthin) msymbol(circle_hollow) mcolor(gray)), /*
*/     ylabel(`ylabel') ytitle("N. of bidders", size(medlarge)) /* 
*/     xtitle(Margin of victory, size(medlarge)) xline(0, lwidth(0.2) lcolor(black)) xscale(range(-10 10)) xlabel(-10 -5 0 5 10) /*
*/	   legend(label(1 "First term") label(2 "Higher term")  label(5 "Observed values") colgap(*3) width(100) order(1 2 5)) /*
*/     saving(tgpol_n_firms_bid.gph, replace) nodraw

twoway (line ciccio mv_t if above==0 & mv_t<0, sort lcolor(blue)) /*
*/	   (line ciccia mv_t if above==1 & mv_t>=0, sort lcolor(red) ) /*
*/     (scatter n_firms_bid_mean mv_t_grp , msize(small) mlwidth(vthin) msymbol(circle_hollow) mcolor(gray)), /*
*/     ylabel(`ylabel') ytitle("N. of bidders", size(medlarge)) /* 
*/     xtitle(Margin of victory, size(medlarge)) xline(0, lwidth(0.2) lcolor(black)) xscale(range(-10 10)) xlabel(-10 -5 0 5 10) /*
*/	   legend(label(1 "First term") label(2 "Higher term")  label(5 "Observed values") colgap(*3) width(100) order(1 2 5)) /*
*/     saving(lines_n_firms_bid.gph, replace) nodraw


gr combine points_n_firms_bid.gph
gr combine tgpol_n_firms_bid.gph
gr combine lines_n_firms_bid.gph
*************************************************************

* c)

clear
clear matrix
use final.dta, clear

* sample selection
reg reb_final n_firms_bid max_wins_std tt_cont ty_del term_limit mv_t $geog $time $auction $mayor $electoral if open_race==0 & number_rivals>0 & number_rivals!=. 
gen sample1=e(sample)
keep if sample1==1

drop if mv_t==0 & tt_cont==1


gen above=mv_t>=0 

* 
egen group=cut(mv_t),  at(-80(1)80)
egen mv_t_grp=mean(group),by(group)

drop tag_term
egen tag_term=tag(id_city id_mayor year_election)
keep if tag_term==1

*For presentational purposes
gen NO=NW+NE+CE

foreach var of varlist NW NE CE SOU IS pop_census1991 extension alt_center {
egen `var'_mean = mean(`var'), by(mv_t_grp)
}

*For presentational purposes
keep if mv_t>=-10 & mv_t<=10
gen mv_tXabove=mv_t*above

local nino "NW NE CE SOU IS pop_census1991 alt_center extension"

local i=1
foreach var of local nino{


if `i'== 1 {
 local svar "North-West"
 local ylabel "0(0.25)1"
 }

else if `i'==2 {
 local svar "North-East"
 local ylabel "0(0.25)1"
}

else if `i'==3 {
 local svar "Center"
 local ylabel "0(0.25)1"
}

else if `i'==4 {
 local svar "South"
 local ylabel "0(0.25)1"
}

else if `i'==5 {
 local svar "Islands"
 local ylabel "0(0.25)1"
 }


else if `i'==6 {
 local svar "Population"
 local ylabel "0(50000)50000"
 }

else if `i'==7 {
 local svar "Altitude"
 local ylabel "200(200)400"
}

 else if `i'==8 {
 local svar "Extension"
local ylabel "10(20)70"
 }

qui lowess `var' mv_t if above==0, gen(ciccio) nograph mean
qui lowess `var' mv_t if above==1, gen(ciccia) nograph mean

qui reg `var' mv_t mv_t2 mv_t3 if above==0
predict ciccio2, xb, if e(sample)

qui reg `var' mv_t mv_t2 mv_t3 if above==1
predict ciccia2, xb, if e(sample)




twoway (line ciccio mv_t if above==0 & mv_t<0, sort lcolor(blue)) /*
*/	   (line ciccia mv_t if above==1 & mv_t>=0, sort lcolor(red) ) /*
*/	   (line ciccio2 mv_t if above==0 & mv_t<0, sort lcolor(blue) lp(dash)) /*
*/	   (line ciccia2 mv_t if above==1 & mv_t>=0, sort lcolor(red) lp(dash)) /*
*/     (scatter `var'_mean mv_t_grp , msize(small) mlwidth(vthin) msymbol(circle_hollow) mcolor(gray)), /*
*/     ylabel(`ylabel') ytitle(`svar', size(medlarge)) /* 
*/     xtitle(Margin of victory, size(medlarge)) xline(0, lwidth(0.2) lcolor(black)) xscale(range(-10 10)) xlabel(-10 -5 0 5 10) /*
*/	   legend(label(1 "First term") label(2 "Higher term")  label(5 "Observed values") colgap(*3) width(100) order(1 2 5)) /*
*/     saving(FigA5_`var'.gph, replace) nodraw
drop ciccio* ciccia* 

local i=`i'+1

}


grc1leg FigA5_NW.gph FigA5_NE.gph FigA5_CE.gph FigA5_SOU.gph FigA5_IS.gph FigA5_pop_census1991.gph FigA5_alt_center.gph FigA5_extension.gph, saving(FigA5.gph, replace)


* d)

**** Table 5
clear
use "final.dta"

* sample selection
reg reb_final n_firms_bid winner_in_reg max_wins_std tt_cont term_limit mv_t $geog $time $auction $mayor $electoral if open_race==0 & number_rivals>0 & number_rivals!=.
gen sample1=e(sample)
keep if sample1==1

drop if mv_t==0 & tt_cont==1

*Show in tables only relevant variables
local keep "keep(ty_del tt_cont tt_party_cont term_limit gender age starting_value pop_res)"


** Level of competition: number of bidders
reg n_firms_bid tt_cont mv_t mv_t2 mv_t3, cluster(id_mayor)
eststo
su n_firms_bid if e(sample)
local nm= e(N_clust)
local mout=r(mean)
reg n_firms_bid tt_cont mv_t mv_t2 mv_t3 term_limit $geog $time $auction $mayor $electoral, cluster(id_mayor)
eststo 
su n_firms_bid if e(sample)
local nm= e(N_clust)
local mout=r(mean)

** Level of competition: final rebate
reg reb_final tt_cont mv_t mv_t2 mv_t3, cluster(id_mayor)
eststo
su reb_final if e(sample)
local nm= e(N_clust)
local mout=r(mean)
reg reb_final tt_cont mv_t mv_t2 mv_t3 term_limit $geog $time $auction $mayor $electoral, cluster(id_mayor)
eststo
su reb_final if e(sample)
local nm= e(N_clust)
local mout=r(mean)

**** Table 6

use "final.dta", clear

* sample selection
qui reg reb_final n_firms_bid winner_in_reg max_wins_std tt_cont term_limit mv_t $geog $time $auction $mayor $electoral if open_race==0 & number_rivals>0 & number_rivals!=.
gen sample1=e(sample)
keep if sample1==1

drop if mv_t==0 & tt_cont==1

replace winner_in_reg=winner_in_reg*100 
replace max_wins_std=max_wins_std*100

*Show in tables only relevant variables
local keep "keep(ty_del tt_cont tt_party_cont term_limit gender age starting_value pop_res)"

** Nature of competition: winner outsider
reg winner_in_reg tt_cont mv_t mv_t2 mv_t3, cluster(id_mayor)
eststo
su winner_in_reg if e(sample)
local nm= e(N_clust)
local mout=r(mean)
reg winner_in_reg tt_cont mv_t mv_t2 mv_t3 term_limit $geog $time $auction $mayor $electoral, cluster(id_mayor)
eststo
su winner_in_reg if e(sample)
local nm= e(N_clust)
local mout=r(mean)

** Nature of competition: winning incumbency
reg max_wins_std tt_cont mv_t mv_t2 mv_t3 if year_election>=1998 & year_election<=2003, cluster(id_mayor)
eststo
su max_wins_std if e(sample)
local nm= e(N_clust)
local mout=r(mean)
reg max_wins_std tt_cont mv_t mv_t2 mv_t3 term_limit $geog $time $auction $mayor $electoral if year_election>=1998 & year_election<=2003, cluster(id_mayor)
eststo
su max_wins_std if e(sample)
local nm= e(N_clust)
local mout=r(mean)

* e)

use final.dta, clear

* sample selection
reg reb_final n_firms_bid winner_in_reg max_wins_std tt_cont term_limit mv_t $geog $time $auction $mayor $electoral if open_race==0 & number_rivals>0 & number_rivals!=.
gen sample1=e(sample)
keep if sample1==1

drop if mv_t==0 & tt_cont==1
keep if tag_term==1

 
** McCrary test

DCdensity mv_t, breakpoint(0) generate(Xj Yj r0 fhat se_fhat)
 
graph save Fig2.gph, replace
graph export Fig2.eps, replace


* f)
***** polinomy 2*******************************************************
**** Table 5
clear
use "final.dta"

* sample selection
reg reb_final n_firms_bid winner_in_reg max_wins_std tt_cont term_limit mv_t $geog $time $auction $mayor $electoral if open_race==0 & number_rivals>0 & number_rivals!=.
gen sample1=e(sample)
keep if sample1==1

drop if mv_t==0 & tt_cont==1

*Show in tables only relevant variables
local keep "keep(ty_del tt_cont tt_party_cont term_limit gender age starting_value pop_res)"


** Level of competition: number of bidders
reg n_firms_bid tt_cont mv_t mv_t2, cluster(id_mayor)
eststo
su n_firms_bid if e(sample)
local nm= e(N_clust)
local mout=r(mean)
reg n_firms_bid tt_cont mv_t mv_t2 term_limit $geog $time $auction $mayor $electoral, cluster(id_mayor)
eststo
su n_firms_bid if e(sample)
local nm= e(N_clust)
local mout=r(mean)

** Level of competition: final rebate
reg reb_final tt_cont mv_t mv_t2, cluster(id_mayor)
eststo
su reb_final if e(sample)
local nm= e(N_clust)
local mout=r(mean)
reg reb_final tt_cont mv_t mv_t2 term_limit $geog $time $auction $mayor $electoral, cluster(id_mayor)
eststo
su reb_final if e(sample)
local nm= e(N_clust)
local mout=r(mean)

**** Table 6

use "final.dta", clear

* sample selection
qui reg reb_final n_firms_bid winner_in_reg max_wins_std tt_cont term_limit mv_t $geog $time $auction $mayor $electoral if open_race==0 & number_rivals>0 & number_rivals!=.
gen sample1=e(sample)
keep if sample1==1

drop if mv_t==0 & tt_cont==1

replace winner_in_reg=winner_in_reg*100 
replace max_wins_std=max_wins_std*100

*Show in tables only relevant variables
local keep "keep(ty_del tt_cont tt_party_cont term_limit gender age starting_value pop_res)"

** Nature of competition: winner outsider
reg winner_in_reg tt_cont mv_t mv_t2, cluster(id_mayor)
eststo
su winner_in_reg if e(sample)
local nm= e(N_clust)
local mout=r(mean)
reg winner_in_reg tt_cont mv_t mv_t2 term_limit $geog $time $auction $mayor $electoral, cluster(id_mayor)
eststo
su winner_in_reg if e(sample)
local nm= e(N_clust)
local mout=r(mean)

** Nature of competition: winning incumbency
reg max_wins_std tt_cont mv_t mv_t2 if year_election>=1998 & year_election<=2003, cluster(id_mayor)
eststo
su max_wins_std if e(sample)
local nm= e(N_clust)
local mout=r(mean)
reg max_wins_std tt_cont mv_t mv_t2 term_limit $geog $time $auction $mayor $electoral if year_election>=1998 & year_election<=2003, cluster(id_mayor)
eststo
su max_wins_std if e(sample)
local nm= e(N_clust)
local mout=r(mean)

***** polinomy 4*******************************************************
**** Table 5
clear
use "final.dta"

* sample selection
reg reb_final n_firms_bid winner_in_reg max_wins_std tt_cont term_limit mv_t $geog $time $auction $mayor $electoral if open_race==0 & number_rivals>0 & number_rivals!=.
gen sample1=e(sample)
keep if sample1==1

drop if mv_t==0 & tt_cont==1

*Show in tables only relevant variables
local keep "keep(ty_del tt_cont tt_party_cont term_limit gender age starting_value pop_res)"


** Level of competition: number of bidders
reg n_firms_bid tt_cont mv_t mv_t2 mv_t3 mv_t4, cluster(id_mayor)
eststo
su n_firms_bid if e(sample)
local nm= e(N_clust)
local mout=r(mean)
reg n_firms_bid tt_cont mv_t mv_t2 mv_t3 mv_t4 term_limit $geog $time $auction $mayor $electoral, cluster(id_mayor)
eststo
su n_firms_bid if e(sample)
local nm= e(N_clust)
local mout=r(mean)

** Level of competition: final rebate
reg reb_final tt_cont mv_t mv_t2 mv_t3 mv_t4, cluster(id_mayor)
eststo
su reb_final if e(sample)
local nm= e(N_clust)
local mout=r(mean)
reg reb_final tt_cont mv_t mv_t2 mv_t3 mv_t4 term_limit $geog $time $auction $mayor $electoral, cluster(id_mayor)
eststo
su reb_final if e(sample)
local nm= e(N_clust)
local mout=r(mean)

**** Table 6

use "final.dta", clear

* sample selection
qui reg reb_final n_firms_bid winner_in_reg max_wins_std tt_cont term_limit mv_t $geog $time $auction $mayor $electoral if open_race==0 & number_rivals>0 & number_rivals!=.
gen sample1=e(sample)
keep if sample1==1

drop if mv_t==0 & tt_cont==1

replace winner_in_reg=winner_in_reg*100 
replace max_wins_std=max_wins_std*100

*Show in tables only relevant variables
local keep "keep(ty_del tt_cont tt_party_cont term_limit gender age starting_value pop_res)"

** Nature of competition: winner outsider
reg winner_in_reg tt_cont mv_t mv_t2 mv_t3 mv_t4, cluster(id_mayor)
eststo
su winner_in_reg if e(sample)
local nm= e(N_clust)
local mout=r(mean)
reg winner_in_reg tt_cont mv_t mv_t2 mv_t3 mv_t4 term_limit $geog $time $auction $mayor $electoral, cluster(id_mayor)
eststo
su winner_in_reg if e(sample)
local nm= e(N_clust)
local mout=r(mean)

** Nature of competition: winning incumbency
reg max_wins_std tt_cont mv_t mv_t2 mv_t3 mv_t4 if year_election>=1998 & year_election<=2003, cluster(id_mayor)
eststo
su max_wins_std if e(sample)
local nm= e(N_clust)
local mout=r(mean)
reg max_wins_std tt_cont mv_t mv_t2 mv_t3 mv_t4 term_limit $geog $time $auction $mayor $electoral if year_election>=1998 & year_election<=2003, cluster(id_mayor)
eststo
su max_wins_std if e(sample)
local nm= e(N_clust)
local mout=r(mean)
