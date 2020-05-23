display ("Phan tich gop nghien cuu betablocker va benh tim mach")
use "D:\DATA\Meta_Analysis\betablocker.dta", clear
metan deaths1 alive1 deaths0 alive0, label(namevar=trial, yearvar=year) fixedi rr
metan deaths1 alive1 deaths0 alive0, label(namevar=trial, yearvar=year) fixedi rr texts(2)
gen theta=ln( _ES)
metacum theta _seES, effect(f) eform level(95) graph xline(1) xlabel(0.64,0.8,1,1.25) title("Forest  plot")
metafunnel theta _seES
metafunnel _ES _LCI _UCI, ci

display ("Phan tich gop nghien cuu tien san giat")
use "D:\DATA\Meta_Analysis\preclampsia.dta", clear
metan a b c d, label(namevar=name) fixed rr
metan a b c d if risk==0, label(namevar=name) random rr
metan a b c d if risk==1, label(namevar=name) fixed rr
gen theta=ln( _ES)
metafunnel theta _seES
metafunnel _ES _LCI _UCI, ci

display ("Phan tich gop nghien cuu Magnesium")
use "D:\DATA\Meta_Analysis\magnes_14.dta", clear
metan dead1 alive1 dead0 alive0, label(namevar=trialnam, yearvar=year) fixedi rr
gen theta=ln( _ES)
metafunnel theta _seES
metafunnel _ES _LCI _UCI, ci
metabias theta _seES, graph(begg) gweight
metabias theta _seES, graph(egger) gweight
