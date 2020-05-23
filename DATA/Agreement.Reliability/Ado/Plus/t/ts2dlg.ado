*! version 1.0.1  01aug1995
program define ts2dlg
	version 5.0
	precmd ts2
	global D_run "1"
	window control static D_sm1 5 5 75 8 left
	global D_sm1 "Y-axis variables"
	window control msimple D_vl 5 15 75 60 D_gvar
	window control static D_sm2 85 5 75 8 left
	global D_sm2 "X-axis variable"
	window control ssimple D_vl 85 15 75 60 D_gvar2
	window control check "Scale variables to 100%" 20 75 95 9 D_cb1 right
	getnv
	global D_vl "$S_1"
	window control button "Draw"    7 90 30 16 D_b3
	window control button "OK"     47 90 30 16 D_b4
	window control button "Cancel" 87 90 30 16 D_b5
	window control button "Help"  127 90 30 16 D_b6 help

	global D_b3 "ts2ok"
	global D_b4 "exit 3001"
	global D_b5 "exit 3000"
	global D_b6 "whelp tsdlg"
	cap noi window dialog "Time series--Plot more than one Y vs. X" . . 175 125
	if _rc>3000 {
		ts2ok
	}
	global D_run
end
