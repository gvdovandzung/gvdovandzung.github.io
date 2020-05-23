*! version 1.0.1  31jul1995
program define ptt2vdlg
	version 5.0
	
	precmd ptt2vdlg
	global D_sm1 "Data variable #1"
	global D_sm2 "Data variable #2"
	global D_sm3 "Confidence level"
	
	getnv
	global D_sm5 "$S_1"
	
	
	window control static  D_sm1        10 10 55 10 
	window control ssimple D_sm5 10 20 56 60 D_var1
	
	window control static  D_sm2        80 10 55 10 
	window control ssimple D_sm5 80 20 56 60 D_var2
	
       	window control check "Unequal variances" 10 80 75 8 D_cb1 left
	
	window control static D_sm3 10 95 65 10 
	window control edit 78 95 20 10 D_level

      	window control button "OK"     10 115 30 16 D_bok
	window control button "Cancel" 60 115 30 16 D_bex
	window control button "Help"  110 115 30 16 D_bhl help
	
	global D_bhl "whelp ptt2dlg"
	global D_bok "exit 3001"
	global D_bex "exit 3000"
	
	noi capture window dialog "2-sample t test" . . 155 150 
	
	if _rc>3000 {
		if "$D_level" == "" {
			global D_level 95
		}
		if $D_level < 10 | $D_level > 99 {
			global D_level 95
		}
		global S_level $D_level
		noi ptt2vok
	}
end

program define ptt2vok
	version 5.0
	
       	if $D_cb1 == 1 {
		local opt "unequal"
	}
	noi di in white "ttest $D_var1 = $D_var2, unpaired `opt'"
	window push ttest $D_var1 = $D_var2, unpaired `opt'
	noi ttest $D_var1 = $D_var2, unpaired `opt'
end
