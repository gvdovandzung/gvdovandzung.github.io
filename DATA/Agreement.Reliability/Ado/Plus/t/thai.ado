*! version 3.0.9  20dec2004
program define thai, rclass byable(recall)
	version 6.0, missing

	/* turn "==" into "=" if needed before calling -syntax- */
	gettoken vn rest : 0, parse(" =")
	gettoken eq rest : rest, parse(" =")
	if "`eq'" == "==" {
		local 0 `vn' = `rest'
	}
	syntax varlist(min=2 max=2) [, OR RR PR IT DL BC]
	tokenize `varlist'
	args y x	

	/* PHAN TICH BIEN SO DINH LUONG */
	
	/* Xet xem bien phu thuoc co phan phoi binh thuong hay khong - chi xet tuong doi dua vao trung binh va do lech chuan */
	quiet sum `y'
	scalar normal_dist = r(mean) - 2 * r(sd) 

	/* Dem xem bien so DOC LAP co bao nhieu nhom */
	quiet sum `x'
	scalar groupindep = r(max) - r(min) 
	
	/* Dem xem bien so PHU THUOC co bao nhieu nhom */
	quiet sum `y'
	scalar groupdep = r(max) - r(min)

	/* TH1 - TH6: PHU THUOC la bien dinh luong */
	/* TH1: PHU THUOC dinh luong khong binh thuong + DOC LAP dinh tinh 2 nhom */
	if groupdep > 6 & normal_dist <= 0 & groupindep==1 {
		tab `x', sum(`y')
		ranksum `y', by(`x')
		exit
	}
	
	/* TH2: PHU THUOC dinh luong khong binh thuong + DOC LAP dinh tinh >=3 nhom */
	if groupdep > 6 & normal_dist <= 0 & groupindep>=2 & groupindep <=6 {
		tab `x', sum(`y')
		kwallis `y', by(`x')
		exit
	}
	
	/* TH3: PHU THUOC dinh luong khong binh thuong + DOC LAP dinh luong */
	if groupdep > 6 & normal_dist <= 0 & groupindep > 6 {
		regress `y' `x'		
		exit
	}
	
	/* TH4: PHU THUOC dinh luong binh thuong + DOC LAP dinh tinh 2 nhom */
	if groupdep > 6 & normal_dist > 0 & groupindep==1 {
		qui sdtest `y', by(`x')
		if ($S_7>=0.05) {
			di "DAY LA KIEM DINH T TEST VOI PHUONG SAI BANG NHAU VI p CUA KIEM DINH PHUONG SAI = $S_7 > 0.05"
			ttest `y', by(`x')
			exit
		}
		else {
			di "DAY LA KIEM DINH T TEST VOI PHUONG SAI KHONG BANG NHAU VI p CUA KIEM DINH PHUONG SAI = $S_7 < 0.05"
			ttest `y', by(`x') unequal
			exit
		}
	}
	
	/* TH5: PHU THUOC dinh luong binh thuong + DOC LAP dinh tinh >=3 nhom */
	if groupdep > 6 & normal_dist > 0 & groupindep>=2 & groupindep <=6 {
		quiet oneway `y' `x', tabulate
		scalar pvalue = chi2tail(r(df_bart),r(chi2bart))
		if pvalue >= 0.05 {
			oneway `y' `x', bonferroni tabulate
		}
		else {
			tab `x', sum(`y')			
			di "KIEM DINH KRUSKAL WALLIS DUOC DUNG VI p CUA KIEM DINH PHUONG SAI = " pvalue " < 0.05"
			kwallis `y', by(`x')			
		}		
		exit
	}
	
	/* TH6: PHU THUOC dinh luong binh thuong + DOC LAP dinh luong */
	if groupdep > 6 & normal_dist > 0 & groupindep >6 {
		di "TINH VA KIEM DINH HE SO TUONG QUAN"
		pwcorr `x' `y', sig star(5)
		di " "
		di "PHUONG TRINH HOI QUY"
		regress `y' `x'		
		exit
	}
	
	/* TH7 - TH9: PHU THUOC la bien dinh tinh 2 nhom */
	/* TH7: PHU THUOC dinh tinh 2 nhom + DOC LAP dinh tinh 2 nhom */
	if groupdep==1 & groupindep==1 {
		tab `x' `y', co ro chi exact
		di " "
		di "LUU Y: KHI 20% SO VONG TRI < 5 HOAC CO GIA TRI TRONG O < 5 THI NEN SU DUNG FISHER"
		qui sum `y'
		if r(min)!= 0 {
			di "MUON TINH CAC CHI SO DICH TE HOC (OR, RR, PR) THI BIEN SO PHU THUOC PHAI DUOC MA HOA LA 0 VA 1."
			di "VUI LONG MA HOA LAI HOAC SU DUNG CAU LENH KHAC."
			exit
		}
		qui sum `x'
		if r(min)!= 0 {
			di "MUON TINH CAC CHI SO DICH TE HOC (OR, RR, PR) THI BIEN SO DOC LAP PHAI DUOC MA HOA LA 0 VA 1."
			di "VUI LONG MA HOA LAI HOAC SU DUNG CAU LENH KHAC."
			exit
		}		
		if "`or'" == "or" {
			cc `y' `x'
			exit
		}
		if "`rr'" == "rr" {
			cs `y' `x'
			exit
		}
		cs `y' `x'
		exit
	}
	
	/* TH8: PHU THUOC dinh tinh 2 nhom + DOC LAP dinh tinh >=3 nhom */
	if groupdep==1 & groupindep >= 2 & groupindep <= 6 {
		tab `x' `y', co ro chi exact
		di " "
		di "LUU Y: KHI 20% SO VONG TRI < 5 HOAC CO GIA TRI TRONG O < 5 THI NEN SU DUNG FISHER"
		qui nptrend `y', by(`x')
		scalar ptrend = r(p)
		qui sum `y'
		if r(min)!= 0 {
			di "MUON TINH CAC CHI SO DICH TE HOC (OR, RR, PR) THI BIEN SO PHU THUOC PHAI DUOC MA HOA LA 0 VA 1."
			di "VUI LONG MA HOA LAI HOAC SU DUNG CAU LENH KHAC."
			exit
		}
		if ptrend < 0.05 {          /* CO tinh chat khuynh huong*/
			if "`or'" == "or" {
				di " "
				di "PHAN TICH PHAN TANG (OR) THEO KHUYNH HUONG VI KIEM DINH KHUYNH HUONG p = " ptrend " < 0.05"
				if "`it'" == "it" {
					glm `y' `x', family(binomial 1) link(logit) eform irls
					exit
				}				
				glm `y' `x', family(binomial 1)  link(logit)  eform
				exit
			}
			if "`rr'" == "rr" {
				di " "
				di "PHAN TICH PHAN TANG (RR) THEO KHUYNH HUONG VI KIEM DINH KHUYNH HUONG p = " ptrend " < 0.05"
				if "`it'" == "it" {
					glm `y' `x', family(binomial 1) link(log) eform irls
					exit
				}				
				glm `y' `x', family(binomial 1)  link(log)  eform
				exit
			}
			di " "
			di "PHAN TICH PHAN TANG (RR) THEO KHUYNH HUONG VI KIEM DINH KHUYNH HUONG p = " ptrend " < 0.05"
			if "`it'" == "it" {
				glm `y' `x', family(binomial 1) link(log) eform irls
				exit
			}				
			glm `y' `x', family(binomial 1)  link(log)  eform
			exit
		}
		else {                       /* KHONG co tinh chat khuynh huong*/
			if "`or'" == "or" {
				di " "
				di "PHAN TICH PHAN TANG (OR) THEO YEU TO VI KIEM DINH KHUYNH HUONG p = " ptrend " > 0.05"
				if "`it'" == "it" {
					xi: glm `y' i.`x', family(binomial 1) link(logit) eform irls
					exit
				}				
				xi: glm `y' i.`x', family(binomial 1)  link(logit)  eform
				exit
			}
			if "`rr'" == "rr" {
				di " "
				di "PHAN TICH PHAN TANG (RR) THEO YEU TO VI KIEM DINH KHUYNH HUONG p = " ptrend " > 0.05"
				if "`it'" == "it" {
					xi: glm `y' i.`x', family(binomial 1) link(log) eform irls
					exit
				}				
				xi: glm `y' i.`x', family(binomial 1)  link(log)  eform
				exit
			}
			di " "
			di "PHAN TICH PHAN TANG (RR) THEO YEU TO VI KIEM DINH KHUYNH HUONG p = " ptrend " > 0.05"
			if "`it'" == "it" {
				xi: glm `y' i.`x', family(binomial 1) link(log) eform irls
				exit
			}				
			xi: glm `y' i.`x', family(binomial 1)  link(log)  eform
			exit
		}
	}

	/* TH9: PHU THUOC dinh tinh 2 nhom + DOC LAP dinh luong */
	if groupdep==1 & groupindep > 6 {
		qui sum `y'
		if r(min)!= 0 {
			di "BIEN SO PHU THUOC PHAI DUOC MA HOA LA 0 VA 1."
			di "VUI LONG MA HOA LAI HOAC SU DUNG CAU LENH KHAC."
			exit
		}
		if "`or'" == "or" {
			if "`it'" == "it" {
				glm `y' `x', family(binomial 1) link(logit) eform irls
				exit
			}				
			glm `y' `x', family(binomial 1)  link(logit)  eform
			exit
		}
		if "`rr'" == "rr" {
			if "`it'" == "it" {
				glm `y' `x', family(binomial 1) link(log) eform irls
				exit
			}				
			glm `y' `x', family(binomial 1)  link(log)  eform
			exit
		}
		if "`it'" == "it" {
			glm `y' `x', family(binomial 1) link(log) eform irls
			exit
		}				
		glm `y' `x', family(binomial 1)  link(log)  eform
		exit
	}
	
	/* TH10 - TH12: PHU THUOC la bien dinh tinh >=3 nhom */
	/* TH10: PHU THUOC dinh tinh >=3 nhom + DOC LAP dinh tinh 2 nhom */
	
	/* TH11: PHU THUOC dinh tinh >=3 nhom + DOC LAP dinh tinh >=3 nhom */

	/* TH12: PHU THUOC dinh tinh >=3 nhom + DOC LAP dinh luong */

	ret add
end
