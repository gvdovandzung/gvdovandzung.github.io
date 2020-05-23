use "D:\Documentation\Meta\strepto.dta", clear
generate alive1=pop1-deaths1
generate alive0=pop0-deaths0
metan deaths1 alive1 deaths0 alive0, rr xlab(.1,1,10) label(namevar=trialnam)
//-------------------------------------------------------------

generate logor=log((deaths1/alive1)/(deaths0/alive0))
generate selogor=sqrt((1/deaths1)+(1/alive1)+(1/deaths0)+(1/alive0))



meta logor selogor, eform graph(f) cline xline(1) xlab(.1,1,10) id(trialnam) b2title(Odds ratio) print

//=======================================================================================

 use "D:\Documentation\Meta\magnes.dta", clear
generate alive1=tot1-dead1
generate alive0=tot0-dead0
metan dead1 alive1 dead0 alive0, rr xlab(.1,1,10)


//=======================================================================================

use "D:\Documentation\Meta\strepto.dta", clear
gen str21 trnamyr=trialnam+" (" + string(year)+ ")"
sort year
generate alive1=pop1-deaths1
generate alive0=pop0-deaths0

generate logor=log((deaths1/alive1)/(deaths0/alive0))
generate selogor=sqrt((1/deaths1)+(1/alive1)+(1/deaths0)+(1/alive0))

metacum logor selogor, effect(f) eform graph cline xline(1) xlab(.1,1,10) id(trnamyr) b2title(Odds ratio)

//=======================================================================================

 use "D:\Documentation\Meta\magnes.dta", clear
generate alive1=tot1-dead1
generate alive0=tot0-dead0
// option rr  perform calculations using relative risks
// xlab(.1,1,10) // label the x-axis
// label(namevar=trialnam) label the output and vertical axis of the
metan dead1 alive1 dead0 alive0, rr xlab(.1,1,10)

generate logor=log((dead1/alive1)/(dead0/alive0))
generate selogor=sqrt((1/dead1)+(1/alive1)+(1/dead0)+(1/alive0))


metainf logor selogor, eform id (trialnam) xscale(0.4(0.1)1.2)
metabias logor selogor if trial<16, graph(begg)


//=======================================================================================

use "C:\DATA\Meta_Analysis\bcgtrial.dta", clear

metan cases1 h1 cases0 h0, xlab(.1,1,10) label(namevar=trialnam)
meta logrr selogrr, eform
metareg logrr startyr latitude, wsse(selogrr)


//=======================================================================================

use "C:\DATA\Meta_Analysis\bcg_m.dta", clear

drop h1 h0 logrr selogrr yfit
gen h1=tot1-cases1
gen h0=tot0-cases0


generate logrr=log((cases1/tot1)/(cases0/tot0))
generate selogrr=sqrt((1/cases1)-(1/tot1)+(1/cases0)-(1/tot0))
save "C:\DATA\Meta_Analysis\bcg_modified.dta", replace

metan cases1 h1 cases0 h0, xlab(.1,1,10) label(namevar=trialnam)
meta logrr selogrr, eform
metareg logrr startyr latitude, wsse(selogrr)

gen yfit= .2607981-.0292475* latitude
twoway (scatter  logrr  latitude [weight=w2],  msymbol(oh) )  (line  yfit latitude)
