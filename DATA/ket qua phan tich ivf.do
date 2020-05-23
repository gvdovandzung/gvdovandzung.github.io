use "D:\DATA\ivf_v2.dta", clear
capture log close
log using "d:\data\ketqua1.smcl", replace
describe
di "DAC DIEM DAN SO"
sum  tuoime
tab1 nghenghiep gioi
di "MO TA KET CUOC: TRONG LUONG SO SINH VA TUOI THAI"
sum  tuoithai tlsosinh
tab1  sinhnon
di "MO TA KET CUOC THEO DAC TINH NEN"
sum  tuoithai tlsosinh
bysort gioi: sum  tuoithai tlsosinh
bysort gioi: tab1  sinhnon
bysort nghenghiep: sum  tuoithai tlsosinh
ttest tlsosinh, by(gioi)
ttest tlsosinh, by(tang_ha)
ttest tlsosinh, by(gioi)
ttest tlsosinh, by(tang_ha)
oneway tlsosinh nghenghiep, bonferroni
