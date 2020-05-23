*! version 1.0.0  12jul1995
program define newdlg
	version 5.0

	if _N>0 {
		cap window stopbox rusure "Data exists in memory." /*
			*/ "OK to clear data and enter editor;" /*
			*/ "Cancel to abort"
		if _rc>0 { exit}
		di in wh "drop _all"
		window push drop _all
		drop _all
		di in wh ". edit"
	}
	else {
		di in wh "edit"
	}
	window push edit
	edit
end
