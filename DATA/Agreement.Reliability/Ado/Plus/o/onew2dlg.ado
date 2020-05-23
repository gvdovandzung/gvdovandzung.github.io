*! version 1.0.1  31jul1995
program define onew2dlg
	version 5.0
	
	precmd onewdlg
	
	getnv
	global D_vlist "$S_1"
	
	global D_sm1 "Data variables"

	window control static D_sm1           10 10 100 10 left
	window control msimple D_vlist 10 20 100 60 D_var1

	window control button "OK"      10 80 30 16 D_b1
	window control button "Cancel"  45 80 30 16 D_b2
	window control button "Help"    80 80 30 16 D_b3 help
	
	global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp onewdlg"
	
	cap noi window dialog "One-way ANOVA" . . 130 115
	if _rc>3000 {
		quietly {
			preserve
			stack $D_var1, into(response) clear
			local i 1
			local n : word count $D_var1
			local w1 : word 1 of $D_var1
			label define val 1 `w1'
			local i 2
			while `i'<=`n' {
				local w : word `i' of $D_var1 
				label define val `i' "`w'", add
				local i = `i'+1
			}
			label values _stack val
			rename _stack treat
			label var treat "Treatment"
			global D_sd1 "$D_var1"
			global D_sd2 "$D_var2"
			global D_var1 "response"
			global D_var2 "treat"
		}
		noi di in white "oneway $D_var1 $D_var2, tabulate"
		window push oneway $D_var1 $D_var2, tabulate
		oneway $D_var1 $D_var2, tabulate
		if "$D_level"=="" {
			if "$S_level"=="" { global D_level = 95 }
			else                global D_level = $S_level
		}
		onegdlg
		global D_var1 "$D_sd1"
		global D_var2 "$D_sd2"
		quietly restore
	}
end
