*! version 1.0.0  12jul1995
program define summok
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
	di in wh "summarize `varlist'"
	window push summarize `varlist'
	summarize `varlist'
end
