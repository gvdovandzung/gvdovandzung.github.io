#delim ;
prog def inputst;
version 10.0;
/*
 Input a non-Stata data set using Stat/Transfer
 (with parameters and switches supplied by the user)
 and convert to a Stata data set in the memory,
 overwriting any existing data in the memory.
*!Author: Roger Newson
*!Date: 07 August 2008
*/

tempfile tmpdta;
stcmd `0' stata "`tmpdta'" /y;
* Check that input file exists *;
capture confirm file `"`tmpdta'"';
if _rc!=0 {;
  disp as error "Temporary datafile not created: " as result `"`tmpdta'"';
  disp as error "Stat/Transfer did not run successfully";
  error _rc;
};
disp as text "Temporary datafile created: " as result `"`tmpdta'"';
cap use `"`tmpdta'"', clear;
if _rc!=0 {;
  disp as error "Data could not be input from temporary datafile: " as result `"`tmpdta'"';
  error _rc;
};
disp as text "Data input from temporary datafile: " as result `"`tmpdta'"';

end;
