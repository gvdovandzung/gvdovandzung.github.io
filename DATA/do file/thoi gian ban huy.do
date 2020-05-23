use C:\Users\minhanh\Desktop\geu_data_4.dta,clear
keep  bhcg_1 bhcg_4 bhcg_7 bhcg_14 nhom tuoi snv
reshape long bhcg_, i(snv) j(ngay)
gen loghcg=log( bhcg_)/log(2)
recode nhom 1=0 2=1
gen nhomngay=nhom*ngay
regress  loghcg  nhomngay ngay
xtset snv ngay
xtgee loghcg ngay nhomngay, family(gaussian) link(identity) corr(independent) vce(robust)
graph matrix loghcg ngay nhomngay
