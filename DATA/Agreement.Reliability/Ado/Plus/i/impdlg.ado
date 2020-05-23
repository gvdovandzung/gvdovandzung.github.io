*! version 1.0.0  12jul1995
program define impdlg
	version 5.0
	cap window fopen D_gph "Select import file" "Tab delimited (*.txt;*.dat)|*.txt;*.dat|Comma separated (*.csv)|*.csv|All Files (*.*)|*.*" "*.txt;*.dat"

	if _rc==0 {
		if "$D_cmd"!="impdlg" {
			local flag 1
		}
		precmd impdlg
		
		if "`flag'" != "" {
			global D_cb1 1
		}

		window control radbegin "Auto-detect file properties" 15  9 110 9 D_rb1
		window control radend "Use selected file properties"  15 19 110 9 D_rb1

		global D_sm1 "Field delimiter"
		
		window control static D_sm2 25 35 90 30 blackframe
		window control static D_sm1 40 32 60 9 center

		window control radbegin "tab separated" 35 43 70 9 D_rb2
		window control radend "comma separated" 35 53 70 9 D_rb2

		window control check "file has variable names" 25 70 125 9 D_cb1

		window control button "OK"        10 95 36 16 D_b1
		window control button "Cancel"    50 95 36 16 D_b4
		window control button "Help"      90 95 36 16 D_b3 help

		global D_b1 "exit 3001"
		global D_b3 "whelp impdlg" 
		global D_b4 "exit 3000"


		cap noi window dialog "Import options" . . 150 130 

		if _rc>3000 {
			if $D_rb1 == 2 {
				local opts ", "
				if $D_cb1 == 1 {
					local opts "`opts' names"
				}
				if $D_rb2 == 1 {
					local opts "`opts' tab"
				}
				else {
					local opts "`opts' comma"
				}
			}
			quietly count
			if _result(1) {
				capture noi window stopbox rusure "OK to clear data in memory?"
				if _rc > 0 {
					exit
				}
				drop _all
			}
			di in wh "insheet using" _quote "$D_gph" _quote "`opts'"
			window push insheet using $D_gph `opts'
			insheet using "$D_gph" `opts'
		}
	}
end
