*! version 1.0.0  12jul1995
prog def hstbyok
	version 5.0
	if "$inincr"=="1" | "$indecr"=="1" {
		if "$D_cb2"=="0" {
			exit
		}
	}
	local wc :word count $D_gvar
	if `wc'!=1 {
		window stopbox stop "Please specify a single variable"
		exit
	}
	if "`1'"=="by" {
		local wc :word count $D_gvby
		if `wc'!=1 {
			window stopbox stop "Please specify a single variable"
			exit
		}
	}
	if "$D_cb1"=="1" {
		local normal = "normal"
	}
	cap confirm integer number $D_bins
	if _rc>0 {
		window stopbox stop "Bins must be an integer"
		exit
	}
	if "`1'"=="by" {
		if "$D_cb3"!="" {
			if $D_cb3 == 1 {
				local total "total"
			}
		}
		if "$D_run" != "" {
			di in wh "sort $D_gvby"
		}
		else {
			noi di in white
			di in wh ". sort $D_gvby"
		}
		global D_run
		window push sort $D_gvby
		sort $D_gvby
		di in wh ". graph $D_gvar, by($D_gvby) b2title($D_gvby) hist ylab xlab bor bin($D_bins) `normal' `total'"
		window push graph $D_gvar, by($D_gvby) b2title($D_gvby) hist ylab xlab bor bin($D_bins) `normal' `total'
		graph $D_gvar, by($D_gvby) b2title($D_gvby) hist ylab xlab bor bin($D_bins) `normal' `total'
		exit
	}
	if "$D_run" != "" {
		di in wh "graph $D_gvar, bin($D_bins) `normal' ylab xlab"
	}
	else {
		noi di in white
		di in wh ". graph $D_gvar, bin($D_bins) `normal' ylab xlab"
	}
	global D_run
	window push graph $D_gvar, bin($D_bins) `normal' ylab xlab
	graph $D_gvar, bin($D_bins) `normal' ylab xlab
end
