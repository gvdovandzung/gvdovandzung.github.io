*! version 1.0.1  31jul1995
program define scidlg
	version 5.0
	precmd sci
	window control static D_sm1 5 5 100 8 left
	global D_sm1 "Data variables (optional)"
	window control msimple D_vl 5 15 120 52 D_var
	getnv
	global D_vl "$S_1"
	window control static D_sm3 5 73 60 8 left
	global D_sm3 "Confidence level"
	window control edit 68 71 20 10 D_level
	window control button "OK" 12 87 30 16 D_b3
	window control button "Cancel" 52 87 30 16 D_b4
	window control button "Help" 92 87 30 16 D_b5 help
	global D_b3 "exit 3001"
	global D_b4 "exit 3000"
	global D_b5 "whelp scidlg"
	cap noi window dialog "Confidence intervals" . . 137 120
	if _rc>3000 {
		sciok
	}
end
