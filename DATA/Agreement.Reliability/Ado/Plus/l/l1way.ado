*! version 1.1.1   STB-35 sg65
program define l1way
   version 4.0
   local varlist "req ex min(2) max(2)"
   local if      "opt"
   local in      "opt"
   local weight  "aweight"
   local options "Center(string) Ems"
   parse "`*'"
   parse "`varlist'", parse(" ")
   local weight "[`weight'`exp']"
   local wt : word 2 of `exp'

   tempvar use
   quietly {
      mark `use' `if' `in'
      markout `use' `varlist' `wt'

      preserve
      keep if `use'
      sort `2'
      if "`wt'" == "" {
         tempvar Wt
         gen byte `Wt' = 1
         local wt "`Wt'"
      }
      summ `1' `weight'
      tempname dft sst msa mse gr
      scalar S_1 = _result(1)
      scalar `dft' = _result(1) - 1
      scalar `sst' = `dft' * _result(4)
      tempvar tt sw xm
      gen double `sw' = `wt' in 1     /* sum the weights */
      replace `sw' = cond(`2' >  `2'[_n-1], `wt', `sw'[_n-1] + `wt') in 2/l
      gen double `xm' = `1' in 1      /* get group means */
      replace `xm' = cond(`2' > `2'[_n-1], `1',    /*
            */       `xm'[_n-1] + `wt'*(`1'-`xm'[_n-1])/`sw') in 2/l
      drop if `2' >= `2'[_n+1] in 1/-2

      summ `xm' [aw=`sw']
      scalar S_3 = _result(1) - 1
      scalar `msa' = _result(4) * scalar(S_1) / _result(1)
      scalar S_2 = scalar(S_3) * `msa'
      if "`ems'" != "" {
         replace `sw' = sum(`sw'*`sw')
         scalar `gr' = (_result(2) - `sw'[_N]/_result(2) )/ scalar(S_3)
      }
      else { scalar `gr' = scalar(S_1)/_result(1) }
   }
   scalar S_4 = `sst' - scalar(S_2)
   scalar S_5 = `dft' - scalar(S_3)
   scalar `mse' = scalar(S_4) / scalar(S_5)
   scalar S_6 = `msa' / `mse'

   local lab : variable label `1'
   local lbl /*
   */ "One Way Analysis of Variance for `1': `lab'"
   local indent = int((80-length("`lbl'"))/2)
   noisily di _n _skip(`indent') in gr "`lbl'"
   noisily di _n in gr /*
      */ _col(5) "Source" _col(25) "SS" /*
      */ _col(36) "df" _col(44) "MS" /*
      */ _col(58) "F" _col(64) "Prob > F" /*
      */ _n _dup(72) "-"
   noisily di in gr "Between `2'" in yellow /*
      */ _col(21) %10.0g scalar(S_2) /*
      */ _col(32) %6.0f scalar(S_3)  /*
      */ _col(41) %10.0g `msa' /*
      */ _col(52) %9.2f scalar(S_6) /*
      */ _col(66) %6.4f fprob(scalar(S_3), scalar(S_5), scalar(S_6))
   noisily di in gr "Within `2'" in yellow /*
      */ _col(21) %10.0g scalar(S_4) /*
      */ _col(32) %6.0f scalar(S_5) /*
      */ _col(41) %10.0g `mse' /*
      */ _n in gr _dup(72) "-"
   noisily di in gr "Total" in yellow /*
      */ _col(21) %10.0g `sst' /*
      */ _col(32) %6.0f `dft' /*
      */ _col(41) %10.0g `sst'/`dft'

   scalar `sst' = 1
   if "`center'" == "mean" { scalar `sst' = scalar(S_5)/(scalar(S_5)-2) }
   else if "`center'" == "med" {
      scalar `sst' = invfprob(scalar(S_3), scalar(S_5), 0.5)
   }
   scalar `dft' = max(scalar(S_6) - `sst', 0)
   global S_1 = `dft' / (`dft' + `sst'* `gr')
   global S_2 = `dft' / (`dft' + `sst')
   di _new in gr "Intra-`2' r =" in ye %7.4f $S_1  _new in gr  /*
      */ "Estimated reliability of a `2' mean (n=" in ye %3.2f `gr' in gr  /*
      */ ") =" in ye %7.4f $S_2
end
