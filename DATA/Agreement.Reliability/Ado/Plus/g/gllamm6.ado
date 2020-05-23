*! version 6  30May 1999  (STB-53: sg129)
program define gllamm6, eclass
	version 6.0
	if replay() {
                if "`e(cmd)'" ~= "gllamm" {
                        error 301
                }
                Replay `0'
        }
   	else Estimate `0'
end

program define Replay
	version 6.0
	syntax [, Level(int $S_level) EFORM ALLC]
	if e(ll_0)==.{
		local nohead "noheader"
		disp in gr "gllamm model"
		disp " "
		disp in gr "log likelihood = " in ye e(ll)
	}
	if "`eform'"~=""{
		local eform "eform(exp(b))"
	}
	ml display, level(`level') `nohead' first `eform'
	disprand
	if "`allc'"~=""{
		ml display, level(`level') `nohead'
	}	
end

program define Estimate, eclass
	version 6.0
	syntax varlist(min=1) [if] [in] , I(string) [NRf(string) Eqs(string) noCORrel noCOnstant /*
	*/ Family(string) DEnom(varname numeric min=1) Link(string) /*
	*/ Offset(varname numeric) Exposure(varname numeric)/*
	*/ Weightf(string) LV(varname numeric min=1) FV(varname numeric min=1) S(string) /*
	*/ IP(string) NIp(string) /*
	*/ FRom(string) SEarch(passthru) Gateaux(passthru)/*
	*/ LF0(passthru) noLOg TRace noESt Level(int $S_level) init noDIFficult EFORM ALLC *]
	tempname mat mnip
	global HG_error=0

/* deal with trace */

	if "`trace'"!="" { local noi "noisily" }	
	

/* deal with Link and Family */
	global HG_lev1=0
	local l: word count `family'
	if `l'>1 {
		`noi' qui disp  "more than one family"
		global HG_famil 
		if "`fv'"==""{
			confirm variable family
			global HG_fv family
		}
		else{
			confirm variable `fv'
			global HG_fv `fv'
		}
		parse "`family'", parse(" ")
		local n=1
		while "`1'"~=""{
			qui count if `fv'==`n'
			if _result(1)==0{
				disp "family `1' not used"
			}
			fm "`1'"
			if "`1'"=="gauss"{
				if $HG_lev1==0{
					global HG_lev1=1
				}
				else if $HG_lev1==2{
					global HG_lev1=3
				}
			}
			else if "`1'"=="gamma"{
				if $HG_lev1==0{
					global HG_lev1=2
				}
				else if $HG_lev1==1{
					global HG_lev1=3
				}
			}
			global HG_famil "$HG_famil $S_2"
			local n = `n'+1
			mac shift
		}
		
	}
	local k: word count `link'
	if `k'>1{
		`noi' qui disp  "more than one link"
		global HG_link 
		if "`lv'"==""{
			confirm variable link
			global HG_lv link
		}
		else{
			confirm variable `lv'
			global HG_lv `lv'
		}
		parse "`link'", parse(" ")
		local n=1
		while "`1'"~=""{
			qui count if `lv'==`n'
			if _result(1)==0{
				disp "link `1' not used"
			}
			lnk "`1'"
			global HG_link "$HG_link $S_1"
			local n = `n'+1
			mac shift
		}

	}
	else if `k'<=1&`l'<=1{ /* no more than one link and one family given */
		lnkfm "`link'" "`family'"
		global HG_link = "$S_1"
		global HG_famil  = "$S_2"
		if "$HG_famil"=="gauss"{global HG_lev1=1}
		if "$HG_famil"=="gamma"{global HG_lev1=2}	
	}
	else if (`k'>1&`l'==0)|(`l'>1&`k'==0){
		disp in re /*
		*/ "both the link() and fam() required for multiple links or families"
		exit 198
	}
 

/* deal with varlist */
	tokenize `varlist'
	local y "`1'"

	macro shift   /* `*' is list of dependent variables */
	local indep "`*'"

	local num: word count `indep'  /* number of independent variables */

/* deal with noCOns */
	if "`constant'"~=""{ 
		local cns
	}
	else{
		local num=`num'+1
		local cns "_cons"
	}
	matrix M_nffc=(`num')

/* deal with noCORrel */
	global HG_cor = 1
	if "`correl'"~=""{
		global HG_cor = 0
	}

/* fixed effects matrix */

	matrix M_initf=J(1,`num',0)
	matrix coleq M_initf=`y'
	matrix colnames M_initf=`indep' `cns'

/* deal with DEnom */
	global HG_denom
	local f=0
	parse "$HG_famil", parse(" ")
	while "`1'"~=""&`f'==0{
		if "`1'"=="binom"{
			local f=1
		}
		mac shift
	}
	if `f'==1{
		if "`denom'"~=""{
			confirm variable `denom'
			global HG_denom "`denom'"
		}
		else{
			tempvar den
			quietly gen `den'=1
			global HG_denom "`den'"
		}
	}
	else{
		if "`denom'"~=""{
			disp in blue/*
			  */"option denom(`denom') given but binomial family not used"
		}
	} 
	
/* deal with offset or exposure */
	global HG_off
	if "`offset'"~=""{
		global HG_off "`offset'"
		local offset "offset(`offset')"
	}

/* deal with ip */
	global HG_gauss = 1
	global HG_free = 0
	if "`ip'"=="l"{
		global HG_gauss = 0
	}
	else if "`ip'"=="f"{
		global HG_free = 1
	}

/* deal with I (turn list around)*/
	if ("`i'"==""){
		disp in red "i() required"
		global HG_error=1
		exit 198
	}
	local tplv: word count `i'
	global HG_tplv = `tplv'+1
	global HG_clus
	local k = `tplv'
	while `k'>=1{
		local clus: word `k' of `i'
		confirm variable `clus'
		local k=`k'-1
		global HG_clus "$HG_clus `clus'"
	}
	tempvar id
	gen `id'=_n
	global HG_clus "$HG_clus `id'"

/* deal with weightf */
	tempvar wt
	quietly gen `wt'=1
	local j = 1
	if "`weightf'"==""{
		while (`j'<=$HG_tplv){
			tempname junk
			global HG_wt`j' "`junk'"
			gen ${HG_wt`j'}=1
			local j = `j' + 1
		}
	}
	else{
		global HG_weigh "`weightf'"
		local found = 0
		while (`j'<=$HG_tplv){
			capture confirm variable `weightf'`j'   /* frequency weight */
			if _rc ~= 0 {
				tempname junk
				global HG_wt`j' "`junk'"
				gen ${HG_wt`j'}=1
			}
			else{
				tempname junk
				global HG_wt`j' "`junk'"
				gen ${HG_wt`j'}=`weightf'`j'
				quietly replace `wt'=`wt'*${HG_wt`j'}
				local found = `found' + 1
			}
			local j = `j' + 1
		}
		if `found' == 0 {
			disp in red "weight variables `weightf' not found"
			global HG_error=1
			exit 111
		}
	}

/* display information */
	quietly `noi'{
		disp " "
		disp in gr "General model information"
		disp in gr "-----------------------------------------------------------------------------"
		disp in gr "dependent variable:" in ye "         `y'"	
		disp in gr "family:" in ye "                     $HG_famil"
		disp in gr "link:" in  ye "                       $HG_link"
		if "$HG_denom"~=""{
			if "`denom'"~=""{
		     		disp in gr "denominator:" in ye "                `denom'"
			}
			else{
				disp in gr "denominator:" in ye "                1"
			}
		}
		if "`offset'"~=""{
			disp in gr "offset:" in ye "                     $HG_off"
		}
		disp in gr "equation for fixed effects:" in ye " `y': `indep' `cns'"
		disp " "
	}


/* deal with if and in */
	marksample touse
	markout `touse' `weightf'* `denom' $HG_off

/* initialise macros */
	quietly `noi' initmacs "`nrf'" "`nip'" "`eqs'"  "`s'" "`touse'"
	qui count if `touse'
	if _result(1) <= 1 {
		di in red "insufficient observations"
		exit 2001
	}
	qui summ `wt' if `touse', meanonly
	global HG_obs=_result(18)
	
/* deal with noESt */
	if "`est'"~=""{
		exit 0
	}
/* only use observations satisfying if and in */
	preserve
	quietly keep if `touse'
/* deal with from */
	if "`from'"~=""{
		capture qui matrix list `from'
		local rc=_rc
		if `rc'>1{
			disp in red "`from' not a matrix"
			exit 111
		}
		local from "from(`from')"
	}
	else{
/* initial values for fixed effects */
		local lnk $HG_link
		if "$HG_link"=="recip"{
			local lnk pow -1
		}
		qui `noi' disp in gr "Initial values for fixed effects"
		qui `noi' disp " "
		tempvar yn
		if "`offset'"~=""{
			quietly gen `yn' = `y' - $HG_off
		}
		else{
			gen `yn' = `y'
		}
		if ("$HG_famil"=="gauss")&("$HG_link"=="ident")& M_nbrf[1,1]==1{
			quietly `noi' reg `yn' `indep' [fweight=`wt'], `constant'
			matrix M_initr[1,1]=ln(_result(9))
		}
		else if "$HG_famil"=="binom"{
			qui summ `denom'
			if _result(3)>1 {
				* noi dis "got here"
				qui `noi' glm `y' `indep' [fweight=`wt'], link(`lnk') /*
                                             */ fam(binom `denom') `constant' `offset'
			}
			else{
				if "$HG_link"=="logit"{
					qui `noi' logit `y' `indep' [fweight=`wt'], `constant' `offset'
				}
				else if "$HG_link"=="probit"{
					qui `noi' probit `y' `indep' [fweight=`wt'], `constant' `offset'
				}
			}
		}
		else if ("$HG_famil"=="poiss")&("$HG_link"=="log"){
			qui `noi' poisson `y' `indep' [fweight=`wt'], `constant' `offset'
		}
		else if ("$HG_famil"=="gamma"& M_nbrf[1,1]==1){
			qui `noi' glm `y' `indep' [fweight=`wt'], link(`lnk')/*
				*/ fam(gamma) `constant' `offset'
			matrix M_initr[1,1]= -ln($S_E_dc)
		}		
		else{ /* fit level 1 model */
		/* preserve macros */
			local eqs "$HG_eqs"
			local tprf=$HG_tprf
			local tplv=$HG_tplv
			local tpi=$HG_tpi
			tempvar keep
			quietly gen `keep'=$HG_wt1
			quietly replace $HG_wt1=`wt'
			matrix `mnip'=M_nip
	
		/* change global macros */
			matrix M_nip=(1,1\1,1)
			if $HG_lev1>0{
				global HG_eqs $HG_s1
				global HG_tprf=1
				global HG_tpi=1
				local frm "from(M_initr)"
			}
			else{
				global HG_eqs
				global HG_tprf=0
			}
		/* fit model for initial values */
			global HG_tplv=1 /* no level 1 standard deviation */
			qui `noi' hglm_ml `y' `indep',  /*
			   */  obs($HG_obs) `log' title("fixed effects model") /*
			   */ `frm' `trace' `constant' skip `difficult'
			*quietly `noi' ml mlout gllamm, level(`level')
			quietly `noi' ml display, level(`level')

			if $HG_lev1>0{
				local num=M_nbrf[1,1]
				matrix `mat'=e(b)
				matrix `mat'=`mat'[1,"lns1:"]
				local i=1
				while `i'<=`num'{
					matrix M_initr[1,`i']=`mat'[1,`i']
					local i=`i'+1
				}
			}

		/* restore global macros */
			global HG_tplv=`tplv'
			global HG_eqs "`eqs'"
			global HG_tprf=`tprf'
			global HG_tpi=`tpi'
			quietly replace $HG_wt1=`keep'
			matrix M_nip=`mnip'
		}
		matrix M_initf=e(b)
		local num=M_nffc[1,$HG_tpff]
		matrix M_initf=M_initf[1,1..`num']
		* matrix list M_initf
		if $HG_error==1{
			exit
		}
	}
/* deal with init */
	if "`init'"~=""{
		exit
	}
/* estimation */
	qui `noi' dis "  "
	qui `noi' dis "start running on $S_DATE at $S_TIME"
	capture noi hglm_ml `y' `indep', `trace' `options' `constant'/*
             */ obs($HG_obs) `log' title("gllamm model") `from' /*
	     */ `search' `lf0' `gateaux' `difficult'
	qui `noi' dis "finish running on $S_DATE at $S_TIME"
	qui `noi' dis "  "
	restore
	if $HG_error==0{
		tempname b
		matrix `b'=e(b)
		*disp "running remcor"
		qui remcor6 `b'
		*disp "running delmacs"
		delmacs
		estimate local cmd "gllamm"
		*disp "running replay"
		Replay, level(`level') `eform' `allc' 
	}	
end


program define hglm_ml
	version 6.0
	syntax varlist(min=1) [, TITLE(passthru) LF0(numlist) noLOg TRace noCOnstant /*
	*/ OBS(integer 0) FROM(string) SEarch(integer 0) Gateaux(numlist min=3 max=3) skip /*
	*/ noDIFficult *]

	if "`obs'"~="" { local obs "obs(`obs')" }
	if "`log'"=="" { local log "noisily" }
	if "`trace'"~="" { local noi "noisily" }
	else local log 
	parse "`varlist'", parse(" ")
	local y "`1'"
	macro shift
	local indep "`*'"

     	tempvar mysamp
        tempname b f V M_init M_initr a lnf mlnf ip deriv

	if "`from'"~=""{
		matrix `M_init'=`from'
/* deal with gateaux (in future, different limits for each random effect) */
		if "`gateaux'"~=""&$HG_free==0{
			disp in re "option gateaux not allowed (ignored) for fixed integration points"
		}
		else if "`gateaux'"~=""&$HG_free==1{
			qui `noi' disp in gr "Gateaux derivative"
			local mf=colsof(M_initf)
			local mr = colsof(M_initr)
			local ll=$HG_tplv-1
			local tprf=M_nrfc[2,$HG_tplv]-M_nrfc[2,`ll']
			if `mf'+`mr'-`tprf'-1~=colsof(`M_init'){
				disp in re "initial value vector should have length `mf'+`mr'-`tprf'-1"
				matrix list `from'
				global HG_error=1
				exit 198
			}
			local mfp = `mf' + 1
			local l = `mr' - `tprf'-1 /* length of previous M_initr */
			local lp = `l' + 1
			matrix `a' = M_initr[1,`lp'...]
			matrix M_initr=`M_init'[1,`mfp'...]
			matrix M_initr=M_initr,`a'
			matrix `M_init'=`M_init'[1,1..`mf']
			tokenize "`gateaux'"
			local min = `1'
			local max = `2'
			local num = `3'
			local stp = (`max'-`min')/(`num'-1)
			matrix M_initr[1,`mr']=-5 /* mass of new masspoint */
			scalar `mlnf'=0
			matrix `ip'=M_ip
			matrix `ip'[1,1]=1
			*recursive loop
			matrix `ip'[1,`tprf']=1
			local k = `l' + `tprf'
			matrix M_initr[1,`k']=`min'
			local nxtrf = `tprf'+1
			matrix `ip'[1,`nxtrf']=`num'
			local rf = `tprf'
			while `rf' <= `tprf'{
				*reset ip up to random effect `rf'
				while (`rf'>1) {
					local rf = `rf'-1
					matrix `ip'[1,`rf'] = 1
					local k = `l' + `rf'
					matrix M_initr[1,`k']=`min'
				}
				* update lowest digit
				local rf = 1 
				while `ip'[1,`rf'] <= `num'{
					local k = `l' + `rf'
					matrix M_initr[1,`k'] = `min' + (`ip'[1,`rf']-1)*`stp'
					matrix `a'=`M_init',M_initr
					*matrix list `a'
					global ML_y1 `y'
					gllam_ll 0 "`a'" "`lnf'"
					*noisily disp "likelihood=" `lnf'
					if (`lnf'>`mlnf'|`mlnf'==0)&`lnf'~=.{ 
						scalar `mlnf'=`lnf'
						matrix `M_initr'=M_initr
					}
					matrix `ip'[1,`rf'] = `ip'[1,`rf'] + 1
				}
				matrix `ip'[1,`rf'] = `num' /* lowest digit has reached the top */
				while `ip'[1,`rf']==`num'&`rf'<=`tprf'{
					local rf = `rf' + 1
				}
				* rf is first r.eff that is not complete or rf>nrf
				if `rf'<=`tprf'{
					matrix `ip'[1,`rf'] = `ip'[1,`rf'] + 1
					local k = `l' + `rf'
					matrix M_initr[1,`k'] = `min' + (`ip'[1,`rf']-1)*`stp'
				}
			}
			if "`lf0'"~=""{
				local junk: word 2 of `lf0'
				disp in re "junk = " `junk'
				disp in re "mlnf - lf0 is " `mlnf' " - " `junk'
				scalar `deriv' = `mlnf'-`junk'
				disp in ye "maximum gateaux derivative is " `deriv'
				* matrix list `M_initr'
				if `deriv'<0.00001{
					disp in re "maximum gateaux derivative less than 0.00001"
					global HG_error=1
					exit
				}
			}
			else{
				disp in ye "no gateaux derivarives could be calculated"
				matrix list `M_initr'
			}

			matrix `M_initr'[1,`mr']=-1
			matrix `M_init'=`M_init',`M_initr'
			matrix list `M_init'
		}		
	}
	else{
		if "`gateaux'"~=""{ disp "gateaux can't be used without option from()"}
		matrix `M_init'=M_initf
		if $HG_tprf>1{
			matrix `M_initr'=M_initr
			local max=3
			local min=0
			scalar `mlnf' = 0
			local f1= M_nbrf[1,1]+1
			local l=colsof(M_initr)
			local m=1
			if `search'>1{qui `noi' disp in gr "searching for initial values for random effects"}
			while `m'<=`search'{ /* begin search */
				* matrix list M_initr
				matrix `a'=`M_init',M_initr
				*matrix list `a'
				global ML_y1 `y'
				noisily gllam_ll 0 "`a'" "`lnf'"
				qui `noi' disp "likelihood=" `lnf'
				if (`lnf'>`mlnf'|`m'==1)&`lnf'~=. { 
					scalar `mlnf'=`lnf'
					matrix `M_initr'=M_initr
				}
				local k=`f1'
				while `k'<=`l'{
					matrix M_initr[1,`k']=`min' + (`max'-`min')*uniform()
					local k=`k'+1
				}
				local m = `m' + 1
			} /* end search */
			matrix `M_init' = `M_init',`M_initr'
		}

	}
	if "`difficult'"~=""{
		local difficu /* erase macro */
	}
	else{
		local difficu "difficult" /* default */
	}
	*disp "(`y': `y'=`indep', `constant') $HG_eqs, init(`M_init',`skip') `difficu' `options'"
	*matrix list `M_init'
	if "`lf0'"~="" { local lf0 "lf0(`lf0')" }
	capture `log' ml model d0 gllam_ll (`y': `y'=`indep', `constant') $HG_eqs, maximize search(off) /*
	 */ init(`M_init', `skip') noscvars `lf0' `obs' `title' `trace' waldtest(0) nopreserve missing /*
	 */ `difficu' `options'
	local rc = _rc
	if `rc'>1 {
		di in red "(error occurred in ML computation)"
		di in red "(use trace option and check correctness " /*
		*/ "of initial model)" 
		global HG_error=1
		exit `rc'
	}
	if `rc'==1 {
		di in red /*
		*/ "(Maximization aborted)"
		delmacs
		global HG_error=1
		exit 1
	}
	else if $HG_error==1{
		disp in red "some error has occurred"
		exit
	}
end

program define lnkfm
	version 6.0
	args link fam

	global S_1	/* link		*/
	global S_2	/* family	*/


	lnk "`1'"
	fm "`2'"	

	if "$S_1" == "" {
		if "$S_2" == "gauss" { global S_1 "ident" }
		if "$S_2" == "poiss" { global S_1 "log"   }
		if "$S_2" == "binom" { global S_1 "logit" }
		if "$S_2" == "gamma" { global S_1 "recip" }
	}

end

program define fm
	version 6.0
	args fam
	local l = length("`fam'")
	local f = lower(trim("`fam'"))

	if "`f'" == substr("gaussian",1,max(`l',3)) { global S_2 "gauss" }
	else if "`f'" == substr("normal",1,max(`l',3))   { global S_2 "gauss" }
	else if "`f'" == substr("poisson",1,max(`l',3))  { global S_2 "poiss" }
	else if "`f'" == substr("binomial",1,max(`l',3)) { global S_2 "binom" }
	else if "`f'" == substr("gamma",1,max(`l',3))    { global S_2 "gamma" }
	else if "`f'" != "" {
		noi di in red "unknown family() `fam'"
		exit 198
	}

	if "$S_2" == "" {
		global S_2 "gauss"
	}
end

program define lnk
	version 6.0
	args link
	local l = length("`link'")
	local f = lower(trim("`link'"))

	if "`f'" == substr("identity",1,max(`l',2)) { global S_1 "ident" }
	else if "`f'" == substr("log",1,max(`l',3))      { global S_1 "log"   }
	else if "`f'" == substr("logit",1,max(`l',4))    { global S_1 "logit" }
	else if "`f'" == substr("probit",1,max(`l',3))   { global S_1 "probit"}
	else if "`f'"==substr("reciprocal",1,max(`l',3)) { global S_1 "recip" }
	else if "`f'" != "" {
		noi di in red "unknown link() `link'"
		exit 198
	}
end

program define delmacs, eclass
	version 6.0
/* deletes all global macros and matrices and stores some results in e()*/
	tempname var
	if "$HG_tplv"==""{
		* macros already gone
		exit
	}
	local nrfold = M_nrfc[2,1]
	local lev = 2
	while (`lev'<=$HG_tplv){
		local i2 = M_nrfc[2,`lev']
		local i1 = `nrfold'+1
		local i = `i1'
		local nrfold = M_nrfc[2,`lev']
		while `i' <= `i2'{
			local n = M_nip[2,`i']
			if `i' <= M_nrfc[1,`lev']{
				capture est matrix zps`n' M_zps`n'
			}
			capture est matrix zlc`n' M_zlc`n'
			local i = `i' + 1
		}
		local lev = `lev' + 1
	}
	if $HG_free==0{
		est matrix chol M_chol
	}
	est matrix nrfc M_nrfc
	*matrix drop M_nrfc
	est matrix nffc M_nffc
	*matrix drop M_nffc
	est matrix nbrf M_nbrf
	*matrix drop M_nbrf
	matrix drop M_ip
	est matrix nip M_nip
	*matrix drop M_nip
	matrix drop M_znow
	capture matrix drop M_initf
	matrix drop M_initr

	/* globals defined in gllam_ll */
	local i=1
	while (`i'<=$HG_tpff){
		global HG_xb`i'
		local i= `i'+1
	}
	local i = 1
	while (`i'<=$HG_tprf){
		global HG_s`i'
		local i= `i'+1
	}
	local i = 1
	while (`i'<=$HG_tplv){
		global HG_wt`i'
		local i = `i' + 1
	}
	est local lev1 = $HG_lev1
	global HG_lev1
	est local tplv = $HG_tplv
	global HG_tplv 
	est local tprf = $HG_tprf
	global HG_tprf
	est local tpi = $HG_tpi
	global HG_tpi
	est local tpff = $HG_tpff
	global HG_tpff
	est local clus "$HG_clus"
	global HG_clus
	est local weight "$HG_weigh"
	global HG_weigh
	global which   
	global HG_gauss 
	est local free = $HG_free 
	global HG_free
	est local famil "$HG_famil"
	global HG_famil 
	est local link "$HG_link"
	global HG_link 
	est local lv "$HG_lv"
	global HG_lv
	est local fv "$HG_fv"
	global HG_fv
	global HG_nump
	global HG_eqs
	global HG_obs
	est local offset "$HG_off"
	global HG_off
	global HG_denom
	est local cor = $HG_cor
	global HG_cor
	est local s1 "$HG_s1"
	global HG_s1
end

program define initmacs
version 6.0
/* defines all global macros */
args nrf nip eqs s touse

tempname mat

disp "  "
disp in gr "Random effects information for" in ye " $HG_tplv" in gr " level model"
disp in gr "-----------------------------------------------------------------------------"

/* deal with nrf */
	matrix M_nrfc=J(2,$HG_tplv,1)
	if "`nrf'"==""|$HG_free{
		local k=1
		while (`k'<=$HG_tplv){
			matrix M_nrfc[1,`k']=`k'
			matrix M_nrfc[2,`k']=`k'
			local k=`k'+1
		}
	}
	if "`nrf'"~=""{
		local k: word count `nrf'
		if `k'~=$HG_tplv-1 {
			if $HG_tplv==1{
				disp in red "option nrf is meaningless for 1-level model"
			}
			else{
				disp in red "option nrf() does not contain " $HG_tplv-1 " argument(s)"
			}
			exit 198
		}
		parse "`nrf'", parse(" ")
		local k=2
		while (`k'<=$HG_tplv){
			matrix M_nrfc[2,`k']=`1'
			local k=`k'+1
			mac shift
		}
		/* make cumulative */
		local k=2
		while (`k'<=$HG_tplv){
			matrix M_nrfc[2,`k']=M_nrfc[2,`k'-1]+M_nrfc[2,`k']
			if $HG_free==0{matrix M_nrfc[1,`k']=M_nrfc[2,`k']}
			local k=`k'+1
		}
	}
	* matrix list M_nrfc
	global HG_tprf=M_nrfc[2,$HG_tplv] /* number of random effects */
	global HG_tpi=M_nrfc[1,$HG_tplv] /* number of integration loops + 1 */
	if $HG_tplv==$HG_tprf{
		if $HG_cor==0{
			disp "option nocorrel ignored because no multiple r. effects per level"
		}
	}

/* deal with nip */
	if "`nip'"==""{ 
		local k = 1
		local nip = 8
	}
	else{
		local k: word count `nip'
	}
	if `k'==1{
		matrix M_nip=J(2,$HG_tprf,`nip')
		if `nip' == 1 { global HG_error=1 }
		matrix M_nip[1,1]=1
	}
	else if `k'~=$HG_tpi-1{
		disp in red "option nip() has `k' arguments, need 1 or " $HG_tpi-1
		exit 198
	}
	else{
		matrix M_nip=J(2,$HG_tprf,1)
		local i=1
		while `i'<$HG_tpi{
			local k: word `i' of `nip'
			local l = `i' + 1
			matrix M_nip[1,`l']= `k'
			local i = `i' + 1
		}
	}
	local i = M_nrfc[2,1]+1
	while `i'<= $HG_tprf{
		if $HG_free{
			matrix M_nip[2,`i'] = `i'
		}
		else{
			matrix M_nip[2,`i'] = M_nip[1,`i']
		}
		local i = `i' + 1
	}			

	* matrix list M_nip
	capture matrix drop M_initr
	
/* deal with Eqs */
	matrix M_nbrf=(0)
	global HG_eqs
	if $HG_lev1>0{
		disp in gr "***level 1 equation:"
		if "`s'"~=""{
			eq ? "`s'"
			local vars "$S_1"
			markout `touse' `vars'
			global HG_eqs "$HG_eqs (lns1:`vars',nocons)"
			global HG_s1 "(lns1:`vars',nocons)"
		}
		else{
			local vars "_cons"
			global HG_eqs "$HG_eqs (lns1:)"
			global HG_s1 "(lns1:)"
		}
		disp " "
		if $HG_lev1==1{disp in gr "   log standard deviation"}
		else if $HG_lev1==2{disp in gr "   log coefficient of variation"}
		else if $HG_lev1==3{disp in gr "   log(phi)/2"}
		disp in ye "   lns1: `vars'"
		local num: word count `vars'
		matrix M_nbrf=(`num')
		matrix `mat'=J(1,`num',-1)
		matrix colnames `mat'=`vars'
		matrix coleq `mat'=lns1
		matrix M_initr=nullmat(M_initr),`mat'
	}
	else{
		matrix M_nbrf=(0)
		if "`s'"~=""{
			disp in re "S not used because families do not include dispersion parameters"
		}
	}
	if "`eqs'"~=""{
		local k: word count `eqs'
		if `k'~=$HG_tprf-1{
			disp in red `k' " equations specified: `eqs', need " $HG_tprf-1
			exit 198
		}
		* check that they are equations and find number of variables in each: nbrf
		local lev=2
		local l=1
		local ic=0
		while (`lev'<=$HG_tplv){
			disp " "
			local m=$HG_tplv-`lev'+1
			local clusnam: word `m' of $HG_clus
			disp " "
			disp in gr "***level `lev' (" in ye "`clusnam'" in gr ") equation(s):"
			local clusnam=substr("`clusnam'",1,4)
			local i1=M_nrfc[2, `lev'-1]
			local j1=M_nrfc[2, `lev']
			local nrf=`j1'-`i1'
			disp "   (`nrf' random effect(s))"
			disp "  "
			local rfl = 1
/* MASS POINTS */
			if $HG_free {
				if $HG_cor==0{
					disp "option nocorrel irrelevant for free masses"
				}
				local k = 1
				while `k' < M_nip[1, `lev']{
					disp " "
					disp in gre "class `k'"
					local j = `i1'
					while `j'< `j1'{
						local eqnam: word `j' of `eqs'
						eq ? "`eqnam'"
						local vars "$S_1"
						markout `touse' `vars'
						local num: word count `vars'
						matrix `mat'=(`num')
						matrix M_nbrf=M_nbrf,`mat'
						if (`num'>1){
							parse "`vars'", parse(" ")
							local vars1 "`1'"
							if `k'==1{
								mac shift
								local vars2 "`*'"
								local eqnaml "`clusnam'`rfl'l"
								eq "`eqnaml': `vars2'"
								eq ? "`eqnaml'"
								disp " "
								disp in gr "   lambdas for random effect " in ye `j'
								disp in ye "   `eqnaml': `vars2'"
								global HG_eqs "$HG_eqs (`eqnaml': `vars2', nocons)"
								local num=`num'-1
								* initial loading on masspoints
								local lod = `j'/3
								matrix `mat'=J(1,`num',`lod')
								matrix colnames `mat'= `vars2'
								matrix coleq `mat'=`eqnaml'
								matrix M_initr = nullmat(M_initr), `mat'	
							}

						}
						else{local vars1 `vars'}
						disp " "
						disp in gr "   location for random effect " in ye `j'
						local eqnam "z`lev'_`j'_`k'"
						if `nrf'==1{
							local eqnam "z`lev'_`k'"
						}
						eq "`eqnam'":`vars1'
						eq ? "`eqnam'"
						disp in ye "   `eqnam': `vars1'"
						global HG_eqs "$HG_eqs (`eqnam': `vars1', nocons)"
						markout `touse' `vars1'
						* initial locations of mass points
						*local val = int((`k'+1)/2)*(-1)^`k'/10
						local val = int((`k'+1)/2)*(-1)^`k'
						matrix `mat'=(`val')
						matrix colnames `mat'=`vars1'
						matrix coleq `mat'=`eqnam'
						matrix M_initr=nullmat(M_initr),`mat'
						local j = `j' + 1
						local rfl = `rfl' + 1
					}
					local eqnam "p`lev'_`k'"
					eq "`eqnam'":
					eq ? "`eqnam'"
					disp " "
					disp in gr "   log odds for level " in ye `lev'
					disp in ye "   `eqnam': _cons"
					global HG_eqs "$HG_eqs (`eqnam':)"
					* initial log odds for masspoints
					matrix `mat'=(-.4)
					matrix colnames `mat'=_cons
					matrix coleq `mat'=`eqnam'
					matrix M_initr=nullmat(M_initr),`mat'
					local k = `k' + 1
				}
			}
/* STD DEVS */
			else{
				local j = `i1'
				while (`j'<`j1'){
					local eqnam: word `l' of `eqs'
					eq ? "`eqnam'"
					local vars "$S_1"
					local num: word count `vars'
					matrix `mat'=(`num')
					matrix M_nbrf=M_nbrf,`mat'
					markout `touse' `vars'
					if "`vars'"==""{ local vars "_cons"}
					if `num'>1{
						* vars1 is variable of first loading (fix at one)
						parse "`vars'", parse(" ")
						local vars1 "`1'"
						mac shift
						local vars "`*'"
						local eqnaml "`clusnam'`rfl'l"
						eq "`eqnaml'": `vars'
						eq ? "`eqnaml'"
						disp " "
						disp in gr "   lambdas for random effect " in ye `j'
						disp in ye "   `eqnaml': `vars'"
						global HG_eqs "$HG_eqs (`eqnaml': `vars', nocons)"
						* initial values of loadings
						local lod = `j'/3 /*different loading for diff r.eff*/
						matrix `mat'=J(1,`num'-1,`lod')
						matrix colnames `mat'=`vars'
						matrix coleq `mat'=`eqnaml'
						matrix M_initr=nullmat(M_initr),`mat'
					}
					else{
						local vars1 `vars'
					}
					* variance
					local eqnam "`clusnam'`rfl'"
					eq "`eqnam'": `vars1'
					if `nrf'==1|$HG_cor==0{
						disp in gr "   standard deviation for random effect " in ye `j'
					}
					else if `j'==`i1'{
						disp " "
						disp in gr /*
						*/"   diagonal elements of cholesky decomp. of covariance matrix"
					}
					disp in ye "   `eqnam' : `vars1'"
					global HG_eqs "$HG_eqs (`eqnam': `vars1', nocons)"
					* initial value of standard deviation
					matrix `mat' = (0.5)
					matrix colnames `mat' = `vars1'
					matrix coleq `mat' = `eqnam'
					matrix M_initr=nullmat(M_initr),`mat'
					local l=`l'+1
					local j=`j'+1
					local rfl = `rfl' + 1
				}
				if `nrf' > 1&$HG_cor==1{
					/* generate equations for covariance parameters */
					disp " "
					disp  in gr "   off-diagonal elements"
					local ii=2
					*local num = $HG_tplv-`lev'+1
					*local eqnam: word `num' of $HG_clus
					*local eqnam = substr("`eqnam'",1,4)
					while (`ii'<=`nrf'){
						local jj=1
						while (`jj'<`ii'){
							local eqnaml "`clusnam'`ii'_`jj'"
							eq "`eqnaml'":
							eq ? "`eqnaml'"
							disp in ye "   `eqnaml': _cons"
							global HG_eqs "$HG_eqs (`eqnaml':)"
							matrix `mat'=(0)
							matrix colnames `mat'=_cons
							matrix coleq `mat'=`eqnaml'
							matrix M_initr=nullmat(M_initr),`mat'
							local jj =  `jj' + 1
						}
						local ii=`ii'+1
					}
				}
			} /* end else $HG_free */
		local lev=`lev'+1
		} /* lev loop */
		
	} /* endif equ given */
	else{
	/* random intercepts */
		if M_nrfc[1,$HG_tplv]~=$HG_tplv{
			"must specify equations for random effects"
			exit 198
		}
		local k=$HG_tprf-1
		matrix `mat'=J(1,`k',1)
		matrix M_nbrf=M_nbrf,`mat'
		local lev=2
		disp " "
		while (`lev'<=$HG_tplv){
			local l=$HG_tplv-`lev'+1
			local clusnam: word `l' of $HG_clus
			disp " "
			disp in gr "***level `lev' (" in ye "`clusnam'" in gr ") equation(s):"
			local clusnam = substr("`clusnam'",1,4)
/*MASS POINTS */
			if ($HG_free){
				local k = 1
				while `k' < M_nip[1, `lev']{
					disp " "
					disp in gre "class `k'"
					local j = 1
					if `k'<M_nip[1, `lev']{
						local eqnam "z`lev'_`k'"
						disp in gr "   location for random effect"
						disp in ye "   `eqnam': _cons"
						global HG_eqs "$HG_eqs (`eqnam':)"
						* initial locations of mass points
						*local val = int((`k'+1)/2)*(-1)^`k'/10
						local val = int((`k'+1)/2)*(-1)^`k'
						matrix `mat'=(`val')
						matrix colnames `mat'=_cons
						matrix coleq `mat'=`eqnam'
						matrix M_initr=nullmat(M_initr),`mat'
					}
					local eqnam "p`lev'_`k'"
					disp in gr "   log odds for random effect"
					disp in ye "   `eqnam': _cons"
					global HG_eqs "$HG_eqs (`eqnam':)"
					* initial log odds for mass-points
					matrix `mat'=(-.4)
					matrix colnames `mat'=_cons
					matrix coleq `mat'=`eqnam'
					matrix M_initr=nullmat(M_initr),`mat'
					local k = `k' + 1
				}
			}
/* ST. DEVS */
			else{
				local eqnam "`clusnam'"
				disp " "
				disp in gr "   standard deviation of random effect"
				disp in ye "   `eqnam': _cons"
				global HG_eqs "$HG_eqs (`eqnam':)"
				* initial value for sd
				matrix `mat'=(0.5)
				matrix colnames `mat'=_cons
				matrix coleq `mat'=`eqnam'
				matrix M_initr=nullmat(M_initr),`mat'
				local cons `cons'1
			}
			local lev=`lev'+1
		}
	}
	disp " "
/* ++++++++++++ need to define quantities +++++++++++++++++++++++++++++++++++++++ */
	global which = 25

/* ++++++++++++ calculates quantities +++++++++++++++++++++++++++++++++++++++ */
/* total number of fixed linear predictors */      
	global HG_tpff = colsof(M_nffc)
		
/* the "clock" ip and znow*/
	local k = $HG_tprf+2
	matrix M_ip =  J(1,`k',1)
	local k = $HG_tprf - 1
	matrix M_znow =J(1,`k',1)

/* set up zloc and zps*/
	if $HG_free==0{
		local i = 2
		while (`i'<=$HG_tprf){
			local n = M_nip[1, `i']
			if $HG_gauss{
				ghquad `n'
			}
			else{
				lebesque `n'
			}
			* matrix list M_zlc`n'
			* matrix list M_zps`n'
			local i = `i' + 1
		}
	}

end

program define ghquad 
* stolen from rfprobit (Bill Sribney)
	version 4.0
	local n `1'
	tempname xx ww a b
	local i 1
	local m = int((`n' + 1)/2)
	matrix M_zlc`n' = J(1,`m',0)
	matrix M_zps`n' = M_zlc`n'
	while `i' <= `m' {
		if `i' == 1 {
			scalar `xx' = sqrt(2*`n'+1)-1.85575*(2*`n'+1)^(-1/6)
		}
		else if `i' == 2 { scalar `xx' = `xx'-1.14*`n'^0.426/`xx' }
		else if `i' == 3 { scalar `xx' = 1.86*`xx'-0.86*M_zlc`n'[1,1] }
		else if `i' == 4 { scalar `xx' = 1.91*`xx'-0.91*M_zlc`n'[1,2] }
		else { 
			local im2 = `i' -2
			scalar `xx' = 2*`xx'-M_zlc`n'[1,`im2']
		}
		hermite `n' `xx' `ww'
		matrix M_zlc`n'[1,`i'] = `xx'
		matrix M_zps`n'[1,`i'] = `ww'
		local i = `i' + 1
	}
	if mod(`n', 2) == 1 { matrix M_zlc`n'[1,`m'] = 0}
/* start in tails */
	matrix `b' = (1,1)
	matrix M_zps`n' = M_zps`n'#`b'
	matrix M_zps`n' = M_zps`n'[1,1..`n']
	matrix `b' = (1,-1)
	matrix M_zlc`n' = M_zlc`n'#`b'
	matrix M_zlc`n' = M_zlc`n'[1,1..`n']
/* other alternative (left to right) */
/*
	above: matrix M_zlc`n' = J(1,`n',0)
	while ( `i'<=`n'){
		matrix M_zlc`n'[1, `i'] = -M_zlc`n'[1, `n'+1-`i']
		matrix M_zps`n'[1, `i'] = M_zps`n'[1, `n'+1-`i']
		local i = `i' + 1
	}
*/
	scalar `a' = sqrt(2)
	matrix M_zlc`n' = `a'*M_zlc`n'
	scalar `a' = 1/sqrt(_pi)
	matrix M_zps`n' = `a'*M_zps`n'
end


program define hermite  /* integer n, scalar x, scalar w */
* stolen from rfprobit (Bill Sribney)
	version 4.0
	local n "`1'"
	local x "`2'"
	local w "`3'"
	local last = `n' + 2
	tempname i p
	matrix `p' = J(1,`last',0)
	scalar `i' = 1
	while `i' <= 10 {
		matrix `p'[1,1]=0
		matrix `p'[1,2] = _pi^(-0.25)
		local k = 3
		while `k'<=`last'{
			matrix `p'[1,`k'] = `x'*sqrt(2/(`k'-2))*`p'[1,`k'-1] /*
			*/	- sqrt((`k'-3)/(`k'-2))*`p'[1,`k'-2]
			local k = `k' + 1
		}
		scalar `w' = sqrt(2*`n')*`p'[1,`last'-1]
		scalar `x' = `x' - `p'[1,`last']/`w'
		if abs(`p'[1,`last']/`w') < 3e-14 {
			scalar `w' = 2/(`w'*`w')
			exit
		}
		scalar `i' = `i' + 1
	}
	di in red "hermite did not converge"
	exit 499
end


program define lebesque
	version 5.0
	local n `1'
	tempname pt a b
	scalar `a' = 1/`n'
	matrix M_zps`n' = J(1,`n',`a')
	local i = 1
	local m = int((`n' + 1)/2)
	matrix M_zlc`n' = J(1,`m',0)
	while(`i'<=`m'){
		scalar `pt' = `i'/`n' -1/(2*`n')
		matrix M_zlc`n'[1,`i']=invnorm(`pt')
		local i = `i' + 1
	}
/* start in tails */
	matrix `b' = (1,-1)
	matrix M_zlc`n' = M_zlc`n'#`b'
	matrix M_zlc`n' = M_zlc`n'[1,1..`n']
/* other alternative: left to right */
/*
	while ( `i'<=`n'){
		matrix M_zlc`n'[1, `i'] = -M_zlc`n'[1, `n'+1-`i']
		local i = `i' + 1
	}
*/
end

program define disprand
version 6.0
* displays additional information about random effects 
*disp "running disprand "
disp " "
if "e(tplv)" == ""{
	* estimates not found
	exit
}
tempname var b se cor
matrix `b' = e(b)
local names: colnames(`b')
tempname M_nrfc M_nip M_nbrf M_nffc V
matrix `V' = e(V)
matrix `M_nrfc' = e(nrfc)
matrix `M_nip' = e(nip)
matrix `M_nbrf' = e(nbrf)
matrix `M_nffc' = e(nffc)
local iscor = e(cor)
local nxt = `M_nffc'[1,colsof(`M_nffc')]+1
local free = e(free)
local tplv = e(tplv)
local lev1 = e(lev1)
local nrfold = `M_nrfc'[2,1]
if `M_nbrf'[1,1]>0{
	if `lev1' == 1 {disp in gr "Variance at level 1"}
	else if `lev1' == 2 {disp in gr "Squared Coefficient of Variation"}
	else if `lev1' == 3 {disp in gr "Dispersion at level 1"}
disp in gr "-----------------------------------------------------------------------------"
	if `M_nbrf'[1,1]==1{
		scalar `var' = exp(2*`b'[1, `nxt'])
		scalar `se' = 2*`var'*sqrt(`V'[`nxt',`nxt'])
		disp in gr "  " in ye `var' " (" `se' ")"
		local nxt = `nxt' + 1
	}
	else{
		disp " "
		if `lev1'==1{disp in gr "    equation for log-standard deviaton: "}
		else if `lev1'==2{disp in gr "    equation for log-coefficient of variation"}
		else if `lev1'==3{disp in gr "    equation for log(phi)/2"}
		disp " "
		local i = 1
		while `i' <= `M_nbrf'[1,1]{
			scalar `var' = `b'[1,`nxt']
			scalar `se' = sqrt(`V'[`nxt',`nxt'])
			local nna: word `nxt' of `names'
			disp in gr "    `nna': " in ye `var' " (" `se' ")"
			local i = `i' + 1
			local nxt = `nxt' + 1 
		}
	}
}

local lev = 2
if `free' == 1{
	disp " "
	disp in gr "Probabilities and locations of random effects"
}
else{
	disp " "
	disp in gr "Variances and covariances of random effects"
}
disp in gr "-----------------------------------------------------------------------------"
while (`lev' <= `tplv'){
	local nip = `M_nip'[1,`lev']
	local sof = `M_nrfc'[1,`lev'-1]
	disp " "
	local cl = `tplv' - `lev' + 1
	local cl: word `cl' of `e(clus)'
	disp in gr "***level `lev' (" in ye "`cl'" in gr ")"
	if `free' == 1{
		tempname M_zps`lev'
		matrix `M_zps`lev'' = e(zps`lev')
		local j = 2
		local zz=string(`M_zps`lev''[1,1],"%6.0gc")
		local mm "0`zz'"

		while `j'<=`nip'{
			local zz=string(`M_zps`lev''[1,`j'],"%6.0gc")
			local mm "`mm'" ", " "0`zz'"
			local j = `j' + 1
		}
		disp in gr "    prob: " in ye "`mm'"
	}
	local i2 = `M_nrfc'[2,`lev']
	local i = `nrfold'+1
	local num = `i2' -`i' + 1
	if `free'==0{
		* get standard errors of variances from those of cholesky decomp.
		*disp "sechol `lev' `num' `nxt'"
		qui sechol `lev' `num' `nxt' 
	}
	local k = 1
	local ii = 1
	local nrfold = `M_nrfc'[2,`lev']
	while `i'<= `i2'{
		local n=`M_nip'[2,`i']
		if `free'==1{
			tempname M_zlc`n'
			matrix `M_zlc`n'' = e(zlc`n')
			local j = 2
			local zz=string(`M_zlc`n''[1,1],"%7.0gc")
			local mm "`zz'"
			while `j'<=`nip'{
				local zz=string(`M_zlc`n''[1,`j'],"%7.0gc")
				local mm "`mm'" ", " "`zz'"
				local j = `j' + 1
			}
			disp " "
			disp in gr "    loc`ii': " in ye "`mm'"
		}
		local j = `i'
		local jj = `ii'
		while (`j'<=`i2'){
			if `free'==1{
				local m = `M_nip'[2,`j']
				capture tempname M_zlc`m'
				matrix `M_zlc`m'' = e(zlc`m')
				local l = 1
				scalar `var' = 0
				while `l'<=`nip'{		
					scalar `var' = `var' + /*
					*/ `M_zlc`n''[1,`l']*`M_zlc`m''[1,`l']*`M_zps`lev''[1,`l']
					local l = `l' + 1
				}
				if `i' == `j'{
					disp in gr "  var(`ii'): " in ye `var'
					local nb = `M_nbrf'[1,`ii'+`sof']
					if `nb'>1{
						disp " "
						disp in gr "    loadings for random effect " `ii'
						*disp in gr "    coefficient of"
						local load = 1
						while `load'<=`nb'-1{
							local nna: word `nxt' of `names'
							scalar `var'=`b'[1,`nxt']
							scalar `se' = sqrt(`V'[`nxt',`nxt'])
							disp in gr "    `nna': " in ye  `var' " (" `se' ")"
							local nxt = `nxt' + 1
							local load = `load' + 1
						}
						local nxt = `nxt' + 1
						disp " "
					}
				}
				else{
					disp in gr "cov(`ii',`jj'): " in ye `var'
				}
			}
			else{
				*disp "k= " `k' ", i= " `i' ", j= " `j' ", ii= " `ii' ", jj= " `jj'

				scalar `var' = M_cov[`ii', `jj']
				scalar `se' = sqrt(M_se[`k', `k'])
				if `i' == `j'{
					disp " "
					disp in gr "    var(`ii'): " in ye `var' " (" `se' ")"
					local nb = `M_nbrf'[1,`ii'+`sof']
					if `nb'>1{
						disp " "
						disp in gr "    loadings for random effect " `ii'
						* disp in gr "    coefficient of"
						local load = 1
						while `load'<=`nb'-1{
							local nna: word `nxt' of `names'
							scalar `var'=`b'[1,`nxt']
							scalar `se' = sqrt(`V'[`nxt',`nxt'])
							disp in gr "    `nna': " in ye `var' " (" `se' ")"
							local nxt = `nxt' + 1
							local load = `load' + 1
						}
						disp " "
					}
					local nxt = `nxt' + 1
				}
				else{
					if `iscor'==0{
						disp in gr "  cov(`ii',`jj'): " in ye "fixed at 0"
					}
					else{
						scalar `cor' = `var'/sqrt(M_cov[`ii',`ii']*M_cov[`jj',`jj'])
						disp in gr "  cov(`ii',`jj'): " in ye `var' " (" `se' ")" /*
							*/ " cor(`ii',`jj'): " `cor'
						local nxt = `nxt' + 1
					}
				}
			}

			local j = `j' + 1
			local jj = `jj' + 1
			local k = `k' + 1
		}
		local i = `i' + 1
		local ii = `ii' + 1
	}
local lev = `lev' + 1
}
disp in gr "-----------------------------------------------------------------------------"
disp " "
end

program define sechol
	version 6.0
	args lev num nxt
	* num is number of random effects
	local l = `num'*(`num' + 1)/2 
	disp "lev = `lev' num = `num' nxt = `nxt' l= `l'"
	tempname b V C L zero a H M_nbrf M_nrfc ind

	matrix `M_nbrf' = e(nbrf)
	matrix `M_nrfc' = e(nrfc)
	local iscor = e(cor)
	matrix `b' = e(b)
	matrix `V' = e(V)
	local sof = `M_nrfc'[1,`lev'-1]
	local i = 1
	local k = 1
	matrix `C' = J(`l',`l',0)
	matrix `L' = J(`num',`num',0)
	matrix `ind' = `L'
	* get L matrix
	while `i' <= `num'{
		* skip loading parameters
		local nb = `M_nbrf'[1,`i'+`sof']
		local nxt = `nxt' + `nb' -1
		matrix `L'[`i',`i'] = `b'[1, `nxt']
		matrix `ind'[`i',`i'] = `nxt'
		local nxt = `nxt' + 1
		local i = `i' + 1
	}
	local i = 2
	while `i' <= `num'&`iscor'==1{
		local j = 1
		while `j' < `i'{
			matrix `L'[`i',`j'] = `b'[1, `nxt']
			matrix `ind'[`i',`j'] = `nxt'
			local nxt = `nxt' + 1
			local j = `j' + 1
		}
		local i = `i' + 1
	}
	disp "L and ind"
	matrix list `L'
	matrix list `ind'
	* get C matrix
	local ll1 = 1
	local i = 1
	while `i' <= `num'{
	local j = 1
	while `j' <= `i'{
		local nxt1 = `ind'[`i', `j']
		local ll2 = 1
		local ii = 1
		while `ii' <= `num'{
		local jj = 1
		while `jj' <= `ii'{
			local nxt2 = `ind'[`ii', `jj']
			disp "ll1 = " `ll1' " ll2 = " `ll2' " nxt1 = " `nxt1' " nxt2 = " `nxt2'
			if `iscor' == 1{
				matrix `C'[`ll1', `ll2'] = `V'[`nxt1',`nxt2']
				matrix `C'[`ll2', `ll1'] = `C'[`ll1', `ll2']
			}
			else if `i'==`j'&`ii'==`jj'{
				matrix `C'[`ll1', `ll2'] = `V'[`nxt1',`nxt2']
				matrix `C'[`ll2', `ll1'] = `C'[`ll1', `ll2']
			}
			local ll2 = `ll2' + 1
			local jj = `jj' + 1
		}
		local ii = `ii' + 1
		}
		local ll1 = `ll1' + 1
		local j = `j' + 1
	}
	local i = `i' + 1
	}

	disp "C"
	matrix list `C'
	matrix `zero' = J(`num', `num', 0)
	local k = 1
	local i = 1
	local n = `num' * (`num' + 1)/2
	matrix `H' = J(`n',`n',0)
	while `i' <= `num' {
		local j =  1
		while `j' <= `i'{
			* derivative of LL' with respect to i,j th element of L
			mat `a' = `zero'
			mat `a'[`i',`j'] = 1
			mat `a' = `a'*(`L')'
			mat `a' = `a' + (`a')' 
			disp "a"
			matrix list `a'
			local ii = 1
			local kk = 1
			while `ii'<=`num'{
				local jj = 1
				while `jj' <= `ii'{
					matrix `H'[`kk',`k'] = `a'[`ii',`jj']
					local jj = `jj' + 1
					local kk = `kk' + 1
				}
				local ii= `ii' + 1
			}
			local j = `j' + 1
			local k = `k' + 1
		}
		local i = `i' + 1
	}
	disp "H"
	matrix list `H'
	matrix M_se = `H'*`C'*(`H')'
	matrix M_cov = `L'*(`L')'
	matrix list M_se
	matrix list M_cov
	
end



