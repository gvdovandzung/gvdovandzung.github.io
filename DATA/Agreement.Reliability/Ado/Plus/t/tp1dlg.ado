*! version 1.0.0  20apr1995
program define tp1dlg
	version 5.0
	
	precmd tp1dlg
	global D_run "1"
	global D_sm1 "No. of observations"
	global D_sm2 "No. of successes"
	global D_sm3 "Prob. of success or"
	global D_sm4 "exp. no. successes "
	global D_sm5 "Confidence level "
	
	* Number of observations
	window control static D_sm1 10 10 75 10
	window control edit 88 10 25 10 D_nobs
	
        * Number of successes
	window control static D_sm2 10 25 75 10
	window control edit 88 25 25 10 D_nsuc
	
        * Probability of success
	window control static D_sm3 10 37 75 8 
	window control static D_sm4 10 46 75 8
	window control edit 88 40 25 10 D_prob

	* Confidence level
	window control static D_sm5 10 60 75 10
	window control edit 88 60 20 10 D_level
	
        window control check "Normal approximation" 10 75 90 10 D_cb1
	
      	window control button "Run"    12 95 30 16 D_bok
	window control button "Cancel" 48 95 30 16 D_bex
	window control button "Help"   84 95 30 16 D_bhl help
	
	global D_bhl "whelp tp1dlg"
	global D_bok "noi tp1ok"
	global D_bex "exit 3000"
	
       	if "$D_level"=="" {
		global D_level 95
	}
	noi capture window dialog "1-sample test of proportion" . . 135 130
	if _rc>3000 {
		global S_level $D_level
		tp1ok
	}
	global D_run
end

program define tp1ok
	version 5.0
	
        if $D_cb1==1 {
		local opt ", normal"
	}
	if $D_prob >= 1 {
		global D_prob = $D_prob/$D_nobs
	}
	if "$D_run" != "" {
		noi di in white "bintesti $D_nobs $D_nsuc $D_prob `opt'"
	}
	else {
		noi di in white 
		noi di in white ". bintesti $D_nobs $D_nsuc $D_prob `opt'"
	}
	global D_run
	window push bintesti $D_nobs $D_nsuc $D_prob `opt'
	noi bintesti $D_nobs $D_nsuc $D_prob `opt'
end
