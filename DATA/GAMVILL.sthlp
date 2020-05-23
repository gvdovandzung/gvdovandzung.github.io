^CROSS-SECTIONAL SURVEY OF MALARIA MORBIDITY IN GAMBIAN VILLAGES^
                                
This survey was undertaken as part of the epidemiological evaluation of 
the Gambian National Impregnated Bednet Programme.  
The evaluation took place in five areas, and villages within each area 
were randomly allocated to receive the treatment (insecticide impregnation 
of bednets) or to remain untreated until the next year (control).  
The data are from the cross-sectional survey of children aged 1-4 years 
conducted at the end of the malaria transmission season in a sample of 
villages from each treatment group, from four of the five areas. Data
from Area 5 have been excluded to simplify the interpretation.
                                
                                
File ^gamindiv^ contains data on all the individual children in the survey, 
while file ^gamvill^ contains summary data from the 34 villages in the 
survey. 
                                
                  
Coding of file ^gamvill^:

^vid^            village identifier
^parapos^        number of children with malaria parasites
^paraneg^        number of children without malaria parasites
^nets^           percentage of bednet usage in village 
                    (from a previous survey)
^eg^             predominant ethnic group in village
                 M=Mandinka, W=Wollof, J=Jola, S=Serahuli, X=mixed
^dist ^          distance of village from river (in map units)
^group^          treatment group (1 = nets impregnated, 2 = control)
^rate^           village parasite rate (parapos/(parapos + paraneg))
^area^           area
                                
                                
                                
Note that ^eg^ and ^nets^ are variables that could have been 
recorded on individuals, but are only known here for the 
village as a whole.
                                
                                
                                
