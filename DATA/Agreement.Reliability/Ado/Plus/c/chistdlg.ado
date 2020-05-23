*! version 1.0.0  12jul1995
program define chistdlg
	version 5.0
	precmd chist
	global D_run "1"
	window control static D_sm1 5 5 100 8 left
	global D_sm1 "Data variable"
	window control ssimple D_vl 5 15 120 52 D_gvar
	getiv
	global D_vl "$S_1"
	window control button "Draw" 2 73 25 16 D_b3
	window control button "OK" 32 73 30 16 D_b4
	window control button "Cancel" 67 73 30 16 D_b5
	window control button "Help" 102 73 25 16 D_b6 help
	global D_b3 "chistok"
	global D_b4 "exit 3001"
	global D_b5 "exit 3000"
	global D_b6 "whelp histdlg"
	cap noi window dialog "Discrete variable histogram" . . 137 108
	if _rc>3000 {
		chistok
	}
	global D_run
end
