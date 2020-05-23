*! sdpair.ado 1.00 by PTS (p.seed@umds.ac.uk)  (STB-55: sbe33)
*! Based on Pitman (1939) Biometrika 31: 9
*! as in Snedecor & Cochran (1967) "Statistical methods (6th ed)" (Iowas State UP)

prog define sdpair

	version 5.0
	local varlist " req ex min(2) max(2)"
	local if "opt"
	local in "opt"
	local weight "fweight aweight"
	local options "format(string) Level(real 100)"
	parse "`*'"

	tempvar touse sum diff
	mark `touse' `if' `in'
	markout `touse' `varlist'
	if "`format'" == "" { local format "%6.4f" }
	if `level' == 100 { local level = $S_level }
	if `level' > 1 { local level = `level' /100 }

	parse "`varlist'", parse(" ")
	
	qui summ `1' if `touse' [`weight'`exp']
	tempname var1 n df var2 F r t p K lcb ucb 
	scalar `var1' = _result(4)
	scalar `n' = _result(2)
	scalar `df' = `n' - 2

	qui summ `2' if `touse' [`weight'`exp']

	scalar `var2' = _result(4)

	scalar `F' = `var1'/`var2' 

	qui corr `varlist' if `touse' [`weight'`exp']
	scalar `r' = _result(4)

	scalar `t' = ((`F'-1)/2)*( (`df')/ ((1-`r'*`r')*`F') )^.5

* Note: under the null hypothesis, phi = 1
*	di "t = |" `t' "|"

	scalar `p' = tprob(`df', `t')


	scalar `K' = 1 + 2*(1-`r'*`r')*invt(`df', `level')^2/(`df')

	scalar `lcb' = `F' * (`K' - (`K'*`K'-1)^.5)

	scalar `ucb' = `F' * (`K' + (`K'*`K'-1)^.5)

	local label1 : variable label `1' 
	if "`label1'" == "" {local label1 `1' }
	local label2 : variable label `2' 
	if "`label2'" == "" {local label2 `2' }


	zap_s
	global S_1 = `n'
	global S_2 = `t'
	global S_3 = `df'
	global S_4 = `p'
	global S_5 = `F'^.5
	global S_6 = `lcb'^.5
	global S_7 = `ucb'^.5



	di in gr _n(2) "Pitman's variance ratio test between `label1' and `label2': "
	di in gr _n "Ratio of Standard deviations = " in ye `format' `F'^.5,  " 
	di in gr 100*`level' "% Confidence Interval " in ye `format' `lcb'^.5 in gr " to " in ye `format' `ucb'^.5
	di in gr "t = " in ye %6.3f `t' in gr ", df = " in ye `df' in gr ", p = " in ye %6.3f `p'

end vartest
