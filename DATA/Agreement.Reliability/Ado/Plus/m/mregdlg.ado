*! version 1.0.1  12jul1995
program define mregdlg
	version 5.0
	if "$D_cmd" != "mregdlg" {
		local flag 1
	}
	precmd mreg
	if "`flag'"!="" {
		global D_cb1 = 1
	}
	window control static D_sm1 5 10 70 8 left
	global D_sm1 "Dependent variable"
	window control ssimple D_vl 5 20 70 60 D_depv
	window control static D_sm2 80 10 90 8 left
	global D_sm2 "Independent variables"
	window control msimple D_vl 80 20 105 60 D_idepv
	window control static D_sm3 5 83 180 44 blackframe
	window control static D_sm4 62 80 42 10 center
	global D_sm4 "Options"

	window control radbegin "Use all selected variables (standard)" 17 91 165 9 D_rb1 right
	window control radio "Do a stepwise regression" 17 101 135 9 D_rb1 right
	window control radend "Durbin-Watson autocorrelation statistic" 17 111 160 8 D_rb1 right
	global D_rb1 1
	getnv
	global D_vl "$S_1"

	window control check "Show diagnostics menu" 55 133 90 9 D_cb1

	window control button "OK"     27 148 30 16 D_b1
	window control button "Cancel" 77 148 30 16 D_b2
	window control button "Help"  127 148 30 16 D_b3 help

	global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp mregdlg"

	cap noi window dialog "Multiple regression" . . 195 184
	if _rc>3000 {
		regok
	}
end
