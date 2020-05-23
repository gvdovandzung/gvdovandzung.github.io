*! version 1.0.0  12jul1995
prog def ts1ok
	version 5.0
	local mto "`1'"
	mac shift
	local wc :word count $D_gvar
	if `wc'!=1 & "`mto'"!="mto" {
		window stopbox stop "Please specify a single variable"
		exit
	}
	else if `wc'<1 & "`mto'"=="mto" {
		window stopbox stop "Please specify at least one variable"
		exit
	}
	if "$D_cb1"=="1" {
		preserve
	}
	if "`mto'"=="mto" {
		parse "$D_gvar",parse(" ")
		while "`1'"!="" {
			cap confirm string var `1'
			if _rc==0 {
				window stopbox stop /*
				    */ "`1' is a string variable.  Please" /*
				    */ "specify only numeric variables."
				
				exit
			}
			if "$D_cb1"=="1" {
				qui summ `1'
				local range = _result(6)-_result(5)
				if `range'==0 {
					qui replace `1'=.5
				}
				else {
					qui replace `1' = (`1'-_result(5))/ /*
					*/ `range'      
				}
			}
			mac shift
		}
		local connect "c(lllllllllllllllll)"
	}
	else {
		cap confirm string var $D_gvar
		if _rc==0 {
			window stopbox stop "$D_gvar is a string variable.  Please" /*
				*/ "specify only numeric variables."
			exit
		}
		local connect "c(l)"
	}
	cap drop _Time
	gen int _Time = _n
	if "$D_run" != "" {
		di in wh "graph $D_gvar _Time, `connect' xlab ylab bor"
	}
	else {
		noi di in white
		di in wh ". graph $D_gvar _Time, `connect' xlab ylab bor"
	}
	global D_run
	window push graph $D_gvar _Time, `connect' xlab ylab bor
	graph $D_gvar _Time, `connect' xlab ylab bor
	di in wh ". drop _Time"
	window push drop _Time
	cap drop _Time
	if "$D_cb1"=="1" {
		restore
	}
end
