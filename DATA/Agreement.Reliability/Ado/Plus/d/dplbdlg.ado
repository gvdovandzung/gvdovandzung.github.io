*! version 1.0.1   31jul1995
program define dplbdlg
	version 5.0
	
	precmd dplbdlg

	global D_run 1
	
	getnv
	global D_vlist "$S_1"
	
	global D_sm1 "Data variable"
	window control static D_sm1 5 7 55 8 left
	window control ssimple D_vlist 5 17 65 55 D_var1
	
	global D_sm3 "By group"
	window control static D_sm3 75 7 45 8 left
	window control ssimple D_vlist 75 17 65 55 D_var2
	
        window control check "Use raw data range" 25 74 90 10 D_cb1 right
	
	window control button "Draw"    3 89 30 16 D_b4
	window control button "OK"     38 89 30 16 D_b1
	window control button "Cancel" 73 89 30 16 D_b2
	window control button "Help"  108 89 30 16 D_b3 help
	
	global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp dpldlg"
	global D_b4 "dplok"
	
	cap noi window dialog "Dotplots by group" . . 150 125
	if _rc>3000 {
		if $D_cb1 == 1 {
			local opt "raw"
		}
		if "$D_run"!="" {
			noi di in white "dplot $D_var1, by($D_var2) `opt'"
		}
		else noi di _n in white ". dplot $D_var1, by($D_var2) `opt'"
		global D_run
		window push dplot $D_var1, by($D_var2) `opt'
		dplot $D_var1, by($D_var2) `opt'
	}
end

program define dplok
	version 5.0
	if $D_cb1 == 1 {
		local opt "raw"
	}
	if "$D_run"!="" {
		noi di in white "dplot $D_var1, by($D_var2) `opt'"
	}
	else    noi di _n in white ". dplot $D_var1, by($D_var2) `opt'"
	global D_run 
	window push dplot $D_var1, by($D_var2) `opt'
	dplot $D_var1, by($D_var2) `opt'
end
