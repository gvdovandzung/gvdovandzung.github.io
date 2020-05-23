*! version 1.0.0  20apr1995
program define zt2dlg
	version 5.0
	
	precmd zt2dlg
	
	global D_run "1"

	global D_sm1 "2-sample normal test of means"
	global D_sm2 "Sample 1"
	global D_sm3 "Sample 2"
	global D_sm4 "No. of observations"
	global D_sm5 "Sample mean"
	global D_sm6 "Population std. dev."
	global D_sm7 "Confidence level"
	global D_sm9 "Sample 1"
	global D_sm10 "Sample 2"
	global D_sm11 "Confidence level"
	
	window control static D_sm4 10 30 70 10
	window control static D_sm5 10 45 70 10
	window control static D_sm6 10 60 70 10 
	window control static D_sm9 80 15 35 10
	window control static D_sm10 120 15 35 10

	window control static D_sm11 10 75 70 10

        * Number of observations
	window control edit 82 30 29 10 D_nobs1
	window control edit 120 30 29 10 D_nobs2
       
        * Sample mean
	window control edit 82 45 29 10 D_mean1
	window control edit 120 45 29 10 D_mean2
	
        * Sample std
	window control edit 82 60 29 10 D_sd1
	window control edit 120 60 29 10 D_sd2

	window control edit 82 75 20 10 D_level
	
	
        * Buttons
      	window control button "Run"    16 95 30 16 D_bok
	window control button "Cancel" 63 95 30 16 D_bex
	window control button "Help"  110 95 30 16 D_bhl help
	
	global D_bhl "whelp zt2dlg"
	global D_bok "noi zt2ok"
	global D_bex "exit 3000"
	
       	if "$D_level"=="" {
		global D_level 95
	}
	noi capture window dialog "2-sample normal test of means" . . 165 135
	if _rc>3000 {
		zt2ok
	}
	global D_run
end

program define zt2ok
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
	if $D_nobs1 <= 0 | $D_nobs2 <= 0 {
		window stopbox stop "Number of observations must be positive."
		exit
	}
	if $D_sd1 <= 0 | $D_sd2 <= 0 {
		window stopbox stop "Standard deviation must be positive."
		exit
	}
	if "$D_level"=="" {
		global D_level 95
	}
	if $D_level < 10 | $D_level > 99 {
		global D_level 95
	}
	global S_level $D_level
	if "$D_run" != "" {
		noi di in white /*
*/ "ztest2i $D_nobs1 $D_mean1 $D_sd1 $D_nobs2 $D_mean2 $D_sd2,level($D_level)"
	}
	else {
		noi di in white
		noi di in white /*
*/ ". ztest2i $D_nobs1 $D_mean1 $D_sd1 $D_nobs2 $D_mean2 $D_sd2,level($D_level)"
	}
	global D_run
	window push ztest2i $D_nobs1 $D_mean1 $D_sd1 $D_nobs2 $D_mean2 $D_sd2,/*
		*/  level($D_level)
	ztest2i $D_nobs1 $D_mean1 $D_sd1 $D_nobs2 $D_mean2 $D_sd2,/*
		*/  level($D_level)
end
