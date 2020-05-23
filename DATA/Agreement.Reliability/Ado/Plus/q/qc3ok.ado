*! version 1.0.0  12jul1995
program define qc3ok
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
	local wc: word count $D_gvby
	if `wc'!=1 {
		window stopbox stop "Please specify only one sample size variable"
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
	cap confirm string var "$D_gvby"
	if _rc==0 {
		window stopbox stop "$D_gvby is a string variable.  Please" /*
			*/ "specify only numeric variables."
		exit
	}
	if "$D_run" != "" {
		di in wh "pchart $D_gvar $D_gvar2 $D_gvby, xlab ylab"
	}
	else {
		noi di in white
		di in wh ". pchart $D_gvar $D_gvar2 $D_gvby, xlab ylab"
	}
	global D_run
	window push pchart $D_gvar $D_gvar2 $D_gvby, xlab ylab
	qui pchart $D_gvar $D_gvar2 $D_gvby, xlab ylab
end
