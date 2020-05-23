*! version 1.0.0  12jul1995
program define sp3dlg
	version 5.0
	precmd "s3`1'"
	global D_run "1"
	local func = "`1'"
	mac shift
	window control static D_sm1 5 5 110 8 left
	global D_sm1 "Y-axis variable"
	window control scombo D_vl 5 15 120 90 D_gvar
	window control static D_sm2 5 30 110 8 left
	global D_sm2 "X-axis variable"
	window control scombo D_vl 5 40 120 90 D_gvar2
	window control static D_sm3 5 55 110 8 left
	if "`func'"=="name" {
		global D_sm3 "Labeling variable"
	}
	else if "`func'"=="scale" {
		global D_sm3 "Variable to scale points"
	}
	else if "`func'"=="by" {
		global D_sm3 "By group"
	}
	window control scombo D_vla 5 65 120 90 D_gvby
	getnv
	global D_vl "$S_1"
	if "`func'"=="name" {
		getnv, all
	}
	else {
		getnv
	}
	global D_vla "$S_1"
	
	if "`func'"=="by" {
		window control check "Include plot of total" 20 85 95 9 D_cb3 right

		window control button "Draw" 2 100 25 16 D_b3
		window control button "OK" 32 100 30 16 D_b4
		window control button "Cancel" 67 100 30 16 D_b5
		window control button "Help" 102 100 25 16 D_b6 help
	}
	else {
		window control button "Draw" 2 85 25 16 D_b3
		window control button "OK" 32 85 30 16 D_b4
		window control button "Cancel" 67 85 30 16 D_b5
		window control button "Help" 102 85 25 16 D_b6 help
	}

	global D_b3 "sp3ok `func'"
	global D_b4 "exit 3001"
	global D_b5 "exit 3000"
	global D_b6 "whelp spdlg"
	if "`func'"=="name" {
		cap noi window dialog "Plot Y vs. X, naming points" . . 137 120
	}
	else if "`func'"=="scale" {
		cap noi window dialog "Plot Y vs. X, scaling symbols" . . 137 120
	}
	else if "`func'"=="by" {
		cap noi window dialog "Plot Y vs. X, by group" . . 137 135
	}
	if _rc>3000 {
		sp3ok `func'
	}
	global D_run
end
