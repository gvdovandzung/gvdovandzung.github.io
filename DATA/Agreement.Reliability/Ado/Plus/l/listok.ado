*! version 1.0.0  12jul1995
program define listok
	version 5.0
	local varlist "opt ex"
	cap parse "$D_var"
	if _rc>0 {
		window stopbox stop "Please specify only existing variables"
		exit
	}
	cap confirm number $D_nobs1
	if _rc>0 {
		window stopbox stop "Please specify a valid first observation"
		exit
	}
	cap confirm number $D_nobs2
	if _rc>0 {
		window stopbox stop "Please specify a valid last observation"
		exit
	}
	if $D_nobs1<1 | $D_nobs1>_N | $D_nobs2<1 | $D_nobs2>_N {
		local N = _N
		local txt "Please specify observation numbers between 1 and `N'"
		window stopbox stop "`txt'"
		exit
	}
	if $D_nobs1 > $D_nobs2 {
		window stopbox stop "The first observation cannot be greater than the last observation"
		exit
	}
	di in wh "list `varlist' in $D_nobs1/$D_nobs2"
	window push list `varlist' in $D_nobs1/$D_nobs2
	list `varlist' in $D_nobs1/$D_nobs2
end
