*! version 1.0.0  18apr1995
program define getiv
	local options "ALL"
	local varlist	"opt"
	parse "`*'"
	
	local i 1
	global S_1 ""
	parse "`varlist'", parse(" ")
	while "``i''"!="" {
		if "`all'"=="" {
			capture confirm string ``i''
			if _rc {
				capture assert ``i''==int(``i'')
				if _rc == 0 {
					qui summ ``i''
					if _result(6)-_result(5) < 50 {
					    global S_1 "$S_1``i'' "
					}
				}
			}
		}
		else {
			global S_1 "$S_1``i'' "
		}
		local i = `i'+1
	}
end
