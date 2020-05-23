*! version 1.1.0  04aug1995
program define seqdlg
	version 5.0
	
        precmd seqdlg
	if "$D_sd1"=="" {
		global D_sd1 1
	}
	if "$D_mean1"=="" {
		global D_mean1 1
	}
	if "$D_var2"=="" {
		global D_var2 1
	}
	
	global D_sm1  "New variable name"
	global D_sm2  "Starting value"
	global D_sm3  "Ordinary:    Step by"
	global D_sm4  "Grouped:    Group size"
	global D_sm5  "step between groups"
	global D_sm6  "Repeated:  Ending value"
	global D_sm8  "step by"
	global D_sm9  "Choose type of sequence"

	window control static D_sm1        7  5  65 10 
	window control edit 75 5 35 10 D_var
        window control static D_sm2        7 20  65 10 
	window control edit 75 20 30 10 D_var1
	window control static D_sm10       3 38 209 55 blackframe
	window control static D_sm9       60 35 100 10 center 
	
	window control radbegin "$D_sm3"   7 48  73 10 D_rb1
	window control edit 83 49 20 10 D_sd1
	window control radio    "$D_sm4"   7 63  83 10 D_rb1
	window control edit 93 64 20 10 D_nobs
        window control static   D_sm5    117 65  70 10 
	window control edit 188 64 20 10 D_var2
	window control radend   "$D_sm6"   7 78  90 10 D_rb1
	window control edit 100 79 20 10 D_sd2
	window control static   D_sm8    125 80  25 10
	window control edit 154 79 20 10 D_mean1
	
	window control button "Preview" 84 100 45 16 D_b4
	window control static D_sm7     17 118 180 10
	
	window control button "OK"      52 132 30 16 D_b1
	window control button "Cancel"  92 132 30 16 D_b2
	window control button "Help"   132 132 30 16 D_b3 help
	
	global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp seqdlg"
	global D_b4 "seqprev"
	
	cap noi window dialog "Generate integer sequence" . . 220 166
	if _rc>3000 {
		if "$D_var"=="" {
			noi di in red "no variable name specified"
			exit
		}
		noi seqok
	}
end
	
program define seqprev
	version 5.0
	
	preserve
	capture confirm new var $D_var
	local rc = _rc
	capture confirm var $D_var
	if _rc>0 & `rc' {
		global D_sm7 "Error: missing or illegal new variable name"
		restore
		exit
	}
	capture confirm number $D_var1
	if _rc>0 {
		global D_sm7 "Error: missing or illegal starting value"
		restore
		exit
	}
	quietly {
		tempvar x
		drop _all
		set obs 20
		if $D_rb1 == 1 {
			capture confirm number $D_sd1
			if _rc>0 {
				global D_sm7 /*
			*/ "Error: missing or illegal increment value"
				restore
				exit
			}
			gen int `x' = _n-1+$D_var1
			replace `x' = `x'[_n-1]+$D_sd1 in 2/l
		}
		else if $D_rb1 == 2 {
			capture confirm number $D_nobs
			if _rc>0 | "$D_nobs"=="" {
				global D_sm7 /*
			*/ "Error: missing or illegal group size value"
				restore
				exit
			}
			if int($D_nobs) != $D_nobs {
				global D_sm7 /*
			*/ "Error: group size must be an integer"
				restore
				exit
			}
			if $D_nobs <= 0 {
				global D_sm7 /*
			*/ "Error: group size must be positive"
				restore
				exit
			}
			capture confirm number $D_var2
			if _rc>0 {
				global D_sm7 /* 
			*/ "Error: missing or illegal step between groups value"
				restore
				exit
			}
			gen int `x' = int((_n-1)/$D_nobs)+1
			replace `x' = `x'*$D_var2
			local diff  = `x'[1] - $D_var1
			replace `x' = `x'-`diff'
		}
		else {
			capture confirm number $D_mean1
			if _rc>0 {
				global D_sm7 /*
			*/ "Error: missing or illegal by value"
				restore
				exit
			}
			capture confirm number $D_sd2
			if _rc>0 {
				global D_sm7 /*
			*/ "Error: missing or illegal ending value"
				restore
				exit
			}
			if ($D_sd2-$D_var1)/$D_mean1 != /*
			*/ int(($D_sd2-$D_var1)/$D_mean1) {
				global D_sm7 /*
			*/ "Error: by value must reach end value exactly"
				restore
				exit
			}
			if $D_sd2>$D_var1 &  $D_mean1 <= 0 {
				global D_sm7 /*
	*/ "Error: ending value > starting value and step < 0"
				restore
				exit
			}
			if $D_sd2<$D_var1 &  $D_mean1 >= 0 {
				global D_sm7 /*
	*/ "Error: ending value < starting value and step > 0"
				restore
				exit
			}
			gen int `x' = /*
		*/ mod(_n-1,($D_sd2-$D_var1)/$D_mean1+1)*$D_mean1+$D_var1
		}
	}
	local i 1
 	while `i'<=20 {
		local xx : di %9.0g `x'[`i']
		local xx = trim("`xx'")
		
		local list "`list'`xx',"
		local i=`i'+1
	}
	global D_sm7 "`list'..."
	restore
end

		
program define seqok
	version 5.0
	
	quietly describe
	if _result(1) == 0 {
		noi setodlg
		if trim("$D_nnn")=="" {
			noi di in red "obs set to 0"
			exit 198
		}
		if $D_nnn > 600 & "$S_FLAVOR"=="Quest" {
			noi di in red /*
			*/ "too many observations for StataQuest - set to 600"
			global D_nnn = 600
		}
		noi di in white "set obs $D_nnn"
		window push set obs $D_nnn
		set obs $D_nnn
		noi di in wh _newline ". " _continue
		global D_nnn
	}
	
	capture confirm new var $D_var
	if _rc>0 {
		capture noi window stopbox rusure /*
		*/ "Variable already exists!" "OK to replace, Cancel to exit"
		if _rc > 0 {
			exit
		}
	}
	
        quietly {
		describe
		local n = _result(1)
		capture drop $D_var
		describe
		if _result(1)==0 {
			set obs `n'
		}
		
		if $D_rb1 == 1 {
			capture confirm number $D_sd1
			if _rc>0 {
				noi di in red /*
			*/ "missing or illegal increment value"
				exit
			}
			gen int $D_var = _n-1+$D_var1
			replace $D_var = $D_var[_n-1]+$D_sd1 in 2/l
		}
		else if $D_rb1 == 2 {
			capture confirm number $D_nobs
			if _rc>0 {
				noi di in red /*
				*/ "Error: missing or illegal group size value"
				exit
			}
			if $D_nobs <= 0 {
				noi di in red /*
				*/ "group size must be positive"
				exit
			}
			capture confirm number $D_var2
			if _rc>0 {
				noi di in red /*
			*/ "missing or illegal step between groups value"
				exit
			}
			gen int $D_var = int((_n-1)/$D_nobs)+1
			replace $D_var = $D_var*$D_var2
			local diff  = $D_var[1] - $D_var1
			replace $D_var = $D_var-`diff'
		}
		else {
			capture confirm number $D_sd2
			if _rc>0 {
				noi di in red /*
				*/ "missing or illegal ending value"
				exit
			}
			capture confirm number $D_mean1
			if _rc>0 {
				global D_sm7 /*
			*/ "Error: missing or illegal by value"
				restore
				exit
			}
			if $D_sd2<$D_var1 {
				noi di in red /*
				*/ "ending value must be > starting value"
				exit
			}
			if ($D_sd2-$D_var1)/$D_mean1 != /*
			*/ int(($D_sd2-$D_var1)/$D_mean1) {
				global D_sm7 /*
			*/ "Error: by value must reach end value exactly"
				restore
				exit
			}
			gen int $D_var = /*
		*/ mod(_n-1,($D_sd2-$D_var1)/$D_mean1+1)*$D_mean1+$D_var1
		}
	}
end
