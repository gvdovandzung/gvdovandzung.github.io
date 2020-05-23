*! version 1.0.1  31jul1995
program define box1sdlg
	version 5.0
	precmd box1s
	global D_run "1"
	window control static D_sm1 5 5 120 8 left
	global D_sm1 "Data variables"
	window control msimple D_vl 5 15 120 60 D_gvar
	window control static D_sm4 2 77 125 24 blackframe
	window control static D_sm5 42 75 42 10  center
	global D_sm5 "Options"
	window control check "Scale each variable" 5 84 107 10 D_cb1 right
	getnv
	global D_vl "$S_1"
	window control button "Draw" 2 106 25 16 D_b3
	window control button "OK" 32 106 30 16 D_b4
	window control button "Cancel" 67 106 30 16  D_b5
	window control button "Help" 102 106 25 16 D_b6 help
	global D_b3 "boxok ones"
	global D_b4 "exit 3001"
	global D_b5 "exit 3000"
	global D_b6 "whelp boxdlg"
	cap noi window dialog "Box plot & one-way comparison" . . 135 141
	if _rc>3000 {
		boxok ones
	}
	global D_run
end
