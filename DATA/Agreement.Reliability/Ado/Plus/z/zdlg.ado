*!  version 1.0.0  24apr1995
program define zdlg
	version 5.0
	
        precmd zdlg
	global D_run "1"
	global D_sm1 "Normal statistic"
	window control static D_sm1 5 10 55 10 left
	
	window control edit 62 10 25 10 D_val
	
	window control button "Run"     5 31 30 16 D_b1 default
	window control button "Cancel" 38 31 30 16 D_b2
	window control button "Help"   71 31 30 16 D_b3 help
	
	global D_b1 "noi norok" 
	global D_b2 "exit 3000"
	global D_b3 "whelp probdlg"
	cap noi window dialog "Normal probability" . . 110 66
	if _rc>3000 {
		noi norok
	}
	global D_run
end

program define norok
	if "$D_run" != "" {
		noi di in white "tablesq Z $D_val"
	}
	else {
		noi di in white
		noi di in white ". tablesq Z $D_val"
	}
	global D_run
	window push tablesq Z $D_val
	tablesq Z $D_val
end 
