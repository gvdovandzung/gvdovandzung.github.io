*! version 1.0.0  08may1995
program define onegdlg
	version 5.0
	
        if "$D_cmd" != "onewdlg" {
		di in red "you must run a one-way analysis first"
		exit 198
	}
	global D_rb1 1
	capture noi omnudlg
	while _rc > 3000 {
		capture noi onact $D_rb1
		capture noi omnudlg
	}
end

program define omnudlg	
	version 5.0
	
	window control edit 92 10 15 9 D_level

	window control radbegin "Error bar, conf. level" 10 10 80 9 D_rb1 right
	window control radend   "Graph means by $D_var2" 10 25 110 9 D_rb1 right

	
	window control button "Run"     5 45 30 16 D_b1
	window control button "Cancel" 40 45 30 16 D_b2
	window control button "Help"   75 45 30 16 D_b3 help
	
        global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp onegdlg"
	
	capture noi window dialog "One-way ANOVA plots" . . 118 80 
	if "$D_level"=="" {
		global D_level = 95      
	}
	if $D_level < 10 | $D_level > 99 {
		global D_level = 95
	}
	global S_level = $D_level
	exit _rc
end

program define onact
	version 5.0
	
	if "$D_cmd" != "onewdlg" {
		exit 198
	}
	
       	if $D_rb1 == 1 {
		onebar		
	}
	else if $D_rb1 == 2 {
		noi di in white "grmeanby $D_var2, summarize($D_var1) ylab"
		window push "grmeanby $D_var2, summarize($D_var1) ylab"
		capture grmeanby $D_var2, summarize($D_var1) ylab
		if _rc>0 {
			window stopbox stop "Too many values!"
		}
	}
end
	
