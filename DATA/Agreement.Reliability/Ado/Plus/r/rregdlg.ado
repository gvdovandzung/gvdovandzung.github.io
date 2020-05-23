*! version 1.0.0  12jul1995
program define rregdlg
	version 5.0
	if "$D_cmd"!="rregdlg" {
		local flag = 1
	}
	precmd rreg
	if "`flag'"!="" {
		global D_cb1 = 1
	}
	window control static D_sm1 5 7 70 8 left
	global D_sm1 "Dependent variable"
	window control ssimple D_vl 5 17 70 60 D_depv
	window control static D_sm2 80 7 90 8 left
	global D_sm2 "Independent variables"
	window control msimple D_vl 80 17 105 60 D_idepv
	getnv
	global D_vl "$S_1"
	window control check "Show diagnostics menu" 55 85 90 9 D_cb1
	window control button "OK" 32 101 30 16 D_b1
	window control button "Cancel" 77 101 30 16 D_b2
	window control button "Help" 122 101 30 16 D_b3 help
	global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp rregdlg"
	cap noi window dialog "Robust regression" . . 195 138
	if _rc>3000 {
		regok rreg
	}
end
