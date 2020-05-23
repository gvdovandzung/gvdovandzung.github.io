*! version 1.0.1  03aug1995
program define qc3dlg
	version 5.0
	precmd qc3
	global D_run "1"
	window control static D_sm1 5 5 110 8 left
	global D_sm1 "Variable for number defective"
	window control scombo D_vl 5 15 120 90 D_gvar
	window control static D_sm2 5 30 110 8 left
	global D_sm2 "Identification variable"
	window control scombo D_vl 5 40 120 90 D_gvar2
	window control static D_sm3 5 55 110 8 left
	global D_sm3 "Sample-size variable"
	window control scombo D_vl 5 65 120 90 D_gvby
	getnv
	global D_vl "$S_1"
	window control button "Draw" 2 85 25 16 D_b3
	window control button "OK" 32 85 30 16 D_b4
	window control button "Cancel" 67 85 30 16 D_b5
	window control button "Help" 102 85 25 16 D_b6 help
	global D_b3 "qc3ok"
	global D_b4 "exit 3001"
	global D_b5 "exit 3000"
	global D_b6 "whelp qcdlg"
	cap noi window dialog "Fraction defective (P) chart" . . 137 120
	if _rc>3000 {
		qc3ok
	}
	global D_run
end
