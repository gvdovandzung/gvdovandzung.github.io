*! version 1.0.0  13jul1995
program define regok
	version 5.0

	local wc :word count $D_depv
	if `wc'!=1 {
		window stopbox stop "Please specify only one dependent variable"
		exit
	}
	local cmd = "regress"
	if "$D_cmd"=="mreg" {
		if "$D_rb1"!="1" {
			if "$D_rb1"=="2" {
				sqswdlg
				local opt "$D_lcmd"
				global D_lcmd
				if "`opt'"=="" {
					exit
				}
				local cmd "sqswreg"
			}
			else if "$D_rb1"=="3" {
				local cmd "regdw"
			}
		}
	}
	if "$D_cmd"=="rreg" {
		local cmd = "rreg"
	}
	local cmd "`cmd' $D_depv $D_idepv"
	if "`opt'"!="" {
		local cmd "`cmd', `opt'"
	}
	di in wh "`cmd'"
	window push `cmd'
	`cmd' 
	if "$D_cmd"=="sreg" | "$D_cmd"=="mreg" | "$D_cmd"=="rreg" {
		if $D_cb1 == 1 {
			pregmenu
		}
	}
end
