*! version 1.0.0  18apr1995
program define getbv
	local options "ALL ZERO"
	local varlist	"opt"
	parse "`*'"
	
	local i 1
	global S_1 ""
	parse "`varlist'", parse(" ")
	while "``i''"!="" {
		if "`all'"=="" {
			capture confirm string var ``i''
			if _rc {
				if "`zero'"!="" {
					capture assert ``i''==0 | ``i''==1 /*
					*/ | ``i''==.
					if _rc == 0 {
						global S_1 "$S_1``i'' "
					}
				}
				else {
					capture tab ``i''
					if _rc == 0 & _result(2)==2 {
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
