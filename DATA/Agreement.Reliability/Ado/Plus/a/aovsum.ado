*! Version 1.0        (STB-54: sg132)
program define aovsum
*!  One-way ANOVA from summary statistics
*!  Syntax:  . aovsum, n(n's) mean(means) <se(SE's) | sd(SD's)>
*!                      [ keep names(y [c [f]]) oneway_options ]
*!  Version 1.1.1 <JRG; 27Sep1999>
*   John R. Gleason (loesljrg@accucom.net)

   version 6.0
   if "`1'" == "?" {
      which aovsum
      exit
   }

   syntax , N(numlist >0 integer) Mean(numlist)    /*
      */    [ Keep NAMes(string) SD(numlist >=0) SE(numlist >=0) * ]

   if "`sd'`se'" == "" {
      di in red "Either sd() or se() must be provided"
      error 499
   }
   local V "se"
   if "`se'" == "" { local V "sd" }

   local nCell : word count `n'
   if `nCell' < 2 {
      di in red "#(cells) < 2"
      error 499
   }
   local i : word count `mean'
   local j : word count ``V''
   if !(`i'==`nCell' & `j'==`nCell') {
      di in red "n(), mean(), and `V'() don't have the same" /*
         */ " number of entries"
      error 499
   }

   local N1 = _N
   local N2 = 2 * `nCell'
   if `N1' < `N2' { qui set obs `N2' }

   tempvar Nx Xx Cx
   tempname S X
   qui {
      gen int `Nx' = .
      gen double `Xx' = .
      gen int `Cx' = .
      local i 0
      while `i' < `nCell' {
         local i = `i' + 1
         local j = `i' + `nCell'
         replace `Cx' = `i' in `i'
         replace `Cx' = `i' in `j'
         local t : word `i' of `n'
         replace `Nx' = `t' - 1 in `i'
         replace `Nx' = 1 in `j'
         local T : word `i' of ``V''
         scalar `S' = `T'
         if "`se'" == "" { scalar `S' = `S' / sqrt(`t') }
         local t : word `i' of `mean'
         scalar `X' = `t'
         replace `Xx' = `X' + `S' in `i'
         replace `Xx' = `X' - `Nx'[`i']*`S' in `j'
      }
   }
   lab var `Xx' "Response variable"
   lab var `Cx' "Groups (cells)"
   oneway `Xx' `Cx' [fw = `Nx'], `options' nofreq

   if "`keep'" != "" {
      tokenize `names'
      local t = cond("`1'" != "", "`1'", "y_")
      rename `Xx' `t'
      local t = cond("`2'" != "", "`2'", "cond_")
      rename `Cx' `t'
      local t = cond("`3'" != "", "`3'", "freq_")
      rename `Nx' `t'
      lab var `t' "Frequency (n/cell)"
   }
   else if `N1' & `N1' < _N { qui keep in 1/`N1' }
end
