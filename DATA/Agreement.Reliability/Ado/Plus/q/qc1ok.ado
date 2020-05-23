*! version 1.0.0  12jul1995
program define qc1ok
	version 5.0
	local wc: word count $D_gvar
	if `wc'<=1 {
		window stopbox stop "Please specify at least two variables"
		exit
	}
	local qc "`1'"
	mac shift
	parse "$D_gvar", parse(" ")
	while "`1'"!="" {
		cap confirm string var "`1'"
		if _rc==0 {
			window stopbox stop "`1' is a string variable.  Please" /*
				*/ "specify only numeric variables."
			exit
		}
		mac shift
	}
	if "`qc'"=="range" {
		local cmd "rchart"
	}
	else if "`qc'"=="xbar" {
		local cmd "xchart"
	}
	else if "`qc'"=="xbarpr" {
		local cmd "shewhart"
	}
	if "$D_run" != "" {
		di in wh "`cmd' $D_gvar, c(l)"
	}
	else {
		noi di in white
		di in wh ". `cmd' $D_gvar, c(l)"
	}
	global D_run
	window push `cmd' $D_gvar, c(l)
	`cmd' $D_gvar, c(l)
end
