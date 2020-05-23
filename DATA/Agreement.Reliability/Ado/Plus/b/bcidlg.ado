*! version 1.0.1  19jul1995
program define bcidlg
	version 5.0
	
        precmd bcidlg
	global D_run "1"
	global D_sm1 "No. observations"
	global D_sm2 "No. of successes"
	global D_sm3 "Confidence level"
	
        * Number of observations
	window control static D_sm1 10 15 60 10
	window control edit 75 15 25 10 D_nobs
	
        * Number of successes
	window control static D_sm2 10 30 60 10 
	window control edit 75 30 25 10 D_nsuc
	
        * Confidence Level
	window control static D_sm3 10 45 60 10 
	window control edit 75 45 20 10 D_level
	
      	window control button "Run"     5 65 30 16  D_bok
	window control button "Cancel" 40 65 30 16  D_bex
	window control button "Help"   75 65 30 16  D_bhl help
	
	global D_bhl "whelp bcidlg"
	global D_bok "noi bciok"
	global D_bex "exit 3000"
	
       	if "$D_level"=="" {
		global D_level 95
	}
	noi capture window dialog "Binomial confidence interval" . . 120 100
	if _rc>3000 {
		bciok
	}
	global D_run
end

program define bciok
	version 5.0
	
	if "$D_run" != "" {
		noi di in white "cii $D_nobs $D_nsuc, level($D_level)"
	}
	else {
		noi di in white
		noi di in white ". cii $D_nobs $D_nsuc, level($D_level)"
	}
	window push cii $D_nobs $D_nsuc, level($D_level)
	global D_run
	noi cii $D_nobs $D_nsuc, level($D_level)
end
