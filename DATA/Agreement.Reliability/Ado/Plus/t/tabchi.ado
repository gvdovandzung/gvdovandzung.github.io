*! 1.2.3 NJC 21 March 1999
* 1.2.2 NJC 25 January 1999
* 1.2.1 13 January 1998
program define tabchi
        version 5.0
        local varlist "max(2)"
        local if "opt"
        local in "opt"
        local options "Raw Pearson Adjust Cont noO noE *"
        local weight "fweight"
        parse "`*'"
        parse "`varlist'", parse(" ")

        quietly {
                preserve
                tempvar touse obs colsum rowsum fit rawres Pearson adj contr

                if "`exp'" == "" { local exp "= 1" }
                gen `obs' `exp'
                capture assert `obs' == int(`obs') `if' `in'
                if _rc == 9 {
                        di in r "observed frequencies must be integers"
                        exit 499
                }

                mark `touse' `if' `in'
                markout `touse' `varlist', strok
                keep if `touse'

                sort `1' `2'
                by `1' `2': replace `obs' = sum(`obs')
                by `1' `2': replace `obs' = `obs'[_N]
                by `1' `2': keep if _n == _N

                * use WWG Pairwise
                Pairwise `1' `2'

                replace `obs' = 0 if `obs' == .
                sort `2'
                by `2': gen double `colsum' = sum(`obs')
                by `2': replace `colsum' = `colsum'[_N]
                sort `1'
                by `1': gen double `rowsum' = sum(`obs')
                by `1': replace `rowsum' = `rowsum'[_N]
                su `obs', meanonly
                local tabsum = _result(18)

                gen double `fit' = (`rowsum' * `colsum')/`tabsum'
                count if `fit' < 5
                local lt5 = _result(1)
                count if `fit' < 1
                local lt1 = _result(1)
                gen double `rawres' = `obs' - `fit'
                gen double `Pearson' = (`obs' - `fit')/sqrt(`fit')
                gen double `contr' = (`obs' - `fit')^2/(`fit')
                gen double `adj' = `Pearson' / sqrt((1 - `rowsum'/`tabsum') /*
                */ *(1 - `colsum'/`tabsum'))
                noi di
                noi if "`o'" != "noo" {
                        di in g _dup(10) " " "observed frequency"
                }
                noi if "`e'" != "noe" {
                        di in g _dup(10) " " "expected frequency"
                }
                noi if "`raw'" == "raw" {
                        di in g _dup(10) " " "raw residual"
                        local res "`rawres'"
                }
                noi if "`pearson'" == "pearson" {
                        di in g _dup(10) " " "Pearson residual"
                        local res "`res' `Pearson'"
                }
                noi if "`cont'" == "cont" {
                        di in g _dup(10) " " "contribution to chi-square"
                        local res "`res' `contr'"
                }
                noi if "`adjust'" == "adjust" {
                        di in g _dup(10) " " "adjusted residual"
                        local res "`res' `adj'"
                }
                format `rawres' `fit' `Pearson' `adj' `contr' %9.3f
                if "`o'" != "noo" { local show "`obs'" }
                if "`e'" != "noe" { local show "`show' `fit'" }

                noisily {
                        if "`show'`res'" != "" {
                                tabdisp `1' `2', c(`show' `res') `options'
                        }
                        if `lt5' > 1 {
                                di _n in g /*
                                 */ "`lt5' cells with expected frequency < 5"
                        }
                        else if `lt5' == 1 {
                                di _n in g /*
                                 */ "1 cell with expected frequency < 5"
                        }
                        if `lt1' > 1 {
                                di in g /*
                                 */ "`lt1' cells with expected frequency < 1"
                        }
                        else if `lt1' == 1 {
                                di in g "1 cell with expected frequency < 1"
                        }
                }

                tabulate `1' `2' [fw=`obs'], chi2 lrchi2
                local df = (_result(2) - 1) * (_result(3) - 1)
                noi di _n in g _dup(10) " " "Pearson chi2(" in y "`df'" /*
                 */ in g ") = " in y %8.4f _result(4) in g "   Pr = "   /*
                 */ in y %5.3f _result(5)
                noi di in g " likelihood-ratio chi2(" in y "`df'"       /*
                 */ in g ") = " in y %8.4f _result(6) in g "   Pr = "   /*
                 */ in y %5.3f _result(7)
        }
end

*! version 1.0.0  WWG 31 jan 1997
program define Pairwise /* varname1 varname2 [if] [in] */
        version 5.0
        local varlist "req ex min(2) max(2)"
        local if "opt"
        local in "opt"
        parse "`*'"
        parse "`varlist'", parse(" ")

        tempfile one

        quietly {
                count `if' `in'
                if _N==0 {
                        exit
                }
                if "`if'"!="" | "`in'"!="" {
                        local keep "keep `if' `in'"
                }
                preserve
                `keep'
                keep `1'
                sort `1'
                by `1': keep if _n==1
                save "`one'"

                restore, preserve
                `keep'
                keep `2'
                sort `2'
                by `2': keep if _n==1

                cross using `one'
                sort `1' `2'
                save "`one'", replace

                restore, preserve
                sort `1' `2'
                merge `1' `2' using "`one'"
                drop _merge
        }
        restore, not
end
