*! version 1.0.0  12jul1995
prog def logok
	version 5.0

	local wc1 :word count $D_depv
	local wc2 :word count $D_idepv
	if `wc1'+`wc2'!=2 {
		window stopbox stop "Please specify one dependent" /*
			*/ "and one independent variable"
		exit
	}
	if "$D_cb1"=="1" {
		local opt ", or"
	}
	di in wh "logit $D_depv ${D_idepv}`opt'"
	window push logit $D_depv ${D_idepv}`opt'
	logit $D_depv ${D_idepv}`opt'
end
