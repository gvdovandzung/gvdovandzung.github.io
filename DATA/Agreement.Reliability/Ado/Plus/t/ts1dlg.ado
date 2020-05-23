*! version 1.0.0  12jul1995
program define ts1dlg
	version 5.0
	precmd "ts1`1'"
	global D_run "1"
	local ts "`1'"
	mac shift
	window control static D_sm1 5 5 100 8 left
	if "`ts'"=="mto" {
		global D_sm1 "Y-axis variables"
	window control msimple D_vl 5 15 120 52 D_gvar
		window control check "Scale variables to 100%" 20 70 95 9 D_cb1 right
		getnv
		global D_vl "$S_1"
		window control button "Draw"    2 85 30 16 D_b3
		window control button "OK"     37 85 30 16 D_b4
		window control button "Cancel" 72 85 30 16 D_b5
		window control button "Help"  107 85 30 16 D_b6 help
	}
	else {
		global D_sm1 "Y-axis variable"
	window control ssimple D_vl 5 15 120 52 D_gvar
		getnv
		global D_vl "$S_1"
		window control button "Draw"    2 70 30 16 D_b3
		window control button "OK"     37 70 30 16 D_b4
		window control button "Cancel" 72 70 30 16 D_b5
		window control button "Help"  107 70 30 16 D_b6 help
	}
	global D_b3 "ts1ok `ts'"
	global D_b4 "exit 3001"
	global D_b5 "exit 3000"
	global D_b6 "whelp tsdlg"
	global D_cmd "ts1"
	if "`ts'"=="mto" {
		cap noi window dialog "Plot more than one Y vs. obs. no." . . 146 120
	}
	else {
		cap noi window dialog "Time series--Plot Y vs. obs. no." . . 146 108
	}
	if _rc>3000 {
		ts1ok `ts'
	}
	global D_run
end
