use "D:\DATA\nhaplieu Bs Hong\mysurvey_z_rc.dta", clear
recode t (min/35.999=0 "<36 thang") (36/max=1 "36+ thang"), gen(nhomtuoi)
gen hcm=strpos(q4,"Q ")>0
replace hcm=1 if q4=="CAN GIO" | q4=="CU CHI" |q4=="HOC MON" | q4=="NHA BE" | q4=="THU DUC"
label define hcm 1 "TP Ho Chi Minh" 0 "Tinh"
label value hcm hcm

recode  _zwei (min/-2.0001 = 1 "SDD cannang/tuoi") (-2/max=0 "khong SDD cannang/tuoi"), gen(sddnhecan)
recode  _zlen (min/-2.0001 = 1 "SDD chieucao/tuoi") (-2/max=0 "khong SDD chieucao/tuoi"), gen(sddchieucao)


label define thuoc 0 "khong dieu tri" 1 "flixotide/seretide" 10 "singulair/monte" 11 "ket hop"
gen ktkm5r=0
replace ktkm5r=1 if strpos(ktkm5,"TIDE")
replace ktkm5r=1+10 if strpos(ktkm5,"SING") |strpos(ktkm5,"MONT")
label value ktkm5r thuoc
gen ktkh5r=0
replace ktkh5r=1 if strpos(ktkh5,"TIDE")
replace ktkh5r=1+10 if strpos(ktkh5,"SING") |strpos(ktkh5,"MONT")
label value ktkh5r thuoc
gen ktkb5r=0
replace ktkb5r=1 if strpos(ktkb5,"TIDE")
replace ktkb5r=1+10 if strpos(ktkb5,"SING") |strpos(ktkb5,"MONT")
label value ktkb5r thuoc

encode bvnc21, gen(bvnc21x)
recode bvnc21x (1/5=0 "nha tre") (6/11=1 "truong hoc"), gen(bvnc21r)
encode q12d, gen(q12dx)
recode q12dx (7=0 "khong thuoc") (1 2 9 10=1 "Flixotide Seretide don thuan") (8 12=2 "Montiget Singulair don thuan") (3/6 11=3 "Flixotide Seretide phoi hop Montiget Singulair"), gen(q12dr)
gen benhdiungkethop=q14a+q14b+q14c+q14d+q14e+q14f+q14g+q14h
recode benhdiungkethop (3/4=3 ">=3 benh"), gen(benhdiungkethopr)
gen avnc18a=avnc18!="KHONG"

foreach X of varlist v6b v7b v8b v9b v10b v11b {
gen `X'pos=`X'
replace `X'pos=0 if `X'<=v5b
recode `X'pos (0=0 "Am tinh") (1/5=1 "1+") (6/7=2 "2+") (8/10=3 "3+") (11/max=4 "4+"), gen(`X'posn)
recode `X'pos (0=0 "Am tinh") (1/max=1 "Duong tinh"), gen(`X'pos2)
}
gen soallergen=(v6bpos2>0)+(v7bpos2>0)+(v8bpos2>0)+(v9bpos2>0)+(v10bpos2>0)+(v11bpos2>0)



recode kshen (1=0 "kiem soat tot") (2=1 "kiem soat kem"), gen(outcome)


capture log close
log using "D:\DATA\nhaplieu Bs Hong\ket qua phan tich.smcl", replace

di "I. DAC DIEM DAN SO NGHIEN CUU (tan so, ti le)"

tab1 nhomtuoi q3 hcm bvnc20 bvnc21r	

di "5. Dinh duong: dua theo can nang va chieu cao theo tuoi"
tab1  sddnhecan sddchieucao

di "II. DAC DIEM LAM SANG (tan so, ti le)"
di "BENH SU"
tab1 kvnc9 q12d
tab1  benhdiungkethopr
di "TIEN SU"
sum q12a q12b q12c 
tab1 q12b

di "Tien su benh di ung khac (tan so, ti le)" 
tab1 q14a q14b q14c q14d q14e q14f q14g q14h q14ha
di "Benh di ung ket hop (tan so, ti le) " 
tab1  benhdiungkethopr
di "Tien su benh di ung gia dinh"
tab1 q15a q15aa q15b q15bb


di "Test da"
tab1 v6bpos2 v7bpos2 v8bpos2 v9bpos2 v10bpos2 v11bpos2
tab1 soallergen  

di "16. Di nguyen khong khi:  "

tab1 avnc1  avnc2  avnc3  avnc4  avnc5  
tab1 avnc6  avnc7  avnc8  avnc9  avnc10  
tab1 avnc11  avnc12  avnc13  avnc14  avnc15  
tab1 avnc16  avnc17  avnc18  avnc18a avnc19  avnc20

gen sodiung=avnc1+avnc2+avnc3+avnc4+ avnc6 +avnc7 + avnc8 +avnc9 
replace sodiung=avnc11 +avnc12 +avnc13 +avnc14 +avnc15+avnc16+avnc17+avnc19+avnc20

di "Khoi thuoc la"
tab1 bvnc1 bvnc2  bvnc3
di "bep gas"
tab1 bvnc4  
di "bep cui"
tab1 n14b  n14c  n14d  n14e  n14f  n14g  n14ga  
tab1 bvnc1  bvnc2  bvnc3  bvnc4  bvnc5  bvnc6  
tab1 bvnc6  bvnc7  bvnc8  bvnc9  bvnc10  bvnc11 bvnc12   
tab1 bvnc13  bvnc14  bvnc15  bvnc16  bvnc17  
tab1 bvnc18  bvnc19  bvnc20  bvnc21  bvnc22  bvnc23  
tab1 bvnc24  bvnc25  bvnc16  bvnc27  cvnc1  cvnc2  
tab1 cvnc3  cvnc4  cvnc5  cvnc6

gen sobvnc=bvnc1+bvnc2+bvnc3+bvnc4+bvnc5+bvnc6 +bvnc6+bvnc7+bvnc9+bvnc11  
replace sobvnc=sobvnc+bvnc13+bvnc15+bvnc17+bvnc18+bvnc19+bvnc20+bvnc24+cvnc1+cvnc2+cvnc4+cvnc5+cvnc6  
tab1 sobvnc

  


di "Thuoc dieu tri"
tab1  ktkm5r ktkh5r ktkb5r

di "Tuan thu dieu tri"
tab1  ktkm7 ktkh7 ktkb7

di "Quen dung thuoc"
tab1  ktkm6 ktkh6 ktkb6

di "Ky thuat dung thuoc"
tab1  ktkm8 ktkh8 ktkb8

di "PHAN DO KIEM SOAT HEN CHUNG (tan so, ti le)" 
tab1 kshen

di "LIEN QUAN GIUA KIEM SOAT HEN CHUNG VA DI UNG NGUYEN" 
tab1 kshen
foreach X of varlist v6bpos2 v7bpos2 v8bpos2 v9bpos2 v10bpos2 v11bpos2 {
cc outcome `X'
}

di  "LIEN QUAN GIUA KIEM SOAT HEN CHUNG VA DI UNG NGUYEN, phan tang tai kham khong thuong xuyen"
tab1 kshen
foreach X of varlist v6bpos2 v7bpos2 v8bpos2 v9bpos2 v10bpos2 v11bpos2 {
cc outcome `X', by(ktkb7)
}

di "LIEN QUAN GIUA KIEM SOAT HEN CHUNG VA DI UNG NGUYEN, phan tang quen dung thuoc"
tab1 kshen
foreach X of varlist v6bpos2 v7bpos2 v8bpos2 v9bpos2 v10bpos2 v11bpos2 {
cc outcome `X', by(ktkb6)
}

di "LIEN QUAN GIUA KIEM SOAT HEN CHUNG VA DI UNG NGUYEN, phan tang ki thuat dung thuoc"
tab1 kshen
foreach X of varlist v6bpos2 v7bpos2 v8bpos2 v9bpos2 v10bpos2 v11bpos2 {
cc outcome `X', by(ktkb8)
}


capture log close
log using "D:\DATA\nhaplieu Bs Hong\ket qua phan tich 2.smcl", replace

di "1. MO TA VA PHAN TICH DON BIEN"
di 	"1.1. PHAN TICH DI NGUYEN"
capture drop achung*
foreach stt of numlist 1/4 6/9 11/17 19 20 {
gen achung`stt'=avnc`stt' | atkm`stt' | atkh`stt' | atkb`stt'
tab1 avnc`stt'  atkm`stt'  atkh`stt'  atkb`stt' achung`stt' 
cc outcome achung`stt'
}

di 	"1.2. PHAN TICH O NHIEM KHONG KHI"
capture drop bchung*
foreach stt of numlist 1/7 9/13 15 17/20 22 24 26 {
gen bchung`stt'=bvnc`stt' | btkm`stt' | btkh`stt' | btkb`stt'
tab1 bvnc`stt'  btkm`stt'  btkh`stt'  btkb`stt' bchung`stt' 
cc outcome bchung`stt'
}

di 	"1.3. NHA TRE"
capture drop cchung*
foreach stt of numlist 1 2 4/6 {
gen cchung`stt'=cvnc`stt' | ctkm`stt' | ctkh`stt' | ctkb`stt'
tab1 cvnc`stt'  ctkm`stt'  ctkh`stt'  ctkb`stt' cchung`stt' 
cc outcome cchung`stt'
}

di 	"1.3. PHAN TICH ve dieu tri"
capture drop kchung*
gen kchung6= (ktkm6>1) | (ktkh6>1) | (ktkb6>1)
tab1 ktkm6 ktkh6 ktkb6 kchung6
cc outcome kchung6

foreach stt of numlist 7/8 {
gen kchung`stt'= ktkm`stt' | ktkh`stt' | ktkb`stt'
tab1 ktkm`stt'  ktkh`stt'  ktkb`stt' kchung`stt' 
cc outcome kchung`stt'
}

di "2. PHAN TICH DA BIEN"
logistic outcome achung3 achung6 achung12 achung17 achung19 kchung6 kchung8
logistic outcome bchung1 bchung5 bchung7 bchung11 kchung6 kchung8
logistic outcome cchung4 kchung6 kchung8









