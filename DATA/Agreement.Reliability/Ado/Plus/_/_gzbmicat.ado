*! version 1.0.1 dec2003    (SJ4-1: dm0004)
program define _gzbmicat
	version 8

	preserve

	noi findfile zbmicat.dta
	local fn "`r(fn)'"

	gettoken type 0 : 0
	gettoken g    0 : 0
	gettoken eqs  0 : 0

	gettoken paren 0 : 0, parse("(), ")
	gettoken measure 0 : 0, parse("(), ")
	gettoken paren 0 : 0, parse("(), ")
	if `"`paren'"' != ")" {
		error 198
	}

	syntax [if] [in], Xvar(varname numeric) GENder(varname) GENCode(string) /*
	*/[AGEUnit(string) BY(string)]
	if `"`by'"' != "" {
		_egennoby zbmicat() `"`by'"'
		/* NOTREACHED */
	}



	local 1 `gencode'
	*zap commas to spaces (i.e. commas indulged)
	local 1 : subinstr local 1 "," " ", all
	tokenize "`1'", parse("= ")
	
	if "`1'" == substr("male",1,length("`1'")) {
		*male first
		if "`2'" ~= "=" | "`5'" ~= "=" {
			Badsyntax
		}
		if "`4'" ~= substr("female",1,length("`4'")) {
			Badsyntax
		}
		if "`7'" ~= "" {
			Badsyntax
		}
		local male "`3'"
		local female "`6'"
	}
	else if "`1'" == substr("female",1,length("`1'")) {
		*female first
		if "`2'" ~= "=" | "`5'" ~= "=" {
			Badsyntax
		}
		if "`4'" ~= substr("male",1,length("`4'")) {
			Badsyntax
		}
		if "`7'" ~= "" {
			Badsyntax
		}
		local female "`3'"
		local male "`6'"
	}
	else Badsyntax

	local x : type `gender'
	local y = substr("`x'",1,3)
	if "`y'" == "str" {
		capture assert `gender'=="`male'" | `gender'=="`female'" | `gender'=="" | `gender'==" "
		if _rc {
			di as err "The gender variable takes values other than `male' and `female'"
			exit 
		}
	}
	else {
		capture assert `gender'==`male' | `gender'==`female' | `gender'==.
		if _rc {
			di as err "The gender variable takes values other than `male' and `female'"
			exit 
		}
	}


	if "`ageunit'"=="" {
		local ageunit year
	}
	else {
		capture assert "`ageunit'"=="day" | "`ageunit'"=="month" | "`ageunit'"=="year"
		if _rc {
			di as err "The ageunit option must contain the word" in green " day" in red "," /*
			*/in green " month" in red " or" in green " year"
			exit
		}
	}

	tempvar ageyr dif agefrac __25 __30

	foreach x in sex age 25 30 25_nx 30_nx merge {
		capture confirm new var __IOTF`x'
		if _rc {
			di as err "__IOTF`x' is used by zbmicat - rename your variable"
			exit 110
		}
	}

	marksample touse

	quietly { 
		if "`y'" == "str" {
			gen __IOTFsex=1 if `gender'=="`male'"
			replace __IOTFsex=2 if `gender'=="`female'"
		}
		else {
			gen __IOTFsex=1 if `gender'==`male'
			replace __IOTFsex=2 if `gender'==`female'
		}

		if "`ageunit'"=="year" {
			gen `ageyr'=`xvar'
		}
		else if "`ageunit'"=="month" {
			gen `ageyr'=`xvar'/12
		}
		else if "`ageunit'"=="day" {
			gen `ageyr'=`xvar'/365.25
		}
		gen __IOTFage=int(`ageyr')
		gen `dif' = `ageyr'-__IOTFage
		replace __IOTFage=__IOTFage+0.5 if `dif'>=0.5 & `dif'<.

		sort __IOTFsex __IOTFage
		merge __IOTFsex __IOTFage using "`fn'", nokeep _merge(__IOTFmerge)

		gen `agefrac' = (`ageyr'-__IOTFage)/0.5 if `ageyr'>=2 & `ageyr'<18 & `touse' & __IOTFmerge==3
		gen `__25' = __IOTF25+`agefrac'*(__IOTF25_nx-__IOTF25) if `ageyr'>=2 & `ageyr'<18 & `touse' & __IOTFmerge==3
		gen `__30' = __IOTF30+`agefrac'*(__IOTF30_nx-__IOTF30) if `ageyr'>=2 & `ageyr'<18 & `touse' & __IOTFmerge==3
		replace `__25' = __IOTF25 if `ageyr'==18 & `touse' & __IOTFmerge==3
		replace `__30' = __IOTF30 if `ageyr'==18 & `touse' & __IOTFmerge==3

		gen `type' `g' = 1 if `measure'<`__25' & `ageyr'>=2 & `ageyr'<=18 & `touse' & __IOTFmerge==3
		replace `g' = 2 if `measure'>=`__25' & `measure'<`__30' & `ageyr'>=2 & `ageyr'<=18 & `touse' & __IOTFmerge==3
		replace `g' = 3 if `measure'>=`__30' & `measure'<. & `ageyr'>=2 & `ageyr'<=18 & `touse' & __IOTFmerge==3
		replace `g'=. if `measure'<=0
		capture lab def bmicat_lab 1 "Normal wt" 2 "Overweight" 3 "Obese"
		lab val `g' bmicat_lab
		drop __IOTFsex __IOTFage __IOTF25 __IOTF30 __IOTF25_nx __IOTF30_nx __IOTFmerge
	}

	quietly count if `g'<. & `touse'
	if r(N) { 
		local y = cond(r(N)==1,"y","")
		local ies = cond(r(N)>1,"ies","")
		local s = cond(r(N)>1,"s","")
		di as text "(BMI categor`y'`ies' generated for " r(N) " case`s')" 
		di as text "(gender was assumed to be coded male=`male', female=`female')"
		di as text "(age was assumed to be in `ageunit's)"
	}

	quietly count if `g'==. & `touse'
	if r(N) { 
		di as text "(A BMI category can be missing because age<2 years or age>18 years," 
		di as text " the gender variable is missing, or BMI is a nonpositive value)"
	}

	restore, not

end

program Badsyntax
	di as err "gencode() option invalid: see {help zbmicat}"
	exit 198
end
