
use "D:\Dung\Research\2011_Thieu mau cu chi\file so lieu 2-8.dta", clear
drop if a1==8 | a1==15 | a1>=18
sort a1
merge a1 using "D:\Dung\Research\2011_Thieu mau cu chi\a1 xa.dta", uniqusing
gen p1=21/14
* Chon ngau nhien 14 xa trong tong so 21 xa
gen p2= bamexa/ bamemau
gen pwt = p1*p2
gen fpc=21

recode nhiemgiun (0=0) (1/2=1), gen(nhiemgiunchung)
gen agegr=.
replace agegr=0 if nhomtuoi==0
replace agegr=1 if nhomtuoi==1|nhomtuoi==2
label define agegr 0 "<=20" 1 ">20", modify
label value agegr agegr

recode MCV (min/79.9=1) (80/100=2) (100/max=3), gen (mcv)
label define mcv 1 "<80" 2 "80-100" 3 ">100", modify
label value mcv mcv


gen mucdo=.
replace mucdo=0 if phandothieumau==0
replace mucdo=1 if phandothieumau==1
replace mucdo=2 if phandothieumau==2|phandothieumau==3|phandothieumau==4
label define mucdo 0 binhthuong 1 nhe 2 trungnang, modify
label value mucdo mucdo

recode b5 (1/2=0 "<6 thang") (3=1 ">=6thang"), gen(b5a)
recode a4 (1=1 "cong nhan") (6=6 "noi tro") (else=8 "khac"), gen(a4a)
recode a3 (1/2=1 "mu chu/cap 1") (4/5=4 "cap 3+") (3=3 "cap 2"), gen(a3a)



svyset [pweight = pwt], fpc(fpc) psu(a1)
svy linearized : proportion nhomtuoi a5 a4a a3a b1 a7 b5a 

* So sanh nghe nghiep, giao duc, kinh te
xi: svy linearized : tab thieumauthieusat a4a, pearson col
xi: svy linearized : tab thieumauthieusat a3a, pearson col
xi: svy linearized : tab thieumauthieusat a7, pearson col
* So sanh cac yeu to b1 (so lan mang thai), b2 (so lan sinh con), b42(dieu hoa), b5(tuoithai)
xi: svy linearized : tab thieumauthieusat b1, pearson col
xi: svy linearized : tab thieumauthieusat b2, pearson col
xi: svy linearized : tab thieumauthieusat b42, pearson col
xi: svy linearized : tab thieumauthieusat b5, pearson col
* so sanh cac yeu to an uong tab1  c1 c21 c22 c23 c24 c25 - khong co y nghia c22
* Cac yeu to co anh huong la 
* di  an chay-c21, rau dau-c23, trai cay-c24, tra caphe-c25
xi: svy linearized : tab thieumauthieusat c21, pearson col
xi: svy linearized : tab thieumauthieusat c22, pearson col 
xi: svy linearized : tab thieumauthieusat c23, pearson col
xi: svy linearized : tab thieumauthieusat c24, pearson col
xi: svy linearized : tab thieumauthieusat c25, pearson col

* Cac yeu to co anh huong la viensat-c4, chan dat-c1,tay giun-c5 khong anh huong
recode c4 1=1 else=0
xi: svy linearized : tab thieumauthieusat c4, pearson col
recode c1 0=0 1/2=1
xi: svy linearized : tab thieumauthieusat c1, pearson col
xi: svy linearized : tab thieumauthieusat c5, pearson col

* Doi voi thieu mau cac yeu to bao ve gom vien sat-c4, an thit ca-c22, 
* Yeu co nguy co la: di chan dat-c1, so giun-c5, rau dau-c23, trai cay-c24  
xi: svy linearized : logistic thieumau c4 c1 c5 c21 c22 c23 c24 c25 b5a
xi: svy linearized : logistic thieumauthieusat c4 c1 c5 c21 c22 c23 c24 c25 b5a












