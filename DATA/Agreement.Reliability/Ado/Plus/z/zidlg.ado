*!  version 1.0.0  24apr1995
program define zidlg
	version 5.0
	
        precmd zidlg
	global D_run "1"
	global D_sm1 "Pr(Z<=z) = "
	window control static D_sm1 5 10 55 10 left
	
	window control edit 62 10 25 10 D_val
	
	window control button "Run"     5 31 30 16 D_b1 default
	window control button "Cancel" 38 31 30 16 D_b2
	window control button "Help"   71 31 30 16 D_b3 help
	
	global D_b1 "noi noriok" 
	global D_b2 "exit 3000"
	global D_b3 "whelp probdlg"
	cap noi window dialog "Normal percentile" . . 110 66
	if _rc>3000 {
		noi noriok
	}
	global D_run
end

program define noriok
	if "$D_val"=="" {
		window stopbox stop "You must provide a probability"
		exit
	}
	if $D_val<=0 | $D_val>=1 {
		window stopbox stop "Probability must be in (0,1)"
		exit
	}
	if "$D_run" != "" {
		noi di in white "tablesqi Z $D_val"
	}
	else {
		noi di in white
		noi di in white ". tablesqi Z $D_val"
	}
	global D_run
	window push tablesqi Z $D_val
	tablesqi Z $D_val
end 
