*! version 1.0.1  31jul1995
program define ptt2gdlg
	version 5.0
	
	precmd ptt2gdlg
	global D_sm1 "Data variable"
	global D_sm2 "Group var. (2 groups)"
	global D_sm3 "Confidence level"
	
	getnv
	global D_sm5 "$S_1"
	getbv
	global D_sm6 "$S_1"
	
	window control static D_sm1         10 10 50 10 
	window control ssimple D_sm5 10 20 56 60 D_var1
	
	window control static D_sm2         73 10 80 10 
	window control ssimple D_sm6 85 20 56 60 D_var2
	
       	window control check "Unequal variances" 10 80 75 8 D_cb1 left

	window control static D_sm3 10 95 65 10 
	window control edit 78 95 20 10 D_level
	
      	window control button "OK"     10 115 30 16 D_bok
	window control button "Cancel" 60 115 30 16 D_bex
	window control button "Help"  110 115 30 16 D_bhl help
	
	global D_bhl "whelp ptt2dlg"
	global D_bok "exit 3001"
	global D_bex "exit 3000"
	
	noi capture window dialog "2-sample t test" . . 160 150 
	
	if _rc>3000 {
		if "$D_level"=="" {
			global D_level 95
		}
		if $D_level < 10 | $D_level > 99 {
			global D_level 95
		}
		global S_level $D_level
		noi ptt2gok
	}
end

program define ptt2gok
	version 5.0
	
       	if $D_cb1 == 1 {
		local opt "unequal"
	}
	noi di in white "ttest $D_var1, by($D_var2) `opt'"
	window push ttest $D_var1, by($D_var2) `opt'
	noi ttest $D_var1, by($D_var2) `opt'
end
