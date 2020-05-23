*! version 1.0.1 PR 10Aug95.                    (STB-29: sg47)
program define a2
version 4.0
local varlist "req ex min(1)"
local if "opt"
local in "opt"
local options "DIst(string) DF(int 0)"

parse "`*'"

if "`dist'"=="" {
	di in red "distribution not specified"
	exit 198
}
local d=lower(substr("`dist'",1,1))
if "`d'"=="n" {
	local dno 1
	local dist "normal"
}
else if "`d'"=="u" {
	local dno 2
	local dist "uniform"
}
else if "`d'"=="c" {
	local dno 3
	local dist "chi-square"
	if `df'<=0 { 
		di in red "invalid df for chi-square"
		exit 198
	}
}
else {
	di in red "invalid `dist'"
	exit 198
}

local small 1e-20

di _n in gr _col(3) "Anderson-Darling A^2 test for `dist' data"
#delimit ;
di in gr " Variable |    Obs" _col(29) "A2"
	_col(40) "z   Pr > z" _n
" ---------+" _dup(38) "-"
;
#delimit cr
tempvar epit term touse
quietly {
	parse "`varlist'", parse(" ")
	while "`1'"!="" {
		local uvar `1'
		capture drop `touse'
		capture drop `epit'
		capture drop `term'
		mark `touse' `if' `in'
		markout `touse' `uvar'
/*
	Calculate number of good values and SD of data
*/
		summ `uvar' if `touse'
		if _result(1)<3 {
			di in red "insufficient observations"
			exit 2001
		}
		local obs=_result(1)
		local mean=_result(3)
		local sd=sqrt(_result(4))
/*
	Calculate estimated probability integral transform
*/
		gen `epit' = `uvar' if `touse'
		sort `epit'
		if `dno'==1 { /* normal */
			replace `epit'=normprob((`epit'-`mean')/`sd')
		}
		else if `dno'==3 { /* chi-sq */
			replace `epit'=1-chiprob(`df',`epit')
		}
/*
	Calculate Anderson-Darling A^2 statistic
*/
		gen `term'=`epit'*(1-`epit'[`obs'-_n+1]) if `touse'
		replace `term'=`small' if `term'<=0
		replace `term'=sum( (2*_n-1)*log(`term') ) if `touse'
		local A2=-`obs'-`term'[`obs']/`obs'
		if `dno'==1 { /* normal */
			local A2=`A2'*(1+(0.75+2.25/`obs')/`obs')
			local X=1000/`obs'
			local B0=2.25247+0.317e-3*exp(0.0295*`X')
			local B1=2.16872+0.00243*exp(0.0277*`X')
			local B2=0.19135+0.00255*exp(0.0283*`X')
			local B3=0.110978+0.16243e-4*exp(0.03904*`X')+ /*
			 */ 0.00476*exp(0.02137*`X')
			local LA2=log(`A2')
			local Z=`B0'+`LA2'*(`B1'+`LA2'*(`B2'+`LA2'*`B3'))
		}
		else {
/*
	FP (-0.5,0.5)-based Z-value for A2 (see a2.do)
*/
			local sa2=sqrt(`A2')
			local Z=.805489-1.64302/`sa2'+1.19616*`sa2'
		}
		local P=normprob(-`Z')
		local skip=9-length("`uvar'")
		#delimit ;
		noi di in gr _skip(`skip') "`1' |" in ye
			%7.0f `obs' "    "
			%8.5f `A2' "  "
			%8.3f `Z' "  "
			%7.5f `P'
		;
		#delimit cr
		mac shift
	}
	global S_1 `obs'
	global S_2 `A2'
	global S_3 `Z'
	global S_4 `P'
}
end
