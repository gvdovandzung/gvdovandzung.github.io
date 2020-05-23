*interaction version 1.0 SB 23Nov2005
*produces plots of qualitative and quantitative interaction

clear

insheet using "H:\Personal\Analysis\ICON3\survplot.csv", comma

gen cumhaz = -log(survprob)

gen beta = time/cumhaz

sum beta

gen expsurv = exp(-time/r(mean))

gen expsurv1 = (expsurv*0.5)+0.5

gen expsurv2 = (expsurv*1.1)-0.1

gen expsurv3 = (expsurv*1.4)-0.4

gen expsurv4 = (expsurv*1.5)-0.5

set scheme s1mono


twoway (line expsurv1 time if time < 1700, clp(-) lcolor(black)) ///
 	(line expsurv2 time if time < 1700, clp(-) lcolor(gs10)) ///
 	(line expsurv3 time if time < 1700, clp(_) lcolor(black)) ///
 	(line expsurv4 time if time < 1700, clp(_) lcolor(gs10) ytitle("Survival probability") title("Quantitative interaction") legend(symxsize(10) lab(1 "Group A trt 1") lab(2 "Group A trt 2") lab(3 "Group B trt 1") lab(4 "Group B trt 2")) saving(g1, replace)) 

replace expsurv3 = (expsurv*1.5)-0.5

replace expsurv4 = (expsurv*1.4)-0.4

twoway (line expsurv time if time < 1700, clp(-) lcolor(black)) ///
 	(line expsurv2 time if time < 1700, clp(-) lcolor(gs10)) ///
 	(line expsurv3 time if time < 1700, clp(_) lcolor(black)) ///
 	(line expsurv4 time if time < 1700, clp(_) lcolor(gs10) ytitle("Survival probability") title("Qualitative interaction") legend(symxsize(10) lab(1 "Group A trt 1") lab(2 "Group A trt 2") lab(3 "Group B trt 1") lab(4 "Group B trt 2")) saving(g2, replace)) 
 
graph combine g1.gph g2.gph

