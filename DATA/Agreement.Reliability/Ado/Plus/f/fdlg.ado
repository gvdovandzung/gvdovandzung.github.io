*!  version 1.0.0  24apr1995
program define fdlg
	version 5.0
	
       	precmd fdlg
	global D_run "1"
	global D_sm1 "F statistic"
	global D_sm2 "numerator dof"
	global D_sm3 "denominator dof"
	window control static D_sm1 5 10 56 10 left
	window control static D_sm2 5 25 56 10 left
	window control static D_sm3 5 40 56 10 left
	
	window control edit 62 10 30 10 D_val
	window control edit 62 25 30 10 D_dof1
	window control edit 62 40 30 10 D_dof2
	
	window control button "Run"     5 61 30 16 D_b1
	window control button "Cancel" 40 61 30 16 D_b2
	window control button "Help"   75 61 30 16 D_b3 help

	global D_b1 "noi fok" 
	global D_b2 "exit 3000"
	global D_b3 "whelp probdlg"
	cap noi window dialog "F probability" . . 120 101
	global D_run
end

program define fok
	if "$D_run" != "" {
		noi di in white "tablesq F $D_dof1 $D_dof2 $D_val"
	}
	else{
		noi di in white
		noi di in white ". tablesq F $D_dof1 $D_dof2 $D_val"
	}
	global D_run
	window push tablesq F $D_dof1 $D_dof2 $D_val
	tablesq F $D_dof1 $D_dof2 $D_val
end
