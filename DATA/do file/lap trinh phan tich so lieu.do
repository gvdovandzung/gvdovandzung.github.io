use "D:\DATA\banghuyetss miso.dta", clear
describe
log using "D:\DATA\phan tich ket qua misoprostol.smcl", replace
summ
tab1  nhanhct
recode nhanhct (1=1 "Misoprostol") (0=2 "Placebo"), gen(canthiep)
tab1 canthiep
di "BANG 1"
ttest tuoi, by(canthiep)
ttest hemoglobin, by(canthiep)
ttest kcsinh, by(canthiep)
tabulate tienthai canthiep, chi2 column
tabulate bietchu canthiep, chi2 column
tabulate khamthai canthiep, chi2 column
tabulate sinhtainha canthiep, chi2 column
tabulate sinhnon canthiep, chi2 column
tabulate rachsinhmon canthiep, chi2 column
tabulate gioi canthiep, chi2 column
tabulate tlsosinh canthiep, chi2 column
cs bhss nhanhct
cs bhssnang nhanhct, exact
ttest maumat, by(canthiep)
cs chuyenvien nhanhct, exact
cs truyenmau nhanhct, exact
cs sansocdacbiet nhanhct, exact
cs ctngoaikhoa nhanhct, exact
cs ttnoikhoa nhanhct, exact
graph box maumat, over(canthiep)
