*! version 1.0.0  09aug1995  for StataQuest

program define sqswreg
	version 5.0

	if "`*'"=="" | substr("`*'",1,1)=="," {
		if "$S_E_cmd"=="regress" {
			regress `*'
			exit
		}
	}

	_sqswzap
	capture noisily _sqswdo `*'
	local rc = _rc 
	_sqswzap
	exit `rc'
end

program define _sqswzap
	local i 1
	global SQSWdv		/* dependent variable   */
	global SQSWin		/* currently in		*/
	global SQSWout		/* currently out	*/
	global SQSWtu		/* touse		*/

	global SQSWpr
	global SQSWpe

	global SQSWrm
	global SQSWad
end
	

program define _sqswdo
	local varlist "req ex min(3)"
	local if "opt"
	local in "opt"
	local options "FORWard STEPwise PE(real .2) PR(real .4) Level(integer $S_level)"
	parse "`*'"

	if `pe'>=`pr' & "`stepwis'"!=""  {
		di in red "pe(`pe') >= pr(`pr') invalid"
		exit 198
	}
	if `level'<10 | `level'>99 {
		local level 95
	}

	tempvar touse
	mark `touse' `if' `in'
	markout `touse' `varlist'

	parse "`varlist'", parse(" ")
	global SQSWdv "`1'"
	mac shift
	global SQSWin "`*'"

	qui regress $SQSWdv $SQSWin if `touse'
	if _result(1)==0 | _result(1)==. { 
		error 2000
	}

	global SQSWpr `pr'
	global SQSWpe `pe'
	global SQSWtu "`touse'"

	global SQSWrm 1
	global SQSWad 1

	if "`forward'"=="" {
		di in gr _col(22) "start with full model"
		if "`stepwis'"=="" {
			while $SQSWrm {		/* backwards	*/
				_sqswrm
			}
		}
		else {
			_sqswrm			/* backwards stepwise */
			if $SQSWrm {
				_sqswrm
				global SQSWad 0
				while $SQSWrm | $SQSWad {
					_sqswad
					_sqswrm
				}
			}
		}
	}
	else {
		di in gr _col(22) "start with empty model"
		global SQSWout "$SQSWin"
		global SQSWin
		qui regress $SQSWdv if `touse'
		if "`stepwis'"=="" {
			while $SQSWad {		/* forwards 	*/
				_sqswad
			}
		}
		else {
			_sqswad			/* forwards stepwise */
			if $SQSWad {
				_sqswad
				global SQSWrm 0
				while $SQSWad | $SQSWrm {
					_sqswrm
					_sqswad
				}
			}
		}
	}
	regress, level(`level')
end


program define _sqswrm
	parse "$SQSWin", parse(" ")
	if "`1'" == "" {
		global SQSWrm 0
		exit
	}
	local i 1
	local p -1
	while "``i''" != "" {
		qui test ``i''
		if fprob(_result(3),_result(5),_result(6)) > `p' {
			local p = fprob(_result(3),_result(5),_result(6))
			local vn `i'
		}
		local i=`i'+1
	}
	if `p' > $SQSWpr {
		di in gr "remove" _col(10) in ye "``vn''" /*
		*/ _col(22) in gr "p = " in ye %6.4f `p' /*
		*/ in gr " >  " %6.4f $SQSWpr
		global SQSWout "$SQSWout ``vn''"
		local `vn' " "
		parse "`*'", parse(" ")
		global SQSWin "`*'"
		qui regress $SQSWdv $SQSWin if $SQSWtu
		global SQSWrm 1
	}
	else	global SQSWrm 0
end

program define _sqswad
	parse "$SQSWout", parse(" ")
	if "`1'" == "" {
		global SQSWad 0
		exit
	}
	local i 1
	local p 2
	while "``i''" != "" {
		qui regress $SQSWdv $SQSWin ``i'' if $SQSWtu
		qui test ``i''
		if fprob(_result(3),_result(5),_result(6)) < `p' {
			local p = fprob(_result(3),_result(5),_result(6))
			local vn `i'
		}
		local i=`i'+1
	}
	if `p' <= $SQSWpe {
		di in gr "add" _col(10) in ye "``vn''" /*
		*/ _col(22) in gr "p = " in ye %6.4f `p' /*
		*/ in gr " <= " %6.4f $SQSWpe
		global SQSWin "$SQSWin ``vn''"
		local `vn' " "
		parse "`*'", parse(" ")
		global SQSWout "`*'"
		global SQSWad 1
	}
	else	global SQSWad 0
	qui regress $SQSWdv $SQSWin if $SQSWtu
end

exit

sqswreg depvar rhsvars, FORWard STEPwise pe() pr()


sqswreg depvar rhsvars                      backwards
sqswreg depvar rhsvars, step back           backwards stepwise
sqswreg depvar rhsvars, forward             means forward selection
                        


step back
forw



Organization:

SQSWin	varlist currently in the model 
SQSWout	varlist currently out of the model


----+----1----+----2----+----3----+----4----+----5----+----6----+----7----+----8
add      weight      p = .xxxx <= .xxxx
remove   weight      p = .xxxx >  .xxxx
