*! version 1.1.0  17oct1995
prog def histok
	version 5.0
	if "$inincr"=="1" | "$indecr"=="1" {
		if "$D_cb2"=="0" | "$D_rb1"!="1" {
			exit
		}
	}
	local wc :word count $D_gvar
	if `wc'!=1 {
		window stopbox stop "Please specify a single variable"
		exit
	}
	if "$D_cb1"=="1" {
		local normal = "normal"
	}
	if !(trim("$D_nobs1")=="" | trim("$D_nobs2")=="")  {
		local if " if $D_gvar >= $D_nobs1 & $D_gvar <= $D_nobs2"
		local xscale " xscale($D_nobs1,$D_nobs2)"
		nicen D_scale = $D_nobs1 $D_nobs2, inter($D_bins)
	}
	else {
		global D_scale
	}
	if "$D_rb1"=="1" {
		cap confirm integer number $D_bins
		if _rc>0 {
			window stopbox stop "Bins must be an integer"
			exit
		}
		local bins = $D_bins
	}
	else {
		cap confirm number $D_nobs
		if _rc>0 {
			window stopbox stop "Width must be a number"
			exit
		}
		if "`if'"=="" {
			qui summ $D_gvar
			local x1 = _result(5)
			local x2 = _result(6)
		}
		else {
			local x1 = $D_nobs1
			local x2 = $D_nobs2
		}
		local bins = int((`x2'-`x1'+(.99 *$D_nobs))/$D_nobs)
		local x2 = `x1' + `bins' * $D_nobs
		local xscale " xscale(`x1',`x2')"
		nicen D_scale = `x1' `x2' , inter(`bins')
	}
	if "$D_scale"!="" {
		local xscale " xlab($D_scale)"
	}
	else {
		local xscale " `xscale' xlab"
	}
	if "$D_run" != "" {
		di in wh "graph $D_gvar`if',`xscale' bin(`bins') `normal' ylab"
	}
	else {
		noi di in white
		di in wh ". graph $D_gvar`if',`xscale' bin(`bins') `normal' ylab"
	}
	global D_run
	window push graph $D_gvar`if',`xscale' bin(`bins') `normal' ylab 
	graph $D_gvar`if',`xscale' bin(`bins') `normal' ylab 
end
