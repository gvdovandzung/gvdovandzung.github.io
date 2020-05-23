*! version 1.0.1  31jul1995
program define tsbydlg
	version 5.0
	precmd tsbydlg
	local func = "by"

	global D_sm2 "Row variable"
	window control static D_sm2       5  5 110  8 left
	window control scombo D_vl 5 15 110 90 D_var1

	global D_sm3 "Column variable"
	window control static D_sm3       5 30 110  8 left
	window control scombo D_vl 5 40 110 90 D_var2

	global D_sm1 "By group"
	window control static D_sm1      5 55 110  8 left
	window control scombo D_vl 5 65 110 90 D_var

	window control static D_sm4 2 87 115 51 blackframe
	window control static D_sm5 42 83 42 10 center

	global D_sm5 "Options"
	window control check "Report row percentages" 5 94 100 9 D_cb1 right
	window control check "Report column percentages" 5 104 100 9 D_cb2 right
	window control check "Report cell percentages" 5 114 100 9 D_cb3 right
	window control check "Report all statistics" 5 124 100 9 D_cb4 right

	window control button "OK"      5 145 30 16 D_b3
	window control button "Cancel" 45 145 30 16 D_b4
	window control button "Help"   85 145 30 16 D_b5 help
	getcv

	global D_vl "$S_1"
	global D_b3 "exit 3001"
	global D_b4 "exit 3000"
	global D_b5 "whelp twodlg"
	cap noi window dialog "Three-way tabulation (by group)" . . 125 183
	if _rc>3000 {
		twomok `func'
	}
end
