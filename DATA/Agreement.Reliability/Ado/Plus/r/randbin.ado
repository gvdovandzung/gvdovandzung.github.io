*! version 1.0.0  8 May 1995
program define randbin
	version 5.0
	local varlist "req new max(1)"
	local if "opt"
	local in "opt"
	local options "N(integer 1) P(real .5) OBS(integer 0)"
	parse "`*'"
	capture {
		local x "`varlist'"
		if `n' < 1 {
			di in red "n() must be >= 1"
			exit 499
		}
		if `p' < 0 | `p' > 1 {
			di in red "p() must be between 0 and 1"
			exit 499
		}
		if `obs' < 0 {
			di in red "obs() must be positive"
			exit 198
		}
		if `obs' == 0 & _N == 0 { error 2000 }
		if ("`if'"~="" | "`in'"~="") & `obs' > 0 {
			di in red "obs() not allowed with if or in"
			exit 101
		}
		tempvar doit
		local old_N = _N
		if `obs' > _N { noisily set obs `obs' }
		mark `doit' `if' `in'
		local exp "(uniform()<`p')"
		replace `x' = 0 if `doit'
		if `n' >= 4 {
			local i 1
			while `i' <= int(`n'/4) {
				replace `x' = `x'+`exp'+`exp'+`exp'+`exp' if `doit'
				local i = `i' + 1
			}
		}
		local i 1
		while `i' <= mod(`n',4) {
			replace `x' = `x'+`exp' if `doit'
			local i = `i' + 1
		}
	}
	if _rc>0 {
		local rc = _rc
		capture drop `varlist'
		capture drop if _n > `old_N'
		error `rc'
	}
end
