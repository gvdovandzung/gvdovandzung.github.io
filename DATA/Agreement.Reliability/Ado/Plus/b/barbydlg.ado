*! version 1.0.2  31jul1995
program define barbydlg
	version 5.0
	precmd "bar`1'"
	global D_run "1"
	local bars = "`1'"
	mac shift
	window control static D_sm1 5 5 75 8     left
	if "`bars'" == "bars" {
		global D_sm1 "Data variables"
	window control msimple D_vl 5 15 75 60 D_gvar
	}
	else {
		global D_sm1 "Data variable"
	window control ssimple D_vl 5 15 75 60 D_gvar
	}
	window control static D_sm2 85 5 75 8 left
	global D_sm2 "By group"
	window control ssimple D_sm3 85 15 75 60 D_gvby
	window control static D_sm4  9 78 150 40  blackframe
	window control static D_sm5 62 75  42 10   center
	global D_sm5 "Options"
	window control check "Bar height to reflect means" 18  86 110 10 D_cb1 right
	window control check "Include bar chart of total"  18 100 110 10 D_cb3 right
	getnv
	global D_vl "$S_1"
	getc2v
	global D_sm3 "$S_1"

	window control button "Draw"    11 125 30 16 D_b3
	window control button "OK"      51 125 30 16 D_b4
	window control button "Cancel"  91 125 30 16 D_b5
	window control button "Help"   131 125 30 16 D_b6 help
	global D_b3 "barok `bars'by"
	global D_b4 "exit 3001"
	global D_b5 "exit 3000"
	global D_b6 "whelp bardlg"
	if "`bars'"=="bars" {
		cap noi window dialog "Bar chart variables comparison by group" . . 175 161
	}
	else {
		cap noi window dialog "Bar charts by group" . . 175 161
	}
	if _rc>3000 {
		barok `bars'by
	}
	global D_run
end
