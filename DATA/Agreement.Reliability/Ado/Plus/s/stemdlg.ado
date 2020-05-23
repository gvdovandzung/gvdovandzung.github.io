*! version 1.2.0  16oct1996
program define stemdlg
	version 5.0

	precmd stemdlg
	global D_run 1
	global D_sm1 "Data variable"
	global D_sm2 "Lines"
	global D_sm3 "Digits per leaf"
	global D_sm4 "Options"
	global D_sm6 "Round"
	
	getnv
	global D_sm5 "$S_1"

	window control static D_sm1          5 9 50 10
	window control ssimple D_sm5 55 7 57 60 D_var1

	window control static D_sm6 10 68 102 66 blackframe
	window control static D_sm4 40 65  42 10 center	
	window control static D_sm2 20 76  50 10  
	window control edit 73 76 25 10 D_sd1
	window control static D_sm3 20 91  50 10  
	window control edit 73 91 25 10 D_sd2
	window control static D_sm6 20 106 50 10
	window control edit 73 106 25 10 D_var
	
	window control check "Prune empty stems" 20 120 80 10 D_cb1 right
	
       	window control button "Draw"    5 140 30 14 bdr
       	window control button "OK"     37 140 30 14 bok
	window control button "Cancel" 69 140 30 14 bex
	window control button "Help"  101 140 30 14 bhl help
	
	global bhl "whelp stemdlg"
	global bok "exit 3001"
	global bex "exit 3000"
	global bdr "stemdr"
	
	capture noi window dialog "Stem-and-leaf plot" . . 145 175  
	if _rc>3000 {
		tempvar o
		gen `o'=_n
		stemok 
		sort `o'
		drop `o'
	}
end

program define stemdr
	version 5.0

	tempvar o
	gen `o'=_n
	noi stemok 
	sort `o'
end

program define stemok
	version 5.0

        if $D_cb1 == 1 {
		local opt " prune"
	}
	if "$D_sd1" != "" {
		local opt " lines($D_sd1)`opt'"
	}
	if "$D_sd2" != "" {
		local opt " digits($D_sd2)`opt'"
	}
	if "$D_var" != "" {
		local opt " round($D_var)`opt'"
	}
	if "`opt'" != "" {
		local opt ",`opt'"
	}

	if "$D_run"!="" {
		noi di in white "stem $D_var1`opt'"
	}
	else    noi di _n in white ". stem $D_var1`opt'"
	global D_run
	window push stem $D_var1`opt'
	stem $D_var1`opt'
end
