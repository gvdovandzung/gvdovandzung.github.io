*! version 1.0.0  12jul1995
program define sciok
	version 5.0
	if trim("$D_var")=="" {
		getnv
		local varlist "$S_1"
	}
	else {
		local varlist "req ex"
		cap parse "$D_var"
		if _rc>0 {
			window stopbox stop "Please specify only existing variables"
			exit
		}
	}
	cap confirm number $D_level
	if _rc>0 {
		window stopbox stop "Confidence level must be a number between 10 and 99"
		exit
	}
	else {
		if $D_level<10 | $D_level>99 {
			window stopbox stop "Confidence level must be a number between 10 and 99"
			exit
		}
	}
	di in wh "ci `varlist', level($D_level)"
	window push ci `varlist', level($D_level)
	ci `varlist', level($D_level)
end
