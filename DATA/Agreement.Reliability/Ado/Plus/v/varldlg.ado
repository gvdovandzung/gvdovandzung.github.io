*! version 1.0.0  12jul1995
program define varldlg
	version 5.0
	precmd varldlg

	global D_sm1 "Variable label"
	global D_sm2 "Variable to label"

	getnv
	global D_vl "$S_1"
	getsv
	global D_vl "$D_vl$S_1"

	window control static D_sm2 5 10 60 10
	window control scombo D_vl 67 10 80 60 D_sd1
	window control static D_sm1 5 25 60 8 left
	global D_var ""
	window control edit 67 25 80 10 D_var

	window control button "OK"     22 45 30 16 D_b1
	window control button "Cancel" 67 45 30 16 D_b2
	window control button "Help"  112 45 30 16 D_b3 help

	global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp varldlg"
	cap noi window dialog "Label variable" . . 175 80  
	if _rc>3000 {
		di in wh "label var $D_sd1 " _quote "$D_var" _quote
		window push label var $D_sd1 "$D_var"
		label var $D_sd1 "$D_var"
	}
end
