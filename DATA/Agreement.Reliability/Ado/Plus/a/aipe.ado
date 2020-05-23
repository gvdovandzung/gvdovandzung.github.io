program define aipe
version 9.2

syntax , w(real) p(integer) r2(real) r2xx(real) [ alpha(real .05) quan(real .8) help]

local z = invnormal(1-`alpha'/2)

local N = (`z'/`w')^2*(1-`r2')/(1-`r2xx')+`p'+1
local N = ceil(`N')
display
display as txt "Accuracy in Parameter Estimation"
display as txt "p     = `p'    -- number of predictor variables in full model"
display as txt "alpha =  `alpha' -- alpha level for confidence interval"
display as txt "w     =  `w' -- confidence interval half-width"
display as txt "R2    =  `r2' -- R-squared for full model"
display as txt "R2xx  =  `r2xx' -- R-squared for target predictor with other predictors"
display as txt "quan  =  `quan'" "  -- quantile of chi-square distribution"
 
display
display as txt "AIPE sample size"
display as txt "N  = " as res `N' as txt " -- n needed for CI half-width of w = `w', 50% of time


 local chi2 = invchi2(`N'-1,`quan')
 local percent = 100*`quan'
 local Nm = (`z'/`w')^2*(1-`r2')/(1-`r2xx')*`chi2'/(`N'-`p'-1)+`p'+1
 local Nm = ceil(`Nm')
 display as txt "Nm = " as res `Nm' as txt " -- n needed for CI half-width of w = `w', 100*(quan)% = 100*(`quan')% = `percent'% of time"

end
