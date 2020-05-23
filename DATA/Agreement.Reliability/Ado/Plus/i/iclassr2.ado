*! version 1.1.1      STB-35 sg65
program define iclassr2
   version 4.0
   local varlist "req ex min(2) max(2)"
   local if      "opt"
   local in      "opt"
   local options "Center(string)"
   parse "`*'"
   parse "`varlist'", parse(" ")
   local weight "[`weight'`exp']"

   tempvar use
   quietly {
      mark `use' `if' `in'
      markout `use' `varlist'

      tempname m k f
      tempvar tt
      gen `tt' = `1' + `2' if `use'
      summ `tt'    /*  `weight'  */
      if !_result(1) { error 2000 }
      scalar `k' = _result(1)
      scalar `f' = _result(4)
      replace `tt' = `1' - `2' if `use'
      summ `tt'      /* `weight' */
      scalar `f' = `f'/((`k'-1)*_result(4)/`k' + _result(3)*_result(3))
      scalar `m' = 1
      if "`center'" == "mean" { scalar `m' = `k'/(`k'-2) }
      else if "`center'" == "med" {
         scalar `m' = invfprob(`k'-1, `k', 0.5)
      }
      global S_1 = (`f' - `m') / (`f' + `m')
      global S_2 = (`f' - `m') / `f'
   }
   di _new in gr "Intra-class r =" in ye %7.4f $S_1 in gr   /*
      */ "     Number of classes =", in ye `k' _new in gr  /*
      */ "Estimated reliability of a class mean (n=2) =" in ye %7.4f $S_2
end
