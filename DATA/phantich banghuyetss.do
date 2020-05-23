di "use "D:\DATA\banghuyetss miso.dta", clear"
capture log close
log using "d:\data\ketqua banghuyetss.smcl",replace
describe
browse
summ
describe
di "MO TA DAC DIEM DAN SO"
sum  tuoi hemoglobin kcsinh
tab1  tienthai bietchu khamthai sinhtainha sinhnon rachsinhmon gioi tlsosinh
bysort  nhanhct: sum  tuoi hemoglobin kcsinh
bysort nhanhct: tab1  tienthai bietchu khamthai sinhtainha sinhnon rachsinhmon gioi tlsosinh
di "MO TA KET CUOC"
tab1  bhss bhssnang
di "THONG KE PHAN TICH"
tabulate bhss nhanhct, chi2 column
tabulate bhssnang nhanhct, chi2 column exact
tabulate chuyenvien nhanhct, chi2 column exact
tabulate truyenmau nhanhct, chi2 column exact
tabulate sansocdacbiet nhanhct, chi2 column exact
tabulate ctngoaikhoa nhanhct, chi2 column exact
tabulate ttnoikhoa nhanhct, chi2 column exact
