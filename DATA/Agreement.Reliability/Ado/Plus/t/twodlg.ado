*! version 1.0.0  12jul1995
program define twodlg
	version 5.0
	precmd two

	window control static D_sm1 5 5 75 8 left
	global D_sm1 "Row variable"
	window control ssimple D_vl 5 15 75 60 D_var1
	window control static D_sm2 85 5 75 8 left
	global D_sm2 "Column variable"
	window control ssimple D_vl 85 15 75 60 D_var2
	window control static D_sm4 2 77 162 51 blackframe
	window control static D_sm5 62 74 42 10 center
	global D_sm5 "Options"
	window control check "Report row percentages" 5 85 100 9 D_cb1 right
	window control check "Report column percentages" 5 95 100 9 D_cb2 right
	window control check "Report cell percentages" 5 105 100 9 D_cb3 right
	window control check "Report all statistics" 5 115 100 9 D_cb4 right
	getcv
	global D_vl "$S_1"
	window control button "OK" 12 133 30 16 D_b4
	window control button "Cancel" 67 133 30 16 D_b5
	window control button "Help" 122 133 30 16 D_b6 help
	global D_b4 "exit 3001"
	global D_b5 "exit 3000"
	global D_b6 "whelp twodlg"
	cap noi window dialog "Two-way (cross) tabulation" . . 175 165
	if _rc>3000 {
		twook
	}
end
