*! version 1.0.0  12jul1995
program define chbydlg
	version 5.0
	precmd chby

	global D_run "1"
	window control static D_sm1 5 5 75 8 left
	global D_sm1 "Data variable"
	window control ssimple D_vl 5 15 75 60 D_gvar
	window control static D_sm2 85 5 75 8 left
	global D_sm2 "By group"
	window control ssimple D_vl 85 15 75 60 D_gvby
	getcv
	global D_vl "$S_1"

	window control check "Include histogram of totals" 20 78 95 9 D_cb3 right

	window control button "Draw" 7 95 30 16 D_b3
	window control button "OK" 47 95 30 16 D_b4
	window control button "Cancel" 87 95 30 16 D_b5
	window control button "Help" 127 95 30 16 D_b6 help
	global D_b3 "chbyok"
	global D_b4 "exit 3001"
	global D_b5 "exit 3000"
	global D_b6 "whelp histdlg"
	cap noi window dialog "Discrete variable histograms by group" . . 175 135
	if _rc>3000 {
		chbyok
	}
	global D_run
end
