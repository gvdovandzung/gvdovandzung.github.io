*! version 1.0.1  19jul1995
program define tablesq
	version 5.0

	local type "`1'"
	mac shift

	if "`type'"=="Z" {
		local zval "`1'"
		confirm number `zval'

		local azval = abs(`zval')
		local one = normprob(-abs(`zval'))
		local two = 2*normprob(-abs(`zval'))
		if `zval' >= 0 {
			local a1 = 1-`one'
			local a2  = `one'
		}
		else {
			local a1 = `one'
			local a2 = 1-`one'
		}
		di
		di in gr _col(8) "Pr(Z <= `zval')   = " in ye %5.4f `a1'
		di in gr _col(8) "Pr(Z >= `zval')   = " in ye %5.4f `a2'
		di in gr _col(8) "Pr(|Z| >= `azval') = " in ye %5.4f `two'
		exit
	}
	else if "`type'"=="T" {
		local dof "`1'"
		local tval "`2'"

		confirm number `dof'
		confirm number `tval'

		if `dof'<=0 {
			di in red "degrees of freedom must be positive"
			exit 198
		}

		local atval = abs(`tval')
		local one = tprob(`dof',`tval')/2
		local two = tprob(`dof',`tval')

		if `tval' >= 0 {
			local a1 = 1-`one'
			local a2  = `one'
		}
		else {
			local a1 = `one'
			local a2 = 1-`one'
		}

		di
		di in gr "t(`dof') = `tval'"
		di in gr _col(8) "Pr(T <= `tval')   = " in ye %5.4f `a1'
		di in gr _col(8) "Pr(T >= `tval')   = " in ye %5.4f `a2'
		di in gr _col(8) "Pr(|T| >= `atval') = " in ye %5.4f `two'
		exit
	}
	else if "`type'"=="X" {
		local dof "`1'"
		local xval "`2'"

		confirm number `dof'
		confirm number `xval'

		if `dof'<=0 {
			di in red "degrees of freedom must be positive"
			exit 198
		}
		local one = chiprob(`dof',`xval')
		di
		di in gr "X(`dof') = `xval'"
		di in gr _col(8) "Pr(X <= `xval') = " in ye %5.4f 1-`one'
		di in gr _col(8) "Pr(X >= `xval') = " in ye %5.4f `one'
		exit
	}
	else if "`type'"=="F" {
		local ndf "`1'"
		local ddf "`2'"
		local fval "`3'"

		confirm number `ndf'
		confirm number `ddf'
		confirm number `fval'

		if `ndf'<=0 | `ddf'<=0 {
			di in red "degrees of freedom must be positive"
			exit 198
		}

		local one = fprob(`ndf',`ddf',`fval')
		di
		di in gr "F(`ndf',`ddf') = `fval'"
		di in gr _col(8) "Pr(F <= `fval') = " in ye %5.4f 1-`one'
		di in gr _col(8) "Pr(F >= `fval') = " in ye %5.4f `one'
		exit
	}
	else if "`type'"=="B" {
		local n "`1'"
		local k "`2'"
		local p "`3'"

		confirm number `n'
		confirm number `k'
		confirm number `p'

		if `n' <= 0 {
			di in red "number of trials must be positive"
			exit 198
		}
		if `k' < 0 | `k'>`n' {
			di in red "number of success is between 0 and `n'"
			exit 198
		}
		if `p'<0 | `p'>1 {
			di in red "probability of success must be in [0,1]"
			exit 198
		}

		tempname kplus kex kminus
		scalar `kplus' = Binomial(`n',`k',`p')
		scalar `kex' = `kplus' -Binomial(`n',`k'+1,`p')
		scalar `kminus' = 1 - Binomial(`n',`k'+1,`p')
		di
		di in gr "B(`n',`p') = `k'"
		di in gr _col(8) "Pr(k == `k') = " in ye %6.4f `kex'
		di in gr _col(8) "Pr(k >= `k') = " in ye %6.4f `kplus'
		di in gr _col(8) "Pr(k <= `k') = " in ye %6.4f `kminus'
		exit
	}
	else if "`type'"=="P" {
		local k "`1'"
		local lambda "`2'"

		confirm number `k'
		confirm number `lambda'
	
		local kplus cond(`k'>0,gammap(`k',`lambda'),1)
		local kex = `kplus'-cond(`k'+1>0,gammap(`k'+1,`lambda'),1)
		local kminus = 1-`kplus'+`kex'
	
		di
		di in gr "Poisson(`lambda') = `k'"
		di in gr _col(8) "Pr(k == `k') =  " in ye %6.4f `kex'
		di in gr _col(8) "Pr(k >= `k') =  " in ye %6.4f `kplus'
		di in gr _col(8) "Pr(k <= `k') =  " in ye %6.4f `kminus'
		exit
	}
	else {
		di in red "unknown option"
		exit 198
	}
end
