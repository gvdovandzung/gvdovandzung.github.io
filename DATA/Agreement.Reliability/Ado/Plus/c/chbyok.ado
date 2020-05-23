*! version 1.0.0  12jul1995
prog def chbyok
	version 5.0
	local wc :word count $D_gvar
	if `wc'!=1 {
		window stopbox stop "Please specify a single variable"
		exit
	}
	local wc :word count $D_gvby
	if `wc'!=1 {
		window stopbox stop "Please specify a single variable"
		exit
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
	if "D_cb3"!="" {
		if $D_cb3 == 1 {
			local total "total"
		}
	}
	di in wh ". hist $D_gvar, by($D_gvby) b2title($D_gvby) `total' ylab"
	window push hist $D_gvar, by($D_gvby) b2title($D_gvby) `total' ylab
	hist $D_gvar, by($D_gvby) b2title($D_gvby) `total' ylab
end
