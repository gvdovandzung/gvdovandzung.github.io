*! version 1.0.0  12jul1995
prog def barok
	version 5.0
	local wc :word count $D_gvar
	if "`1'"=="bars" | "`1'"=="barsby" {
		if `wc'<1 | `wc'>6 {
			window stopbox stop "Please specify between one and six variables"
			exit
		}
	}
	else if "`1'"=="by" {
		if `wc'!=1 {
			window stopbox stop "Please specify a single variable"
			exit
		}
	}
	if "`1'"=="by" | "`1'"=="barsby" {
		local wc :word count $D_gvby
		if `wc'!=1 {
			window stopbox stop "Please specify a single variable"
			exit
		}
	}
	if "$D_cb1"=="1" {
		local means = "means"
	}
	if "`1'"=="by" | "`1'"=="barsby" {
		if "$D_cb3"=="1" {
			local total "total"
		}
		if "$D_run" != "" {
			di in wh "sort $D_gvby"
		}
		else {
			di in wh ". sort $D_gvby"
		}
		window push sort $D_gvby
		sort $D_gvby
		global D_run
		di in wh ". graph $D_gvar, by($D_gvby) b2title($D_gvby) bar ylab noax ylin `means' `total'"
		window push graph $D_gvar, by($D_gvby) b2title($D_gvby) bar ylab noax ylin `means' `total'
		graph $D_gvar, by($D_gvby) b2title($D_gvby) bar ylab noax ylin `means' `total'
	}
	else if "`1'"=="bars" {
		if "$D_run" != "" {
			di in wh "graph $D_gvar, bar ylab noax yli `means'"
		}
		else {
			di in wh ". graph $D_gvar, bar ylab noax yli `means'"
		}
		window push graph $D_gvar, bar ylab noax yli `means'
		global D_run
		graph $D_gvar, bar ylab noax yli `means'
	}
end
