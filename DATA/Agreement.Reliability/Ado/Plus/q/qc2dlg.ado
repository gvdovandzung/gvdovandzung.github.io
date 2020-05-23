*! version 1.0.0  12jul1995
program define qc2dlg
	version 5.0
	precmd qc2

	global D_run "1"
	window control static D_sm1 5 5 75 8 left
	global D_sm1 "Defect counts variable"
	window control ssimple D_vl 5 15 75 60 D_gvar
	window control static D_sm2 85 5 75 8 left
	global D_sm2 "Identification variable"
	window control ssimple D_vl 85 15 75 60 D_gvar2
	getnv
	global D_vl "$S_1"
	window control button "Draw" 7 76 30 16 D_b3
	window control button "OK" 47 76 30 16 D_b4
	window control button "Cancel" 87 76 30 16 D_b5
	window control button "Help" 127 76 30 16 D_b6 help
	global D_b3 "qc2ok"
	global D_b4 "exit 3001"
	global D_b5 "exit 3000"
	global D_b6 "whelp qcdlg"
	cap noi window dialog "Control (C) chart for defects" . . 175 107
	if _rc>3000 {
		qc2ok
	}
	global D_run
end
