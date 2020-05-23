*! version 1.0.0  12jul1995
program define rpmdlg
	version 5.0
	
	precmd rpmdlg 
	
	getnv
	global D_vlist "$S_1"
	getcv
	global D_vl "$S_1"
	
	global D_sm1 "Dependent var."
	global D_sm2 "Subject ID"
	global D_sm3 "Categorical var."

	window control static D_sm1 5 10 80 8 left
	window control ssimple D_vlist 5 20 56 60 D_depv

	window control static D_sm2 75 10 80 8 left
	window control ssimple D_vl 75 20 56 60 D_var1

	window control static D_sm3 145 10 80 8 left
	window control ssimple D_vl 145 20 56 60 D_var2
	
	window control button "OK"     50 90 30 16 D_b1
	window control button "Cancel" 90 90 30 16 D_b2
	window control button "Help"  130 90 30 16 D_b3 help
	
	global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp rpmdlg"
	
	cap noi window dialog "Repeated-measures ANOVA" . . 215 130
	if _rc>3000 {
		noi di in white "anova $D_depv $D_var1 $D_var2"
		window push anova $D_depv $D_var1 $D_var2
		anova $D_depv $D_var1 $D_var2
	}
end
