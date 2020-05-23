*!  version 1.0.0  24apr1995
program define bdlg
	version 5.0
	
        precmd bdlg
	global D_run "1"
	global D_sm1 "No. of trials"
	global D_sm2 "Prob. of success"
	global D_sm3 "No. of successes"
	window control static D_sm1 7 10 70 10 left
	window control static D_sm2 7 25 70 10 left
	window control static D_sm3 7 40 70 10 left
	
	window control edit 73 10 30 10 D_nobs
	window control edit 73 25 30 10 D_prob
	window control edit 73 40 30 10 D_nsuc
	
	window control button "Run"     5 57 30 16  D_b1
	window control button "Cancel" 45 57 30 16  D_b2
	window control button "Help"   85 57 30 16  D_b3 help

	global D_b1 "noi bok" 
	global D_b2 "exit 3000"
	global D_b3 "whelp probdlg"
	cap noi window dialog "Binomial probability" . . 125 95 
	global D_run
end

program define bok
	if "$D_run" != "" {
		noi di in white "tablesq B $D_nobs $D_nsuc $D_prob"
	}
	else {
		noi di in white
		noi di in white ". tablesq B $D_nobs $D_nsuc $D_prob"
	}
	window push tablesq B $D_nobs $D_nsuc $D_prob
	global D_run
	tablesq B $D_nobs $D_nsuc $D_prob
end
