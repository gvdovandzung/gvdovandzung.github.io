*! version 1.0.0  12jul1995
program define sregdlg
	version 5.0
	if "$D_cmd"!="sregdlg" {
		local flag 1
	}
	precmd sreg
	if "`flag'"!="" {
		global D_cb1 = 1
	}
	window control static D_sm1 5 7 70 8 left
	global D_sm1 "Dependent variable"
	window control ssimple D_vl 5 17 70 60 D_depv
	window control static D_sm2 80 7 90 8 left
	global D_sm2 "Independent variable"
	window control ssimple D_vl 80 17 105 60 D_idepv
	getnv
	global D_vl "$S_1"
	window control check "Show diagnostics menu" 55 75 90 9 D_cb1
	window control button "OK" 32 91 28 14 D_b1
	window control button "Cancel" 77 91 28 14 D_b2
	window control button "Help" 122 91 28 14 D_b3 help
	global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp sregdlg"
	cap noi window dialog "Simple regression" . . 195 128
	if _rc>3000 {
		regok
	}
end
