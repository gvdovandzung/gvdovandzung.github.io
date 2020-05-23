*! version 1.0.0  12jul1995
program define stldlg
	version 5.0
	
       	precmd stldlg
	global D_sm1 "Variable"
	window control static D_sm1 5 5 60 10 left
	window control ssimple D_vl 5 15 90 60 D_var
	getsv
	global D_vl "$S_1"
	
	window control button "OK"      3 75 30 16 D_b1
	window control button "Cancel" 35 75 30 16 D_b2
	window control button "Help"   67 75 30 16 D_b3 help
	
	global D_b1 "exit 3001" 
	global D_b2 "exit 3000"
	global D_b3 "whelp stldlg"
	cap noi window dialog "Strings to labels" . . 105 107
	if _rc>3000 {
		stlok
	}
end

program define stlok
	cap confirm string var $D_var
	if _rc>3000 {
		cap window stopbox stop "$D_var is not a string variable."
		exit
	}
	tempvar lblvar
	di in wh ". encode $D_var, gen(_tmp) label($D_var)"
	window push encode $D_var, gen(_tmp) label($D_var)
	encode $D_var, gen(`lblvar') label($D_var)
	di in wh ". drop $D_var"
	window push drop $D_var
	drop $D_var
	di in wh ". rename _tmp $D_var"
	window push rename _tmp $D_var
	rename `lblvar' $D_var
	order $D_vl
end
