*! version 1.1.0  20dec2000 
program define quest
	quietly version
	local ver = _result(1)
	version 5.0


	if `ver' < 7 & "$S_OS"!="MacOS" & "$S_OS"!="Windows" {
		di in red /*
*/ "Quest is for use with Stata for Windows and Stata for Macintosh only" 
		exit 198
	}

	if `ver' >= 7 &  "$S_CONSOLE" == "console" {
		di in red /*
*/ "Quest can not be used with the console version of Stata"
		exit 198
	}

	capture quest1
	local rc1 = _rc
	capture quest2
	local rc2 = _rc
	capture quest3
	local rc3 = _rc
	if `rc1' | `rc2' | `rc3' { 
		di in red /*
		*/"Quest is not fully installed.  You still need to load:"
		if `rc1' { di in red _col(8) "quest1" }
		if `rc2' { di in red _col(8) "quest2" }
		if `rc3' { di in red _col(8) "quest3" }
		di in red "from http://www.stata.com"
		exit 111
	}
	local rc3
	local rc2
	local rc1

	

        if "`1'"=="off" {
		if "`ver'" == "6" & "$S_OS" == "Windows" {
			quietly query born
			if "$S_1" < "14271" {
				di in blue /*
*/ "Your copy of Stata cannot use " /*
*/ in white "quest off" in blue " to change the menus back to Stata's"
				di in blue /*
*/ "default menus.  To reset the menus, please exit Stata and restart it."
				di in blue /*
*/ "There is an update to Stata available which will allow you to use " /*
*/ in white "quest off"
				di in blue /*
*/ "to restore Stata's menus.  Please type " in white "update all" /*
*/ in blue " to update your Stata now."
				exit
			}
		}
		window menu clear
		if "`ver'" == "5" {
        		quietly adopath -"$qpath"
		}
		global qpath
		global S_QUEST 
        	di "StataQuest menus off.  The menubar has been changed."
		exit
	}
        if "$S_QUEST"=="on" {
		di "StataQuest menus already on.  Type sqmenu off to turn them off." 
		exit
	}
	if "`ver'" == "6" & "$S_OS" == "Windows" & "`1'" != "ON" {
		quietly query born
		if "$S_1" < "14271" {
			di in blue /*
*/ "Before using StataQuest, you should update your copy of Stata to the"
			di in blue /*
*/ "latest executable.  If you do not update your executable, you can"
			di in blue /*
*/ "force StataQuest to start by typing " in white "quest ON" /*
*/ in blue " (note the capitalization), but "
			di in white "quest off" in blue /*
*/ " will not work.  You will have to exit Stata to switch from the"
			di in blue /*
*/ "StataQuest menus back to the Stata menus."
			di
			di in blue /*
*/ "Updating your executable will fix this.
			di
			di in blue /*
*/ "Type " in white "update all" /*
*/ in blue " to download the latest executable."

			exit
		}
	}
	global S_QUEST "on"
	if "`ver'" == "" {
        	getstpat
        	quietly adopath +"$qpath"
	}
	else if "`ver'" == "6" {
		global qpath ""
	}
	wmenu popout "StataQuest"
	*wmenu append popout sysmenu "&StataQuest"
	wmenu append popout "StataQuest" "&File"
	wmenu append popout "StataQuest" "&Edit"
	wmenu append popout "StataQuest" "&Prefs"
	wmenu append popout "StataQuest" "&Data"
	wmenu append popout "StataQuest" "&Graphs"
	wmenu append popout "StataQuest" "S&ummaries"
	wmenu append popout "StataQuest" "&Statistics"
	wmenu append popout "StataQuest" "&Calculator"

	if "$S_OS" != "MacOS" {
		quietly query born
		if "$S_1" < "14263" {
			local doshlp 0
		}
		else {
			local doshlp 1
		}

		if "`doshlp'" == "1" {
			wmenu append popout "StataQuest" "&sHelp"
		}
		else {
			wmenu append popout "StataQuest" "&Help"
		}
	}
	
	wmenu append string File "&New" "newdlg"
	wmenu append string File "&Open..." "XEQ use"
	wmenu append string File "&Save" "XEQ save"
	wmenu append string File "Save &As..." "XEQ saveas"
	wmenu append separator File
	wmenu append string File "Save &Graph" "XEQ savegr"
	wmenu append string File "&Print Graph" "prgphdlg"
	wmenu append string File "Print &Log" "XEQ printlog"
	wmenu append separator File
	wmenu append string File "&Import ASCII" "impdlg"
	wmenu append string File "&Export ASCII" "expdlg"
	wmenu append separator File
	wmenu append string File "E&xit" "XEQ exit"
	
	wmenu append popout Data "&Generate/Replace"
	wmenu append string "Generate/Replace" "&Random numbers" "rnddlg"
	wmenu append string "Generate/Replace" "S&equence" "seqdlg"
	wmenu append string "Generate/Replace" "&Formula" "formdlg"
	wmenu append string "Generate/Replace" "Re&code" "recdlg"
	
	wmenu append popout Data "&Label"
	wmenu append string Label "Label &dataset" "dslabdlg"
	wmenu append string Label "Label va&riable" "varldlg"
	wmenu append string Label "Label &values" "vlabdlg"
	wmenu append string Label "&Strings to labels" "stldlg"
	wmenu append string Label "&Labels to strings" "ltsdlg"
	
	wmenu append string Data "&Edit data" "edit"
	
	wmenu append popout Graphs "&One variable"
	wmenu append popout "One variable" "&Histogram"
	wmenu append string "Histogram" "&Continuous variable" "histdlg"
	wmenu append string "Histogram" "&Discrete variable" "chistdlg"
	wmenu append string "One variable" "&Box plot" "boxdlg box"
	wmenu append string "One variable" "Box plot && &one-way" "boxdlg boxone"
	wmenu append string "One variable" "&Stem-and-leaf" "stemdlg"
	wmenu append string "One variable" "&Dotplot" "dpldlg"
	wmenu append string "One variable" "&Normal quantile plot" "qnormdlg"
	
	wmenu append popout Graphs "One variable &by group"
	wmenu append popout "One variable by group" "&Histograms by group"
	wmenu append string "Histograms by group" "&Continuous variable" "hstbydlg"
	wmenu append string "Histograms by group" "&Discrete variable" "chbydlg"
	wmenu append string "One variable by group" "&Box plots by group" "boxbydlg"
	wmenu append string "One variable by group" "B&ar charts by group" "barbydlg"
	wmenu append string "One variable by group" "&Dotplots by group" "dplbdlg"
	
	wmenu append popout Graphs "&Comparison of variables"
	wmenu append string "Comparison of variables" "&Box plot comparison" "boxdlg boxes"
	wmenu append string "Comparison of variables" "Box plot && &one-way comparison" "box1sdlg"
	wmenu append string "Comparison of variables" "B&ar chart comparison" "barsdlg"
	wmenu append string "Comparison of variables" "Bar chart comparison by &group" "barbydlg bars"
	
	wmenu append popout Graphs "&Scatterplots"
	wmenu append string "Scatterplots" "&Plot Y vs. X" "sp2dlg"
	wmenu append string "Scatterplots" "Plot Y vs. X, &naming points" "sp3dlg name"
	wmenu append string "Scatterplots" "Plot Y vs. X, with &regression line" "sp2dlg reg"
	wmenu append string "Scatterplots" "Plot Y vs. X, &scale symbols to Z" "sp3dlg scale"
	wmenu append string "Scatterplots" "Plot Y vs. X, &by group" "sp3dlg by"
	wmenu append string "Scatterplots" "Scatterplot &matrix" "spmatdlg"
	
	wmenu append popout Graphs "&Time series"
	wmenu append string "Time series" "&Plot Y vs. X" "sp2dlg ts1"
	wmenu append string "Time series" "Plot Y vs. &obs. no." "ts1dlg"
	wmenu append string "Time series" "Plot &more than one Y vs. X" "ts2dlg"
	wmenu append string "Time series" "P&lot more than one Y vs. obs. no." "ts1dlg mto"
	
	wmenu append popout Graphs "&Quality control"
	wmenu append string "Quality control" "&Control (C) chart for defects" "qc2dlg"
	wmenu append string "Quality control" "&Fraction defective (P) chart" "qc3dlg"
	wmenu append string "Quality control" "&Range (R) chart" "qc1dlg range"
	wmenu append string "Quality control" "&X-bar chart" "qc1dlg xbar"
	wmenu append string "Quality control" "X-&bar && R chart" "qc1dlg xbarpr"
	
	wmenu append string Graphs "&View saved graphs" "gphview"
	
	wmenu append string Summaries "&Means and SDs" "summdlg"
	
	wmenu append popout Summaries "Means and SDs &by group"
	wmenu append string "Means and SDs by group" "One-way of &means" "onemdlg"
	wmenu append string "Means and SDs by group" "&Two-way of means" "tsumdlg"
	
	wmenu append string Summaries "Median/&Percentiles" "dtldlg"
	wmenu append string Summaries "&Confidence intervals" "scidlg"

	wmenu append popout Summaries "&Tables"
	wmenu append string Tables "&One-way (frequency)" "onedlg"
	wmenu append string Tables "Two-way (&cross-tabulation)" "twodlg"
	wmenu append string Tables "Three-way (by &group)" "tsbydlg"
	
	wmenu append string Summaries "Dataset &info" "ndlg" 
	wmenu append string Summaries "&Describe variables" "descdlg"
	wmenu append string Summaries "&List data" "listdlg"
	
	wmenu append popout Statistics "&Parametric tests"
	wmenu append string "Parametric tests" "1-sample t &test" "ptt1dlg"
	wmenu append string "Parametric tests" "2-sample t t&est" "ptt2dlg"
	wmenu append string "Parametric tests" "&Paired t test" "ptt2pdlg"
	wmenu append string "Parametric tests" "1-sample test of &variance" "ptev1dlg"
	wmenu append string "Parametric tests" "2-sample test of v&ariance" "ptev2dlg"
	wmenu append string "Parametric tests" "&Normality test" "ptntdlg"
	wmenu append string "Parametric tests" "&1-sample test of proportion" "pttpdlg"
	wmenu append string "Parametric tests" "&2-sample test of proportions" "ptp2dlg"
	
	wmenu append popout Statistics "&Nonparametric tests"
	wmenu append string "Nonparametric tests" "&Sign test" "stesdlg"
	wmenu append string "Nonparametric tests" "W&ilcoxon signed-ranks" "srandlg"
	wmenu append string "Nonparametric tests" "&Mann-Whitney" "rsumdlg"
	wmenu append string "Nonparametric tests" "Kruskal-&Wallis" "kwaldlg"
	wmenu append string "Nonparametric tests" "&Kolmogorov-Smirnov" "ksmdlg"
	
	wmenu append popout Statistics "&Correlation"
	wmenu append string Correlation "&Pearson (regular)" "pearsdlg"
	wmenu append string Correlation "&Spearman (rank)" "speardlg"
	
	wmenu append string Statistics "&Simple regression" "sregdlg"
	wmenu append string Statistics "&Multiple regression" "mregdlg"
	wmenu append string Statistics "&Robust regression" "rregdlg"
	wmenu append string Statistics "&Logistic regression" "logdlg"
	
	wmenu append popout Statistics "&ANOVA"
	wmenu append string ANOVA "One-way &nonparametric" "kwaldlg"
	wmenu append string ANOVA "&One-way" "onewdlg"
	wmenu append string ANOVA "&Repeated measures" "rpmdlg"
	wmenu append string ANOVA "&Two-way" "twowdlg 1"
	wmenu append string ANOVA "N-factor &ANOVA && ANOCOVA" "aovcdlg"
	
	wmenu append string Calculator "1-sample &normal test" "zt1dlg"
	wmenu append string Calculator "2-sample n&ormal test" "zt2dlg"
	wmenu append string Calculator "1-sample t &test" "tt1dlg"
	wmenu append string Calculator "2-sample t t&est" "tt2dlg"
	wmenu append string Calculator "&1-sample test of proportion" "tp1dlg"
	wmenu append string Calculator "&2-sample test of proportions" "tp2dlg"
	wmenu append string Calculator "1-sample test of &variance" "sdt1dlg"
	wmenu append string Calculator "2-sample test of v&ariance" "sdtdlg"
	wmenu append string Calculator "&Confidence interval for mean" "ccidlg"
	wmenu append string Calculator "&Binomial confidence interval" "bcidlg"
	wmenu append string Calculator "&Poisson confidence interval" "poidlg"
	
	wmenu append popout Calculator "&Statistical tables"
	wmenu append string "Statistical tables" "&Normal" "zdlg"
	wmenu append string "Statistical tables" "Student's &t" "tdlg"
	wmenu append string "Statistical tables" "&F" "fdlg"
	wmenu append string "Statistical tables" "&Chi-squared" "xdlg"
	wmenu append string "Statistical tables" "&Binomial" "bdlg"
	wmenu append string "Statistical tables" "&Poisson" "pdlg"

	wmenu append popout Calculator "&Inverse statistical tables"
	wmenu append string "Inverse statistical tables" "&Normal" "zidlg"
	wmenu append string "Inverse statistical tables" "Student's &t" "tidlg"
	wmenu append string "Inverse statistical tables" "&F" "fidlg"
	wmenu append string "Inverse statistical tables" "&Chi-squared" "xidlg"
	
	wmenu append string Calculator "St&andard calculator" "cstddlg"
	wmenu append string Calculator "&RPN calculator" "crpndlg"
	

	if "$S_OS" != "MacOS" {
		if "`doshlp'" != "1" {
			wmenu append string Help "&Help" "XEQ conhelp"
			wmenu append string Help "&About StataQuest..." "XEQ about"
		}
	}
	
	wmenu set StataQuest
	
	if "$S_level"=="" {
		global S_level 95
	}
	if $S_level < 10 | $S_level > 99 {
		global S_level 95
	}
	global D_level = $S_level
	global D_dlgx = 20
	global D_dlgy = 20
        di "StataQuest menus on.  The menubar has been changed."
end

program define getstpat
version 5.0
	local x = substr("$S_ADO", 1, index("$S_ADO",";")-1)
	if substr("`x'", -3,.) != "ado" {
		di in red "I do not understand how Stata is installed."
		di in red "The first element of S_ADO is not as I expect"
		di in red "it to be."
	}
       	if "$S_OS"=="Windows" {
		global qpath "`x'\\quest"
	}
	else {
		global qpath "`x':quest"
	}
end

