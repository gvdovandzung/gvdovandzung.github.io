*! version 1.0.1  31jul1995
program define speardlg
	version 5.0
	
	precmd speardlg
	
	
	global D_sm1 "Data variable #1"
	global D_sm2 "Data variable #2"

	getnv
	global D_sm3 "$S_1"

	window control static D_sm1  10 10 56 10 
	window control ssimple D_sm3 10 20 56 60 D_var1

	window control static D_sm2 80 10 56 10    
	window control ssimple D_sm3 80 20 56 60 D_var2
	
	window control button "OK"      8 85 30 16 D_b1
	window control button "Cancel" 58 85 30 16 D_b2
	window control button "Help"  108 85 30 16 D_b3 help
	
	global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp speardlg"
	
	cap noi window dialog "Spearman rank correlation" . . 150 120
	if _rc>3000 {
		noi di in white "spearman $D_var1 $D_var2"
		window push spearman $D_var1 $D_var2
		spearman $D_var1 $D_var2
	}
end
