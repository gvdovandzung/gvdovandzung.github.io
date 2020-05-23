*! version 1.0.0  12jul1995
program define precmd
	local ppp "`1'"
	mac shift
	parse "`*'"
	version 5.0
	local i 1
	while `i'<=10 {
		global D_sm`i'
		local i = `i' + 1
	}
	local rc 0
	local varlist "opt"
	parse "`*'"
	if "$D_VLIST"=="" {
		global D_VLIST "`varlist'"
		local rc = 1
	}
	else {
		local olist "$D_VLIST"
		parse "`olist'", parse(" ")
		while "`1'" != "" {
			capture confirm var `1'
			local rc = `rc' + (_rc!=0)
			mac shift
		}
		if `rc' > 0 {
			global D_VLIST "`varlist'"
		}
	}

		
	if "`ppp'"!="$D_cmd" | `rc' > 0 {
		local i 1
		while `i'<=20 {
			global D_rb`i'
			global D_b`i'
			global D_cb`i'
			local i = `i' + 1
		}
		global D_depv
		global D_idepv
		global D_gvar
		global D_gvar2
		global D_gvby
		global D_bins 8
		global D_var
		global D_val1
		global D_val2
		global D_var1
		global D_var2
		global D_mean1
		global D_mean2
		global D_sd1
		global D_sd2
		global D_nobs1
		global D_nobs2
		global D_nobs
		global D_dof1
		global D_dof2
		global D_dof
		global D_time
		global D_prob
		global D_hyp
		global D_events
		global D_nsuc
		global D_vlist
		global D_vl
		global D_vla
		global D_val
		global D_nnn
	}
	cap confirm number .
	if _rc>0 {
		global D_dlgx 20
	}
	else {
		if .<0 {
			global D_dlgx 0
		}
	}
	cap confirm number .
	if _rc>0 {
		global D_dlgy 20
	}
	else {
		if .<0 {
			global D_dlgy 0
		}
	}
	cap confirm number $D_level
	if _rc>0 {
		global D_level $S_level
	}
	global D_cmd "`ppp'"
	window manage forward results
end
