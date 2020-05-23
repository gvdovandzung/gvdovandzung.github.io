*! version 1.0.0  3jul1995
program define vlabvar
	version 5.0

	global D_sm1 "`1'"
	global D_sm4

	getcv
	global D_vlist "$S_1"

	window control static D_sm1          10 5 90 9
	window control ssimple D_vlist 25 15 55 60 D_sm4

	window control button "OK"      5 76 30 16 D_b1
	window control button "Cancel" 40 76 30 16 D_b3
	window control button "Help"   75 76 30 16 D_b2 help

	global D_b1 "exit 3001"
	global D_b2 "whelp vlabdlg"
	global D_b3 "exit 3000"

	cap noi window dialog "Choose variable" . . 115 110

	if _rc == 3000 {
		global D_sm4
	}
end
