*! version 1.0.0  21apr1995
program define onewdlg
	version 5.0
	
	window control static D_sm3 5 8 135 44 blackframe
	window control static D_sm4 50 6 46 10 center
	global D_sm4 "Options"
       	window control radbegin "1 data variable, 1 group variable" 10 18 125 10 D_rb1 right
	window control radend "k data variables (one per treatment)" 10 32 125 10 D_rb1 right
	global D_rb1 1
	
	window control button "OK"     18 60 30 16 D_bok
	window control button "Cancel" 56 60 30 16 D_bex
	window control button "Help"   93 60 30 16 D_bhl help
	
	global D_bhl "whelp onewdlg"
	global D_bok "exit 3001"
	global D_bex "exit 3000"
	
	noi capture window dialog "One-way analysis of variance" . . 155 95 
	if _rc>3000 {
		noi ttok
	}
end

program define ttok
	version 5.0
	
	if $D_rb1 == 1 {
		onew1dlg
	}
	else {
		onew2dlg
	}
end
