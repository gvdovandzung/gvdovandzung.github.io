*! version 0.15  Ian White 8Aug2008
/********************************************************************************************** 
History:
version 0.15  8Aug2008
    clearer error messages when used with varname not stub; 
    mvmeta_var2mat brought back into mvmeta; 
    corr() now works with mm; 
    nouncertainv respects eform; 
    missing values reported & allowed using new options missest(), missvar(); 
    trace, report now undocumented
version 0.14  27Mar2008 
    new MM option (Dan's procedure) with details and notrunc options; 
    always returns e(Mu); 
    start(mm) enabled; 
    bscorr option outputs Sigma in sd/corr form. 
version 0.13  21Feb2008
version 0.12   5Oct2007
    new corr() option; allow abbreviated option names
version 0.11   5Jul2007
    allow new syntax from mvmeta_make: vars(numlist|namelist)
version 0.10  29Jun2007
    clearer error if no `y'# variables; nouncertainv option
version 0.9   25Jun2007
    new options bsest(fixed), longparm. SJ draft 1.
version 0.8   22Jun2007
    single equation, allows eform; corrected restricted likelihood (now agrees with SAS)
version 0.7   20Jun2007
    new syntax based on variables
version 0.6   20Jun2007
    NR using cholesky decomposition as basic parameters; 
    default start uses uncorrected DL (guaranteed to be pos def); 
    allow start(0) meaning 0.001*I;
    variable-to-matrix conversion now handled by mvmeta_var2mat.ado.
version 0.5   17May2007
    used EM and "ad hoc" iterative algorithms - neither handled perfect correlation well
**********************************************************************************************/

prog def mvmeta, eclass
version 9

syntax namelist(min=2) [if] [in], [reml ml Fixed MM Vars(varlist) TRace REPort start(string) SHOWStart SHOWChol eform(passthru) KEEPmat(namelist min=2 max=2) se longparm noUNCertainv corr(string) details notrunc bscov bscorr missest(real 0) missvar(real 1E4) *]

* undocumented options: 
*   longparm: means in p equations not 1
*   se: attempts to get standard errors on the between-studies variance matrix. Tends to fail for the 3rd or later diagonal element - bug in -nlcom-?

***************** PARSING ************************ 
tokenize "`namelist'"
local y `1'
local S `2'
mac shift 2
local xvars `*'
if "`xvars'"!="" {
    di as error "Sorry, mvmeta can't handle meta-regression yet"
    exit 498
    unab xvarlist : `xvars'
    local nxvars = wordcount("`xvars'")
}

marksample touse

local bsestcount = wordcount("`reml' `ml' `fixed' `mm'")
if `bsestcount'>1 {
     di as error "Please specify only one of reml, ml, fixed, mm"
     exit 498
}
else if `bsestcount'==0 local bsest reml
else local bsest `reml'`ml'`fixed'`mm'
if "`bsest'"=="mm" & "`trunc'"=="notrunc" local bracket (untruncated)
if "`bsest'"=="mm" & "`trunc'"=="" local bracket (truncated)
di as text "Note: using method `bsest' `bracket'"

if "`keepmat'"=="" tempname ymat Smat 
else {
    tokenize "`keepmat'"
    local ymat `1'
    local Smat `2'
}

if "`bscov'`bscorr'"=="" local bscorr bscorr

if "`corr'"!="" {
    tempvar corrvar
    gen `corrvar'=`corr'
    cap assert abs(`corr')<=1
    if _rc {
        di as error "Correlation (`corr') outside range [-1,1]."
        exit 498
    }
}

****************** SET UP *****************

preserve
qui keep if `touse'

****************** IDENTIFY VARIABLES TO USE *****************

local ylist0 = cond("`vars'"=="", "`y'*", "`vars'")
local p 0
foreach yvar of varlist `ylist0' {
    if index("`yvar'","`y'")!=1 {
        di as error "Variable `yvar' in vars() does not start with `y'"
        exit 498
    }
    cap confirm variable `yvar', exact
    if _rc {
        di as error "Variable `yvar' in vars() not found"
        exit 498
    }
    local yend = substr("`yvar'",1+length("`y'"),.)
    if "`yend'"=="" di as error "Warning: variable `yvar' not used (looking for variable names starting with `yvar')"
    else {
        * Found a valid yvar
        local ++p
        local yend`p' `yend'
        local var`p' `y'`yend'
        local yends `yends' `yend'
        local ylist `ylist' `y'`yend'
    }
}
if "`yends'"=="" {
    di as error "No variable names starting with `y' found"
    exit 498
}
if `p'>1 local plural s
di as text "Note: using variable`plural' `ylist'"

qui count if `touse'
local n = r(N)
di as text "Note: " as result `n' as text " observations on " as result `p' as text " variables"

tempname Sigma

****************** CHECK VARIANCES AND IDENTIFY COVARIANCE EXPRESSIONS *****************

forvalues r=1/`p'{
    forvalues s=`r'/`p'{
        cap confirm var `S'`yend`r''`yend`s''
        local okrs = _rc==0
        cap confirm var `S'`yend`s''`yend`r''
        local oksr = _rc==0
        if `okrs' local cov`r'`s' `S'`yend`r''`yend`s''
        else {
            if `r'==`s' {
                di as error "`S'`yend`r''`yend`s'' not found"
                exit 498
            }
            if `oksr' local cov`r'`s' `S'`yend`s''`yend`r''
            else if "`corr'"!="" {
                tempvar cov`r'`s'
                gen `cov`r'`s'' = `corrvar'*sqrt(`S'`yend`r''`yend`r''*`S'`yend`s''`yend`s'')
            }
            else {
                di as error "Neither `S'`yend`r''`yend`s'' nor `S'`yend`s''`yend`r'' found, and corr() not specified"
                exit 498
            }
        }
        if "`corr'"!="" & `s'!=`r' {
            if (`oksr'|`okrs') local corrunused 1
            if !`oksr' & !`okrs' local corrused 1
        }
        cap assert missing(`var`r'') | missing(`var`s'')
        if !_rc {
            di as error "`var`r'' and `var`s'' have no jointly observed values"
            exit 498
        }
    }
}
if "`corr'"!="" {
    if "`corrused'"=="1" & "`corrunused'"=="1" di as error "Warning: corr(`corr') used for only some covariances"
    if "`corrused'"!="1" & "`corrunused'"=="1" di as error "Warning: corr(`corr') not used"
    if "`corrused'"=="1" & "`corrunused'"!="1" di as text "Note: corr(`corr') used for all covariances"
}

****************** METHOD OF MOMENTS *****************

* NB this code uses the original variables, not the matrices just created
* NB this code is sensitive to missingness so must precede "CHECK AND REPLACE MISSING VALUES" 
if "`bsest'"=="mm" | "`start'"=="mm" {
    tempvar ok w term mmcorr
    tempname Q A B 
    foreach name in `Q' `A' `B' `Sigma' { 
        matrix `name' = J(`p',`p',.)
        matrix rownames `name' = `ylist'
        matrix colnames `name' = `ylist'
    }
    forvalues ir = 1/`p' {
        forvalues is = `ir'/`p' {
            local r `yend`ir''
            local s `yend`is''
            qui gen `ok' = !missing(`y'`r') & !missing(`y'`s') 
            qui gen `w'=1/sqrt(`cov`ir'`ir''*`cov`is'`is'') if `ok'
            qui replace `w'=0 if !`ok'
            summ `y'`r' [aw=`w'], meanonly
            local mr = r(mean)
            summ `y'`s' [aw=`w'], meanonly
            local ms = r(mean)
            qui gen `term'=`w'*(`y'`r'-`mr')*(`y'`s'-`ms') if `ok'
            summ `term', meanonly
            matrix `Q'[`ir',`is'] = r(sum)
            qui gen `mmcorr' = `cov`ir'`is''/sqrt(`cov`ir'`ir''*`cov`is'`is'') if `ok'
            summ `mmcorr', meanonly
            local sumcorr=r(sum)
            summ `mmcorr' [aw=`w'], meanonly
            local avecorr=r(mean)
            matrix `A'[`ir',`is'] = `sumcorr'-`avecorr'
            summ `w', meanonly
            local sumw=r(sum)
            summ `w' [aw=`w'], meanonly
            local avew=r(mean)
            matrix `B'[`ir',`is'] = `sumw'-`avew'
            matrix `Sigma'[`ir',`is'] = (`Q'[`ir',`is']-`A'[`ir',`is']) / `B'[`ir',`is']
            foreach name in `Q' `A' `B' `Sigma' { 
                matrix `name'[`is',`ir'] = `name'[`ir',`is']
            }
            drop `ok' `w' `term' `mmcorr'
        }
    }
    if "`details'"=="details" {
        mat list `Q', title(Q matrix)
        mat list `Sigma', title(Untruncated estimate of Sigma)
    }
    if "`trunc'"!="notrunc" {
        * truncation
        tempname evecs evals
        mat symeigen `evecs' `evals' = `Sigma'
        forvalues i=1/`p' {
            if `evals'[1,`i']<0 mat `evals'[1,`i']=0
        }
        mat `Sigma' = `evecs'*diag(`evals')*`evecs''
        mat colnames `Sigma'=`ylist'
        if "`details'"=="details" mat list `Sigma', title(Truncated estimate of Sigma)
    }
}

****************** CHECK AND REPLACE MISSING VALUES ******************

forvalues r=1/`p' {
    qui count if missing(`var`r'')
    if r(N)>0 di as text "Note: setting " r(N) " missing values of `var`r'' to `missest'"
    forvalues s=`r'/`p' {
        qui count if !missing(`var`r'') & !missing(`var`s'') & missing(`cov`r'`s'')
        if r(N)>0 {
            di as error "Error: " r(N) " missing values of cov(`y'`yend`r'',`y'`yend`s'') where `var`r'' and `var`s'' are non-missing"
            exit 498
        }
        qui count if (missing(`var`r'') | missing(`var`s'')) & !missing(`cov`r'`s'') 
        if r(N)>0 {
            if `s'>`r' di as error "Warning: ignoring " r(N) " non-missing values of cov(`y'`yend`r'',`y'`yend`s'') where `var`r'' or `var`s'' is missing"
            if `s'==`r' di as error "Warning: ignoring " r(N) " non-missing values of var(`y'`yend`r'') where `var`r'' is missing"
        }
        if `r'==`s' {
            qui summ `cov`r'`s''
            local missval = `missvar'*r(max)
        }
        else local missval = 0
        qui count if (missing(`var`r'') | missing(`var`s''))
        if r(N)>0 {
            if `s'>`r' di as text "Note: setting " r(N) " values of cov(`y'`yend`r'',`y'`yend`s'') to `missval' where `var`r'' or `var`s'' is missing"
            if `s'==`r' di as text "Note: setting " r(N) " values of var(`y'`yend`r'') to `missval' where `var`r'' is missing"
        }
        qui replace `cov`r'`s''=`missval' if (missing(`var`r'') | missing(`var`s''))
    }
    qui replace `var`r''=`missest' if missing(`var`r'')
}

****************** CONVERT VARIABLES TO MATRICES *****************

tempvar id
gen `id'=_n
qui summ `id' if `touse'
local nobs=r(max)
local imat 0
forvalues i=1/`nobs' {
    if `touse'[`i']==1 {
        local ++imat
        mat `ymat'`imat'=J(1,`p',0)
        mat rownames `ymat'`imat' = estimate
        mat colnames `ymat'`imat' = `ylist'
        mat `Smat'`imat'=J(`p',`p',0)
        mat rownames `Smat'`imat' = `ylist'
        mat colnames `Smat'`imat' = `ylist'
        forvalues r=1/`p' {
            local yvalue = `var`r'' in `i'
            mat `ymat'`imat'[1,`r'] = `yvalue'
            forvalues s=`r'/`p' {
                local Svalue = `cov`r'`s'' in `i'
                if `r'==`s' & `Svalue'==0 {
                    di as error "Zero variance detected at `S'`yend`r''`yend`s''[`i']"
                    exit 498
                }
                mat `Smat'`imat'[`r',`s']=`Svalue'
                mat `Smat'`imat'[`s',`r']=`Svalue'
            }
        }
        if `p'>1 {
            cap varcheck `Smat'`imat', check(psd) 
            if _rc==506 {
                di as error _new "Variance-covariance matrix not positive semi-definite in line `i':" _c
                mat l `Smat'`imat'
            }
            if _rc {
                exit _rc
            }
        }
    }
}

***************** STARTING VALUES FOR Mu: fixed effects estimate ***********************

tempname Mu Wysum Wsum init
mat `Wysum'=J(1,`p',0)
mat `Wsum'=J(`p',`p',0)
forvalues i=1/`n' {
    tempname W`i'
    if "`bsest'"=="mm" | "`start'"=="mm" mat `W`i'' = syminv(`Smat'`i'+`Sigma')
    else mat `W`i'' = syminv(`Smat'`i')
    mat `Wysum' = `Wysum' + `ymat'`i'*`W`i''
    mat `Wsum'  = `Wsum'  + `W`i''
}
mat `Mu' = `Wysum' * syminv(`Wsum')

***************** FIXED EFFECTS / MM RESULTS ***********************

if "`bsest'"=="fixed" | "`bsest'"=="mm" {
    tempname V
    mat `V'=syminv(`Wsum')
    ereturn post `Mu' `V', obs(`n')
    ereturn display, `eform'
    mat `Mu'=e(b)
}

***************** REML / ML *****************

if "`bsest'"=="reml" | "`bsest'"=="ml" {

    ***************** STARTING VALUES FOR Sigma *****************

    tempname Wyss chol
    if "`start'"!="" & "`start'"!="0" & "`start'"!="mm" mat `Sigma'=`start'
    else if "`start'"!="mm" {
        * Sigma = weighted variance of y's
        * don't subtract mean S (as in DerSimonian+Laird): this can give 0 and non-convergence
        mat `Wyss'=J(`p',`p',0)
        forvalues i=1/`n' {
            cap mat `chol' = cholesky(`W`i'')
            if !_rc mat `Wyss' = `Wyss' + `chol' * (`ymat'`i'-`Mu')' * (`ymat'`i'-`Mu') * `chol''
        }
        cap cholesky2 `Wyss'  `chol'
        if _rc {
            di as error "Failed to find starting values - please specify start()"
            exit 498
        }
        mat `Sigma' = `chol' * syminv(`Wsum') * `chol''
    }
    if "`start'"=="0" mat `Sigma'=0.001*`Sigma'
    cholesky2 `Sigma' `chol' 

   * FINISH OFF STARTING VALUES
    if "`showstart'"=="showstart" {
        mat colnames `Mu' = `ylist'
        mat rownames `Sigma' = `ylist'
        mat colnames `Sigma' = `ylist'
        di as text _newline "Starting value for Mu (overall mean):" _c
        mat l `Mu', noheader
        di as text _newline "Starting value for Sigma (between-studies variance):" _c
        mat l `Sigma', noheader
    }
    * combine Mu and chol into a single vector
    forvalues i=1/`p' {
         if `i'==1 mat `init' = `Mu'[1,`i']
         else mat `init' = `init', `Mu'[1,`i']
         if "`xvars'"!="" mat `init' = `init', J(1,`nxvars',0)
    }
    forvalues i=1/`p' {
         mat `init' = `init', `chol'[`i',1..`i']
    }
    
    ****************** ML *****************
    * parms to "pass" to loglik program
    global MVMETA_y `ymat'
    global MVMETA_S `Smat'
    global MVMETA_n `n'
    global MVMETA_p `p'
    global MVMETA_names `ylist'
    global MVMETA_bsest `bsest'
    
    * list equations
    if "`longparm'"=="" & "`xvars'"=="" {            /* one equation for all means */
        local eqlist1 (Overall_mean:
        forvalues i=1/`p' {
            local eqlist1 `eqlist1' `var`i''
        }
        local eqlist1 `eqlist1', nocons)
        local beqs 1
    }
    else {                        /* one equation per mean: "long parameterisation" */
        forvalues i=1/`p' {
            local eqlist1 `eqlist1' (`var`i'': `xvars')
        }
        local beqs `p'
    }
    forvalues i=1/`p' {
        forvalues j=1/`i' {
            local eqlist2 `eqlist2' (chol`var`j''`var`i'':)
        }
    }
    ml model d0 mvmeta_l `eqlist1' `eqlist2', obs(`n') collinear 
      /* makes the short parameterisation work even when some b's are collinear */
    ml init `init', copy
    if "`report'"=="report" ml report
    ml maximize, nooutput `trace' `options' /* neq(`p') fails here, not sure why */
    if "`showchol'"=="" local neq neq(`beqs')
    ml display, `eform' `neq'
   
    ****************** COMPUTE Sigma *****************
    mat `Mu'=e(b)
    mat `Mu'=`Mu'[1,1..`p']
    mat `chol'=J(`p',`p',0)
    forvalues i=1/`p' {
        forvalues j=1/`i' {
            mat `chol'[`i',`j'] = [chol`var`j''`var`i'']_b[_cons]
        }
    }
    matrix `Sigma'=`chol'*`chol''
    mat colnames `Mu' = `ylist'
    mat rownames `Sigma' = `ylist'
    mat colnames `Sigma' = `ylist'
}

****************** PRESENT Sigma (+ OPTIONAL CI) *****************

if "`bsest'"!="fixed" {
    tempname Corr SD all
    cap mat `Corr'=corr(`Sigma')
    if _rc local bsprob 1
    cap mat `SD'=vecdiag(cholesky(diag(vecdiag(`Sigma'))))'
    if _rc local bsprob 1
    else mat colnames `SD'="SD"
    if "`bsprob'"=="1" {
        di as error _newline "Warning: can't compute between-studies SDs and correlation matrix"
        di as error "        (probably because one or more variances are zero)" _c
        local bscov bscov
        local bscorr
    }
    if "`bscov'"=="bscov" {
       di as text _newline "Estimated between-studies covariance matrix Sigma:" _c
       mat l `Sigma', noheader
    }
    if "`bscorr'"=="bscorr" {
        mat `all'=(`SD', `Corr')
        di as text _newline "Estimated between-studies SDs and correlation matrix:" _c
        mat l `all', noheader
    }
}

if ("`bsest'"=="reml" | "`bsest'"=="reml") {
    if "`se'"=="se" {
        di as text _newline "Attempting to get confidence intervals for Sigma"
        di as text `"(note: often fails with message "Maximum number of iterations exceeded".)"'
        forvalues i=1/`p' {
            forvalues j=1/`i' {
                local nlcom `Sigma'`j'`i':
                forvalue k=1/`j' {
                    local plus=cond(`k'>1,"+","")
                    local nlcom `nlcom' `plus' [chol`var`k''`var`i'']_b[_cons]*[chol`var`k''`var`j'']_b[_cons]
                }
                nlcom `nlcom'
            }
        }
    }
   
    if "`uncertainv'" == "nouncertainv" {
        di as text _newline "Alternative standard errors, ignoring uncertainty in V:"
        tempname b I
        mat `b' = e(b)
        mat `b' = `b'[1,1..`p']
        mat `I' = syminv(e(V))
        mat `I'=`I'[1..`p',1..`p']
        mat `I' = syminv(`I')
        ereturn post `b' `I'
        ereturn display, `eform'
    }
}

***************** TIDY UP *****************

global MVMETA_y 
global MVMETA_S 
global MVMETA_n 
global MVMETA_p 
global MVMETA_names
global MVMETA_bsest 

***************** RETURN RESULTS *****************

ereturn matrix Mu=`Mu'
if "`bsest'"!="fixed" {
    ereturn matrix Sigma=`Sigma'
    if "`bsprob'"!="1" {
        ereturn matrix Sigma_corr = `Corr'
        ereturn matrix Sigma_SD = `SD'
    }
}
end


prog def cholesky2
* produce an approximate cholesky decomposition, even if matrix is not positive definite
args M C
mat _M=`M'/**/
cap matrix `C' = cholesky(`M')
if _rc {
    local eps = trace(`M')/1000
    if `eps'<=0 {
        di as error "cholesky2: matrix `M' has non-positive trace"
        matrix list `M'
        return 498
    }
    local p = rowsof(`M')
    cap matrix `C' = cholesky(`M'+`eps'*I(`p'))
    if _rc {
        di as error "cholesky2: can't decompose matrix `M'"
        matrix list `M'
        return 498
    }
}
end





prog def varcheck
syntax anything, [check(string)]
_getcovcorr `anything'
if "`check'"!="" {
tempname evecs evals
mat symeigen `evecs' `evals' = `anything'
local dim = colsof(`evals')
local mineigen .
forvalues i=1/`dim' {
    local mineigen = min(`mineigen',`evals'[1,`i'])
}
if "`check'"=="psd" {
    if `mineigen'<0 {
        di as error "`anything' is not positive semi-definite"
        exit 506
    }
}
else if "`check'"=="pd" {
    if `mineigen'<=0 {
        di as error "`anything' is not positive definite"
        exit 506
    }
}
else {
    di as error "varcheck: check(`check') invalid"
    exit 498
}
}
end
