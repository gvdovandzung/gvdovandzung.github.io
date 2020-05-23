*! version 1.0.0  12may1995
program define setodlg
	version 5.0
	local nvar  "`1'"
	if "`nvar'"=="" {
		local nvar 1
	}
	else if `nvar'<1 {
		local nvar 1
	}
	
	global D_ms1 "Data set is empty."
	global D_ms2 "Please set desired number of observations below"
	
	window control static D_ms1 60 10 60 10 
	window control static D_ms2 10 20 170 10 
	
	window control edit 80 40 30 10 D_nnn
	
	window control button "OK" 80 60 30 16 D_b1
	global D_b1 "chknum `nvar'"
	
        if "."=="" | $D_dlgx==. {
		global D_dlgx = 10
	}
        if "."=="" | $D_dlgy==. {
		global D_dlgy = 10
	}
	cap noi window dialog "Set number of observations" . . 200 100
	global D_ms1
	global D_ms2
end

program define chknum
	version 5.0
	local nvar = `1'

	if "$D_nnn"=="" {
		window stopbox stop "Please enter a number"
	}
	if int($D_nnn) != $D_nnn {
		window stopbox stop "Please enter an integer"
	}
	if $D_nnn <= 0 {
		window stopbox stop "Observations must be positive"
	}
	if $D_nnn > 600 {
		window stopbox stop "Observations must be less than or equal to 600"
	}
	if ($D_nnn*`nvar') > 4000 {
		window stopbox stop "You cannot have more than 4000 cells (variables x obs)"
	}
	exit 3001
end

