*! version 1.0.1  10nov995
program define twomok
	version 5.0
	local func "`1'"
	mac shift
	local wc1: word count $D_var1
	local wc2: word count $D_var2
	local wc3: word count $D_var
	if `wc1'+`wc2'+`wc3'!=3 {
		if "`func'"=="summ" {
			window stopbox stop "Please specify one row variable," /*
				*/ "one column variable, and" /*
				*/ "one summary variable"
		}
		else if "`func'"=="by" {
			window stopbox stop "Please specify one row variable," /*
				*/ "one column variable, and" /*
				*/ "one group variable"
		}
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
	cap confirm var $D_var
	if _rc>0 {
		window stopbox stop "$D_var is not a valid variable"
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
	cap confirm string var $D_var
	if !_rc {
		if "`func'"=="summ" {
			window stopbox stop "$D_var is a string variable." /*
				*/ "Please use only a numeric summary variable."
		}
		else if "`func'"=="by" {
			window stopbox stop "$D_var is a string variable." /*
				*/ "Please use only a numeric group variable."
		}
		exit
	}
	if "`func'"=="summ" {
		di in wh "tabulate $D_var1 $D_var2, summ($D_var)"
		window push tabulate $D_var1 $D_var2, summ($D_var)
		tabulate $D_var1 $D_var2, summ($D_var)
	}
	else if "`func'"=="by" {
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
		di in wh "sort $D_var"
		window push sort $D_var
		sort $D_var
		di in wh ". by $D_var: tabulate $D_var1 $D_var2, chi2 `row'`column'`cell'`all'"
		window push by $D_var: tabulate $D_var1 $D_var2, chi2 `row'`column'`cell'`all'
		by $D_var: tabulate $D_var1 $D_var2, chi2 `row'`column'`cell'`all'
	}
end
