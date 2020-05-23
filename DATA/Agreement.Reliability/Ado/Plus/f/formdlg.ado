*! version 1.0.0  12jul1995
program define formdlg
	version 5.0
	
	cap qui desc, short
	if _result(2)>=25 {
		cap window stopbox rusure "You already have 25 variables." /*
			*/ "You will only able to replace an existing" /*
			*/ "variable instead of generating a new variable." /*
			*/ " (OK to continue; Cancel to abort)"
		if _rc>0 { exit }
	}
       	precmd formdlg
	global D_sm1 "New variable name"
	global D_sm2 "Formula"
	window control static D_sm1 5 10 70 10 right
	window control static D_sm2 5 25 70 10 right
	
	window control edit 82 10 30 10 D_var
	window control edit 82 25 90 10 D_var1
	
	window control button "OK"     30 46 30 16 D_b1
	window control button "Cancel" 80 46 30 16 D_b2
	window control button "Help"  130 46 30 16 D_b3 help
	
	global D_b1 "exit 3001" 
	global D_b2 "exit 3000"
	global D_b3 "whelp formdlg"
	cap noi window dialog "Generate formula" . . 185 81
	if _rc>3000 {
		formok
	}
end

program define formok

	tempvar junk
	cap gen `junk' = $D_var1
	if _rc>0 {
		cap window stopbox stop "You entered an invalid formula."
		exit
	}
	cap drop `junk'

	if _N == 0 {
		noi setodlg
		noi di in whi "set obs $D_nnn"
		window push set obs $D_nnn
		set obs $D_nnn
		noi di in white _newline ". " _continue
	}
	
	cap confirm var $D_var
	if !_rc {
		cap window stopbox rusure "$D_var already exists."/*
			*/ "(OK to replace; Cancel to abort)"
		if _rc>0 { exit }
		di in wh "replace $D_var = $D_var1"
		window push replace $D_var = $D_var1
		replace $D_var = $D_var1
	}
	else {
		di in wh "generate $D_var = $D_var1"
		window push generate $D_var = $D_var1
		generate $D_var = $D_var1
	}
end
