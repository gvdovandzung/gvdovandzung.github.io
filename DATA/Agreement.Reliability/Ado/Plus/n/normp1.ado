*! version 1.0.0  20apr1995
program define normp1
	version 5.0

	local varname	"`1'"
	local prob	"`2'"

	confirm var `varname'
	confirm number `prob'

	if `prob'<0 | `prob'>1 {
		di in red "probability must be in [0,1]"
		exit 198
	}
	
	qui sum `varname'
	local n = _result(1)
	local min = _result(5)
	local max = _result(6)
	#delimit ;
	capture assert `varname'==`min' | `varname'==`max' 
		| `varname' == . `if' `in' ;
	#delimit cr
	if _rc>3000 {
		di in red "`varname' takes on more than two values"
		exit 450
	}
	preserve
	if `max'==`min' {
		if `max' > 0 {
			qui replace `varname' = 1 if `varname'==`max'
		}
		else {
			qui replace `varname' = 0 if `varname'==`max'
		}
	}
	else {
		if `min'==1 {
			qui replace `varname' = 0 if `varname'==`min'
			qui replace `varname' = 1 if `varname'==`max'
		}
		else {
			qui replace `varname' = 1 if `varname'==`max'
			qui replace `varname' = 0 if `varname'==`min'
		}
	}
	qui count if `varname' == 1
	local k = _result(1)
	local phat = `k'/`n'
	local zval = (`k'-`n'*`prob') / /*
		*/ sqrt(`n'*`prob'*(1-`prob'))
	local ff : di %8.0g sqrt(`phat'*(1-`phat')/`n')*invnorm($D_level/100)
	#delimit ;
	di _n in gr "  Variable |"
		_col(19) "Obs" _col(24) "Proportion" _col(37) "Std. Error" _n
		"  " _dup(9) "-" "+" _dup(34) "-" ; 
	local skip = 10 - length("x") ;
	di in gr _skip(`skip') "x" _col(12) "|" in ye 
		_col(15) %7.0g `n'
		_col(25) %9.0g `k'/`n'
		_col(37) %9.0g 
			sqrt((`k'/`n')*(1-`k'/`n')/`n');
	di _n in gr _col(12) "Ho:     p = " in ye `prob' _n
		in gr _col(20) "z = " in ye %3.2f `zval' _n
		in gr _col(13) "Pr > |z| = "
		in ye %5.4f 2*normprob(-abs(`zval'));
	di in gr _col(15) $D_level "% CI = (" in ye
		`phat'-`ff' in gr "," in ye `phat'+`ff' in gr ")" ;
	#delimit cr
end
