*! version 1.0.2  10nov1995
program define sdt1dlg
	version 5.0
	
	precmd sdt1dlg
	global D_run "1"
	global D_sm1 "1-sample test of variance"
	global D_sm4 "No. of observations"
	global D_sm5 "Hypothesized std. dev."
	global D_sm6 "Sample std. dev."
	
        * Number of observations
	window control static D_sm4 10 10 79 10
	window control edit 90 10 29 10 D_nobs1

        * Standard deviations
	window control static D_sm6 10 25 79 10 
	window control edit 90 25 29 10 D_sd1

	* Theoretical value
	window control static D_sm5 10 40 79 10
	window control edit 90 40 29 10 D_sd2

       
        * Buttons
      	window control button "Run"    10 67 30 16 D_bok
	window control button "Cancel" 49 67 30 16 D_bex
	window control button "Help"   88 67 30 16 D_bhl help
	
	global D_bhl "whelp sdt1dlg"
	global D_bok "noi sdtok"
	global D_bex "exit 3000"
	
       	if "$D_level"=="" {
		global D_level 95
	}
	noi capture window dialog "$D_sm1" . . 135 110
	if _rc>3000 {
		sdtok
	}
	global D_run
end

program define sdtok
	version 5.0
	
	if "$D_run" != "" {
		noi di in white "sdtesti $D_nobs1 . $D_sd1 $D_sd2"
	}
	else {
		noi di in white
		noi di in white ". sdtesti $D_nobs1 . $D_sd1 $D_sd2"
	}
	global D_run
	window push sdtesti $D_nobs1 . $D_sd1 $D_sd2
	noi sdtesti $D_nobs1 . $D_sd1 $D_sd2
end
