*! version 1.0.0  12jul1995
program define oneok
	version 5.0
	local wc :word count $D_var
	if `wc'!=1 {
		window stopbox stop "Please specify one variable"
		exit
	}
	cap confirm var $D_var
	if _rc>3000 {
		window stopbox stop "$D_var is not a valid variable"
		exit
	}
	cap confirm string var $D_var
	if !_rc {
		window stopbox stop "$D_var is a string variable." /*
			*/ "Please use only a numeric variable."
		exit
	}
	if "$D_cb1"=="1" {
		local plot ", plot"
	}
	di in wh "tabulate $D_var`plot'"
	window push tabulate $D_var`plot'
	tabulate $D_var`plot'
end
