*! version 2.0.1 28jul1999
program define ztesti
	version 5.0
	parse "`*'", parse(" ,")

	confirm integer number `1'
	confirm number `2'
	confirm number `3'
	confirm number `4'

	local n1 `1'
	local u1 `2'
	local s1 `3'
	local u2 `4'

	if `n1'<=0 { error 2001 } 
	if `s1'<=0 { error 411  }
	confirm number `1'

	if "$S_level"=="" {
		global S_level 95
	}
	if $S_level < 10 | $S_level > 99 {
		global S_level 95
	}

	mac shift 4

	local options "Level(integer $S_level)"
	parse "`*'"


	local xname "x" 
	local se = `s1'/sqrt(`n1')

	noi di
	noi di in gr _col(55) "Number of obs = " /*
	*/ in ye %8.0g `n1'
	_ttest1 `xname' `n1' `u1' `se' normal `level'
	noi di in gr _dup(78) "-"

	global S_6 = (`u1'-`u2')*sqrt(`n1')/`s1'	/* z */

	local col = 29 - int(length("`xname'")/2)
	di _n in gr _col(`col') "Ho: mean(" in ye "`xname'" /*
	*/ in gr ") = " in ye "`u2'" 

	di
	di in gr _col(7) "Ha: mean" in gr " < " in ye "`u2'" in gr /*
	*/ _col(30) "Ha: mean" in gr " ~= " in ye "`u2'" in gr 	/*
	*/ _col(57) "Ha: mean" in gr " > " in ye "`u2'"	

	di in gr _col(9) "z = " in ye %8.4f $S_6 /*
	*/ in gr _col(34) "z = " in ye %8.4f $S_6 /*
	*/ in gr _col(59) "z = " in ye %8.4f $S_6 

	local p2 = 2*(1-normprob(abs($S_6)))
	if $S_6 < 0 {
		local p1 = `p2'/2
		local p3 = 1 - `p1'
	}
	else {
		local p3 = `p2'/2
		local p1 = 1 - `p3'
	}
		
	di in gr _col(5) "P < z = " in ye %8.4f `p1' in gr _col(28) /*
	*/ "P > |z| = " in ye %8.4f `p2' in gr _col(55) "P > z = " /*
	*/ in ye %8.4f `p3'

end
exit
