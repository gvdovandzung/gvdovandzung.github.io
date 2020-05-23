*! version 1.0.0  12jul1995
program define dslabdlg
	version 5.0
	precmd dslabdlg
	global D_sm1 "Enter new dataset label"
	window control static D_sm1 5 10 160 8 left
	global D_var ""
	window control edit 5 20 160 10 D_var
	window control button "OK" 22 40 30 16 D_b1
	window control button "Cancel" 67 40 30 16 D_b2
	window control button "Help" 112 40 30 16 D_b3 help
	global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp dslabdlg"
	cap noi window dialog "Label dataset" . . 175 75  
	if _rc>3000 {
		di in wh "label data " _quote "$D_var" _quote
		window push label data "$D_var"
		label data "$D_var"
	}
end
