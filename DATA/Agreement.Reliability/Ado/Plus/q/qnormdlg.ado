*! version 1.0.1  31jul1995
program define qnormdlg
	version 5.0
	precmd qnorm
	global D_run "1"
	window control static D_sm1 5 5 120 8 left
	global D_sm1 "Data variable"
	window control ssimple D_vl 5 15 120 52 D_gvar
	getnv
	global D_vl "$S_1"
	window control button "Draw" 2 72 25 16 D_b3
	window control button "OK" 32 72 30 16 D_b4
	window control button "Cancel" 67 72 30 16 D_b5
	window control button "Help" 102 72 25 16 D_b6 help
	global D_b3 "qnormok"
	global D_b4 "exit 3001"
	global D_b5 "exit 3000"
	global D_b6 "whelp qnormdlg"
	global D_cmd "qnorm"
	cap noi window dialog "Normal quantile plot" . . 137 107
	if _rc>3000 {
		qnormok
	}
	global D_run
end
