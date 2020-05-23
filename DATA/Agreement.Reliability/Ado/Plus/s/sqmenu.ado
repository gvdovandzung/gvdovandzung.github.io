*! version 1.1.0  15oct1996
program define sqmenu
	version 5.0
/*	win menu clear*/
	win menu popout "StataQuest"
	win menu append popout "StataQuest" "&File"
	win menu append popout "StataQuest" "&Edit"
	win menu append popout "StataQuest" "&Prefs"
	win menu append popout "StataQuest" "&Data"
	win menu append popout "StataQuest" "&Graphs"
	win menu append popout "StataQuest" "S&ummaries"
	win menu append popout "StataQuest" "&Statistics"
	win menu append popout "StataQuest" "&Calculator"
	win menu append popout "StataQuest" "&Help"
	
	win menu append string File "&New" "newdlg"
	win menu append string File "&Open..." "XEQ use"
	win menu append string File "&Save" "XEQ save"
	win menu append string File "Save &As..." "XEQ saveas"
	win menu append separator File
	win menu append string File "Save &Graph" "XEQ savegr"
	win menu append string File "&Print Graph" "prgphdlg"
	win menu append string File "Print &Log" "XEQ printlog"
	win menu append separator File
	win menu append string File "&Import ASCII" "impdlg"
	win menu append string File "&Export ASCII" "expdlg"
	win menu append separator File
	win menu append string File "E&xit" "XEQ exit"
	
	win menu append popout Data "&Generate/Replace"
	win menu append string "Generate/Replace" "&Random numbers" "rnddlg"
	win menu append string "Generate/Replace" "S&equence" "seqdlg"
	win menu append string "Generate/Replace" "&Formula" "formdlg"
	win menu append string "Generate/Replace" "Re&code" "recdlg"
	
	win menu append popout Data "&Label"
	win menu append string Label "Label &dataset" "dslabdlg"
	win menu append string Label "Label va&riable" "varldlg"
	win menu append string Label "Label &values" "vlabdlg"
	win menu append string Label "&Strings to labels" "stldlg"
	win menu append string Label "&Labels to strings" "ltsdlg"
	
	win menu append string Data "&Edit data" "edit"

	win menu append string Data "&Stack variables" "stkdlg"
	
	win menu append popout Graphs "&One variable"
	win menu append popout "One variable" "&Histogram"
	win menu append string "Histogram" "&Continuous variable" "histdlg"
	win menu append string "Histogram" "&Discrete variable" "chistdlg"
	win menu append string "One variable" "&Box plot" "boxdlg box"
	win menu append string "One variable" "Box plot && &one-way" "boxdlg boxone"
	win menu append string "One variable" "&Stem-and-leaf" "stemdlg"
	win menu append string "One variable" "&Dotplot" "dpldlg"
	win menu append string "One variable" "&Normal quantile plot" "qnormdlg"
	
	win menu append popout Graphs "One variable &by group"
	win menu append popout "One variable by group" "&Histograms by group"
	win menu append string "Histograms by group" "&Continuous variable" "hstbydlg"
	win menu append string "Histograms by group" "&Discrete variable" "chbydlg"
	win menu append string "One variable by group" "&Box plots by group" "boxbydlg"
	win menu append string "One variable by group" "B&ar charts by group" "barbydlg"
	win menu append string "One variable by group" "&Dotplots by group" "dplbdlg"
	
	win menu append popout Graphs "&Comparison of variables"
	win menu append string "Comparison of variables" "&Box plot comparison" "boxdlg boxes"
	win menu append string "Comparison of variables" "Box plot && &one-way comparison" "box1sdlg"
	win menu append string "Comparison of variables" "B&ar chart comparison" "barsdlg"
	win menu append string "Comparison of variables" "Bar chart comparison by &group" "barbydlg bars"
	
	win menu append popout Graphs "&Scatterplots"
	win menu append string "Scatterplots" "&Plot Y vs. X" "sp2dlg"
	win menu append string "Scatterplots" "Plot Y vs. X, &naming points" "sp3dlg name"
	win menu append string "Scatterplots" "Plot Y vs. X, with &regression line" "sp2dlg reg"
	win menu append string "Scatterplots" "Plot Y vs. X, &scale symbols to Z" "sp3dlg scale"
	win menu append string "Scatterplots" "Plot Y vs. X, &by group" "sp3dlg by"
	win menu append string "Scatterplots" "Scatterplot &matrix" "spmatdlg"
	
	win menu append popout Graphs "&Time series"
	win menu append string "Time series" "&Plot Y vs. X" "sp2dlg ts1"
	win menu append string "Time series" "Plot Y vs. &obs. no." "ts1dlg"
	win menu append string "Time series" "Plot &more than one Y vs. X" "ts2dlg"
	win menu append string "Time series" "P&lot more than one Y vs. obs. no." "ts1dlg mto"
	
	win menu append popout Graphs "&Quality control"
	win menu append string "Quality control" "&Control (C) chart for defects" "qc2dlg"
	win menu append string "Quality control" "&Fraction defective (P) chart" "qc3dlg"
	win menu append string "Quality control" "&Range (R) chart" "qc1dlg range"
	win menu append string "Quality control" "&X-bar chart" "qc1dlg xbar"
	win menu append string "Quality control" "X-&bar && R chart" "qc1dlg xbarpr"
	
	win menu append string Graphs "&View saved graphs" "gphview"
	
	win menu append string Summaries "&Means and SDs" "summdlg"
	
	win menu append popout Summaries "Means and SDs &by group"
	win menu append string "Means and SDs by group" "One-way of &means" "onemdlg"
	win menu append string "Means and SDs by group" "&Two-way of means" "tsumdlg"
	
	win menu append string Summaries "Median/&Percentiles" "dtldlg"
	win menu append string Summaries "&Confidence intervals" "scidlg"

	win menu append popout Summaries "&Tables"
	win menu append string Tables "&One-way (frequency)" "onedlg"
	win menu append string Tables "Two-way (&cross-tabulation)" "twodlg"
	win menu append string Tables "Three-way (by &group)" "tsbydlg"
	
	win menu append string Summaries "Dataset &info" "ndlg" 
	win menu append string Summaries "&Describe variables" "descdlg"
	win menu append string Summaries "&List data" "listdlg"
	
	win menu append popout Statistics "&Parametric tests"
	win menu append string "Parametric tests" "1-sample t &test" "ptt1dlg"
	win menu append string "Parametric tests" "2-sample t t&est" "ptt2dlg"
	win menu append string "Parametric tests" "&Paired t test" "ptt2pdlg"
	win menu append string "Parametric tests" "1-sample test of &variance" "ptev1dlg"
	win menu append string "Parametric tests" "2-sample test of v&ariance" "ptev2dlg"
	win menu append string "Parametric tests" "&Normality test" "ptntdlg"
	win menu append string "Parametric tests" "&1-sample test of proportion" "pttpdlg"
	win menu append string "Parametric tests" "&2-sample test of proportions" "ptp2dlg"
	
	win menu append popout Statistics "&Nonparametric tests"
	win menu append string "Nonparametric tests" "&Sign test" "stesdlg"
	win menu append string "Nonparametric tests" "W&ilcoxon signed-ranks" "srandlg"
	win menu append string "Nonparametric tests" "&Mann-Whitney" "rsumdlg"
	win menu append string "Nonparametric tests" "Kruskal-&Wallis" "kwaldlg"
	win menu append string "Nonparametric tests" "&Kolmogorov-Smirnov" "ksmdlg"
	
	win menu append popout Statistics "&Correlation"
	win menu append string Correlation "&Pearson (regular)" "pearsdlg"
	win menu append string Correlation "&Spearman (rank)" "speardlg"
	
	win menu append string Statistics "&Simple regression" "sregdlg"
	win menu append string Statistics "&Multiple regression" "mregdlg"
	win menu append string Statistics "&Robust regression" "rregdlg"
	win menu append string Statistics "&Logistic regression" "logdlg"
	
	win menu append popout Statistics "&ANOVA"
	win menu append string ANOVA "One-way &nonparametric" "kwaldlg"
	win menu append string ANOVA "&One-way" "onewdlg"
	win menu append string ANOVA "&Repeated measures" "rpmdlg"
	win menu append string ANOVA "&Two-way" "twowdlg 1"
	win menu append string ANOVA "N-factor &ANOVA && ANOCOVA" "aovcdlg"
	
	win menu append string Calculator "1-sample &normal test" "zt1dlg"
	win menu append string Calculator "2-sample n&ormal test" "zt2dlg"
	win menu append string Calculator "1-sample t &test" "tt1dlg"
	win menu append string Calculator "2-sample t t&est" "tt2dlg"
	win menu append string Calculator "&1-sample test of proportion" "tp1dlg"
	win menu append string Calculator "&2-sample test of proportions" "tp2dlg"
	win menu append string Calculator "1-sample test of &variance" "sdt1dlg"
	win menu append string Calculator "2-sample test of v&ariance" "sdtdlg"
	win menu append string Calculator "&Confidence interval for mean" "ccidlg"
	win menu append string Calculator "&Binomial confidence interval" "bcidlg"
	win menu append string Calculator "&Poisson confidence interval" "poidlg"
	
	win menu append popout Calculator "&Statistical tables"
	win menu append string "Statistical tables" "&Normal" "zdlg"
	win menu append string "Statistical tables" "Student's &t" "tdlg"
	win menu append string "Statistical tables" "&F" "fdlg"
	win menu append string "Statistical tables" "&Chi-squared" "xdlg"
	win menu append string "Statistical tables" "&Binomial" "bdlg"
	win menu append string "Statistical tables" "&Poisson" "pdlg"

	win menu append popout Calculator "&Inverse statistical tables"
	win menu append string "Inverse statistical tables" "&Normal" "zidlg"
	win menu append string "Inverse statistical tables" "Student's &t" "tidlg"
	win menu append string "Inverse statistical tables" "&F" "fidlg"
	win menu append string "Inverse statistical tables" "&Chi-squared" "xidlg"
	
	win menu append string Calculator "St&andard calculator" "cstddlg"
	win menu append string Calculator "&RPN calculator" "crpndlg"
	
	win menu append string Help "&Help" "XEQ conhelp"
	win menu append string Help "&About StataQuest..." "XEQ about"
	
	win menu set StataQuest
	
	if "$S_level"=="" {
		global S_level 95
	}
	if $S_level < 10 | $S_level > 99 {
		global S_level 95
	}
	global D_level = $S_level
	global D_dlgx = 20
	global D_dlgy = 20
end
