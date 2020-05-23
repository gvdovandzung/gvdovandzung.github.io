*! metap AT v2.0.0, March 2000    (STB-56: sbe28.1)
* metap AT 1.1.0, 7 February 1999

program define metap, rclass
   version 6.0
   syntax varlist(min=1 max=1 numeric) [if] [in] [, Method(str) `options' *]
   tokenize `varlist'
   local P `1'

   preserve
   if ("`if'"!="") {
	qui keep `if'
   } 
   if ("`in'"!="") {
	qui keep `in'
   } 

   if "`method'"=="ea" {
	dis   
	dis in gre "Meta-analysis of p_values"
	dis
	qui summ `P', detail
        local n=r(N)
        local sp=r(sum)
	local m="Edgington, additive"
	local t="."
	local i=1
	local f=1
	while `i'<=`n' {
	      local f=`f'*`i'
	      local i=`i'+1
	}
        local z=.
	local pz=(`sp'^`n')/`f'
   }
   else if "`method'"=="en" {
	dis   
	dis in gre "Meta-analysis of p_values"
	dis
   	qui sum `P', detail
        local n=r(N)
        local sp=r(sum)
   	local m="Edgington, Normal"
        local t="Z"
	local p=`sp'/`n'
	local z=(0.5-`p')*sqrt(12*`n')
	local pz=normprob(-`z')
   }
   else {
	dis   
	dis in gre "Meta-analysis of p-values"
	dis
        tempvar lnP
	qui gen `lnP'=ln(`P')
	qui summ `lnP', detail
        local n=r(N)
        local sp=r(sum)
	local t="chi2"
	local m="Fisher"
	local z=-2*`sp'
	local df=2*`n'
	local pz=chiprob(`df', `z')
   }
   dis in gre "--------------------------------------------------------------                    
   dis in gre " Method" _col(23) "|" _col(27) "`t'" _col(40) "p_value" _col(53) "studies"                    
   dis in gre "----------------------+---------------------------------------                    
   dis in gre _col(2) "`m'" _col(23) "|" _col(27) in ye `z' _col(40) in ye `pz' _col(53) in ye `n'                       
   dis in gre "--------------------------------------------------------------                    
   return local method="`m'"
   return scalar n=`n'
   return local stat="`t'"
   return scalar z=`z'
   return scalar pvalue=`pz'
end
