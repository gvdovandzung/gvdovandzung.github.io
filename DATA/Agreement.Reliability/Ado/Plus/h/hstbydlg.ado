*! version 1.0.1  31jul1995
program define hstbydlg
	version 5.0
	precmd hist

	global D_run "1"
	window control static D_sm1 5 5 75 8 left
	global D_sm1 "Data variable"
	window control ssimple D_vl 5 15 75 60 D_gvar
	window control static D_sm2 85 5 75 8 left
	global D_sm2 "By group"
	window control ssimple D_sm3 85 15 75 60 D_gvby
	window control static D_sm4 2 78 162 43 blackframe
	window control static D_sm5 62 75 42 10 center
	global D_sm5 "Options"
	window control static D_sm6 5 86 62 8 left
	global D_sm6 "Number of bins"
	window control edit 68 86 15 9 D_bins
	window control button "-" 85 85 10 10 D_b1
	window control button "+" 96 85 10 10 D_b2
	global D_b1 = "decr D_bins hstbyok by"
	global D_b2 = "incr D_bins hstbyok by"
	window control check "Overlay normal curve" 5 96 85 8 D_cb1 right
	window control check "Auto-redraw" 5 106 85 8 D_cb2 right
	getnv
	global D_vl "$S_1"
	getcv
	global D_sm3 "$S_1"

	window control check "Include histogram of totals" 40 127 95 9 D_cb3 right

	window control button "Draw" 7 142 30 16 D_b3
	window control button "OK" 47 142 30 16 D_b4
	window control button "Cancel" 87 142 30 16 D_b5
	window control button "Help" 127 142 30 16 D_b6 help

	global D_b3 "hstbyok by"
	global D_b4 "exit 3001"
	global D_b5 "exit 3000"
	global D_b6 "whelp histdlg"
	cap noi window dialog "Continuous variable histograms by group" . . 175 180
	if _rc>3000 {
		hstbyok by
	}
	global D_run
end
