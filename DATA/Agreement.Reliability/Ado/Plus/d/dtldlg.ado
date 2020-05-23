*! version 1.0.0  12jul1995
program define dtldlg
	version 5.0
	precmd dtl
	window control static D_sm1 5 5 100 8 left
	global D_sm1 "Data variable"
	window control ssimple D_vl 5 15 120 52 D_var
	getnv
	global D_vl "$S_1"
	window control button "OK" 12 70 30 16 D_b3
	window control button "Cancel" 52 70 30 16 D_b4
	window control button "Help" 92 70 30 16 D_b5 help
	global D_b3 "exit 3001"
	global D_b4 "exit 3000"
	global D_b5 "whelp dtldlg"
	cap noi window dialog "Median/Percentiles" . . 137 102 
	if _rc>3000 {
		dtlok
	}
end
