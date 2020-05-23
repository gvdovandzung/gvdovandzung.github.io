// use "D:\DATA\nin2.dta", clear
sum
gen tuoi=2000- namsinh
gen bmi= cannang/( chieucao/100)^2
replace bmi=round(bmi,0.01)
gen beophi=bmi>=25
replace beophi=bmi>=30
gen tangha= (hamax>=140) | (hamin>=90)
recode bmi (min/18.49= 1 "CED") (18.5/24.99 = 2 "Binh thuong") (25/29.99 =3  "Thua can") (30/max=4 "Beo phi"), gen(pldd)
gen beobung=( vongeo>=90 & gioi==1) | (vongeo>=80 & gioi==0)
recode hamax (min/119=-1 "bt") (120/139=0 "tien THA") (140/159=1 "THA1") (160/max=2 "THA2"), gen(sbpgrp)
recode hamin (min/79=-1 "bt") (80/89=0 "tien THA") (90/99=1 "THA1") (100/max=2 "THA2"), gen(dbpgrp)
gen plha=max(sbpgrp,dbpgrp)
save "D:\DATA\nin3.dta", replace
sum  tuoi bmi chieucao cannang vongeo vonghong
tab1  gioi tangha beophi beobung pldd plha
label value  plha sbpgrp
tab1  gioi tangha beophi beobung pldd plha
