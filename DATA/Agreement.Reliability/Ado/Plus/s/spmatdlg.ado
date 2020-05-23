*! version 1.0.1  31jul1995
program define spmatdlg
	version 5.0
	precmd spmat
	global D_run "1"
	window control static D_sm1 5 5 100 8 left
	global D_sm1 "Data variables"
	window control msimple D_vl 5 15 120 52 D_gvar
	getnv
	global D_vl "$S_1"
	window control button "Draw" 2 70 25 16 D_b3
	window control button "OK" 32 70 30 16 D_b4
	window control button "Cancel" 67 70 30 16 D_b5
	window control button "Help" 102 70 25 16 D_b6 help
	global D_b3 "spmatok"
	global D_b4 "exit 3001"
	global D_b5 "exit 3000"
	global D_b6 "whelp spdlg"
	cap noi window dialog "Scatterplot matrix" . . 137 102
	if _rc>3000 {
		spmatok
	}
	global D_run
end
