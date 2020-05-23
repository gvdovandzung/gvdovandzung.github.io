*! version 1.0.0  20apr1995
program define tt2dlg
	version 5.0
	
	precmd tt2dlg
	
	global D_run "1"

        global D_cmd "tt2dlg"
	global D_sm1 "2-sample t test"
	global D_sm2 "Sample 1"
	global D_sm3 "Sample 2"
	global D_sm4 "No. of observations"
	global D_sm5 "Sample mean"
	global D_sm6 "Sample std. dev."
	global D_sm7 "Confidence level"
	global D_sm9 "Sample 1"
	global D_sm10 "Sample 2"
	global D_sm11 "Confidence level"
	
	window control static D_sm4 10 30 65 10
	window control static D_sm5 10 45 65 10
	window control static D_sm6 10 60 65 10 
	window control static D_sm9 80 15 35 10
	window control static D_sm10 120 15 35 10
	window control static D_sm11 10 75 68 10
	
        * Number of observations
	window control edit 80 30 29 10 D_nobs1
	window control edit 120 30 29 10 D_nobs2
       
        * Sample mean
	window control edit 80 45 29 10 D_mean1
	window control edit 120 45 29 10 D_mean2
	
        * Sample std
	window control edit 80 60 29 10 D_sd1
	window control edit 120 60 29 10 D_sd2
	
	* Options
	window control check "Unequal variances" 10 90 72 10 D_cb1 left
	
	* Confidence level
	window control edit 80 75 20 10 D_level

        * Buttons
      	window control button "Run"    20 110 30 16 D_bok
	window control button "Cancel" 65 110 30 16 D_bex
	window control button "Help"  110 110 30 16 D_bhl help
	
	global D_bhl "whelp tt2dlg"
	global D_bok "noi tt2ok"
	global D_bex "exit 3000"
	
       	if "$D_level"=="" {
		global D_level 95
	}
	noi capture window dialog "2-sample t test" . . 165 155
	if _rc>3000 {
		tt2ok
	}
	global D_run
end

program define tt2ok
	version 5.0
	
	if trim("$D_mean1") == "" | trim("$D_mean2") == "" | /*
	*/ trim("$D_nobs1") == "" | trim("$D_nobs2") == "" | /*
	*/ trim("$D_sd1") == "" | trim("$D_sd2") == "" {
		window stopbox stop "Missing values not allowed."
		exit
	}
	if $D_mean1 == . | $D_mean2 == . | /*
	*/ $D_nobs1 == . | $D_nobs2 == . | /*
	*/ $D_sd1 == . | $D_sd2 == . {
		window stopbox stop "Missing values not allowed."
		exit
	}
	if $D_nobs1 <= 1 | $D_nobs2 <= 1 {
		window stopbox stop "Number of observations must be > 1."
		exit
	}
	if $D_sd1 <= 0 | $D_sd2 <= 0 {
		window stopbox stop "Standard deviation must be positive."
		exit
	}
	global S_level $D_level
        if $D_cb1 == 1 { local opt "unequal" }
	if "`opt'"!="" { local opt = ", `opt'" }
	
	if "$D_run" != "" {
		noi di in white "ttesti $D_nobs1 $D_mean1 $D_sd1 $D_nobs2 $D_mean2 $D_sd2 `opt'"
	}
	else {
		noi di in white
		noi di in white ". ttesti $D_nobs1 $D_mean1 $D_sd1 $D_nobs2 $D_mean2 $D_sd2 `opt'"
	}
	global D_run
	window push ttesti $D_nobs1 $D_mean1 $D_sd1 $D_nobs2 $D_mean2 $D_sd2 `opt'
	noi ttesti $D_nobs1 $D_mean1 $D_sd1 $D_nobs2 $D_mean2 $D_sd2 `opt'
end
	
