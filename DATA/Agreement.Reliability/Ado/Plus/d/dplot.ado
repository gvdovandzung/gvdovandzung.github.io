*! version 1.1.0  17dec1995
program define dplot
	version 5.0
	local varlist 	"req ex max(1)"
	local if	"opt"
	local in	"opt"
	local options	"RAW BY(string)"
	parse "`*'"
	
	local var "`varlist'"

	if "`by'"!="" {
		confirm var `by'
	}

	local col1 = 10
	local col2 = 20
	local col3 = 30
	local col4 = 40
	local col5 = 50
	local col6 = 60

	quietly {
		preserve
		tempvar touse
		mark `touse' `if' `in'
		markout `touse' `var' `by'
		keep if `touse'
		summ `var'
		local xmin = _result(5)
		local xmax = _result(6)
		local cnt = _result(1)
		if `xmin'==`xmax' {
			noi di in red "data is constant"
			exit 198
		}
		if "`raw'"=="" {
			nicen S_nice = `var'
		}
		else {
			summ `var'
			local i 1
			local newx : di %8.0g _result(5)
			global S_nice = "`newx',"
			local star = _result(5)
			local step = (_result(6)-_result(5))/5
			while `i' < 5 {
				local newl = `i'*`step'+`star'
				local newx : di %8.0g `newl'
				global S_nice = "$S_nice`newx',"
				local i = `i'+1
			}
			local newx : di %8.0g _result(6)
			global S_nice = "$S_nice`newx'"
		}

		local i 1
		local nlab 1
		parse "$S_nice", parse(" ,")
		while "``i''"!="" {
			if "``i''"!="," {
				local lab`nlab' = "``i''"
				local len`nlab' = length("`lab`nlab''")
				local col`nlab' = /*
				*/ int(`nlab'*10-`len`nlab''/2)+1
				local nlab = `nlab'+1
			}
			local i = `i'+1
		}
		local nlab = `nlab'-2
		if `nlab' > 6 {
			noi di in red "data has bad range"
			exit 198
		}

		tempvar g

		if "`by'"!="" {
			egen `g'=group(`by')
		} 
		else {
			gen `g'=1
		}

		local lmin = `lab1'
		local lmax = `nlab'+1
		local lmax = `lab`lmax''
		summ `g'
		local lastby = int(_result(6)+.001)
		local byc = 1
		while `byc' <= `lastby' {
			noi drawdot `var' `g' `byc' `nlab' `lmin' `lmax' `by'
			count if `g'==`byc'
			local cnt = _result(1)
			local byc = `byc'+1
			noi di in gr "        -" _dup(`nlab') "+---------" /*
			*/ "+-" in gr "  (" in ye `cnt' in gr " obs.)"
			noi di in gr _col(`col1') "`lab1'" _col(`col2') /*
			*/ "`lab2'" _col(`col3') "`lab3'" _col(`col4')  /*
			*/ "`lab4'" _col(`col5') "`lab5'" _col(`col6')  /*
			*/ "`lab6'"	
		}
	}
	restore
end


program define drawdot
	version 5.0

	local var "`1'"
	local g "`2'"
	local byc = `3'
	local nlab = `4'
	local lmin = `5'
	local lmax = `6'
	local byv "`7'"

	tempvar x c nobs b sd cmn 

	quietly {
		preserve
		keep if `g'==`byc'
		tempname vxmin vxmax vxran
		scalar `vxmin' = `lmin'
		scalar `vxmax' = `lmax'
		scalar `vxran' = `vxmax'-`vxmin'
		gen int `x' = int( /*
		*/	(`var'-`vxmin') / `vxran' * /*
		*/ (10*(`nlab'))) + 10
		egen int `c' = count(`x'), by(`x')

		sort `x'
		keep if `x'!=`x'[_n-1] 
		gen `sd' = mod(`c',2)
		replace `c'=int(`c'/2+.5001)
		summ `c'
		local lastj = int(_result(6)+.001)
		local nn = _result(1)

		noi di 

		if "`byv'" != "" {
			local val = `byv'[1]
			noi di in bl "-> `byv'=`val'"
		}
		local i = `lastj'
		*noi list `var' `x' `sd' `c'
		while `i' >= 1 {
			local lastj = 0
			local j 1
			while `j' <= `nn' {
				if `c'[`j'] >= `i' {
					local z = cond(`lastj'==0,`x'[`j'],/*
					*/ `x'[`j']-`x'[`lastj'])
					local lastj = `j'
					if `sd'[`j'] == 1 & `c'[`j'] == `i' {
						noi di in ye _col(`z') "." _c
					} 
					else {
						noi di in ye _col(`z') ":" _c
					}
				}
				local j = `j'+1
			}
			local i = `i'-1
			noi di 
		}
		restore
	}
end


program define nicen
	version 5.0
	local mac "`1'"
	if "`2'" != "=" {
		di in red /*
		*/ "nicenum macroname = arglist [if expr] [in range], Inter(#)"
		error 198
	}
	mac shift 2
	local remain "`*'"
	parse "`*'", parse(",")
	local arglist "`1'"
	local opts "`3'"

	parse "`arglist'", parse(" ")
	while "`1'" != "" & "`1'" != "if" & "`1'" != "in" {
		capture confirm var `1'
		if _rc>0 != 0 {
			local numlist "`numlist' `1'"
		}
		else { local varlist "`varlist' `1'" }
		mac shift
	}
	tempvar use
	mark `use' `*'
	markout `use' `varlist'

	tempname gmin gmax
	if "`varlist'" != "" {
		parse "`varlist'", parse(" ")
		quietly summ `1' if `use'
		scalar `gmin' = _result(5)
		scalar `gmax' = _result(6)
		mac shift
		while "`1'" != "" {
			quietly summ `1' if `use'
			scalar `gmin'=cond(_result(5)<`gmin',_result(5),`gmin')
			scalar `gmax'=cond(_result(6)>`gmax',_result(6),`gmax')
			mac shift
		}
	}

	parse "`numlist'", parse(" ")
	while "`1'" != "" {
		if "`gmin'"=="" { scalar `gmin' = `1' }
		if "`gmax'"=="" { scalar `gmax' = `1' }
		scalar `gmin' = cond(`1'<`gmin',`1',`gmin')
		scalar `gmax' = cond(`1'>`gmax',`1',`gmax')
		mac shift
	}

	local command 	"`*' , `opts'"
	local varlist	"opt"
	local options 	"Inter(int 5)"
	
	parse "`command'"

	local inter = 5
	if `inter' < 2 | `inter' > 20 {
		di in red "intervals must be in [2,19]"
		error 198
	}

	local ntick = `inter' 
	quietly {
		tempname gran exp d f nf tmp1 tmp2

		scalar `gran' = `gmax'-`gmin'
		scalar `exp'  = log10(`gran')
		scalar `exp'  = int(`exp') - (`exp'<0.0)
		scalar `f'    = `gran'/(10^`exp')
		if `f' <= 1.      { scalar `nf' = 1.  }
		else if `f' <= 2. { scalar `nf' = 2.  }
		else if `f' <= 5. { scalar `nf' = 5.  }
		else              { scalar `nf' = 10. }

		scalar `gran' = `nf'*10^`exp' 

		scalar `d'    = `gran'/(`ntick'-1)
		scalar `exp'  = log10(`d')
		scalar `exp'  = int(`exp')-(`exp'<0.0)
		scalar `f'    = `d'/(10^`exp')
		if `f' < 1.5      { scalar `nf' = 1.  }
		else if `f' < 3.  { scalar `nf' = 2.  }
		else if `f' < 7.  { scalar `nf' = 5.  }
		else              { scalar `nf' = 10. }

		scalar `d' = `nf'*10^`exp'

		scalar `gmin' = `gmin'/`d'
		scalar `gmin' = (int(`gmin') - (`gmin'<0.0))*`d'
		scalar `tmp1' = `gmax'/`d'
		scalar `tmp2' = int(`tmp1')
		if `tmp2' < float(`tmp1') { scalar `tmp2' = `tmp2'+1 }
		scalar `gmax' = `tmp2'*`d'
		scalar `tmp1' = log10(`d')
		local nfrac = int(-`tmp1')+(`tmp1'<0.0)
		if `nfrac'<=0 { local nfrac = 0 }

		if `nfrac' > 20 {
			noi di in red "numbers too small for nice labels"
			error 198
		}

		global `mac'  ""

		if `nfrac' == 0 {
			scalar `tmp1' = `gmin'
		}
		else {
			scalar `tmp1' = `gmin' + 1/(10^(`nfrac'+1))
		}
		scalar `tmp2' = `gmax' + `d'/2
		local comma  ""
		while `tmp1' <= `tmp2' {
			local stub = int(`tmp1')
			if `nfrac' {
				local gminb = int(`tmp1'*(10^`nfrac'))
				local stubb = int(`stub'*(10^`nfrac'))
				local frac = `gminb'-`stubb'
				local frst = "00000000000000000000" + /*
				*/	string(`frac')
				local fstr = substr("`frst'",-`nfrac',.)
				global `mac' = "${`mac'}`comma'`stub'.`fstr'"
			}
			else	{ 
				local tstr = string(`tmp1')
				global `mac' = "${`mac'}`comma'`tstr'" 
			}
			scalar `tmp1' = `tmp1' + `d' 
			local comma ","
		}  

end

