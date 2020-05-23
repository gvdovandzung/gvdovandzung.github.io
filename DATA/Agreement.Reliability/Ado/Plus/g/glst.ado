version 9
mata 
function covariances(string scalar betas, string scalar doses, string scalar ses, string scalar tot, string scalar cases, real scalar study)
{
	real colvector  b, dose, se, n, A,  V, cx , ex, sx, sx_1, fitcontrols, SE
	real scalar i, m1, N, n0, api, a0i, SINCR, DCA, NUMCOR  
	real matrix H1 , H2, AP, INCR, A1, C, X, PASSA, PASSN, R

	st_view(b=., ., betas, .)
	st_view(dose=., ., doses, .)
	st_view(se=., ., ses, .)
	st_view(n=., ., tot, .)
	st_view(A=., ., cases, .)

	V = se:*se

	// get some number of cases and total obs
	
	m1 = colsum(A)
	N = colsum(n)
	n0 = n[1]
        
	// Loop until converence (no more changes of fitted cases) 

	SINCR = 1

while (abs(SINCR)>1e-5) {

	api = colsum(A[|2,1 \ ., .|])
	a0i = m1 - api
 	ex = J(rows(A), 1,.)
  

	if (study==1) {      
		cx = (1:/A) + 1:/(n:-A)	
  		for (i=2; i<=rows(A); i++) {
			ex[i] = b[i] + log(a0i)+log(n[i]-A[i])-log(A[i])-log(n0-a0i)
		}
	}

	if (study==2|study==3) {      
		cx = (1:/A)  
  		for (i=2; i<=rows(A); i++) {
			ex[i] = b[i] + log(m1-api)+log(n[i])-log(A[i])-log(n0)
		}
	}

      H1 = J(rows(A)-1,rows(A)-1,cx[1])
	H2 = diag(cx) 	
      H = H1 + H2[|2,2\. , .|]

      AP = A[|2,1 \ ., .|] + invsym(H)*ex[|2,1 \ ., .|]
 
	INCR = invsym(H)*ex[|2,1 \ ., .|] 
 
	SINCR = colsum(INCR)
 
	DCA = m1-sum(AP) 

	// New colvector of fitted cases
	A  = (DCA \ AP)
}

// Covariances and correlations

	fitcontrols = n :- A 	
      sx = J(rows(A), 1,.)
	
	// case-control 

	if (study==1) {   
      		sx_1  = sqrt(1:/A :+ 1:/fitcontrols :+ 1/A[1] :+ 1/fitcontrols[1]) 
	}

	// cohort data with person-time

	if (study==2) {   
      		sx_1  = sqrt(1:/A :+  1/A[1]) 
	}

	// cohort data with person 

	if (study==3) {   
      		sx_1  = sqrt(1:/A :- 1:/n :+ 1/A[1] :- 1/n0) 
	}
 
	sx = sx_1[|2,1 \ ., .|]
      C = diag(V[|2,1 \ ., .|])
	SE = diagonal(sqrt(C))

	if (study==1) {   
      		NUMCOR  = (1/A[1] + 1/fitcontrols[1])
	}

	if (study==2) {   
      		NUMCOR  = (1/A[1]) 
	}

	if (study==3) {   
      		NUMCOR  = (1/A[1] - 1/n0) 
	}
	
// fill in the variance-covariance matrix

	for (j =1; j<=rows(C); j++) {
	 		for (i =1; i<=rows(C); i++) {	
		  		if  (i != j)  C[i,j] =  ( NUMCOR / ( sx[j]*sx[i]) ) * (SE[j]*SE[i])   
   			}
	}

// fill in the correlation matrix

      R = J(rows(C), cols(C),1)
 
	for (j =1; j<=rows(R); j++) {
	 		for (i=1; i<=rows(R); i++) {	
		  		 if  (i != j)  R[i,j] =  ( NUMCOR / ( sx[j]*sx[i]) )  
 		  		// if  (i != j)  R[i,j] =  ( C[i,j] / (SE[j]*SE[i])   )  
  			}
	}


PASSA = A
st_matrix("r(fitA)", PASSA)
st_matrix("r(C)", C)
st_matrix("r(R)", R)
}

function glsest(string scalar y, string scalar x, string scalar cov)
{
	real matrix Y, X, C, BC, VB
	real scalar Q, LL 
	Y = st_matrix(y)
	X = st_matrix(x)
	C = st_matrix(cov)
 
// Variance and betas

	VB = invsym(X'*invsym(C)*X)
	BC = invsym(X'*invsym(C)*X)*X'*invsym(C)*Y
 
// Q goodness of fit

 	Q = (Y-X*BC)'*invsym(C)*(Y-X*BC)
	C2 = diag(C)

// log-likelihood

	LL =  -.5*rows(Y)*log(2*pi())-.5*log(det(C))-.5*Q

/*
	printf("1 %g\n", -.5*rows(Y)*log(2*pi()) )
	printf("2 %g\n",-.5*log(det(C))  )
	printf("det(C) %g\n", det(C)  )
	printf("3 %g\n",-.5*Q )
	printf("4 %g\n", LL )
*/
 
	/* alternative
	LL =  -rows(Y)/2*log(2*pi())-.5*log(det(C))-.5*Q
      LL2 = log( (2*pi())^(-.5*rows(Y))*det(C)^(-.5)*exp(-.5*(Q)))
      printf("LL2 %g\n", LL2 )
	*/

	st_matrix("r(BC)", BC)
	st_matrix("r(VB)", VB)
	st_numscalar("r(Q)", Q)
	st_numscalar("r(LL)", LL)
	st_matrix("r(COVAR)", C)
}

function crudest(string scalar logrr, string scalar cases, string scalar tot, real scalar study)
{
	real colvector n, A, EXPB, B, OT, COVBV 
	real scalar M_DIFF_C_A_RR
	real matrix C, R

	st_view(n=., ., tot, .)
	st_view(A=., ., cases, .)
	st_view(LRR=., ., logrr, .)
	
	RR = exp(LRR)

	OT = n - A

	// estimate crude beta coefficients

	if (study==1) {  
      		EXPB = (A:*OT[1]):/(A[1]:*OT) 
	}

	if (study==2|study==3) {    
      		EXPB = (A:*n[1]):/(A[1]:*n) 
	}

	B = log(EXPB)

	// estimate covariances of the crude beta coefficients
	
	if (study==1) {   
      		COVB  = (1/A[1] + 1/OT[1])
	}

	if (study==2) {   
      		COVB  = (1/A[1]) 
	}

	if (study==3) {   
      		COVB  = (1/A[1] - 1/n[1]) 
	}
	
	COVBV = J(rows(A)-1,rows(A)-1,COVB)
	COVBV = COVBV -  diag(COVBV)

	// estimate variances of the crude beta coefficients
     
	sx = J(rows(A), 1,.)

	if (study==1) {   
      		sx_1  =  (1:/A :+ 1:/OT :+ 1/A[1] :+ 1/OT[1] )
	}

	if (study==2) {   
      		sx_1  =  (1:/A :+  1/A[1])  
	}

	if (study==3) {   
      		sx_1  =   (1:/A :- 1:/n :+ 1/A[1] :- 1/n[1])
	}
      
	sx = sx_1[|2,1 \ ., .|]

      C = diag(sx[|1,1 \ ., .|])
 
	C = C + COVBV

	// estimate correlation matrix of the crude beta coefficients

      R = J(rows(C), cols(C),1)
 
	for (j =1; j<=rows(R); j++) {
	 		for (i=1; i<=rows(R); i++) {	
		  	 	// if  (i != j)  R[i,j] = COVB / sqrt(C[i,j]*C[j,i]) 
				if  (i != j)  R[i,j] = COVB / sqrt(sx[j]*sx[i])  
  			}
	}
	
	// relative comparison between crude and adjusted relative risks (check assumption 1)
	// (crude RR - adjusted RR)/ crude RR * 100

	DIFF_C_A_RR =   (EXPB :- RR):/(EXPB) * 100

	// this provides the percentage of the crude relative risks to be added or subtracted, depending on its
      //  positive or negative sign to the crude relative risks to get the adjusted relative risks 

	// calculate the average relative change (from crude to adjusted)  
      // of the relative risks at different exposure level  

	M_DIFF_C_A_RR = mean( abs(DIFF_C_A_RR[|2,1 \ ., .|] ) )

	// I'll also get the maximum and minimum relative change (excluding the referent relative risk)

	st_matrix("r(RD_C_A)", DIFF_C_A_RR)
	st_numscalar("r(M_RD_C_A)", M_DIFF_C_A_RR)
	st_matrix("r(CR_C)", C)
	st_matrix("r(CR_R)", R)
	st_matrix("r(CR_B)", B)
	st_matrix("r(CR_EXPB)", EXPB)
	st_matrix("r(ADJ_EXPB)", RR)
	st_numscalar("r(RD_max)", max(DIFF_C_A_RR[|2,1\.,1|]) )
	st_numscalar("r(RD_min)", min(DIFF_C_A_RR[|2,1\.,1|]) )
}

function boundscov(string scalar a, string scalar u)
{
	real matrix AD, UN, DIF, ADL, ADU
	real colvector VDIF
	AD = st_matrix(a)
	UN = st_matrix(u)
	DIF = AD - UN
	VDIF = diagonal(DIF)
       
	// create initial values or lower and upper var-cov matrix
	ADL = AD
	ADU = AD

	// replace the off-diagonal elements with a lower and upper limits
	// as described by Berrington and Cox (Biostatistics, 2003) 

  	for (j=1; j<=rows(AD); j++) {
		
  		for (k=1; k<=rows(AD); k++) {
 
			// In the unlikely case (mistake) that the adjusted variance is lower than the un-adjusted variance
			// in such case we force to zero the covariance

						 if (j!=k) {
								ADL[j, k] = AD[j,k]-sqrt(VDIF[j]*VDIF[k]) 
							 	if (ADL[j, k] == .) ADL[j, k] = AD[j,k]
						 }

						 if (j!=k) {
								ADU[j, k] = AD[j,k]+sqrt(VDIF[j]*VDIF[k]) 
						 		if (ADU[j, k] == .) ADU[j, k] = AD[j,k]
						 }
		}
	}
 
	st_matrix("r(UB_C)", ADU)
	st_matrix("r(LB_C)", ADL)	
}

function blockaccum(string scalar a, string scalar b) 
{	
	real matrix A, B, GA
	A = st_matrix(a)
	B = st_matrix(b)
	GA = blockdiag(A,B)
	st_matrix("r(CACC)", GA)
}

function iterativegls(string scalar y, string scalar b, string scalar x, string scalar cov, real scalar q, real scalar n, real scalar p)
{
	real matrix Y, B, X, C, W, YH,  D
 	real scalar tau2, diff, lastau2, stopiter

	Y = st_matrix(y)
	B = st_matrix(b)
	X = st_matrix(x)
	C = st_matrix(cov)
 

// just get the dose variable, the first in the linear predictor

XL = X[.,1]
 
// moment-based estimator of tau2 (between-slope variance)
	// (q, n, p)
	// ( q - (n-p) ) 
	// ( trace(invsym(C)) - trace( invsym(C)*X*invsym(X'*invsym(C)*X)*X'*invsym(C) )  )
	tau2 = ( q - (n-p) ) / ( trace(invsym(C)) - trace( invsym(C)*X*invsym(X'*invsym(C)*X)*X'*invsym(C) )  )
	tau2 = max((tau2, 0))
 	// printf("Starting tau2=%g\n", tau2)	 

// loop until convergence for tau2 

diff = tau2

// if there is not heterogenity (tau2=0) there is no need to loop

if (diff==0) {
	// Variance and betas

 	VB = invsym(X'*invsym(C)*X)
 	BC = invsym(X'*invsym(C)*X)*X'*invsym(C)*Y
 
	// Q goodness of fit
 	q = (Y-X*BC)'*invsym(C)*(Y-X*BC)
}

      // printf("Initial diff=%g\n", diff)	 
      // printf("Initial tau2=%g\n", tau2)	 

i = 1
D = C

while (diff>1e-5)  {
 
	//  printf("i=%g\n", i)

	lastau2 = tau2
 
	// this should be done for each study and then re-create the block diagonal
 
	C = D + tau2*XL*XL'
 
	// replace to 0 out of the diagonal block - I'm sure this can be done in a better efficient way

		for (j =1; j<=rows(C); j++) { 	
	 		for (k =1; k<=rows(C); k++) {	
		  		if (D[k,j]==0)  {
					 C[k,j]=0
				}
	   		}
		}

 	// Variance and betas

 	VB = invsym(X'*invsym(C)*X)
 	BC = invsym(X'*invsym(C)*X)*X'*invsym(C)*Y
 
	// Q goodness of fit

 	q = (Y-X*BC)'*invsym(C)*(Y-X*BC)


	// tau2
	tau2 = ( q - (n-p) ) / ( trace(invsym(C)) - trace( invsym(C)*X*invsym(X'*invsym(C)*X)*X'*invsym(C) )  )
	tau2 = max((tau2, 0))

	if (tau2 != 0) {
				diff = abs(tau2 - lastau2)
				stopiter = 0
	}
	else {
		diff = 0
		stopiter = 1
	}
	   	
	  // printf("stop=%g\n", stopiter)	 
   	  // printf("diff=%g\n", diff)	 
  	  // printf("tau2=%g\n", tau2)	 
	i++
} 

// if the loop has been stopped because tau2 < 0 then the results will be equal to fixed-effects

if (stopiter==1) {
	// I have to go back to original sigma
	 C = D 

	// Variance and betas

 	VB = invsym(X'*invsym(C)*X)
 	BC = invsym(X'*invsym(C)*X)*X'*invsym(C)*Y
 
	// Q goodness of fit
 	q = (Y-X*BC)'*invsym(C)*(Y-X*BC)
}


//printf("convergence done\n")

//   (BC, sqrt(VB))
//   (tau2, q)

// get the log-likelihood

	LL =  -.5*rows(Y)*log(2*pi())-.5*log(det(C))-.5*q

	// LL =  log( (2*pi())^(-.5*rows(Y))*det(C)^(-.5)*exp(-.5*(q)))

	st_matrix("r(C)", C)
	st_matrix("r(BC)", BC)
	st_matrix("r(VB)", VB)
	st_numscalar("r(Q)", q)
	st_numscalar("r(tau2)", tau2)
	st_numscalar("r(LL)", LL)

} 


function checklowhigh(string scalar sl, string scalar su)
{
	real matrix cov_cru, cov_adj, zero, diffca, low, high
 	real scalar nc, meandiffca
	cov_cru = st_matrix(sl)
	cov_adj = st_matrix(su)	

	// number of covariances

	nc = (rows(cov_cru)*rows(cov_cru)-rows(cov_cru)) /2
	lw = 0
	uw = 0

 	zero = J(rows(cov_cru), cols(cov_cru),0)
	low = J(rows(cov_cru), cols(cov_cru),0)
	high = J(rows(cov_cru), cols(cov_cru),0)

	// relative differences between crude and adjusted elements 

      diffca = abs((cov_cru:-cov_adj):/cov_cru)*100
	
	// initialize a vector to containing off-diagonal elements

	corr = J(nc,1,0)
	s = 1

	// check if cov_cru <=> cov_adj

  	for (j=1; j<=rows(cov_cru); j++) {
		
  		for (k=1; k<=rows(cov_cru); k++) {

						 zero[j,k] = 1

						 if (j!=k)  { 
 
						     if (zero[j,k]!=1 | zero[k,j]!=1 )  {

 								corr[s++,1] = diffca[j,k] 			
								
								if (cov_cru[k,j]<cov_adj[k,j]) {	
												//  printf("Crude<Adjusted")								
												// (j, k, cov_cru[j,k], cov_adj[j,k])
												low[k,j]=1
												++lw
								}
								if (cov_cru[k,j]>=cov_adj[k,j]) {
												//  printf("Crude>=Adjusted")								
												//  (j, k, cov_cru[j,k], cov_adj[j,k])	
												high[k,j]=1
												++uw
								}					
						  	}		
						 }
		}
	} 
 
meandiffca = mean(corr[|1,1 \ ., .|] )
 
st_matrix("r(diffca)", diffca)	
st_numscalar("r(meandiffca)", meandiffca)	

st_numscalar("r(nc)", nc)
st_numscalar("r(lw)", lw)
st_numscalar("r(uw)", uw)	
st_matrix("r(low)", low)	
st_matrix("r(high)", high)	
}


end


****************************************************************************************************************************
 

*! N.Orsini v.1.0.0 18may2005 - Version 8
*! N.Orsini v.2.0.0 16aug2005 - Version 9 
*! N.Orsini v.3.0.0 28oct2005 - Version 9 
*! N.Orsini v.4.0.0 16nov2005 - Version 9  
*! N.Orsini v.5.0.0 20dec2005 - Version 9  
*! N.Orsini v.6.0.0 22aug2006 - Version 9.2  
*! N.Orsini v.7.0.0  9may2009 - Version 9.2  

capture program drop glst
program glst, eclass
version 9.2

	if replay() {

		if "`e(cmd)'"!="glst" {
			`e(cmd)' `0'
			error 301
		}	

		Display `0'
		exit
	}

syntax varlist (min=2) [if] [in] , Se(varname numeric) Cov(varlist numeric min=2) ///
[ cc ir ci  PFirst(varlist numeric min=2) Level(integer $S_level)  eform  LBCov(string) UBCov(string) CRudes Random vwls TStage(string) SSest ] 

// check estimation method - random-effects is allowed only with multiple studies

if "`pfirst'" == "" & "`random'" != "" {
	di as err "random-effects model are allowed only with multiple studies, specify the option pfirst()"
	exit 198
	} 

if "`pfirst'" != "" & "`crudes'" != "" {
	di as err "crude estimates are provided only for a single study, do not specify the option pfirst()"
	exit 198
	} 

// check that the two-stage method is specified with multiple studies

if "`pfirst'" == "" & "`tstage'" != "" {
	di as err "specifies the option pfirst()"
	exit 198
	} 

// check the two-stage method (fixed or random).

if  "`tstage'" != "" {
	* di "`tstage'"
	if inlist("`tstage'", "f", "r") != 1 {
		di in red "choose either fixed (f) or random (r) effects two-stage meta-analysis with the option tstage() "
		exit 198
	} 
}

if "`random'" != "" & "`tstage'" != "" {
	di as err "take out the option random when specifying the option tstage()"
	exit 198
	} 


// check methods for the confidence bounds of the covariances 

	if "`lbcov'"!=""  & "`ubcov'"!="" { 
		di in red "choose lbcov() or ubcov() otpion"
		exit 198
	} 	

	if "`lbcov'"!="" {
	confirm integer number `lbcov'

	if inrange(`lbcov', 1, 3) != 1 {
		di in red "choose method either 1,2, or 3 for the option lbcov() "
		exit 198
	} 	
	else {	
		global lbcov = `lbcov'
		global lbounds = "yes"	
		global ubcov = 0
	}	

	}

	if "`ubcov'"!="" {
	capture confirm integer number `ubcov'
	if inrange(`ubcov', 1, 3) != 1 {
		di in red "choose method either 1,2, or 3 for the option ubcov() "
		exit 198
	}
	else {
		global ubcov = `ubcov'
		global ubounds = "yes"
		global lbcov = 0

	}	

	} 	

// check study design (single study)

if "`pfirst'" == "" {

	if "`cc'"=="" & "`ir'"=="" & "`ci'"==""  {
		di in red "choose cc or ir  or ci "
		exit 198
	} 	

	if "`cc'"!="" & "`ir'"!="" & "`ci'"!="" { 
		di in red "choose cc or ir or ci "
		exit 198
	} 	

	if  "`ir'"!="" & "`ci'"!="" { 
		di in red "choose ir or ci "
		exit 198
	} 	

	if "`cc'"!="" & "`ir'"!="" { 
		di in red "choose cc or ir  "
		exit 198
	} 	

	if "`cc'"!=""  & "`ci'"!="" { 
		di in red "choose cc or ci "
		exit 198
	} 	



	if  "`ir'"!="" { 
 		local ptcohort = "ptcohort"
	} 	

	if  "`cc'"!="" { 
 		local casecontrol = "casecontrol"
	} 	

	if  "`ci'"!="" { 
 		local pecohort = "pecohort"
	} 
}	


// check level 

	if `level' < 10 | `level' > 99 {
		di in red "level() must be between 10 and 99 inclusive"
		exit 198
	}

	tempname levelci 

	global levelp  = `level'/100
	scalar `levelci' = `level' * 0.005 + 0.50
 	global levelci = `level' * 0.005 + 0.50

// to use the option if/in  
	
	marksample touse, strok novarlist

      global touse = `touse'

// check observation
 
	qui count if `touse'
	local nobs = r(N)

		if `nobs'== 0 {
				di in red "no observations"
				exit 2000
		}
		 
		if `nobs'== 1 {
				di in red "insufficient number of observations"
				exit 2001
		}

// Parsing input variables

		tempvar b dose n case control v
quietly {
	 	tokenize `varlist'
		local depname = "`1'"
            mac shift
            local xname `*'
		local ncov : word count  `xname' 

		gen double `v' = `se'^2 if `touse'
		parse "`varlist'" , parse(" ")
		gen double `b' = `1' if `touse'
		gen double `dose' = `2' if `touse'

// check number of covariates and number of observations

	qui count if `touse'

	local nobstouse = r(N)-1

	if `ncov' > `nobstouse' {
				 di in r "number of covariates greater than the number of observations"
				 exit 198
	}

// get the variables required to  

	if "`cov'"!=""  { 
             	parse "`cov'" , parse(" ")
			gen double `n' = `1' if `touse'
			gen double `case' = `2' if `touse'
			capture confirm numeric var  `n'
			capture confirm numeric var  `case'
	}


	if "`pfirst'"!=""  { 
			local multiple = "multiple"
			tempvar id typestudy
             	parse "`pfirst'" , parse(" ")
			clonevar `id' = `1' if `touse'
			gen double `typestudy' = `2' if `touse'
			capture confirm numeric var  `id'
			capture confirm numeric var  `typestudy'
			capture assert (`typestudy' == 1) | (`typestudy' == 2) | (`typestudy' == 3) if `touse'

			if _rc != 0 {
				di _n as err "variable `2' cant take only value 1 (cc), 2 (ir), or 3 (ci)" 
			}
	}

} // end quietly


// Multiple studies 

if "`pfirst'" != "" {

global loglik  0 

local i = 1


	if "`tstage'"!= "" {
       			tempvar ltb ltvar 
				qui gen `ltb' = .
				qui gen `ltvar' = .
	}

* // Warning message when assuming zero-correlations 
* if "`vwls'" != "" di _n in g "Assuming zero-correlation within each set of log relative risks"

qui levelsof `id' , local(studies)

	qui tab `pfirst' if `touse'
	local nstudies = r(r)
	
	local countstudy = 1
 
	foreach study of local studies {    

	varcov `varlist' if `id' == `study' & `touse', s(`se') tot(`n') c(`case')  ///
	  ts(`typestudy')  `crudes'  `vwls'  

	// required step for the two-stage meta-analysis
	
       	tempname M_bc M_vc
		* get beta and variance of the linear trend
		mat `M_bc' = r(BC)
		mat `M_vc' = r(VB)		
		scalar sltb`i' =  `M_bc'[1,1]
		scalar sltvar`i' =  `M_vc'[1,1]


		// display study-specific linear trends, std error and 95% CI
		
		if "`ssest'" != "" {
		local fmt = "%9.0g"
		local labstudy : label (`id') `study'
			if `countstudy' == 1 {
				di _n in g "Study-specific linear trend estimates"
				di "{dup 78:-}"
				di in g   _col(8) "Study"  _col(21) "Coef."  _col(29) "Std. Err." _col(44) "z"  ///
				 _col(49) "P>|z|"    _col(59) "[95% Conf. Interval]" 
				di "{dup 13:-}{c TT}{dup 64:-}"
				di in g  _col(5) %8s abbrev("`labstudy'",8)  _col(14) "{c |}" in y _col(17) `fmt' sltb`i'  _col(28) `fmt' sqrt(sltvar`i') _col(41) %3.2f sltb`i'/sqrt(sltvar`i')  ///
				 _col(49) %4.3f [1- norm(abs(sltb`i'/sqrt(sltvar`i') ) )]*2   _col(59) `fmt' sltb`i'-invnorm(`levelci')*sqrt(sltvar`i') `fmt' _col(69) sltb`i'+invnorm(`levelci')*sqrt(sltvar`i')
			}
			else {
				di in g  _col(5) %8s abbrev("`labstudy'",8)  _col(14) "{c |}" in y _col(17) `fmt' sltb`i'  _col(28) `fmt' sqrt(sltvar`i') _col(41) %3.2f sltb`i'/sqrt(sltvar`i')  ///
				 _col(49) %4.3f [1- norm(abs(sltb`i'/sqrt(sltvar`i') ) )]*2   _col(59) `fmt' sltb`i'-invnorm(`levelci')*sqrt(sltvar`i') `fmt' _col(69) sltb`i'+invnorm(`levelci')*sqrt(sltvar`i')
			}
			if `countstudy' == `nstudies' di in g "{dup 13:-}{c BT}{dup 64:-}"

		}

      local countstudy = `countstudy' + 1
	mat C = r(C)
	mat G`i' = C 
	scalar col`i' = colsof(G`i')

	local i = `i' + 1
	}

preserve // I could take out this! 

tempvar ids
tempname X L G

quietly {
sort `pfirst', stable
bys `pfirst' :   gen `ids' = cond(_n == 1, 0, 1) 
keep if `ids' == 1 & `touse'
mkmat `xname', matrix(`X')
mkmat `depname'  , matrix(`L')
} 



// stop if random-effects are required with only one study! 
 
if "`pfirst'" != "" & "`random'" != "" & `nstudies' == 1 {
	di as err "random-effects model are allowed with multiple studies"
	exit 198
	}

* create a block-diagonal matrix using my blockaccum mata function

quietly {

local i = 1

forv l = 1(1)`nstudies' {

if `i' == 1 {
		mat PG = G`i'
		}

if `i' != 1 {		
		mata: blockaccum("PG","G`l'")
		mat PG = r(CACC)
		}
local ++i
}

mat `G' = PG

} // end quietly

// Generalized Least Squares Estimation  

tempvar b  
tempname V BETAS b COV tau2 Q ll

* just change colnames

* noisily di _n in w "Call Mata glsest()"

mata: glsest("`L'", "`X'", "`G'")
mat `G' = r(COVAR)
mat `V' =  r(VB)
mat `b'  = r(BC)'
scalar `Q' = r(Q)
 
local  Q =  `Q' 
local obs = c(N)

// Random-effects estimation 

if "`random'"  != "" {

* noisily di _n in w "Call Mata iterativegls()"

mata: iterativegls("`L'", "`b'","`X'", "`G'", `Q', `obs', `ncov')
scalar `tau2' = r(tau2)
eret scalar tau2 = r(tau2)
}

mat `COV' = r(C)
mat `b' = r(BC)'
mat `V' = r(VB)  

global loglik = r(LL)
eret scalar ll = r(LL)
eret scalar chi2_gf = r(Q)
 
// two-stage fixed and random effects meta-analysis

if "`tstage'" != "" {

	* create a variable with beta and its variance

	forv i = 1(1)`nstudies' {
		qui replace `ltb' = sltb`i' in `i'
		qui replace `ltvar' = sltvar`i' in `i'
	}

	* two-step method

	tempvar w hat v resid tobeused constantone

	qui gen `constantone' = 1	
	qui gen `tobeused' = `ltb' != . 

	tempname  sumw  tau2  b V Q df_Q 
	
	* use method-of-moments 

	qui gen double `w'=1/`ltvar' 
	summ `w' , meanonly
	scalar `sumw'=r(sum)

	* di in w "two-stage fixed-effects meta-analysis"

	* list `idstudy' `ltb' `ltvar'  if `tobeused'

	qui regress `ltb' `constantone' [iw=`w'] if `tobeused' , mse1 noconstant
	qui predict `hat' if `tobeused', hat
	qui replace `hat'=`hat'*`w'^2  
	scalar `df_Q' = `nstudies' - 1
	scalar `Q' = e(rss)
	summ `hat', meanonly
	scalar `tau2' = max( (`Q' - `df_Q') / ( `sumw' - r(sum) ), 0) 

	if "`tstage'" == "r" {

	* di in w "two-stage random-effects meta-analysis"

	qui gen double `v' = `ltvar' + `tau2'
	qui regress `ltb' `constantone'  [iw=1/`v'], mse1 noconstant
	}

	matrix `b' = e(b)
	matrix `V' = e(V)
	local df_m = e(df_m)
      local df = `nstudies'-1
	}


} // end multiple studies
 
// single study

if "`pfirst'" == "" {

/* check standard error not equal to zero

capture assert `se' != 0 

	if _rc != 0 { 
		di as err "standard errors equal to zero are not allowed"
		exit 198
	}
*/

varcov `varlist' `if' `in' , s(`se') tot(`n') c(`case') ///
 `pecohort' `ptcohort' `casecontrol' `crudes'  `vwls'

global loglik = r(ll)
 
tempname b V COV R 

local obs = r(N)
mat `COV' = r(C)
mat `R' = r(R)
 
mat `b' = r(BC)'
mat `V' = r(VB)  
 
if "`crudes'" != "" {
 
	tempname RD_min RD_max CR_C CR_EXPB CR_B RD_C_A M_RD_C_A CR_R ADJ_EXPB MEANDIFF_C_A DIFF_C_A
	mat `CR_C' = r(CR_C)
	mat `CR_R' = r(CR_R)
	mat `CR_EXPB' = r(CR_EXPB)
	mat `ADJ_EXPB' = r(ADJ_EXPB)
	mat `CR_B' = r(CR_B)
	mat `RD_C_A' = r(RD_C_A)
 	scalar `RD_min' = r(RD_min)
	scalar `RD_max' = r(RD_max)
	scalar `M_RD_C_A' = r(M_RD_C_A) 
	scalar `MEANDIFF_C_A' = r(MEANDIFF_C_A) 
	mat `DIFF_C_A' = r(DIFF_C_A) 
}

}

// Saved results

mat rownames `b' = `depname'
mat colnames `b' = `xname'

mat rownames `V' = `xname'
mat colnames `V' = `xname'


if "`tstage'" != "" {
ereturn post `b' `V' , dep(`depname') obs(`nstudies') esample(`tobeused')  
	ereturn scalar tau2 = `tau2'
	ereturn scalar df_m = `df_m'
	ereturn scalar Q = `Q'
	ereturn scalar df_Q = `df_Q'
	tempname sp_betas sp_var_betas
	mkmat `ltb' if `ltb' != . , matrix(`sp_betas') 
	mkmat `ltvar' if `ltb' != . , matrix(`sp_var_betas') 
      mat colnames `sp_betas' = c1
	mat colnames `sp_var_betas' = c1
	ereturn matrix sp_betas = `sp_betas'
	ereturn matrix sp_var_betas = `sp_var_betas'
}
else {
local df = `obs' - rowsof(`V')
tempvar tousecopy 
gen `tousecopy' = `touse'
ereturn post `b' `V' , dep(`depname') obs(`obs') esample(`touse')  
}

if "`crudes'" != "" {
	ereturn matrix C_Sigma  =`CR_C'
	ereturn matrix C_R  =`CR_R'
	ereturn matrix C_y  =`CR_B'
	ereturn matrix C_expy  =`CR_EXPB'
	ereturn matrix A_expy  =`ADJ_EXPB'
	ereturn matrix RD_C_A = `RD_C_A'
	ereturn scalar RD_min = `RD_min'
	ereturn scalar RD_max = `RD_max'
	ereturn scalar M_RD_C_A = `M_RD_C_A'

  	ereturn scalar MEANDIFF_C_A = `MEANDIFF_C_A'
	ereturn matrix DIFF_C_A = `DIFF_C_A'
}

if "`pfirst'" == "" {
	ereturn matrix Sigma = `COV'
	ereturn matrix R = `R'

}
else {
	ereturn matrix Sigma = `G'
}

if "`random'" != "" {
eret scalar tau2 = r(tau2)
}

ereturn scalar df_gf = `df'
ereturn local cmd = "glst"
ereturn local depvar = "`depname'"

ereturn scalar chi2_gf = r(Q)

if "`tstage'" != "" ereturn scalar chi2_gf = `Q'

// Q-test heterogeneity

 	if `df' > 0 {
		 if "`pfirst'" == "" eret scalar chi2_gf = r(chi2_gf2)
		}
		else {
			eret scalar chi2_gf = .
		}

/* compute test of indepvars = 0 */

qui testparm  `xname' 
 
eret scalar df_m = r(df)
eret scalar chi2 = r(chi2)
eret scalar ll = $loglik

if "`pfirst'" != "" {
eret scalar S = `nstudies'
}

Display, level(`level') `eform' `random' `multiple'  twostage(`tstage') `vwls'

// drop global used 
macro drop lbcov ubcov loglik ubounds lbounds levelci levelp

end

// Algorithm to fit the variance-covariance matrix

capture program drop varcov
program varcov, rclass
version 8.2
syntax varlist [if] [in] , s(varname numeric) tot(varname numeric) c(varname numeric)  ///
[CRudes  pecohort  ptcohort casecontrol   ts(varname numeric)  vwls ]


tempvar  b dose se n case control v 

	tokenize `varlist'
	local depname = "`1'"
      mac shift
      local xname `*'

// to use the option if/in  
	
	marksample touse, strok novarlist

	preserve
	qui keep if  `touse' &  `depname' != .

// get the arguments

parse "`varlist'" , parse(" ")

quietly {
	gen double `b' = `1'
	gen double `dose' = `2'

	gen double `se' = `s'
	gen double `v' = `se'^2
	gen double `n' = `tot'
	gen double `case' = `c'

} // end quietly

// get the type of study (either single study or multiple study)

if "`ts'"  != ""   {	 

	if `ts'[1] == 1  local typestudy = 1 
	if `ts'[1] == 2  local typestudy = 2
	if `ts'[1] == 3  local typestudy = 3
}
else {
	if "`casecontrol'"  != ""  local typestudy = 1 
	if "`ptcohort'" 	  != ""  local typestudy = 2
	if "`pecohort'" 	  != ""  local typestudy = 3 
}

// check exposure referent level 

if `b'[1] != 0  {
			di in r "beta coefficient (log relative risk) at the referent exposure level should be zero, log(1)=0"
			exit 198
			}

// Call mata function to calculate covariances 

* noisily di in w _n "Call Mata covariances()"
mata: covariances("`b'", "`dose'", "`se'", "`n'", "`case'", `typestudy')

tempname C FCASE R

mat `C' = r(C)
mat `R' = r(R)
mat `FCASE' = r(fitA)
* return matrix R =  `R'  
 
tempname VB BC PASS X XP B bc vb pval ll Q fitcases

mkmat `xname' if `b' != 0, matrix(`X')
mkmat `b' if `b' != 0, matrix(`B') 
svmat `FCASE', name(`fitcases') 
 
 
// Estimate beta corrected using weighted least squares for correlated outcomes
// Generalized Least Squares

* noisily di _n in w "Call Mata glsest()"

// Zero-covariance options (replaced 0 off-diagonal)

if "`vwls'" != "" {
	* Replace the previous C with a diagonal matrix (0 off-diagonal elements) 
	tempname CZ  
	mat `CZ' = diag(vecdiag(`C'))
	mat `C' = `CZ'
}
 	
mata: glsest("`B'", "`X'", "`C'")

mat `VB' = r(VB)
mat `BC' = r(BC)
scalar `Q' = r(Q)
scalar `ll' = r(LL)

// Get crude (un-adjusted) estimates of the betas and var-cov matrix

if "`crudes'" != ""   { 

	* noisily di in w _n "Call Mata crudest()"
	mata: crudest("`b'", "`case'", "`n'", `typestudy')

	tempname RD_min RD_max CR_C CR_EXPB CR_B  RD_C_A M_RD_C_A CR_R ADJ_EXPB MEANDIFF_C_A DIFF_C_A
	mat `CR_C' = r(CR_C)
	mat `CR_R' = r(CR_R)
	mat `CR_EXPB' = r(CR_EXPB)
	mat `ADJ_EXPB' = r(ADJ_EXPB)
	mat `CR_B' = r(CR_B)
	mat `RD_C_A' = r(RD_C_A)
	scalar `M_RD_C_A' = r(M_RD_C_A)
	scalar `RD_min' = r(RD_min)
	scalar `RD_max' = r(RD_max)

	// Compare crude and adjusted correlation matrix 

	mata: checklowhigh("`CR_R'", "`R'")
	scalar `MEANDIFF_C_A' = r(meandiffca)
	mat `DIFF_C_A' = r(diffca)

	/*
      mat list `CR_R'
	mat list `R'
	di _n "N. Corr = " r(nc)
	di "N. Lower corr = " r(lw)
	di "N. Higher corr =  "r(uw)
	mat list r(low)
	mat list r(high)
	*/
}

// Create Confidence Bounds for the var-cov matrix 
 
	if ( "$lbounds" != "" | "$ubounds" != "")   { 
		 
	if ($lbcov == 1)  | ($ubcov == 1) {
	
		noi di as res  "Method 1" 
	
	// generate CI of RR
	
	tempname lb ub 
	gen double `lb' = `b' - `se'*invnorm($levelci)
	gen double `ub' = `b' + `se'*invnorm($levelci)
	
	// Call mata function to calculate covariances

      if ($lbcov == 1) {
	mata: covariances("`lb'", "`dose'", "`se'", "`n'", "`case'", `typestudy')
	mat `C' = r(C)
	mata: glsest("`B'", "`X'", "`C'")
	mat `VB' = r(VB)
	mat `BC' = r(BC)
	scalar `Q' = r(Q)	
	scalar `ll' = r(LL)
	return scalar ll = `ll'
	return matrix BC =  `BC'
	return matrix VB =  `VB'
	return matrix C =  `C'  
	ret scalar chi2_gf2 = `Q'
	}
	
      if ($ubcov == 1) {
	mata: covariances("`ub'", "`dose'", "`se'", "`n'", "`case'", `typestudy')
	mat `C' = r(C)
	mata: glsest("`B'", "`X'", "`C'")
	mat `VB' = r(VB)
	mat `BC' = r(BC)
	scalar `Q' = r(Q)	
	scalar `ll' = r(LL)
	return scalar ll = `ll'
	return matrix BC =  `BC'
	return matrix VB =  `VB'
	return matrix C =  `C'  
	ret scalar chi2_gf2 = `Q'
	}

	}

	if ($lbcov == 2)  | ($ubcov == 2) {

	noi di as res  "Method 2" 
		 
	// find CI for the cases and N using exact poisson 		
	// I assume that it's not possible in this setting to have zero cases

		tempvar lbfitc ubfitc lbn ubn
 
		gen `lbfitc' = round(invgammap( `fitcases' , (1-$levelp)/2 ) )
		gen `ubfitc' = round(invgammap((`fitcases'+ 1) , (1+$levelp)/2 ) )

 		gen `lbn' = round(invgammap( `n' , (1-$levelp)/2 ))
		gen `ubn' = round(invgammap((`n'+ 1) , (1+$levelp)/2 ))
		
		// list  `lbfitc'  `ubfitc'  `lbn'  `ubn' `case' `n'
 
	// call crudest function to get the variance/covariance at lower/upper bounds	

      if ($lbcov == 2) {
		mata: crudest("`b'", "`ubfitc'", "`ubn'", `typestudy')
		mat `C' = r(CR_C)
		mat list `C'
		mata: glsest("`B'", "`X'", "`C'")
		mat `VB' = r(VB)
		mat `BC' = r(BC)
		scalar `Q' = r(Q)	
		scalar `ll' = r(LL)
		return scalar ll = `ll'
		return matrix BC =  `BC'
		return matrix VB =  `VB'
		return matrix C =  `C'  
		ret scalar chi2_gf2 = `Q'
	}

       if ($ubcov == 2) {
		mata: crudest("`b'", "`lbfitc'", "`lbn'", `typestudy')
		mat `C' = r(CR_C)
		mata: glsest("`B'", "`X'", "`C'")
		mat `VB' = r(VB)
		mat `BC' = r(BC)
		scalar `Q' = r(Q)	
		scalar `ll' = r(LL)
		return scalar ll = `ll'
		return matrix BC =  `BC'
		return matrix VB =  `VB'
		return matrix C =  `C'  
		ret scalar chi2_gf2 = `Q'
	}

	}

		
	if ($lbcov == 3)  | ($ubcov == 3) {

		noi di as res "Method 3"

		// Berrington and Cox method

		// Difference Adjusted and Un-adjusted (crude) var-cov matrix

		if $lbcov == 3  | $ubcov == 3  {
		* noisily di in w _n "Call Mata crudest()"
			mata: crudest("`b'", "`case'", "`n'", `typestudy')
			tempname CR_C CR_EXPB CR_B
			mat `CR_C' = r(CR_C)
			mat `CR_EXPB' = r(CR_EXPB)
			mat `CR_B' = r(CR_B)
		}
		* noisily di in w _n "Call Mata boundscov()"

		mata: boundscov("`C'", "`CR_C'") 
		
		tempname SIGMA_U SIGMA_L

		mat `SIGMA_U' = r(UB_C) 
		mat `SIGMA_L' = r(LB_C)	
 
		* noisily di _n  in w "Estimates at lower confidence limit of the covariances"
		
	if ($lbcov == 3) {
		mata: glsest("`B'", "`X'", "`SIGMA_L'")	

		tempname VB_L BC_L Q_L ll_L
	      mat `VB_L' = r(VB)
		mat `BC_L' = r(BC)
		scalar `Q_L' = r(Q)
		scalar `ll_L' = r(LL)

		return scalar ll = `ll_L'
		return matrix BC =  `BC_L'
		return matrix VB =  `VB_L'
		return matrix C =  `SIGMA_L'  
		ret scalar chi2_gf2 = `Q_L'
	}
 
	if ($ubcov == 3) {
		* noisily  di _n in w "Estimates at upper confidence limit of the covariances"
		mata: glsest("`B'", "`X'", "`SIGMA_U'")		
		
		tempname VB_U BC_U Q_U ll_U
	
		mat `VB_U' = r(VB)
		mat `BC_U' = r(BC)
		scalar `Q_U' = r(Q)
		scalar `ll_U' = r(LL)

		return scalar ll = `ll_U'
		return matrix BC =  `BC_U'
		return matrix VB =  `VB_U'
		return matrix C = `SIGMA_U'  
		ret scalar chi2_gf2 = `Q_U'
	}

	}

	}


matrix colnames `X' = doses
matrix colnames `B' = betas
 
return matrix x = `X'
return matrix B = `B'
return matrix R =  `R'  

return scalar N = c(N)- 1
 
if "`crudes'" != "" { 
 
	return mat CR_C = `CR_C'
	return mat CR_EXPB = `CR_EXPB'
	return mat ADJ_EXPB = `ADJ_EXPB'
	return mat CR_B = `CR_B'
	return matrix RD_C_A  = `RD_C_A'
	return scalar M_RD_C_A = `M_RD_C_A'
	return scalar RD_min = `RD_min'
	return scalar RD_max =  `RD_max'
	return mat CR_R = `CR_R'
	return scalar MEANDIFF_C_A = `MEANDIFF_C_A'
	return matrix DIFF_C_A  = `DIFF_C_A'
}


if ("$lbounds" != "yes") & ("$ubounds" != "yes")   { 

* noi di in w "nobounds"

// saved results

	return scalar ll = `ll'
	return matrix BC =  `BC'
	return matrix VB =  `VB'
	return matrix C =  `C'  
	ret scalar chi2_gf2 = `Q'
}
 

end  

capture program drop Display
program define Display
version 8
	syntax [, Level(integer $S_level) eform Random multiple twostage(string) vwls ]
	if `level' < 10 | `level' > 99 {
		di in red "level() must be between 10 and 99 inclusive"
		exit 198
	}

	tempname pgf pm
	if e(df_gf) > 0 {
		scalar `pgf' = chiprob(e(df_gf), e(chi2_gf))
	}
	else scalar `pgf' = .
	scalar `pm' = chiprob(e(df_m), e(chi2))
 

if "`multiple'" != "" &  "`random'" == "" & "`twostage'" == "" {
di _n  in gr "Fixed-effects dose-response model" _col(50) "Number of studies" _col(70) "= " as res %7.0g e(S)
}

if "`multiple'" != "" &  "`random'" == "" & "`twostage'" == "f" {
di _n  in gr "Two-stage fixed-effects dose-response model" _col(50) "Number of studies" _col(70) "= " as res %7.0g e(S)
}

if "`multiple'" != "" &  "`random'" != ""  & "`twostage'" == "" {
di _n in gr "Random-effects dose-response model" _col(50) "Number of studies" _col(70) "= " as res %7.0g e(S) 
}

if "`multiple'" != "" &  "`random'" == "" & "`twostage'" == "r" {
di _n in gr "Two-stage random-effects dose-response model" _col(50) "Number of studies" _col(70) "= " as res %7.0g e(S) 
}

* if "`multiple'" == "" di _n ""

if "`random'" == "" {

	if "`vwls'" != "" {
	#delimit ;
	di  _n in gr "Variance-weighted least-squares regression" _col(54)
		"Number of obs   = " in ye %7.0g e(N) _n
		in gr "Goodness-of-fit chi2(" in ye  e(df_gf)
		in gr ")" _col(28) "= "
		in ye %7.2f e(chi2_gf) _col(54)
		in gr "Model chi2(" in ye e(df_m) in gr ")" _col(70) "= "
		in ye %7.2f e(chi2) _n
		in gr "Prob > chi2" _col(28) "= " in ye %7.4f `pgf' _col(54)
		in gr "Prob > chi2     = " in ye %7.4f `pm' 
		 ; 
	#delimit cr
	}
	else { 
	#delimit ;
	di  _n in gr "Generalized least-squares regression" _col(54)
		"Number of obs   = " in ye %7.0g e(N) _n
		in gr "Goodness-of-fit chi2(" in ye  e(df_gf)
		in gr ")" _col(28) "= "
		in ye %7.2f e(chi2_gf) _col(54)
		in gr "Model chi2(" in ye e(df_m) in gr ")" _col(70) "= "
		in ye %7.2f e(chi2) _n
		in gr "Prob > chi2" _col(28) "= " in ye %7.4f `pgf' _col(54)
		in gr "Prob > chi2     = " in ye %7.4f `pm' 
		 ; 
	#delimit cr
	}
}
else {
	if "`vwls'" != "" {
	#delimit ;
	di  _n in gr "Variance-weighted least-squares regression" _col(54)
		"Number of obs   = " in ye %7.0g e(N) _n
		in gr "Goodness-of-fit chi2(" in ye  e(df_gf)
		in gr ")" _col(28) "= "
		in ye %7.2f e(chi2_gf) _col(54)
		in gr "Model chi2(" in ye e(df_m) in gr ")" _col(70) "= "
		in ye %7.2f e(chi2) _n
		in gr "Prob > chi2" _col(28) "= " in ye %7.4f `pgf' _col(54)
		in gr "Prob > chi2     = " in ye %7.4f `pm' 
		 ; 
	#delimit cr
	}
	else { 
	#delimit ;
	di _n in gr "Iterative Generalized least-squares regression" _col(54)
		"Number of obs   = " in ye %7.0g e(N) _n
		in gr "Goodness-of-fit chi2(" in ye  e(df_gf)
		in gr ")" _col(28) "= "
		in ye %7.2f e(chi2_gf) _col(54)
		in gr "Model chi2(" in ye e(df_m) in gr ")" _col(70) "= "
		in ye %7.2f e(chi2) _n
		in gr "Prob > chi2" _col(28) "= " in ye %7.4f `pgf' _col(54)
		in gr "Prob > chi2     = " in ye %7.4f `pm' 
		 ; 
	#delimit cr
	}
}
	if "`eform'" == "" ereturn display, level(`level') 
		else ereturn display, level(`level') eform(exb(b)) 

if "`random'" != "" {
	di as res "Moment-based"  /*
*/	  as txt " estimate of between-study variance of the slope:" /*
*/ _col(63) "tau2" _col(66) " = " as res %8.7f e(tau2)
}

if "`twostage'" == "r" {
	di as res "Moment-based"  /*
*/	  as txt " estimate of between-study variance of the slope:" /*
*/ _col(63) "tau2" _col(66) " = " as res %8.7f e(tau2)
}

end

 
