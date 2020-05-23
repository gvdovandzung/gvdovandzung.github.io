*! version 1.0.1  31jul1995
program define tsumdlg
	version 5.0
	precmd tsumdlg
	local func = "summ"

	global D_sm3 "Data variable"
	window control static D_sm3 5  5 110 8 left
	window control scombo D_sm6 5 15 110 90 D_var

	global D_sm1 "Row group variable"
	window control static D_sm1 5 30 110 8 left
	window control scombo D_vl 5 40 110 90 D_var1

	global D_sm2 "Column group variable"
	window control static D_sm2 5 55 110 8 left
	window control scombo D_vl 5 65 110 90 D_var2

	getnv
	global D_sm6 "$S_1"
	window control button "OK" 5 85 30 16 D_b3
	window control button "Cancel" 45 85 30 16 D_b4
	window control button "Help" 85 85 30 16 D_b5 help

	getcv
	global D_vl "$S_1"
	global D_b3 "exit 3001"
	global D_b4 "exit 3000"
	global D_b5 "whelp sumbydlg"
	cap noi window dialog "Two-way tabulation of means" . . 125 120
	if _rc>3000 {
		twomok `func'
	}
end
