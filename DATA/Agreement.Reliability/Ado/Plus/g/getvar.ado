*! version 1.0.0  12jul1995
program define getvar
	version 5.0
	local options "CAPTION(string) PROMPT(string) PREFILL(string) EXISTS(string)"
	parse "`*'"
	global D_sm1 "`prompt'"
	window control static D_sm1 5 10 160 8 left
	global D_sm2
	global D_var "`prefill'"
	if "`exists'"=="" {
		window control edit 5 20 160 10 D_var
		window control button "OK" 22 40 30 16 D_b1
		window control button "Cancel" 67 40 30 16 D_b2
		window control button "Help" 112 40 30 16 D_b3 help
		global D_b1 "exit 3001"
		global D_b2 "exit 3000"
		global D_b3 "whelp getvar"
		cap noi window dialog "`caption'" . . 175 75  
	}
	else {
		global D_vl "`exists'"
		window control ssimple D_vl 5 20 160 60 D_var
		window control button "OK"     22 90 30 16 D_b1
		window control button "Cancel" 67 90 30 16 D_b2
		window control button "Help"  112 90 30 16 D_b3 help
		global D_b1 "exit 3001"
		global D_b2 "exit 3000"
		global D_b3 "whelp getvar"
		cap noi window dialog "`caption'" . . 175 125  
	}
	if _rc == 3000 {
		global D_var
		exit
	}
end
