*! version 1.0.0  12jul1995
program define sp3ok
	version 5.0
	local func = "`1'"
	local wc1 :word count $D_gvar
	local wc2 :word count $D_gvar2
	local wc3 :word count $D_gvby
	if `wc1'!=1 | `wc2'!=1 {
		window stopbox stop "Please specify a single variable for each axis"
		exit
	}
	if `wc3'!=1 {
		if "`func'"=="by" {
			window stopbox stop "Please specify a single group variable"
		}
		else if "`func'"=="name" {
			window stopbox stop "Please specify a single symbol variable"
		}
		else if "`func'"=="scale" {
			window stopbox stop "Please specify a single scale variable"
		}
		exit
	}
	if "`func'"=="name" {
		local opt "symbol([$D_gvby])"
	}
	else if "`func'"=="scale" {
		local weight " [weight=$D_gvby]"
	}
	else if "`func'"=="by" {
		if "$D_cb3"=="1" {
			local total "total"
		}
		local opt "by($D_gvby)"
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
		di in wh ". " _c
	}
	if "$D_run" != "" {
		di in wh "graph $D_gvar $D_gvar2`weight', xlab ylab bor `opt' `total'"
	}
	else {
		noi di in white
		di in wh ". graph $D_gvar $D_gvar2`weight', xlab ylab bor `opt' `total'"
	}
	global D_run
	window push graph $D_gvar $D_gvar2`weight', xlab ylab bor `opt' `total'
	graph $D_gvar $D_gvar2`weight', xlab ylab bor `opt' `total'
end
