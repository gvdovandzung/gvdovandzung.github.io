*! version 1.0.2 27dec2000 
program define rnddlg
	version 5.0

	precmd rnddlg

	global D_sm1 "Variable name prefix"
	global D_sm2 "Number of variables"
	global D_sm3 "Variable name is built with the prefix name plus an"
	global D_sm4 "integer, i.e., name1, name2, ... up to the number"
	global D_sm5 "of variables that you desire to generate or, just"
	global D_sm9 "the variable name if you want only one variable."
	global D_sm6 "Distribution"
	global D_sm7 "Normal Bernoulli Binomial Chi-squared Exponential F Student's-t Uniform Poisson Integers"
	global D_sm10

	window control static D_sm1  5 5 85 10 
	window control edit 92 5 25 10 D_var

	window control static D_sm2   5 20 85 10
	window control edit 92 20 25 10 D_nobs

	window control static D_sm3   5 35 175 10
	window control static D_sm4   5 45 175 10
	window control static D_sm5   5 55 175 10
	window control static D_sm9   5 65 175 10

	window control static D_sm6   20 80 40 10
	window control ssimple D_sm7 62 80 60 60 D_var1

	window control button "OK"     15 146 30 16 D_b1
	window control button "Cancel" 72 146 30 16 D_b2
	window control button "Help"   130 146 30 16 D_b3 help

	global D_b1 "chkarg"
	global D_b2 "exit 3000"
	global D_b3 "whelp rnddlg"

	cap noi window dialog "Generate random variables" . . 185 185

	if _rc>3000 {
		rndok
	}
	global D_val1
	global D_val2 
	global D_val3
	global D_t1
	global D_t2
	global D_t3
	global D_t4
end

program define chkarg
	version 5.0

	quietly describe
	local obs = _result(1)
	local var = _result(2)
	local wid = _result(3)


	if "$D_var" != ""  & "$D_var1" != "" {
		exit 3001
	}
	if "$D_var"=="" {
		window stopbox stop "Please enter in a variable name to continue"
	}
	else    window stopbox stop "Please choose a distribution to continue"
end
	

program define rndok
	version 5.0

	if "$D_var1"=="Normal" {
		randok "nor"
	}
	else if "$D_var1"=="Bernoulli" {
		randok "ber"
	}
	else if "$D_var1"=="Binomial" {
		randok "bin"
	}
	else if "$D_var1"=="Chi-squared" {
		randok "chi"
	}
	else if "$D_var1"=="Exponential" {
		randok "exp"
	}
	else if "$D_var1"=="F" {
		randok "fis"
	}
	else if "$D_var1"=="Student's-t" {
		randok "stu"
	}
	else if "$D_var1"=="Uniform" {
		randok "uni"
	}
	else if "$D_var1"=="Poisson" {
		randok "poi"
	}
	else if "$D_var1"=="Integers" {
		randok "int"
	}
end

program define randok 
	version 5.0

	quietly describe
	local obs = _result(1)
	if `obs'==0 {
		local nvar = _result(1)+$D_nobs
		noi setodlg `nvar'
		noi di in white "set obs $D_nnn"
		window push set obs $D_nnn
		set obs $D_nnn
	}
	
        local dist "`1'"
	noi randdlg "`1'"
	
	if _rc == 3000 {
		exit 
	}
	
        local gennor "$D_val1 + ($D_val2)*invnorm(uniform())"
	local genber "uniform() < ($D_val1)"
	local genexp "($D_val1)*(-log(uniform()))"
	local genstu "$D_val1 + ($D_val2)*invt($D_val3,uniform())*sign(uniform()-.5)"
	local genuni "(($D_val2)-($D_val1))*uniform()+($D_val1)"
	local genint "int((($D_val2)-($D_val1)+1)*uniform() + $D_val1)"
	
	if "$D_nobs"=="" {
		global D_nobs 1
	}

        local n = length("$D_nobs")
/*	local m = 8 - `n' */
	local m = 32 - `n' 
	if $D_nobs == 1 {
		local basen = "$D_var"
	}
	else { local basen = substr("$D_var",1,`m') }

	capture confirm new var `basen'
	if _rc != 0 & _rc != 110 {
		local rc = _rc
		noi di in red "illegal variable name: `basen' (`rc')"
		exit 198
	}
	
       	quietly {
	    tempvar d e
	    local i 1
	    while `i' <= $D_nobs {
		
	       	    if "`dist'"=="bin" {
		    	randbin `d', n($D_val1) p($D_val2)
		    }
		    else if "`dist'"=="poi" {
		    	if $D_val1 < 0 {
				noi di in red "invalid argument for mean"
				exit 198
			}
			gen `d'=.
		    	randpoi `d' $D_val1
		    }
		    else if "`dist'"=="chi" {
		    	if $D_val1 <= 0 {
				noi di in red "invalid argument for dof"
				exit 198
			}
		    	gen `d' = .
			randchi `d' $D_val1
		    }
		    else if "`dist'"=="fis" {
		    	if $D_val1 <= 0 | $D_val2 <= 0 {
				noi di in red "invalid argument for dof"
				exit 198
			}
		    	gen `d' = .
			gen `e' = .
			randchi `d' $D_val1
			randchi `e' $D_val2
			replace `d' = (`d'/$D_val1)/(`e'/$D_val2)
			drop `e'
		    }
		    else {
			if $D_nobs==1 {
				noi di in white "generate $D_var = `gen`dist''"
				window push generate $D_var = `gen`dist''
			}
			else{
				if `i' == 1 {
					noi di in white /*
					*/ "generate `basen'`i' = `gen`dist''"
				}
				else {
					noi di in white /*
					*/ ". generate `basen'`i' = `gen`dist''"
				}
				window push generate `basen'`i' = `gen`dist''
			}
			generate `d' = `gen`dist''
		    }
		    if $D_nobs==1 {
			capture rename `d' $D_var
		        if _rc>0 {
				capture noi window stopbox rusure /*
				*/ "Variable $D_var already exists!" /*
				*/ "OK to replace, Cancel to exit"
				if _rc > 0 {
					exit
				}
				capture drop $D_var
				if _N==0 {
					set obs `nnn'
				}
				rename `d' $D_var
		        }

		    }
		    else { 
			capture rename `d' `basen'`i' 
		        if _rc>0 {
			    capture noi window stopbox rusure "Variable `basen'`i' already exists!" /*
			    */ "OK to replace, Cancel to exit"
				if _rc > 0 {
					exit
				}
			    capture drop `basen'`i'
			    if _N==0 {
				    set obs `nnn'
			    }
			    rename `d' `basen'`i'
		        }
		    }
		    local i = `i'+1
	    }
	}
end

program define randdlg
	version 5.0
	
	local dist "`1'"
	
	if "$D_cmd" != "rnddlg" {
		noi di in red "you must use the menu command for random numbers first"
		exit 198
	}
	if "`dist'"=="nor" {
		global D_t1 "Mean"
		global D_t2 "Std. dev."
		global D_t3
		global D_t4 "Random normal deviates"
		global D_val1 = 0
		global D_val2 = 1
	}
	else if "`dist'"=="ber" {
		global D_t1 "Probability"
		global D_t2 
		global D_t3
		global D_t4 "Random Bernoulli integers"
		global D_val1 = .5
	}
	else if "`dist'"=="bin" {
		global D_t1 "No. trials"
		global D_t2 "Probability"
		global D_t3
		global D_t4 "Random binomial integers"
		global D_val1 = 10
		global D_val2 = .5
	}
	else if "`dist'"=="chi" {
		global D_t1 "Deg. freedom"
		global D_t2 
		global D_t3
		global D_t4 "Random chi-squared deviates"
		global D_val1 = 1
	}
	else if "`dist'"=="exp" {
		global D_t1 "Mean"
		global D_t2 
		global D_t3
		global D_t4 "Random exponential deviates"
		global D_val1 = 1
	}
	else if "`dist'"=="fis" {
		global D_t1 "Numerator dof"
		global D_t2 "Denominator dof"
		global D_t3
		global D_t4 "Random Fisher's F deviates"
		global D_val1 = 1
		global D_val2 = 1
	}
	else if "`dist'"=="stu" {
		global D_t1 "Mean"
		global D_t2 "Std. dev."
		global D_t3 "Deg. freedom"
		global D_t4 "Random Student's t deviates"
		global D_val1 = 0
		global D_val2 = 1
		global D_val3 = 10
	}
	else if "`dist'"=="uni" {
		global D_t1 "Lower limit"
		global D_t2 "Upper limit"
		global D_t3
		global D_t4 "Random uniform deviates"
		global D_val1 = 0
		global D_val2 = 1
	}
	else if "`dist'"=="poi" {
		global D_t1 "Mean"
		global D_t2 
		global D_t3
		global D_t4 "Random Poisson deviates"
		global D_val1 = 5
	}
	else if "`dist'"=="int" {
		global D_t1 "Lower limit"
		global D_t2 "Upper limit"
		global D_t3
		global D_t4 "Random uniform integers"
		global D_val1 = 0
		global D_val2 = 9
	}
	
	
	window control static D_t1 10 5 65 10 
	window control edit 77 5 20 10 D_val1
	
        if "$D_t2"!="" {
	    window control static D_t2 10 20 65 10
	window control edit 77 20 20 10 D_val2
	}
	
        if "$D_t3" != "" {
		window control static D_t3 10 35 65 10
	window control edit 77 35 20 10 D_val3
	}
	
	window control button "OK" 5 55 30 16 D_b1
	window control button "Cancel" 40 55 30 16 D_b2
	window control button "Help" 75 55 30 16 D_b3 help
	
        global D_b1 "legala `dist'"
	global D_b2 "exit 3000"
	global D_b3 "whelp rnddlg"
	
	cap noi window dialog "$D_t4" . . 115 95 
end

program define legala
	version 5.0
	local dist "`1'"

	if "`dist'" == "nor" {
		if "$D_val1"=="" {
			mymiss "mean"
			exit
		}
		if "$D_val2"=="" {
			mymiss "standard deviation"
			exit
		}
		if $D_val2 <= 0 {
			mypos "standard deviation"
			exit
		}
		exit 3001
	}

	if "`dist'"=="ber" {
		if "$D_val1"==""{
			mymiss "probability"
			exit
		}
		if $D_val1 < 0 | $D_val1 > 1 {
			myprob
			exit
		}
		exit 3001
	}

	if "`dist'"=="bin" {
		if "$D_val1"=="" {
			mymiss "number of trials"
			exit
		}
		if "$D_val2"=="" {
			mymiss "probability"
			exit
		}
		if int($D_val1) != $D_val1 {
			myint "number of trials"
			exit
		}
		if $D_val1 <= 0 {
			mypos "number of trials"
			exit
		}
		if $D_val2 < 0 | $D_val2 > 1 {
			myprob
			exit
		}
		exit 3001
	}

	if "`dist'"=="chi" {
		if "$D_val1"=="" {
			mymiss "degrees of freedom"
			exit
		}
		if $D_val1 <= 0 {
			mypos "degrees of freedom"
			exit
		}
		exit 3001
	}

	if "`dist'"=="exp" {
		if "$D_val1"=="" {
			mymiss "mean"
			exit
		}
		if $D_val1 <= 0 {
			mypos "mean"
			exit
		}
		exit 3001
	}

	if "`dist'"=="fis" {
		if "$D_val1"=="" {
			mymiss "numerator degrees of freedom"
			exit
		}
		if "$D_val2"=="" {
			mymiss "denominator degrees of freedom"
			exit
		}
		if $D_val1 <= 0 {
			mypos "numerator degrees of freedom"
			exit
		}
		if $D_val2 <= 0 {
			mypos "denominator degrees of freedom"
			exit
		}
		exit 3001
	}

	if "`dist'"=="stu" {
		if "$D_val1" == "" {
			mymiss "mean"
			exit
		}
		if "$D_val2"=="" {
			mymiss "standard deviation"
			exit
		}
		if "$D_val3"=="" {
			mymiss "degrees of freedom"
			exit
		}
		if $D_val2<=0 {
			mypos "standard deviation"
			exit
		}
		if $D_val3<=0 {
			mypos "degrees of freedom"
			exit
		}
		exit 3001
	}

	if "`dist'"=="uni" {
		if "$D_val1"=="" {
			mymiss "lower limit"
			exit
		}
		if "$D_val2"=="" {
			mymiss "upper limit"
			exit
		}
		if $D_val2 < $D_val1 {
			window stopbox stop "Upper limit must be greater than lower limit"
			exit
		}
		exit 3001
	}

	if "`dist'"=="poi" {
		if "$D_val1"=="" {
			mymiss "mean"
			exit
		}
		if $D_val1 < 0 {
			window stopbox stop "Mean must be >= 0"
			exit
		}
		exit 3001
	}

	if "`dist'"=="int" {
		if "$D_val1"=="" {
			mymiss "lower limit"
			exit
		}
		if "$D_val2"=="" {
			mymiss "upper limit"
			exit
		}
		if int($D_val1) != $D_val1 {
			myint "lower limit"
			exit
		}
		if int($D_val2) != $D_val2 {
			myint "upper limit"
			exit
		}
		if $D_val2 < $D_val1 {
			window stopbox stop "Upper limit must be greater than lower limit"
			exit
		}
		exit 3001
	}
		
end

program define mymiss
	local arg "`1'"
	local msg "You must provide an argument for `arg'"
	window stopbox stop "`msg'"
end

program define mypos
	local arg "`1'"
	local msg "`arg' must be positive"
	window stopbox stop "`msg'"
end

program define myint
	local arg "`1'"
	local msg "`arg' must be an integer"
	window stopbox stop "`msg'"
end

program define myprob
	local msg "Probability must be in [0,1]"
	window stopbox stop "`msg'"
end

program define randchi
	local i 1
	qui replace `1' = 0
	while `i' <= `2' {
		qui replace `1' = `1' + invnorm(uniform())^2
		local i = `i' + 1
	}
end
