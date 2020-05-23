capture log close
log using "d:\data\ket qua.smcl",replace 

use "D:\DATA\biendoisolieu.step4.dta", clear
di "MO TA DAN SO"
tab1  gioi nhomtuoi
sum  tuoi
di "MO TA KET CUOC"
sum  chieucao cannang vongeo vonghong hamax hamin bmi
tab1  beophi tha
di "MO TA KET CUOC THEO DAN SO"
bysort  gioi: sum  chieucao cannang vongeo vonghong hamax hamin bmi
bysort gioi: tab1  beophi tha
di "THONG KE PHAN TICH"
tabulate tha beophi, chi2 column
ttest hamax, by(beophi)
ttest hamin, by(beophi)
