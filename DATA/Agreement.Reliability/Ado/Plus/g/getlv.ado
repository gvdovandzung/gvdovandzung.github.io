*! version 1.0.0  18apr1995
program define getlv
	local varlist	"opt"
	parse "`*'"
	
	local i 1
	global S_1 ""
	parse "`varlist'", parse(" ")
	while "``i''"!="" {
		local t : value label ``i''
		if "`t'" != "" {
			global S_1 "$S_1``i'' "
		}
		local i = `i'+1
	}
end
