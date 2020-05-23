*! version 1.0.1  31jul1995
program define boxbydlg
	version 5.0
	precmd box
	global D_run "1"
	window control static D_sm1 5 5 75 8     left
	global D_sm1 "Data variable"
	window control ssimple D_vl 5 15 75 60 D_gvar
	window control static D_sm2 85 5 75 8     left
	global D_sm2 "By group"
	window control ssimple D_sm3 85 15 75 60 D_gvby
	getnv
	global D_vl "$S_1"
	getcv
	global D_sm3 "$S_1"

	window control check "Include box plot of total" 20 76 95 9 D_cb3 right

	window control button "Draw"    7 90 30 16  D_b3
	window control button "OK"     47 90 30 16  D_b4
	window control button "Cancel" 87 90 30 16  D_b5
	window control button "Help"  127 90 30 16  D_b6 help
	global D_b3 "boxok by"
	global D_b4 "exit 3001"
	global D_b5 "exit 3000"
	global D_b6 "whelp boxdlg"
	cap noi window dialog "Box plots by group" . . 175 130
	if _rc>3000 {
		boxok by
	}
	global D_run
end
