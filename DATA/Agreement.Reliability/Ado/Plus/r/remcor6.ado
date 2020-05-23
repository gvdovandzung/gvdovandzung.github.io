*! version 1.0.0  (STB-53: sg129)
program define remcor6
	version 6.0
	* takes b and transform set of r.effs at same level using choleski
	* returns bi where the r.effs are independent and correlation equations
	* have been removed
	* also takes exponential of sd parameters
	* and evaluates contributions to linear predictor that don't change
	args b

	tempname b2 s1 cov t r d dd u denom mean mzps
	tempvar junk
	gen double `junk'=0

	disp  "*********in remcor:"

	/* fixed effects $HG_xb1, $HG_xb2 etc. (tempnames stored in global macros-list) */
	disp "fixed parameters: "
	matrix list `b'
     	matrix `b2' = `b'
	local nffold=0
	local ff = 1
	local nxt = 1
	while(`ff' <= $HG_tpff){
		matrix `b2' = `b2'[1, `nxt'...]
		local np = M_nffc[1, `ff'] - `nffold'
		disp "np = " `np'
		local nxt = `np' + 1
		local nffold = M_nffc[1,`ff']
		matrix `s1' = `b2'[1,1..`np']
		matrix list `s1'
		disp "tempname: ${HG_xb`ff'}"
		matrix score double ${HG_xb`ff'} = `s1' /* nontemp */
		disp ${HG_xb`ff'}[$which]
		local ff=`ff'+1
	}
	if "$HG_off"~=""{qui replace $HG_xb1=$HG_xb1+$HG_off}
	disp "HG_xb1 = " $HG_xb1[$which]

	/* random effects */
/* level 1 */
	local np = M_nbrf[1,1]
	if `np'>0{
		matrix `b2' = `b2'[1, `nxt'...]
		local nxt = 1
		matrix `s1' = `b2'[1,1..`np']
		matrix list `s1'
		matrix score double $HG_s1 = `s1'
		qui replace $HG_s1=exp($HG_s1)
		disp "s1 = " $HG_s1[$which]
		local nxt = `nxt' + `np'
	}
	local lev = 2
	local rf = 2
	local nrfold = M_nrfc[2,1]
	
/* MASS POINTS */
if($HG_free){
	while(`lev'<=$HG_tplv&`rf'<=$HG_tprf){
		local j1 = M_nrfc[2, `lev']
		local nrf = `j1' - `nrfold'
		local nip = M_nip[1, `lev']
		scalar `denom' = 1 /* =exp(0) */
		matrix M_zps`lev' = J(1,`nip',`denom')
		local k = 1
		disp "`nip' integration points at level `lev'"
		while `k' < `nip' {
			local j = `nrfold'+1
			while `j'<=`j1'{
				disp "level `lev', class `k' and random effect `j'"
				disp " nxt = " `nxt'
				matrix `b2' = `b2'[1, `nxt'...]
				matrix list `b2'
				local nxt = 1
				if `k'==1{
					/* linear predictors come before first masspoint */
					local np = M_nbrf[1,`j']-1
					if `np'>0 {
						disp "extracting coefficients for r.eff"
						matrix `s1' = `b2'[1,1..`np']
						matrix score double ${HG_s`j'} = `s1'
						disp "HG_s" `j' " = " ${HG_s`j'}[$which]
						local nxt = `nxt' + `np'
					}
					/* first coeff fixed at one */
					matrix `s1' = (1)
					local lab: colnames `b2'
					local lab: word `nxt' of `lab'
					matrix colnames `s1'=`lab'
					matrix list `s1'
					capture drop `junk'
					matrix score double `junk' = `s1'
					if `np'>0{
						qui replace ${HG_s`j'}=${HG_s`j'}+`junk'
					}
					else{
						qui gen double ${HG_s`j'}=`junk'
					}
					matrix list `s1'
					disp "HG_s" `j' " = " ${HG_s`j'}[$which]
					disp "making M_zlc`j'"
					matrix M_zlc`j' = J(1,`nip',0)
				}
				matrix M_zlc`j'[1,`k'] = `b2'[1,`nxt']
				local nxt = `nxt' + 1
				local j = `j' + 1
			}
			scalar `mzps' = exp(`b2'[1,`nxt'])
			if `mzps' == . {
				global HG_error=1
				exit
			}
			matrix M_zps`lev'[1,`k'] = `mzps'
			local nxt = `nxt' + 1
			scalar `denom' = `denom' + M_zps`lev'[1,`k']
			local k = `k' + 1
		}

		local k = 1
		while `k' <= `nip'{
			scalar `mzps' = M_zps`lev'[1,`k']
			matrix M_zps`lev'[1,`k'] = `mzps'/`denom'
			local k = `k' + 1
		}
		local j = `nrfold' + 1
		while `j' <= `j1'{ /* subtract the mean */
			matrix `mean' = M_zps`lev'*M_zlc`j'' /* mean of all but last point */
			scalar `mzps' = M_zps`lev'[1,`nip']
			matrix M_zlc`j'[1,`nip'] = -`mean'[1,1]/`mzps'
			disp "M_zlc`j'"
			matrix list M_zlc`j'
			local j = `j' + 1
		}
		disp "M_zpz`lev'"
		matrix list M_zps`lev'
		local nrfold = `j1'
		local lev = `lev' + 1
	}
}/*endinf HG_free */
else{
/* ST. DEVS */
	disp "random parameters: "
	while(`lev'<=$HG_tplv&`rf'<=$HG_tprf){
		local np = M_nbrf[1,`rf']
		disp "np = " `np'
		local nrf = M_nrfc[2, `lev'] - `nrfold'
		matrix `t' = J(`nrf',`nrf',0)
		local i = 1
		while (`i' <= `nrf'){ 
			disp " nxt = " `nxt'
			matrix `b2' = `b2'[1, `nxt'...]
			local nxt = 1
			matrix list `b2'
			local np = M_nbrf[1, `rf'] - 1
			if `np'>0{
				disp `np' " loadings at random effect " `rf' ", level " `lev'
				matrix `s1' = `b2'[1,1..`np']
				matrix list `s1'
				matrix score double ${HG_s`rf'} = `s1'
				disp "s" `rf' " = " ${HG_s`rf'}[$which]
				local nxt = `nxt' + `np'
			}
			/* first (single non-) loading fixed at one, label in st. dev */
			matrix `s1' = (1)
			local lab: colnames `b2'
			local lab: word `nxt' of `lab'
			matrix colnames `s1' = `lab'
			capture drop `junk'
			matrix score double `junk' = `s1'
			if `np'>0{
				qui replace ${HG_s`rf'} = ${HG_s`rf'} + `junk'
			}
			else{
				matrix score double ${HG_s`rf'} = `s1'
			}

			* extract standard deviation
			matrix `t'[`i',`i'] = `b2'[1, `nxt']
			local nxt = `nxt' + 1
			local i = `i' + 1
			local rf = `rf' + 1
		}
		if (`nrf'>1&$HG_cor==1){ /* deal with correlations */
			/* extract correlation parameters */
			local i = 2
			while (`i' <= `nrf'){	
				local j = 1
				while (`j' < `i'){
					disp "i = " `i' " j = " `j' " nxt = " `nxt'
					matrix `t'[`i',`j'] = `b2'[1,`nxt']
					local j = `j' + 1
					local nxt = `nxt' + 1
				}
				local i = `i' + 1
			}
		}
		matrix list `t'
		matrix M_chol = `t'
		local i = 1
		while (`i'<=`nrf'){
			local k = `i' + `nrfold'
			qui replace `junk'=0
			local j = `i'
			disp "making s`k'"
			while `j'<=`nrf'{
				local l = `j' + `nrfold'
				qui replace `junk' = `junk' + `t'[`j',`i']*${HG_s`l'}
				disp "     adding t[`j',`i']s`l'"
				local j = `j' + 1
			}
			qui replace ${HG_s`k'}=`junk'
			disp "s`k' = " ${HG_s`k'}[$which]
			local i =  `i' + 1
		}		
		/* unpacked parameters */
		local nrfold = M_nrfc[2,`lev']
		local lev = `lev' + 1
	} /* loop through levels */
}/*endelse HG_free */
* label M_znow
local i=2
local lab 
while `i'<=$HG_tprf{
	local lab "`lab' ${HG_s`i'}"
	local i = `i' + 1
}
matrix colnames M_znow=`lab'
	
end

