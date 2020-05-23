*! bagroup.ado written 8/5/1997 by PTS version 1.2.2  (STB-55: sbe33)
*! modified Bland-Altman plots for more than two measures
*! one plot per figure
*!
*! Syntax: bagroup varlist if in, rows avlab difflab <graph options> obs_c


* modified 3/8/1998 to allow for larger symbols if there are repetitions
* modified 7/8/1998 to use all possible pairs, and to allow for ylines
* modified 11/11/1998 to give n, means, sd of vars in table 
* modified 2/2/2000 to accommodate xlab & ylab options & warn against xlab, ylab without options

set trace off

cap prog drop bagroup
prog define bagroup
	local varlist "req ex min(3)"
	local if "opt"
	local in "opt"
	local options "format(str) rows(int 999) XLABel(str) YLABel(str) avlab(str) difflab(str) title(str) saving(str) obs(int 2) listwise text(real 100) *"

	parse "`*'"
	if index("`options'","xlab") ~= 0 | index("`options'","ylab") ~= 0 { 
		di in red "xlabel and ylabel without values not permitted"
		exit 198
	}


	tempvar touse
	mark `touse' `if' `in'

	local nvars : word count `varlist'
	if "`listwise'" ~= "" {local obs = `nvars'}
	cap assert `obs' >= 2 & `obs' <= `nvars'
	if _rc { di in red "obs must be between 2 and the number of variables: " in ye `nvars' 
		exit _rc}
	tempvar obs_c
	qui gen `obs_c' = 0
	parse "`varlist'", parse(" ")
	while "`1'" ~= "" {
		qui replace `obs_c' = `obs_c' + (`1' ~= .)
		mac shift
		}

	qui replace `touse' = 0 if `obs_c' < `obs'

	if "`format'" == "" { local format "%5.2f" }

	tempvar av diff 
	qui egen `av' = rmean(`varlist') `if' `in'
	qui gen `diff' = .
	_table `varlist', av(`av') diff(`diff') touse(`touse') format(`format') obs_c(`obs_c')

	if "`xlabel'" == "" { 
		nicenum xlabel = $xmin $xmax
		local xlabel "xlabel($xlabel)"
		global xlabel 
		}
	else local xlabel "xlabel(`xlabel')"

	if "`ylabel'" == "" { 
		nicenum ylabel = $rrmin $rrmax
		parse "$ylabel" , parse (",")
		assert "`2'" == ","
		if `1' > $rrmin { 
			local ymin = 2*`1' - `3'
			global ylabel "`ymin',$ylabel"
		}
		local ylabel "ylabel($ylabel)"
		global ylabel 
		}
	else local ylabel "ylabel(`ylabel')"

	if "`avlab'" ~= "" { local avlab avlab("`avlab'") }
	if "`difflab'" ~= "" { local difflab difflab("`difflab'") }
	if "`title'" ~= "" { local title title("`title'") }
	if "`saving'" ~= "" { local saving saving(`saving') }

	qui replace `diff' = .
	cap noi _graph `varlist', av(`av') diff (`diff') touse(`touse') rows(`rows') /*
*/ `xlabel' `ylabel' `avlab' `difflab' `saving' `title' `options' obs_c(`obs_c') text(`text')
	if _rc {di in red "error in graph options"
		exit _rc}

	cap gph close

end bagroup

	
prog define _table

	local varlist "req ex "
	local options "av(str) diff(str) touse(str) format(str) title(str) obs_c(str)"
	parse "`*'"
	di _n(2) in gr "Comparisons with the average of the other measures"
	di _n in gr "Variable |     Obs   Mean      SD      Difference    Reference Range "
	di in gr    "---------+----------------------------------------------------------"
	parse "`varlist'", parse(" ")
	while "`1'" ~ = "" {	

		qui replace `diff' = (`1' - `av')* `obs_c'/(`obs_c'-1) if `touse'
		qui summ `diff' if `touse'
		local mean = _result(3)
		local lrr = _result(3) - 2*_result(4)^.5
		local urr = _result(3) + 2*_result(4)^.5

		if "`rrmin'" == "" { local rrmin = `lrr' }
		else if `lrr' < `rrmin' { local rrmin = `lrr' }
		if "`rrmax'" == "" { local rrmax = `urr' }
		else if `urr' > `rrmax' { local rrmax = `urr' }
		
* set trace on
		summ `av' , mean
		if "`xmin'" == "" { local xmin = _result(5) }
		else if _result(5) < `xmin' { local xmin = _result(5) }
		if "`xmax'" == "" { local xmax = _result(6) }
		else if _result(6) > `xmax' { local xmax = _result(6) }
		
		qui corr `av' `diff' if `touse'
		local r = _result(4)
		local n = _result(1)
		local sig = tprob(`n'-2, `r'*((`n'-2)/(1-`r'^2))^.5)
		qui summ `1' if `touse'

	#delim ;
		di in gr "`1'" _col(10) "|" 
                _col(12) in ye %7.0f `n' 
		_col(22) `format' _result(3) 
		_col(32) `format' _result(4)^.5
		_col(40) `format' `mean' 
		_col(54) `format' `lrr' in gr " to " in ye `format' `urr'; 
	#delim cr
		mac shift
		}


	global xmin = `xmin'
	global xmax = `xmax'
	global rrmin = `rrmin'
	global rrmax = `rrmax'
end _table


prog define _graph
	local varlist "req ex min(3)"
	local options "av(str) diff(str) touse(str) rows(int 999) avlab(str) difflab(str) title(str) saving(str) obs_c(str) yline(str) text(real 100) *"

	parse "`*'"
	if "`yline'" ~= "" { local yline ",`yline'" }

	if "`avlab'"  == "" {local avlab " " }
	if "`difflab'"  == "" {local difflab " " }
	if "`saving'" ~= "" { local saving saving(`saving') }

	label var `av' "`avlab'"
	label var `diff' "`difflab'"

	local nvar: word count `varlist'
	if "`rows'" == "999" { local rows = int(`nvar'^.5) }
	local cols = int(`nvar' / `rows')
	if `cols'*`rows' < `nvar' {
		local cols = `cols' + 1 
		}

	local rlow = 0
	local rmax = 23063
	if "`title'" ~= "" {local rmax = 20000 }
	local clow = 0
	local cmax = 32000

	local dr = `rmax'/`rows' - 100
	local dc = `cmax'/`cols' - 100

	cap noi gph open, `saving'
	if "title" ~= "" {
		gph pen 1
		gph font 1000 500
		gph text 22000 16000 0 0 `title'
		}

	parse "`varlist'", parse(" ")
	while "`1'" ~ = "" {	

		qui replace `diff' = (`1' - `av')* `obs_c'/(`obs_c'-1) if `touse'
		qui summ `diff' if `touse'
		local mean = _result(3)
		local lrr = _result(3) - 2*_result(4)^.5
		local urr = _result(3) + 2*_result(4)^.5
		local rhigh = `rlow' + `dr'
		local chigh = `clow' + `dc'

		local lab1 : var label `1'
		if "`lab1'" == "" { local lab1 "`1'" }
		
		sort `diff' `av' 
		tempvar f n
		qui by `diff' `av' : gen `f' = _N if `touse'
		qui by `diff' `av' : gen `n' = _n if `touse'

		local r_tx = int(400 * `text'/100)
		local c_tx = int(200 * `text'/100)
		

	
		#delim ;
		cap noi graph `diff' `av' if `touse' & `n' == 1 [fw=`f'], s(o) `xlabel' `ylabel' yline(`lrr', `mean', `urr' `yline') 
			`options' title("`lab1'")
			bbox(`rlow', `clow', `rhigh', `chigh', `r_tx',`c_tx', 0);
		#delim cr

		local clow = `clow' + `dc'
		if `clow' + `dc' > `cmax' { 
			local clow = 0
			local rlow = `rlow' + `dr'
			}
		mac shift
		} 
	gph close

end _graph
