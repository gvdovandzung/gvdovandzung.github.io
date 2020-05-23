*! version 1.0.1   31jul1995
program define dpldlg
	version 5.0
	
	precmd dpldlg

	global D_run
	
	getnv
	global D_vlist "$S_1"
	
	window control static D_sm1 9 10 49 8 left
	global D_sm1 "Data variable"
	window control ssimple D_vlist 59 10 65 60 D_var1
	
        window control check "Use raw data range" 9 69 90 10 D_cb1 right
	
	window control button "Draw"    3 84 30 16 D_b4
	window control button "OK"     35 84 30 16 D_b1
	window control button "Cancel" 67 84 30 16 D_b2
	window control button "Help"   99 84 30 16 D_b3 help
	
	global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp dpldlg"
	global D_b4 "drawdp"
	
	cap noi window dialog "Dotplot" . . 140 120
	if _rc>3000 {
		if $D_cb1 == 1 {
			local opt ", raw"
		}
		if "$D_run"=="" {
			noi di in white "dplot $D_var1`opt'"
		}
		else    noi di _n in white ". dplot $D_var1`opt'"
		window push dplot $D_var1`opt'
		dplot $D_var1`opt'
	}
	global D_run
end

program define drawdp
	version 5.0
	if $D_cb1 == 1 {
		local opt ", raw"
	}
	if "$D_run"=="" {
		noi di in white "dplot $D_var1`opt'"
	}
	else    noi di _n in white ". dplot $D_var1`opt'"
	window push dplot $D_var1`opt'
	dplot $D_var1`opt'

	global D_run 1
end
