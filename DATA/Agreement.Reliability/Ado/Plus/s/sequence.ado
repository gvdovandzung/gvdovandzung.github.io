*! version 1.0.0  5 May 1995
program define sequence
	version 5.0
	parse "`*'", parse("=()")
	if "`2'"~="=" & "`3'"~="(" & "`5'"~=")" {
		error 198
	}
	local terms "`4'"
	local x "`1'"
	macro shift 5
	local varlist "req new max(1)"
	local options "Repeat Expand Interval N(integer 0)"
	local old_N = _N
	parse "`x' `*'"
	drop `varlist'
	local x "`varlist'"

* Check _N.

	if _N == 0 & `old_N' > 0 {
		quietly set obs `old_N'
	}
	if `n'< 0 {
		di in red "n() cannot be negative"
		exit 499
	}
	if `n'==0 {
		if _N==0 { error 2000 }
		local n = _N
	}

* Only one of repeat, expand, and interval allowed.

	local i = ("`repeat'"~="")+("`expand'"~="")+("`interval'"~="")
	if `i' > 1 {
		di in red "only one of { repeat | expand | interval } allowed"
		exit 198
	}
	else if `i' == 0 {
		local repeat repeat
	}

* Parse `terms'.

	tparse `terms'

	if "$S_2"=="c" & "$S_3"=="d" {
		di in red "multiple sequence definitions not allowed"
		exit 198
	} 

* Compute start, step, and npt (number of points) for each type of sequence.

	if "`interval'"~="" {
		if "$S_2"=="c" | "$S_3"=="d" {
			di in red "not allowed with interval option"
			exit 198
		} 
		igetstep $S_1
	}
	else if "$S_2"=="c" { cgetstep $S_1 }
	else if "$S_3"=="d" { dgetstep $S_1 }
	else {

	* Generate variable if literal sequence.

		genlit `repeat' `expand' `x' `n' $S_1
		exit
	}

* Results from i/c/dgetstep: start = $S_1, step = $S_2, npt = $S_3.

	genseq `repeat' `expand' `interval' `x' `n' $S_1 $S_2 $S_3
end


program define igetstep /* terms */
	version 5.0
	parse "`*'", parse(" ")
	if "`3'"~="" {
		di in red "only two terms allowed with interval option"
		exit 198
	}
	global S_1 `1'
	global S_2  = `2' - `1'
	global S_3 2
end


program define cgetstep /* terms */
	version 5.0
	parse "`*'", parse(" ")
	confirm integer number `1'
	global S_1 `1'
	if "`2'"~="c" | "`4'"~="" {
		di in red "syntax for : violated"
		exit 198
	}
	if "`3'"~="" {
		confirm integer number `3'
		global S_2 = sign(`3' - `1')
		global S_3 = abs(`3' - `1') + 1
	}
	else {
		global S_2 1
		global S_3
	}
end


program define dgetstep /* terms */
	version 5.0
	parse "`*'", parse(" ")
	if ~("`1'"~="d" & "`2'"~="d" & "`3'"=="d") /*
	*/ | "`4'"=="d" | "`5'"~="" {
		di in red "syntax for ... violated"
		exit 198
	}
	global S_1 `1'           /* start of sequence    */
	global S_2  = `2' - `1'  /* stepsize of sequence */
	if "`4'"~="" {
		global S_3 = int((`4'-$S_1)/$S_2+1e-7) /* no. of steps */
		if $S_3 <= 0 {
			di in red "sequence end value impossible"
			exit 499
		}
		if abs($S_3*$S_2+$S_1-`4') > 1e-7 {
			di in blu /*
		*/ "Warning: specified sequence end value not met"
		}
		if $S_2 == 0 { global S_3 1 } /* or error?!! */
		else global S_3 = $S_3 + 1  /* no. of points in sequence */
	}
	else global S_3
end


program define genlit /* option x n terms */
	version 5.0
	local option "`1'"
	local x      "`2'"
	local n      "`3'"
	macro shift 3
	local npt : word count `*'
	tempvar k y
	local old_N = _N
	capture {
		noisily genseq `option' `k' `n' 1 1 `npt'

		gen `y' = .
		local i 1
		while `i' <= `npt' {
			replace `y' = ``i'' in `i'
			local i = `i' + 1
		}
		gen `x' = `y'[`k']
	}
	if _rc>0 {
		local rc = _rc
		if _N > `old_N' { quietly drop if _n > `old_N' }
		error `rc'
	}
end


program define genseq /* option x n start step npt */
	version 5.0
	local option "`1'"
	local x      "`2'"
	local n      "`3'"
	local start  "`4'"
	local step   "`5'"
	local npt    "`6'"  /* empty if infinite sequence */
	if "`npt'"~="" {
		if `npt' > `n' {
			di in red "insufficient observations to hold sequence"
			exit 2001
		}
		if mod(`n',`npt')~=0 {
			di in blu "Warning: last `option' truncated"
		}
	}	
	local old_N = _N
	capture {
		if `n' > _N { noisily set obs `n' }
		if "`npt'"=="" {
			gen `x' = `step'*(_n-1) + `start' in 1/`n'
		}
		else if "`option'"=="repeat" {
			gen `x' = `step'*mod(_n-1,`npt') + `start' in 1/`n'
		}
		else if "`option'"=="expand" {
			local npt = cond(mod(`n',`npt')==0, /*
			*/	`n'/`npt', int(`n'/`npt')+1)

			gen `x' = `step'*int((_n-1)/`npt') + `start' in 1/`n'
		}
		else { /* "`option'"=="interval" */
			gen `x' = `step'*(_n-1)/(`n'-1) + `start' in 1/`n'
		}
	}
	if _rc>0 {
		local rc = _rc
		if _N > `old_N' { quietly drop if _n > `old_N' }
		error `rc'
	}
end


program define tparse /* terms */
	version 5.0
	global S_2
	global S_3
	parse "`*'", parse(" ,:")
	local nt : word count `*'
	local i 1
	while `i' <= `nt' {
		if "``i''"~="," {
			capture confirm number ``i''
			if _rc == 0 { local terms "`terms' ``i''" }
			else if "``i''"==":" {
				local terms "`terms' c"
				global S_2 "c"
			}
			else {
				finddots ``i''
				local terms "`terms' $S_1"
			}
		}
		local i = `i' + 1
	}					
	global S_1 "`terms'"
end


program define finddots /* look for "..." in item */
	version 5.0
/*
	Possibilities are 1...8 1... ...8 (or .. rather than ...)
	Replace ".." or "..." with "d"
*/
	local j = index("`1'","...")
	if `j' { local dots 3 }
	else {
		local j = index("`1'","..")
		local dots 2
	}
	if `j' > 1 {
		local number = substr("`1'",1,`j'-1)
		confirm number `number'
	}
	else if `j' == 0 { error 198 }
	global S_1 "`number' d"
	global S_3 "d"
	local number = substr("`1'",`j'+`dots',.)
	if "`number'" ~= "" {
		confirm number `number'
		global S_1 "$S_1 `number'"
	}
end

