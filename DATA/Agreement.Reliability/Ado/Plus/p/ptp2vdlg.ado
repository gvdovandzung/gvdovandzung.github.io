*! version 1.0.1  31jul1995
program define ptp2vdlg
	version 5.0
	
	precmd ptp2vdlg
	global D_sm1 "Data var. #1 (0/1)"
	global D_sm2 "Data var. #2 (0/1)"
	
	getbv , zero
	global D_sm5 "$S_1"
	
	
	window control static  D_sm1        10 10 65 10 
	window control ssimple D_sm5 10 20 56 60 D_var1
	
	window control static  D_sm2        80 10 65 10 
	window control ssimple D_sm5 80 20 56 60 D_var2
	
	global D_sm3 "Confidence level"
	window control static D_sm3 10 82 62 9 left
	window control edit 75 82 15 9 D_level
	
      	window control button "OK"      10 95 30 16 D_bok
	window control button "Cancel"  60 95 30 16 D_bex
	window control button "Help"   110 95 30 16 D_bhl help
	
	global D_bhl "whelp ptp2dlg"
	global D_bok "exit 3001"
	global D_bex "exit 3000"
	
	noi capture window dialog "2-sample test of proportions" . . 155 130 
	
	if _rc>3000 {
		if "$D_level" == "" {
			global D_level 95
		}
		if $D_level < 10 | $D_level > 99 {
			global D_level 95
		}
		global S_level $D_level
		noi ptp2vok
	}
end

program define ptp2vok
	version 5.0
	
	noi di in white "prtest $D_var1 = $D_var2, level($D_level)"
	window push prtest $D_var1 = $D_var2, level($D_level)
	noi prtest $D_var1 = $D_var2, level($D_level)
end
