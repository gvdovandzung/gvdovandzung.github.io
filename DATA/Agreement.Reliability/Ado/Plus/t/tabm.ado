*! 1.2.0 NJC 5 February 1999
* 1.0.0 NJC 22 December 1998
program define tabm
        version 6
        syntax varlist(min=2) [if] [in] [fw aw iw] [, TRans Vallbl(string) *]
        tokenize `varlist'

        if "`exp'" != "" {
                tempvar wt
                gen `wt' `exp'
                local w "[`weight' = `wt']"
        }

        capture confirm string variable `1'
        local strOK = _rc == 0

        local nvars : word count `varlist'
        local i = 1
        local j = 1

        while `i' <= `nvars' {
                capture confirm string variable ``i''
                if `strOK' {
                        if _rc { local badlist "`badlist'``i'' " }
                        else {
                                local OKlist "`OKlist'``i'' "
                                local slist "`slist'``i'' `wt' "
                                local lbl`j' : variable label ``i''
                                if "`lbl`j''" == "" { local lbl`j' "``i''" }
                                local j = `j' + 1
                        }
                }
                else {
                        if _rc {
                                local OKlist "`OKlist'``i'' "
                                local slist "`slist'``i'' `wt' "
                                local lbl`j' : variable label ``i''
                                if "`lbl`j''" == "" { local lbl`j' "``i''" }
                                local j = `j' + 1
                        }
                        else  local badlist "`badlist'``i'' "
                }
                local i = `i' + 1
        }

        if "`badlist'" != "" { di in bl "`badlist'different type, so excluded" }

        local nvars : word count `OKlist'
        if `nvars' == 1  { /* normal tabulation, no need to stack */
                tab `OKlist' `w', `options'
                exit 0
        }

        if "`vallbl'" == "" {
                local 1 : word 1 of `slist'
                local vallbl : value label `1'
        }
        if "`vallbl'" != "" { /* insurance policy */
                tempfile flabels
                qui label save `vallbl' using `flabels'
        }

        preserve
        tempvar data
        stack `slist' `if' `in', into(`data' `wt') clear
        label var _stack "Variable"
        label var `data' "Values"
        local i = 1
        while `i' <= `nvars' {
                label def _stack `i' "`lbl`i''", add
                local i = `i' + 1
        }
        label val _stack _stack

        if "`vallbl'" != "" {
                if `strOK' { di in bl "may not label strings" }
                else {
                        capture label list `vallbl'
                        if _rc { run `flabels' }
                        label val `data' `vallbl'
                }
        }

        if "`trans'" == "" { tab _stack `data' `w', `options' }
        else tab `data' _stack `w' , `options'
end
