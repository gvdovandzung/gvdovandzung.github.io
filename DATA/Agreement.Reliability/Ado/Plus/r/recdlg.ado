*! version 1.0.0  2aug1995
program define recdlg
	version 5.0

	precmd recdlg

	recvar "Recode values of"
	if "$D_sm4"=="" {
		exit
	}


	global D_sm1 "Value range"
	global D_sm2 "Recoded value"
	global D_sm3 "Variable:"
	global D_sm6 "-"
	global D_sm7 "---->"
	global D_sm8 ""

	global D_val1
	global D_val2
	global D_lab 

	window control static D_sm3 15 5 28 9
	window control static D_sm4 50 5 50 9 

	window control static D_sm1 14 20 45  9 
	window control edit 15 30 15 9 D_val1
	window control static D_sm6 31 30  5  9 center
	window control edit 37 30 15 9 D_val2

	window control static D_sm7 58 30 12 9

	window control static D_sm2 65 20 48 9
	window control edit 76 30 15 9 D_lab

	window control static D_sm8    5 61 115 12 

	window control button "First"  5 43 30 16 D_b1
	window control button "Prev"  37 43 30 16 D_b2
	window control button "Next"  69 43 30 16 D_b3
	window control button "Last" 101 43 30 16 D_b4

	window control button "OK"      12 78 30 16 D_b5
	window control button "Cancel"  46 78 30 16 D_b7
	window control button "Help"    80 78 30 16 D_b6 help

	global D_b1 "rlabok 1"
	global D_b2 "rlabok 2"
	global D_b3 "rlabok 3"
	global D_b4 "rlabok 4"
	global D_b5 "rlabok 5"
	global D_b6 "whelp recdlg"
	global D_b7 "exit 3000"

	global D_c 1

	cap noi window dialog "Recode values" . . 142 120
	global D_Dlgy = _result(1)
	if _rc>3000 {
		deflab 1
	}
	cleanup 
end

program define rlabok
	version 5.0
	local arg = `1'

	global D_vl$D_c "$D_val1"
	global D_vr$D_c "$D_val2"
	global D_lb$D_c "$D_lab"

	if `arg'==1 {
		global D_c = 1
	}
	if `arg'==2 & $D_c > 1 {
		global D_c = $D_c - 1
	}
	if `arg'==3 & $D_c < $D_cm {
		global D_c = $D_c + 1
	}
	if `arg'==4 {
		global D_c = $D_cm
	}
	global D_val1 "${D_vl$D_c}"
	global D_val2 "${D_vr$D_c}"
	global D_lab  "${D_lb$D_c}"

	if trim("$D_lab")=="" {
		global D_lab
	}
	if `arg'==5 {
		deflab 0
	}
end

program define deflab
	version 5.0
	local arg = `1'
	
	local larg ""

	local flag = 0
	local i 1
	while `i' <= $D_cm {
		if trim("${D_lb`i'}") == "" {
			local flag 1
		}
		if trim("${D_vl`i'}")=="" & trim("${D_vr`i'}")=="" {
			local flag 1
		}
		local i = `i'+1
	}

	if `flag' {
		global D_sm8 "missing label"
		exit
	}

	local i 1
	while `i'<=$D_cm {
		if trim("${D_vl`i'}")!="" & trim("${D_vr`i'}")!="" {
			local larg "`larg' ${D_vl`i'}/${D_vr`i'}=${D_lb`i'}"
		}
		else    local larg "`larg' ${D_vl`i'}${D_vr`i'}=${D_lb`i'}"
		local i = `i'+1
	}
	if `arg' == 1 {
		noi di in white ". gen $D_sd1 = $D_sm4"
		window push gen $D_sd1=$D_sm4
		gen $D_sd1=$D_sm4
		noi di in white ". recode $D_sd1 `larg'"
		window push recode $D_sd1 `larg'
		recode $D_sd1 `larg'
	}
	else {
		tempvar tt
		gen `tt' = $D_sm4
		capture recode `tt' `larg'
		if _rc>0 {
			global D_sm8 "illegal arguments -- please check"
			exit
		}
		else {
			global D_sm8
			exit 3001
		}
	}
end


program define cleanup
	version 5.0

	local i 1
	while `i' <= $D_cm {
		global D_vl`i'	
		global D_vr`i'	
		global D_lb`i'	
		local i = `i'+1
	}
	global D_c
	global D_cm
	global D_lab
end

program define recvar
	version 5.0

	global D_sm1 "Recode values of"
	global D_sm2 "into"
	global D_sm3 "values (or classes)"
	global D_sm6 "New variable name"

	getnv
	global D_vlist "$S_1"

	window control static D_sm1 5 5 90 9
	window control ssimple D_vlist 20 15 55 60 D_sm4

	window control static D_sm2 10 76 14 10
	window control edit 25 76 13 10 D_cm
	window control static D_sm3 40 76 70 10 

	window control static D_sm6 10 90 63 10 
	window control edit 74 90 30 10 D_sd1

	window control button "OK"      5 105 30 16 D_b1
	window control button "Cancel" 40 105 30 16 D_b3
	window control button "Help"   75 105 30 16 D_b2 help

	global D_b1 "chkname"
	global D_b2 "whelp recdlg"
	global D_b3 "exit 3000"

	cap noi window dialog "Choose variable" . . 120 145

	if _rc>3000 == 0 {
		global D_sm4
	}
end

program define chkname
	version 5.0
	
	if "$D_sd1" == "" {
		window stopbox stop "Please specify a new variable to hold the result"
		exit
	}

	if "$D_sd1"=="" {
		window stopbox stop "Please specify a variable name"
		exit
	}

	capture confirm var $D_sd1
	if !_rc {
		cap window stopbox rusure "$D_sd1 already exists."/*
			*/ "(OK to replace; Cancel to abort)"
		if _rc>0 { exit }
		di in wh "drop $D_sd1"
		window push replace drop $D_sd1
		drop $D_sd1
	}

	if "$D_cm" == "" {
		window stopbox stop "Please specify the number of classes"
		exit
	}

	if "$D_sm4" == "" {
		window stopbox stop "Please choose a variable to recode"
		exit
	}

	if $D_cm < 1 {
		window stopbox stop "Illegal number of classes"
		exit
	}

	di in wh "summ $D_sm4, detail"
	window push summ $D_sm4, detail
	summ $D_sm4, detail
	exit 3001
end

