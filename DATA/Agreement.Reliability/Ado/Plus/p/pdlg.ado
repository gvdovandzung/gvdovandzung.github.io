*!  version 1.0.1  03nov1995
program define pdlg
	version 5.0
	
        precmd pdlg
	global D_run "1"
	global D_sm1 "lambda"
	global D_sm2 "count"
	window control static D_sm1 15 10 26 10 left
	window control static D_sm2 15 25 26 10 left
	
	window control edit 43 10 30 10 D_var1
	window control edit 43 25 30 10 D_var2
	
	window control button "Run"     2 46 30 16 D_b1
	window control button "Cancel" 37 46 30 16 D_b2
	window control button "Help"   71 46 30 16 D_b3 help

	global D_b1 "noi pok" 
	global D_b2 "exit 3000"
	global D_b3 "whelp probdlg"
	cap noi window dialog "Poisson probability" . . 110 80 
	global D_run
end

program define pok
	if "$D_run" != "" {
		noi di in white "tablesq P $D_var2 $D_var1"
	}
	else {
		noi di in white 
		noi di in white ". tablesq P $D_var2 $D_var1"
	}
	global D_run
	window push tablesq P $D_var2 $D_var1
	tablesq P $D_var2 $D_var1
end
