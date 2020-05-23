*! version 1.0.1 dec2003  (SJ4-1: dm0004)
program define _gzanthro
	version 8

	preserve

	gettoken type 0 : 0
	gettoken g    0 : 0
	gettoken eqs  0 : 0

	gettoken paren 0 : 0, parse("(), ")

	gettoken measure 0 : 0, parse("(), ")
	gettoken chart  0 : 0, parse("(), ")
	if `"`chart'"' == "," {
		gettoken chart  0 : 0, parse("(), ")
	}
	gettoken version  0 : 0, parse("(), ")
	if `"`version'"' == "," {
		gettoken version  0 : 0, parse("(), ")
	}

	gettoken paren 0 : 0, parse("(), ")
	if `"`paren'"' != ")" {
		error 198
	}


	if "`chart'"=="wh" | "`chart'"=="wl" {
		syntax [if] [in], Xvar(varname numeric) GENder(varname) GENCode(string) /*
		*/[NOCutoff BY(string)]
	}
	else if "`chart'"=="ha" |  "`chart'"=="wa" | "`chart'"=="ba" | "`chart'"=="hca" | /*
	*/"`chart'"=="sha" | "`chart'"=="lla" | "`chart'"=="la" {
		syntax [if] [in], Xvar(varname numeric) GENder(varname) GENCode(string) /*
		*/[AGEUnit(string) NOCutoff BY(string)]
		local forage 1
	}
	else {
		di as text "`chart'" as error " is an invalid chart code. See " /*
		*/as text "{help zanthro}" as error " for valid chart codes."
		exit 198
	}

	if `"`by'"' != "" {
		_egennoby zanthro() `"`by'"'
		/* NOTREACHED */
	}

	capture assert "`version'"=="US" | "`version'"=="UK"
	if _rc {
		di as text "`version'" as error " is an invalid version.  The only valid choices are " /*
		*/as text "US" as error " and " as text "UK" as error"."
		exit 198
	}

	capture assert "`version'"=="UK" if "`chart'"=="sha"
	if _rc {
		di as error "For chart code " as text "sha" as error ", " as text "UK" as error " is the only valid version"
		exit 198
	}
	capture assert "`version'"=="UK" if "`chart'"=="lla"
	if _rc {
		di as error "For chart code " as text "lla" as error ", " as text "UK" as error " is the only valid version"
		exit 198
	}
	capture assert "`version'"=="US" if "`chart'"=="la"
	if _rc {
		di as error "For chart code " as text "la" as error ", " as text "US" as error " is the only valid version"
		exit 198
	}
	capture assert "`version'"=="US" if "`chart'"=="wl"
	if _rc {
		di as error "For chart code " as text "wl" as error ", " as text "US" as error " is the only valid version"
		exit 198
	}
	capture assert "`version'"=="US" if "`chart'"=="wh"
	if _rc {
		di as error "For chart code " as text "wh" as error ", " as text "US" as error " is the only valid version"
		exit 198
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


	if "`forage'"=="1" {
		if "`ageunit'"=="" {
			local ageunit year
		}
		else {
			capture assert "`ageunit'"=="day" | "`ageunit'"=="month" | "`ageunit'"=="year"
			if _rc {
				di as error "The ageunit option must contain the word" as text " day" as error "," /*
				*/as text " month" as error " or" as text " year"
				exit
			}
		}
	}

	
	if "`chart'"=="wh" {
		local lmsfile zwthtus.dta
	}
	else if "`chart'"=="wl" {
		local lmsfile zwtlenius.dta
	}
	else if "`chart'"=="la" {
		local lmsfile zlenageius.dta
	}
	else if "`chart'"=="lla" {
		local lmsfile zllageuk.dta
	}
	else if "`chart'"=="sha" {
		local lmsfile zshtageuk.dta
	}
	else if "`chart'"=="hca" & "`version'"=="UK" {
		local lmsfile zhcageuk.dta
	}
	else if "`chart'"=="hca" & "`version'"=="US" {
		local lmsfile zhcageius.dta
	}
	else if "`chart'"=="ba" & "`version'"=="UK" {
		local lmsfile zbmiageuk.dta
	}	
	else if "`chart'"=="ba" & "`version'"=="US" {
		local lmsfile zbmiageus.dta
	}
	else if "`chart'"=="wa" & "`version'"=="UK" {
		local lmsfile zwtageuk.dta
	}
	else if "`chart'"=="wa" & "`version'"=="US" {
		local lmsfile zwtagecomus.dta
	}
	else if "`chart'"=="ha" & "`version'"=="UK" {
		local lmsfile zhtageuk.dta
	}
	else if "`chart'"=="ha" & "`version'"=="US" {
		local lmsfile zhtageus.dta
	}

	noi findfile `lmsfile'
	local fn "`r(fn)'"


	tempvar xvarfin dif xvarfrac l m s

	foreach x in sex xvar l m s xvar_nx l_nx m_nx s_nx merge {
		capture confirm new var __SVJCKH`x'
		if _rc {
			di as error "__SVJCKH`x' is used by zanthro - rename your variable"
			exit 110
		}
	}

	marksample touse

	quietly { 
		if "`y'" == "str" {
			gen __SVJCKHsex=1 if `gender'=="`male'"
			replace __SVJCKHsex=2 if `gender'=="`female'"
		}
		else {
			gen __SVJCKHsex=1 if `gender'==`male'
			replace __SVJCKHsex=2 if `gender'==`female'
		}
		if "`ageunit'"=="year" {
			gen `xvarfin'=`xvar'*12
		}
		else if "`ageunit'"=="day" {
			gen `xvarfin'=(`xvar'/365.25)*12
		}
		else {
			gen `xvarfin'=`xvar'
		}
		gen __SVJCKHxvar=int(`xvarfin')

		if "`version'"=="US" {
			gen `dif'=`xvarfin'-__SVJCKHxvar
			replace __SVJCKHxvar=__SVJCKHxvar-0.5 if `dif'<0.5
			replace __SVJCKHxvar=__SVJCKHxvar+0.5 if `dif'>=0.5 & `dif'<.

			if "`chart'"=="ha" | "`chart'"=="ba" {
				replace __SVJCKHxvar=24 if `xvarfin'>=24 & `xvarfin'<24.5
				replace __SVJCKHxvar=240 if `xvarfin'==240
			}
			else if "`chart'"=="wa" {
				replace __SVJCKHxvar=0 if `xvarfin'>=0 & `xvarfin'<0.5
				replace __SVJCKHxvar=240 if `xvarfin'==240
			}
			else if "`chart'"=="hca" {
				replace __SVJCKHxvar=0 if `xvarfin'>=0 & `xvarfin'<0.5
				replace __SVJCKHxvar=36 if `xvarfin'==36
			}
			else if "`chart'"=="la" {
				replace __SVJCKHxvar=0 if `xvarfin'>=0 & `xvarfin'<0.5
			}
			else if "`chart'"=="wh" {
				replace __SVJCKHxvar=77 if `xvarfin'>=77 & `xvarfin'<77.5
			}
			else if "`chart'"=="wl" {
				replace __SVJCKHxvar=45 if `xvarfin'>=45 & `xvarfin'<45.5
			}
		}

		sort __SVJCKHsex __SVJCKHxvar
		merge __SVJCKHsex __SVJCKHxvar using "`fn'", _merge(__SVJCKHmerge)
		su __SVJCKHxvar if __SVJCKHmerge~=1, meanonly
		local min=r(min)
		local max=r(max)
		drop if __SVJCKHmerge==2

		gen `xvarfrac' = (`xvarfin'-__SVJCKHxvar)/(__SVJCKHxvar_nx-__SVJCKHxvar) if `xvarfin'<`max' & `touse'

		gen `l' = __SVJCKHl+`xvarfrac'*(__SVJCKHl_nx-__SVJCKHl) if `xvarfin'>=`min' & `xvarfin'<`max' & `touse'
		gen `m' = __SVJCKHm+`xvarfrac'*(__SVJCKHm_nx-__SVJCKHm) if `xvarfin'>=`min' & `xvarfin'<`max' & `touse'
		gen `s' = __SVJCKHs+`xvarfrac'*(__SVJCKHs_nx-__SVJCKHs) if `xvarfin'>=`min' & `xvarfin'<`max' & `touse'
		replace `l' = __SVJCKHl if `xvarfin'==`max' & `touse'
		replace `m' = __SVJCKHm if `xvarfin'==`max' & `touse'
		replace `s' = __SVJCKHs if `xvarfin'==`max' & `touse'
		if "`chart'"=="hca" & "`version'"=="UK" {
			replace `l' = __SVJCKHl if __SVJCKHsex==2 & `xvarfin'==204 & `touse'
			replace `m' = __SVJCKHm if __SVJCKHsex==2 & `xvarfin'==204 & `touse'
			replace `s' = __SVJCKHs if __SVJCKHsex==2 & `xvarfin'==204 & `touse'
		}

		gen `type' `g' = (((`measure'/`m')^`l')-1)/(`l'*`s') if `xvarfin'>=`min' & `xvarfin'<=`max' & `touse'
		replace `g'=. if `measure'<=0
		if "`nocutoff'"=="" {
			replace `g'=. if abs(`g')>=5 & `g'<.
		}

		drop __SVJCKHsex __SVJCKHxvar __SVJCKHl __SVJCKHm __SVJCKHs __SVJCKHxvar_nx /*
		*/ __SVJCKHl_nx __SVJCKHm_nx __SVJCKHs_nx __SVJCKHmerge
	}

	quietly count if `g'<. & `touse'
	if r(N) { 
		local s = cond(r(N)>1,"s","")
		di as text "(Z value`s' generated for " r(N) " case`s') " 
		di as text "(gender was assumed to be coded male=`male', female=`female')"
		if "`forage'"=="1" {
			di as text "(age was assumed to be in `ageunit's)"
		}
	}

	quietly count if `g'==. & `touse'
	if r(N) { 
		if "`nocutoff'"=="" {
			di as text "(Z values can be missing because xvar is nonpositive or otherwise" 
			di as text " out of range for the chart code, the gender variable is missing,"
			di as text " or the Z value has an absolute value >=5)"
		}
		else {
			di as text "(Z values can be missing because xvar is nonpositive or otherwise"
			di as text " out of range for the chart code, or the gender variable is missing)" 
		}
	}

	restore, not

end

program Badsyntax
	di as err "gencode() option invalid: see {help zanthro}"
	exit 198
end
