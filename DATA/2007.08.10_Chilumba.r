remove(list=ls())
setwd("c:/data")
library(foreign)
library(Hmisc)
library(epitools)
blnColumn=T
#source("functions_ztable.r")
#===============================================================================
# FUNCTIONS DEFINITIONS
#===============================================================================

#===============================================================================
fcatTest<-function(tab) {
min1<-min(expected(tab))
st <- if(!is.matrix(tab) || nrow(tab) < 2)
list(p.value=NA, statistic=NA, parameter=NA) else
     (if (min1<5)
     fisher.test(tab) else
     chisq.test(tab, correct=FALSE))
f1<-if (min1<5) list(P=st$p.value, stat=1,
     df=1, testname='Fisher', statname='Fisher',
     latexstat='\\chi^{2}_{df}', plotmathstat='chi[df]^2') else
     list(P=st$p.value, stat=st$statistic,
     df=st$parameter,
     testname='Pearson', statname='Chi-square',
     latexstat='\\chi^{2}_{df}', plotmathstat='chi[df]^2')
return(f1)
     }
fcatTest(table(data1$gioi,data1$ntrungph))
# fcatTest(table(davayca,dt02))
#===============================================================================


ztable<-function(depent1,vFormula,overall=F,exclude1=T) {  # Hoi quy cho ca tiep xuc hcpx
for (i in 1:length(vFormula)) {
strFunc<-paste(depent1,"~",vFormula[i],sep="")
print(strFunc)
sum1<-summary(as.formula(strFunc),data=data1,
    method="reverse",test=T,continuous=8,overall=overall,catTest=fcatTest)
p1<-print(sum1,prmsd=T,digits=3,exclude1=exclude1,pctdig=1)
if (blnColumn) {print(noquote(p1))}
}
}
#===============================================================================
ztablenull<-function(vFormula,exclude1=F) {  # Hoi quy cho ca tiep xuc hcpx
for (i in 1:length(vFormula)) {
strFunc<-paste("~",vFormula[i],sep="")
print(strFunc)
sum1<-summary(as.formula(strFunc),data=data1,
    method="reverse",continuous=8)
p1<-print(sum1,prmsd=T,digits=3,exclude1=exclude1)
if (blnColumn) {print(noquote(p1))}
}
}

zsum1<- function(x,detail=F,conf.int = 0.95){
    x<-as.numeric(x)
    x <- x[!is.na(x)]
    n <- length(x)
    if (n==0) {xbar<-NA;sd1<-NA;se<-NA;median1<-NA;max1<-NA;min1<-NA}
    else
    {
    xbar <- sum(x)/n
    sd1<-ifelse(n==1,NA,sqrt(sum((x - xbar)^2)/(n - 1)))
    se <- ifelse(n==1,NA,sqrt(sum((x - xbar)^2)/n/(n - 1)))
    median1<-median(x)
    max1<-max(x)
    min1<-min(x)
    }
    if (detail) {
    mult <- qt((1 + conf.int)/2, n - 1)
    temp<-c(N=n, mean=xbar ,sd=sd1,
          se=se,Lower = xbar - mult * se, Upper = xbar + mult * se,
          median=median1, Min=min1, Max=max1)
    } else
    temp<-c(N=n, mean=xbar ,sd=sd1,
          median=median1, Min=min1, Max=max1)
    return(temp)
}

zor<-function(depent1,vFormula,overall=F,exclude1=F) {  # Hoi quy cho ca tiep xuc hcpx
v1<-vFormula[1]
if (length(vFormula)>=2) {
for (i in 2:length(vFormula)) {
v1<-paste(v1,vFormula[i],sep="+")
}
}
strFunc<-paste(depent1,"~",v1)
print(strFunc)
sum1<-summary(as.formula(strFunc),data=data1,
    method="reverse",test=T,continuous=8,overall=overall,catTest=fcatTest)
p1<-print(sum1,prmsd=T,digits=3,long=T,exclude1=exclude1)
if (blnColumn) {print(noquote(p1))}
for (i in 1:length(vFormula)) {
     cat(ifelse(label(data1[,vFormula[i]])=="",vFormula[i],label(data1[,vFormula[i]])),"\n")
     or1<-NULL
     try (or1<-oddsratio(data1[,vFormula[i]],data1[,depent1],method="midp",rev="columns"),T)
     if (is.null(or1)) print("Cannot calculate OR") else {
     print("OR (95%CI) : \n")
     print(or1$measure[-1,])
     }
     cat("\n")

}
}

zor.stata<-function(depent1,vFormula,overall=F,exclude1=F) {  # Hoi quy cho ca tiep xuc hcpx
for (i in 1:length(vFormula)) {
strFunc<-paste(vFormula[i],"~",depent1,sep="")
print(strFunc)
sum1<-summary(as.formula(strFunc),data=data1,
    method="reverse",test=T,continuous=8,overall=overall,catTest=fcatTest)
p1<-print(sum1,prmsd=T,digits=3,long=T,exclude1=exclude1)
if (blnColumn) {print(noquote(p1))}
# cc(data1[,depent1],data1[,vFormula[i]],graph = TRUE)
or1<-oddsratio(data1[,vFormula[i]],data1[,depent1],method="midp",rev="both")
#print(or1)
print("OR (95%CI) : \n")
print(or1$measure[-1,])
}
}

zanti<- function(X,detail=F, conf.int = 0.95) {
iVar<-ncol(X)
if (!is.null(iVar)) {
  Temp1 <- NULL
  rowname1<-colnames(X)

  for (i in 1:iVar) {
    x<-X[,i]
    N<-length(x)
          n1<-sum(x=="S")
          n2<-sum(x=="I")
          n3<-sum(x=="R")
    Temp1<-rbind(Temp1,c(N=N,Sensi=n1,S_pct=round(n1*100/N),
                             Inter=n2,I_pct=round(n2*100/N),
                             Resis=n3,R_pct=round(n3*100/N) ))
    rowname1[i]<-ifelse(label(X[,i])=="",rowname1[i],label(X[,i]))
    }
   rownames(Temp1)<-rowname1
  }
  else
  {
  Temp1<-c(N=N,Sens=n1,Senspct=round(n1*100/N),
                             Inte=n2,Intepct=round(n2*100/N),
                             Resi=n3,Resipct=round(n3*100/N) )
  Temp1<-rbind(Temp1,Temp1)
   rownames(Temp1)<-rowname1
  }
  return(Temp1)
}

zfreqco2<-function(v1) {
if (is.matrix(v1))
        apply(v1, 2, zfreqco2)
        else {
v1<-factor(v1[!is.na(v1)])
n2<-sum(v1=="co")
n2<-ifelse(n2>0,n2,sum(v1==T))
N<-sum(!is.na(v1))
temp<-c(n=n2,percent=round(n2/N,3))
return(temp)
}
}

zfreq3<-function(v1) {
v1<-factor(v1[!is.na(v1)])
n1<-sum(as.numeric(v1)==1)
n2<-sum(as.numeric(v1)==2)
N<-sum(!is.na(v1))
temp1<-c(n1,round(n1*100/N,1),n2,round(n2*100/N,1))
return(temp1)
}

zfreq2<-function(v1) {
if (is.matrix(v1))
        apply(v1, 2, zfreq2)
        else {
v1<-factor(v1[!is.na(v1)])
n2<-sum(v1=="co")
n2<-ifelse(n2>0,n2,sum(v1==T))
N<-sum(!is.na(v1))
temp<-c(nzung=n2,N=N,percent=round(n2*100/N,1))
print(temp)
return(temp)
}
}
summary(bcgscar=="co"~bcgscar+sex+agegrp+school+mbcont+pbcont, data=data1[data1$caco=="benh",],method="response",fun=zfreq2)
summary(bcgscar=="co"~bcgscar+sex+agegrp+school+mbcont+pbcont, data=data1[data1$caco=="chung",],method="response",fun=zfreq2)


#===============================================================================

#============================================================================
#============================================================================
data1<-stata.get("chilumba2.dta")
#[1] "id"      "caco"    "agegrp"  "sex"     "bcgscar" "school"  "mbcont"  "pbcont"
#============================================================================

#============================================================================
label(data1$bcgscar)<-"scar BCG"
label(data1$sex)<-"Sex"

ztable("caco","bcgscar+sex+agegrp+school+mbcont+pbcont")
ztable("caco","bcgscar+sex+agegrp+school+mbcont+pbcont")
v1<-data1(