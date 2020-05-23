*! version 1.0.1  31jul1995
program define ptt2pdlg
	version 5.0
	
	precmd ptt2pdlg
	global D_sm1 "Data variable #1"
	global D_sm2 "Data variable #2"
	global D_sm3 "Confidence level"
	
	getnv
	global D_sm5 "$S_1"
	
	
	window control static  D_sm1        10 10 55 10 
	window control ssimple D_sm5 10 20 56 60 D_var1
	
	window control static  D_sm2        80 10 55 10 
	window control ssimple D_sm5 80 20 56 60 D_var2

	window control static  D_sm3	   10 80 65 10 
	window control edit 78 80 20 10 D_level
	
       	window control button "OK"     10 95 30 16 bok
	window control button "Cancel" 60 95 30 16 bex
	window control button "Help"  110 95 30 16 bhl help
	
	global bhl "whelp ptt2pdlg"
	global bok "exit 3001"
	global bex "exit 3000"
	
	noi capture window dialog "Paired t test" . . 155 130 
	
	if _rc>3000 {
		if "$D_level" == "" {
			global D_level 95
		}
		if $D_level < 10 | $D_level > 99 {
			global D_Level 95
		}
		global S_level $D_level
		noi ptt2pok
	}
end

program define ptt2pok
	version 5.0
	
	noi di in white "ttest $D_var1 = $D_var2"
	window push ttest $D_var1 = $D_var2
	noi ttest $D_var1 = $D_var2
end
