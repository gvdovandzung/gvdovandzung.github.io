*! version 1.0.0  12jul1995
program define spmatok
	version 5.0
	parse "$D_gvar", parse(" ")
	if "`1'`2'"=="" {
		window stopbox stop "Please enter at least two numeric variables"
		exit
	}
	while "`1'"!="" {
		cap confirm string variable `1'
		if _rc==0 {
			window stopbox stop "`1' is a string variable.  Please" "select only numeric variables"
			exit
		}
		mac shift
	}
	if "$D_run" != "" {
		di in wh "graph $D_gvar, matrix label"
	}
	else {
		noi di in white
		di in wh ". graph $D_gvar, matrix label"
	}
	global D_run
	window push graph $D_gvar, matrix label
	graph $D_gvar, matrix label
end
