tab b42a
tab  thieumauthieusat b42a, chi col row exact exp

gen agegr=.
replace agegr=0 if nhomtuoi==0
replace agegr=1 if nhomtuoi==1|nhomtuoi==2
label define agegr 0 "<=20" 1 ">20", modify
label value agegr agegr

tab thieumauthieusat b42, col chi exact exp row

recode MCV (min/79.9=1) (80/100=2) (100/max=3), gen (mcv)
label define mcv 1 "<80" 2 "80-100" 3 ">100", modify
label value mcv mcv

gen mucdo=.
replace mucdo=0 if phandothieumau==0
replace mucdo=1 if phandothieumau==1
replace mucdo=2 if phandothieumau==2|phandothieumau==3|phandothieumau==4
label define mucdo 0 binhthuong 1 nhe 2 trungnang, modify
label value mucdo mucdo

tab mucdo agegr, chi col row exact exp
tab a3 mucdo, chi col row exact exp
tab a4 mucdo, chi col row exact exp

tab a5 mucdo, chi col row exact exp
tab a6 mucdo, chi col row exact exp
tab a7 mucdo, chi col row exact exp
tab c1 mucdo, chi col row exact exp
tab c5 mucdo, chi col row exact exp
tab nhiemgiun mucdo, chi col row exact exp
tab b71 mucdo, chi col row exact exp
tab b72 mucdo, chi col row exact exp
tab b73 mucdo, chi col row exact exp
tab b74 mucdo, chi col row exact exp

