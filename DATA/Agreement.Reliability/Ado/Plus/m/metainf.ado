*! metainf.ado AT version 3.0.0 March 2000    (STB-56: sbe26.1)
* metainf.ado AT version 2.0.0 November 1998  
* metainf.ado AT version 1.0.0 February 1998  

program define metainf
   version 6.0
   syntax varlist(min=2 max=2 numeric) [if] [in] [, id(varname) /*
   */ random eform t1(str) t2(str) Format(str) print `options' *]
   tokenize `varlist'
   local E  `1'
   local SE `2'
   preserve

   * Dealing with if and in options
   if ("`if'"!="") {
	qui keep `if'
   } 
   if ("`in'"!="") {
	qui keep `in'
   } 

   * Overall estimates
   qui meta `E' `SE', `eform' 
   if "`random'"=="random" {	
   	local ove=$S_7
    	local ll=$S_9
	* Global macro should be updated if meta change it name 
	local ul=$S_0
   }
   else {
    	local ove=$S_1
    	local ll=$S_3
    	local ul=$S_4
   }		

   * Meta-analysis estimate ommiting one study each step
   tempvar theta setheta ulth llth
   qui sum `E', detail
   local n=_result(1)
   qui {
	gen `theta'=.    
    	gen `setheta'=.
    	gen `ulth'=.
    	gen `llth'=.
   }
   local i=1
   tempvar s
   qui gen `s'=_n
   while (`i'<=`n') {
    	qui {
	    meta `E' `SE' if `s'!=`i', `eform'
	    if "`random'"=="random" {
		  replace `theta'=$S_7 in `i'
		  replace `llth'=$S_9 in `i'
		  replace `ulth'=$S_0 in `i'
	    }
	    else {
		  replace `theta'=$S_1 in `i'
		  replace `llth'=$S_3 in `i'
		  replace `ulth'=$S_4 in `i'
	    }
	}
	local i=`i'+1
   }

   * Maximum and minimum CI values
   qui sum `llth', detail
   local mnx=r(min)
   qui sum `ulth', detail
   local mxx=r(max)
   
   * Labeling plot
   if "`t2'" == "" { 
	local t2 "Study ommited" 
   }
   if "`t1'" == "" {
	if "`eform'"=="eform" & "`random'"=="" { 
		local t1 "Meta-analysis fixed-effects estimates (exponential form)" 
	}
	if "`eform'"=="" & "`random'"=="" { 
		local t1 "Meta-analysis fixed-effects estimates (linear form)" 
	}
	if "`eform'"=="eform" & "`random'"=="random" { 
		local t1 "Meta-analysis random-effects estimates (exponential form)" 
	}
	if "`eform'"=="" & "`random'"=="random" { 
		local t1 "Meta-analysis random-effects estimates (linear form)" 
	}
   }

   * Numeric format
   if "`format'" == "" {
	local format "%5.2f"
   }

   * Print option
   if "`print'"=="print" & "`eform'"=="" {
	dis
	dis in gre "`lab'"
	dis in gr "------------------------------------------------------------------------------"
        dis in gr _col(2) "Study ommited" _col(20) "|" _col(24) "Coef." _col(39) "[95%  Conf.  Interval]"
	dis in gr "-------------------+----------------------------------------------------------"
	local i=1
	while `i'<=`n' {
   		if "`id'"=="" { local a=`s' in `i' }
	        else { local a=`id' in `i'}
	 	local b=`theta' in `i'
	 	local c=`llth' in `i'
	 	local d=`ulth' in `i'
		display _col(2) "`a'" _col(20) in gr "|" in ye _col(24) `b' _col(39) `c' _col(52) `d'
		local i=`i'+1
	}
	dis in gr "-------------------+----------------------------------------------------------"
   	dis _col(2) "Combined" _col(20) in gr "|" in ye _col(24) `ove' _col(39) `ll' _col(52) `ul'
   	dis in gr "------------------------------------------------------------------------------"
   } 
   else if "`print'"=="print" & "`eform'"=="eform" {
	dis
	dis in gre "`lab'"
    	dis in gr "------------------------------------------------------------------------------"
        dis in gr _col(2) "Study ommited" _col(20) "|" _col(24) "e^coef." _col(39) "[95%  Conf.  Interval]"
	dis in gr "-------------------+----------------------------------------------------------"
	local i=1
	while `i'<=`n' {
   		if "`id'"=="" { 
			local a=`s' in `i' 
		}
		else { 
			local a=`id' in `i'
		}
		local b=`theta' in `i'
		local c=`llth' in `i'
		local d=`ulth' in `i'
		display _col(2) "`a'" _col(20) in gr "|" in ye _col(24) `b' _col(39) `c' _col(52) `d'
		local i=`i'+1
	}
	dis in gr "-------------------+----------------------------------------------------------"
   	display _col(2) "Combined" _col(20) in gr "|" in ye _col(24) `ove' _col(39) `ll' _col(52) `ul'
   	dis in gr "------------------------------------------------------------------------------"
   }

   * Displaying  plot
   hplot `theta' `llth' `ulth', r sy(o||) l("`id'") t1(`t1') t2(`t2') f(`format') /*
   */ xline(`ove',`ll',`ul') xlab(`mnx',`ove',`ll',`ul',`mxx') xti(`ove',`ll',`ul') /*
   */ xscale(`mnx',`mxx')
end
