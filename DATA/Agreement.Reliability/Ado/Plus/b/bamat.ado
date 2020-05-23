*! bamat    Version 1.2.2 written 11 June 1997 by P T Seed (STB-55: sbe33)
*!
*! A matrix of Bland-Altman plots for a series of variables
*! bamat varlist, graph_options

* Amended 7 August 1998 to allow for saving graphs
* 
* Amended 3 May 2000 by arr@stata to suppress intermediary graphs and
* display only the final matrix of Bland-Altman plots

prog define bamat
  version 5.0


  local varlist "req ex min(3)"
  local if "opt"
  local in "opt"
  local options "noTABle TItle(string) saving(string) data nograph markout FORmat(string) XLAbel(string) YLAbel(string) text(str) *"

  parse "`*'"
	if index("`options'","xlab") ~= 0 | index("`options'","ylab") ~= 0 { 
		di in red "xlabel and ylabel without values not permitted"
		exit 198
	}

  parse "`varlist'", parse(" ")

  if "`table'" == "notable" & "`graph'" == "nograph" & "`data'" == "" {
	di in red "Either table data or graph options must be chosen"
	exit 194 }

  preserve 
  tempvar touse
  mark `touse' `if'
  if "`markout'" ~= "" {markout `touse' `varlist'}
  if "`format'" == "" { local format "%6.3f" }
  if "`saving'" ~= "" { local saving "saving(`saving')" }

  if "`table'" ~= "notable" {
	_table `varlist' if `touse', format(`format') `data'
	}

  if "`graph'" ~= "nograph" |"`data'" ~= "" {
  	_limits `varlist' if `touse'
	if "`xlabel'" == "" | "`xlabel'"  == "xlabel" { 
  		_mynnum xlabel $xmin $xmax
		local xlabel "xlabel($xlabel)" 
		}
	else {local xlabel "xlabel(`xlabel')" }
  
	if "`ylabel'" == "" { 
  		_mynnum ylabel $ymin $ymax
		local ylabel "ylabel($ylabel)" 
		}
	else {local ylabel "ylabel(`ylabel')" }

        #delim ;
        di _n  in gr "Range of x values is " in ye %6.0g $xmin in gr " to " in ye %6.0g $xmax 
           in gr ", range of y values is " in ye %6.0g $ymin in gr " to " in ye %6.0g $ymax;
        #delim cr
	if "`title'" == "" {_graph `varlist' if `touse', `graph' `saving' `xlabel' `ylabel' `data' `options' }
	else {_graph `varlist' if `touse', title("`title'") `graph' `saving' `xlabel' `ylabel' `data' `options' }
	}
end bamat

prog define _table
    local varlist "req ex" 
    local if "opt"
    local options "data format(str)"
    parse "`*'"

    tempvar touse
    mark `touse' `if'

    di in gr _new "Reference ranges for differences between two methods""
    #delimit;
    di in gr _new(2) "Method 1" _col(10) "Method 2" _col(20) "Mean" 
    _col(30) "[95% Reference Range]"  
    _col(54) "Minimum" _col(64) "Maximum" ;
    #delimit cr
    di in gr _dup(70) "-"

    tempvar av diff
    qui gen `av' = .
    qui gen `diff' = .

    local nvar : word count `varlist'
    local i = 2
    while `i' <= `nvar' {

      local j = 1
      while `j' < `i' {
* di "i = |`i'|, j = |`j'|"
          qui replace `diff' = ``i'' - ``j'' `if'  
          label var `diff' " "
          qui replace `av' = (``i'' + ``j'')/2 `if'
          label var `av' " "
          qui summ `diff' `if'
          local mean = _result(3)
          local lrr = `mean' - 2*_result(4)^.5
          local urr = `mean' + 2*_result(4)^.5
          local min = _result(5)
          local max = _result(6)
          di in gr "``i''" _col(10) "``j''" _col(20) in ye `format' `mean' /*
*/ _col(30) `format' `lrr' _col(40) `format' `urr' _col(52) `format' `min' _col(62) `format' `max'
	  local j = `j' +1
	  }
	local i = `i' + 1
	}
    di in gr _dup(70) "-"
end _table


prog define _data 
	local av `1'
	local diff `2'
	local m1 `3'
	local m2 `4'
	di _n in gr _dup(40) "-"
	di in gr  "Data for graph comparing `m1' and `m2'"
	di in gr "Difference" _col(20) "Average"
	di in gr _dup(40) "-"
	local k = 1
	while `k' <= _N { 
	  if `av'[`k'] ~= . & `diff'[`k'] ~= . { di `diff'[`k'] _col(20) `av'[`k'] }
	  local k = `k' + 1
	  }
  	di in gr _dup(40) "-" _n
end _data
	

prog define _graph
	local varlist "req ex"
	local if "req"
	local options "title(str) saving(str) xlabel(str) ylabel(str) nograph data *"

	parse "`*'", 
	if "`saving'" ~= "" { local saving "saving(`saving')" }

	local nvar : word count `varlist'
	tempvar diff av
	qui gen `diff' = .
	qui gen `av' = .
	label var `diff' " "
	label var `av' " "

	local gonoff : set graphics
	set graphics off
	local i = 1
	while `i' <= `nvar' {
		local j = 1
		while `j' <= `nvar' {
			qui replace `diff' = ``i'' - ``j'' `if'
			qui replace `av' = (``i'' + ``j'')/2 `if'
			tempfile g`i'`j'	
		       	local graph2 "`graph2' `i'`j'"
		       	local graphs "`graphs' `g`i'`j''"
		        if `i' == `j' & "`graph'" == "" { _namegr ``i'', saving(`g`i'`j'',  replace) }
* set trace on
			else if `i' ~= `j'{
			  qui summ `diff'
			  local mean = _result(3)
			  local lrr = _result(3) - 2*_result(4)^.5
			  local urr = _result(3) + 2*_result(4)^.5
			  if "`graph'" == "" {
				sort `diff' `av'
* set trace off
				tempvar f n 
				qui by `diff' `av' : gen `f' = _N if `diff' ~= . & `av' ~= .
				qui by `diff' `av' : gen `n' = _n if `diff' ~= . & `av' ~= .

	    	      	  	qui graph `diff' `av' `if' & `n' == 1 [fw=`f'], xlabel(`xlabel')  /*
*/ylabel(`ylabel') `options' saving(`g`i'`j'', replace) yline(`lrr', `mean', `urr') 
				}
			  if "`data'" ~= "" { _data `av' `diff' ``i'' ``j''}
		          }
			local j = `j' + 1
        		}
		local i = `i' + 1
      		}
	set graphics `gonoff'

  if "`graph'" == "" { graph using `graphs', title("`title'") `saving' }
end _graph
               
prog define _namegr
  local varlist "req ex"
  local options "saving(string)"
  parse "`*'"

  local f1 = 3000
  local f2 = 1400


  parse "`varlist'", parse (" ")
  local lab1 : var label `1'
  if "`lab1'" == "" { local lab1 "`1'" }

  qui gph open, saving(`saving')
  qui gph font `f1' `f2'
  qui gph text 11188 16000 0 0 `lab1'
  qui gph close
end _namegr

prog define _limits
  local varlist "req ex"
  local if "opt"
  parse "`*'"
  tempvar av diff

  qui gen `diff' = `2' - `1'
  qui gen `av' = (`2' + `1')/2
  qui summ `av' `if'
  global xmin = _result(5)
  global xmax = _result(6)
  qui summ `diff' `if'
  global ymin = _result(5)
  global ymax = _result(6)
 
  local nvar : word count `varlist'
  local i = 3
  while `i' <= `nvar' {

    local j = 1
    while `j' < `i' {
        qui replace `diff' = ``i'' - ``j'' `if'
        qui replace `av' = (``i'' + ``j'')/2 `if'
	qui summ `av' `if'
	if _result(5) < $xmin {	global xmin = _result(5) }
	if _result(6) > $xmax { global xmax = _result(6) }
        qui summ `diff' `if'
	if _result(5) < $ymin { global ymin = _result(5) }
	if _result(6) > $ymax { global ymax = _result(6) }
	local j = `j' + 1
	}
     local i = `i' + 1
     }
     if $ymax + $ymin > 0 { global ymin = -$ymax }
     else { global ymax = -$ymin }
end _limits

prog define _mynnum
*! _mynnum		Version 1.00 20/3/1997 PTS
*! a version of nicenum to handle numbers less than 1
*! usage: _mynnum global_macro minimum maximum mumber_of_ticks
  version 5.0
  local macro "`1'"
  if `2' ~= `3' { 
	if `2' < `3' {
		local min `2'
		local max `3'
		}
	else { 
		local min `3'
	  	local max `2'
		}
	}
  else  {
     di in red "Numbers do not differ"
     exit  198
     }
  local nticks `4'
  if "`nticks'" == "" { local nticks = 5 }
  else { cap confirm integer `nticks'
         assert `nticks' > 2
         if _rc ~= 0 {
            di in red "Number of ticks requested must be at least 2"
            exit 198
            }
	}

  local gap = 10^(int(log10(`max' - `min'))-1)

  local nt = int((`max' - `min' )/`gap') + 1
  while `nt' < `nticks' { 
	local gap = `gap'/10
  	local nt = int((`max' - `min' )/`gap') + 1
	}

  if `nt' > `nticks' - 1 { 
	local gap = `gap' * 2 
  	local nt = int((`max' - `min' )/`gap') + 1
	}
  if `nt' > `nticks' - 1 { 
	local gap = `gap' * 2.5
	}
  if `nt' > `nticks' - 1 { 
	local gap = `gap' * 2
	}


  local tick = `gap'*int(`min'/`gap')
  while `tick' > `min' { local tick = `tick' - `gap' }
  global `macro' "`tick'"
  while `tick' < `max' {
	local tick = `tick' + `gap'
	global `macro' "$`macro', `tick'"
	}

end _mynnum
