^THE EFFECT OF MARITAL BEREAVMENT ON MORTALITY^

The data arose originally from a survey of the physical 
and mental health, social networks and use of services of 
a cohort of 75 year olds and over belonging to a general 
practice.  An analysis of these data have already been published 
^Jagger C and Sutton CJ, Statistics in Medicine, 10, 395-404^
looking at survival over 7 years (to 1st January 1988). More 
deaths have now accrued in this cohort and the death information 
is complete up to 1st January 1990. Since some of the spouses 
were not included in the original survey, a few spouses removed 
from the area and are untraceable for death at that point.

The data can be divided into 3 groups (see variable GROUP below):
group 1 contains the 226 index-cases (113 couples) who were 
both age 75 years and over and therefore both in the initial study 
and also living as a two-person household at interview; group 2 
contains 118 index cases who had spouses below 75 years at interview 
but were again in a two-person household; and group 3 contains 55 
index-cases who were living with a spouse and another person at the 
time of interview.

The file ^brv^ contains the following variables:

^id^           Subject identifier
^couple^       Couple identifier 
^sex^          Sex  1=M, 2=F
^dob^          Date of birth
^doe^          Date of entry
^dosp^         Date of death of spouse, missing if spouse still alive
             at end of study
^dod^          Date of death, missing if still alive at end of study
^y^            Follow-up time (years)
^agein^        Age at entry
^d^            1=Died, 0=Survived
^disab^        Disability: 0=None, 1=Mild, 2=Moderate, 3=Severe
^inc^          Incontinence: 0=None, 1=Mild, 2=Moderate, 3=Severe
^health^       Perceived health status: 0=Poor
^inf^          Information/Orientation: 0 -- 1
^hyp^          Hypoglycaemics: 0=No, 1=Yes
^group^        Group 1, 2 or 3
^diu^          Diuretics: 0=No, 1=Yes

