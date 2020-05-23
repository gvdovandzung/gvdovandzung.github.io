*! version 1.0.0  19apr1995
program define calcrpn
	local cmd "`1'"
	mac shift
	
	if "`cmd'" == "addchar" {
	    local char "`1'"
	    if "$D_clr" != "" & "$D_exp1" != "" {
	    	global D_exp2 = $D_exp1
	    	global D_exp1
	    }
	    global D_exp1 = "${D_exp1}`char'"
	    global D_clr
	    exit
	}
	
	if "`cmd'"=="enter" {
		cpush $D_exp1
		global D_exp1
/*
		if $D_exp >= 5 {
			exit
		}
		local i = $D_exp + 1
		while `i'>=2 {
			local j= `i'-1
			global D_exp`i' = ${D_exp`j'}
			local i = `i'-1
		}
		global D_exp = $D_exp+1
*/
		global D_clr  "1"
	}

	if "`cmd'"=="drop" {
		if "$D_exp1"=="" {
			cpop D_exp1
		}
		global D_exp1
	}

	if "`cmd'"=="swap" {
		cpop D_exp2
		cpop D_exp3
		cpush $D_exp2
		global D_exp1 $D_exp3
	}

	if "`cmd'"=="cls" {
		global D_exp1
		global D_aexp
	}
		
	
	if "`cmd'"=="sub" {
		cpop D_exp2
		cpop D_exp3
		if "$D_exp2" != "" & "$D_exp3" != "" {
			global D_exp1 = $D_exp3 - $D_exp2
			global D_clr "1"
		}
	}

	if "`cmd'"=="sum" {
		cpop D_exp2
		cpop D_exp3
		if "$D_exp2" != "" & "$D_exp3" != "" {
			global D_exp1 = $D_exp3 + $D_exp2
			global D_clr "1"
		}
	}

	if "`cmd'"=="mul" {
		cpop D_exp2
		cpop D_exp3
		if "$D_exp2" != "" & "$D_exp3" != "" {
			global D_exp1 = $D_exp3 * $D_exp2
			global D_clr "1"
		}
	}

	if "`cmd'"=="div" {
		cpop D_exp2
		cpop D_exp3
		if "$D_exp2" != "" & "$D_exp3" != "" {
			global D_exp1 = $D_exp3 / $D_exp2
			global D_clr "1"
		}
	}

	if "`cmd'"=="chs" {
		cpop D_exp2
		if "$D_exp2" != "" {
			global D_exp1 = - $D_exp2
			global D_clr "1"
		}
	}

	if "`cmd'"=="sin" {
		cpop D_exp2
		if "$D_exp2" != "" {
			global D_exp1 = sin($D_exp2)
			global D_clr "1"
		}
	}

	if "`cmd'"=="cos" {
		cpop D_exp2
		if "$D_exp2" != "" {
			global D_exp1 = cos($D_exp2)
			global D_clr "1"
		}
	}

	if "`cmd'"=="inv" {
		cpop D_exp2
		if "$D_exp2" != "" {
			global D_exp1 = 1.0/$D_exp2
			global D_clr "1"
		}
	}

	if "`cmd'"=="sqrt" {
		cpop D_exp2
		if "$D_exp2" != "" {
			global D_exp1 = sqrt($D_exp2)
			global D_clr "1"
		}
	}

	if "`cmd'"=="exp" {
		cpop D_exp2
		if "$D_exp2" != "" {
			global D_exp1 = exp($D_exp2)
			global D_clr "1"
		}
	}

	if "`cmd'"=="log" {
		cpop D_exp2
		if "$D_exp2" != "" {
			global D_exp1 = log($D_exp2)
			global D_clr "1"
		}
	}

	if "`cmd'"=="yupx" {
		cpop D_exp2
		cpop D_exp3
		if "$D_exp2" != "" & "$D_exp3" != "" {
			global D_exp1 = $D_exp3 ^ $D_exp2
			global D_clr "1"
		}
	}

/*
	if "`cmd'"=="sub" & "$D_exp2"!="" {
		local tmp $D_exp1
		global D_exp1 = $D_exp2-$D_exp1
		global D_exp2 `tmp'
		global D_clr "1"
		global D_exp = $D_exp - 1
	}
	
	if "`cmd'"=="sum" & "$D_exp2"!="" {
		local tmp $D_exp1
		global D_exp1 = $D_exp2+$D_exp1
		global D_exp2 `tmp'
		global D_clr "1"
		exit
	}

	if "`cmd'"=="mul" & "$D_exp2"!="" {
		local tmp $D_exp1
		global D_exp1 = $D_exp2*$D_exp1
		global D_exp2 `tmp'
		global D_clr "1"
		exit
	}
	
	if "`cmd'"=="div"  & "$D_exp2"!="" {
		local tmp $D_exp1
		global D_exp1 = $D_exp2/$D_exp1
		global D_exp2 `tmp'
		global D_clr "1"
		exit
	}
	
	if "`cmd'"=="chs" {
		global D_exp1 = -$D_exp1
		global D_clr "1"
		exit
	}
	
	if "`cmd'"=="sin" {
		global D_exp1 = sin($D_exp1)
		global D_clr "1"
		exit
	}
	
	if "`cmd'"=="cos" {
		global D_exp1 = cos($D_exp1)
		global D_clr "1"
		exit
	}
	
	if "`cmd'"=="inv" {
		global D_exp1 = 1.0/$D_exp1
		global D_clr "1"
		exit
	}
	
	if "`cmd'"=="sqrt" {
		global D_exp1 = sqrt($D_exp1)
		global D_clr "1"
		exit
	}
	
	if "`cmd'"=="exp" {
		global D_exp1 = exp($D_exp1)
		global D_clr "1"
		exit
	}
	
	if "`cmd'"=="log" {
		global D_exp1 = log($D_exp1)
		global D_clr "1"
		exit
	}
	
	if "`cmd'"=="yupx" & "$D_exp2"!="" {
		local tmp $D_exp1
		global D_exp1 = $D_exp2^$D_exp1
		global D_exp2 `tmp'
		global D_clr "1"
		exit
	}
*/
	if "$D_exp1"!="" {
		cpush $D_exp1
		global D_exp1
	}
	global D_exps1 : word 1 of $D_aexp
	global D_exps2 : word 2 of $D_aexp
	global D_exps3 : word 3 of $D_aexp
	global D_exp1 : display %15.0g $D_exp1
	global D_exps1 : display %15.0g $D_exps1
	global D_exps2 : display %15.0g $D_exps2
	global D_exps3 : display %15.0g $D_exps3
end

program define showdisp
	version 5.0

	local i 2
	while `i'<=$D_exp & `i'<4 {
		global D_exps`i' = ${D_exp`i'}	
		local i = `i'+1
	}
end

program define cpush
	version 5.0

	global D_aexp "`1' $D_aexp"
end

program define cpop
	version 5.0

	local todef = "`1'"
	if "$D_exp1" != "" {
		global `todef' $D_exp1
		global D_exp1
		exit
	}
	parse "$D_aexp", parse(" ")
	global `todef' `1'
	mac shift
	global D_aexp "`*'"
end
