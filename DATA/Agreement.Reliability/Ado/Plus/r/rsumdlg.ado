*! version 1.0.1  31jul1995
program define rsumdlg
	version 5.0
	
	precmd rsumdlg
	global D_sm1 "Data variable"
	global D_sm2 "Group var. (2 groups)"
	
	getnv
	global D_sm5 "$S_1"
	getbv
	global D_sm6 "$S_1"
	
	window control static  D_sm1        10 10 56 10
	window control ssimple D_sm5 10 20 56 60 D_var1
	
	window control static  D_sm2        74 10 75 10
	window control ssimple D_sm6 80 20 56 60 D_var2
	
      	window control button "OK"      10 85 30 16 D_bok
	window control button "Cancel"  60 85 30 16 D_bex
	window control button "Help"   110 85 30 16 D_bhl help
	
	global D_bhl "whelp rsumdlg"
	global D_bok "exit 3001"
	global D_bex "exit 3000"
	
	noi capture window dialog "Mann-Whitney (Wilcoxon rank-sum) test" . . 158 120
	
	if _rc>3000 {
		noi rsumok
	}
end

program define rsumok
	version 5.0
	
	noi di in white "ranksum $D_var1, by($D_var2)"
	window push ranksum $D_var1, by($D_var2) 
	noi ranksum $D_var1, by($D_var2) 
end
