*! version 1.0.1  31jul1995
program define srandlg
	version 5.0
	
	precmd srandlg
	global D_sm1 "Data variable #1"
	global D_sm2 "Data variable #2"
	
	getnv
	global D_sm5 "$S_1"
	
	
	window control static  D_sm1        10 10 65 10
	window control ssimple D_sm5 10 20 56 60 D_var1
	
	window control static  D_sm2        80 10 65 10
	window control ssimple D_sm5 80 20 56 60 D_var2
	
      	window control button "OK"      10 85 30 16 D_bok
	window control button "Cancel"  60 85 30 16 D_bex
	window control button "Help"   110 85 30 16 D_bhl help
	
	global D_bhl "whelp srandlg"
	global D_bok "exit 3001"
	global D_bex "exit 3000"
	
	noi capture window dialog "Wilcoxon signed-rank test" . . 155 120
	
	if _rc>3000 {
		noi sranok
	}
end

program define sranok
	version 5.0
	
	noi di in white "signrank $D_var1 = $D_var2"
	window push signrank $D_var1 = $D_var2
	noi signrank $D_var1 = $D_var2
end
