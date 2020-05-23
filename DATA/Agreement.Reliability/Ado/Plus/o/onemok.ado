*! version 1.0.0  12jul1995
program define onemok
	version 5.0
	local wc1: word count $D_var1
	local wc2: word count $D_var2
	if `wc1'+`wc2'!=2 {
		window stopbox stop "Please specify one group variable" "and one summary variable"
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
			*/ "Please use only a numeric group variable."
		exit
	}
	cap confirm string var $D_var2
	if !_rc {
		window stopbox stop "$D_var2 is a string variable." /*
			*/ "Please use only a numeric summary variable."
		exit
	}
	di in wh "tabulate $D_var1, summ($D_var2)"
	window push tabulate $D_var1, summ($D_var2)
	tabulate $D_var1, summ($D_var2)
end
