*! version 1.0.0  20apr1995
program define pttpdlg
	version 5.0
	
	precmd pttpdlg
	global D_sm1 "Data variable (0/1)"
	global D_sm2 "Probability of"
	global D_sm3 "success or"
	global D_sm5 "exp. no. successes"
	global D_sm6 "Conf. level"
	
       	getbv, zero
	global D_sm4 = "$S_1"
	
	* Variable
	window control static D_sm1 10 10 60 10 
	window control ssimple D_sm4 10 20 50 50 D_var
	
        * Probability of success
	window control static D_sm2 80  7 70 8 
	window control static D_sm3 80 15 70 8 
	window control static D_sm5 80 23 70 8 
	window control edit 80 33 30 10 D_prob
	
        * Significance level
	window control static D_sm6  80 53 35 10 
	window control edit 117 53 15 10 D_level
	
        window control check "Normal approximation" 25 70 85 10 D_cb1 left

      	window control button "OK"     10 90 30 16 D_bok
	window control button "Cancel" 63 90 30 16 D_bex
	window control button "Help"  116 90 30 16 D_bhl help
	
	global D_bhl "whelp pttpdlg"
	global D_bok "exit 3001"
	global D_bex "exit 3000"
	
	noi capture window dialog "1-sample test of proportion" . . 160 125

	if _rc>3000 {
		if "$D_level"=="" {
			global D_level 95
		}
		if $D_level < 10 | $D_level > 99 {
			global D_level 95
		}
		global S_level $D_level
		pttpok
	}
end

program define pttpok
	version 5.0
	
        if $D_prob>=1 {
		qui summ $D_var
		global D_prob = $D_prob/_result(1)
	}
        if $D_cb1 != 1 {
		noi di in white "bintest $D_var=$D_prob, level($D_level)"
		window push bintest $D_var=$D_prob, level($D_level)
		noi bintest $D_var=$D_prob, level($D_level)
	}
	else {
		noi di in white "normp1 $D_var $D_prob"
		window push normp1 $D_var $D_prob
		normp1 $D_var $D_prob
	}
end
