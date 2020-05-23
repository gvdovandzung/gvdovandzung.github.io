*! version 1.2.0  17oct1995
program define bintesti
	version 5.0
	parse "`*'", parse(", ")
	local n `1'
	local k `2'
	local p `3'
	mac shift 3
	local options "Level(integer $D_level) Normal"
	parse "`*'"
	if `level' < 10 | `level' > 99 {
		local level 95
	}
	if "`normal'"=="" {
		bitesti `n' `k' `p'
		di
		di in gr "Ho: proportion = " in ye `p'
		cii `n' `k', level(`level')
	}
	else {
	    local zval = (`k'/`n'-`p')/sqrt(`p'*(1-`p')/`n')
	    local ph = `k'/`n'
	    local lvl = 100-((100-`level')/2)
	    local ff : disp %8.0g sqrt(`ph'*(1-`ph')/`n')*invnorm(`lvl'/100)
	    #delimit ;
	    di _n in gr "  Variable |"
		    _col(19) "Obs" _col(24) "Proportion" _col(37) "Std. Error" _n
		    "  " _dup(9) "-" "+" _dup(34) "-" ; 
	    local skip = 10 - length("x") ;
	    di in gr _skip(`skip') "x" _col(12) "|" in ye 
		_col(15) %7.0g `n'
		_col(25) %9.0g `k'/`n'
		_col(37) %9.0g 
			sqrt(`k'/`n'*(1-`k'/`n')/`n');
	    di _n in gr _col(12) "Ho:     p = " in ye $D_prob _n
		in gr _col(20) "z = " in ye %3.2f `zval' _n
		in gr _col(13) "Pr > |z| = "
		in ye %5.4f 2*normprob(-abs(`zval')) ;
	    di in gr _col(15) `level' "% CI = (" in ye
		%6.4f `ph'-`ff' in gr "," in ye %6.4f `ph'+`ff' in gr ")" ;
	    #delimit cr
	}
end
	    
