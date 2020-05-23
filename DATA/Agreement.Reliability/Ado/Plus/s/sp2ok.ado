*! version 1.0.0  12jul1995
program define sp2ok
	version 5.0
	local wc1 :word count $D_gvar
	local wc2 :word count $D_gvar2
	if `wc1'!=1 | `wc2'!=1 {
		window stopbox stop "Please specify a single variable for each axis"
		exit
	}
	if "`1'"=="reg" {
		local opts "c(.l) s(oi) sort"
		if "$D_run" != "" {
			di in wh "regress $D_gvar $D_gvar2"
		}
		else {
			noi di in white
			di in wh ". regress $D_gvar $D_gvar2"
		}
		window push regress $D_gvar $D_gvar2
		qui regress $D_gvar $D_gvar2
		local ttl : di "$D_gvar=" %8.0g _b[_cons] 
		local sl : di %8.0g _b[$D_gvar2]
                local sl = trim("`sl'")
		if _b[$D_gvar2] < 0 {
			local ttl "`ttl'`sl'$D_gvar2"
		}
		else    local ttl "`ttl'+`sl'$D_gvar2"
		local opts "t1(`ttl') `opts'"
		di 
		di in wh ". predict _Yhat"
		tempvar hatvar
		window push predict _Yhat
		predict `hatvar'
		label var `hatvar' "_Yhat"
		di
		di in wh ". graph $D_gvar _Yhat $D_gvar2, xlab ylab bor `opts'"
	}
	else if "`1'"=="ts1" {
		local opts = "c(l) sort"
		if "$D_run" != "" {
			di in wh "graph $D_gvar $D_gvar2, xlab ylab bor `opts'"
		}
		else {
			noi di in white
			di in wh ". graph $D_gvar $D_gvar2, xlab ylab bor `opts'"
		}
	}
	else {
		if "$D_run" != "" {
			di in wh "graph $D_gvar $D_gvar2, xlab ylab bor `opts'"
		}
		else {
			noi di in white
			di in wh ". graph $D_gvar $D_gvar2, xlab ylab bor `opts'"
		}
	}
	global D_run
	window push graph $D_gvar _Yhat $D_gvar2, xlab ylab bor `opts'
	graph $D_gvar `hatvar' $D_gvar2, xlab ylab bor `opts'
	if "`hatvar'"!="" {
		di 
		di in wh ". drop _Yhat"
		window push drop _Yhat
	}
end
