*! version 1.0.0  21apr1995
program define kwaldlg
	version 5.0
	
	precmd kwaldlg
	global D_sm1 "Data variable"
	global D_sm2 "Group variable"
	
	getnv
	global D_sm5 "$S_1"
	getcv
	global D_sm6 "$S_1"
	
	window control static D_sm1 10 10 66 10
	window control ssimple D_sm5 10 20 56 60 D_var1
	
	window control static D_sm2 80 10 56 10 
	window control ssimple D_sm6 80 20 56 60 D_var2
	
      	window control button "OK"      10 85 30 16 D_bok
	window control button "Cancel"  58 85 30 16 D_bex
	window control button "Help"   106 85 30 16 D_bhl help
	
	global D_bhl "whelp kwaldlg"
	global D_bok "exit 3001"
	global D_bex "exit 3000"
	
	noi capture window dialog "One-way nonparametric ANOVA" . . 150 120
	
	if _rc>3000 {
		noi kwalok
	}
end

program define kwalok
	version 5.0
	
	noi di in white "kwallis $D_var1, by($D_var2)"
	window push kwallis $D_var1, by($D_var2) 
	noi kwallis $D_var1, by($D_var2) 
end
