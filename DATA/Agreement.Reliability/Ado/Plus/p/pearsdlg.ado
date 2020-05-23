*! version 1.0.0  12jul1995
program define pearsdlg
	version 5.0
	
       	precmd pearsdlg
	getnv
	global D_vlist "$S_1"
	
	global D_sm1 "Data variables"
	window control static D_sm1 5 10 160 8 left
	
	window control msimple D_vlist 5 20 100 50 D_depv
	
	window control button "OK"      5 72 30 16 D_b1
	window control button "Cancel" 42 72 30 16 D_b2
	window control button "Help"   79 72 30 16 D_b3 help
	
	global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp pearsdlg"
	cap noi window dialog "Pearson correlation" . . 125 110
	if _rc>3000 {
		noi di in white "pwcorr $D_depv, sig"
		window push pwcorr $D_depv, sig
		pwcorr $D_depv, sig
	}
end
