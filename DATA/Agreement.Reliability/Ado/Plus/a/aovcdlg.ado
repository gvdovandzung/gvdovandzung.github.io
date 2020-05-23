*! version 1.0.0  12jul1995
program define aovcdlg
	version 5.0
	
	precmd aovcdlg
	getnv
	global D_vl "$S_1"
	getcv
	global D_vlist "$S_1"
	
	global D_sm5 "Dependent variable"
	window control static D_sm5 5 5 75 10 left
	window control scombo D_vl 82 5 65 45 D_depv
	
	global D_sm1 "Categorical variables"
	window control static D_sm1 5 25 80 8    left
	window control msimple D_vlist 5 35 80 60 D_var
	
	global D_sm2 "Continuous variables"
	window control static D_sm2 90 25 80 8    left
	window control msimple D_vl 90 35 80 55 D_var1
	
	global D_sm6 "Build interaction terms"
	window control static D_sm6 5 97 84 8     left
	window control msimple D_vlist 90 96 80 55 D_tmpv
	
	window control button "Add term"  45 105 37 12 D_b4
	
	global D_sm4 "Interactions"
	window control static D_sm4 5 150 50 9    left

	window control edit 58 150 115 9 D_var2

	window control button "OK"     27 166 30 16 D_b1
	window control button "Cancel" 77 166 30 16 D_b2
	window control button "Help"  127 166 30 16 D_b3 help
	
	global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp aovcdlg"
	global D_b4 "aovup"
	
	cap noi window dialog "N-factor ANOVA & ANOCOVA" . . 195 203
	if _rc>3000 {
		aovcok
	}
end

program define aovup
	version 5.0
	
	parse "$D_tmpv", parse(" ")
	if "`1'"=="" {
		exit
	}
	global D_var2 "$D_var2 `1'"
	mac shift
	while "`1'" != "" {
		global D_var2 "$D_var2*`1'"
		mac shift
	}
	global D_tmpv
end


program define aovcok
	version 5.0
	
       	noi di in white "anova $D_depv $D_var $D_var1 $D_var2, cat($D_var)"
	window push anova $D_depv $D_var $D_var1 $D_var2, cat($D_var)
	anova $D_depv $D_var $D_var1 $D_var2, cat($D_var)
end
