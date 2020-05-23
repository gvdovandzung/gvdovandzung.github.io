*! version 1.0.0  18apr1995
program define getc2v
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
				capture tab ``i''
				if _rc == 0 & _result(2) < 50 {
				    global S_1 "$S_1``i'' "
				}
			}
		}
		else {
			global S_1 "$S_1``i'' "
		}
		local i = `i'+1
	}
end
