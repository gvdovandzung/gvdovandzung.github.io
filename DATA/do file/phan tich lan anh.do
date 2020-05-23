use "D:\DATA\banghuyetss miso.dta", clear
log using "D:\DATA\lan anh.smcl",replace
describe
summ
tab1 nhanhct
recode nhanhct (1=1 "Misoprostol") (0=2 "Placebo"), gen(canthiep)
di "BANG 1. So sanh dac diem dan so, thai nghen va chu sinh o hai nhom"
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
di "BANG 2. Phan tich ket cuoc giua 2 nhom"
cs bhss nhanhct
cs bhssnang nhanhct, exact
ttest maumat, by(canthiep)
di "BANG 2A. So sanh cham soc y te giua 2 nhom"
cs chuyenvien nhanhct, exact
cs truyenmau nhanhct, exact
cs sansocdacbiet nhanhct, exact
cs ctngoaikhoa nhanhct, exact
cs ttnoikhoa nhanhct, exact
graph box maumat, over(canthiep)
