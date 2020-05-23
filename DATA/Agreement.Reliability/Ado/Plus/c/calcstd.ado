*! version 1.0.0  19apr1995
program define calcstd
	local cmd "`1'"
	mac shift
	
	if "`cmd'" == "addchar" {
		local char "`1'"
		if "$D_clr" != "" & "$D_exp" != "" {
			global D_exp2 = $D_exp
			global D_exp 
		}
		if ("`char'"=="." & index("$D_exp",".")==0) | "`char'"!="." {
			global D_exp = "${D_exp}`char'"
		}
		global D_clr
		global D_exp = substr("$D_exp",1,15)
*		global D_exp : display %15.0g $D_exp
*		if "`char'"=="." & substr("$D_exp",length("$D_exp"),1)!="." {
*			global D_exp "${D_exp}."
*		}
		exit
	}
	
	if "`cmd'"=="enter" & "$D_purp"!="" {
		global D_exp = $D_exp2$D_purp$D_exp
		global D_exp2 
		global D_purp ""
		global D_clr "1"
		global D_exp : display %15.0g $D_exp
		exit
	}
	
	if "`cmd'"=="sub" {
		if "$D_purp" != "" {
			global D_exp = $D_exp2$D_purp$D_exp
		}
		global D_exp2 = $D_exp
		global D_purp = "-"
		global D_clr "1"
		global D_exp : display %15.0g $D_exp
		exit
	}
	
	if "`cmd'"=="sum" {
		if "$D_purp" != "" {
			global D_exp = $D_exp2$D_purp$D_exp
		}
		global D_exp2 = $D_exp
		global D_purp = "+"
		global D_clr "1"
		global D_exp : display %15.0g $D_exp
		exit
	}
	
	if "`cmd'"=="mul" {
		if "$D_purp" != "" {
			global D_exp = $D_exp2$D_purp$D_exp
		}
		global D_exp2 = $D_exp
		global D_purp = "*"
		global D_clr "1"
		global D_exp : display %15.0g $D_exp
		exit
	}
	
	if "`cmd'"=="div" {
		if "$D_purp" != "" {
			global D_exp = $D_exp2$D_purp$D_exp
		}
		global D_exp2 = $D_exp
		global D_purp = "/"
		global D_clr "1"
		global D_exp : display %15.0g $D_exp
		exit
	}
	
	if "`cmd'"=="chs" {
		global D_exp = -$D_exp
		global D_clr "1"
		global D_exp : display %15.0g $D_exp
		exit
	}
	
	if "`cmd'"=="sin" {
		global D_exp = sin($D_exp)
		global D_clr "1"
		global D_exp : display %15.0g $D_exp
		exit
	}
	
	if "`cmd'"=="cos" {
		global D_exp = cos($D_exp)
		global D_clr "1"
		global D_exp : display %15.0g $D_exp
		exit
	}
	
	if "`cmd'"=="inv" {
		global D_exp = 1.0/$D_exp
		global D_clr "1"
		global D_exp : display %15.0g $D_exp
		exit
	}
	
	if "`cmd'"=="sqrt" {
		global D_exp = sqrt($D_exp)
		global D_clr "1"
		global D_exp : display %15.0g $D_exp
		exit
	}
	
	if "`cmd'"=="exp" {
		global D_exp = exp($D_exp)
		global D_clr "1"
		global D_exp : display %15.0g $D_exp
		exit
	}
	
	if "`cmd'"=="log" {
		global D_exp = log($D_exp)
		global D_clr "1"
		global D_exp : display %15.0g $D_exp
		exit
	}
	
	if "`cmd'"=="yupx" & "$D_exp2"!="" {
		if "$D_purp" != "" {
			global D_exp = $D_exp2$D_purp$D_exp
		}
		global D_exp2 = $D_exp
		global D_purp = "^"
		global D_clr "1"
		global D_exp : display %15.0g $D_exp
		exit
	}
		
end
