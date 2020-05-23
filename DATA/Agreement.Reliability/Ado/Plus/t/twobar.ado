*! version 1.0.0  09may1995
program define twobar
	version 5.0
	
        local flag = `1'
	local var "${D_var`flag'}"
	if "$D_cmd" != "twowdlg" {
		di in red "must follow the use of the two-way anova dialog"
		exit 198
	}
	
	preserve
	quietly {
		tempvar mean std cnt yu yl
		
		sort $D_var1
		summ $D_depv
		local mn = _result(3)
		egen `mean' = mean($D_depv), by(`var')
		egen `std' = sd($D_depv), by(`var')
		egen `cnt' = count($D_depv), by(`var')
		replace `std' = invt(`cnt'[_n]-1,$D_level/100)* /*
		*/ `std'/sqrt(`cnt') 
		label var `mean' "Mean $D_depv by `var' level"
	}
	serrbar `mean' `std' `var', scale(1) ylab xlab yline(`mn')
end
