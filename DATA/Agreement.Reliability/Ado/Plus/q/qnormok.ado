*! version 1.0.0  12jul1995
prog def qnormok
	version 5.0
	local wc :word count $D_gvar
	if `wc'!=1 {
		window stopbox stop "Please specify a single variable"
		exit
	}
	if "$D_run" != "" {
		di in wh "qnorm $D_gvar, grid xlab ylab"
	}
	else {
		noi di in white
		di in wh ". qnorm $D_gvar, grid xlab ylab"
	}
	global D_run
	window push qnorm $D_gvar, grid xlab ylab
	qnorm $D_gvar, grid xlab ylab
end
