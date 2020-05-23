*! version 1.0.1  31jul1995
program define ptntdlg
	version 5.0
	
	precmd ptntdlg
	global D_sm1 "Data variables"
	
	getnv
	global D_sm5 "$S_1"
	
	window control static D_sm1 10 5 65 10  
	window control msimple D_sm5 10 19 137 50 D_vlist
	
      	window control button "OK"     10 75 30 16 D_bok
	window control button "Cancel" 63 75 30 16 D_bex
	window control button "Help"  116 75 30 16 D_bhl help
	
	global D_bhl "whelp ptntdlg"
	global D_bok "exit 3001"
	global D_bex "exit 3000"
	
	noi capture window dialog "Normality test" . . 160 110 
	
	if _rc>3000 {
		noi ptntok
	}
end

program define ptntok
	version 5.0
	
	noi di in white "swilk $D_vlist"
	window push swilk $D_vlist
	noi swilk $D_vlist

	noi di in white _n ". sfrancia $D_vlist"
	window push sfrancia $D_vlist
	noi sfrancia $D_vlist
end
