*! version 1.0.0  12jul1995
prog def chistok
	version 5.0
	local wc :word count $D_gvar
	if `wc'!=1 {
		window stopbox stop "Please specify a single variable"
		exit
	}
	if "$D_run" != "" {
		di in wh "hist $D_gvar, ylab"
	}
	else {
		noi di in white
		di in wh ". hist $D_gvar, ylab"
	}
	global D_run
	window push hist $D_gvar, ylab
	hist $D_gvar, ylab
end
