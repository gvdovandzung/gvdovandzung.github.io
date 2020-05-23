*! version 1.0.1  31jul1995
program define summdlg
	version 5.0
	precmd summ
	window control static D_sm1 5 5 100 8 left
	global D_sm1 "Data variables (optional)"
	window control msimple D_vl 5 15 120 52 D_var
	getnv
	global D_vl "$S_1"
	window control button "OK" 12 70 30 16 D_b3
	window control button "Cancel" 52 70 30 16 D_b4
	window control button "Help" 92 70 30 16 D_b5 help
	global D_b3 "exit 3001"
	global D_b4 "exit 3000"
	global D_b5 "whelp summdlg"
	cap noi window dialog "Means and SDs" . . 137 102
	if _rc>3000 {
		summok
	}
end
