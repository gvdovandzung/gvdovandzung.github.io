*! version 1.0.0  21apr1995
program define ptp2dlg
	version 5.0
	
	precmd ptp2dlg
	
	window control static D_sm3 5 8 125 29 blackframe
	window control static D_sm4 50 6 42 10 center
	global D_sm4 "Options"
       	window control radbegin "1 data variable, 1 group variable" 10 15 115 9 D_rb1 right
	window control radend "2 independent data variables" 10 25 115 9 D_rb1 right
	global D_rb1 1
	
	window control button "OK"     12 45 30 16 D_bok
	window control button "Cancel" 50 45 30 16 D_bex
	window control button "Help"   87 45 30 16 D_bhl help
	
	global D_bhl "whelp ptp2dlg"
	global D_bok "exit 3001"
	global D_bex "exit 3000"
	
	noi capture window dialog "2-sample test of proportions" . . 140 80 
	if _rc>3000 {
		noi tpok
	}
end

program define tpok
	version 5.0
	
	if $D_rb1 == 1 {
		ptp2gdlg
	}
	else {
		ptp2vdlg
	}
end
