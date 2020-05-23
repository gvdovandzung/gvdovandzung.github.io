use "C:\DATA\ivf_v2.dta"
anova  tlsosinh nghenghiep,detail
matrix c1=(0,1,-1,0\0,1,0,-1\0,0,1,-1)
test, test(c1)  mtest(noadjust)
test, test(c1)  mtest(bonferroni)
