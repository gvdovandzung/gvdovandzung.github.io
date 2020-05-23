*! version 1.1.0  12jul1995
program define bintest
	version 5.0
	local varlist "req ex max(1)"
	local if "opt"
	local in "opt"
	local exp "req noprefix"
	local options "Level(integer $S_level)"
	parse "`*'"
	if `level' < 10 | `level' > 99 {
		error 198
	}
	confirm number `exp'
	qui sum `varlist'
	local min = _result(5)
	local max = _result(6)
	#delimit ;
	capture assert `varlist'==`min' | `varlist'==`max' 
		| `varlist' == . `if' `in' ;
	#delimit cr
	if _rc>0 {
		di in red "`varlist' takes on more than two values"
		exit 450
	}
	preserve
	if `max'==`min' {
		if `max' > 0 {
			qui replace `varlist' = 1 if `varlist'==`max'
		}
		else {
			qui replace `varlist' = 0 if `varlist'==`max'
		}
	}
	else {
		if `min'==1 {
			qui replace `varlist' = 0 if `varlist'==`min'
			qui replace `varlist' = 1 if `varlist'==`max'
		}
		else {
			qui replace `varlist' = 1 if `varlist'==`max'
			qui replace `varlist' = 0 if `varlist'==`min'
		}
	}
	bitest `varlist'=`exp' `if' `in'
	di
	di in gr "Ho: proportion(x) = " in ye `exp'
	ci `varlist' `if' `in', level(`level') binomial
	restore
end
