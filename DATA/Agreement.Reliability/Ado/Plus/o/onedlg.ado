*! version 1.0.1  31jul1995
program define onedlg
	version 5.0
	local f = ("$D_cmd"=="one" )
	precmd one
	if `f' == 0 {
		global D_cb1 = 0
	}
	window control static D_sm1 5 5 100 8 left
	global D_sm1 "Data variable"
	window control ssimple D_vl 5 15 120 52 D_var
	window control check "Include character plot" 10 67 95 9 D_cb1 right

	getcv
	global D_vl "$S_1"
	window control button "OK" 12 85 30 16 D_b3
	window control button "Cancel" 52 85 30 16 D_b4
	window control button "Help" 92 85 30 16 D_b5 help
	global D_b3 "exit 3001"
	global D_b4 "exit 3000"
	global D_b5 "whelp onedlg"
	cap noi window dialog "One-way (frequency) tabulation" . . 137 120
	if _rc>3000 {
		oneok
	}
end
