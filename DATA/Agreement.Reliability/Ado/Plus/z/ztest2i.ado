*! version 2.0.0  17oct1996
program define ztest2i
	version 5.0
	global S_5		/* will be dof	*/
	global S_6		/* will be t	*/
	parse "`*'", parse(" ,")

	confirm integer number `1'
	confirm number `2'
	confirm number `3'

	local n1 `1'
	local u1 `2'
	local s1 `3'
	mac shift 3
	confirm integer number `1'
	confirm number `2'
	confirm number `3'
	local n2 `1'
	local u2 `2'
	local s2 `3'

	if `n2'<=1 { error 2001 } 
	if `s2'<=0 { error 411  }
	if `n1'<=1 { error 2001 } 
	if `s1'<=0 { error 411  }

	if "$S_level"=="" {
		global S_level 95
	}
	if $S_level < 10 | $S_level > 99 {
		global S_level 95
	}

	mac shift 3

	local options "Level(integer $S_level)"
	parse "`*'"

	local xname "x" 
	local yname "y"
	local se1 = `s1'/sqrt(`n1')
	local se2 = `s2'/sqrt(`n2')
	local c1 = 53 - length("`xname'")
	local c2 = 53 - length("`yname'")

	noi di
	noi di in gr "`title'" in ye _col(`c1') "`xname'" in gr /*
	*/ _col(53) ": Number of obs = " /*
	*/ in ye %8.0g `n1'
	noi di in ye _col(`c2') "`yname'" in gr _col(53) ": Number of obs = " /*
	*/ in ye %8.0g `n2'
	_ttest1 `xname' `n1' `u1' `se1' normal `level'
	_ttest2 `yname' `n2' `u2' `se2' normal `level'
	di in gr "---------+" _dup(68) "-"
	local dm = `u1' - `u2'
	local ds = sqrt(`s1'^2/`n1' + `s2'^2/`n2')
	_ttest2 diff 0 `dm' `ds' normal `level'

	di in gr _dup(78) "-"

	di
	local c1 = 23 - int((length("`xname'") + length("`yname'"))/2)
	di in gr _col(`c1') "Ho: mean(" in ye "`xname'" in gr /*
	*/ ") - mean(" in ye "`yname'" in gr ") = diff = 0"
	di 
	di in gr _col(7) "Ha: diff" in gr " < " in ye "0" in gr	/*
	*/ _col(30) "Ha: diff" in gr " ~= " in ye "0" in gr 	/*
	*/ _col(57) "Ha: diff" in gr " > " in ye "0"

	global S_6 = `dm'/`ds'
	di in gr  _col(9) "z = " in ye %8.4f $S_6 /*
	*/ in gr _col(34) "z = " in ye %8.4f $S_6 /*
	*/ in gr _col(59) "z = " in ye %8.4f $S_6  

	local p2 = 2*normprob(-abs($S_6))
	if $S_6 < 0 {
		local p1 = `p2'/2
		local p3 = 1 - `p1'
	}
	else {
		local p3 = `p2'/2
		local p1 = 1 - `p3'
	}
		
	di in gr _col(5) "P < z = " in ye %8.4f `p1' /*
	*/ in gr _col(28) "P > |z| = " in ye %8.4f `p2' /*
	*/ in gr _col(55) "P > z = " in ye %8.4f `p3'
end
exit
