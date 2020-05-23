program def tabsplit
*! NJC 1.2.1 1 March 1999
* NJC 1.1.0 11 August 1998
* NJC 1.0.0 29 July 1998
    version 5.0
    local varlist "max(1)"
    local if "opt"
    local in "opt"
    local options "Punct(str) Sort Header(str) Generate(str) GMAX(str) SAving(str)"
    parse "`*'"

    if "`punct'" == "" { local punct " " }

    confirm string variable `varlist'

    if "`gmax'" != "" {
        confirm integer number `gmax'
        if `gmax' < 1 {
            di in r "gmax( ) should be positive integer"
            exit 198
        }
    }

    tempvar data newdata touse id nwords wordno word orig

    qui {
        gen str1 `data' = ""
        replace `data' = trim(`varlist') `if' `in'

        if "`punct'" == "no" {
            compress `data'
            local vartype: type `data'
            local len = substr("`vartype'",4,.)
            gen str1 `newdata' = ""

            local i = 1
            while `i' < `len' {
                replace `newdata' = /*
                 */ `newdata' + substr(`data',`i',1) + " "
                local i = `i' + 1
            }
            replace `data' = trim(`newdata' + substr(`data',`len',1))
            local punct " "
        }

        gen str1 `word' = ""
        gen int `nwords' = .

        mark `touse' `if' `in'
        markout `touse' `data', strok
        sort `touse'
        count if !`touse'
        local notuse = _result(1)
        gen long `id' = _n
    }

    local i = 1 + `notuse'
    while `i' <= _N {
        local val = `data'[`i']
        if "`punct'" == " " { local j : word count `val' }
        else {
            local j 0
            parse "`val'", parse("`punct'")
            while "`1'" != "" {
                if index("`punct'","`1'") == 0 { local j = `j' + 1 }
                mac shift
            }
        }
        qui replace `nwords' = `j' in `i'
        local i = `i' + 1
    }

    qui nobreak {

        local N = _N
        expand `nwords'
        gen byte `orig' = _n <= `N'
        sort `touse' `id'
        by `touse' `id' : gen `wordno' = _n if `touse'

        if "`generat'" != "" {
            su `nwords', meanonly
            local max = _result(6)
            if "`gmax'" != "" { local max = min(`max',`gmax') }
            local j = 1
            while `j' <= `max' {
                confirm new variable `generat'`j'
                local j = `j' + 1
            }
            local j = 1
            while `j' <= `max' {
                gen str1 `generat'`j' = ""
                local j = `j' + 1
            }
        }

        local i = 1 + `notuse'
        while `i' <= _N {
            local val = `data'[`i']
            local w = `nwords'[`i']
            if "`punct'" == " " {
                local j = 1
                local l = `i'
                while `j' <= `w' {
                    local k : word `j' of `val'
                    replace `word' = "`k'" in `i'
                    if "`generat'" != ""  {
                        if `j' <= `max' {
                            replace `generat'`j' = "`k'" in `l'
                        }
                    }
                    local i = `i' + 1
                    local j = `j' + 1
                }
            }
            else {
                parse "`val'", parse("`punct'")
                local j = 1
                local l = `i'
                while `j' <= `w' & "`1'" != "" {
                    if index("`punct'","`1'") == 0 {
                        replace `word' = trim("`1'") in `i'
                        if "`generat'" != "" {
                            if `j' <= `max' {
                                replace `generat'`j' = "`k'" in `l'
                            }
                        }
                        local i = `i' + 1
                        local j = `j' + 1
                    }
                    mac shift
                }
            }
        }

        if "`header'" == "" { local header "Parts" }
        label var `word' "`header'"
        noi tab`sort' `word'

        if "`saving'" != "" {
                capture confirm new variable _part
                if _rc {
                        di in r "_part already exists"
                        keep if `orig'
                        exit 198
                }
                else {
                        capture confirm new variable _orig
                        if _rc {
                                di in r "_orig already exists"
                                keep if `orig'
                                exit 198
                        }
                        else {
                                gen byte _orig = `orig'
                                gen str1 _part = ""
                                replace _part = `word'
                       }
                       save "`saving'"
                }
        }
        else keep if `orig'

    }

    if "`generat'" != "" { global S_1 = `max' }
end
