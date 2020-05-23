*! version 1.0.0  12jul1995
program define twook
	version 5.0
	local wc1: word count $D_var1
	local wc2: word count $D_var2
	if `wc1'+`wc2'!=2 {
		window stopbox stop "Please specify one row variable" "and one column variable"
		exit
	}
	cap confirm var $D_var1
	if _rc>0 {
		window stopbox stop "$D_var1 is not a valid variable"
		exit
	}
	cap confirm var $D_var2
	if _rc>0 {
		window stopbox stop "$D_var2 is not a valid variable"
		exit
	}
	cap confirm string var $D_var1
	if !_rc {
		window stopbox stop "$D_var1 is a string variable." /*
			*/ "Please use only a numeric row variable."
		exit
	}
	cap confirm string var $D_var2
	if !_rc {
		window stopbox stop "$D_var2 is a string variable." /*
			*/ "Please use only a numeric row variable."
		exit
	}
	if "$D_cb1"=="1" {
		local row "row "
	}
	if "$D_cb2"=="1" {
		local column "column "
	}
	if "$D_cb3"=="1" {
		local cell "cell "
	}
	if "$D_cb4"=="1" {
		local all "all "
	}
	di in wh "tabulate $D_var1 $D_var2, chi2 `row'`column'`cell'`all'"
	window push tabulate $D_var1 $D_var2, chi2 `row'`column'`cell'`all'
	tabulate $D_var1 $D_var2, chi2 `row'`column'`cell'`all'
end
