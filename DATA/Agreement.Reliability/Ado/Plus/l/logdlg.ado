*! version 1.0.0  12jul1995
program define logdlg
	version 5.0
	precmd log
	window control static D_sm1 5 7 70 8 left
	global D_sm1 "Dependent variable"
	window control ssimple D_sm3 5 17 75 60 D_depv
	window control static D_sm2 85 7 75 8 left
	global D_sm2 "Independent variable"
	window control ssimple D_vl 85 17 75 60 D_idepv
	getbv, zero
	global D_sm3 "$S_1"
	getnv
	global D_vl "$S_1"
	window control static D_sm4 2 78 162 23 blackframe
	window control static D_sm5 62 75 42 10 center
	global D_sm5 "Options"
	window control check "Display odds ratios rather than coefs." 5 86 140 8 D_cb1 right
	window control button "OK" 22 106 30 16 D_b1
	window control button "Cancel" 67 106 30 16 D_b2
	window control button "Help" 112 106 30 16 D_b3 help
	global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp logdlg"
	cap noi window dialog "Logistic regression" . . 175 140
	if _rc>3000 {
		logok
	}
end
