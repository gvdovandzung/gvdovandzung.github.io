*! version 1.0.0  12jul1995
program define listdlg
	version 5.0
	precmd list
	window control static D_sm1 5 5 100 8 left
	global D_sm1 "Variables (optional)"
	window control msimple D_vl 5 15 120 52 D_var
	getnv, all
	global D_vl "$S_1"
	window control static D_sm3 5 73 60 8 left
	global D_sm3 "First observation"
	window control edit 68 71 20 10 D_nobs1
	if "$D_nobs1"=="" {
		global D_nobs1 1
	}
	if "$D_nobs2"=="" {
		global D_nobs2 = _N
	}
	window control static D_sm5 5 88 60 8 left
	global D_sm5 "Last observation"
	window control edit 68 86 20 10 D_nobs2
	window control button "OK" 12 102 30 16 D_b3
	window control button "Cancel" 52 102 30 16 D_b4
	window control button "Help" 92 102 30 16 D_b5 help
	global D_b3 "exit 3001"
	global D_b4 "exit 3000"
	global D_b5 "whelp listdlg"
	cap noi window dialog "List data" . . 137 135
	if _rc>3000 {
		listok
	}
end
