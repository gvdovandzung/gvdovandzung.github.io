*! version 1.0.0  09may1995
program define onebar
	version 5.0
	
	if "$D_cmd" != "onewdlg" {
		di in red "must follow the use of the one-way anova dialog"
		exit 198
	}
	
	preserve
	quietly {
		tempvar mean std cnt yu yl
		
		sort $D_var1
		summ $D_var1
		local mn = _result(3)
		egen `mean' = mean($D_var1), by($D_var2)
		egen `std' = sd($D_var1), by($D_var2)
		egen `cnt' = count($D_var1), by($D_var2)
		replace `std' = invt(`cnt'[_n]-1,$D_level/100)*`std'/sqrt(`cnt')
		label var `mean' "Mean $D_var1 by $D_var2 level"
	}
	serrbar `mean' `std' $D_var2, scale(1) ylab xlab yline(`mn')
end
