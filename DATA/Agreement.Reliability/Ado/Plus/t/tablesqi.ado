*! version 1.0.1  19jul1995
program define tablesqi
	version 5.0

	local type "`1'"
	mac shift

	if "`type'"=="Z" {
		local zval "`1'"
		confirm number `zval'

		local one = invnorm(`zval')
		di
		di in gr "Pr(Z<=z)     = `zval'"
		di in gr _col(8) "Quantile (z) = " in ye %7.0g `one'
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

		if `tval' >= .5 {
			local tt = 2*`tval'-1
			local sn 1
		}
		else {
			local tt = 1 - 2*`tval'
			local sn -1
		}
		local one = invt(`dof',`tt') * `sn'
		di
		di in gr "Pr(T<=t)     = `tval'"
		di in gr _col(8) "Quantile (t) = " in ye %7.0g `one'
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
		local one = invnchi(`dof',0,`xval')
		di
		di in gr "Pr(X<=x)     = `xval'"    
		di in gr _col(8) "Quantile (x) = " in ye %7.0g `one'
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

		local one = invfprob(`ndf',`ddf',1-`fval')
		di
		di in gr "Pr(F<=f)     = `fval'"
		di in gr _col(8) "Quantile (f) = " in ye %7.0g `one'
		exit
	}
	else {
		di in red "unknown option"
		exit 198
	}
end
