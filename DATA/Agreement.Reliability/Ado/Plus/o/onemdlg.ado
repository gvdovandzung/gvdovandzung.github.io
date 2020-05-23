*! version 1.0.1  31jul1995
program define onemdlg
	version 5.0
	precmd onem

	window control static D_sm2 5 5 75 8 left
	global D_sm1 "By group"
	window control ssimple D_vl 5 15 75 60 D_var2

	window control static D_sm1 85 5 75 8 left
	global D_sm2 "Data variable"
	window control ssimple D_vl 85 15 75 60 D_var1
	getnv
	global D_vl "$S_1"
	window control button "OK" 12 75 30 16 D_b4
	window control button "Cancel" 67 75 30 16 D_b5
	window control button "Help" 122 75 30 16 D_b6 help
	global D_b4 "exit 3001"
	global D_b5 "exit 3000"
	global D_b6 "whelp sumbydlg"
	cap noi window dialog "One-way tabulation of means" . . 175 109
	if _rc>3000 {
		onemok
	}
end
