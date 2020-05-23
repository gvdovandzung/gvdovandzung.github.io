*! version 1.0.0  12jul1995
program define qc1dlg
	version 5.0
	precmd "q`1'"
	global D_run "1"
	local qc = "`1'"
	mac shift
	window control static D_sm1 5 5 110 8 left
	global D_sm1 "Sample measurement variables"
	window control msimple D_vl 5 15 120 52 D_gvar
	getnv
	global D_vl "$S_1"
	window control button "Draw" 2 70 27 16 D_b3
	window control button "OK" 32 70 30 16 D_b4
	window control button "Cancel" 67 70 30 16 D_b5
	window control button "Help" 102 70 27 16 D_b6 help
	global D_b3 "qc1ok `qc'"
	global D_b4 "exit 3001"
	global D_b5 "exit 3000"
	global D_b6 "whelp qcdlg"
	if "`qc'"=="range" {
		cap noi window dialog "Range (R) chart" . . 137 102
	}
	else if "`qc'"=="xbar" {
		cap noi window dialog "X-bar chart" . . 137 102
	}
	else if "`qc'"=="xbarpr" {
		cap noi window dialog "X-bar & R chart" . . 137 102
	}
	if _rc>3000 {
		qc1ok `qc'
	}
	global D_run
end
