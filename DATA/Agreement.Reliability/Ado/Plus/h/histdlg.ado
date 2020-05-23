*! version 1.0.1  31jul1995
program define histdlg
	version 5.0
	precmd hist
	global D_run "1"
	window control static D_sm1 5 5 100 8 left
	global D_sm1 "Data variable"
	window control ssimple D_vl 5 15 120 52 D_gvar
	window control static D_sm4 2 73 125 64 blackframe
	window control static D_sm2 45 70 42 10 center
	global D_sm2 "Options"
	window control static D_sm3 5 81 43 8 left
	global D_sm3 "Range from"
	window control edit 50 81 22 8 D_nobs1
	window control static D_sm4 80 81 13 8 left
	global D_sm4 "to"
	window control edit 95 81 22 8 D_nobs2
	window control radbegin "Histogram with" 5 91 60 9 D_rb1 right
	window control edit 67 91 10 9 D_bins
	window control radend "Bins of width" 5 102 60 8 D_rb1 right
	window control static D_sm5 79 91 15 8 left
	global D_sm5 "bins"
	window control edit 67 102 22 9 D_nobs

	window control button "-" 95 91 10 10 D_b1
	window control button "+" 106 91 10 10 D_b2
	global D_b1 = "histbtn decr D_bins histok"
	global D_b2 = "histbtn incr D_bins histok"
	window control check "Overlay normal curve" 5 112 85 8 D_cb1 right
	window control check "Auto-redraw" 5 122 85 8 D_cb2 right
	getnv
	global D_vl "$S_1"
	window control button "Draw" 2 140 25 16 D_b3 default
	window control button "OK" 32 140 30 16 D_b4
	window control button "Cancel" 67 140 30 16 D_b5
	window control button "Help" 102 140 25 16 D_b6 help
	global D_b3 "histok"
	global D_b4 "exit 3001"
	global D_b5 "exit 3000"
	global D_b6 "whelp histdlg"
	cap noi window dialog "Continuous variable histogram" . . 137 175
	if _rc>3000 {
		histok
	}
	global D_run
end

program define histbtn
	version 5.0
	global D_rb1 1
	`1' `2' `3'
end
