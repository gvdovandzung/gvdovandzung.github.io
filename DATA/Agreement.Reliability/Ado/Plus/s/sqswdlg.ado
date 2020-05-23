*! version 1.0.0  10aug1995
program define sqswdlg
	version 5.0

	global D_sm1 "P-value entrance criterion"
	global D_sm2 "P-value removal criterion"

	window control radbegin "Forward stepwise procedure" 10 10 110 10 D_rb1 right
	*window control radio "Forward stepwise procedure"   10 25 110 10 D_rb1 right
	*window control radio "Backward selection procedure" 10 40 110 10 D_rb1 right
	window control radend "Backward stepwise procedure"  10 22 110 10 D_rb1 right

	window control static D_sm1  10 45 90 10 
	window control edit 102 45 20 10 D_pe
	window control static D_sm2  10 60 90 10
	window control edit 102 60 20 10 D_pr

	global D_rb1 1
	global D_pe .2
	global D_pr .4


	window control button "OK"     12 80 30 16 D_b1
	window control button "Cancel" 51 80 30 16 D_b2
	window control button "Help"   90 80 30 16 D_b3

	global D_b1 "chkarg"
	global D_b2 "exit 3000"
	global D_b3 "whelp mregdlg"

	cap noi window dialog "Stepwise regression" . . 135 115

	if _rc>3000 {
		if $D_rb1 == 1 {
			global D_lcmd "forward step pr($D_pr) pe($D_pe)"
		}
		else    global D_lcmd "step pr($D_pr) pe($D_pe)"
	}
	else {
		global D_lcmd
	}
end

program define chkarg
	if "$D_pe" == "" | "$D_pr"=="" {
		window stopbox stop "You must provide the criteria for entrance and removal"
		exit
	}
	if $D_pe > $D_pr {
		window stopbox stop "Entrance criterion must be less than removal criterion"
		exit
	}
	exit 3001
end


