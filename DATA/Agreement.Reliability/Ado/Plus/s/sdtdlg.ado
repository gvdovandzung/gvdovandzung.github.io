*! version 1.0.0  20apr1995
program define sdtdlg
	version 5.0
	
	precmd sdtdlg
	global D_run "1"
	global D_sm1 "2-sample test of variance"
	global D_sm2 "Sample 1"
	global D_sm3 "Sample 2"
	global D_sm4 "No. of observations"
	global D_sm6 "Sample std. dev."
	global D_sm7 "Confidence level"
	global D_sm9 "Sample 1"
	global D_sm10 "Sample 2"
	
	window control static D_sm4 10 30 65 10
	window control static D_sm6 10 45 60 10 
	window control static D_sm9 80 15 35 10
	window control static D_sm10 120 15 35 10

        * Number of observations
	window control edit 80 30 29 10 D_nobs1
	window control edit 120 30 29 10 D_nobs2
       
        * Standard deviations
	window control edit 80 45 29 10 D_sd1
	window control edit 120 45 29 10 D_sd2

	*window control static D_sm7 10 60 65 10
	*window control edit D_level 80 60 20 10 maxlen 2
	
	
        * Buttons
      	window control button "Run"    20 67 30 16 D_bok
	window control button "Cancel" 65 67 30 16 D_bex
	window control button "Help"  110 67 30 16 D_bhl help
	
	global D_bhl "whelp sdtdlg"
	global D_bok "noi sdtok"
	global D_bex "exit 3000"
	
       	if "$D_level"=="" {
		global D_level 95
	}
	noi capture window dialog "$D_sm1" . . 165 110
	if _rc>3000 {
		sdtok
	}
	global D_run
end

program define sdtok
	version 5.0
	
	if "$D_run" != "" {
		noi di in white "sdtesti $D_nobs1 . $D_sd1 $D_nobs2 . $D_sd2"
	}
	else {
		noi di in white
		noi di in white ". sdtesti $D_nobs1 . $D_sd1 $D_nobs2 . $D_sd2"
	}
	global D_run
	window push sdtesti $D_nobs1 . $D_sd1 $D_nobs2 . $D_sd2
	noi sdtesti $D_nobs1 . $D_sd1 $D_nobs2 . $D_sd2
end
