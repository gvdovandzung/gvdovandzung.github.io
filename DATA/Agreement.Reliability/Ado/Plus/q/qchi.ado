*! version 1.0.0 12Jul95.                       (STB-29: sg47)
program define qchi
	version 4.0
	local varlist "req ex max(1)"
	local if "opt"
	local in "opt"
	local options /* 
	*/ "Df(string) Symbol(string) Connect(string) noBorder TRAnsform *"
	parse "`*'"
	if "`df'"=="" {
		di in red "df() not specified"
		exit 198
	}
	confirm integer num `df'
	if `df'<=0 {
		di in red "non-positive df() not allowed"
		exit 198
	}
	if "`symbol'"=="" { local symbol "oi" } 
	else { local symbol "`symbol'`i" }
	if "`connect'"=="" { local connect ".l" }
	else { local connect "`connect'`l" }
	tempvar touse x y
	quietly {
		mark `touse' `if' `in'
		markout `touse' `varlist'
		gen `y'=`varlist' if `touse'
		replace `touse'=. if `touse'==0
		sort `y'
		gen `x' = sum(`touse')
		replace `x' = cond(`touse'==.,.,`x'/(`x'[_N]+1))
		replace `x' = invnchi(`df',0,`x')
		local lbl: var label `varlist'
		if "`lbl'"=="" { local lbl `varlist' }
		if "`transform'"=="" {
			label var `x' "Inverse Chi-square(`df')"
			label var `y' "`lbl'"
		}
		else {
			replace `x'=`x'^(1/3)
			replace `y'=`y'^(1/3)
			label var `x' "Cube-root inverse Chi-sq(`df')"
			label var `y' "Cube-root `lbl'"
		}
		local fmt : format `varlist'
		format `x' `fmt'
		if "`border'"=="" { local b "border" }
		noisily graph `y' `x' `x', c(`connect') /*
		*/ s(`symbol') `b' `options'
	}
end
