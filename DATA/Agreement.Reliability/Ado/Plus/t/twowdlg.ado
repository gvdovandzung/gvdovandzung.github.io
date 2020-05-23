*! version 1.0.0  12jul1995
program define twowdlg
	version 5.0
	
	precmd twowdlg 
	
	getnv
	global D_vlist "$S_1"
	getcv
	global D_vl "$S_1"
	
	global D_sm1 "Dependent var."
	global D_sm2 "Cat. var. #1"
	global D_sm3 "Cat. var. #2"

	window control static  D_sm1          5 10 80 8 left
	window control ssimple D_vlist 5 20 56 60 D_depv

	window control static  D_sm2       75 10 80 8 left
	window control ssimple D_vl 75 20 56 60 D_var1

	window control static  D_sm3 145 10 80 8 left
	window control ssimple D_vl 145 20 56 60 D_var2
	
        window control check "Include interaction" 70 80 90 8 D_cb1 right
	if "`*'"=="1" {
		global D_cb1 = 1
	}
	else {
		global D_cb1 = 0
	}
	
	window control button "OK"     50 100 30 16 D_b1
	window control button "Cancel" 90 100 30 16 D_b2
	window control button "Help"  130 100 30 16 D_b3 help
	
	global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp twowdlg"
	
	cap noi window dialog "Two-way ANOVA" . . 215 140
	if _rc>3000 {
		if $D_cb1 == 1 {
			local fact "$D_var1*$D_var2"
		}
		noi di in white "anova $D_depv $D_var1 $D_var2 `fact'" 
		window push anova $D_depv $D_var1 $D_var2 `fact'
		anova $D_depv $D_var1 $D_var2 `fact'
		aovmdlg
	}
end
