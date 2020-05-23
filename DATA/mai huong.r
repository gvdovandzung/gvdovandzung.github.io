library(Hmisc)
library(thongke)
mh<-read.csv("d:/data/canh2.csv")
mh<-subset(mh,!is.na(mh$tuoi))
mh$gioi<-factor(mh$gioi,levels=c(0,1),labels=c("Nu","Nam"))

mh$hamt.r=mh$hamt1/mh$hamt2
mh$hamp.r=mh$hamp1/mh$hamp2
mh$trant.r=mh$tran1/mh$trant2
mh$tranp.r=mh$tran1/mh$tranp2
mh$buomt.r=mh$buomt1/mh$buom2
mh$buomp.r=mh$buomp1/mh$buom2

label(mh$gopt)<-"goc trai"
label(mh$gocp)<-"goc phai"
tab(gioi~gopt+gocp,data=mh)


label(mh$hamt1)<-"lo thong xoang ham tren duoi trai"
label(mh$hamp1)<-"lo thong xoang ham tren duoi phai"
label(mh$hamt2)<-"lo thong xoang ham truoc sau trai"
label(mh$hamp2)<-"lo thong xoang ham truoc sau phai"
label(mh$hamt.r)<-"ti so 2 kich thuoc cua xoang ham t"
label(mh$hamp.r)<-"ti so 2 kich thuoc cua xoang ham p"


label(mh$tran1)<-"lo thong xoang tran trong ngoai"
label(mh$trant2)<-"lo thong xoang tran truoc sau trai"
label(mh$tranp2)<-"lo thong xoang tran truoc sau phai"
label(mh$trant.r)<-"ti so 2 kich thuoc cua xoang tran t"
label(mh$tranp.r)<-"ti so 2 kich thuoc cua xoang tran p"

label(mh$buomt1)<-"lo thong xoang buom trong ngoai trai"
label(mh$buomp1)<-"lo thong xoang buom trong ngoai phai"
label(mh$buom2)<-"lo thong xoang buom tren duoi trai"
label(mh$buomt.r)<-"ti so 2 kich thuoc cua xoang buom t"
label(mh$buomp.r)<-"ti so 2 kich thuoc cua xoang buom p"

tab(gioi~hamt1+hamp1+hamt2+hamp2+hamt.r+hamp.r,data=mh)
t.test(mh$hamt1,mh$hamp1,paired=T)

tab(gioi~hamt1+hamp1+hamt2+hamp2+hamt.r+hamp.r,data=mh)


