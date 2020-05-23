*! version 3.0.9  20dec2004
program define buitest, rclass byable(recall)
	version 6.0, missing

	/* turn "==" into "=" if needed before calling -syntax- */
	gettoken vn rest : 0, parse(" =")
	gettoken eq rest : rest, parse(" =")
	if "`eq'" == "==" {
		local 0 `vn' = `rest'
	}
	syntax varlist(min=2 max=2)
	tokenize `varlist'
	args y x
	sdtest `y', by(`x')
	if ($S_7>0.05) {
		di as txt "HAY DUNG KIEM DINH T TEST VOI PHUONG SAI BANG NHAU VI p = $S_7 > 0.05"
		ttest `y', by(`x')
		exit
	}
	else {
		di as txt "HAY DUNG KIEM DINH T TEST VOI PHUONG SAI KHONG BANG NHAU VI p = $S_7 < 0.05"
		ttest `y', by(`x') unequal
		exit
	}
	ret add
end
