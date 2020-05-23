*! version 1.0.0  05may1995
program define intplot
	version 5.0
	
	if "$D_cmd"!="twowdlg" & "$D_cmd"!="rpmdlg" {
		exit 301
	}
	local depv "$D_depv"
	local cv1  "$D_var1"
	local cv2  "$D_var2"
	
	tempvar touse g g1 g2 d
	
	preserve
	quietly {
		mark `touse'
		markout `touse' `depv' `cv1' `cv2'
		keep if `touse'
		
		egen `g' = group(`cv1' `cv2')
		egen `g1' = group(`cv1')
		egen `g2' = group(`cv2')
		sort `g'
		egen `d' = mean(`depv'), by(`g')
		sort `g'
		by `g' : keep if _n==1
		
		tab `g1'
		local ngr1 = _result(2)
		local ngr = `ngr1'
		tab `g2'
		local ngr2 = _result(2)
		if `ngr2'<`ngr1' {
			local cv1 "$D_var2"
			local cv2 "$D_var1"
			replace `g1'=`g2'
			local ngr = `ngr2'
		}
		
		
		local i 1
		while `i'<=`ngr' {
			tempvar d`i'
			gen `d`i'' = `d' if `g1'==`i'
			label var `d`i'' "`cv1' - group `i'"
			local list "`list' `d`i''"
			local clist "`clist'l"
			local i = `i'+1
		}
		
	}
	graph `list' `cv2', c(`clist') title("Interaction Plot") xlab ylab
end
		
		
		
	
