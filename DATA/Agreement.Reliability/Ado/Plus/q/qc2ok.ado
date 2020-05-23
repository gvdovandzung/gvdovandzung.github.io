*! version 1.0.0  12jul1995
program define qc2ok
	version 5.0
	local wc: word count $D_gvar
	if `wc'!=1 {
		window stopbox stop "Please specify only one defect count variable"
		exit
	}
	local wc: word count $D_gvar2
	if `wc'!=1 {
		window stopbox stop "Please specify only one identification variable"
		exit
	}
	cap confirm string var "$D_gvar"
	if _rc==0 {
		window stopbox stop "$D_gvar is a string variable.  Please" /*
			*/ "specify only numeric variables."
		exit
	}
	cap confirm string var "$D_gvar2"
	if _rc==0 {
		window stopbox stop "$D_gvar2 is a string variable.  Please" /*
			*/ "specify only numeric variables."
		exit
	}
	if "$D_run" != "" {
		di in wh "cchart $D_gvar $D_gvar2, xlab ylab"
	}
	else {
		noi di in white
		di in wh ". cchart $D_gvar $D_gvar2, xlab ylab"
	}
	global D_run
	window push cchart $D_gvar $D_gvar2, xlab ylab
	cchart $D_gvar $D_gvar2, xlab ylab
end
