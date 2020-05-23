capture log close
log using "d:\data\kqthieumau.smcl", replace
di "MO TA DAC DIEM DAN SO"
sum age b1 b2 b41a b42a b5
tab1   a1 a3 a4 a5 a6 a7 b3 b41 b42 b6
di "MO TA KET CUOC"
tab1  thieumau thieumauthieusat
format   a1 a3 a4 a5 a6 a7 b3 b41 b42 b6 %10.0f
bysort a3: tab1  thieumau thieumauthieusat
bysort a4: tab1  thieumau thieumauthieusat
bysort a5: tab1  thieumau thieumauthieusat
bysort a6: tab1  thieumau thieumauthieusat
bysort a7: tab1  thieumau thieumauthieusat
bysort b3: tab1  thieumau thieumauthieusat
bysort b41: tab1  thieumau thieumauthieusat
bysort b42: tab1  thieumau thieumauthieusat
bysort b6: tab1  thieumau thieumauthieusat
di "THONG KE PHAN TICH"
tabulate thieumau c1, chi2 column
tabulate thieumau c21, chi2 column
tabulate thieumau c22, chi2 column
tabulate thieumau c23, chi2 column
tabulate thieumau c24, chi2 column
tabulate thieumau c25, chi2 column
tabulate thieumau c26, chi2 column
tabulate thieumau c3, chi2 column
tabulate thieumau c4, chi2 column
tabulate thieumau c5, chi2 column
tabulate thieumau c6, chi2 column
