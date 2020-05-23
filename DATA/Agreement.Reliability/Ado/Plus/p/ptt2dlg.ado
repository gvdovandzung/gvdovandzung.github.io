*! version 1.0.0  21apr1995
program define ptt2dlg
	version 5.0
	
	window control static D_sm3 5 8 125 44 blackframe
	window control static D_sm4 50 6 42 10 center
	global D_sm4 "Options"
       	window control radbegin "1 data variable, 1 group variable" 10 18 115 8 D_rb1 right
	window control radend "2 independent data variables" 10 32 115 8 D_rb1 right
	global D_rb1 1
	
	window control button "OK"     12 60 30 16 D_bok
	window control button "Cancel" 50 60 30 16 D_bex
	window control button "Help"   87 60 30 16 D_bhl help
	
	global D_bhl "whelp ptt2dlg"
	global D_bok "exit 3001"
	global D_bex "exit 3000"
	
	noi capture window dialog "2-sample t test" . . 140 95 
	if _rc>3000 {
		noi ttok
	}
end

program define ttok
	version 5.0
	
	if $D_rb1 == 1 {
		ptt2gdlg
	}
	else {
		ptt2vdlg
	}
end
