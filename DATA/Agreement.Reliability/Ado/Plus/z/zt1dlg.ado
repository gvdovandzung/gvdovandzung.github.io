*! version 1.0.0  21apr1995
program define zt1dlg
	version 5.0
	
        precmd zt1dlg
	
	global D_run  "1"

	global D_sm1 "No. of observations"
	global D_sm2 "Sample mean"
	global D_sm3 "Population std. dev."
	global D_sm4 "Hypothesized mean"
	global D_sm5 "Confidence level"
	
	window control static D_sm1 10 15 70 10 left
	window control static D_sm2 10 30 70 10
	window control static D_sm3 10 45 70 10
	window control static D_sm4 10 60 70 10
	window control static D_sm5 10 75 70 10
	
        * Number of observations
	window control edit 85 15 25 10 D_nobs
	
        * Sample average
	window control edit 85 30 25 10 D_mean1
	
        * Sample std. dev
	window control edit 85 45 25 10 D_sd1
	
        * Hypothesized mean
	window control edit 85 60 25 10 D_hyp
	
	* Confidence level
	window control edit 85 75 25 10 D_level

        * Buttons
      	window control button "Run"     7 95 30 16 D_bok
	window control button "Cancel" 47 95 30 16 D_bex
	window control button "Help"   87 95 30 16 D_bhl help
	
	global D_bhl "whelp zt1dlg"
	global D_bok "noi zt1ok"
	global D_bex "exit 3000"
	
	noi capture window dialog "1-sample normal test of mean" . . 132 130
	if _rc>3000 {
		zt1ok
	}
	global D_run
end

program define zt1ok
	version 5.0
	
	if trim("$D_mean1") == "" | trim("$D_nobs") == "" | /*
	*/ trim("$D_sd1") == "" | trim("$D_hyp") == "" {
		window stopbox stop "Missing values not allowed."
		exit
	}
	if $D_mean1 == . | $D_nobs == . | /*
	*/ $D_sd1 == . | $D_hyp == . {
		window stopbox stop "Missing values not allowed."
		exit
	}
	if $D_nobs <= 0 {
		window stopbox stop "Number of observations must be positive."
		exit
	}
	if $D_sd1 <= 0 {
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
		*/ "ztesti $D_mean1 $D_sd1 $D_hyp $D_nobs, level($D_level)"
	}
	else {
		noi di in white
		noi di in white /*
		*/ ". ztesti $D_mean1 $D_sd1 $D_hyp $D_nobs, level($D_level)"
	}
	global D_run
	window push ztesti $D_nobs $D_mean1 $D_sd1 $D_hyp, level($D_level)
	ztesti $D_nobs $D_mean1 $D_sd1 $D_hyp, level($D_level)
end
