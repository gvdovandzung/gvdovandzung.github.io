*! version 1.0.0  18apr1995
program define getsv
	local varlist	"opt"
	parse "`*'"
	
	local i 1
	global S_1 ""
	parse "`varlist'", parse(" ")
	while "``i''"!="" {
		capture confirm string var ``i''
		if _rc==0 {
			global S_1 "$S_1``i'' "
		}
		local i = `i'+1
	}
end
