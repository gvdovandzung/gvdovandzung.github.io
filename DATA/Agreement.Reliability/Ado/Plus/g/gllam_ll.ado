*! version 1.0.0  (STB-53: sg129)
program define gllam_ll
version 6.0
args todo bo lnf alv probs res
* matrix list `bo'

/* ----------------------------------------------------------------------------- */
/* set up variables and macros needed */

local toplev = $HG_tplv
local topi = $HG_tpi
tempname pkpl b mzlc
local clus $HG_clus
sort `clus'
* reset the the clock and reset znow
local i = 1
matrix M_ip[1,1] = 1 /* in case topi=0 */
while (`i' <= `topi'){
	matrix M_ip[1,`i'] = 1
	local i = `i' + 1
}

/* -------------------------------------------------------------------------------- */
/* set up lprod1 ... lint1 */
local i=1
tempvar extra
quietly gen double `extra'=0
while `i' <= `toplev'{               
	tempvar  lint`i'
	gen double `lint`i'' = 0.0   /* used to integrate, therefore must be zero */
	if (`i'>1){
		tempvar  lprod`i'
		quietly gen double `lprod`i'' = .
		tempvar lfac`i'
		quietly gen double `lfac`i'' = 0  
	}
	local i = `i' + 1
}
/* set up names for HG_xb`i' */
local i = 1
while (`i' <= $HG_tpff){
	tempname junk
	global HG_xb`i' "`junk'"
	local i = `i' + 1
}
/* set up names for HG_s`i' */
local i = 1
while (`i'<=$HG_tprf){
	tempname junk
	global HG_s`i' "`junk'"
	local i = `i'+1
}

qui remcor6 "`bo'"
if $HG_error==1{
	scalar `lnf' = .
	exit
}
*disp "HG_xb1 after remcor: $HG_xb1[$which]:" $HG_xb1[$which]
*disp "HG_s2 after remcor: $HG_s2[$which]:" $HG_s2[$which]

local i = 2
while `i' <= `toplev'{
	quietly zip `i'
	local i = `i' + 1
}
*disp "STARTING LOOP"
/* --------------------------------------------------------------------------------- */
/* recursive loop through r.effs (levels)    */
/* topi nested loops: irf from 1 ro nip(rf) */
/* ip is "clock": (irf) stages of loops      */

*local lc = ln(10000) /* term to add to each lpyz */
*local lc = 0
local levno = `toplev'
local rf = `topi'
while (`rf' <= `topi') { /* for each r.eff */

/* ----------------------------------------------------------------------------------*/
/* reset ip to 1st point for all lower r.effs... */
/* update znow                                   */  
	*disp "reset ip up to random effect " `rf'
	while (`rf' > 1) {
		local rf = `rf' - 1
		*disp `rf'
		matrix M_ip[1,`rf'] = 1
	}
	while (`levno' > 1){ 
	/* update znow for all new ips    */
		quietly zip `levno'
		local levno = `levno' - 1
	}
/* --------------------------------------------------------------------------------- */
/* cycling through lev1: set lint1 to lpyz for new znow  */
		
	local rf = 1
	local levno = 1
	local sortlst `clus' /* cluster variables to sort by */	
	*disp "rf = " `rf'
	while (M_ip[1,`rf'] <= M_nip[1,`rf']) { /* for each int. point for curr. r.eff */
		if (M_nip[1,`rf'] > 1) {quietly zip `levno'} /* no need to call zip for level 1 */
		/* replace lint1 by current cond. log likelihood for lev1 unit*/
		*matrix list M_ip

		qui lpyz `lint1'

		* disp " after lpyz lint1 = " `lint1'[$which]
		quietly count if `lint1'==.
		if r(N) > 0{
			* overflow problem
			noi disp "overflow at level 1 ( " r(N) " missing values)"
			*matrix list `bo'
			*lpyz `lint1'
			if "`res'" == ""{
				scalar `lnf' = .
				exit
			}	
		}
		quietly replace `lint1' = `lint1' * $HG_wt1
		matrix M_ip[1,`rf'] = M_ip[1,`rf'] + 1
		*next ip
	}
/* --------------------------------------------------------------------------------- */
/* update lint for all completed levels up to */
/* highest completed level, reset lower lints */
/* to zero (for models including a random effect) */

	* now ip too high for current `rf'
	matrix M_ip[1, `rf'] = M_nip[1, `rf']    /* reset ip at rf to highest value */
	while (M_ip[1,`rf'] == M_nip[1,`rf'] & `rf' <= `topi'){ 
	* digit equals its max => increment next digit	
		if (`rf' == M_nrfc[1,`levno'] & `levno' < `toplev'){  
		* done last r.eff of current level
			* disp "********** level " `levno' " complete ************"
			* next level
			local levno = `levno'+1 
 
			/* change sortlst */         
			local l = `toplev' - `levno' + 2
			parse "`sortlst'", parse(" ")
			* take away var. of level to sum over          	
			local `l' " "                 
			local sortlst "`*'"

/*------------------------------------------------------------------------------------ */
/* update lint and lprod */
		quietly{
			*!! disp "!!! update level " `levno'

			/* get pkpl: product of r.effs at level */            
			* update znow for levno
			zip `levno'               
			zprob `levno'
			scalar `pkpl' = $S_1

			/* set previous lint to ln(lint) */
			local lprev = `levno' - 1
			if(`levno' > 2){
				*!! disp " replace lint" `lprev' " by ln(lint" `lprev' ")"
				quietly count if `lint`lprev'' < 1e-308
				if r(N) > 0{
					/* overflow problem */
					noi disp "overflow at level " `lprev'
					if "`res'" == ""{
						scalar `lnf' = .
						exit
					}	
				}
				quietly replace `lint`lprev'' = ln(`lint`lprev'')
				quietly replace `lint`lprev'' = (`lint`lprev''-`lfac`lprev'')*${HG_wt`lprev'}
			}

			/* sum previous lprod within cluster at current level */
			*!! disp " "
			*!! disp "by `sortlst': replace lprod" `levno' "=cond(_n==N, sum(lint" `lprev' "))"
			quietly by `sortlst': replace `lprod`levno'' = /*
				*/ cond(_n==_N,sum(`lint`lprev''),.)
			*!! disp "lprod" `levno' " = " `lprod`levno''[$which]
			/* avoid underflow: extra added to lfac, lint multiplied by exp(extra) */
			
			*local nxtlev = `levno' + 1
			*matrix list M_ip
			local lstrf = M_nrfc[2,`levno']
			local frstrf = M_nrfc[2,`lprev'] + 1
			*!! disp "checking that M_ip[1,`frstrf' to `lstrf'] = 1"
			local frst = 1
			while(`frstrf' <= `lstrf'){
				if M_ip[1,`frstrf'] ~= 1{
					local frst = 0
				}
				local frstrf = `frstrf' + 1
			}	
			if `frst' == 1{ /* first term in integral */
				*!! disp "first term for level `levno', random effect `rf'"
				quietly replace `extra' = 0
				quietly replace `lfac`levno'' = -`lprod`levno''
				if "`res'" ~= ""{
					local lst
					local sofar = 0
					local comp = M_nrfc[1,2]
					local found = 0
					tempvar rest resl
					tempname mrot
					gen double `rest' = `lint`levno''
					gen double `resl' = 0
					local ll = M_nrfc[2,1]+1
					while `ll'<=M_nrfc[2,2]{
						gen double `res'm`ll' = 0
						disp "          `res'm`ll'"
						local ll =  `ll' + 1
					}
				} 
			}
			else{
				quietly replace `extra' = /*
				*/cond((`lprod`levno''+`lfac`levno''-100)>0, /*
				*/ -(`lprod`levno''+`lfac`levno''-100),0)
				*!! disp "extra = " `extra'[$which]
				quietly replace `lfac`levno''=`lfac`levno''+`extra'
			}
			/* increment lint at current level using lprod at previous level */
			*!! disp " "
			*!! disp "increase lint" `levno' " by exp(lprod" `levno' ")*pkpl"
			quietly replace `lint`levno''=/*
				*/ exp(`extra')*`lint`levno''+exp(`lprod`levno''+`lfac`levno'')*`pkpl'
			*!! disp "increase by " exp(`lprod`levno''[$which]+`lfac`levno''[$which])*`pkpl' " to "  `lint`levno''[$which]
			if "`res'" ~= ""{
			   noi{ /* for current ip value: */
				if `levno' == 2{
					*!! disp "sortlst = `sortlst'"
					qui by `sortlst': replace `lint`levno''=`lint`levno''[_N]
					qui by `sortlst': replace `lprod`levno''=`lprod`levno''[_N]
					qui by `sortlst': replace `lfac`levno''=`lfac`levno''[_N]
					qui by `sortlst': replace `extra'=`extra'[_N]
					local sofar = `sofar' + 1
					*!! disp "updating `rest' the `sofar'th time"
					qui replace `rest' = `lint`levno''
					qui replace `resl' = exp(`lprod`levno''+`lfac`levno'')*`pkpl'

					*!! disp "`resl' = " `resl'[$which]
					local first = M_nrfc[1,1] + 1 /* loop */
					local ll = `first'
					
					if $HG_free==1{
						matrix `mrot' = M_znow
					}
					else{
						matrix `mrot' = M_chol*M_znow'
						matrix `mrot' = `mrot''
						* matrix list `mrot'
					}
					local kk = M_nrfc[2,1] + 1 /* r. eff */
					while `ll' <= M_nrfc[1,`levno']{
					while `kk' <= M_nrfc[2,`levno']{
						*!! disp "loop " `ll'
						*!! disp "random effect " `kk'
						local junk = M_ip[1,`ll']
						local w = M_nip[2,`kk']
						*scalar `mzlc' = M_zlc`w'[1,`junk']
						scalar `mzlc' = `mrot'[1,`kk'-1]
						qui replace `res'm`kk' = `res'm`kk'*exp(`extra')+/*
							*/ `mzlc'*`resl' /* *${HG_s`kk'} */
						*!! disp "after adding M_znow[1," `kk'-1 "] = " M_znow[1,`kk'-1] ", `res'm`kk' = " `res'm`kk'[$which]
						if M_ip[1,`comp'] == M_nip[1,`comp']{
							*!! disp "loop " `comp' " is complete"
							if `comp' == `first'{
							  *matrix list M_ip
							  *!! disp "last update: divide `res'm`kk' by `rest'"
							  qui replace `res'm`kk' = `res'm`kk'/`rest'
							}
							else if `found' == 0{
								disp "reduce comp by 1"
								local comp = `comp' -1
								local found = 1
							}
						}
						local kk = `kk' + 1
						}
						local ll = `ll' + 1
					}
					if `probs'>0 {
					/* create and update posterior probabilities */
					local lab
					local ll = M_nrfc[1,1]+1
					while `ll' <= M_nrfc[1,2]{ /* each loop */
						local junk = M_ip[1,`ll'] 
						*!! disp "ip = " `junk'
						local lab "`lab'`junk'"
						local ll = `ll'+1
					}
					*!! disp "lab is `lab'"
					qui gen double `res'`lab' = `resl'
					if M_ip[1,`comp'] == M_nip[1,`comp']&`comp'==`first'{
						*!! disp "last update: divide `res'`lab' by `rest'"
						qui replace `res'`lab'=`res'`lab'/`rest'
					}
					*!! disp "`res'`lab' = " `res'`lab'[$which]
					tokenize "`lst'"
					while "`1'" ~= ""{ /* for all posterior probabilities */
						* disp "multiplying `1' by "  exp(`extra'[$which])
						qui replace `1' = `1'*exp(`extra')
						if M_ip[1,`comp'] == M_nip[1,`comp']&`comp'==`first'{
							*!! disp "dividing `1' by pt" 
							qui replace `1' = `1'/`rest'
						}
						mac shift
					}
					local lst "`lst' `res'`lab'"
					} /* endif */
				}
			   } /* noi */
			}

			/* reset previous lint to zero */
			if `levno'>2{
				*!! disp "setting lint" `lprev' " to zero"
				quietly replace `lint`lprev'' = 0
				quietly replace `lfac`lprev'' = 0
			}
		 } /* qui */
/* ------------------------------------------------------------------------------------------- */	
		}
		* next digit
		local rf = `rf' + 1
	}
	* rf is first r.eff that is not complete
	* increase clock in lowest incomplete digit
	* disp "update rf = " `rf'
	matrix M_ip[1,`rf'] = M_ip[1,`rf'] + 1
	*matrix list M_ip
}/*}*/
quietly{ 
	*now rf too high
	*!! disp "********** level " `toplev' " complete ************"
	*!! disp "lint" `toplev' " = " `lint`toplev''[$which]
	if(`toplev'>1){

		*!! disp "taking log of lint" `toplev' " = " `lint`toplev''[$which]
		*!! disp "subtracting " `lfac`toplev''[$which]
		quietly replace `lint`toplev'' = (ln(`lint`toplev'')-`lfac`toplev'')* ${HG_wt`toplev'}
	}
	* noi display "lnf[" $which "] = " `lint`toplev''[$which]
	qui by `sortlst': replace  `extra' = cond(_n==_N,1,0)
	*mlsum `lnf' = `lint`toplev'' if `extra' == 1 /* can only use this when program called by ML */
	count if `extra' == 1
	local n = r(N)
	summarize `lint`toplev'', meanonly
	if `n' > r(N) {
		noi disp "there are " r(N) " values of likelihood, should be " `n'
		noi disp "lnf equal to missing in last step"
		scalar `lnf' = .
		exit
	}
	scalar `lnf' = r(sum)
	display "total lnf = " `lnf'
	*junk
	
	* capture drop lint`toplev'
	* gen double lint`toplev' = `lint`toplev''
} /* qui */
end

program define zip
	version 6.0
	* updates znow 
	* matrix list M_ip
	args levno
/* -----------------------------------------------------------------------------*/
/* do we need to update all r.effs at current level?   */

	disp "in zip, levno is " `levno'
	local i = M_nrfc[2,`levno'-1] + 1 

	*!! disp "update" 
	local k = M_nrfc[1,`levno']
	local k = M_ip[1,`k']
	local last = M_nrfc[2,`levno']
	while `i' <= `last'{
		if $HG_free{
			* same class for all random effects
			local which = `k'
		}
		else{
			local which = M_ip[1,`i']
		}
		local npt = M_nip[2,`i']
		local im = `i' - 1
	 	disp "     "`im' "th z to " `which' "th location"
		disp " using M_zlc`npt' "
		matrix M_znow[1,`im'] = M_zlc`npt'[1,`which']
		*!! disp M_znow[1,`im'] 
		local i = `i' + 1
	}
end

program define zprob
	version 6.0
	* returns product of pk needed for integration at level lev for current ip
	args levno
	tempname pkpl mzps
	disp "in zprob, levno is " `levno'
	scalar `pkpl' = 1.0

	local i=M_nrfc[1,`levno'-1] + 1 

	*!! disp "-----------pkpl: product of" 
	local last = M_nrfc[1,`levno'] 
	local k = M_ip[1,`last']
	while `i' <= `last'{
		if $HG_free{
			local which = `k'
		}
		else{
			local which = M_ip[1,`i']
		}
		local npt = M_nip[2,`i']
		disp "     prob for " `i' "th r.eff: " `which' "th weight"
		disp " using M_zps`npt' "
		* product of probabilities
		scalar `mzps' = M_zps`npt'[1,`which']
		scalar `pkpl' = `pkpl'*`mzps'
		local i=`i'+1
	}
	global S_1 = `pkpl'
	*!! disp "pkpl = " `pkpl'
end


program define lpyz
	version 6.0
* returns log of prob of obs. given znow
	args lpyz

	disp "-----------------called lpyz"

	tempname mznow
	tempvar zu xb mu /* linear predictor and zu: r.eff*design matrix for r.eff */

/* ----------------------------------------------------------------------------- */
*quietly{
/* level 1 was done in remcor*/

/* levels 2 to toplev*/
	

	if $HG_tprf>1{
		matrix score double `zu' = M_znow
	}
	else{
		qui gen double `zu' = 0
	}

	matrix list M_znow
	* disp "ML_y1: $ML_y1 " $ML_y1[$which]

	*matrix list M_ip

	disp " xb1 = " $HG_xb1[$which]
	disp " zu = " `zu'[$which]
	quietly gen double `mu' = 0


	link "$HG_link" `mu' $HG_xb1 `zu'
	disp " mu = " `mu'[$which]
	family "$HG_famil" `lpyz' `mu' $HG_s1
	
	noi disp "lnz = " `lpyz'[$which]
*} /* qui */
end


program define link
	version 6.0
* returns mu for requested link
	args which mu xb zu
	*disp " in link, which is `which' "

	tokenize "`which'"
	local i=1
	while "`1'"~=""{
		if `i' == 1{
			local ifs 
		}
		else{
			local ifs if $HG_lv==`i'
		}
		
		if ("`1'" == "logit"){
		noi disp "quietly replace `mu' = 1/(1+exp(-`xb'-`zu')) `ifs'"
			quietly replace `mu' = 1/(1+exp(-`xb'-`zu')) `ifs'
		}
		else if ("`1'" == "probit"){
			*disp "doing probit "
			quietly replace `mu' = normprob(`xb'+`zu') `ifs'
		}
		else if ("`1'" == "log"){
			*disp "doing log "
			quietly replace `mu' = exp(`xb'+`zu') `ifs'
		}
		else if ("`1'" == "recip"){
			*disp "doing recip "
			quietly replace `mu' = 1/(`xb'+`zu') `ifs'
		}
		else{
		noi disp "quietly replace `mu' = `xb'+`zu' `ifs'"
			quietly replace `mu' = `xb'+`zu' `ifs'
		}
		local i = `i' + 1
		mac shift
	}

end

program define family
	version 6.0
	args which lpyz mu s1

	tokenize "`which'"
	local i=1
	while "`1'"~=""{
		if `i' == 1{
			local ifs 
		}
		else{
			local ifs if $HG_fv == `i'
		}
		if ("`1'" == "binom"){
			famb `lpyz' `mu' "`ifs'"
		}
		else if ("`1'" == "poiss"){
			famp `lpyz' `mu' "`ifs'"
		}
		else if ("`1'" == "gauss") {
			famg `lpyz' `mu' `s1' "`ifs'"  /* get log of conditional prob. */
		}
		else if ("`1'" == "gamma"){
			famga `lpyz' `mu' `s1' "`ifs'"
		}
		else{
			disp in re "unknown family in gllam_ll"
			exit 198
		}
		local i = `i' + 1
		mac shift
	}
end
	
program define famg
	version 6.0
* returns log of normal density conditional on r.effs
	args lpyz mu s1 if
	*!! disp "running famg `if'"
	*!! disp "s1 = " `s1'[$which] ", mu = " `mu'[$which] " and Y = " $ML_y1[$which]
      	quietly replace `lpyz' = /*
		*/ -(ln(2*_pi*`s1'^2) + (($ML_y1-`mu')/`s1')^2)/2 `if'
end

program define famb
	version 6.0
* returns log of binomial density conditional on r.effs
* $HG_denom is denominator
	args lpyz mu if 
	*!! disp "running famb `if'"
	*!! disp "mu = " `mu'[$which] " and Y = " $ML_y1[$which]
	quietly replace `lpyz' = /*
		*/ $ML_y1*ln(`mu')+($HG_denom-$ML_y1)*ln(1-`mu') `if'
	* disp "done famb"
end

program define famp
	version 6.0
* returns log of poisson density conditional on r.effs
	args lpyz mu if
	*!! disp "running famp `if'"
	quietly replace `lpyz' = /*
		*/ $ML_y1*(ln(`mu'))-`mu'-lngamma($ML_y1+1) `if'
	* disp "done famp"
end

program define famga
	version 6.0
* returns log of gamma density conditional on r.effs
	args lpyz mu s1 if
	*!! disp "running famg `if'"
	*!! disp "mu = " `mu'[$which]
	*!! disp "s1 = " `s1'[$which]
	qui replace `mu' = 0.0001 if `mu' <= 0
	tempvar nu
	qui gen double `nu' = `s1'^(-2)
      	quietly replace `lpyz' = /*
		*/ `nu'*(ln(`nu')-ln(`mu')) - lngamma(`nu')/*
		*/ + (`nu'-1)*ln($ML_y1) - `nu'*$ML_y1/`mu' `if'
end
