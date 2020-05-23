*! version 1.0.1  23oct1995
program define stkdlg  
	version 5.0
	
	precmd stkdlg
	
	getnv
	global D_vlist "$S_1"
	global D_var2 "$S_1"
	
	global D_sm1 "New data variable"
	global D_sm2 "Data variables"
	global D_sm3 "New group variable"

	window control static D_sm1           10 10 65 10 
	window control edit 77 10 35 10 D_var1

	window control static D_sm3           10 25 65 10 
	window control edit 77 25 35 10 D_var3

	window control static D_sm2           10 40 100 10 left
	window control msimple D_vlist 10 50 100 60 D_var2

	window control button "OK"      10 110 30 16 D_b1
	window control button "Cancel"  45 110 30 16 D_b2
	window control button "Help"    80 110 30 16 D_b3 help
	
	global D_b1 "stkok"
	global D_b2 "exit 3000"
	global D_b3 "whelp stkdlg"
	
	cap noi window dialog "Stack variables" . . 130 145
end

program define stkok
	if "$D_var1"=="" {
		window stopbox stop "No new data variable specified"
		exit
	}
	if "$D_var3"=="" {
		window stopbox stop "No new group variable specified"
		exit
	}
	local nobs = _N
	local nvar : word count $D_var2
	capture confirm var $D_var1
	if _rc>0 & _rc!=111 {
		window stopbox stop "Illegal new data variable name"
		exit
	}
	capture confirm var $D_var3
	if _rc>0 & _rc!=111{
		window stopbox stop "Illegal new data variable name"
		exit
	}

	if "$D_var1"=="$D_var3" {
		window stopbox stop "New data variable name must be different than new group variable name"
		exit
	}

	quietly {
		stack $D_var2, into($D_var1) clear
		local i 1
		local n : word count $D_var2
		local w1 : word 1 of $D_var2
		label define val 1 `w1'
		local i 2
		while `i'<=`n' {
			local w : word `i' of $D_var2 
			label define val `i' "`w'", add
			local i = `i'+1
		}
		label values _stack val
		rename _stack $D_var3
	}
	exit 3001
end
