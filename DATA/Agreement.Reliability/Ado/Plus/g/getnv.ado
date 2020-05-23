*! version 1.0.0  18apr1995
program define getnv
	local options "ALL"
	local varlist	"opt"
	parse "`*'"
	
	local i 1
	global S_1 ""
	parse "`varlist'", parse(" ")
	while "``i''"!="" {
		if "`all'"=="" {
			capture confirm string var ``i''
			if _rc {
				global S_1 "$S_1``i'' "
			}
		}
		else {
			global S_1 "$S_1``i'' "
		}
		local i = `i'+1
	}
end
