*! version 1.0.1  20jul1995
prog def boxok
	version 5.0

	local wc :word count $D_gvar
	if ("`1'"=="by" | "`1'"=="box") {
		if `wc'!=1 {
			window stopbox stop "Please specify a single variable"
			exit
		}
	}
	else if "`1'"=="boxes" | "`1'"=="ones" {
		if `wc'<1 {
			window stopbox stop "Please specify one or more variables"
			exit
		}
		if "`1'"=="ones" & "$D_cb1"=="1" {
			local rescale "rescale"
		}
	}
	if "`1'"=="by" {
		local wc :word count $D_gvby
		if `wc'!=1 {
			window stopbox stop "Please specify a single variable"
			exit
		}
		if "$D_cb3" == "1" {
			local total "total"
		}
		if "$D_run" != "" {
			di in wh "sort $D_gvby"
		}
		else {
			noi di in white
			di in wh ". sort $D_gvby"
		}
		window push sort $D_gvby
		sort $D_gvby
		di in wh ". graph $D_gvar, box ylab by($D_gvby) `total'"
		window push graph $D_gvar, box ylab by($D_gvby) `total'
		global D_run
		graph $D_gvar, box ylab by($D_gvby) `total'
		exit
	}
	else if "`1'"=="box" | "`1'"=="boxes" {
		if "$D_run" != "" {
			di in wh "graph $D_gvar, box ylab"
		}
		else {
			noi di in white
			di in wh ". graph $D_gvar, box ylab"
		}
		window push graph $D_gvar, box ylab
		global D_run
		graph $D_gvar, box ylab
	}
	else if "`1'"=="boxone" | "`1'"=="ones" {
		if "$D_run" != "" {
			di in wh "graph $D_gvar, oneway box `rescale'"
		}
		else {
			noi di in white
			di in wh ". graph $D_gvar, oneway box `rescale'"
		}
		window push graph $D_gvar, oneway box `rescale'
		global D_run
		graph $D_gvar, oneway box `rescale'
	}
	global D_run
end
