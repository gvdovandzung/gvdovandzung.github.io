*! version 1.1.0 11/4/94                        (STB-25: dm28)
program define nicenum
	version 4.0
	local mac "`1'"
	if "`2'" != "=" {
		di in red /*
		*/ "nicenum macroname = arglist [if expr] [in range], Number(#)"
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
		if _rc != 0 {
			local numlist "`numlist' `1'"
		}
		else { local varlist "`varlist' `1'" }
		mac shift
	}
	tempvar use
	mark `use' `*'
	markout `use' `varlist'

	tempname gmin gmax
	scalar `gmin' = .		/* uninitialized state */
	scalar `gmax' = .
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
		if `gmin'==. { scalar `gmin' = `1' }
		if `gmax'==. { scalar `gmax' = `1' }
		scalar `gmin' = cond(`1'<`gmin',`1',`gmin')
		scalar `gmax' = cond(`1'>`gmax',`1',`gmax')
		mac shift
	}

	local command 	"`*' , `opts'"
	local varlist	"opt"
	local options 	"Number(int 4)"
	
	parse "`command'"

	if `number' < 1 | `number' > 19 {
		di in red "number must be in [1,19]"
		error 198
	}
        local inter = `number' + 1

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

