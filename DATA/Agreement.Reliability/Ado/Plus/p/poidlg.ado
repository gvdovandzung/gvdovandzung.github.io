*! version 1.0.0  20apr1995
program define poidlg
	version 5.0
	
        precmd poidlg
	global D_run "1"
	global D_sm1 "Total exp. time  "
	global D_sm2 "No. of events   "
	global D_sm3 "Confidence level"
	
        * Total exp time
	window control edit 75 15 25 10 D_time
	window control static D_sm1 10 15 60 10 
	
        * Number of events
	window control edit 75 30 25 10 D_events
	window control static D_sm2 10 30 60 10 
	
        * Confidence level
	window control edit 75 45 20 10 D_level
	window control static D_sm3 10 45 60 10 
	
      	window control button "Run"     5 65 30 16 D_bok
	window control button "Cancel" 42 65 30 16 D_bex
	window control button "Help"   79 65 30 16 D_bhl help
	
	global D_bhl "whelp poidlg"
	global D_bok "noi poiok"
	global D_bex "exit 3000"
	
       	if "$D_level"=="" {
		global D_level 95
	}
	noi capture window dialog "Poisson confidence interval" . . 125 100
	if _rc>3000 {
		poiok
	}
        global cmac1
	global cmac2
	global D_run
end

program define poiok
	version 5.0
	
	if "$D_run" != "" {
		noi di in white "cii $D_time $D_events, poisson level($D_level)"
	}
	else {
		noi di in white
		noi di in white ". cii $D_time $D_events, poisson level($D_level)"
	}
	global D_run
	window push cii $D_time $D_events, poisson level($D_level)
	noi cii $D_time $D_events, poisson level($D_level)
end
