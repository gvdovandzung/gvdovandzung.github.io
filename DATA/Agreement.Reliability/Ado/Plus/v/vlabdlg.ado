*! version 1.0.0  3jul1995
program define vlabdlg
	version 5.0

	precmd vlabdlg

	global D_sm1 "Value"
	global D_sm2 "Label (max. 8 chars.)"
	global D_sm3 "Variable"
	global D_sm4 "foreign"

	vlabvar "Define value labels for"

	if "$D_sm4"=="" {
		exit
	}

	noisily getvar   

	window control static D_sm3 15 5 28 9
	window control static D_sm4 50 5 50 9 

	window control static D_sm5 14 29 27 11 blackframe
	window control static D_sm1 15 20 25  9 
	window control static D_val 15 30 25  9

	window control static D_sm2 45 20 78 9
	window control edit 45 30 55 9 D_lab

	window control button "First"  5 43 30 16 D_b1
	window control button "Prev"  37 43 30 16 D_b2
	window control button "Next"  69 43 30 16 D_b3
	window control button "Last" 101 43 30 16 D_b4

	window control button "OK"      15 67 30 16 D_b5
	window control button "Cancel"  54 67 30 16 D_b7
	window control button "Help"    93 67 30 16 D_b6 help

	global D_b1 "labelok 1"
	global D_b2 "labelok 2"
	global D_b3 "labelok 3"
	global D_b4 "labelok 4"
	global D_b5 "labelok 5"
*	global D_b5 "exit 3001"
	global D_b6 "whelp vlabdlg"
	global D_b7 "exit 3000"

	cap noi window dialog "Label values" . . 147 103
	global D_Dlgy = _result(1)
	if _rc>3000 {
		deflab
	}
	cleanup 
end

program define getvar
	version 5.0

	tempvar g s
	gen int `s' = _n
	qui egen `g' = group($D_sm4)
	qui summ `g'
	local max = _result(6)

	tempvar gl n
	qui gen `n' = _n
	local vl : value label $D_sm4
	if "`vl'"!="" {
		qui decode $D_sm4, generate(`gl')
	}
	else { qui generate str1 `gl' = "" }

	tempvar tmp
	qui gen `tmp'=.
	local i 1
	while `i' <= `max' {
		qui replace `tmp' = (`g'==`i')*`n'
		qui summ `tmp' if `g'==`i'
		local ind = _result(5)
		global D_val`i' = $D_sm4[`ind']
		global D_lab`i' : di `gl'[`ind']
		local i = `i'+1
	}

	global D_val = $D_val1
	global D_lab = "$D_lab1"
	global D_c = 1
	global D_cm = `max'
	sort `s'
end
	
program define labelok
	version 5.0
	local arg = `1'

	global D_lab$D_c "$D_lab"
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
	global D_val = ${D_val$D_c}
	global D_lab "${D_lab$D_c}"
	if trim("$D_lab")=="" {
		global D_lab
	}
	if `arg'==5 {
		exit 3001
	}
end

program define deflab
	version 5.0
	
	local larg ""

	local i 1
	while `i' <= $D_cm {
		if trim("${D_lab`i'}") != "" {
			local flag 1
		}
		local i = `i'+1
	}

	if "`flag'"=="" {
		exit
	}

	capture label drop $D_sm4
	label values $D_sm4
	local i 1
	while `i' <= $D_cm {
		local p : di "${D_lab`i'}"
		local p = trim("`p'")
		if "`p'" != "" {
			label define $D_sm4 ${D_val`i'} "`p'", add
		}
		else {
			label define $D_sm4 ${D_val`i'} "`p'", modify
		}
		local i = `i'+1
	}
	label values $D_sm4 $D_sm4
end

program define cleanup
	version 5.0

	local i 1
	while `i' <= $D_cm {
		global D_val`i'	
		global D_lab`i'	
		local i = `i'+1
	}
	global D_c
	global D_cm
end

