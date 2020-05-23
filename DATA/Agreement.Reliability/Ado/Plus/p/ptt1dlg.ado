*! version 1.0.1  31jul1995
program define ptt1dlg
	version 5.0
	
	precmd ptt1dlg
	global D_sm1 "Data variable"
	global D_sm2 "Hypoth. mean"
	global D_sm3 "Confidence level"
	global D_sm4 "%"
	
	getnv
	global D_sm5 "$S_1"
	
	
	window control static D_sm1          5 10 50 10  
	window control ssimple D_sm5 55 10 60 60 D_var1
	
	window control static D_sm2 5 70 65 10  
	window control edit 72 70 25 10 D_val1
	
	window control static D_sm3 5 85 65 10 
	window control edit 72 85 20 10 D_level

      	window control button "OK"      5 105 30 16 bok
	window control button "Cancel" 46 105 30 16 bex
	window control button "Help"   87 105 30 16 bhl help
	
	global bhl "whelp ptt1dlg"
	global bok "exit 3001"
	global bex "exit 3000"
	
	noi capture window dialog "1-sample t test" . . 125 140  
	if _rc>3000 {
		if "$D_level" == "" {
			global D_level 95
		}
		if $D_level < 10 | $D_level > 99 {
			global D_level 95
		}
		global S_level $D_level
		noi ptt1ok
	}
end

program define ptt1ok
	version 5.0
	
	noi di in white "ttest $D_var1 = $D_val1"
	window push ttest $D_var1 = $D_val1
	noi ttest $D_var1 = $D_val1
end
