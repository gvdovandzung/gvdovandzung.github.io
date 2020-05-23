*!  version 1.0.0  24apr1995
program define tdlg
	version 5.0
	
       	precmd tdlg
	global D_run "1"
	global D_sm1 "t statistic"
	global D_sm2 "deg. freedom"
	window control static D_sm1 5 10 50 10 left
	window control static D_sm2 5 25 50 10 left
	
	window control edit 62 10 30 10 D_val
	window control edit 62 25 30 10 D_dof
	
	window control button "Run"     5 46 30 16 D_b1 default
	window control button "Cancel" 38 46 30 16 D_b2
	window control button "Help"   71 46 30 16 D_b3 help
	
	global D_b1 "noi tok" 
	global D_b2 "exit 3000"
	global D_b3 "whelp probdlg"
	cap noi window dialog "Student's t probability" . . 115 81
	global D_run
end

program define tok
	if "$D_run" != "" {
		noi di in white "tablesq T $D_dof $D_val"
	}
	else {
		noi di in white
		noi di in white ". tablesq T $D_dof $D_val"
	}
	global D_run
	window push tablesq T $D_dof $D_val
	tablesq T $D_dof $D_val
end
