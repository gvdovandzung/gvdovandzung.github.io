** Demonstrate the commands in wsanova.tex
** J. R. Gleason (08Nov98)


*** OK to clear the data in memory? ***
more

* Example 1:
use histamin, clear
describe
more

* Example 1.1:
more
wsanova lhist time if group==1, id(dog)
more

* Example 1.2:
more
wsanova lhist time if group==1, id(dog) eps
more


* Example 2.1:
more
set matsize 42
wsanova lhist time, id(dog) bet(group)
more

* Example 2.2:
more
set matsize 41
wsanova lhist time if dog != 6, id(dog) bet(group) eps
more

* Matrices created by wsanova
matrix dir
more

matrix list WSAov1
matrix list WSAoV_
more

* Example 3:
tab drug depleted
more

* Example 3.1:
set matsize 61
wsanova lhist time if dog != 6, id(dog) bet(drug depl drug*depl)
more

* Example 3.2:
set matsize 33
wsanova lhist time if dog != 6, id(dog) bet(drug depl) wonly(time time*depl) eps
