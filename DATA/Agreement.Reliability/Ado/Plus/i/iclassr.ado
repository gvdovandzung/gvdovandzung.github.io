*! version 1.1.1   STB-35 sg65
program define iclassr
   version 4.0
   local varlist "req ex min(2) max(2)"
   local if      "opt"
   local in      "opt"
   local weight  "aweight"
   local options "Center(string) Ems NOIsily"
   parse "`*'"
   parse "`varlist'", parse(" ")
   local weight "[`weight'`exp']"
   local wt : word 2 of `exp'

   tempvar use
   quietly {
      mark `use' `if' `in'
      markout `use' `varlist' `wt'
   }
   tempname gr df fm
   if "`ems'" != "" {
      preserve
      qui keep if `use'
      sort `2'
      if "`wt'" == "" {
         tempvar Wt
         qui gen byte `Wt' = 1
         local wt "`Wt'"
      }
      tempvar sw
      qui by `2': gen double `sw' = sum(`wt')
      qui summ `sw' if `2' < `2'[_n+1]
      scalar `df' = _result(1) - 1
      scalar `gr' = _result(1) * _result(3)
      scalar `gr' = (`gr' - _result(3) - _result(4)*`df'/`gr')/`df'
      capture `noisily' oneway `1' `2' `weight'
   }
   else {
      capture `noisily' oneway `1' `2' `weight' if `use'
      scalar `gr' = _result(1)/ (_result(3) + 1)
   }
   if _rc == 134 { error(134) }
   scalar `df' = 1
   if "`center'" == "mean" { scalar `df' = _result(5)/(_result(5)-2) }
   else if "`center'" == "med" {
      scalar `df' = invfprob(_result(3), _result(5), 0.5)
   }
   scalar `fm' = max(_result(6) - `df', 0)
   global S_1 = `fm' / (`fm' + `df'* `gr')
   global S_2 = `fm' / (`fm' + `df')
   di _new in gr "Intra-`2' r =" in ye %7.4f $S_1  _new in gr  /*
      */ "Estimated reliability of a `2' mean (n=" in ye %3.2f `gr' in gr  /*
      */ ") =" in ye %7.4f $S_2
end
