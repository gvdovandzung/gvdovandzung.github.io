*! version 1.0.0  12jul1995
program define ltsdlg
	version 5.0
	
       	precmd ltsdlg
	global D_sm1 "Variable"
	window control static D_sm1 5 5 60 10 left
	window control ssimple D_vl 5 15 90 60 D_var
	getlv
	global D_vl "$S_1"
	
	window control button "OK"      5 75 30 16 D_b1
	window control button "Cancel" 38 75 30 16 D_b2
	window control button "Help"   71 75 30 16 D_b3 help
	
	global D_b1 "exit 3001" 
	global D_b2 "exit 3000"
	global D_b3 "whelp stldlg"
	cap noi window dialog "Labels to strings" . . 115 109
	if _rc>3000 {
		ltsok
	}
end

program define ltsok
	cap confirm var $D_var
	if _rc>0 {
		cap window stopbox stop "$D_var is not a valid variable name."
		exit
	}
	local vl : value label $D_var
	if "`vl'"=="" {
		cap window stopbox stop "$D_var is not labelled."
		exit
	}
	tempvar lblvar
	di in wh "decode $D_var, gen(_tmp)"
	window push decode $D_var, gen(_tmp)
	decode $D_var, gen(`lblvar')
	di in wh ". drop $D_var"
	window push drop $D_var
	drop $D_var
	di in wh ". rename _tmp $D_var"
	window push rename _tmp $D_var
	rename `lblvar' $D_var
	order $D_vl
end
