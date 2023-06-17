*** RCT
clear
use "Pregunta_1-1.dta"

unab prepped: _* 

local conditions_proj tooktest_el==1 
local conditions_pec took_std==1 


*Panel A Col 1,3 

reg z_irt_total_el treatment strata* _z_irt*bl if `conditions_proj', cluster(school_code) 

sum z_scoreindex_el if treatment==0 & `conditions_proj' & `conditions_pec'
local m_z_scoreindex_el=`r(mean)'
reg z_scoreindex_el treatment  strata* _z_irt*bl *pec_2016 if `conditions_pec' & `conditions_proj', cluster(school_code) 


*Panel B Col 1,3

pdslasso z_irt_total_el treatment (`prepped' strata*) if `conditions_proj', partial(strata* _z_irt*bl) cluster(school_code) 

pdslasso z_scoreindex_el treatment (`prepped' strata* ) if `conditions_proj' & `conditions_pec', partial(strata* _z_irt*bl *pec_2016) cluster(school_code) 

