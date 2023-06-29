
*** Set directory here (change to the location of the "Elearn publication" folder on yoru drive)
cd ""
version 16
** Install the necessary commands
/*
If you would like to replicate the exact estimates found in "Engaging Teachers with Technology Increased Achievement, Bypassing Teachers Did Not," by Sabrin Beg, Adrienne M. Lucas, Waqas Halim, and Umar Saif then run the following:
*/
*local dir : pwd
*adopath ++ "`dir'/Ado_elearn/"




/* 
If you would like to use the current versions of lassopack and pdslasso run the following:
*/
*cap ssc install lassopack
*cap ssc install pdslasso


*** define macros
global strata "strataFE*" 
global partialled_proj "_z_irt_math_bl _z_irt_sci_bl"
global partialled_pec  " _meanmath_pec_2016 _meansci_pec_2016 _meaneng_pec_2016 _meaneng_pec_2016_mi"
global partialled_tablet "_z_score_math_bl _z_score_sci_bl"
global elearn "Data/Elearn"
global tablets "Data/Elearn_tablets"
global do "Do-files"
global pap_tab "Output/tables/main"
global app_tab "Output/tables/appendix"
global fig "Output/figures"

**Replicate the tables in the main paper
run "$do/table1_and_A1.do"
run "$do/table2.do"
run "$do/table3.do"
run "$do/table4.do"
run "$do/table5.do"

**Replicate the tables in the appendix
run "$do/tableA2.do"
run "$do/tableA3.do"
run "$do/tableA4.do"
run "$do/tableA5.do"
run "$do/tableA6.do"
run "$do/tableA7.do"
run "$do/tableA8.do"

**Replicate the paper's figures
run "$do/FiguresA1_A2.do"

**Remove the adopath from your directory
*adopath - "`dir'/Ado_elearn/"
