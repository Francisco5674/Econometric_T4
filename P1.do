*** RCT
clear
use "Pregunta_1-1.dta"

global strata "strataFE*" 
global partialled_proj "_z_irt_math_bl _z_irt_sci_bl"
global partialled_pec  " _meanmath_pec_2016 _meansci_pec_2016 _meaneng_pec_2016 _meaneng_pec_2016_mi"
unab prepped: _* 

local conditions_proj tooktest_el==1 
local conditions_pec took_std==1 


*Panel A Col 1,3 

reg z_irt_total_el treatment $strata _z_irt*bl if `conditions_proj', cluster(school_code) 
eststo

sum z_scoreindex_el if treatment==0 & `conditions_proj' & `conditions_pec'
local m_z_scoreindex_el=`r(mean)'
reg z_scoreindex_el treatment  $strata $partialled_proj $partialled_pec if `conditions_pec' & `conditions_proj', cluster(school_code) 
eststo


*Panel B Col 1,3

pdslasso z_irt_total_el treatment (`prepped' $strata ) if `conditions_proj', partial($strata $partialled_proj) cluster(school_code) 
eststo

pdslasso z_scoreindex_el treatment (`prepped' $strata ) if `conditions_proj' & `conditions_pec', partial($strata $partialled_proj $partialled_pec ) cluster(school_code) 
eststo
