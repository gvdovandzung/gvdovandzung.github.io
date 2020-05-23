*! version 1.0.1  19jul1995
program define ccidlg
	version 5.0
	
        precmd ccidlg
	
	global D_run "1"
	global D_sm1 "No. observations"
	global D_sm2 "Sample mean"
	global D_sm3 "Sample std. dev."
	global D_sm4 "Confidence level"
	
	window control static D_sm1 10 15 60 10 left
	window control static D_sm2 10 30 60 10
	window control static D_sm3 10 45 60 10
	window control static D_sm4 10 60 60 10
	
        * Number of observations
	window control edit 75 15 25 10 D_nobs
	
        * Sample average
	window control edit 75 30 25 10 D_mean1
	
        * Sample std. dev
	window control edit 75 45 25 10 D_sd1
	
        * Significance level
	window control edit 75 60 20 10 D_level
	
        * Buttons
      	window control button "Run"     5 80 30 16 D_bok
	window control button "Cancel" 40 80 30 16 D_bex
	window control button "Help"   75 80 30 16 D_bhl help
	
	global D_bhl "whelp ccidlg"
	global D_bok "noi cciok"
	global D_bex "exit 3000"
	
	noi capture window dialog "Confidence interval for mean" . . 120 115
	if _rc>3000 {
		tt1ok
	}
	global D_run
end

program define cciok
	version 5.0
	
	if "$D_run" != "" {
		noi di in white "cii $D_nobs $D_mean1 $D_sd1, level($D_level)"
	}
	else {
		noi di in white
		noi di in white ". cii $D_nobs $D_mean1 $D_sd1, level($D_level)"
	}
	window push cii $D_nobs $D_mean1 $D_sd1, level($D_level)
	global D_run
	noi cii $D_nobs $D_mean1 $D_sd1, level($D_level)
end
