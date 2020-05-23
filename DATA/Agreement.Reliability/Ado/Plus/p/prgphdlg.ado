*! version 1.0.0  12jul1995
program define prgphdlg
	version 5.0
	local gname "$D_GNAME"
	precmd prgphdlg
	global D_sm1 "Enter optional text"
	window control static D_sm1 5 10 160 8 left
	window control edit 5 20 160 10 D_GNAME
	window control button "OK" 22 40 30 16 D_b1
	window control button "Cancel" 67 40 30 16 D_b2
	window control button "Help" 112 40 30 16 D_b3 help
	global D_b1 "exit 3001"
	global D_b2 "exit 3000"
	global D_b3 "whelp graph_sq"
	cap noi window dialog "Graph Name" . . 175 75  
	if _rc>3000 {
		qui printgr
	}
	else {
		global D_GNAME "`gname'"
	}
end
