*! version 1.0.1  19mar2010
program define cusumchart, rclass byable(recall)
	version 6.0, missing

	/* turn "==" into "=" if needed before calling -syntax- */
	gettoken vn rest : 0, parse(" =")
	gettoken eq rest : rest, parse(" =")
	if "`eq'" == "==" {
		local 0 `vn' = `rest'
	}
	syntax varlist(min=5 max=5) [, DATA CHART TEST]
	tokenize `varlist'
	args r s t x y	
	
	if ("`data'" == "data") {
		quiet gen cumsum = sum(`r')
		quiet gen rateexp = `s' * `t'
		quiet gen ratereal = `s' * `x'
		quiet gen k = (`t' + `x')/2
		quiet gen d = `y' + k
		local stop = _N
		quiet gen cusumscore = 0
		quiet gen cusumvalue = `r'[1]
		local i 2
		while (`i' <= `stop') {
			quiet gen s1 = cusumscore[`i'-1]
			quiet gen x1 = `r'[`i']
			quiet replace cusumvalue = s1 + x1 if _n == `i'
			quiet replace cusumscore = cusumvalue - k if _n == `i'
			quiet replace cusumscore = 0 if cusumscore < 0 & _n == `i'
			quiet replace cusumscore = 0 if cusumvalue > d & _n == `i'
			local i = `i' + 1 	
			quiet drop s1 x1
		}
	}
	if ("`chart'" == "chart") {
		local tit1 = "Cumulative value"
		local tit2 = "Satisfactory rate"
		local tit3 = "Unsatisfactory rate"
		local legend = `"order(1 `"`tit1'"' 2 `"`tit2'"' 3 `"`tit3'"')"'
		local title = `"Figure: CUSUM chart"'
			noi version 8, missing: graph twoway	///
			(line cumsum rateexp ratereal `s',		///
				sort				///
				ytitle(`"Cumulative Count"')		///
				xtitle(`"Case number"')		///
				title(`"`title'"')		///
				legend(`legend')		///
				scheme(`"s1color"')		///
			)
			exit
	}	
	if ("`test'" == "test") {	
		local tit1 = "CUSUM value"
		local tit2 = "K + h"
		local legend = `"order(1 `"`tit1'"' 2 `"`tit2'"')"'
		local title = `"Figure: CUSUM test chart"'
			noi version 8, missing: graph twoway	///
			(connected cusumvalue `s',		///
				sort				///
				msymbol(`"none"')		///
				connect(`"stairstep"')		///
				ytitle(`"CUSUM value"')		///
				xtitle(`"Case number"')		///
				title(`"`title'"')		///
				legend(`legend')		///
			) ///
			(line d `s',		///
				sort				///
				lpattern(`"solid"')		///
				scheme(`"s1color"')		///
			)
			exit
	}		
	ret add
end

