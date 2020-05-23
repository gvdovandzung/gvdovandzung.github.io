*! version 1.0.0  15may1995
program define randpoi
	tempvar sum
	qui gen `sum' = 0
	qui replace `1' = 0
	while(1) {
		qui replace `sum' = `sum' - log(uniform())
		qui count if `sum'<`2'
		if (_result(1)==0) { exit }
		qui replace `1' = `1' + 1 if `sum'<`2'
	}
end
