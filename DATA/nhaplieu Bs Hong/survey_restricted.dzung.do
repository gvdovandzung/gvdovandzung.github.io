clear
set more 1
set memory 20m
set maxvar 10000
adopath + "E:\CDMedStat\igrowup_stata"
use "D:\DATA\nhaplieu Bs Hong\data.dta", clear
gen str60 reflib="E:\CDMedStat\igrowup_stata"
lab var reflib "Directory of reference tables"
gen str60 datalib="D:\DATA\nhaplieu Bs Hong"
lab var datalib "Directory for datafiles"
gen str30 datalab="mysurvey"
lab var datalab "Working file"

gen str6 ageunit="months"
gen str1 measure=" "
gen str1 oedema="n"
gen sw=1
igrowup_restricted reflib datalib datalab q3 t ageunit q11b q11a measure oedema sw

save "D:\DATA\nhaplieu Bs Hong\data.anthropometric.dta", replace

/*igrowup_restricted reflib datalib datalab gender agemons ageunit weight height measure oedema sw*/

