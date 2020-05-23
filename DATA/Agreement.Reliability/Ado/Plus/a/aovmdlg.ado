*! version 1.0.0  10jul1995
program define aovmdlg
	version 5.0
	
        if "$D_cmd" != "twowdlg" {
		di in red "you must run a two-way ANOVA first"
		exit 198
	}
	global D_rb1 1
	set more 1
	capture noi amnudlg
	while _rc > 3000 {
		capture anact $D_rb1
		if _rc == 0 {
			capture noi amnudlg
		}
		else { exit _rc }
	}
	set more 0
end

program define amnudlg	
	version 5.0

	global D_sm6 "Error bar, conf. level"
	
	window control radbegin "Interaction plot" 5 5 110 9 D_rb1 right
	window control radio    "Graph $D_var1 error bars" 5 15 110 9 D_rb1 right
	window control radio    "Graph $D_var2 error bars" 5 25 110 9 D_rb1 right
	window control radend   "Graph means by $D_var1 $D_var2" 5 35 110 9 D_rb1 right

	window control static D_sm6 10 58 70 10 
	window control edit 82 58 20 10 D_level
	
	window control button "Run"     5 80 30 16  D_b1
	window control button "Cancel" 45 80 30 16  D_b2
	window control button "Help"   85 80 30 16  D_b3 help
	
        global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp aovmdlg"
	
	capture noi window dialog "Two-way ANOVA Plots" . . 125 115 

	if "$D_level"=="" { global D_level = 95 }
	if $D_level < 10 | $D_level > 99 { global D-level = 95 }
	global S_level = $D_level
	exit _rc
end

program define anact
	version 5.0
	
       	if $D_rb1 == 1 {
		intplot
	}
	else if $D_rb1 == 2 {
		twobar 1
	}
	else if $D_rb1 == 3 {
		twobar 2
	}
	else {
		noi di in wh "grmeanby $D_var1 $D_var2, summarize($D_depv) ylab"
		window push grmeanby $D_var1 $D_var2, summarize($D_depv) ylab
		capture noi grmeanby $D_var1 $D_var2, summarize($D_depv) ylab
		if _rc>0 {
			window stopbox stop "Too many values!"
		}
	}
end
	
