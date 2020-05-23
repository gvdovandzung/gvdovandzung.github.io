* !galbr.ado version 1.15, June/October 1997  STB-41 sbe20
* Aurelio Tobias
* Glabraith plot to assess heterogeneity in meta-analysis

program define galbr
    version 3.0
    local varlist "req ex min(2)"
    local if "opt"
    local in "opt"
    local options "`options' id(string) *"
    parse "`*'"
    parse "`varlist'", parse(" ")
    local E  `1'
    local SE `2'

    preserve

    if "`id'"=="" {
       local id "O"
    } 
    else {
        local id "[`id']"
    }

    tempvar x y p ulp llp
    quietly gen `x'=1/`SE' `if' `in'
    label var `x' "1/se"
    quietly gen `y'=`E'/`SE' `if' `in'
    label var `y' "b/se"

    quietly regress `y' `x', noconstant
    quietly predict `p' 
    quietly gen `llp'=`p'-2 
    quietly gen `ulp'=`p'+2 

    quietly summ `x' 
    local mxx=_result(6)
    quietly summ `llp' 
    if _result(5)>=-2 {
       local mny=-2
    } 
    else {
       local mny=_result(5)
    }
    quietly summ `ulp' `if' `in'
    if _result(6)<=2 {
       local mxy=2
    } 
    else {
       local mxy=_result(6)
    }

    local new=_N+1
    quietly set obs `new'
    quietly replace `y'=0 in l
    quietly replace `x'=0 in l
    quietly replace `p'=0 in l
    quietly replace `llp'=-2 in l
    quietly replace `ulp'=2 in l 

    graph `y' `p' `ulp' `llp' `x', ylab(`mny',-2,0,2,`mxy') /* 
       */ xscale(0,`mxx') pen(1922) sy(`id'iii) c(.lll) `options' 

end
