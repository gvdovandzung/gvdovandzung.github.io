program define nicen
	version 5.0
	local mac "`1'"
	if "`2'" != "=" {
		di in red /*
		*/ "nicenum macroname = arglist [if expr] [in range], Inter(#)"
		error 198
	}
	mac shift 2
	local remain "`*'"
	parse "`*'", parse(",")
	local arglist "`1'"
	local opts "`3'"

	parse "`arglist'", parse(" ")
	while "`1'" != "" & "`1'" != "if" & "`1'" != "in" {
		capture confirm var `1'
		if _rc != 0 {
			local numlist "`numlist' `1'"
		}
		else { local varlist "`varlist' `1'" }
		mac shift
	}
	tempvar use
	mark `use' `*'
	markout `use' `varlist'

	tempname gmin gmax
	if "`varlist'" != "" {
		parse "`varlist'", parse(" ")
		quietly summ `1' if `use'
		scalar `gmin' = _result(5)
		scalar `gmax' = _result(6)
		mac shift
		while "`1'" != "" {
			quietly summ `1' if `use'
			scalar `gmin'=cond(_result(5)<`gmin',_result(5),`gmin')
			scalar `gmax'=cond(_result(6)>`gmax',_result(6),`gmax')
			mac shift
		}
	}

	parse "`numlist'", parse(" ")
	if "`varlist'"=="" {
		scalar `gmin' = `1'
		scalar `gmax' = `1'
	}
	while "`1'" != "" {
		if `1' < `gmin' {
			scalar `gmin' = `1'
		}
		if `1' > `gmax' {
			scalar `gmax' = `1'
		}
		mac shift
	}

	local command 	"`*' , `opts'"
	local varlist	"opt"
	local options 	"Inter(int 5)"
	
	parse "`command'"

	local ntick = `inter'+1

	quietly {
		tempname gran exp d f nf tmp1 tmp2

		scalar `gran' = `gmax'-`gmin'
		scalar `d'    = `gran'/(`ntick'-1)

		global `mac'  ""

		scalar `tmp1' = `gmin'
		scalar `tmp2' = `gmax'
		local comma  ""
		local i 1
		while `i' < `ntick' {
			local val : di %6.0g `gmin'+(`i'-1)*`d'
			local val = trim(string(`val'))
			global `mac' "${`mac'}`comma'`val'"
			local i = `i'+1
			local comma ","
		}
		local val : di %6.0g `gmax'
		local val = trim(string(`val'))
		global `mac' "${`mac'},`val'"
	}
end

