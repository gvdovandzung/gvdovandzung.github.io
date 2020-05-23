*! version 1.0.1  31jul1995
program define onew1dlg
	version 5.0
	
	precmd onewdlg
	
	getnv
	global D_vlist "$S_1"
	getcv
	global D_vl "$S_1"
	
	global D_sm1 "Data variable"
	global D_sm2 "Group variable"

	window control static D_sm1 5 10 60 10 left
	window control ssimple D_vlist 5 20 60 60 D_var1

	window control static D_sm2 80 10 60 10 left 
	window control ssimple D_vl 80 20 60 60 D_var2

	window control button "OK"      10 80 30 16 D_b1
	window control button "Cancel"  60 80 30 16 D_b2
	window control button "Help"   110 80 30 16 D_b3 help
	
	global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp onewdlg"
	
	cap noi window dialog "One-way ANOVA" . . 158 115
	if _rc>3000 {
		noi di in white "oneway $D_var1 $D_var2, tabulate"
		window push oneway $D_var1 $D_var2, tabulate
		oneway $D_var1 $D_var2, tabulate
		if "$D_level"=="" {
			if "$S_level"=="" { global D_level = 95 }
			else                global D_level = $S_level
		}
		onegdlg
	}
end
