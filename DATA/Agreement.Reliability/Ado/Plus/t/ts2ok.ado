*! version 1.0.0  12jul1995
prog def ts2ok
	version 5.0
	local wc :word count $D_gvar
	else if `wc'<1 {
		window stopbox stop "Please specify at least one Y variable"
		exit
	}
	local wc :word count $D_gvar2
	if `wc'!=1 {
		window stopbox stop "Please specify only one X variable"
		exit
	}
	if "$D_cb1"=="1" {
		preserve
	}
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
				qui replace `1'=(`1'-_result(5)) / /*
				*/ `range'
			}
		}
		mac shift
	}
	cap confirm string var $D_gvar2
	if _rc==0 {
		window stopbox stop "$D_gvar2 is a string variable.  Please" /*
			*/ "specify only a numeric variable."
		exit
	}
	if "$D_run" != "" {
		di in wh "graph $D_gvar $D_gvar2, c(llllll) xlab ylab sort bor"
	}
	else {
		noi di in white
		di in wh ". graph $D_gvar $D_gvar2, c(llllll) xlab ylab sort bor"
	}
	global D_run
	window push graph $D_gvar $D_gvar2, c(llllll) xlab ylab sort bor
	graph $D_gvar $D_gvar2, c(llllll) xlab ylab sort bor

	if "$D_cb1"=="1" {
		restore
	}
end
