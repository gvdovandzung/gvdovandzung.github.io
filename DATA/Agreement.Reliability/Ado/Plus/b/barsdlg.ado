*! version 1.0.1  31jul1995
program define barsdlg
	version 5.0
	precmd barsdlg
	global D_run "1"
	window control static D_sm1 5 5 100 8 left
	global D_sm1 "Data variables"
	window control msimple D_vl 5 15 120 52 D_gvar
	window control static D_sm4 2 73 125 22  blackframe
	window control static D_sm5 45 70 42 10  center
	global D_sm5 "Options"
	window control check "Bar height to reflect means" 5 79 110 10 D_cb1 right
	getnv
	global D_vl "$S_1"
	window control button "Draw"    2 98 25 16  D_b3
	window control button "OK"     32 98 30 16  D_b4
	window control button "Cancel" 67 98 30 16  D_b5
	window control button "Help"  102 98 25 16  D_b6 help
	global D_b3 "barok bars"
	global D_b4 "exit 3001"
	global D_b5 "exit 3000"
	global D_b6 "whelp bardlg"
	global D_cmd "bar"
	cap noi window dialog "Bar chart comparison of variables" . . 137 131
	if _rc>3000 {
		barok bars
	}
	global D_run
end
