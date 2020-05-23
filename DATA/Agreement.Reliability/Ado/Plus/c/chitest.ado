*! 1.4.4 NJC 26 January 1999
* 1.4.3  2 Sept 1997
* 1.4.2  13 August 1997
* 1.4.2, 1.4.3 indicate keyboard entry (undocumented option)
* 1.4.1  30 April 1997     save emean in S_7
* 1.4.0  20 December 1996
program def chitest
    version 5.0
    local varlist "min(1) max(2)"
    local if "opt"
    local in "opt"
    local options "NFIT(int 0) KB"
    parse "`*'"
    parse "`varlist'", parse(" ")
    local nvars : word count `varlist'

    tempvar touse obs exp lrchi2
    mark `touse' `if' `in'
    markout `touse' `varlist'

    * degrees of freedom (subtract `nfit')
    qui count if `touse'
    local df = _result(1) - 1 - `nfit'
    if `df' < 1 {
        di in r "too few categories"
        exit 149
    }

    qui {

        gen `obs' = `1'
        su `obs' if `touse', meanonly
        local omean = _result(3)
        local osum = _result(18)
        local omin = _result(5)

        * check observed frequencies
        if `omin' < 0 {
            di in r "observed frequencies must be zero or positive"
            exit 499
        }
        capture assert `obs' == int(`obs') if `touse'
        if _rc == 9 {
            di in r "observed frequencies must be integers"
            exit 499
        }

        if `nvars' == 2 { gen `exp' = `2' }
        else gen `exp' = `omean'

        su `exp' if `touse', meanonly
        local emean = _result(3)
        local esum = _result(18)
        local emin = _result(5)

        * check expected frequencies
        if `emin' <= 0 {
            di in r "expected frequencies must be positive"
            exit 411
        }

        * got to here => we're in business

        preserve
        keep if `touse'
        keep `obs' `exp'
        tempname X2 pvalX2 G2 pvalG2
        gen observed = `obs'
        gen expected = `exp'

        * count cells with < 5 & < 1
        local lowexp = `emin' < 5
        count if exp >= 1 & exp < 5
        local lt5 = _result(1)
        count if exp < 1
        local lt1 = _result(1)

    }

    * print header
    di _n in g "Chi-square test:"
    di in g "    observed frequencies from " _c
    if "`kb'" == "kb" { di in g "keyboard" }
    else  di in g "`1'"
    if `nvars' == 2 {
        di in g "    expected frequencies from " _c
        if "`kb'" == "kb" { di in g "keyboard" }
        else di in g "`2'"
    }
    else di in g "    expected frequencies equal"

    * warn if totals differ by more than 0.01
    if `nvars' == 2 & abs(`osum'-`esum') > 0.01 {
        di _n in r "Warning: totals of `1' and `2' differ"
        di in r _col(15) "total"
        di in r "`1'" _col(12) %8.0g `osum'
        di in r "`2'" _col(12) %8.0g `esum'
    }

    * macros for output if `emin' >= 5
    local outlist "obs exp classic Pearson"
    local nspaces = 35

    * prepare notes and change macros for output if `emin' < 5
    if `lowexp' {
        qui {
            gen str2 notes = "  "
            replace notes = " *" if exp < 5
            replace notes = "**" if exp < 1
            format notes %6s
            local outlist "obs exp notes classic Pearson"
            local nspaces = 43
       }
    }

    * chi-square calculations
    qui {
        gen classic  = obs - exp
        gen Pearson = (obs - exp) / sqrt(exp)
        format exp classic Pearson %10.3f
        gen Pearson2 = Pearson^2
        su Pearson2, meanonly
        local k  = _result(1)
        scalar `X2' = _result(18)
        scalar `pvalX2' = chiprob(`df', `X2')
        gen `lrchi2' = obs * log(obs / exp)
        su `lrchi2', meanonly
        scalar `G2' = 2 * _result(18)
        scalar `pvalG2' = chiprob(`df', `G2')
    }

    * output results
    di _n in g "         Pearson chi2(" in y "`df'"  /*
    */ in g ") = " in y %8.4f `X2' in g "   Pr = "   /*
    */ in y %6.3f `pvalX2'
    di in g "likelihood-ratio chi2(" in y "`df'"     /*
    */ in g ") = " in y %8.4f `G2' in g "   Pr = "   /*
    */ in y %6.3f `pvalG2'
    di _n _dup(`nspaces') " " in g  "residuals" _c
    l `outlist'

    * explain notes if necessary
    if `lt5' | `lt1' { di }
    if `lt5' { di in y " *" in g " 1 <= expected < 5" }
    if `lt1' { di in y "**" in g " 0 <  expected < 1" }

    global S_1 = `k'
    global S_2 = `df'
    global S_3 = `X2'
    global S_4 = `pvalX2'
    global S_5 = `G2'
    global S_6 = `pvalG2'
    global S_7 = `emean'

end
