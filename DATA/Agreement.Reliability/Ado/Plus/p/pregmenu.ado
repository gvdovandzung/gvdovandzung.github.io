*! version 1.0.0  12jul1995
program define pregmenu
	version 5.0
	global D_rb2 = 1
	global D_dof = _result(5)
	set more 1
	cap noi pregdlg
	while _rc > 3000 {
		doaction $D_rb2
		cap noi pregdlg
	}
	global D_dof
	set more 0
end

program define pregdlg
	version 5.0
	if "$D_cmd"=="sreg" {
		window control radbegin "Plot fitted model" 5 5 115 8 D_rb2 right
	}
	else if "$D_cmd"=="mreg" | "$D_cmd"=="rreg" {
		window control radbegin "Plot actual Y vs. prediction" 5 5 115 8 D_rb2 right
	}
	window control radio "Plot residual vs. prediction" 5 15 115 8 D_rb2 right
	window control radio "Plot residual vs. an X" 5 25 115 8 D_rb2 right
	window control radio "Normal quantile plot of residuals" 5 35 115 8 D_rb2 right
	window control radio "Save YHAT as a variable" 5 45 115 8 D_rb2 right
	window control radend "Save residuals as a variable" 5 55 115 8 D_rb2 right
	window control button "Run" 10 70 30 16 D_b1
	window control button "Cancel" 45 70 30 16 D_b2
	window control button "Help" 80 70 30 16 D_b3 help
	global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp pregmenu"
	set more 1
	cap noi window dialog "Post-regression diagnostics" . . 130 105
	set more 0
	local rc = _rc
	if `rc' {
		exit `rc'
	}
end

prog def doaction
	version 5.0

	local n : word count $D_idepv
	capture local cons : di %8.0g _b[_cons]
	if _rc == 0 {
		local ttl "$D_depv=`cons'"
	}
	local i 1
	while `i' <= `n' {
		local name : word `i' of $D_idepv
		capture local val : di %8.0g _b[`name']
		if _rc == 0 {
			if `val' < 0 {
				local term : di `val' "`name'"
			}
			else    local term : di "+" `val' "`name'"
			local ttl "`ttl'`term'"
		}
		local i = `i'+1
	}
	local ttlt = "`ttl'"
	if length("`ttlt'") > 50 {
		local ttl = substr("`ttlt'",1,50)
		local ttl = "`ttl' ..."
	}
	else    local ttl = "`ttlt'"
 
	if `1'==1 {
	    if "$D_cmd"=="sreg" {
		window control check "Include confidence intervals" 10 10 130 9 D_cb1
		window control check "Include prediction intervals" 10 20 130 9 D_cb2
		global D_sm1 "Significance Level"
		window control static D_sm1 30 40 70 9 
		window control edit 102 40 15 9 D_level
		window control button "Ok" 55 60 30 16 D_b1 default
		global D_b1 "exit 3001"
		global D_cb1 = 0
		global D_cb2 = 0 
		capture noisily window dialog "Include intervals" . . 160 100
		if "$D_level" == "" {
			global D_level 95
		}
		if $D_level < 5 {
			global D_level 5
		}
		if $D_level > 99 {
			global D_level 99
		}

		if $D_level < 50 {
			global D_level = 100 - $D_level
		}

		local zfac : di %5.0g invt($D_dof,$D_level/100)
		window push predict _Yhat
		noi di in wh ". predict _Yhat"
		tempvar yhat
		predict `yhat'
		label var `yhat' "_Yhat"
		local ppen "23"
		if $D_cb1 == 1 {
			window push predict _Yci, stdp
			noi di in wh ". predict _Yci, stdp"
			tempvar yci ycil yciu
			predict `yci', stdp
			local yc "`ycil' `yciu'"
			window push gen _Ycil = _Yhat-`zfac'*_Yci
			noi di in wh ". gen _Ycil = _Yhat-`zfac'*_Yci"
			gen `ycil' = `yhat'-`zfac'*`yci'
			label var `ycil' "_Ycil"
			window push gen _Yciu = _Yhat+`zfac'*_Yci
			noi di in wh ". gen _Yciu = _Yhat+`zfac'*_Yci"
			gen `yciu' = `yhat'+`zfac'*`yci'
			label var `yciu' "_Yciu"
			local ycll "_Ycil _Yciu"
			local ppen "`ppen'44"
		}
		if $D_cb2 == 1 {
			window push predict _Ypi, stdf
			noi di in wh ". predict _Ypi, stdf"
			tempvar ypi ypil ypiu
			predict `ypi', stdf
			local yp "`ypil' `ypiu'"
			window push gen _Ypil = _Yhat-`zfac'*_Ypi
			noi di in wh ". gen _Ypil = _Yhat-`zfac'*_Ypi"
			gen `ypil' = `yhat'-`zfac'*`ypi'
			label var `ypil' "_Ypil"
			window push gen _Ypiu = _Yhat+`zfac'*_Ypi
			noi di in wh ". gen _Ypiu = _Yhat+`zfac'*_Ypi"
			gen `ypiu' = `yhat'+`zfac'*`ypi'
			label var `ypiu' "_Ypiu"
			local ypll "_Ypil _Ypiu"
			local ppen "`ppen'55"
		}

		window push graph $D_depv _Yhat `ycll' `ypll' $D_idepv, sort connect(.lllll) symbol(o.....) ylab xlab t1("`ttl'") pen(`ppen')
		noi di in wh ". graph $D_depv _Yhat `ycll' `ypll' $D_idepv, sort connect(.lllll) symbol(o.....) ylab xlab t1(`ttl') pen(`ppen')"
		graph $D_depv `yhat' `yc' `yp' $D_idepv, sort connect(.lllll) symbol(o.....) ylab xlab t1("`ttl'") pen(`ppen')
		window push drop _Yhat _Yci _Ypi _Ycil _Yciu _Ypil _Ypiu
		noi di in wh ". drop _Yhat _Yci _Ypi _Ycil _Yciu _Ypil _Ypiu"
	    }
	    else if "$D_cmd"=="rreg" | "$D_cmd"=="mreg" {
		window push predict _Yhat
		noi di in wh ". predict _Yhat"
		tempvar yhat
		predict `yhat'
		label var `yhat' "_Yhat"
		window push graph $D_depv _Yhat, ylab xlab t1("`ttl'")
		noi di in wh ". graph $D_depv _Yhat, ylab xlab t1(`ttl')"
		graph $D_depv `yhat', ylab xlab t1("`ttl'")
		window push drop _Yhat
		noi di in wh ". drop _Yhat"
	    }
	}
	else if `1'==2 {
		window push predict _Yhat
		noi di in wh ". predict _Yhat"
		tempvar yhat resid
		predict `yhat'
		window push predict _Resid, resid
		noi di in wh ". predict _Resid, resid"
		predict `resid', resid
		label var `yhat' "_Yhat"
		label var `resid' "_Resid"
		window push graph _Resid _Yhat, yline(0) ylab xlab twoway box t1("`ttl'")
		noi di in wh ". graph _Resid _Yhat, yline(0) ylab xlab twoway box t1(`ttl')"
		graph `resid' `yhat', yline(0) ylab xlab twoway box t1("`ttl'")
		window push drop _Yhat
		noi di in wh ". drop _Yhat"
		window push drop _Resid
		noi di in wh ". drop _Resid"
	}
	else if `1'==3 {
		#delimit ;
		local done 0 ;
		while !`done' {
			getnv;
			local pfill : word 1 of $D_idepv ;
			cap noi getvar , exists("$S_1") 
			  prompt("Choose an independent variable as your X")
			  prefill(`pfill')
			  caption("Enter variable") ;
			if "$D_var"=="" {
				local done 1 ;
			} ;
			else {
				cap confirm var $D_var ;
				if _rc>0 {
					cap window stopbox stop "$D_var is not a valid variable" ;
				} ;
				else {
					local done 2 ;
				} ;
			} ;
		} ;
		#delimit cr
		if `done'==1 {
			exit
		}
		window push predict _Resid, resid
		noi di in wh ". predict _Resid, resid"
		tempvar resid
		predict `resid', resid
		label var `resid' "_Resid"
		di in wh ". graph _Resid $D_var, ylab xlab t1(`ttl') yline(0) box twoway"
		window push graph _Resid $D_var, ylab xlab t1("`ttl'") yline(0) box twoway
		graph `resid' $D_var, ylab xlab t1("`ttl'") yline(0) box twoway
		window push drop _Resid
		noi di in wh ". drop _Resid"
	}
	else if `1'==4 {
		window push predict _Resid, resid
		noi di in wh ". predict _Resid, resid"
		tempvar resid
		predict `resid', resid
		label var `resid' "_Resid"
		window push qnorm _Resid, grid xlab ylab 
		noi di in wh ". qnorm _Resid, grid xlab ylab"
		qnorm `resid', grid xlab ylab 
		window push drop _Resid
		noi di in wh ". drop _Resid"
	}
	else if `1'==5 {
		local done 0
		while !`done' {
			gnname yhat
			cap noi getvar, prompt("Enter new variable name") /*
				*/ caption("Save yhat") prefill("$S_1")
			if "$D_var"=="" {
				local done 1
			}
			else {
				cap confirm new var $D_var
				if _rc>0 {
					cap confirm var $D_var
					if _rc>0 {
					    cap window stopbox stop "$D_var is not a valid variable name"
					}
					else {
					    cap window stopbox rusure "$D_var already exists" "(OK to overwrite; Cancel to abort)"
					    if _rc>0 {
						local done 1
					    }
					    else {
						window push drop $D_var
						noi di in wh ". drop $D_var"
						drop $D_var
						local done 2
					    }
					}
				}
				else {
					local done 2
				}
			}
		}
		if `done'==1 {
			exit
		}
		window push predict $D_var
		noi di in wh ". predict $D_var"
		predict $D_var
	}
	else if `1'==6 {
		local done 0
		while !`done' {
			gnname resid
			cap noi getvar, prompt("Enter new variable name") /*
				*/ caption("Save residuals") prefill("$S_1")
			if "$D_var"=="" {
				local done 1
			}
			else {
				cap confirm new var $D_var
				if _rc>0 {
					cap confirm var $D_var
					if _rc>0 {
					    cap window stopbox stop "$D_var is not a valid variable name"
					}
					else {
					    cap window stopbox rusure "$D_var already exists" "(OK to overwrite; Cancel to abort)"
					    if _rc>0 {
						local done 1
					    }
					    else {
						window push drop $D_var
						noi di in wh ". drop $D_var"
						drop $D_var
						local done 2
					    }
					}
				}
				else {
					local done 2
				}
			}
		}
		if `done'==1 {
			exit
		}
		window push predict $D_var, resid
		noi di in wh ". predict $D_var, resid"
		predict $D_var, resid
	}
end
