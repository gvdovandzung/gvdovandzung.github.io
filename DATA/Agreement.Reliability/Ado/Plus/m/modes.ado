program def modes
*! NJC 1.1.2 23 December 1998
* NJC 1.1.1 29 October 1998
        version 5.0
        local varlist "max(1)"
        local if "opt"
        local in "opt"
        local weight "fweight aweight noprefix"
        local options "Min(int 0)"
        parse "`*'"
        tempvar freq touse

        mark `touse' `if' `in'
        markout `touse' `varlist', strok
        sort `touse' `varlist'
        if "`exp'" == "" { local exp = 1 }
        qui by `touse' `varlist' : gen long `freq' = sum(`exp') * `touse'
        qui by `touse' `varlist' : replace `freq' = `freq'[_N]
        label var `freq' "Frequency"
        su `freq', meanonly
        local max = _result(6)

        if `min' > 0 { local which "`freq' >= `min'" }
        else { local which "`freq' == `max'" }
        qui count if `which'
        if _result(1) == 0 {
                di in r "no such modes in data"
                exit 498
        }
        qui tab `varlist' if `which'
        if _result(2) > 1 { local s "s" }
        di _n in g "Mode`s' of `varlist'"
        tabdisp `varlist' if `which', c(`freq')
end



