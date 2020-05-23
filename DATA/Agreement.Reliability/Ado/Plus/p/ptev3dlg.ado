*! version 1.0.1  31jul1995
program define ptev3dlg
	version 5.0
	
	precmd ptev3dlg
	global D_sm1 "Data variable #1"
	global D_sm2 "Data variable #2"
	
	getnv
	global D_sm5 "$S_1"
	global D_sm6 "$S_1"
	
	window control static  D_sm1        5 10 65 10 
	window control ssimple D_sm5 5 20 56 60 D_var1
	
	window control static  D_sm2        80 10 75 10 
	window control ssimple D_sm6 80 20 56 60 D_var2
	
      	window control button "OK"     10 90 30 16 D_bok
	window control button "Cancel" 60 90 30 16 D_bex
	window control button "Help"  110 90 30 16 D_bhl help
	
	global D_bhl "whelp ptevdlg"
	global D_bok "exit 3001"
	global D_bex "exit 3000"
	
	noi capture window dialog "2-sample test of variance" . . 155 130 
	
	if _rc>3000 {
		noi ptevok
	}
end

program define ptevok
	version 5.0
	
	noi di in white "sdtest $D_var1=$D_var2"
	window push sdtest $D_var1=$D_var2
	noi sdtest $D_var1=$D_var2
end
