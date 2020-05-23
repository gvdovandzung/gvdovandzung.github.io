*! version 1.0.1  31jul1995
program define boxdlg
	version 5.0
	precmd `1'
	global D_run "1"
	local box = "`1'"
	mac shift
	window control static D_sm1 5 5 120 8    left
	if "`box'"=="boxes" {
		global D_sm1 "Data variables"
	window control msimple D_vl 5 15 120 52 D_gvar
	}
	else {
		global D_sm1 "Data variable"
	window control ssimple D_vl 5 15 120 52 D_gvar
	}
	getnv
	global D_vl "$S_1"
	window control button "Draw" 2 72 25 16  D_b3
	window control button "OK" 32 72 30 16  D_b4
	window control button "Cancel" 67 72 30 16   D_b5
	window control button "Help" 102 72 25 16  D_b6 help
	global D_b3 "boxok `box'"
	global D_b4 "exit 3001"
	global D_b5 "exit 3000"
	global D_b6 "whelp boxdlg"
	if "`box'"=="box" {
		cap noi window dialog "Box plot" . . 137 107
	}
	else if "`box'"=="boxone" {
		cap noi window dialog "Box plot & one-way" . . 137 107 
	}
	else if "`box'"=="boxes" {
		cap noi window dialog "Box plot comparison of variables" . . 137 107
	}
	if _rc>3000 {
		boxok `box'
	}
	global D_run
end
