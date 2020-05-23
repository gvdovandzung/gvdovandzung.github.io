*! version 1.0.1  18jul1995
program define tp2dlg
	version 5.0
	
	precmd tp2dlg
	
	global D_run "1"
	global D_sm1 "2-sample test of proportions"
	global D_sm4 "No. of observations"
	global D_sm5 "No. of successes or"
	global D_sm6 "observed proportion"
	global D_sm7 "Confidence level"
	global D_sm9 "Sample 1"
	global D_sm10 "Sample 2"
	
	window control static D_sm4 8 25 68 10
	window control static D_sm5 8 38 68 8
	window control static D_sm6 8 46 68 8
	window control static D_sm9 80 14 35 10
	window control static D_sm10 120 14 35 10
	window control static D_sm7 8 61 68 10

        * Number of observations
	window control edit 80 25 29 10 D_nobs1
	window control edit 120 25 29 10 D_nobs2
       
        * Number of successes
	window control edit 80 40 29 10 D_prob1
	window control edit 120 40 29 10 D_prob2
	
	window control edit 80 61 20 10 D_level
	
        * Buttons
      	window control button "Run"    20 82 30 16 D_bok
	window control button "Cancel" 65 82 30 16 D_bex
	window control button "Help"  110 82 30 16 D_bhl help
	
	global D_bhl "whelp tp2dlg"
	global D_bok "noi tp2ok"
	global D_bex "exit 3000"
	
       	if "$D_level"=="" {
		global D_level 95
	}
	noi capture window dialog "2-sample test of proportions" . . 165 120
	if _rc>3000 {
		tp2ok
	}
	global D_run
end

program define tp2ok
	version 5.0
	
        if $D_prob1 >= 1 {
		global D_prob1 = $D_prob1/$D_nobs1
	}
        if $D_prob2 >= 1 {
		global D_prob2 = $D_prob2/$D_nobs2
	}
	if "$D_run" != "" {
		noi di in white "prtesti $D_nobs1 $D_prob1 $D_nobs2 $D_prob2, level($D_level) `opt'"
	}
	else {
		noi di in white
		noi di in white ". prtesti $D_nobs1 $D_prob1 $D_nobs2 $D_prob2, level($D_level) `opt'"
	}
	global D_run
	window push prtesti $D_nobs1 $D_prob1 $D_nobs2 $D_prob2, level($D_level) `opt'
	noi prtesti $D_nobs1 $D_prob1 $D_nobs2 $D_prob2, level($D_level) `opt'
end
