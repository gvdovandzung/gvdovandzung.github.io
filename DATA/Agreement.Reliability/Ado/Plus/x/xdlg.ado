*!  version 1.0.0  24apr1995
program define xdlg
	version 5.0
	
        precmd xdlg
	global D_run "1"
	global D_sm1 "Chi-squared"
	global D_sm2 "degrees of freedom"
	window control static D_sm1 5 10 65 10 left
	window control static D_sm2 5 25 65 10 left
	
	window control edit 72 10 30 10 D_val
	window control edit 72 25 30 10 D_dof
	
	window control button "Run"     5 46 30 16 D_b1 default
	window control button "Cancel" 40 46 30 16 D_b2
	window control button "Help"   75 46 30 16 D_b3 help

	global D_b1 "noi xok" 
	global D_b2 "exit 3000"
	global D_b3 "whelp probdlg"
	cap noi window dialog "Chi-squared probability" . . 115 86
	global D_run
end

program define xok
	if "$D_run" != "" {
		noi di in white "tablesq X $D_dof $D_val"
	}
		noi di in white
		noi di in white ". tablesq X $D_dof $D_val"
	else {
	}
	global D_run
	window push tablesq X $D_dof $D_val
	tablesq X $D_dof $D_val
end
