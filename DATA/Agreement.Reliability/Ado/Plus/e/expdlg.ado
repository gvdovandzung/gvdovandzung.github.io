*! version 1.0.0  12jul1995
program define expdlg
	version 5.0
	cap noi window fsave D_gph "Select export file" "Text Files (*.txt)|*.txt|All Files (*.*)|*.*" "txt" 
	if _rc==0 {
		if "$D_cmd"!="expdlg" {
			local flag 1
		}
		precmd expdlg
		
		if "`flag'" != "" {
			global D_cb1 1
			global D_cb2 1
			global D_cb3 0
		}

		global D_sm1 "Field delimiter"
		
		window control static D_sm2 15 5 110 30 blackframe
		window control static D_sm1 40 4 60 9 center
		window control radbegin "tab separated" 19 13 90 9 D_rb1
		window control radend "comma separated" 19 23 90 9 D_rb1

		window control check "include names as 1st observation" 8 40 120 9 D_cb1
		window control check "include quotes around strings" 8 50 120 9 D_cb2
		window control check "replace if file exists" 8 60 100 9 D_cb3

		window control button "OK"      20 77 30 16 D_b1
		window control button "Help"   100 77 30 16 D_b2 help
		window control button "Cancel"  60 77 30 16 D_b3

		global D_b1 "exit 3001"
		global D_b2 "whelp expdlg"
		global D_b3 "exit 3000"

		cap noi window dialog "Export options" . . 150 120 

		if _rc>3000 {
			local opts ", "
			if $D_cb1 == 0 {
				local opts "`opts' nonames"
			}
			if $D_cb2 == 0 {
				local opts "`opts' noquote"
			}
			if $D_cb3 == 1 {
				local opts "`opts' replace"
			}
			if $D_rb1 == 2 {
				local opts "`opts' comma"
			}
			di in wh "outsheet using" _quote "$D_gph" _quote "`opts'"
			window push outsheet using $D_gph `opts'
			outsheet using "$D_gph" `opts'
		}
	}
end
