*! version 1.0.0  12jul1995
program define dtlok
	version 5.0
	local wc :word count $D_var
	if `wc'!=1 {
		window stopbox stop "Please specify one variable"
		exit
	}
	cap confirm var $D_var
	if _rc>0 {
		window stopbox stop "$D_var is not a valid variable"
		exit
	}
	di in wh "summarize $D_var, detail"
	window push summarize $D_var, detail
	summarize $D_var, detail
end
