
^BRAZILIAN CASE-CONTROL STUDY OF RISK FACTORS FOR INFANT 
DEATH FROM DIARRHOEA^


An attempt was made to ascertain all infant deaths from diarrhoea 
occurring over a one year period in two cities in southern Brazil, 
by means of weekly visits to all hospitals, coroners'
services and death registries in the cities.

Whenever the underlying cause of death was considered to be diarrhoea, 
a physician visited the parents or guardians to collect further 
information about the terminal illness, and data on possible
risk factors. The same data were collected for two `control' infants. 
Those chosen were the nearest neighbour aged less than 1 year, and the 
next child in the neighbourhood aged less than
6 months. This procedure was designed to provide a control group with a 
similar age and socioeconomic distribution to that of the cases.

Cases and controls with important perinatal risk factors were excluded 
from the study as follows: those with a birthweight under 1500g; twins; 
those with major malformations or cerebral palsy;
and those whose initial stay in hospital exceeded 15 days. 
Also excluded were cases and controls aged under seven days, as there 
were very few diarrhoea deaths in this age group.

During the one-year study period, data were collected on 170 cases 
together with their 340 controls.

In examining the risk associated with different infant feeding practices, care was taken to collect
a history of the feeding mode both at the time of death (variable milkfin) 
and prior to the onset of the terminal illness (variables milk to 
feedmode), to allow for the possibility that the illness
may have resulted in a change in feeding practice. 
For controls, the feeding information was collected for the same dates 
as their matched cases.


There are two files: ^diabraz2^ contains data for all 170 cases and 
their 340 matched controls (two controls per case).

^diabraz^ is a reduced dataset containing data for 86 cases with one 
matched control per case. The control is one of the two neighbourhood 
controls for that case, and is additionally matched to the case on age, 
so that their ages fall in the same broad age-group (0-2, 3-5 and 6-11 
months) and differ by no more than 3 months. The remaining 84 cases were
excluded because neither of the available controls satisfied the age 
matching criteria.

In both datasets, the mean ages of cases and controls are very similar 
(^diabraz2^: cases 4.48 months, controls 4.52 months; ^diabraz^: 
cases 4.23 months, controls 4.34 months).

Coding of files ^diabraz^ and ^diabraz2^


^set^        No of matched set (1-170)
^case^       1=case, 0=control
^age^        Age in months
^agegp^      Age group (months): 1=0-1, 2=2-3, 3=4-5, 4=6-8, 5=9-11
^agegp2^     1=0-2, 2=3-5, 3=6-11
^agegp3^     1=0-1, 2=2+
^sex^        1=male, 2=female
^bint^       Birth interval (months): 1=first born, 2=<23 mths, 
             3=24-35 mths, 4=36+ mths
^bwt^        Birth weight (kg): 1=min/2.50, 2=2.50-2.99, 3=3.00-3.49, 
             4=3.50+
^bwtgp^      1=greater or equal 3.00, 2=less than 3.00
^meduc^      Mother's education (years): 1=none, 2=1-3, 3=4-5, 4=6+
^social^     Social class: 1=underproletariat, 2=proletariat, 
             3=bourgeoisie
^water^      Piped water supply: 1=in house, 2=in plot, 3=none
^wat2^       1=in house/plot 2=none
^income^     Per capita monthly income (% of national min wage): 
             1=0-19, 2=20-39, 3=40-99, 4=100+
^house^      Type of house: 1=regular building, 2=shack
^fridge^     Availability of refrigerator: 1=yes, 2=no
^milkfin^    Type of milk drunk at time of death: 1=breast only,
             2=breast+formula, 3=breast+cows, 4=breast+formula+cows,
             5=formula only
^milk^       Type of milk at onset of illness: 1=breast only,
             2=breast+formula, 3=breast+cows, 4=formula only, 
             5=cows only
^milkgp^     1=breast only, 2=breast+other, 3=other only
^bf^         1=breastfed, 2=not breastfed
^supp^       Non-milk food supplements: 1=yes, 2=no
^feedmode^   Feeding mode: 1=exclusive BF, 2=BF+other milk, 
             3=other milk only, 4=BF+suppl, 5=BF+other+suppl, 
             6=other+suppl
^pair^       No of matched pair (1-86)(^diabraz^ only)

                        
